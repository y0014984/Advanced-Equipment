/*
 * AE3 external apps - lets other addons (Root Cyberwarfare, ...) inject launcher apps over the
 * SQF bridge. On boot the SQF side pushes "ext_apps"; each descriptor becomes a generic
 * device-list app. The app requests its device list (dev_request), renders rows with per-device
 * action buttons, and triggers actions (dev_action). Results stream back via dev_list / dev_result.
 */
(function () {
  function esc(s) { return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }
  function escAttr(s) { return esc(s).replace(/"/g, "&quot;"); }

  // Route pushed results to the interested open windows, keyed by device type.
  var listSubs = {};   // type -> fn(items)
  var resultSubs = {};  // type -> fn(res)
  A3.on("dev_list", function (p) { if (p && listSubs[p.type] != null) listSubs[p.type](p.items || []); });
  A3.on("dev_result", function (p) { if (p && resultSubs[p.type] != null) resultSubs[p.type](p); });

  // The desktop is served through the embedded browser, where localStorage can be unavailable and
  // throws on access. Fall back to an in-memory store so pins simply live for the session instead of
  // taking the whole app down.
  var memStore = {};
  function storeGet(key) {
    try { return localStorage.getItem(key); } catch (e) { return memStore[key] != null ? memStore[key] : null; }
  }
  function storeSet(key, value) {
    try { localStorage.setItem(key, value); } catch (e) { memStore[key] = value; }
  }

  function iconMarkup(path) {
    return '<span class="app-img" data-icon-path="' + escAttr(path) + '"></span>';
  }

  function hydrateAppImages(root) {
    root = root || document;
    if (!window.A3 || typeof A3.loadImage !== "function") return;
    Array.prototype.slice.call(root.querySelectorAll(".app-img[data-icon-path]")).forEach(function (node) {
      var path = node.getAttribute("data-icon-path");
      if (!path || node.dataset.loaded === "1") return;
      node.dataset.loaded = "1";
      A3.loadImage(path, 128, [], "mod").then(function (src) {
        node.style.backgroundImage = 'url("' + src + '")';
      }).catch(function () { node.classList.add("missing"); });
    });
  }
  window.AE3_hydrateAppImages = hydrateAppImages;

  // Prefer a web-loadable image path, then a named SVG icon, then a glyph string.
  function glyphFor(desc) {
    var iconPath = desc.iconPath || (desc.extra && desc.extra.iconPath);
    if (iconPath) return iconMarkup(iconPath);
    var iconName = desc.icon || (desc.extra && desc.extra.icon);
    if (window.Icons && iconName && Icons[iconName]) return Icons[iconName];
    if (desc.glyph) return desc.glyph;
    return window.Icons ? Icons.device : "🔌";
  }

  function makeDeviceApp(desc) {
    var extra = desc.extra || {};
    var actions = extra.actions || [];
    var glyph = glyphFor(desc);
    return {
      id: desc.id, title: desc.title, glyph: glyph,
      kind: "deviceList", width: 620, height: 440,
      showOnDesktop: !!extra.showOnDesktop, showInDock: !!extra.showInDock,
      showInMenu: extra.showInMenu !== false, singleton: true,
      menu: extra.menu || "Tools", external: true,
      render: function (body, win) {
        body.innerHTML =
          '<div class="toolbar"><span class="muted" style="flex:1">' + esc(desc.title) +
              ' <span class="devcount"></span></span>' +
            (extra.globalActions ? '<span class="globals"></span>' : '') +
            (extra.filters ? '<button class="btn filters">Filters</button>' : '') +
            '<button class="btn refresh">&#8635;</button></div>' +
          (extra.filters ?
            '<div class="filterbar" style="display:none;gap:6px;padding:6px 12px;align-items:center">' +
              '<input class="input fgrid" placeholder="Grid reference" style="flex:1">' +
              '<input class="input fdist" type="number" min="0" placeholder="Max distance (m)" style="width:150px">' +
              '<button class="btn fapply">Apply</button><button class="btn fclear">Clear</button></div>' : '') +
          '<ul class="list devs"><li class="muted pad">Loading...</li></ul>' +
          '<div class="dev-status" style="min-height:22px;padding:8px 12px;font-weight:600"></div>';
        var devs = body.querySelector(".devs");
        var status = body.querySelector(".dev-status");
        var countLabel = body.querySelector(".devcount");
        // The rows the filter currently leaves on screen. Global actions act on exactly these, so what a
        // button labelled "All Off" switches is what the operator can see, not the whole network.
        var visibleItems = [];
        // filterOrigin holds the world position of the grid reference once the engine has resolved it.
        // With both a grid and a distance set, the distance is measured from that grid square instead
        // of from the player, so the pair reads as "everything within N metres of this grid".
        var allItems = [], filterGrid = "", filterDistance = 0, filterOrigin = null;
        var pinKey = "rootcw_pins_" + extra.type;
        var pins = [];
        try { pins = JSON.parse(storeGet(pinKey) || "[]") || []; } catch (e) { pins = []; }

        // Prominent, clearly-coloured result feedback (Root_CW general #2): success green, failure
        // orange-red, so low-battery / overload / not-allowed messages can't be missed.
        function setStatus(msg, ok) {
          status.textContent = msg || "";
          status.style.color = (ok === false) ? "#ff7a4d" : (ok === true ? "var(--good)" : "var(--muted)");
        }

        // Whole-app global actions (e.g. Lights: All On / All Off, Root_CW Lights #1).
        var glWrap = body.querySelector(".globals");
        if (glWrap && extra.globalActions) {
          extra.globalActions.forEach(function (a) {
            var b = document.createElement("button"); b.className = "btn"; b.textContent = a.label; b.style.marginLeft = "6px";
            b.addEventListener("click", function () {
              // Download flow (Root_CW Network Scanner export): let the user pick a save location
              // instead of sending straight to a hardcoded server-side default.
              if (a.flow === "download" && typeof window.AE3_pickFile === "function") {
                window.AE3_pickFile("save", { title: "Save exported file", start: (window.AE3_HOME || "/root"), filename: a.label || "export" }).then(function (savePath) {
                  if (!savePath) return;
                  A3.send("dev_action", { app: desc.id, type: extra.type, id: "", action: a.id, path: "", savePath: savePath });
                  setStatus(a.label + "...");
                });
                return;
              }
              // Prompt flow: the action needs a value the list cannot supply (e.g. the identifier of
              // a device this app does not list). The typed text travels as promptValue; cancelling
              // sends nothing.
              if (a.flow === "prompt") {
                Modal.prompt(a.promptTitle || a.label, "").then(function (value) {
                  if (value === null) return;
                  value = String(value).trim();
                  if (!value) return;
                  A3.send("dev_action", { app: desc.id, type: extra.type, id: "", action: a.id, path: "", promptValue: value });
                  setStatus(a.label + "...");
                });
                return;
              }
              A3.send("dev_action", {
                app: desc.id, type: extra.type, id: "", action: a.id, path: "",
                ids: visibleItems.map(function (d) { return d.id; }),
                filtered: visibleItems.length !== allItems.length
              });
              setStatus(a.label + "...");
            });
            glWrap.appendChild(b);
          });
        }

        // Perform a single action (confirm / slider / download / plain send). Shared by top-level
        // buttons and submenu children so every flow behaves identically (Drones/Vehicles #1).
        function runAction(d, a, sub) {
          // Slider flow: collect the value first, then confirm battery use before sending it.
          if (a.slider && typeof Modal !== "undefined" && typeof Modal.slider === "function") {
            Modal.slider(a.label + (d.label ? (" - " + d.label) : ""), a.min, a.max, a.value, a.step, a.unit, a.options || {}).then(function (v) {
              if (v == null) return;
              var value = (typeof v === "object") ? v.value : v;
              var payload = { app: desc.id, type: extra.type, id: d.id, action: a.id, sub: sub || "", path: d.path || "", value: value };
              if (typeof v === "object" && v.lock !== undefined) payload.lock = !!v.lock;
              var send = function () {
                A3.send("dev_action", payload);
                setStatus(a.label + " → " + value + (a.unit || "") + "...");
              };
              if (a.confirm && a.confirm !== "" && typeof Modal !== "undefined") {
                Modal.confirm(a.label, a.confirm).then(function (ok) { if (ok) send(); });
              } else {
                send();
              }
            });
            return;
          }
          // Optional confirmation for non-slider actions.
          if (a.confirm && a.confirm !== "" && typeof Modal !== "undefined") {
            Modal.confirm(a.label, a.confirm).then(function (ok) {
              if (ok) A3.send("dev_action", { app: desc.id, type: extra.type, id: d.id, action: a.id, sub: sub || "", path: d.path || "" });
              if (ok) setStatus(a.label + "...");
            });
            return;
          }
          // Download flow (Databases #5): pick a save location, run a progress bar for the configured
          // download time, then perform the action with the chosen path.
          if (a.flow === "download" && typeof window.AE3_pickFile === "function") {
            window.AE3_pickFile("save", { title: "Save downloaded file", start: (window.AE3_HOME || "/root"), filename: (d.label || "download") }).then(function (savePath) {
              if (!savePath) return;
              runProgress(d.downloadTime || 0, function () {
                A3.send("dev_action", { app: desc.id, type: extra.type, id: d.id, action: a.id, sub: sub || "", path: d.path || "", savePath: savePath });
              });
            });
            return;
          }
          A3.send("dev_action", { app: desc.id, type: extra.type, id: d.id, action: a.id, sub: sub || "", path: d.path || "" });
          setStatus(a.label + "...");
        }

        function actionButton(d, a, sub) {
          var b = document.createElement("button");
          b.className = "btn" + (a.danger ? " accent" : ""); b.textContent = a.label; b.style.marginLeft = "6px";
          b.addEventListener("click", function () {
            // Submenu (Drones "Change Drone Side", grouped Vehicle controls #1): open a popup of child
            // actions; each child runs the normal confirm/slider/send flow via runAction.
            if (a.submenu && a.submenu.length && typeof window.AE3_ctxMenu === "function") {
              var r = b.getBoundingClientRect();
              window.AE3_ctxMenu(r.left, r.bottom, a.submenu.map(function (ca) {
                return { label: ca.label, action: function () { runAction(d, ca, sub); } };
              }));
              return;
            }
            runAction(d, a, sub);
          });
          return b;
        }

        // Animated progress bar in the status area over the given number of seconds.
        function runProgress(seconds, done) {
          var secs = Number(seconds) || 0;
          if (secs <= 0) { setStatus("Downloading..."); done(); return; }
          var start = Date.now(); var total = secs * 1000;
          status.innerHTML = '<div style="background:#2b2b2b;border-radius:6px;overflow:hidden;height:14px;width:200px;display:inline-block;vertical-align:middle"><div class="dlbar" style="height:100%;width:0;background:var(--accent)"></div></div> <span class="dlpct">0%</span>';
          var bar = status.querySelector(".dlbar"); var pct = status.querySelector(".dlpct");
          var iv = setInterval(function () {
            var p = Math.min(1, (Date.now() - start) / total);
            if (bar) bar.style.width = Math.round(p * 100) + "%";
            if (pct) pct.textContent = Math.round(p * 100) + "%";
            if (p >= 1) { clearInterval(iv); done(); }
          }, 100);
        }

        function render(items) {
          allItems = items;
          items = items.filter(function (d) {
            // Grid + distance together: keep only what lies within the radius of the named grid square.
            if (filterOrigin && filterDistance) {
              var p = d.pos;
              if (!p || p.length < 2) return false;
              var dx = Number(p[0]) - filterOrigin[0], dy = Number(p[1]) - filterOrigin[1];
              return Math.sqrt(dx * dx + dy * dy) <= filterDistance;
            }
            var gridOk = !filterGrid || String(d.grid || "").toLowerCase().indexOf(filterGrid) === 0;
            var distOk = !filterDistance || (Number(d.distance) >= 0 && Number(d.distance) <= filterDistance);
            return gridOk && distOk;
          }).sort(function (a, b) { return (pins.indexOf(String(b.id)) >= 0) - (pins.indexOf(String(a.id)) >= 0); });
          visibleItems = items;
          // How much of the network the operator is looking at: the rows on screen against everything the
          // laptop can reach, so a filter that hides devices says so rather than looking like an empty net.
          if (countLabel) {
            countLabel.textContent = (items.length === allItems.length)
              ? ("(" + allItems.length + (allItems.length === 1 ? " device)" : " devices)"))
              : ("(showing " + items.length + " of " + allItems.length + ")");
          }
          devs.innerHTML = "";
          if (!items.length) { devs.innerHTML = '<li class="muted pad">No devices</li>'; return; }
          items.forEach(function (d) {
            var li = document.createElement("li");
            li.style.flexDirection = "column"; li.style.alignItems = "stretch";
            var statusHtml = (d.status != null && d.status !== "") ? ' <span class="muted">[' + esc(d.status) + ']</span>' : "";
            // Grid + clickable map link (Root_CW shared #0f), shown only when the backend provides a
            // position (gated server-side by "Allow Location View"; GPS only when tracked).
            var gridHtml = (d.grid != null && d.grid !== "") ? ' <span class="muted" style="font-size:12px">&#128205; ' + esc(d.grid) + '</span>' : "";
            var top = document.createElement("div");
            top.style.display = "flex"; top.style.alignItems = "center"; top.style.width = "100%";
            // Root_CW: an in-progress network scan renders an animated radar sweep instead of the app icon.
            var isScanning = (d.label === "Scanning network");
            if (isScanning && !document.getElementById("rootcw-radar-style")) {
              var st = document.createElement("style"); st.id = "rootcw-radar-style";
              st.textContent = "@keyframes rootcwSpin{to{transform:rotate(360deg)}}.rootcw-radar{display:inline-block;width:16px;height:16px;margin-right:8px;border:2px solid #8ce10b;border-top-color:transparent;border-radius:50%;animation:rootcwSpin .8s linear infinite;vertical-align:middle}";
              document.head.appendChild(st);
            }
            var icoHtml = isScanning ? '<span class="rootcw-radar"></span>' : ('<span class="ico">' + glyph + '</span>');
            top.innerHTML = icoHtml + '<span style="flex:1">' + esc(d.label || d.name || ("#" + d.id)) + statusHtml + gridHtml + "</span>";
            if (extra.filters) {
              var pb = document.createElement("button"); pb.className = "btn"; pb.textContent = pins.indexOf(String(d.id)) >= 0 ? "Unpin" : "Pin"; pb.style.marginLeft = "6px";
              pb.addEventListener("click", function () { var i = pins.indexOf(String(d.id)); if (i >= 0) pins.splice(i, 1); else pins.push(String(d.id)); storeSet(pinKey, JSON.stringify(pins)); render(allItems); });
              top.appendChild(pb);
            }
            if (d.pos && d.pos.length >= 2) {
              var mb = document.createElement("button"); mb.className = "btn"; mb.textContent = "Map"; mb.style.marginLeft = "6px";
              mb.addEventListener("click", function () { window.AE3_openMap(d.pos, d.mapLabel !== undefined ? d.mapLabel : (d.label || ("#" + d.id)), d.mapMarker); });
              top.appendChild(mb);
            }
            // Per-device action buttons (use d.actions override when non-empty, else the app default).
            ((d.actions && d.actions.length) ? d.actions : actions).forEach(function (a) { top.appendChild(actionButton(d, a)); });
            li.appendChild(top);

            // Optional key/value details (vehicle fuel/battery/engine/alarm/brake, Root_CW Vehicles #1).
            if (d.details && d.details.length) {
              var det = document.createElement("div");
              det.className = "muted"; det.style.cssText = "font-size:12px;margin:4px 0 2px 26px;display:flex;flex-wrap:wrap;gap:10px";
              d.details.forEach(function (kv) { det.innerHTML += '<span>' + esc(kv[0]) + ": <b style='color:var(--text)'>" + esc(String(kv[1])) + "</b></span>"; });
              li.appendChild(det);
            }
            // Optional sub-items with their own actions (per-door lock/unlock, Root_CW Doors #2).
            if (d.children && d.children.length) {
              var wrap = document.createElement("div");
              wrap.style.cssText = "margin:4px 0 2px 26px;display:none;flex-direction:column;gap:4px";
              d.children.forEach(function (c) {
                var row = document.createElement("div"); row.style.cssText = "display:flex;align-items:center;font-size:12px";
                row.innerHTML = '<span style="flex:1">' + esc(c.label) + (c.status ? ' <span class="muted">[' + esc(c.status) + ']</span>' : "") + "</span>";
                (c.actions || []).forEach(function (a) { row.appendChild(actionButton(d, a, c.id)); });
                wrap.appendChild(row);
              });
              var toggle = document.createElement("button");
              toggle.className = "btn"; toggle.textContent = "Doors (" + d.children.length + ")"; toggle.style.cssText = "margin:4px 0 0 26px;align-self:flex-start";
              toggle.addEventListener("click", function () { wrap.style.display = wrap.style.display === "none" ? "flex" : "none"; });
              li.appendChild(toggle); li.appendChild(wrap);
            }
            devs.appendChild(li);
          });
        }
        listSubs[extra.type] = render;

        // Filters live in an inline row inside the app: the embedded browser never services
        // window.prompt, so a dialog-based filter would silently do nothing.
        var filterButton = body.querySelector(".filters");
        var filterBar = body.querySelector(".filterbar");
        if (filterButton && filterBar) {
          var gridInput = filterBar.querySelector(".fgrid");
          var distInput = filterBar.querySelector(".fdist");
          filterButton.addEventListener("click", function () {
            filterBar.style.display = filterBar.style.display === "none" ? "flex" : "none";
          });
          filterBar.querySelector(".fapply").addEventListener("click", function () {
            filterGrid = String(gridInput.value || "").trim().toLowerCase();
            filterDistance = Number(distInput.value) || 0;
            filterOrigin = null;
            // Only the engine can turn a grid reference into a world position, and it is only needed
            // when a radius is given too - a grid on its own still matches by grid label.
            if (filterGrid && filterDistance) {
              A3.request("grid_pos", { grid: filterGrid }).then(function (res) {
                filterOrigin = (res && res.ok && res.pos && res.pos.length >= 2) ? res.pos : null;
                render(allItems);
              }).catch(function () { render(allItems); });
              return;
            }
            render(allItems);
          });
          filterBar.querySelector(".fclear").addEventListener("click", function () {
            gridInput.value = ""; distInput.value = "";
            filterGrid = ""; filterDistance = 0; filterOrigin = null;
            render(allItems);
          });
        }
        resultSubs[extra.type] = function (r) {
          setStatus(r.msg || (r.ok ? "OK" : "Failed"), r.ok);
          // Also raise a prominent toast so blocked/failed actions (low battery, overload not allowed,
          // ...) can't be missed in the small inline status line (Root_CW general #1).
          if (typeof window.AE3_toast === "function") {
            window.AE3_toast(r.msg || (r.ok ? "Done" : "Action failed"), r.ok ? "ok" : "error");
          }
          // Downloaded file: offer to open/read it straight from the app (Databases #5).
          if (r.ok && r.path && r.path !== "") {
            var ob = document.createElement("button");
            ob.className = "btn"; ob.textContent = "Open downloaded file"; ob.style.marginLeft = "10px";
            ob.addEventListener("click", function () { Apps.launch("notepad", { path: r.path }); });
            status.appendChild(ob);
          }
          if (r.ok) setTimeout(request, 300);
        };
        function request() { devs.innerHTML = '<li class="muted pad">Loading...</li>'; A3.send("dev_request", { type: extra.type }); }
        body.querySelector(".refresh").addEventListener("click", request);
        win.app.onClose = function () { delete listSubs[extra.type]; delete resultSubs[extra.type]; };
        request();
      }
    };
  }


  var scriptLoads = {};
  function loadExternalScript(path) {
    if (!path) return Promise.resolve();
    if (scriptLoads[path]) return scriptLoads[path];
    scriptLoads[path] = Promise.resolve(A3API.RequestFile(String(path).replace(/\//g, "\\"))).then(function (text) {
      if (text == null || text === "") throw new Error("missing external app script: " + path);
      var node = document.createElement("script");
      node.text = text;
      document.head.appendChild(node);
    });
    return scriptLoads[path];
  }

  function makeScriptApp(desc) {
    var extra = desc.extra || {};
    return loadExternalScript(extra.scriptPath).then(function () {
      var factory = extra.factory && window[extra.factory];
      if (typeof factory !== "function") throw new Error("missing external app factory: " + extra.factory);
      return factory(desc);
    });
  }


  function makeLauncherApp(desc) {
    var extra = desc.extra || {};
    var glyph = glyphFor(desc);
    var launchApps = extra.launchApps || [];
    return {
      id: desc.id, title: desc.title, glyph: glyph,
      kind: "launcher", width: extra.width || 430, height: extra.height || 330,
      showOnDesktop: !!extra.showOnDesktop, showInDock: !!extra.showInDock,
      showInMenu: extra.showInMenu !== false, singleton: true,
      menu: extra.menu || "Tools", external: true,
      render: function (body) {
        body.innerHTML =
          '<div class="toolbar"><span class="muted" style="flex:1">' + esc(extra.subtitle || desc.title) + '</span></div>' +
          '<ul class="list launcher-list"></ul>' +
          '<div class="dev-status" style="min-height:22px;padding:8px 12px;font-weight:600"></div>';
        var list = body.querySelector(".launcher-list");
        var status = body.querySelector(".dev-status");
        function setStatus(msg, ok) {
          status.textContent = msg || "";
          status.style.color = (ok === false) ? "#ff7a4d" : (ok === true ? "var(--good)" : "var(--muted)");
        }
        if (extra.openCommand) {
          A3.request(extra.openCommand, { app: desc.id }).then(function (res) {
            if (res && res.ok === false) setStatus("Unavailable", false);
          }).catch(function () {});
        }
        var visible = launchApps.filter(function (entry) {
          var id = Array.isArray(entry) ? entry[0] : entry.id;
          return !!Apps.get(id);
        });
        if (!visible.length) {
          list.innerHTML = '<li class="muted pad">No tools available</li>';
          return;
        }
        visible.forEach(function (entry) {
          var id = Array.isArray(entry) ? entry[0] : entry.id;
          var label = Array.isArray(entry) ? (entry[1] || id) : (entry.label || id);
          var app = Apps.get(id);
          var li = document.createElement("li");
          li.innerHTML = '<span class="ico">' + ((app && app.glyph) || glyph) + '</span><span style="flex:1">' + esc(label) + '</span>';
          var b = document.createElement("button");
          b.className = "btn"; b.textContent = "Open"; b.style.marginLeft = "6px";
          b.addEventListener("click", function () { Apps.launch(id); setStatus(label + " opened.", true); });
          li.appendChild(b);
          list.appendChild(li);
        });
      }
    };
  }

  A3.on("ext_apps", function (list) {
    list = list || [];
    console.log("[AE3] ext_apps received:", list.length, "app(s)");
    var incoming = {};
    list.forEach(function (desc) { incoming[desc.id] = true; });
    Apps.all().slice().forEach(function (app) {
      if (app.external && !incoming[app.id]) Apps.unregister(app.id);
    });
    list.forEach(function (desc) {
      if (desc.kind === "deviceList") Apps.register(makeDeviceApp(desc));
      else if (desc.kind === "launcher") Apps.register(makeLauncherApp(desc));
      else if (desc.kind === "script") {
        makeScriptApp(desc).then(function (app) {
          Apps.register(app);
          if (window.Desktop) Desktop.refresh();
          setTimeout(function () { hydrateAppImages(document); }, 0);
        }).catch(function (e) { console.error(e); });
      }
    });
    if (window.Desktop) Desktop.refresh();
    setTimeout(function () { hydrateAppImages(document); }, 0);
  });
})();
