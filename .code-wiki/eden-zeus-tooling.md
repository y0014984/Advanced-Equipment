---
topic: eden-zeus-tooling
status: verified
last-verified: 2026-07-08
confidence_score: 1.0
priority: core
rank: 2
tokens: ~1550
code-paths:
  - addons/main/Cfg3DEN.hpp
  - addons/main/CfgUserInterfaceZeus.hpp
  - addons/main/functions/fnc_zeus_*.sqf
  - addons/main/CfgVehicles.hpp
  - addons/armaos/CfgVehicles.hpp
  - addons/filesystem/CfgVehicles.hpp
  - addons/network/CfgVehicles.hpp
  - addons/power/CfgVehicles.hpp
  - addons/*/functions/fnc_module_*.sqf
  - addons/main/functions/fnc_zen_createDialog.sqf
  - addons/*/functions/fnc_zen_module_*.sqf
  - addons/main/functions/fnc_zeus_applyConnection.sqf
related-topics: [filesystem-model, network-routing-and-ssh, power-model, desktop-gui-and-browser, desktop-intel-and-communications, main-runtime-infrastructure]
related-docs:
  - wiki/Eden-Editor-Guide.md
  - wiki/Zeus-Guide.md
  - wiki/Examples/
---

# Eden Zeus Tooling

## overview

Editor tooling is split between 3DEN attributes/connections, Eden modules, Zeus modules/dialogs, and shared Zeus helper functions in the main component.

## current behavior

- 3DEN custom connections define power and network links. Power connections call `AE3_power_fnc_createPowerConnection`; network connections call `AE3_network_fnc_createNetworkConnection`.
- Laptop and router attributes live on their vehicle classes and set object variables for power level, interface mode, static IP, startup power state, router gateway, wireless range, password, and external access policy.
- Eden-visible modules exist in multiple components. Examples include adding users, files, directories, calendar events, emails, webpages, browser history, media, passworded files, and interface access/crash actions depending on scope.
- Zeus has custom dialogs and helper functions under `addons/main/functions/fnc_zeus_*.sqf` and `addons/main/CfgUserInterfaceZeus.hpp`.
- The Zeus Add Connection module validates exactly two synced objects and then creates either a power or network connection.
- Zeus filesystem browser operations are a larger sub-system: open, refresh, populate tree, create, save, delete, rename, move, apply changes, and close.
- Some module classes are intentionally Eden-only or Zeus-only through `scope` and `scopeCurator`.
- Add Intel is split in Zeus into standalone per-type modules: `AE3_AddEmail`, `AE3_AddWebpage`, `AE3_AddBrowserHistory`, `AE3_AddMedia`, `AE3_AddPasswordedFile` are now `scopeCurator = 2` and share `curatorInfoType = AE3_UserInterface_Zeus_Module_AddIntel`. Each carries `ae3_intelType`; the shared dialog reads it (`configOf _module >> "ae3_intelType"`) to preset+lock the type picker (non-ZEN) or route straight to the matching ZEN step-2 form (or the legacy Browse dialog for media/lockedfile). The unified `AE3_AddIntel` is now `scopeCurator = 0` (hidden from Zeus) but kept so its shared dialog and 3DEN wiring stay defined. Eden/trigger placement is unchanged (per-type `Attributes` + `AE3_desktop_fnc_module_addIntel`).
- The Add User ZEN dialog pre-fills `admin` / `admin123` as default username/password (`fnc_zen_module_addUser`).
- `AE3_AddSudoer` ("AE3: Add Sudoer") follows the Add User pattern end to end: Eden `fnc_module_addSudoer` (attribute class/variable `AE3_ModuleSudoers_User`), curator dialog `AE3_UserInterface_Zeus_Module_AddSudoer` (idd 16988) + `fnc_zeus_module_addSudoer`, ZEN `fnc_zen_module_addSudoer`, and the `"addSudoer"` case in `fnc_zeus_deviceOpServer` -> `AE3_armaos_fnc_computer_addSudoer`. Per-laptop root policy/password/sudoers are also 3DEN object attributes on all three laptop variants via the `AE3_LAPTOP_ROOT_ATTRIBUTES` macro (`armaos/CfgVehicles.hpp`).
- ZEN Add Calendar Event has a Time (HH:MM) field, appended to the event tuple. ZEN Interface Access uses two `OWNERS` pickers (CLI access / GUI access) instead of per-player combos; empty picker = allow-all (`{true}`), otherwise a UID+side array passed to `setInterfaceAccess`. New `AE3: Add Website` module (Eden attrs Domain/SiteRoot; Zeus via ZEN `fnc_zen_module_addWebsite`) registers custom browser domains.
- Save/Restore Laptop target resolution: `fnc_module_saveLaptop`/`fnc_module_restoreLaptop` must resolve their laptop themselves. A curator dropping the module directly onto a laptop spawns it with an **empty** synced-object list, so both now use the crashDevice pattern - filter the synced units with `_isLaptop` (`isClass (configOf _x >> "AE3_USB_Interface")` or `AE3_cap_hasTerminal`) and fall back to `nearestObjects [_module, [], 3]` when empty - before the ZEN `remoteExec`/non-ZEN apply. Without this the save/restore loops iterated `[]` (captured/applied nothing) and login later failed with the hardcoded `"Unknown user"` (`fnc_authUser.sqf`). `fnc_zen_module_restoreLaptop` no longer fabricates a `slot1` when the save buffer is empty; it hints "no saved snapshots" and drops the module.
- 3DEN/Zeus asset tree: top-level `AE3_Assets` (`CfgEditorCategories`) plus a `CfgEditorSubcategories` block (both in `addons/main/CfgEditorCategories.hpp`) with 8 subcats (`AE3_Sub_Furniture/Storage/Lights/Routers/Power/Battery/Laptop/SolarPanel`). Each AE3 world object sets `editorCategory = "AE3_Assets"` + its `editorSubcategory`; variants inherit from their base. Both Eden and Zeus read these same two properties. Module (Logic) classes are untouched (they use `category`).
- Save/Restore Laptop clone: `applyState` applies the big nested `AE3_filesystem`/`AE3_filepointer` **server-local** (flag 2, like a normal laptop) and only broadcasts the small vars - broadcasting the CODE-bearing filesystem publicly stalled the client's `getRemoteVar` chain so the userlist never arrived ("Unknown user"/login timeout). It also re-broadcasts `AE3_Userlist` + fires `ae3_computer_userAdded`, re-binds networking with the restored parent/address, and `restoreLaptopApply` calls `device_ensureInit` on the fresh target first. Exclusion set is compared case-insensitively; session vars excluded so a clone starts signed out.
- Zeus curator Filesystem Browser (`idd 16993`): path field `1400` shortened so the pick-mode "Select Path" button `2900` is not covered; `onUnload` returns the path on OK (exit code 1) in pick mode, not just via the button; `refresh` resets the listbox selection (`lbSetCurSel -1`) so it no longer auto-picks the first file. Add Media's intel dialog reuses the shared `1714`/`1405` row as a "File Name with Extension" field (combined with the Browse-picked destination folder), overwriting a case-insensitive name match.
- Optional ZEN (Zeus Enhanced) compat: when the `zen_dialog` addon is loaded, the Zeus modules present ZEN's Dynamic Dialog (`zen_dialog_fnc_create`) instead of the built-in `CfgUserInterfaceZeus` dialogs. Detection is cached once in `addons/main/XEH_preInit.sqf` as `AE3_main_hasZenDialog` (`EGVAR(main,hasZenDialog)`); ZEN is never a required addon and is referenced only from guarded SQF (never config). All ZEN builders route through the guarded wrapper `AE3_main_fnc_zen_createDialog`.
  - Dialog modules (AddUser/AddCalendarEvent/AddFile/AddDir/AddConnection/AddIntel/InterfaceAccess): the legacy `curatorInfoType` handler still opens, but its `onLoad` bails when `hasZenDialog` - it captures the target laptop, sets `AE3_<component>_zenHandled` on the module (so the legacy `onUnload` skips its cleanup), `closeDisplay 2`, then opens the ZEN builder one frame later via `CBA_fnc_execNextFrame`. The ZEN `onConfirm`/`onCancel` funnel into the exact same apply layer (`intel_dispatch`, the `ae3_main_zeusDeviceOp` serverEvent, `setInterfaceMode`/`setInterfaceAccess`, and the extracted `AE3_main_fnc_zeus_applyConnection`) and own the module lifecycle.
  - AddIntel is a two-step ZEN dialog (type combo, then type-specific fields). Media and lockedfile keep the legacy dialog for its filesystem Browse picker: step 1 reopens `AE3_UserInterface_Zeus_Module_AddIntel` with `uiNamespace` override `AE3_desktop_intelZenOverride = [module, computer]` and clears `zenHandled` so the legacy handler runs normally.
  - AddFile has a "This is a Picture" checkbox + "Image type" combo (Eden attrs `AE3_Module_AddFile_IsPicture`/`_PictureType`; Zeus dialog idc `1309`/`1502`; ZEN two extra rows). When checked, `_content` is treated as raw base64 and stored by `device_addFile` as an inline image marker `AE3_MEDIA|image|b64|<mime>|<data>` (overrides code/encryption; empty encryption key no longer blocks it). Cap `AE3_MAX_PICTURE_B64` (2,097,152 chars) enforced server-side in `device_addFile` and pre-checked client-side (feedback `STR_AE3_Main_Zeus_PictureTooLarge`). MIME resolved from the combo or auto-detected from the base64 magic prefix. Only the web desktop's Image Viewer can render these (data URL); the native viewer declines them (`STR_AE3_Desktop_Files_PictureWebOnly`). `device_addFile` param order: `..., _overwrite, _isPicture, _pictureType`.
  - No-dialog modules (CrashDevice/SaveLaptop/RestoreLaptop) gain a curator prompt only under ZEN: the server module function `remoteExec`s a ZEN-prompt fn onto `owner _module`; the curator's `onConfirm` sends the decision back to the server (`remoteExec [..., 2]`) which runs the existing crash/capture/apply logic (Save/Restore extracted into `AE3_armaos_fnc_module_saveLaptopApply` / `_restoreLaptopApply`). Save/Restore let the curator name/pick a slot they previously could not set in Zeus. Restore builds a COMBO from the actual stored keys of `AE3_LAPTOP_SAVES` (a name-keyed HashMap, so multiple named saves coexist), sorted ascending; slot names are `trim`med on both save and restore so trailing spaces cannot desync the key. The hardcoded `slot1` fallback only applies to the non-ZEN Eden-attribute path.

## decisions

- Shared Zeus infrastructure lives in `addons/main` even when it manipulates filesystem, power, network, or ArmaOS state, because curator UI flows need one place for dialogs, validation, feedback, and object operation helpers.
- Eden connections are used for persistent graph-like power/network links, while Zeus uses modules and dialogs for runtime linking. Eden needs visible saved connection lines; Zeus needs a curated runtime workflow with validation and feedback.
- Content/intel modules are split by audience. Eden modules expose many detailed fields, while Zeus often uses consolidated runtime dialogs.
- Attribute expressions write directly to object variables; those variables are the contract consumed by init functions across components.

## gotchas

- Zeus module functions often run locally on the curator machine first, then call server-authoritative operations.
- Synchronized-object order matters for connection modules. Add Connection stores first synced object as `entity1` and second as `entity2`, with an optional switch flag.
- `scope` and `scopeCurator` must be checked separately when documenting modules. Some module classes use `scope = 2` with `scopeCurator = 0`, while `AE3_AddIntel` is curator-visible but hidden in Eden.
- Class validation for Zeus network connections is currently a fixed class-name list, now living in the shared `fnc_zeus_applyConnection.sqf` (extracted from `fnc_zeus_module_addConnection.sqf` so both the legacy dialog and the ZEN dialog reuse it).
- ZEN builders run on the curator's machine. For the dialog modules the module logic is curator-local (same as the legacy handlers, which `deleteVehicle` on the curator). For the no-dialog modules the effect stays server-authoritative and the module is deleted server-side via `remoteExec [..., 2]`. ZEN's `zen_dialog_fnc_create` no-ops on headless (`!hasInterface`), so `owner _module` must resolve to a real curator client.
- The generators were the only AE3 assets built on a vehicle base (`B_Radar_System_01_F`), and that is why they went missing from the asset browsers. Measured behaviour, by probe classes in Eden:
  - **Neither browser will put an `AllVehicles` class in its Empty list.** Eden files such an entity under the side it declares; a probe with `side = 4` appeared in *no* list at all, and the curator browser rejects any side outside `0`-`3` (`zen/addons/faction_filter/XEH_preStart.sqf` mirrors that check). `faction` and `editorCategory` do not override this - a probe with `faction = "Default"` plus the pre-redesign `EdCat_Things`/`EdSubcat_Electronics` still came up under BLUFOR.
  - Stripping weapons, countermeasures, crew or cargo off the vehicle base changes nothing; those probes all stayed in BLUFOR.
  - Only a prop base reaches Empty. So `GeneratorMaster_01_F_AE3` now inherits the vanilla `Land_PortableGenerator_01_F` prop, declares no `side` or `faction`, and `editorCategory`/`editorSubcategory` gather the 7 classes under the Advanced Equipment entry beside the prop-based assets.
  - The price is engine fuel, which is `AllVehicles`-only - see [[power-model]] for where a generator's fuel level lives now.
  - The old master also hid its children from Eden outright, not just from Empty: a probe deriving from it appeared in no list while an otherwise identical probe one level up the chain appeared in BLUFOR. Removing the radar-neutering overrides resolved it; no single one of `Attributes`, `Components` or `Turrets` was responsible on its own.
- Power devices expose `Powered On At Start` in Eden through the shared `AE3_POWER_STARTON_ATTRIBUTE` macro, and the same state through a `Powered On` checkbox in the Zeus asset panel. Before that the only way to switch a battery or generator on was the ACE interaction on the object. See [[power-model]].
- ZEN row labels use literal English strings (not stringtable keys) to avoid stringtable churn; titles reuse the existing `STR_AE3_*` module display-name keys (ZEN auto-localizes localized keys and uppercases titles).

## non-ZEN curator fallback dialogs

Zeus modules that need curator input must work **without** Zeus Enhanced. Two patterns exist:

- **curatorInfoType dialog** (e.g. `AE3_AddUser`): engine auto-opens a `CfgUserInterfaceZeus` dialog on the curator; `function` guards with `if (isCuratorPlaced) exitWith {false}`. Good when no server-side data is needed.
- **server-push dialog** (Save/Restore Laptop, Add Website): the module `function` runs on the server, resolves data (laptops, save-slot list, which the curator does not have), then `remoteExec`s a curator-side opener to `owner _module`. The opener stashes netIds in `uiNamespace` and `createDialog`s a `CfgUserInterfaceZeus` dialog whose `onUnload` sends the choice back via `remoteExec [..., 2]`. Do **not** also set `curatorInfoType` on these, or two dialogs open.
- Dispatch picks ZEN vs built-in with `[QFUNC(zeus_*), QFUNC(zen_*)] select (EGVAR(main,hasZenDialog))`. The `*Apply` workers accept objects **or** netIds so both paths share them.
- `AE3_AddWebsite` uses curatorInfoType (`AE3_UserInterface_Zeus_Module_AddWebsite`, in `desktop/CfgUserInterfaceZeus.hpp`) since it needs no server data; its `fnc_zeus_module_addWebsite` hands off to the ZEN dialog in `onLoad` when present.
- `AE3_SaveLaptop`/`AE3_RestoreLaptop` use server-push (`fnc_zeus_module_saveLaptop`/`restoreLaptop`, dialogs in `armaos/CfgUserInterfaceZeus.hpp`). Restore's combo is filled by the opener from the server-provided slot list.

## re-verify when

- Any module class, Zeus dialog, Cfg3DEN connection, object attribute, or Zeus filesystem browser function changes.

## references

- `addons/main/Cfg3DEN.hpp`
- `addons/main/CfgUserInterfaceZeus.hpp`
- `addons/main/functions/fnc_zeus_module_addConnection.sqf`
- `addons/main/functions/fnc_zeus_openFilesystemBrowser.sqf`
- `addons/armaos/CfgVehicles.hpp`
- `addons/desktop/CfgVehicles.hpp`
- `addons/filesystem/CfgVehicles.hpp`

