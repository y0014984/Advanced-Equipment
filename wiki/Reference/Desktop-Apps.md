# Desktop Apps

AE3 supports two app-extension models:

| Model | Use when | Main API/config |
| --- | --- | --- |
| Native SQF desktop app | You want to build controls directly in Arma UI. | `CfgAE3Apps` or `AE3_desktop_fnc_registerApp`. |
| Web desktop extension | You want to extend the CEF/web desktop bridge with a JS-facing app template and SQF commands. | `AE3_desktop_fnc_registerExtApp`, `AE3_desktop_fnc_registerCmd`, `AE3_desktop_fnc_jsReply`. |

Most new low-level AE3-native apps should use the native SQF model unless they specifically need the web desktop bridge.

A third option exists for a whole app of your own: register it as the `script` kind through
`AE3_desktop_fnc_registerExtApp` with a `scriptPath` and a `factory`, and the web desktop loads that JS
file from your own PBO and asks the factory for the app. The games component is built that way - eight
apps sharing one bundle, each told apart by an `extra.gameId`, talking to the server through its own
`registerCmd` commands. See [Games](../Systems/Games.md) and `addons/games/functions/fnc_registerApps.sqf`.

## Native Config Apps

Apps can be defined in config:

```cpp
class CfgAE3Apps
{
    class myMod_tools
    {
        displayName = "Tools";
        entry = "myMod_fnc_toolsApp";
        icon = "";
        defaultSize[] = {0.55, 0.5};
        showOnDesktop = 1;
        singleton = 1;
        requiresFilesystem = 1;
    };
};
```

Common properties:

| Property | Type | Meaning |
| --- | --- | --- |
| `displayName` | String | Name shown to players. |
| `entry` | String | SQF function called to build the window. |
| `icon` | String | Optional icon path. |
| `defaultSize[]` | Array | Window width/height as desktop fractions. |
| `showOnDesktop` | Number/bool | Whether an icon appears on the desktop. |
| `singleton` | Number/bool | Whether only one instance may be open. |
| `requiresFilesystem` | Number/bool | Whether the app needs the laptop filesystem. |

## Native Runtime Apps

Use runtime registration for mission-specific apps or addon apps that should not require a config patch:

```sqf
if (hasInterface) then {
    ["myMod_tools", "Tools", "myMod_fnc_toolsApp", [0.55, 0.5], true, true] call AE3_desktop_fnc_registerApp;
};
```

Runtime registration is local. Run it on every client that should see the app.

## Native App Entry Contract

Native app entry functions receive:

```sqf
params ["_winId", "_ctrlGroup", "_computer", "_args"];
```

| Parameter | Meaning |
| --- | --- |
| `_winId` | AE3 window id. Use it when calling window-manager functions. |
| `_ctrlGroup` | Control group where the app should create its controls. |
| `_computer` | Laptop object for this desktop session. |
| `_args` | Optional arguments passed when the app is opened. |

Return value may be a HashMap with callbacks:

```sqf
createHashMapFromArray [
    ["onClose", {
        // Cleanup code.
    }]
]
```

Minimal app:

```sqf
myMod_fnc_toolsApp = {
    params ["_winId", "_ctrlGroup", "_computer", "_args"];

    private _text = _ctrlGroup ctrlCreate ["RscText", -1];
    _text ctrlSetPosition [0.02, 0.02, 0.5, 0.05];
    _text ctrlSetText "Tools ready.";
    _text ctrlCommit 0;

    createHashMap
};
```

## Opening Files from Apps

Use:

```sqf
[_computer, _path, _user] call AE3_desktop_fnc_openFile;
```

This lets the desktop choose the correct viewer for text, media markers, locked files, and app launchers. Prefer it over duplicating file-open logic.

## Window Manager Helpers

The Desktop component exposes window manager functions used by built-in apps:

| Function | Purpose |
| --- | --- |
| `AE3_desktop_fnc_wm_createWindow` | Creates a desktop app window. |
| `AE3_desktop_fnc_wm_closeWindow` | Closes a window and runs cleanup. |
| `AE3_desktop_fnc_wm_focusWindow` | Brings a window to the front. |
| `AE3_desktop_fnc_wm_minimizeWindow` | Minimizes/restores a window. |
| `AE3_desktop_fnc_wm_getTheme` | Reads active desktop theme. |
| `AE3_desktop_fnc_wm_updateTaskbar` | Refreshes taskbar state. |

These are framework-level functions. If you are writing a normal app, build controls inside the supplied `_ctrlGroup` and let AE3 manage the window shell.

## Web Desktop Extension Apps

Register a web desktop device-list app template:

```sqf
if (hasInterface) then {
    private _extra = createHashMapFromArray [
        ["deviceType", "doorRelay"],
        ["requiresFunction", "myMod_fnc_canShowDoorTools"]
    ];

    ["myMod_doors", "Door Relays", "D", "deviceList", _extra] call AE3_desktop_fnc_registerExtApp;
};
```

Register a desktop-visible launcher for existing apps:

```sqf
if (hasInterface) then {
    private _extra = createHashMapFromArray [
        ["showOnDesktop", true],
        ["menu", "Tools"],
        ["launchApps", [["myMod_doors", "Door Relays"]]],
        ["openCommand", "myMod_launcherOpened"]
    ];

    ["myMod_tools", "Tools.exe", "T", "launcher", _extra] call AE3_desktop_fnc_registerExtApp;
};
```

The web desktop replaces existing external app registrations with the same id and removes external apps that are absent from a later `ext_apps` push. This lets addons hide USB- or state-dependent apps while the desktop is already open. Files in a user Desktop folder launch apps when their resolved file content is `app=<id>`, so addons can create visible filenames such as `Tools.exe` while still targeting a registered app id. `iconPath` values are loaded through the AE3 texture bridge, which supports PAA mod textures in the web desktop.

Register a JS-to-SQF command:

```sqf
if (hasInterface) then {
    ["myMod_listDoors", {
        params ["_computer", "_user", "_data", "_rid"];

        private _doors = missionNamespace getVariable ["myMod_doors", []];
        ["myMod_listDoors", _rid, _doors] call AE3_desktop_fnc_jsReply;
    }] call AE3_desktop_fnc_registerCmd;
};
```

Web command handlers receive:

| Parameter | Meaning |
| --- | --- |
| `_computer` | Laptop bound to the web desktop session. |
| `_user` | Logged-in desktop user. |
| `_data` | Payload sent from JS. |
| `_rid` | Request id used to resolve the JS promise. |

Use `AE3_desktop_fnc_jsReply` for immediate replies. Use `AE3_desktop_fnc_jsSend` from internal/client code for asynchronous pushes when no request id is being resolved.

## App Launcher Files

Desktop icons can come from virtual filesystem launcher files. AE3 seeds app launchers under:

```text
/usr/share/applications/<appId>.app
```

A launcher file contains:

```text
app=<appId>
```

User desktops can then contain symlinks to those launchers:

```text
/home/admin/Desktop/terminal.app -> /usr/share/applications/terminal.app
```

This lets mission authors curate which tools appear for each user by changing the user's Desktop folder.

## Checklist for New Native Apps

1. Decide whether the app is config-level or runtime-only.
2. Register the app on all clients that should see it.
3. Build controls only inside the provided `_ctrlGroup`.
4. Read laptop state from `_computer`; do not assume global variables identify the active laptop.
5. Use public filesystem/Desktop APIs for file operations.
6. Return an `onClose` callback if you create handlers, cameras, timers, or long-lived controls.
7. Test with two clients so singleton, focus, and close behavior are correct.

## Related Pages

- [Desktop API](Desktop-API.md)
- [Extending Desktop GUI](../Developer/Extending-Desktop-GUI.md)
- [Extending Browser Webpages](../Developer/Extending-Browser-Webpages.md)
