/*
 * AE3 bridge - JS <-> SQF channel for the web desktop.
 *   JS -> SQF : A3.send(command, data)  -> alert(json) -> JSDialog -> AE3_desktop_fnc_jsRouter
 *   SQF -> JS : AE3_desktop_fnc_jsSend -> window.AE3_recv(command, payload) -> handlers here
 *
 * A3.request(command, data) returns a Promise resolved by the matching reply (correlated by
 * an auto _rid the router echoes back). A3.on(channel, cb) subscribes to pushed events.
 */
(function () {
  var handlers = {};   // channel -> [cb]
  var pending = {};    // rid -> {resolve, timer}
  var ridSeq = 1;

  // JS -> SQF transport. Arma raises the control's "JSDialog" event for A3API.SendAlert (and
  // SendConfirm) - NOT for the native window.alert(), which CEF shows/suppresses locally and never
  // delivers to SQF. Using window.alert here was why every A3.request timed out and the desktop
  // looked "logged in but dead". This matches the working os-master bridge (A3API.SendAlert).
  var hasA3 = (typeof A3API !== "undefined" && A3API && typeof A3API.SendAlert === "function");
  // Non-ASCII characters travel as \uXXXX escapes (decoded by AE3_desktop_fnc_jsUnescape).
  function asciiJSON(msg) {
    return msg.replace(/[\u0080-\uffff]/g, function (c) {
      return "\\u" + ("000" + c.charCodeAt(0).toString(16)).slice(-4);
    });
  }
  function rawSend(msg) {
    msg = asciiJSON(msg);
    if (hasA3) { A3API.SendAlert(msg); return; }
    // Plain-browser preview (no A3API): nothing to talk to; log so it can be inspected.
    console.log("[A3 offline]", msg);
  }

  function emit(channel, payload) {
    (handlers[channel] || []).slice().forEach(function (cb) {
      try { cb(payload); } catch (e) { console.error(e); }
    });
  }

  // Collapse "." and ".." segments out of a backslash path. A3API.RequestFile rejects any path
  // containing ".." ("only relative paths supported"), so links like portal -> "..\wiki\index.html"
  // must be flattened to "\z\ae3\...\wiki\index.html" before the request. Preserves a leading "\".
  function normalizePath(p) {
    var lead = (p.charAt(0) === "\\") ? "\\" : "";
    var out = [];
    p.split("\\").forEach(function (seg) {
      if (seg === "" || seg === ".") return;
      if (seg === "..") { if (out.length) out.pop(); return; }
      out.push(seg);
    });
    return lead + out.join("\\");
  }

  var A3 = {
    // Fire-and-forget command to SQF.
    send: function (command, data) {
      rawSend(JSON.stringify({ command: command, data: data === undefined ? null : data }));
    },

    // Command expecting a reply. Resolves when SQF pushes back the same command with _rid.
    request: function (command, data, timeoutMs) {
      var rid = "r" + (ridSeq++);
      var msg = JSON.stringify({ command: command, rid: rid, data: data === undefined ? null : data });
      return new Promise(function (resolve, reject) {
        pending[rid] = {
          resolve: resolve,
          timer: setTimeout(function () {
            delete pending[rid];
            reject(new Error("AE3 request timeout: " + command));
          }, timeoutMs || 8000)
        };
        rawSend(msg);
      });
    },

    on: function (channel, cb) {
      (handlers[channel] = handlers[channel] || []).push(cb);
    },

    // Subscription that ends once el leaves the DOM (window closed).
    onWhile: function (channel, el, cb) {
      var wrap = function (payload) {
        if (!el.isConnected) {
          var list = handlers[channel] || [];
          var i = list.indexOf(wrap);
          if (i >= 0) list.splice(i, 1);
          return;
        }
        cb(payload);
      };
      A3.on(channel, wrap);
    },

    // Load a UI asset (html/md/media/...) by path. CEF cannot resolve relative URLs from a PBO
    // file, so everything goes through A3API. Resolution order for a NON-absolute path:
    //   extraRoots (optional) -> this addon's PBO -> mission root.
    // Absolute paths (\z\ae3\..., \z\othermod\..., or any other loaded mod) are used as-is, so
    // other mods and mission-relative content both work.
    loadFile: function (rel, extraRoots) {
      rel = String(rel).replace(/\//g, "\\");
      if (typeof A3API === "undefined" || !A3API || !A3API.RequestFile) {
        // Plain-browser preview: fetch relatively.
        return fetch(rel.replace(/\\/g, "/")).then(function (r) { return r.text(); });
      }
      function requestOne(full) {
        full = normalizePath(full);
        return Promise.resolve(A3API.RequestFile(full)).then(function (t) {
          if (t == null || t === "") throw new Error("empty/missing: " + full);
          return t;
        });
      }
      if (rel.charAt(0) === "\\") return requestOne(rel); // absolute - this or any other mod
      var roots = (extraRoots || []).concat(window.AE3_WEB_ROOTS ||
        ["", window.AE3_WEB_ROOT || "\\z\\ae3\\addons\\desktop\\ui\\web\\"]);
      var i = 0;
      function next() {
        if (i >= roots.length) return Promise.reject(new Error("not found in any root: " + rel));
        return requestOne(roots[i++] + rel).catch(next);
      }
      return next();
    },

    // Load an image asset as a data URL for an <img>/CSS background. A3API.RequestTexture renders
    // the engine texture (paa/jpg/png, mission or mod) to a base64 PNG data URL, so arbitrary
    // images display inside the webview (above the OS surface) instead of a hidden native control.
    // The path is tried AS GIVEN first (a mission-relative "media\images\x.jpg" or an absolute mod
    // path), then the addon web root, so a mission file gets a clean attempt before the engine ever
    // sees a non-existent web-root path (which is what produced the "Unknown sampler texture type"
    // warning). The scope hint ("mod"/"mission"/"auto") just reorders those candidates.
    loadTexture: function (rel, maxRes, extraRoots, scope) {
      rel = String(rel).replace(/\//g, "\\");
      var res = maxRes || 2048;
      if (typeof A3API === "undefined" || !A3API || !A3API.RequestTexture) {
        return Promise.reject(new Error("no A3API.RequestTexture"));
      }
      function requestOne(full) {
        full = normalizePath(full);
        return Promise.resolve(A3API.RequestTexture(full, res)).then(function (t) {
          if (t == null || t === "") throw new Error("empty/missing: " + full);
          console.log("[AE3 media] RequestTexture OK:", full);
          return t;
        }, function (e) {
          console.log("[AE3 media] RequestTexture FAIL:", full, (e && e.message) || e);
          throw e;
        });
      }
      if (rel.charAt(0) === "\\") return requestOne(rel); // absolute - this or any other mod
      var web = window.AE3_WEB_ROOT || "\\z\\ae3\\addons\\desktop\\ui\\web\\";
      var roots;
      if (extraRoots && extraRoots.length) { roots = extraRoots; }
      else if (scope === "mod") { roots = [web, ""]; }     // mod-relative asset under this addon
      else { roots = ["", web]; }                          // mission/auto: bare mission path first
      var i = 0;
      function next() {
        if (i >= roots.length) return Promise.reject(new Error("not found in any root: " + rel));
        return requestOne(roots[i++] + rel).catch(next);
      }
      return next();
    },

    // Resolve any registered image source to a data URL for an <img>/CSS background, covering both
    // origins:
    //   - mod/addon assets (absolute "\z\..." or a ".paa", and engine-loadable .jpg/.png) render
    //     through A3API.RequestTexture, which returns a base64 PNG data URL.
    //   - mission-folder images that the texture sampler cannot load (e.g. a raw "media\images\x.jpg")
    //     fall back to a base64-encoded sidecar: the file at "<path>.b64" (or the path itself when it
    //     already ends in .b64) is read as text via RequestFile and wrapped in a data URL. This mirrors
    //     the proven mission-media path and works without shipping textures inside a PBO.
    loadImage: function (rel, maxRes, extraRoots, scope) {
      var self = this;
      var src = String(rel).replace(/\//g, "\\");
      scope = scope || "auto";
      function mimeFor(path) {
        var ext = (path.replace(/\.b64$/i, "").split(".").pop() || "png").toLowerCase();
        if (ext === "jpg" || ext === "jpeg") return "image/jpeg";
        if (ext === "gif") return "image/gif";
        return "image/png"; // png, paa(->png), and anything else
      }
      function fromB64() {
        var b64path = /\.b64$/i.test(src) ? src : src + ".b64";
        console.log("[AE3 media] loadImage trying b64 sidecar:", b64path);
        return self.loadFile(b64path, extraRoots).then(function (txt) {
          console.log("[AE3 media] b64 sidecar OK:", b64path);
          return "data:" + mimeFor(src) + ";base64," + String(txt).replace(/\s/g, "");
        });
      }
      function fromTexture() { return self.loadTexture(src, maxRes, extraRoots, scope); }
      console.log("[AE3 media] loadImage start:", src, "scope=" + scope);
      // A pre-encoded source skips the sampler entirely.
      if (/\.b64$/i.test(src)) return fromB64();
      // Mission-folder raster images (jpg/png/gif) ship as a base64 sidecar; the engine texture
      // sampler cannot load them on many builds and logs an "Unknown sampler texture type" warning the
      // moment it tries. Read the sidecar ONLY for those - do NOT fall back to the sampler, which would
      // spam that warning for a raw mission image that has no sidecar. Callers that have a native
      // RscPicture fallback (the image viewer) handle such images through the engine instead; a raw
      // mission raster simply cannot be a CEF wallpaper without a sidecar.
      var isAbsolute = src.charAt(0) === "\\";
      var isRaster = /\.(jpe?g|png|gif)$/i.test(src);
      if (!isAbsolute && isRaster && scope !== "mod") return fromB64();
      // Mod/addon assets (absolute \z\... paths, .paa, or scope "mod") sample cleanly, so try the
      // texture first and use a sidecar as fallback.
      return fromTexture().catch(fromB64);
    },

    // Parse a media marker file's content into {type, scope, web, path}, or null if it is not a
    // marker. Understands both the current "AE3_MEDIA|<type>|<scope>|<web>|<path>" form and the
    // legacy "AE3_MEDIA|<type>|<path>" form.
    parseMedia: function (content) {
      var s = String(content || "");
      if (s.indexOf("AE3_MEDIA|") !== 0) return null;
      var p = s.split("|");
      var type = (p[1] || "").toLowerCase();
      // Inline base64 image: "AE3_MEDIA|image|b64|<mime>|<data>". Rendered as a data URL, no path.
      if (type === "image" && (p[2] || "").toLowerCase() === "b64") {
        return { type: type, b64: true, scope: "auto", web: true, mime: p[3] || "image/png", data: p.slice(4).join("|") };
      }
      if (p.length >= 5) {
        var scope = (p[2] || "auto").toLowerCase();
        if (scope !== "mod" && scope !== "mission") scope = "auto";
        return { type: type, scope: scope, web: p[3] === "1", path: p.slice(4).join("|") };
      }
      return { type: type, scope: "auto", web: false, path: p.slice(2).join("|") };
    },

    emit: emit
  };

  // Entry point called by AE3_desktop_fnc_jsSend.
  window.AE3_recv = function (command, payload) {
    if (payload && payload._rid && pending[payload._rid]) {
      var p = pending[payload._rid];
      clearTimeout(p.timer);
      delete pending[payload._rid];
      p.resolve(payload.data !== undefined ? payload.data : payload);
      return;
    }
    emit(command, payload);
  };

  window.A3 = A3;
})();
