# Locality and Multiplayer

AE3 is multiplayer-oriented. The mod works best when durable state is changed on the server, while display state is built on the client that owns the UI. This page describes the practical rules for writing scripts and addon integrations that work in hosted multiplayer, dedicated servers, JIP, and Zeus.

## Core Rule

Use server-side code for state. Use client-side code for presentation.

| Work | Preferred locality |
| --- | --- |
| Add users | Server |
| Add files/directories | Server |
| Add browser pages/history to laptops | Server |
| Add emails, media, locked files | Server |
| Connect power/network devices | Server |
| Turn devices on/off | Server or public API that routes to server |
| Register native desktop apps | Each client |
| Register web desktop commands | Each client |
| Open a GUI/terminal display | Client |
| Create controls, windows, cameras, render targets | Client |

## Object State

AE3 stores important state on objects with `setVariable`. When state must be visible to clients or JIP players, it must be public or sent to the right target.

Examples:

```sqf
_laptop setVariable ["AE3_interfaceMode", "both", true];
_laptop setVariable ["AE3_Userlist", _userlist, true];
_flashdrive setVariable ["AE3_filesystem", _filesystem, 2];
```

The public flag/target matters:

| Third argument | Meaning |
| --- | --- |
| `true` | Broadcast to all machines and JIP. |
| `false` or omitted | Local only. |
| `2` | Server target. |
| `[clientOwner, 2]` | Specific client plus server. |

Do not broadcast large data every frame. Filesystems can be large; update them deliberately.

## Server Init Pattern

Mission setup:

```sqf
if (isServer) then {
    waitUntil { !isNil { _laptop getVariable "AE3_filesystem" } };

    [_laptop, "admin", "password"] call AE3_armaos_fnc_computer_addUser;
    [_laptop, "both"] call AE3_desktop_fnc_setInterfaceMode;
    [_router, "Depot Net", 100, "depot", "10.0.0.1", false, ""] call AE3_network_fnc_applyRouterConfig;
    [_laptop, _router] call AE3_network_fnc_createNetworkConnection;
    [_laptop, _generator] call AE3_power_fnc_createPowerConnection;
};
```

For Eden-authored content, modules and custom connections handle most setup automatically.

## Client Registration Pattern

Desktop app registration:

```sqf
if (hasInterface) then {
    ["myMod_tools", "Tools", "myMod_fnc_toolsApp", [0.55, 0.5], true, true] call AE3_desktop_fnc_registerApp;
};
```

Web desktop command registration:

```sqf
if (hasInterface) then {
    ["myMod_scan", {
        params ["_computer", "_user", "_data", "_rid"];
        ["myMod_scan", _rid, []] call AE3_desktop_fnc_jsReply;
    }] call AE3_desktop_fnc_registerCmd;
};
```

These calls are local because the desktop is created locally for each player.

## Routing Client Requests to Server

Some public APIs already route from clients to the server. Examples include several Desktop content functions, interface access/mode setters, and power crash behavior.

When writing your own extension, use CBA events or `remoteExecCall` for state changes:

```sqf
["myMod_server_setDoor", [_door, true]] call CBA_fnc_serverEvent;
```

Server registration:

```sqf
if (isServer) then {
    ["myMod_server_setDoor", {
        params ["_door", "_open"];
        _door setVariable ["myMod_open", _open, true];
    }] call CBA_fnc_addEventHandler;
};
```

Prefer CBA events when the event is part of your addon API. Use `remoteExecCall` for simple direct calls to known functions.

## JIP Considerations

A joining player needs current state:

- Laptop filesystem.
- User list.
- Interface mode/access.
- Power state.
- Network IP/router state.
- Registered global media/pages where relevant.

If you use public APIs and public object variables, most JIP state is handled. If you set local variables or register client-only data, new clients will not have it.

For client-only app registration, run registration from addon init so JIP clients execute it locally when they load in.

## Mutex and In-Use State

Laptops use a mutex-like variable to prevent multiple active sessions fighting over the same terminal/desktop state.

Relevant variable:

```sqf
AE3_computer_mutex
```

If a laptop is in use, open/close/power actions may be blocked. Do not force-close displays by deleting variables unless you are writing recovery/debug code. Use public power/interaction/session flows where possible.

## Worked Example: A Game Between Two Computers

The games component (`addons/games`) is the most complete example of this page's rules in one place,
and worth copying from:

- Match state is a **server-only** `missionNamespace` HashMap that is never broadcast and never sent
  whole to a client. Every mutating function opens with
  `if (!isServer) exitWith {[...] call CBA_fnc_serverEvent}`.
- A seat is keyed by the device's `netId`, not by a player, so a player closing the application,
  switching the laptop off, dying or reconnecting does not disturb the match. Resuming is a lookup, not
  a rejoin.
- Each seated device is sent only what its own seat may see, as a **JSON string** through
  `CBA_fnc_ownerEvent` to the machine `AE3_armaos_fnc_computer_getLocality` reports for that device - a
  HashMap would arrive empty on a dedicated server. A device nobody is using is skipped, not queued.
- Every move is re-validated server side: the right device, the right machine, powered on, a live mutex
  holder, the route to the host still resolving, and only then the game's rules.
- Status text crosses as a stringtable key and is localized on the client, because the server may run
  another language.
- The periodic handler is registered when the first match starts and removed with the last one, so an
  idle mission runs none of this code.

## Dedicated Server Pitfalls

| Pitfall | Fix |
| --- | --- |
| UI code runs on server | Guard with `hasInterface`. |
| Server script tries to create controls | Move display code to client. |
| Client edits filesystem locally | Route edit to server or use public API. |
| App icon missing for JIP client | Register runtime app in client init instead of only during mission start on one client. |
| Static IP works in editor but not dedicated | Ensure network connection and router init complete before setting IP. |
| Flash drive state disappears | Mount/unmount on server-aware APIs and publish flash drive filesystem. |

## Testing Checklist

For multiplayer-sensitive changes:

1. Test in singleplayer/editor.
2. Test hosted multiplayer.
3. Test dedicated server with at least two clients if state is shared.
4. Test JIP after laptop content has been created.
5. Test two players trying to open the same laptop.
6. Test power loss while GUI/TUI is open.
7. Test router off/on and IP reacquisition.
8. Test flash drive mount/unmount after JIP.

## Related Pages

- [Architecture](Architecture.md)
- [Debugging](Debugging.md)
- [API Overview](../Reference/API-Overview.md)
