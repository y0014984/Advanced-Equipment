# Eden Attributes

This page is the technical reference for AE3's Eden object attributes, modules, and custom connection types. For a step-by-step no-code guide, see [Eden Editor Guide](../Eden-Editor-Guide.md).

## Laptop Attributes

AE3 laptop variants expose these object attributes.

| Attribute | Stored variable/property | Type | Meaning |
| --- | --- | --- | --- |
| Power Level | `AE3_EdenAttribute_PowerLevel` / related power variable | Number | Initial power/battery level used by device initialization. |
| Interface Mode | `AE3_interfaceMode` | String | Which interface the laptop offers. |
| Static IP | `AE3_network_staticIpDefault` | String | Requested static IP applied when the laptop joins a network. |
| Crypto | `AE3_SecurityCommand_Crypto` | Bool | Installs `crypto` command. |
| Crack | `AE3_SecurityCommand_Crack` | Bool | Installs `crack` command. |
| Snake | `AE3_Game_Snake` | Bool | Installs Snake game. |
| Powered On At Start | `AE3_power_startOn` | Bool | Turns the laptop on after power init. |
| Direct root login | `AE3_allowRootLogin` | String | Whether `root` may log in directly on this laptop: `default` (follow the `AE3_AllowRootLogin` CBA setting), `allow`, or `deny`. |
| Root password | `AE3_rootPassword` | String | Password of this laptop's `root` account. Blank uses the `AE3_DefaultRootPassword` CBA setting. |
| Sudoers | applied to `/etc/sudoers` | String | Comma-separated accounts that may run `sudo` and act as superuser in the desktop apps. The accounts must exist on the laptop. |

Interface Mode values:

| Value | Meaning |
| --- | --- |
| `default` | Use mission/CBA default. |
| `cli` | Terminal/TUI only. |
| `gui` | Desktop GUI only. |
| `both` | Both GUI and TUI ACE actions. |

Static IP guidance:

- Use an address in the connected router subnet.
- Avoid duplicate static IPs.
- Leave blank to use DHCP.

## Router Attributes

Routers expose network configuration attributes:

| Attribute | Type | Meaning |
| --- | --- | --- |
| Network Name / SSID | String | Name shown in router/network UI. |
| Default Gateway | String | Gateway IP, for example `10.0.0.1`. |
| WiFi Range | Number | Wireless range in metres. |
| Network Password | String | Password required by network UI. Empty can represent open network. |
| Power Level | Number | Initial power/fuel/battery level depending on class. |
| Powered On At Start | Bool | Turns router on after init. |
| Allow External SSH | Bool | Allows cross-gateway access to this router subnet. |
| External Allowed IPs | String | Comma/space separated gateway, host, or regex allow list. |

External policy is enforced by `AE3_network_fnc_resolve`, which is used by higher-level route behavior such as SSH/message workflows.

## Power Device Attributes

Power devices expose attributes appropriate to their class:

| Device type | Attributes |
| --- | --- |
| Generator | `Fuel Level`, `Powered On At Start`. |
| Battery | `Power Level`, `Powered On At Start`. |
| Solar panel | `Power Level` (panel variants that carry one), `Powered On At Start`. |
| Laptop/internal battery | `Power Level`, `Powered On At Start`. |

`Powered On At Start` switches the device on as the mission begins, instead of leaving it for a player to reach through the ACE interaction on the object. It is a checkbox, off by default, and it is available on every AE3 power device. The same on/off state is also editable during play from the Zeus asset attributes panel, which shows a `Powered On` checkbox for any AE3 power device.

Exact fields depend on the class configuration. Runtime power scripts can also set levels with [Power API](Power-API.md).

## Custom Eden Connections

AE3 adds connection tools to Eden's right-click connection workflow.

### `AE3: connect device to power source`

Creates a power link:

```sqf
[_entity0, _entity1] call AE3_power_fnc_createPowerConnection;
```

Use it from a consumer to a provider, for example laptop to generator or battery to solar panel.

### `AE3: connect device to network router`

Creates a network link:

```sqf
[_entity0, _entity1] call AE3_network_fnc_createNetworkConnection;
```

Use it from laptop to router or router to router.

## Content Modules

These modules are useful in Eden and/or Zeus. In Eden, place the module, open its attributes, configure fields, and sync it to the target laptop unless the guide for that module says otherwise.

| Module | Purpose | Important fields |
| --- | --- | --- |
| `AE3_AddUser` | Adds a user account. | Username, password. |
| `AE3_AddSudoer` | Gives an existing account superuser rights (adds it to `/etc/sudoers`). | Username. |
| `AE3_AddDir` | Creates a directory. | Path, owner, permissions. |
| `AE3_AddFile` | Creates a file. | Path, content, owner, permissions, code/encryption options. |
| `AE3_AddCalendarEvent` | Adds calendar entry. | Date, title, location/details. |
| `AE3_AddEmail` | Adds mail. | From, to, subject, body, received time, address-book flags. |
| `AE3_AddWebpage` | Registers browser page. | URL, title, content. |
| `AE3_AddBrowserHistory` | Adds browser history entry. | URL, time. |
| `AE3_AddMedia` | Adds media marker. | Source path, media type, laptop path, path type, web-view flag. |
| `AE3_AddPasswordedFile` | Adds locked file. | Path, password, protected content, owner, permissions. |

## Utility Modules

| Module | Purpose |
| --- | --- |
| `AE3_SaveLaptop` | Captures laptop state for restore workflows. |
| `AE3_RestoreLaptop` | Restores saved laptop state. |
| `AE3_CrashDevice` | Crashes a selected computer. |
| `AE3_InterfaceAccess` | Changes GUI/TUI access rules in Zeus workflow. |
| `AE3_AddConnection` | Zeus connection dialog. |

## Attribute vs Module vs Script

| Need | Best tool |
| --- | --- |
| Set per-object default mode, power, static IP, software toggles | Object attributes. |
| Add fixed mission content in Eden | Modules synced to the laptop. |
| Change laptop state live during Zeus | Zeus modules/actions. |
| Create dynamic content based on mission events | Reference API functions in server scripts. |
| Extend AE3 for another addon | Config classes and Developer guides. |

## Related Pages

- [Eden Editor Guide](../Eden-Editor-Guide.md)
- [Config Classes](Config-Classes.md)
- [ArmaOS API](ArmaOS-API.md)
- [Desktop API](Desktop-API.md)
- [Power API](Power-API.md)
- [Network API](Network-API.md)
