---
topic: desktop-intel-and-communications
status: verified
last-verified: 2026-07-08
confidence_score: 1.0
priority: core
rank: 4
tokens: ~650
code-paths:
  - addons/desktop/functions/fnc_intel_*.sqf
  - addons/desktop/functions/fnc_module_addIntel.sqf
  - addons/desktop/functions/fnc_zeus_module_addIntel.sqf
  - addons/desktop/functions/fnc_addEmail.sqf
  - addons/desktop/functions/fnc_mail*.sqf
  - addons/desktop/functions/fnc_msg*.sqf
  - addons/desktop/functions/fnc_registerMedia.sqf
  - addons/desktop/functions/fnc_openFile.sqf
  - addons/desktop/CfgVehicles.hpp
  - addons/desktop/XEH_preInit.sqf
related-topics: [desktop-gui-and-browser, filesystem-model, multiplayer-locality-and-sync, eden-zeus-tooling]
related-docs:
  - wiki/Systems/Desktop-GUI.md
  - wiki/Zeus-Guide.md
  - wiki/Eden-Editor-Guide.md
---

# Desktop Intel And Communications

## overview

The desktop component also acts as the mission-intel and communications layer: Eden/Zeus modules plant mail, web pages, browser history, media markers, locked files, calendar entries, mail addresses, and chat handles into laptop state and the virtual filesystem.

## current behavior

- Typed intel modules are declared in `addons/desktop/CfgVehicles.hpp` and use `ae3_intelType` values such as `email`, `webpage`, `history`, `media`, and `lockedfile`.
- Eden/trigger placement enters through `AE3_desktop_fnc_module_addIntel`; curator placement is ignored there and handled by `AE3_desktop_fnc_zeus_module_addIntel` to avoid duplicate empty dispatches.
- `AE3_desktop_fnc_intel_dispatch` is the shared fan-out point for typed intel. It calls mail, webpage, history, media, or locked-file APIs based on the type string.
- Triggered intel waits for each synced laptop's `AE3_filesystemReady` flag before dispatching, so content added at mission start does not vanish before filesystem initialization finishes.
- Server-side desktop preInit registers CBA events for adding email, registering webpages/media/cameras, adding browser history/calendar entries/locked files, chat pull, chat/mail routing, and handle/address registration.
- `AE3_desktop_fnc_provisionIdentity` gives initialized laptops default mail addresses and Messenger handles in mission-wide registries.
- Mail routing validates that the sender address belongs to the sending laptop, checks powered-on reachability, delivers the email to the recipient, and writes a sent copy under `/var/sent` on the sender.
- Chat routing validates handles, requires powered-on reachability, writes paired conversation logs under `/var/chat`, and notifies the target user's open desktop session when possible.
- Media registration creates virtual filesystem marker files that point to mission or mod media assets. File open logic parses those markers to launch image, video, or audio viewers; the Music app scans for audio markers, lists them, and calls `AE3_desktop_fnc_audioPlayer` on double-click.
- Web desktop apps receive change notifications through client CBA events and `AE3_desktop_fnc_jsSend`, including mail, chat, calendar, volume, system, network, and browser changes.

## decisions

- Typed intel uses a single dispatch function shared by Eden, Zeus, triggers, and scripts, keeping field mapping and target handling consistent even though the entry UIs differ.
- Intel writes wait for filesystem readiness instead of assuming synchronized module activation happens after laptop init; mission-start ordering requires content placement to be deferred per laptop.
- Mail and chat use mission-wide registries keyed by normalized addresses/handles, so users can message a human-readable identity without knowing object netIds.
- Mail/chat reachability currently depends on power state, not network topology. These apps model an online/offline service layer separate from SSH route policy.
- Media is represented as filesystem marker content instead of embedding binary content in the virtual filesystem. Arma media remains a mission/mod asset while the laptop filesystem stores discoverable shortcuts.

## export and clipboard

The Mail and Messenger web apps can write what is on screen out to the laptop's own filesystem and to
the player's real OS clipboard. Both are front-end only (`addons/desktop/ui/web/js/apps.js`):

- One formatter per type - `formatMail(m)` and `formatThread(t, self)` - feeds both the file export
  and the clipboard, so the two can never drift. `fileSlug` sanitizes the suggested filename.
- Export reuses `window.AE3_pickFile("save", ...)` and the existing `fs_save` route
  (`fnc_jsRouter` -> `fnc_fsHandle` case `"save"`). The file is owned by the logged-in desktop user,
  so it is immediately readable by CLI `cat`, `scp` and the SSH pull path. No new SQF was needed.
- Clipboard goes through `window.AE3_copyText` (`ui/web/js/desktop.js`): async clipboard API, then
  `document.execCommand("copy")`, then a dialog with the text preselected for manual Ctrl+C. The
  `copyToClipboard` script command is **not** usable here - it is server-restricted, so on a dedicated
  server it would write to the server's clipboard, which no player can reach.

## gotchas

- Zeus-placed AddIntel modules must not run through the normal Eden/trigger handler.
- New intel types need updates in several places, not just dispatch: type combo setup, field layout, 3DEN save/load, Zeus submit mapping, module config, and `intel_dispatch`.
- Chat file names rely on handle sanitization and a `+` separator that cannot appear after sanitization.
- Mail and chat delivery errors are returned through browser request IDs; callers that bypass the web router need their own feedback path.
- Sent-mail writes and notification nudges are wrapped in `try/catch`; delivery can succeed while the sender's sent copy or open-Mail refresh silently fails.
- Media paths carry a scope hint (`auto`, `mission`, or `mod`) and optional web-viewer flag.

## re-verify when

- Mail address registry `AE3_mail_addresses` entries are `[ownerLaptopNetId, displayAddress]`; element 0 is the owning laptop used by `fnc_mailRoute` for delivery/authorization. Every writer must store the target laptop netId, never `""` — `fnc_addEmail`'s "create sender/recipient address" binds to the email's `_target` laptop (skips when `_target` is `"all"`); `fnc_addrRegister`/`fnc_provisionIdentity` are the other canonical writers.
- A new intel type, desktop app notification, mail/chat route, media marker format, address/handle registry, or AddIntel field changes.
- `fnc_intel_dispatch.sqf`, `fnc_module_addIntel.sqf`, `fnc_zeus_module_addIntel.sqf`, `fnc_registerMedia.sqf`, `fnc_mailRoute.sqf`, or `fnc_msgRoute.sqf` changes.

## references

- `addons/desktop/functions/fnc_intel_dispatch.sqf`
- `addons/desktop/functions/fnc_module_addIntel.sqf`
- `addons/desktop/functions/fnc_zeus_module_addIntel.sqf`
- `addons/desktop/functions/fnc_registerMedia.sqf`
- `addons/desktop/functions/fnc_mailRoute.sqf`
- `addons/desktop/functions/fnc_msgRoute.sqf`
- `addons/desktop/functions/fnc_provisionIdentity.sqf`
- `addons/desktop/XEH_preInit.sqf`
- `addons/desktop/XEH_postInit.sqf`
