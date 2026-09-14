/*
 * AE3 desktop shell: top bar (Applications menu, taskbar, centred clock, tray), left dock, fixed
 * desktop icons, app registry. Apps register via Apps.register({id, title, glyph, render, ...}); the
 * shell renders the launcher menu + taskbar + desktop and routes launches through the window manager.
 */
(function () {
  var registry = [];

  var Apps = {
    register: function (app) {
      var idx = registry.findIndex(function (a) { return a.id === app.id; });
      if (idx >= 0) registry[idx] = app;
      else registry.push(app);
    },
    unregister: function (id) {
      var app = Apps.get(id);
      if (!app) return;
      if (window.WM && typeof WM.closeApp === "function") WM.closeApp(id);
      registry = registry.filter(function (a) { return a.id !== id; });
    },
    all: function () { return registry; },
    get: function (id) { return registry.filter(function (a) { return a.id === id; })[0]; },
    launch: function (id, args) {
      var app = Apps.get(id);
      if (!app) return;
      // Action apps (e.g. "Terminal" switching to the CLI) run a one-shot handler instead of
      // opening a window.
      if (typeof app.action === "function") return app.action(args);
      return WM.open(app, args);
    }
  };

  // Applications-menu category for built-in apps. Ext apps (Root Cyberwarfare) carry their own
  // app.menu (a "Parent/Child" path under "Tools"). "/" nests submenus. Apps absent here fall back to
  // "Other". CATEGORY_ORDER fixes the category sequence; APP_ORDER fixes the within-category order.
  var CATEGORY = {
    terminal: "System & Core Utilities",
    settings: "System & Core Utilities", network: "System & Core Utilities",
    ping: "System & Core Utilities", ssh: "System & Core Utilities", about: "System & Core Utilities",
    notepad: "Productivity & Files", calculator: "Productivity & Files", calendar: "Productivity & Files",
    files: "Productivity & Files", recyclebin: "Productivity & Files", media: "Productivity & Files",
    browser: "Communication & Web", mail: "Communication & Web", messenger: "Communication & Web", map: "Communication & Web",
    snake: "Games & Entertainment"
  };
  // Root Cyberwarfare apps carry app.menu = "Hacking Tools" (set in fn_gui_registerApps.sqf), which is
  // the last category here. My Computer is intentionally not menu-listed (it lives on the desktop/dock).
  var CATEGORY_ORDER = ["System & Core Utilities", "Productivity & Files", "Communication & Web", "Games & Entertainment", "Hacking Tools"];
  var APP_ORDER = ["terminal", "settings", "network", "ping", "ssh", "about",
    "notepad", "calculator", "calendar", "files", "recyclebin", "media",
    "browser", "mail", "messenger", "map", "snake"];
  function appRank(app) { var i = APP_ORDER.indexOf(app.id); return i < 0 ? 999 : i; }

  // Fixed system icons that always sit on the desktop (like Ubuntu's Home/Trash). "My Computer" is
  // the computer-management app; "File Explorer" opens the plain Files browser; Recycle Bin
  // opens the trash. Everything else on the desktop is loaded dynamically from the user's
  // ~/Desktop folder by loadUserDesktop().
  var DESKTOP_ICONS = [
    { label: "My Computer", glyph: function () { return Icons.computer || Icons.files; }, app: "mycomputer" },
    { label: "File Explorer", glyph: function () { return Icons.files; }, app: "files", args: { path: "/home" } },
    { label: "Recycle Bin", glyph: function () { return Icons.trash || Icons.files; }, app: "recyclebin" }
  ];
  // Resolved on login from sysinfo. The desktop surface mirrors this folder.
  window.AE3_HOME = null;

  function el(tag, cls, html) {
    var e = document.createElement(tag);
    if (cls) e.className = cls;
    if (html != null) e.innerHTML = html;
    return e;
  }
  function joinPath(dir, name) { return (dir.replace(/\/+$/, "") + "/" + name).replace(/\/+/g, "/"); }
  function desktopDir() { return ((window.AE3_HOME || "/root") + "/Desktop").replace(/\/+/g, "/"); }

  // ---------------- Reusable right-click context menu ----------------
  // items: array of { label, action, disabled } or { sep:true }. Shared by the desktop surface and
  // the Files app. window.AE3_clipboard holds the pending cut/copy ({ path, name, op }).
  window.AE3_clipboard = null;
  window.AE3_ctxMenu = function (x, y, items) {
    var ex = document.getElementById("ctxmenu"); if (ex) ex.remove();
    var m = el("div", "ctx-menu"); m.id = "ctxmenu";
    items.forEach(function (it) {
      if (it.sep) { m.appendChild(el("div", "ctx-sep")); return; }
      var row = el("div", "ctx-item" + (it.disabled ? " disabled" : ""), it.label);
      if (!it.disabled) row.addEventListener("click", function () { m.remove(); it.action(); });
      m.appendChild(row);
    });
    document.body.appendChild(m);
    // Keep the menu on-screen.
    var r = m.getBoundingClientRect();
    m.style.left = Math.min(x, window.innerWidth - r.width - 4) + "px";
    m.style.top = Math.min(y, window.innerHeight - r.height - 4) + "px";
    setTimeout(function () {
      document.addEventListener("mousedown", function close(ev) {
        if (!m.contains(ev.target)) { m.remove(); document.removeEventListener("mousedown", close); }
      });
    }, 0);
  };

  // ---------------- Toast notifications ----------------
  // Prominent, top-centre, colour-coded transient messages so action feedback (blocked by low
  // battery, overload not allowed, success, ...) can't be missed in a small inline status line.
  // kind: "ok" | "warn" | "error" (anything else = neutral). Auto-dismisses; toasts stack.
  window.AE3_toast = function (msg, kind) {
    if (!msg) return;
    var host = document.getElementById("toasts");
    if (!host) { host = el("div"); host.id = "toasts"; document.body.appendChild(host); }
    var t = el("div", "toast " + (kind || "info"));
    var ic = (kind === "ok") ? "&#10003;" : (kind === "error") ? "&#10005;" : (kind === "warn") ? "&#9888;" : "&#8505;";
    t.innerHTML = '<span class="t-ic">' + ic + '</span><span class="t-msg"></span>';
    t.querySelector(".t-msg").textContent = msg; // textContent: never inject markup
    host.appendChild(t);
    requestAnimationFrame(function () { t.classList.add("show"); });
    setTimeout(function () { t.classList.remove("show"); setTimeout(function () { t.remove(); }, 250); }, 4200);
  };

  // ---------------- OS clipboard ----------------
  // Copies text to the machine's real clipboard so it can be pasted outside the game. This runs in
  // the browser control on the player's own machine; the copyToClipboard script command cannot be
  // used because it is restricted to the server, where the text would be of no use to anyone.
  // Three tiers, because the embedded browser does not always allow a programmatic clipboard write:
  // the async clipboard API, the execCommand fallback (works without a secure context, needs the
  // user gesture that every caller already has), and finally a dialog with the text preselected so
  // the player can copy it by hand.
  window.AE3_copyText = function (text, label) {
    text = String(text == null ? "" : text);
    if (!text) return;
    var what = label || "Text";

    function done() { window.AE3_toast(what + " copied to clipboard.", "ok"); }

    function viaExecCommand() {
      var ta = el("textarea");
      ta.value = text;
      ta.setAttribute("readonly", "readonly");
      ta.style.cssText = "position:fixed;top:-1000px;left:-1000px;opacity:0;";
      document.body.appendChild(ta);
      var ok = false;
      try {
        ta.select();
        ta.setSelectionRange(0, text.length);
        ok = document.execCommand("copy");
      } catch (e) { ok = false; }
      ta.remove();
      return ok;
    }

    // Last resort: show the text so it can be copied manually with Ctrl+C.
    function manual() {
      var ov = el("div");
      ov.style.cssText = "position:fixed;inset:0;z-index:5000;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,0.45);";
      var box = el("div", "window");
      box.style.cssText = "position:relative;min-width:420px;max-width:80%;";
      box.innerHTML =
        '<div class="titlebar"><span class="title">Copy ' + what + '</span></div>' +
        '<div class="pad"><p class="muted">Press Ctrl+C to copy, then close this dialog.</p>' +
        '<textarea class="input cp-text" rows="10" style="width:100%"></textarea></div>' +
        '<div class="pad" style="display:flex;justify-content:flex-end"><button class="btn accent cp-close">Close</button></div>';
      ov.appendChild(box);
      document.body.appendChild(ov);
      var ta = box.querySelector(".cp-text");
      ta.value = text;
      ta.focus();
      ta.select();
      box.querySelector(".cp-close").addEventListener("click", function () { ov.remove(); });
    }

    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(done, function () {
        if (viaExecCommand()) { done(); } else { manual(); }
      });
      return;
    }
    if (viaExecCommand()) { done(); } else { manual(); }
  };

  // ---------------- Left dock (quick launch) ----------------
  function buildDock() {
    var dock = document.getElementById("dock");
    dock.innerHTML = "";
    registry.filter(function (a) { return a.showInDock; }).forEach(function (app) {
      var item = el("div", "dock-item", '<span>' + (app.glyph || "") + '</span><span class="tip">' + app.title + "</span>");
      item.dataset.app = app.id;
      item.addEventListener("click", function () { Apps.launch(app.id); });
      dock.appendChild(item);
    });
  }

  // ---------------- Desktop icons (fixed system + dynamic ~/Desktop) ----------------
  function makeIcon(desk, label, glyph, onOpen, opts) {
    opts = opts || {};
    var icon = el("div", "desktop-icon", '<div class="glyph">' + (glyph || "") + '</div><div class="label">' + label + "</div>");
    icon.addEventListener("dblclick", onOpen);
    icon.addEventListener("click", function () {
      desk.querySelectorAll(".desktop-icon").forEach(function (n) { n.classList.remove("sel"); });
      icon.classList.add("sel");
    });
    if (opts.path) {
      icon.setAttribute("draggable", "true");
      icon.addEventListener("dragstart", function (e) {
        e.dataTransfer.setData("text/plain", opts.path);
        window.AE3_desktopDrag = { path: opts.path, name: opts.name || label };
      });
      icon.addEventListener("contextmenu", function (e) {
        e.preventDefault(); e.stopPropagation();
        desk.querySelectorAll(".desktop-icon").forEach(function (n) { n.classList.remove("sel"); });
        icon.classList.add("sel");
        desktopEntryMenu(e.clientX, e.clientY, opts);
      });
    }
    if (opts.dirPath) {
      icon.addEventListener("dragover", function (e) { if (window.AE3_desktopDrag) e.preventDefault(); });
      icon.addEventListener("drop", function (e) {
        e.preventDefault();
        var drag = window.AE3_desktopDrag;
        if (!drag || drag.path === opts.dirPath) return;
        A3.request("fs_move", { path: drag.path, dest: joinPath(opts.dirPath, drag.name) }).then(function () { Desktop.refresh(); });
      });
    }
    if (opts.trash) {
      icon.addEventListener("dragover", function (e) { if (window.AE3_desktopDrag) e.preventDefault(); });
      icon.addEventListener("drop", function (e) {
        e.preventDefault();
        var drag = window.AE3_desktopDrag;
        if (!drag) return;
        A3.request("fs_delete", { path: drag.path }).then(function () { Desktop.refresh(); });
      });
    }
    desk.appendChild(icon);
    return icon;
  }

  function pasteTo(destDir) {
    var cb = window.AE3_clipboard;
    if (!cb) return;
    A3.request(cb.op === "cut" ? "fs_move" : "fs_copy", { path: cb.path, dest: joinPath(destDir, cb.name) }).then(function (r) {
      if (r && r.error && r.error !== "") { Modal.alert("Paste", "Could not paste here."); return; }
      if (cb.op === "cut") window.AE3_clipboard = null;
      Desktop.refresh();
    });
  }

  function deleteDesktopEntry(path) {
    A3.request("fs_delete", { path: path }).then(function (r) {
      if (r && r.error && r.error !== "") { Modal.alert("Delete", "Permission denied."); return; }
      Desktop.refresh();
    });
  }

  function desktopEntryMenu(x, y, opts) {
    window.AE3_ctxMenu(x, y, [
      { label: "Open", action: opts.open },
      { sep: true },
      { label: "Cut", action: function () { window.AE3_clipboard = { path: opts.path, name: opts.name, op: "cut" }; } },
      { label: "Copy", action: function () { window.AE3_clipboard = { path: opts.path, name: opts.name, op: "copy" }; } },
      { label: "Paste", disabled: !window.AE3_clipboard || !opts.dirPath, action: function () { pasteTo(opts.dirPath); } },
      { sep: true },
      { label: "Delete", action: function () {
        Modal.confirm("Delete", "Delete '" + opts.name + "'?").then(function (ok) { if (ok) deleteDesktopEntry(opts.path); });
      } },
      { sep: true },
      { label: "Properties", action: function () {
        if (window.AE3_showProperties) window.AE3_showProperties(opts.path, { name: opts.name, dir: !!opts.dirPath }, function () { Desktop.refresh(); });
      } }
    ]);
  }

  // Load and render the logged-in user's ~/Desktop folder. Launchers (.app, holding "app=<id>")
  // launch the app; folders open Files there; files open in the default viewer; symlinks follow
  // their target. Mirrors a real Ubuntu/Debian desktop.
  function loadUserDesktop(desk, retries, gen) {
    retries = retries || 0;
    var home = window.AE3_HOME;
    if (!home) return;
    var path = home + "/Desktop";
    A3.request("fs_list", { path: path }).then(function (res) {
      // A rebuild that started after this one has already cleared and repopulated the surface, so
      // these entries belong to a surface that no longer exists - appending them now would stack a
      // second copy of every icon on top of the current ones.
      if (gen !== deskGen) return;
      if (!res || (res.error && res.error !== "")) return;
      if (res.loading) {
        if (retries < 6) setTimeout(function () { loadUserDesktop(desk, retries + 1, gen); }, 500);
        return;
      }
      var placed = {};
      (res.entries || []).forEach(function (it) {
        if (placed[it.name]) return;
        placed[it.name] = true;
        var full = (path + "/" + it.name).replace(/\/+/g, "/");
        var glyph = it.dir ? Icons.folder : Icons.file;
        var open = function () { openDesktopEntry(it, full); };
        var icon = makeIcon(desk, it.name.replace(/\.app$/i, ""), glyph, open, {
          path: full,
          name: it.name,
          open: open,
          dirPath: it.dir ? ((it.link && it.link !== "") ? it.link : full) : ""
        });
        // Launcher files hold "app=<id>" and can use any visible filename, including .exe names.
        if (!it.dir) {
          A3.request("fs_read", { path: (it.link && it.link !== "") ? it.link : full }).then(function (res2) {
            if (gen !== deskGen) return;
            var m = String((res2 && res2.content) || "").match(/app\s*=\s*([\w-]+)/i);
            var target = m && Apps.get(m[1]);
            var g = icon.querySelector(".glyph");
            if (target && target.glyph && g) {
              g.innerHTML = target.glyph;
              if (window.AE3_hydrateAppImages) window.AE3_hydrateAppImages(g);
            }
          }).catch(function () {});
        }
      });
    }).catch(function () {});
  }

  // Shared file-open with password handling. Used by the desktop surface AND the Files app so the
  // password-protected path can never diverge: a locked file always prompts before opening.
  window.AE3_openFile = function (path) {
    A3.request("fs_read", { path: path }).then(function (res) {
      if (res && res.error && res.error !== "") {
        Modal.alert("Open", res.error === "not_text" ? "Not a text file." : "Cannot open file.");
        return;
      }
      if (res && res.locked) {
        Modal.prompt("This file is password protected. Enter password:", "").then(function (pass) {
          if (pass == null) return;
          A3.request("fs_unlock", { path: path, pass: pass }).then(function (r2) {
            if (r2.error === "bad_pass") { Modal.alert("Locked", "Wrong password."); return; }
            if (r2.error && r2.error !== "") { Modal.alert("Open", "Cannot open file."); return; }
            Apps.launch("notepad", { path: path, content: r2.content || "" });
          });
        });
        return;
      }
      var content = (res && res.content) || "";
      if (content.indexOf("AE3_MEDIA|") === 0) {
        var media = A3.parseMedia(content);
        if (media && media.type === "image" && media.b64) {
          // Inline base64 image: only the web viewer can render it (as a data URL). The native
          // viewer cannot load a data URL, so there is no native fallback here.
          Apps.launch("media", {
            b64: true, mime: media.mime, data: media.data,
            vfsPath: path, marker: content, title: path.split("/").pop()
          });
        } else if (media && media.type === "image" && media.web) {
          // Opt-in experimental web viewer: open the in-OS Image Viewer window (it falls back to the
          // native viewer if the CEF texture sampler cannot render the image).
          Apps.launch("media", {
            path: media.path, scope: media.scope, web: media.web,
            vfsPath: path, marker: content, title: path.split("/").pop()
          });
        } else {
          // Default: render through the native engine viewer (video/audio always use this too).
          A3.send("fs_open_media", { path: path, content: content });
        }
        return;
      }
      Apps.launch("notepad", { path: path, content: content });
    });
  };

  function openDesktopEntry(it, full) {
    var readPath = (it.link && it.link !== "") ? it.link : full;
    if (it.dir) { Apps.launch("files", { path: readPath }); return; }
    A3.request("fs_read", { path: readPath }).then(function (res) {
      var content = String((res && res.content) || "");
      var m = content.match(/app\s*=\s*([\w-]+)/i);
      if (m) { Apps.launch(m[1]); return; }
      window.AE3_openFile(readPath);
    }).catch(function () { window.AE3_openFile(readPath); });
  }

  // Bumped on every rebuild so the asynchronous ~/Desktop listing can tell whether the surface it
  // was started for is still the current one (see loadUserDesktop).
  var deskGen = 0;
  var refreshPending = false;

  function buildDesktopIcons() {
    var desk = document.getElementById("desktop");
    desk.innerHTML = "";
    deskGen++;
    var gen = deskGen;
    DESKTOP_ICONS.forEach(function (d) {
      if (!Apps.get(d.app)) return; // skip if the backing app is not present (e.g. recyclebin disabled)
      var glyph = (typeof d.glyph === "function") ? d.glyph() : d.glyph;
      makeIcon(desk, d.label, glyph, function () { Apps.launch(d.app, d.args); }, { trash: d.app === "recyclebin" });
    });
    loadUserDesktop(desk, 0, gen);
    desk.addEventListener("mousedown", function (e) {
      if (e.target === desk) desk.querySelectorAll(".desktop-icon").forEach(function (n) { n.classList.remove("sel"); });
    });
    // Desktop right-click creates items directly in the user's ~/Desktop folder so they
    // appear on the desktop surface, like a real Ubuntu/Debian desktop.
    if (!desk.dataset.ctx) {
      desk.dataset.ctx = "1";
      desk.addEventListener("contextmenu", function (e) {
        if (e.target !== desk && !e.target.closest("#desktop")) return;
        if (e.target.closest(".desktop-icon")) return; // icons would carry their own menu
        e.preventDefault();
        var deskPath = (window.AE3_HOME || "/root") + "/Desktop";
        window.AE3_ctxMenu(e.clientX, e.clientY, [
          { label: "New Folder", action: function () {
            Modal.prompt("New folder name", "untitled").then(function (name) {
              if (!name) return;
              A3.request("fs_mkdir", { path: deskPath + "/" + name }).then(function () { Desktop.refresh(); });
            });
          } },
          { label: "New File", action: function () {
            Modal.prompt("New file name", "untitled.txt").then(function (name) {
              if (!name) return;
              A3.request("fs_save", { path: deskPath + "/" + name, content: "" }).then(function () { Desktop.refresh(); });
            });
          } },
          { sep: true },
          { label: "Paste", disabled: !window.AE3_clipboard, action: function () { pasteTo(deskPath); } },
          { sep: true },
          { label: "Open File Explorer", action: function () { Apps.launch("files", { path: deskPath }); } },
          { label: "Open Recycle Bin", action: function () { Apps.launch("recyclebin"); } },
          { label: "Refresh", action: function () { Desktop.refresh(); } }
        ]);
      });
    }
  }

  // ---------------- Applications menu ----------------
  function menuTree() {
    // Build {category -> {sub -> [apps]} | [apps]} from the registry. app.menu overrides CATEGORY.
    var tree = {};
    registry.filter(function (a) { return a.showInMenu !== false; }).forEach(function (app) {
      var path = String(app.menu || CATEGORY[app.id] || "Other").split("/");
      var cat = path[0], sub = path[1];
      tree[cat] = tree[cat] || { _apps: [], _subs: {} };
      if (sub) { (tree[cat]._subs[sub] = tree[cat]._subs[sub] || []).push(app); }
      else { tree[cat]._apps.push(app); }
    });
    return tree;
  }

  function closeAppsMenu() {
    var m = document.getElementById("appsmenu");
    if (m) m.classList.remove("show");
    var b = document.querySelector("#topbar .appsbtn");
    if (b) b.classList.remove("active");
  }

  function itemRow(app) {
    var row = el("div", "am-item", '<span class="am-ico">' + (app.glyph || "") + '</span><span>' + app.title + "</span>");
    if (window.AE3_hydrateAppImages) window.AE3_hydrateAppImages(row);
    row.addEventListener("click", function (e) { e.stopPropagation(); closeAppsMenu(); Apps.launch(app.id); });
    return row;
  }

  function buildAppsMenu() {
    var menu = document.getElementById("appsmenu");
    if (!menu) return;
    menu.innerHTML = "";
    var tree = menuTree();
    // Fixed category sequence; any unexpected categories follow, alphabetically.
    var cats = CATEGORY_ORDER.filter(function (c) { return tree[c]; })
      .concat(Object.keys(tree).filter(function (c) { return CATEGORY_ORDER.indexOf(c) < 0; }).sort());
    cats.forEach(function (cat) {
      var node = tree[cat];
      var subNames = Object.keys(node._subs);
      node._apps.sort(function (a, b) { return appRank(a) - appRank(b); });
      // Only the uncategorised "Other" bucket is flattened when it holds a single app; named
      // categories always render as a folder so their apps stay grouped (e.g. Snake under Games).
      if (cat === "Other" && node._apps.length === 1 && subNames.length === 0) { menu.appendChild(itemRow(node._apps[0])); return; }
      var catRow = el("div", "am-item am-cat", '<span class="am-ico">&#128193;</span><span style="flex:1">' + cat + '</span><span class="am-arrow">&#9656;</span>');
      var fly = el("div", "am-fly");
      subNames.sort().forEach(function (sub) {
        var subRow = el("div", "am-item am-cat", '<span class="am-ico">&#128193;</span><span style="flex:1">' + sub + '</span><span class="am-arrow">&#9656;</span>');
        var subFly = el("div", "am-fly");
        node._subs[sub].forEach(function (app) { subFly.appendChild(itemRow(app)); });
        subRow.appendChild(subFly);
        fly.appendChild(subRow);
      });
      node._apps.forEach(function (app) { fly.appendChild(itemRow(app)); });
      catRow.appendChild(fly);
      menu.appendChild(catRow);
    });
  }

  // ---------------- Global search ----------------
  // Searches installed apps, files/folders (recursive fs_search from /), the Recycle Bin, and
  // wireless network names. Mail and Messenger are intentionally excluded (they have their own
  // in-app search). Debounced; results render in a dropdown under the search box.
  function bindGlobalSearch() {
    var input = document.getElementById("globalsearch");
    var box = document.getElementById("gsresults");
    if (!input || !box || input.dataset.bound) return;
    input.dataset.bound = "1";
    var timer = null;

    function hide() { box.classList.remove("show"); box.innerHTML = ""; }
    function addRow(icon, label, sub, action) {
      var r = el("div", "gs-row", '<span class="gs-ico">' + (icon || "") + '</span><span class="gs-l">' + label +
        (sub ? '<span class="gs-sub">' + sub + '</span>' : "") + "</span>");
      r.addEventListener("mousedown", function (e) { e.preventDefault(); hide(); input.value = ""; action(); });
      box.appendChild(r);
    }
    function esc(s) { return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }

    function run(q) {
      box.innerHTML = ""; box.classList.add("show");
      var ql = q.toLowerCase();
      // Apps (registry).
      registry.filter(function (a) { return a.showInMenu !== false && a.title.toLowerCase().indexOf(ql) >= 0; })
        .slice(0, 6).forEach(function (a) {
          addRow(a.glyph || "", esc(a.title), "App", function () { Apps.launch(a.id); });
        });
      // Networks.
      A3.request("net_scan", {}).then(function (list) {
        (list || []).filter(function (n) { return (n.ssid || "").toLowerCase().indexOf(ql) >= 0; })
          .slice(0, 5).forEach(function (n) {
            addRow(Icons.wifi, esc(n.ssid), "Network", function () { Apps.launch("network"); });
          });
      }).catch(function () {});
      // Files/folders (recursive) + Recycle Bin.
      A3.request("fs_search", { query: q, root: "/" }).then(function (res) {
        var hits = (res && res.results) || [];
        hits.slice(0, 12).forEach(function (it) {
          var name = it.path.split("/").pop();
          var inTrash = it.path.indexOf("/.trash/") === 0;
          addRow(it.dir ? Icons.folder : Icons.file, esc(name), inTrash ? "Recycle Bin" : esc(it.path), function () {
            if (inTrash) { Apps.launch("recyclebin"); }
            else if (it.dir) { Apps.launch("files", { path: it.path }); }
            else { Apps.launch("files", { path: it.path.replace(/\/[^/]*$/, "") || "/" }); }
          });
        });
        if (!box.children.length) box.innerHTML = '<div class="gs-row muted">No results</div>';
      }).catch(function () {});
    }

    input.addEventListener("input", function () {
      var q = input.value.trim();
      if (timer) clearTimeout(timer);
      if (q === "") { hide(); return; }
      timer = setTimeout(function () { run(q); }, 250);
    });
    input.addEventListener("blur", function () { setTimeout(hide, 150); });
    input.addEventListener("keydown", function (e) { if (e.key === "Escape") { hide(); input.value = ""; } });
  }

  function bindAppsButton() {
    var btn = document.querySelector("#topbar .appsbtn");
    if (!btn || btn.dataset.bound) return;
    btn.dataset.bound = "1";
    btn.addEventListener("click", function (e) {
      e.stopPropagation();
      var menu = document.getElementById("appsmenu");
      var open = menu.classList.toggle("show");
      btn.classList.toggle("active", open);
      if (open) {
        buildAppsMenu();
        setTimeout(function () {
          document.addEventListener("mousedown", function close(ev) {
            if (!menu.contains(ev.target) && ev.target !== btn) { closeAppsMenu(); document.removeEventListener("mousedown", close); }
          });
        }, 0);
      }
    });
  }

  // ---------------- Taskbar ----------------
  function buildTaskbar() {
    var bar = document.getElementById("tasks");
    if (!bar) return;
    bar.innerHTML = "";
    WM.list().forEach(function (w) {
      var t = el("div", "task" + (w.active ? " active" : "") + (w.minimized ? " min" : ""),
        '<span class="task-ico">' + (w.glyph || "") + '</span><span class="task-label">' + w.title + "</span>");
      t.title = w.title;
      t.addEventListener("click", function () { WM.toggle(w.id); });
      bar.appendChild(t);
    });
  }

  function refreshDockRunning() {
    var running = WM.running();
    document.querySelectorAll("#dock .dock-item").forEach(function (n) {
      n.classList.toggle("running", running.indexOf(n.dataset.app) >= 0);
    });
  }

  function onTaskbarChange() { refreshDockRunning(); buildTaskbar(); }

  // ---------------- Clock: Mission Date + Time, click opens Calendar ----------------
  var clockTimer = null, batteryTimer = null;
  function startClock() {
    function tick() {
      var mission = (lastSys && lastSys.missionTime) || "--:--";
      var mDate   = (lastSys && lastSys.missionDate)  || "";
      var c = document.getElementById("clock");
      if (c) c.textContent = mDate ? mDate + "  " + mission : mission;
    }
    if (clockTimer) clearInterval(clockTimer);
    clockTimer = setInterval(tick, 1000); tick();
    var c = document.getElementById("clock");
    if (c && !c.dataset.bound) { c.dataset.bound = "1"; c.addEventListener("click", function () { Apps.launch("calendar"); }); }
  }

  // ---------------- Tray: battery, wifi, power ----------------
  function popover(id, anchorRight, html) {
    var ex = document.getElementById(id);
    if (ex) { ex.remove(); return null; }
    var m = el("div", "tray-pop", html); m.id = id;
    m.style.right = anchorRight + "px";
    document.body.appendChild(m);
    setTimeout(function () {
      document.addEventListener("mousedown", function close(ev) {
        if (!m.contains(ev.target)) { m.remove(); document.removeEventListener("mousedown", close); }
      });
    }, 0);
    return m;
  }

  var lastSys = {};
  function buildTray() {
    var tray = document.querySelector("#topbar .tray");
    if (!tray || !window.Icons) return;
    tray.innerHTML =
      '<span class="tray-ico wifi" title="Network">' + Icons.wifi + '</span>' +
      '<span class="tray-ico battery" title="Battery">' + Icons.battery + ' <span class="batpct">--</span></span>' +
      '<span class="tray-user" title="Signed in user" style="margin:0 6px;opacity:.85"></span>' +
      '<span class="tray-ico powerbtn" title="Power">' + Icons.power + '</span>';

    // Show the currently logged-in user next to the power button (set as text so it is escaped).
    var userEl = tray.querySelector(".tray-user");
    if (userEl) userEl.textContent = window.AE3_USER || "";

    var pct = tray.querySelector(".batpct");
    function poll() {
      A3.request("sysinfo", {}).then(function (s) {
        s = s || {}; lastSys = s;
        if (pct) pct.textContent = (s.battery != null && s.battery >= 0) ? (s.battery + "%") : "--";
        var bat = tray.querySelector(".battery");
        if (bat) {
          var low = (s.battery != null && s.battery >= 0 && s.battery <= 15);
          bat.style.color = low ? "#e9542d" : "";
        }
      }).catch(function () {});
    }
    if (batteryTimer) clearInterval(batteryTimer);
    batteryTimer = setInterval(poll, 5000); poll();

    // Battery popover: charge, power state, capacity.
    tray.querySelector(".battery").addEventListener("click", function (e) {
      e.stopPropagation();
      var s = lastSys || {};
      popover("batterypop", 64,
        '<div class="tp-h">Battery</div>' +
        '<div class="tp-r">Charge: <b>' + ((s.battery != null && s.battery >= 0) ? s.battery + "%" : "?") + '</b></div>' +
        '<div class="tp-r">Power: <b>' + (s.power || "?") + '</b></div>' +
        '<div class="tp-r">Uptime: ' + (s.uptime || "?") + '</div>');
    });

    // Wifi opens the Network app.
    tray.querySelector(".wifi").addEventListener("click", function (e) { e.stopPropagation(); Apps.launch("network"); });

    // Power menu: Sign out / Shut down.
    tray.querySelector(".powerbtn").addEventListener("click", function (e) {
      e.stopPropagation();
      var m = popover("powermenu", 6,
        '<div class="pm-item signout">Sign out</div><div class="pm-item shutdown">Shut down</div>');
      if (!m) return;
      m.querySelector(".signout").addEventListener("click", function () { m.remove(); Desktop.signOut(); });
      m.querySelector(".shutdown").addEventListener("click", function () { m.remove(); A3.send("shutdown", {}); });
    });
  }

  // Open-window layout persistence: debounce-save the WM snapshot to the laptop so reopening
  // resumes exactly where it was left. Suppressed while restoring to avoid feedback churn.
  var uiSaveTimer = null, uiRestoring = false;
  function bindUiPersist() {
    WM.onStateChange = function () {
      if (uiRestoring) return;
      if (uiSaveTimer) clearTimeout(uiSaveTimer);
      uiSaveTimer = setTimeout(function () { A3.send("ui_save", { state: WM.snapshot() }); }, 600);
    };
  }

  var Desktop = {
    init: function () {
      WM.onTaskbarChange = onTaskbarChange;
      bindUiPersist();
      buildTray();
      buildDock();
      buildDesktopIcons();
      bindAppsButton();
      bindGlobalSearch();
      startClock();
      buildTaskbar();
    },
    setHostname: function (name) {
      var h = document.getElementById("hostname");
      if (h) h.textContent = name || "armaOS";
    },
    // Wallpaper: CSS background applied to #wallpaper. Values may be a CSS colour/gradient, an http/
    // data URL, or an engine/mod texture / mission raster (.paa/.jpg/.png or a \z\... path) - the
    // latter are resolved to a data URL through the texture bridge (CEF cannot load engine paths).
    setWallpaper: function (val) {
      var w = document.getElementById("wallpaper");
      if (!w || !val) return;
      if (/\.(paa|jpe?g|png|gif)$/i.test(val) || val.charAt(0) === "\\") {
        A3.loadImage(val).then(function (url) {
          w.style.background = "#000 center/cover no-repeat url('" + url + "')";
        }).catch(function () {});
        return;
      }
      w.style.background = (/^https?:|^data:|\//.test(val)) ? ("center/cover no-repeat url('" + val + "')") : val;
    },
    signOut: function () {
      if (window.WM && WM.closeAll) WM.closeAll();
      window.AE3_USER = null;
      A3.send("signout", {});
      if (typeof window.AE3_showLogin === "function") window.AE3_showLogin();
    },
    // Coalesced: several addons can push their app list in the same frame (one push per laptop or per
    // USB change), and each push asks for a refresh. Rebuilding once per burst keeps the surface from
    // being torn down while a previous rebuild is still listing the user's ~/Desktop folder.
    refresh: function () {
      if (refreshPending) return;
      refreshPending = true;
      setTimeout(function () {
        refreshPending = false;
        buildDock(); buildDesktopIcons(); onTaskbarChange();
      }, 0);
    },
    // Reopen the windows saved from the previous session.
    restoreUi: function (list) {
      uiRestoring = true;
      if (window.WM && WM.restoreState) WM.restoreState(list);
      setTimeout(function () { uiRestoring = false; }, 200);
    }
  };

  // Shared device map-link: open the full in-game map centred on a grid position, with a
  // labelled marker. Used by Root Cyberwarfare device apps' [Map] buttons. pos = [x,y].
  window.AE3_openMap = function (pos, label, marker) {
    if (!pos || pos.length < 2) { A3.send("map_open", {}); return; }
    A3.send("map_open", { pos: pos, label: label || "", marker: marker !== false });
  };

  window.Apps = Apps;
  window.Desktop = Desktop;
})();
