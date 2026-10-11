# Laptops and Interfaces

AE3 laptops are the main interactive computer objects. They can be carried or loaded when allowed, opened or closed, powered on or off, connected to routers, connected to power sources, and filled with mission content.

## Interface Modes

Set via the laptop's Interface Mode object attribute (`AE3_interfaceMode`):

| Value | Meaning |
| --- | --- |
| `default` | Uses the mission/CBA default. |
| `cli` | Terminal command-line interface only. |
| `gui` | Graphical desktop interface only. |
| `both` | Players can choose between terminal and desktop actions. |

Zeus can also manage interface access live during play through the `AE3_InterfaceAccess` module. Getting this wrong is a common cause of "invisible" content — a clue placed as a GUI-only Browser page is unreachable on a `cli`-only laptop.

## GUI Desktop

Best for readable, visual, and app-based gameplay: browsing folders, reading mail, opening webpages, inspecting browser history, reading notes, viewing images/audio/video/maps/CCTV/calendar/system info. Use GUI when players should interact like they are using a normal computer. See [Desktop GUI](Desktop-GUI.md).

## Terminal

Best for command-line gameplay: checking folders and logs, discovering network addresses, connecting through SSH, mounting flash drives, unlocking files, using security or mission-specific commands. Use terminal when the mission should feel like a technical investigation or hacking task. See [Terminal TUI](Terminal-TUI.md).

## Carry and Deploy

Laptops can be picked up into inventory ("Take Laptop" ACE interaction) and placed back down elsewhere ("Deploy laptop" ACE self-action), with content preserved across the conversion (power state does not carry over — a deployed laptop starts off). This is controlled by the `AE3_DeploymentType` CBA setting (see [Config Classes](../Reference/Config-Classes.md#cba-settings)):

- **Stable** (default) — simple hide/show using vanilla laptop item classes.
- **Experimental** — full state preservation using custom item classes; supports the deploy-time custom naming prompt so players can label which physical laptop is which while carrying more than one.

Use this for courier/relocation objectives ("get the laptop out of the compound"), or simply to let players stage laptops where they want them during a mission rather than only where you placed them in Eden. For scripted control, see `AE3_armaos_fnc_laptop_pickup`/`laptop_deploy` in [ArmaOS API](../Reference/ArmaOS-API.md#laptop-state-helpers) — treat those as framework-level, not normal mission-setup calls.

## Access Restrictions

GUI and terminal access can be restricted separately from Interface Mode — this lets a mission maker allow one group to use the desktop while another group can use the terminal, or gate access behind a player-specific condition set by Zeus or mission logic (`AE3_InterfaceAccess` module, or the Desktop API for scripted control).

## Typical Laptop Build

1. Place a laptop.
2. Choose its Interface Mode.
3. Add at least one user (`AE3: Add User`).
4. Add the content players need (files, mail, webpages, calendar events, media — see [Intel, Mail, Chat, and Media](Intel-Mail-Chat-Media.md)).
5. Decide whether it needs power (see [Power](Power.md)) — a laptop with no power connection defaults to off.
6. Decide whether it needs network access (see [Networking](Networking.md)).
7. Test the laptop as a normal player, using whatever Interface Mode you configured — don't test GUI-only content through a debug console that bypasses the mode restriction.

## Related Pages

- [Eden Attributes](../Reference/Eden-Attributes.md) — full laptop attribute table.
- [Create a Laptop](../Examples/Create-a-Laptop.md) — step-by-step tutorial.
- [Configure GUI vs TUI Access](../Examples/Configure-GUI-vs-TUI-Access.md) — worked example of interface restriction.
- [Desktop API](../Reference/Desktop-API.md) / [ArmaOS API](../Reference/ArmaOS-API.md) — scripted setup.

## Headless Servers

`Land_PortableServer_01_{black,olive,sand}_F_AE3` (Eden/Zeus: AE3 > Servers) are computers without a screen: they have a filesystem, users, sudoers, a network address and SSH, but no Use Terminal/Use Desktop action, no USB ports and cannot be picked up. Players reach them over the network with `ssh user@<ip>` or the desktop SSH app — e.g. a server farm behind a router that players explore from a laptop to find and pull files.

- **Power:** mains by default (switch on/off, never drains). Tick *Requires external power* (Eden attribute, Zeus asset panel, or `[_server, false] call AE3_power_fnc_setMainsPowered`) to make it a 150 W consumer that must be cabled to a generator or battery; it shuts down when that power is lost.
- **Attributes:** Hostname, SSH enabled, Static IP, Root login/password, Sudoers, Powered On At Start.
- **Content:** use the same modules and functions as for laptops (`AE3: Add File`, `AE3: Add User`, `AE3_filesystem_fnc_device_writeFile`, ...).
- Connect it to a router with an Eden/Zeus network connection, like a laptop.

