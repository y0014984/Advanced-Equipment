---
topic: desktop-gui-and-browser
status: verified
last-verified: 2026-07-08
confidence_score: 1.0
priority: core
rank: 1
tokens: ~1750
code-paths:
  - addons/desktop/
  - addons/desktop/functions/fnc_jsRouter.sqf
  - addons/desktop/functions/fnc_desktop_open.sqf
  - addons/desktop/CfgAE3Apps.hpp
related-topics: [armaos-terminal, filesystem-model, network-routing-and-ssh, eden-zeus-tooling, desktop-intel-and-communications, flashdrive-usb, multiplayer-locality-and-sync]
related-docs:
  - wiki/Systems/Desktop-GUI.md
  - wiki/Systems/Browser.md
  - wiki/Reference/Desktop-API.md
  - wiki/Reference/Browser-API.md
---

# Desktop GUI And Browser

## overview

The desktop component provides the graphical laptop desktop, native app registry, browser bridge, web desktop command router, mail/chat/browser/calendar/media features, and runtime extension points for other addons.

## current behavior

- `AE3_desktop_fnc_desktop_open` opens the native GUI desktop for a laptop, pulls filesystem/user state, claims the laptop as in use, creates desktop icons, and restores previous window state.
- Native desktop apps are declared in `CfgAE3Apps` or registered at runtime with `AE3_desktop_fnc_registerApp`.
- Web external apps are registered with `AE3_desktop_fnc_registerExtApp`; the web desktop replaces same-id external apps, removes absent external apps from later `ext_apps` pushes, and supports `deviceList` plus `launcher` template kinds. Desktop files with resolved content `app=<id>` launch that app even when the visible filename is not `.app`; launcher `iconPath` values are hydrated through the web texture bridge so PAA mod textures can render in CEF.
- The built-in app set includes Terminal, Files, Settings, Notepad, Mail, Chat, Browser, Calendar, Map, CCTV, Music, and SysInfo.
- The web desktop uses a browser control bridge. JavaScript sends JSON messages with `command`, `rid`, and `data`; `AE3_desktop_fnc_jsRouter` dispatches those messages to SQF handlers and replies through `AE3_desktop_fnc_jsSend`.
- Files and Notepad route through `AE3_desktop_fnc_fsHandle`, which calls the same virtual filesystem functions used by CLI commands.
- Browser pages are registered with `AE3_desktop_fnc_registerWebpage`; global pages live in `missionNamespace` under `AE3_Desktop_Webpages`, while laptop-targeted pages live on the object under the same key.
- Browser history is stored in the laptop filesystem at `/var/log/browser_history`.
- Post-init seeds a default RootNet page and registers client events that notify open web apps about mail, chat, calendar, SSH, USB volume, system, network, and browser page changes.
- Desktop auth mirrors terminal auth, including direct-root restrictions, now resolved per laptop through `AE3_armaos_fnc_computer_allowsRootLogin` (object var `AE3_allowRootLogin`, falling back to the CBA setting `AE3_AllowRootLogin`). Elevation inside the desktop (`fsHandle`, `volHandle`, `sshOpServer`) covers `root`, `admin`, and `/etc/sudoers` members.
- Desktop <-> CLI switching: the web desktop's "Terminal" app (dock + Applications menu; an action-app in `js/apps.js` that calls `A3.send("sys_switch_cli")`) triggers `jsRouter` case `sys_switch_cli`, which closes the web desktop and opens the classic terminal (`AE3_armaos_fnc_terminal_init`) holding the mutex, gated by `AE3_desktop_fnc_canAccessInterface` "cli". The reverse is the terminal command `desktop` (`/bin/desktop` -> `AE3_armaos_fnc_os_desktop`), which closes the terminal and reopens the web desktop, gated by "gui" access and a no-op if the desktop addon is absent.
- Executable files (code payload) are reported by `fs_list` with an `exec` flag; the web file browser tints them green (`.isexec`) and double-clicking one runs it via `jsRouter` case `sys_run_file` (switch to CLI, then execute once a session is authenticated). A symlink is `exec` when its resolved target is a code payload (`fs_list` reads the target's content). The legacy native Files app applies the same green tint and run-on-double-click.
- Browser mission pages: `A3.loadFile` searches the **mission root before** the mod PBO for CONTENT (`window.AE3_WEB_ROOTS = ["", WEB_ROOT]`), so a mission's `sites/<name>/index.html` overrides anything at the mod path. The `index.html` shell-asset loader uses a separate mod-first order (`[WEB_ROOT, ""]`) so bundled css/js do not spam "Script ... not found" mission-root misses in the RPT. The mod no longer ships any bundled sample sites - the old `ui/web/sites/` (portal + wiki) and `ui/web/wiki/` folders were removed; all site content now comes from missions via `registerSite`.
- Browser home: the address `home`/`rootnet` resolves to the server-seeded RootNet intel page (`rootnet.root`/`home.root`, seeded in `XEH_postInit.sqf`). The page list (`web_pages`) loads asynchronously, so `homeTarget()` returns a **static inline RootNet page** (`ROOTNET_HOME`, same text as the seed) until the list arrives; `reloadIntelPages()` then re-navigates `home` once the list resolves (guarded on the active tab still showing `home`) so the registered page replaces the static fallback. There is no Portal fallback and the home is never blank. A bare `.md` link is page-relative when inside a mission site (`curDir` under `sites/`), else resolved under `wiki/` (mission-provided).
- Browser in-site links + history: a slash-containing relative link inside a mission site (e.g. gallery's `assets/night.svg`) is joined to the current site `curDir` in `resolve()` (not treated as VFS-root-relative). `curDir` is adopted (`dirOf(t.path)`) only inside the successful `load()` callback, so a failed fetch does not contaminate the site context. Browser history stores the resolved target objects (not bare labels); Back/Forward (`loadHistoryEntry`) load the stored target directly instead of re-resolving a label against a mutated `curDir`.
- Browser tab close button uses the ASCII HTML entity `&#215;` via `innerHTML` (not a raw non-ASCII `×` literal), matching the toolbar buttons, because Arma's CEF/JS charset handling renders raw non-ASCII literals as tofu.
- Browser tabs: the Browser app runs multiple tabs in one window (tab strip + `+`/close). Each tab keeps its own history, `curDir`, address and last-rendered doc; switching saves the live state and restores the target's. Custom domains map a name to a mission site-root folder: `AE3_desktop_fnc_registerSite [domain, siteRoot, targets]` stores `AE3_Desktop_Sites` (per-laptop or global, broadcast); `jsRouter` case `web_sites` surfaces it; the Browser `resolve()` matches the host part of a typed address and routes `<domain>/<sub>` to `<siteRoot>/<sub>` (bare domain -> `index.html`). The **AE3: Add Website** Zeus/Eden module (`fnc_module_addWebsite` + ZEN `fnc_zen_module_addWebsite`) sets a mapping live.
- Wallpaper is stored **per-user-per-laptop** in the object HashMap `AE3_desktop_wallpapers` (username -> value; legacy single `AE3_desktop_wallpaper` kept as fallback). `sys_set` passes the logged-in user; `sysInfo` returns that user's wallpaper. The Settings app shows a thumbnail picker from `jsRouter` case `wallpaper_list`; the bundled wallpapers are served as base64 sidecars (`addons/desktop/images/wallpaper_*.png.b64`, not `.paa`) because the CEF texture sampler is unreliable for `.paa`. `Desktop.setWallpaper` resolves image paths through `A3.loadImage` (which reads a `<image>.b64` sidecar for raster/engine paths) before applying the CSS background. `tools/png2b64.{ps1,py}` generate the sidecars.
- Calendar events carry an optional time (HH:MM) appended to the event tuple `[date,title,location,body,time]`; `cal_list`/`cal_add` and the web Calendar app read/write it. Media "Add Media" writes to a destination folder + a separate File Name field and overwrites an existing case-insensitive name match (`device_addFile` `_overwrite` param, used by `registerMedia`). Add Media also has a **base64 image box** (IDC 1420, media type only, Zeus dialog): pasting raw base64 there overrides the source path and dispatches type `"picture"` (`intel_dispatch`) -> `AE3_desktop_fnc_registerPictureB64`, which stores the payload as an inline picture marker via `device_addFile`'s `_isPicture` path. The 3DEN attribute group has no base64 box; `intel_updateFields` resolves IDC 1420 defensively (null in 3DEN).
- Inline base64 images: a file created via the **Add Media** base64 box (formerly Add File's removed "This is a Picture" option) stores `AE3_MEDIA|image|b64|<mime>|<data>` (no real texture path). `A3.parseMedia` returns `{type:"image", b64:true, mime, data}` for it; `AE3_openFile` (desktop.js) routes it to the Image Viewer app with `{b64,mime,data}` args (no native fallback - native RscPicture cannot render a data URL, so `fnc_openFile.sqf` declines the `AE3_MEDIA_B64_PREFIX` prefix with `STR_AE3_Desktop_Files_PictureWebOnly`). The Image Viewer (`js/apps.js`) renders it by setting `img.src = "data:"+mime+";base64,"+data`, and has a **Decode B64** toolbar button (`Modal.decodeB64`, `js/modal.js`) that pastes+renders base64 live and temporarily without touching the VFS. MIME auto-detected from the base64 magic prefix (`mimeFromB64`, mirrors the SQF detection in `device_addFile`). Size cap `AE3_MAX_PICTURE_B64` (2 MB) enforced server-side.

## decisions

- The web desktop funnels JavaScript calls through one SQF router to keep the browser bridge auditable and avoid scattering browser event handlers across apps.
- Desktop apps use both config registration and runtime registration: config covers built-in/default apps, while runtime registration gives addon authors a lightweight extension path.
- State-dependent external web apps should prefer `requiresFunction` when availability depends on mounted USBs or computed client state; addons can use the local `ae3_desktop_ready` event and later state-change events to push refreshed filtered `ext_apps` lists.
- Browser content is registered as in-game intel, not loaded from external URLs, so Arma's browser control stays an internal UI and mission-safe content surface.
- GUI file access intentionally reuses CLI filesystem calls to keep owner and permission behavior consistent across GUI and TUI.
- The desktop shows a static in-use texture on the laptop object while the real GUI exists only on the operator client, limiting network traffic and avoiding an active rendered desktop for observers.

## gotchas

- Media type is corrected from the file extension in `fnc_registerMedia` (the Zeus module's type combo defaults to "image"); the native image viewer in `fnc_openFile` also rejects any non-image extension before touching an `RscPicture`, because handing an audio/video source to a texture control hard-crashes the client (`DX11 CreateTexture E_INVALIDARG`).
- `jsRouter` `wallpaper_list` filters registered images to only those with a resolvable `.b64` sidecar (`fileExists`), because CEF cannot sample a raw mission raster/paa and the Settings thumbnail loader would otherwise spam engine "Script ....b64 not found" / "Unknown sampler texture type" warnings. Such images still open in the native viewer; they just cannot be web wallpapers without a sidecar.
- SSH access ("Allow SSH access") and the device IP field live in the **Network** app (behind a "Settings" button next to Rescan, `apps.js`), not the Settings app. Both still drive `ssh_config` / `net_setip`.
- Browser tabs persist across a desktop close/reopen: the browser app writes its open tab addresses + active index into `win.args` (via `persistTabs`, which triggers `WM.onStateChange`), so the WM layout snapshot (`ui_save`) restores them. Restored tabs are `pending` and load lazily when first shown.
- `bridge.js loadImage` for a mission-folder raster (jpg/png/gif, scope != mod) reads only the `.b64` sidecar and does NOT fall back to the engine texture sampler (which spams "Unknown sampler texture type" for a raw mission image). Raw mission rasters render through the native `RscPicture` viewer (`fs_open_media`); they cannot be CEF wallpapers without a sidecar. Mod/absolute/`.paa` assets still sample cleanly (texture-first, sidecar fallback).
- `fnc_jsRouter.sqf` is a major hotspot. New web commands should be reviewed for auth, locality, reply handling, and serialization before adding more cases.
- HashMaps do not serialize safely through every multiplayer path; SSH command handling converts operation arguments to plain arrays/strings before sending a CBA server event.
- Browser history writes require the laptop filesystem to exist and silently fail inside `try/catch` if the history file cannot be created.
- Session resume is tied to player UID; `ready` auto-resumes only when `AE3_desktop_sessionOwner` matches `getPlayerUID player`.
- Runtime app registration is local effect. Call it on every client that should see the app.
- External app removal only applies to apps marked by the web extension registry (`external: true`); built-in apps are not removed by `ext_apps` refreshes. Registry icons can carry `iconPath`; the desktop resolves those paths with `A3.loadImage` instead of direct `<img src>`, so PAA mod textures become web-renderable data URLs.

## re-verify when

- `fnc_jsRouter.sqf`, web app command names, `ui/web/js/extapps.js`, `ui/web/js/desktop.js`, `CfgAE3Apps.hpp`, desktop window manager functions, browser history storage, or `registerWebpage` changes.
- A new desktop app, browser feature, or extension command is added.

## references

- `addons/desktop/functions/fnc_desktop_open.sqf`
- `addons/desktop/functions/fnc_jsRouter.sqf`
- `addons/desktop/functions/fnc_fsHandle.sqf`
- `addons/desktop/functions/fnc_registerApp.sqf`
- `addons/desktop/functions/fnc_registerExtApp.sqf`
- `addons/desktop/ui/web/js/extapps.js`
- `addons/desktop/ui/web/js/desktop.js`
- `addons/desktop/ui/web/js/wm.js`
- `addons/desktop/functions/fnc_registerWebpage.sqf`
- `addons/desktop/XEH_postInit.sqf`
- `addons/desktop/CfgAE3Apps.hpp`
