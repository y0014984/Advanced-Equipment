# API Overview

This section documents the script-facing surface of Advanced Equipment. It is meant for mission framework authors, addon developers, and mission makers who are comfortable writing SQF. Player-facing and no-code Eden/Zeus workflows live in the audience guides and examples.

The API is split by addon component:

| Component | Prefix | Main responsibility |
| --- | --- | --- |
| ArmaOS | `AE3_armaos_fnc_*` | Terminal/TUI users, shell commands, command links, terminal output, games, laptop state. |
| Desktop | `AE3_desktop_fnc_*` | GUI desktop, apps, web bridge, browser, mail, chat, media, calendar, interface access. |
| Filesystem | `AE3_filesystem_fnc_*` | Virtual filesystem, paths, permissions, files, directories, mounts, symlinks. |
| Flashdrive | `AE3_flashdrive_fnc_*` | USB interfaces, inventory/world flash drives, mount and unmount behavior. |
| Interaction | `AE3_interaction_fnc_*` | ACE actions, laptop lid animation, desks, lamps, interaction state. |
| Main | `AE3_main_fnc_*` | Shared helpers, Zeus helpers, debug helpers, remote variable helpers. |
| Network | `AE3_network_fnc_*` | Routers, DHCP, IP conversion, routing, external access policy, SSH/message routing. |
| Power | `AE3_power_fnc_*` | Power states, generators, batteries, solar panels, power links, device shutdown/crash. |

## What Counts as Public

The repository compiles many functions for internal UI callbacks, event handlers, Zeus dialogs, and Eden attributes. The Reference pages document functions that are useful from mission scripts, addon integrations, or framework extensions.

Functions not documented here may still be callable, but they should be treated as implementation details unless a Developer guide explicitly instructs you to use them. Internal functions often assume a prepared display, mutex, object variable, filesystem shape, or server locality that a mission script will not normally have.

## Locality Model

For mission setup, prefer server-side initialization:

```sqf
if (isServer) then {
    [_laptop, "admin", "swordfish"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, "both"] call AE3_desktop_fnc_setInterfaceMode;
    [_laptop, _router] call AE3_network_fnc_createNetworkConnection;
    [_laptop, _generator] call AE3_power_fnc_createPowerConnection;
};
```

This pattern keeps ownership clear because most durable state lives on objects with `setVariable` and is then broadcast or pulled by clients. Several Desktop, Power, and Network APIs can be called from clients and route work to the server internally, but the server remains the authoritative place for mission-created users, filesystem content, power links, and network links.

Use client-side calls for local presentation or local registration:

```sqf
if (hasInterface) then {
    ["myMod_tool", "Tool", "myMod_fnc_toolApp", [0.55, 0.5]] call AE3_desktop_fnc_registerApp;
};
```

Runtime desktop app registration is local because every client builds its own GUI. Server-only code cannot create a client app icon by itself.

## Common Target Forms

Several Desktop intel/content functions accept more than one target form:

| Target | Meaning |
| --- | --- |
| Laptop object | Apply only to that laptop. |
| Laptop `netId` string | Resolve the object from the network id and apply to it. Useful when data crosses UI or event boundaries. |
| Array of laptop objects | Apply to each laptop in the array. |
| `"all"` | Apply to every initialized AE3 computer. |
| `"future"` | Used by media registration. Applies to current initialized computers and to computers initialized later. |

Read each function entry because not every API accepts every form.

## Filesystem Shape

The virtual filesystem is an array:

```sqf
[contentHashMap, ownerName, permissions]
```

File entries may carry an optional fourth element, the virtual size in bytes (`[content, owner, permissions, size]`); read it with `AE3_filesystem_fnc_getFileSize`.

Each hash map entry is another filesystem object. Directories store a hash map as their content. Files store strings, code, media markers, symlink markers, or other values expected by the relevant app.

Permissions are:

```sqf
[[ownerRead, ownerWrite, ownerExecute], [everyoneRead, everyoneWrite, everyoneExecute]]
```

Permission indexes used by low-level calls are:

| Index | Permission |
| --- | --- |
| `0` | Read |
| `1` | Write |
| `2` | Execute |

Most direct filesystem functions mutate the filesystem array in place. After changing a laptop filesystem manually, publish it back to the laptop:

```sqf
_laptop setVariable ["AE3_filesystem", _filesystem, true];
```

This is only safe while nobody is using the laptop (the user's client holds the live copy during a session). To write a file from a script use `AE3_filesystem_fnc_device_writeFile`, which handles that.

When possible, use higher-level Desktop or ArmaOS APIs instead of editing the filesystem directly. They handle folder creation, notifications, target resolution, and JIP state for you.

## Path Rules

AE3 paths are Unix-like:

| Form | Meaning |
| --- | --- |
| `/home/admin/file.txt` | Absolute path from filesystem root. |
| `notes.txt` | Relative path from the current pointer. |
| `../logs` | Parent-relative path. |
| `~` | User home directory where supported by the function/command. |

When writing setup scripts, absolute paths are easier to debug.

## Error Handling

Low-level filesystem calls throw localized exceptions for expected filesystem failures such as missing objects, duplicate paths, and permission failures. Wrap direct filesystem work in `try`/`catch` when you want a mission script to continue after a failed write:

```sqf
try {
    [[], _filesystem, "/home/admin/orders.txt", "Orders", "root", "admin"] call AE3_filesystem_fnc_createFile;
} catch {
    diag_log format ["AE3 setup failed while writing orders.txt: %1", _exception];
};
```

Convenience functions such as `AE3_filesystem_fnc_ensureFile`, `AE3_filesystem_fnc_ensureDir`, and several Desktop content APIs are better for idempotent mission init because they tolerate existing content more cleanly.

## Initialization Timing

Laptops, routers, power devices, and flash drives are initialized by Extended Event Handlers. If your script runs very early, wait until the relevant state exists before writing to it.

Useful checks:

```sqf
waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };
waitUntil { _laptop getVariable ["AE3_power_initDone", false] };
waitUntil { _router getVariable ["AE3_network_isRouter", false] };
```

For many normal mission scripts, placing setup code in server init after objects exist is enough. For addon code that reacts to spawned objects, use CBA waits or class event handlers.

## Multiplayer Rules

Use these defaults unless a function page says otherwise:

| Work | Recommended locality |
| --- | --- |
| Add users, files, email, pages, history, media markers | Server |
| Connect power or network devices | Server |
| Register native desktop apps | Each client that should see the app |
| Register web desktop commands | Each client running the web desktop bridge |
| Read route/power status for UI | Client may call read helpers; server is authoritative for state changes |
| Modify object variables directly | Server, with explicit public flag or target locality |

For dedicated servers, do not assume a player client and server share local object state immediately. If a function already routes to the server, prefer calling that function over setting the variable yourself.

## Main Component Helpers

A handful of `AE3_main_fnc_*` functions are generally useful and don't fit under a bigger component page:

### `AE3_main_fnc_hasCapability`

Checks a capability flag set during device init, instead of probing object variables directly to guess a device's type.

```sqf
if ([_object, "hasTerminal"] call AE3_main_fnc_hasCapability) then { ... };
```

Capabilities: `"hasTerminal"`, `"hasFilesystem"`, `"isNetworkClient"`, `"isRouter"`, `"hasUsb"`, `"hasBattery"`, `"hasFuelTank"`.

### `AE3_main_fnc_terminateDevice`

Turns a device off and removes all its power and network connections (both directions), then cleans up flash-drive tracking. Triggered automatically when Zeus deletes an asset; call it manually when your own script deletes an AE3 device.

```sqf
[_laptop] call AE3_main_fnc_terminateDevice;
```

Call this before `deleteVehicle`-ing an AE3 device so connected power/network devices don't keep a dangling reference.

### `AE3_main_fnc_getPlayersInRange`

Returns players within a radius of an object. Used internally for UI-on-texture viewer-count throttling; useful if your own addon needs the same "who's near this laptop" check.

```sqf
private _nearby = [50, _laptop] call AE3_main_fnc_getPlayersInRange;
```

### `AE3_main_fnc_waitForFilesystem`

Deprecated — kept for external API compatibility. Prefer `AE3_armaos_fnc_device_ensureInit`, which doesn't block a scheduled thread waiting on a variable.

```sqf
private _ready = [_computer, 15] call AE3_main_fnc_waitForFilesystem;
```

## Reference Index

- [ArmaOS API](ArmaOS-API.md)
- [Desktop API](Desktop-API.md)
- [Browser API](Browser-API.md)
- [Filesystem API](Filesystem-API.md)
- [Flashdrive API](Flashdrive-API.md)
- [Interaction API](Interaction-API.md)
- [Network API](Network-API.md)
- [Power API](Power-API.md)
- [Zeus API](Zeus-API.md)
- [Terminal Commands](Terminal-Commands.md)
- [Desktop Apps](Desktop-Apps.md)
- [Config Classes](Config-Classes.md)
- [Eden Attributes](Eden-Attributes.md)
