# Zeus API

Most Zeus functionality should be used through curator modules and object attribute dialogs, not direct script calls. This page documents the useful framework hooks and the module/helper functions developers may need to understand when extending curator workflows.

## Zeus Modules

| Module class | Availability | Purpose |
| --- | --- | --- |
| `AE3_AddConnection` | Zeus | Curator dialog for connecting power/network objects. |
| `AE3_AddIntel` | Zeus | Curator dialog for planting one intel item on the laptop under the module. |
| `AE3_InterfaceAccess` | Zeus | Curator dialog for changing GUI/TUI interface access. |
| `AE3_CrashDevice` | Zeus/Eden config class, Zeus-oriented workflow | Crash a device live. |
| `AE3_AddUser` | Eden/Zeus | Add a laptop user. |
| `AE3_AddFile` | Eden/Zeus | Add a file. |
| `AE3_AddDir` | Eden/Zeus | Add a directory. |
| `AE3_AddCalendarEvent` | Eden/Zeus | Add a calendar event. |
| `AE3_NetworkSpeed` | Eden/Zeus | Set network transfer speed for a router (wifi network), computer, or user accounts on it. In Zeus, drop it onto the router or computer. |

Zeus module functions are normally invoked by the engine when a curator places a module. Call the lower-level Reference APIs for script setup whenever possible.

## Device Operation Helpers

These functions back Zeus actions and dialogs:

| Function | Purpose |
| --- | --- |
| `AE3_main_fnc_zeus_turnOnDevice` | Zeus-facing wrapper for turning a device on. |
| `AE3_main_fnc_zeus_turnOffDevice` | Zeus-facing wrapper for turning a device off. |
| `AE3_main_fnc_zeus_standbyDevice` | Zeus-facing wrapper for standby. |
| `AE3_main_fnc_zeus_openObject` | Opens/animates an object through Zeus action flow. |
| `AE3_main_fnc_zeus_closeObject` | Closes/animates an object through Zeus action flow. |
| `AE3_main_fnc_zeus_connectToRouter` | Connects a selected object to a router. |
| `AE3_main_fnc_zeus_disconnectFromRouter` | Disconnects a selected object from a router. |
| `AE3_main_fnc_zeus_deviceOpServer` | Server-side device operation dispatcher. |
| `AE3_main_fnc_zeus_deviceOpFeedback` | Sends curator feedback for a device operation. |

For scripts, prefer the component APIs:

```sqf
[_device] call AE3_power_fnc_turnOnDevice;
[_device] call AE3_power_fnc_turnOffDevice;
[_device, _router] call AE3_network_fnc_createNetworkConnection;
[_device] call AE3_network_fnc_disconnect;
```

## Filesystem Browser Helpers

The Zeus filesystem browser is implemented with a set of UI callbacks:

| Function | Purpose |
| --- | --- |
| `AE3_main_fnc_zeus_openFilesystemBrowser` | Opens the curator filesystem browser for a laptop. |
| `AE3_main_fnc_zeus_filesystemBrowser_init` | Initializes browser display state. |
| `AE3_main_fnc_zeus_filesystemBrowser_refresh` | Refreshes current folder. |
| `AE3_main_fnc_zeus_filesystemBrowser_populateTree` | Builds the displayed tree/list. |
| `AE3_main_fnc_zeus_filesystemBrowser_createFile` | Creates a file through the browser UI. |
| `AE3_main_fnc_zeus_filesystemBrowser_createFolder` | Creates a folder through the browser UI. |
| `AE3_main_fnc_zeus_filesystemBrowser_saveFile` | Saves edited file content. |
| `AE3_main_fnc_zeus_filesystemBrowser_delete` | Deletes selected content. |
| `AE3_main_fnc_zeus_filesystemBrowser_rename` | Renames selected content. |
| `AE3_main_fnc_zeus_filesystemBrowser_move` | Moves selected content. |
| `AE3_main_fnc_zeus_filesystemBrowser_applyChanges` | Applies filesystem changes back to the object. |
| `AE3_main_fnc_zeus_filesystemBrowser_onUnload` | Cleans display state on close. |

Addon developers should treat these as UI internals. To add content from code, use [Filesystem API](Filesystem-API.md) or higher-level Desktop APIs.

## Content Module Backing Functions

| Function | Module/workflow |
| --- | --- |
| `AE3_main_fnc_zeus_module_addUser` | Zeus Add User. |
| `AE3_main_fnc_zeus_module_addCalendarEvent` | Zeus Add Calendar Event. |
| `AE3_main_fnc_zeus_module_addFile` | Zeus Add File. |
| `AE3_main_fnc_zeus_module_addDir` | Zeus Add Directory. |
| `AE3_main_fnc_zeus_module_addConnection` | Zeus Add Connection. |
| `AE3_desktop_fnc_zeus_module_addIntel` | Zeus Add Intel dialog handling. |
| `AE3_desktop_fnc_zeus_module_interfaceAccess` | Zeus Interface Access dialog handling. |

For scripted setup, use:

```sqf
[_laptop, "admin", "password"] call AE3_armaos_fnc_computer_addUser;
[_laptop, "intel.root/page", "02:47"] call AE3_desktop_fnc_addHistoryEntry;
[_laptop, "informant", "Subject", "Body"] call AE3_desktop_fnc_addEmail;
```

## Zeus Object Checks

| Function | Purpose |
| --- | --- |
| `AE3_main_fnc_zeus_checkForComputer` | Validates selected/synced object is an AE3 computer. |
| `AE3_main_fnc_zeus_isConnectionAllowed` | Checks whether a connection operation is valid. |
| `AE3_main_fnc_zeus_initAttributes` | Initializes Zeus attribute UI for AE3 objects. |
| `AE3_main_fnc_zeus_updateAttributes` | Applies updated Zeus attributes. |

Use these only when extending Zeus UI. They assume curator display context.

## Adding Custom Zeus Workflows

Recommended pattern for addon developers:

1. Create a normal module class in your addon config.
2. Use a module function that validates the synced object or object under the module.
3. Call AE3 public APIs for the actual work.
4. Show curator feedback with standard Arma/CBA feedback or AE3 helper feedback when appropriate.

Example module function body:

```sqf
params ["_logic", "_units", "_activated"];
if (!_activated || {!isServer}) exitWith {};

private _laptop = (_units select { _x isKindOf "Land_Laptop_03_sand_F_AE3" }) param [0, objNull];
if (isNull _laptop) exitWith {};

[_laptop, "admin", "mission"] call AE3_armaos_fnc_computer_addUser;
[_laptop, "intel.root/live", "Curator planted this page.", _laptop] call AE3_desktop_fnc_registerWebpage;
```

## Related Pages

- [Zeus Guide](../Zeus-Guide.md)
- [Desktop API](Desktop-API.md)
- [Filesystem API](Filesystem-API.md)
- [Power API](Power-API.md)
- [Network API](Network-API.md)
