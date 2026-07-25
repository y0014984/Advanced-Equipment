# Advanced Equipment Revamped (AE3)

<p align="center">
    <img src="AE3_Revamped_Logo.png" width="512">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-2.0.0.0-blue" alt="version">
  <a href="https://github.com/y0014984/Advanced-Equipment/actions/workflows/auto-release.yml"><img src="https://github.com/y0014984/Advanced-Equipment/actions/workflows/auto-release.yml/badge.svg?branch=master" alt="build"></a>
  <a href="https://github.com/y0014984/Advanced-Equipment/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-APL--SA-blue.svg" alt="license"></a>
</p>


Advanced Equipment Revamped is an Arma 3 mod for game version 2.20+ that adds interactive, mission-ready equipment and a framework for building computer, power, network, and intel gameplay.

The mod centers on usable in-game laptops, routers, power generators, batteries, and lights. A laptop can expose a graphical desktop interface (GUI), a terminal command-line interface (TUI / CLI), or both. Mission makers can use these interfaces to build investigations, tasks, logistics puzzles, live Zeus intel drops, and persistent object-based systems.

## Requirements
Dependencies:
- [CBA_A3](https://github.com/CBATeam/CBA_A3)
- [ACE3](https://github.com/acemod/ACE3)

Server configuration for GUI/Desktop content:

```cpp
allowedLoadFileExtensions[] = {"hpp", "sqs", "sqf", "fsm", "cpp", "paa", "txt", "xml", "inc", "ext", "sqm", "ods", "fxy", "lip", "csv", "kb", "bik", "bikb", "html", "htm", "biedi", "css", "js", "md", "b64", "svg"};
allowedHTMLLoadExtensions[] = {"htm","html","xml","txt", "css", "js", "md", "b64", "svg"};
```

At minimum, dedicated servers that use the GUI/Desktop variant must allow loading `css`, `js`, `md` file extensions with optional `svg`, and `b64` for loading images and other asthetics.

## Installation

### Steam Workshop

Subscribe to the mod on Steam Workshop:

- [DEV_ADVANCED_EQUIPMENT](https://steamcommunity.com/sharedfiles/filedetails/?id=3751482007)

Load it with CBA_A3 and ACE3.

### Manual install

1. Download the latest release from the repository release page.
2. Extract the release archive into your Arma 3 installation or server mod directory.
3. Ensure the mod folder is named consistently, for example `@ae3`.
4. Start Arma 3 or the dedicated server with the mod loaded after CBA_A3 and ACE3:

```text
-mod=@CBA_A3;@ace;@ae3
```

5. On dedicated servers, update `allowedLoadFileExtensions[]` and `allowedHTMLLoadExtensions[]` as shown above if using the GUI/Desktop interface.

## What It Adds

### Interactive laptops

- GUI desktop with windows, apps, files, browser pages, mail, chat, calendar, map, CCTV, music, settings, and system info.
- TUI terminal with shell commands for files, users, networking, SSH, messaging, USB drives, encryption, cracking, and device control.
- Per-laptop interface mode: terminal only, desktop only, or both.
- Separate GUI and TUI access rules for sides, player UIDs, or custom script conditions.
- User accounts, passwords, home directories, command sets, and filesystem permissions.

### Mission intel tools

- Add files, folders, locked files, emails, browser webpages, browser history, media files, calendar entries, and CCTV cameras.
- Use the GUI Browser and Mail apps for readable intel.
- Use terminal logs and commands for investigation and puzzle flow.
- Add or modify content through 3DEN, Zeus, or SQF.

### Networking

- Routers with SSID, gateway, range, password, powered state, and external routing rules.
- DHCP, static IPs, ping, SSH, route resolution, and network messaging.
- Networked laptop workflows through both GUI apps and TUI commands.

### Power

- Generators, batteries, solar panels, and powered consumers.
- Fuel level, battery charge, solar output, standby, crash, and power connection behavior.
- Power-sensitive laptops, routers, lights, and other equipment.

### Flash drives and filesystem

- Flash drives that move between inventory and world objects.
- USB interfaces, mount/unmount behavior, and persistent virtual filesystems.
- Shared filesystem behavior between GUI Files app and terminal commands.

### Zeus and 3DEN support

- Modules for users, files, directories, connections, browser pages, browser history, email, media, locked files, calendar entries, interface access, and device operations.
- Zeus live-operation tools for adding intel, editing laptop files, connecting devices, and controlling power/network state during play.
- 3DEN attributes for laptop interfaces, router configuration, power levels, and mission setup.

## Documentation

The full documentation is in [wiki](wiki/Home.md).

Useful entry points:

- [Getting Started](wiki/Getting-Started.md)
- [Player Guide](wiki/Player-Guide.md)
- [Mission Maker Guide](wiki/Mission-Maker-Guide.md)
- [Zeus Guide](wiki/Zeus-Guide.md)
- [Desktop GUI](wiki/Systems/Desktop-GUI.md)
- [Terminal TUI](wiki/Systems/Terminal-TUI.md)
- [Browser and Webpages](wiki/Systems/Browser-and-Webpages.md)
- [API Overview](wiki/Reference/API-Overview.md)

## Reporting Issues and Requesting Features

Use GitHub issues for bugs, feature requests, compatibility reports, and documentation problems:

- [Issue Tracker](https://github.com/y0014984/Advanced-Equipment/issues)

When reporting a bug, include:

- AE3 version.
- Arma 3 version.
- CBA_A3 and ACE3 versions.
- Whether the issue happened in singleplayer, hosted multiplayer, or dedicated server.
- Loaded mod list or a minimal reproduction mod list.
- Steps to reproduce the issue.
- Relevant RPT logs, screenshots, or short clips when available.

For feature requests, describe the gameplay or mission-maker problem first, then the proposed behavior. This makes it easier to judge whether the feature belongs in AE3, a mission script, or a separate extension mod.

## Contributing

Contributions are welcome through pull requests. Before opening a PR:

1. Check existing issues and pull requests to avoid duplicate work.
2. Keep changes focused and scoped to one bug fix, feature, or documentation update.
3. Follow the repository style for SQF, configs, stringtables, and documentation.
4. Include documentation updates when behavior, public APIs, editor modules, Zeus workflows, or user-facing systems change.
5. Validate with HEMTT before submitting.

Required validation:

```sh
hemtt check -p -Lc14 -e
```

Gameplay changes should also be tested in Arma 3 with CBA_A3 and ACE3 loaded. Multiplayer, dedicated-server locality, GUI/TUI access, power, network, and Zeus behavior should be tested when relevant.

## Development Builds

Useful local commands:

```sh
hemtt dev
hemtt check -p -Lc14 -e
hemtt build
```

`hemtt dev` creates a development build and local symlink. `hemtt build` creates a release build. `hemtt check -p -Lc14 -e` is the final repository validation command.

## Links

- [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3751482007)
- [Discord](https://discord.gg/qQXg8tB7gr)

## Special Thanks

Special thanks to [JSF Reaper](https://steamcommunity.com/id/operator-101992) whose work on the [Forge - OS](https://steamcommunity.com/sharedfiles/filedetails/?id=3646665660) laid the foundation of this massive GUI update by giving me ideas and references.

## License

Licensed under the Arma Public License - Share Alike. See [LICENSE](LICENSE) for the full license text.

Summary: you may share and adapt the material for non-commercial Arma use, with attribution, under the same license.
