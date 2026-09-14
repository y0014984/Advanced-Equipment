# Config Classes

This page documents the config surfaces addon developers are most likely to extend. It is not a full dump of every class in the mod; it focuses on usable integration points.

## Addon Component Layout

Each addon component typically has:

```text
addons/<component>/
  config.cpp
  script_component.hpp
  XEH_PREP.hpp
  XEH_preInit.sqf
  functions/fnc_*.sqf
  CfgVehicles.hpp
  stringtable.xml
```

Functions are compiled through `XEH_PREP.hpp` and PREP macros. Do not use `execVM` to call component files directly.

## Equipment Classes

AE3 equipment is usually defined through config blocks under a vehicle/object class.

Common blocks:

| Block | Purpose |
| --- | --- |
| `AE3_Equipment` | Interaction/display behavior for a physical object. |
| `AE3_Device` | Power/device behavior. |
| `AE3_InternalDevice` | Internal battery or internal component. |
| `AE3_USB_Interface` | USB port definitions for flash drives. |
| `AE3_Consumer` | Power draw settings inside `AE3_Device`. |
| `AE3_PowerInterface` | Provider/consumer connection metadata. |
| `AE3_Battery` | Battery capacity/recharge/initial level. |

Laptop classes use these blocks to combine interaction, power, filesystem initialization, network behavior, and USB interfaces.

## Laptop Attribute Example

Laptop variants inherit from Arma laptop classes and define AE3 behavior:

```cpp
class Land_Laptop_03_black_F_AE3: Land_Laptop_03_black_F
{
    ae3_item = "Item_Laptop_AE3";
    scopeCurator = 2;
    editorCategory = "AE3_Assets";

    class AE3_Equipment
    {
        displayName = "Laptop";
        init = "call AE3_interaction_fnc_initLaptop;";
        openAction = "call AE3_interaction_fnc_laptop_open;";
        closeAction = "call AE3_interaction_fnc_laptop_close;";
    };

    class AE3_Device
    {
        defaultPowerLevel = 0;
        init = "(_this + [configFile >> 'AE3_FilesystemObjects']) call AE3_armaos_fnc_device_initComplete;";
        turnOnAction = "call AE3_network_fnc_dhcp_onTurnOn; call AE3_armaos_fnc_computer_turnOn;";
        turnOffAction = "call AE3_armaos_fnc_computer_turnOff;";

        class AE3_Consumer
        {
            powerConsumption = 0.01/3600;
            standbyConsumption = 0.0001/3600;
        };
    };
};
```

When extending this, keep behavior in functions and call those functions from config strings. That keeps config readable and makes validation easier.

## USB Interface Config

USB ports are named child classes:

```cpp
class AE3_USB_Interface
{
    class USB0
    {
        rel_pos[] = {-0.19, 0.042, -0.145};
        rot_yaw = 90;
        rot_pitch = 0;
        rot_roll = 0;
    };
};
```

Runtime interface data is stored on the laptop in `AE3_USB_Interfaces`.

## Filesystem Objects

Default laptop filesystem content comes from config under `AE3_FilesystemObjects`. The ArmaOS device initialization reads that config and creates the virtual filesystem.

Use filesystem modules or script APIs for mission-specific content. Use config defaults for addon-wide baseline content that should exist on every laptop of a given type.

Filesystem object concepts:

| Item | Meaning |
| --- | --- |
| Directory | HashMap-backed object. |
| File | String/code/marker-backed object. |
| Owner | User name assigned to object. |
| Permissions | Owner/everyone read/write/execute tuple. |

See [Filesystem API](Filesystem-API.md) for runtime shape and direct manipulation.

## Terminal Command Config

Terminal commands are config classes based on `OsFunction`.

```cpp
class OsFunction
{
    path = "";
    description = "";
    man = "";
    code = "";
};
```

Base commands live under `CfgOsFunctions`, optional security commands under `CfgSecurityCommands`, and games under `CfgGames`.

Example:

```cpp
class CfgOsFunctions
{
    class relayStatus: OsFunction
    {
        path = "/bin/relay";
        description = "Shows relay status.";
        man = "relay: prints relay status.";
        code = "call myMod_fnc_os_relay";
        sshCompatible = 1;
    };
};
```

Avoid square brackets in config strings where the existing command config warns against them.

## Desktop App Config

Native GUI apps can be registered in config with `CfgAE3Apps`.

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

Runtime alternative:

```sqf
["myMod_tools", "Tools", "myMod_fnc_toolsApp", [0.55, 0.5], true, true] call AE3_desktop_fnc_registerApp;
```

See [Desktop Apps](Desktop-Apps.md).

## Eden Modules

AE3 modules are normal `Module_F` classes. Current module classes include:

| Module class | Purpose |
| --- | --- |
| `AE3_AddUser` | Add laptop user. |
| `AE3_AddSudoer` | Give an existing account superuser rights (`/etc/sudoers`). |
| `AE3_AddCalendarEvent` | Add calendar event. |
| `AE3_SaveLaptop` | Save a laptop state. |
| `AE3_RestoreLaptop` | Restore a saved laptop state. |
| `AE3_AddFile` | Add a file. |
| `AE3_AddDir` | Add a directory. |
| `AE3_AddEmail` | Add email intel. |
| `AE3_AddWebpage` | Add browser page. |
| `AE3_AddBrowserHistory` | Add browser history. |
| `AE3_AddMedia` | Add media marker. |
| `AE3_AddPasswordedFile` | Add locked file. |
| `AE3_AddConnection` | Zeus connection workflow. |
| `AE3_InterfaceAccess` | Zeus interface access workflow. |
| `AE3_CrashDevice` | Crash device workflow. |
| `AE3_AddIntel` | Zeus dialog for planting one intel item (email, webpage, history, media, or locked file) on the laptop under the module. |

Module config uses attributes such as `function`, `isGlobal`, `isTriggerActivated`, `isDisposable`, `curatorInfoType`, and `ModuleDescription`.

For no-code use, see [Eden Attributes](Eden-Attributes.md) and [Eden Editor Guide](../Eden-Editor-Guide.md).

## Eden Connection Classes

AE3 adds custom 3DEN connection types:

```cpp
class AE3_PowerConnection
{
    displayName = "AE3: connect device to power source";
    data = "AE3_PowerConnection";
    expression = "[_entity0, _entity1] call AE3_power_fnc_createPowerConnection;";
};

class AE3_NetworkConnection
{
    displayName = "AE3: connect device to network router";
    data = "AE3_NetworkConnection";
    expression = "[_entity0, _entity1] call AE3_network_fnc_createNetworkConnection;";
};
```

These execute on mission start and create the runtime links.

## CBA Settings

All CBA settings AE3 registers, by component. All are configurable from the in-game CBA Settings menu (mission-side, doesn't require a script). Prefer CBA settings for mission/server policy and object attributes for per-object behavior.

### Main

| Setting | Type | Meaning |
| --- | --- | --- |
| `AE3_DebugMode` | Checkbox, default off | Extra internal-structure diagnostics. |
| `AE3_NetworkDebug` | Checkbox, default off | Logs AE3 `remoteExec` traffic to `diag_log`. Verbose — troubleshooting only. |
| `AE3_DeploymentType` | List, default Stable, **requires restart** | How laptop pickup/deployment works: **Stable** = simple hide/show with vanilla laptop items; **Experimental** = full state preservation with custom items. |

### ArmaOS (Terminal)

| Setting | Type | Meaning |
| --- | --- | --- |
| `AE3_AllowRootLogin` | Checkbox, default off | Default root login policy for laptops that don't set their own (Eden attribute *Direct root login*, or `AE3_armaos_fnc_computer_setRootLogin`). When off, use a regular user + `sudo` (see `/etc/sudoers`). |
| `AE3_DefaultRootPassword` | Editbox, default `toor` | Password of the `root` account every laptop is created with. A laptop's own root password overrides it. |
| `AE3_EnableErrorSound` | Checkbox, default on | Play an error sound on failed commands. |
| `AE3_TransferSpeedLocal` | Slider, default 20480 KB/s | Simulated local copy speed. `0` disables the simulated delay. |
| `AE3_TransferSpeedUsb` | Slider, default 2048 KB/s | Simulated USB flash drive transfer speed. |
| `AE3_TransferSpeedNetwork` | Slider, default 512 KB/s | Simulated network transfer speed (`ssh`, downloads). |
| `AE3_KeyboardLayout` | List, default US | Terminal keyboard layout: AR/DE/FR/HE/HU/IT/RU/TR/US. |
| `AE3_TerminalDesign` | List, default Light Mode | One of 20 terminal color schemes (C64, Apple II, Amber, Midnight Blue, Retro Red, TealTerm, Neon Violet, and more). |
| `AE3_TerminalScrollSpeed` | List, default 1 line | Lines scrolled per input tick. |
| `AE3_TerminalDefaultSize` | Slider, default 0.75 | Terminal font size (0.5-1.0). Players can also adjust with Ctrl+Plus/Minus in-game. |
| `AE3_StartupTime` | Slider, default 15s | Cold-boot animation duration (3-15s). Warm boot from standby is always 3s. |
| `AE3_ShutdownTime` | Slider, default 15s | Shutdown animation duration (1-15s). |
| `AE3_TerminalDialogTitle` | Editbox | Terminal window title text. Default `"SHITE™ COMPUTING"` — change this for mission immersion. |
| `AE3_TerminalBiosVersion` | Editbox | BIOS version line shown in the terminal header. |
| `AE3_TerminalCopyright` | Editbox | Copyright line shown in the terminal header. |
| `AE3_TerminalBootMessage` | Editbox | Boot message shown in the terminal header. |
| `AE3_TerminalTipMessage` | Editbox | Tip line shown in the terminal header. |
| `AE3_TerminalTagline` | Editbox | Tagline shown after the ASCII art. |
| `AE3_TerminalShowAsciiArt` | Checkbox, default on | Show ASCII art in the terminal header. |

The `AE3_Terminal*` text fields default to a placeholder in-joke branding ("SHITE™ Technologies") — override them per mission if you want a different in-universe computer brand, or leave them if the tone fits.

### UI-on-Texture (Terminal Rendering, ArmaOS)

Terminal content renders as text/array buffers synced to nearby clients and drawn locally — these settings tune that sync, and matter most on populated dedicated servers:

| Setting | Type | Meaning |
| --- | --- | --- |
| `AE3_UiOnTexture` | Checkbox, default off | Master enable for UI-on-Texture rendering. |
| `AE3_UiPlayerRange` | Slider, default 2m | Max range for a player to receive live UI updates while near a laptop. |
| `AE3_armaos_uiOnTexUpdateInterval` | Slider, default 1.0s | Update cadence. `0` = real-time; 0.1-2.0 = throttled hybrid mode. |
| `AE3_UiMaxConcurrentViewers` | Slider, default 3 | Max simultaneous viewers per laptop (`-1` = unlimited; not recommended on populated servers). |
| `AE3_UiMaxTransmitLines` | Slider, default 64 | Max terminal lines transmitted per update. |
| `AE3_UiKeystrokeSyncInterval` | Slider, default 0.3s | Min interval between keystroke syncs. `0` = per-keystroke (high network usage). |
| `AE3_UiEnableChangeDetection` | Checkbox, default on | Only send updates when content actually changed. Keep on unless debugging. |

### Desktop

| Setting | Type | Meaning |
| --- | --- | --- |
| `AE3_Desktop_DefaultMode` | List, default Both | Default laptop interface mode when Eden doesn't override it: CLI, GUI, or Both. |
| `AE3_Desktop_Size` | List, default Fullscreen | Per-player desktop window size: Fullscreen, Large, Medium, Small — useful for using a laptop from inside a vehicle. |
| `AE3_Desktop_EnableDragDrop` | Checkbox, default on | Allow moving desktop windows by their titlebar. |
| `AE3_Desktop_EnableFileBrowsing` | Checkbox, default on | Allow browsing the laptop filesystem in the Files app. |
| `AE3_Desktop_DefaultTheme` | List, default Dark | Default GUI theme: Dark, Light, or Olive. |

### Filesystem

| Setting | Type | Meaning |
| --- | --- | --- |
| `AE3_Filesystem_SyncMode` | List, default Server Only | **Server Only** = filesystem changes sent to server only (recommended, lowest network usage); **Global** = broadcast to all clients (debugging/experimenting only, high network usage). |

### Power

| Setting | Type | Meaning |
| --- | --- | --- |
| `AE3_Power_ChangeThreshold` | Slider, default 1% | Minimum power-level change required before syncing over the network. |
| `AE3_Power_EnableStateSync` | Checkbox, default on | Enable power state network sync. |
| `AE3_Power_UpdateInterval` | Slider, default 1.0s | How often power states (batteries, solar, generators) are recalculated. |

## Related Pages

- [Eden Attributes](Eden-Attributes.md)
- [Desktop Apps](Desktop-Apps.md)
- [Terminal Commands](Terminal-Commands.md)
- [Addon Components](../Developer/Addon-Components.md)
