# Changelog

## Update 6 (v2.0.0.4)

### Added

- A **Powered On At Start** checkbox on every AE3 power device in the Eden editor - generators, batteries and solar panels. It switches the device on as the mission begins, which previously needed a player to walk up to the object and use the ACE interaction after the mission had already started.
- A **Powered On** checkbox in the Zeus asset attributes panel for any AE3 power device, so a curator can switch a generator or battery on and off from the panel during play. The switch is applied on the server and only when it differs from the state the device is already in, so confirming the panel again never restarts a running generator.

### Removed
- N/A

### Changed

- **Fixed:** logging in at a laptop terminal on a dedicated server could report missing permissions for a perfectly valid account, or claim direct root login was disabled while the setting allowing it was on. The terminal judged the login against whatever account list, superuser roster and root-login policy had reached that client, and those are published once as a laptop initializes - a player who opened the terminal in that window was reading pre-publication state. The terminal now fetches all of them from the server as it opens, which is what the desktop login and `ssh` already did. This is also why the same laptop behaved correctly in single player and on a self-hosted server, where client and server are the same machine.
- **Fixed:** a login as `root` reported "root login disabled" even when the mission allowed it, whenever the account was simply not present on that laptop. A refusal now says so only when the policy actually refuses; an unknown account reports that instead.
- **Fixed:** a custom command added with `AE3_armaos_fnc_computer_addCustomCommand` existed only on the machine that ran the call, so on a dedicated server the command was missing from the terminal it was added to. The function now runs server-side and publishes the filesystem afterwards, as every other filesystem function does.
- The desktop Files app now honours the *Sudoers act as root at the terminal* setting. Turning it off for strict Unix semantics used to restrict the terminal while leaving the Files app wide open for the same account; both interfaces now agree. With the setting on - the default - nothing changes.
- **Fixed:** the Eden **Add File** and **Add Directory** modules deleted themselves without a word when the path or owner was empty or contained a space, which is indistinguishable from a module that worked until the file turns out to be missing in game. Each rejection is now written to the RPT log, naming the rule and the value that broke it.
- Wiki: *Add Files and Folders* gained the rules a path and owner must follow, the RPT lines a rejected module writes, and an explanation of file ownership - including why browsing to `/root` answers "Permission denied" and the three ways to get past it. *Eden Attributes* now lists the power attributes that actually exist.
- Deploying a laptop from a save buffer that carries no object type now reports the missing type instead of risking a script error, and a desktop opened before the size preference has registered falls back to fullscreen rather than reading an unset value.
- Router gateway validation checks that an address part is a number before comparing its range, so a malformed entry is rejected rather than raising an error.

## Update 5 (v2.0.0.3)

### Added
- A **Sudoers act as root at the terminal** setting, on by default. Accounts listed in `/etc/sudoers` can now read and write any file from the terminal, the way they already could from the desktop file manager, so an account no longer has two different sets of rights depending on which interface it is used from. `whoami` still reports the real account, and `sudo` and `su` work exactly as before. Missions that prefer strict Unix semantics - where a sudoer must elevate before reaching another user's files - turn the setting off.
- An optional volume argument on `AE3_desktop_fnc_playDeviceSound`. Callers that omit it get the previous loudness.
- A **Send to Cryptography** entry in the Email and Messenger right-click menus, on a message in the list, an open email, a single chat message, and a whole conversation. Only available when Root's Cyberwarfare mod is loaded.

### Removed
- N/A

### Changed
- Fixed the power generators being absent from the 3DEN asset browser while showing normally in Zeus. They are the only AE3 assets built on a vehicle base rather than a prop one, which filed them under a side instead of under Props, and overriding their faction left them with no branch to appear under at all. They now sit in Props alongside the rest of the Advanced Equipment assets, under a Power subcategory, and each generator states its editor category directly rather than inheriting it from a hidden base class.
- Flash drive connect and disconnect sounds can be silenced and their volume adjusted by a mission.

## Update 4 (v2.0.0.2)

### Added
- `su` terminal command: switches the session to another account, or to `root` when none is given. Available to `root` and to accounts listed in `/etc/sudoers`. Unlike `sudo`, which elevates a single command, the switch lasts until `exit`, which returns to the previous account.
- Export from the Email and Messenger apps: an **Export** button in the mail reader (also on a message's right-click menu) and on a Messenger conversation toolbar writes the message or the whole conversation to a plain-text file through the normal Save As dialog. The file is owned by the logged-in user, so it can then be read with `cat`, copied to a flash drive, or sent to another laptop over SSH.
- Copy to the operating-system clipboard from the Email and Messenger apps: the From, To, Subject or Body of an email, the whole message, a single chat message, a whole conversation, or a peer handle. Text is copied on the player's own machine, so it can be pasted into notes or documents outside the game. If the embedded browser blocks a direct clipboard write, a dialog opens with the text preselected so Ctrl+C still works.
- Curator feedback for the static IP field in the Zeus asset attributes dialog: the address is validated on the server, and the accepted or rejected verdict is now reported back instead of always showing success.

### Removed
- The `ae3_desktop_sshReply` event, folded into `ae3_desktop_routeReply`.

### Changed
- Fixed IP addresses being handed out twice on dedicated servers, which left remote connections unreachable and blocked later address changes. Connecting a device or router, disconnecting, refreshing DHCP and leasing on power-on all ran on the client that used the ACE interaction menu, where the device registry needed to detect a duplicate does not exist. Address allocation is now performed on the server in every case. Addresses already held by a router gateway are rejected as well.
- Fixed replies from server-side desktop actions never reaching the browser on dedicated servers, which left the requesting app waiting indefinitely. This affected changing a laptop's IP from Settings, sending mail and chat messages, creating and deleting mail addresses and Messenger handles, and every SSH operation.
- Fixed hostname, SSH access and static IP changes made from Zeus, and the SSH toggle in desktop Settings, silently failing on dedicated servers that filter remote execution of raw commands.
- Fixed accounts added to `/etc/sudoers` still reporting missing permissions in the desktop apps. Superuser membership is now broadcast alongside the file, so it stays correct on clients whose copy of the laptop's filesystem has not caught up. Account names are matched without regard to capitalisation or surrounding whitespace.
- The Zeus asset attributes dialog no longer waits indefinitely for a laptop's initialisation flag, and its router list now includes routers whose wireless range reaches further than the nearby-object scan.
- A terminal session elevated with `su` returns to the account it was logged in as when the terminal is closed, so reopening it never resumes an elevated shell.
- Removed a clipboard copy from the columnar encryption command that could never work for players on a dedicated server; the command returns the cipher as before.

## Update 3 (v2.0.0.1)

### Added
- Ability to independently allow (and configure) `root` superuser credentials per laptop

### Removed
- N/A

### Changed
- Fixed `sudoers` file not respecting the filesystem permissions.

## Major Update 2 (v2.0.0.0)

### Added
- A new `desktop` addon that gives laptops a windowed graphical operating system alongside the existing terminal.
- Built-in desktop apps for Terminal, Files, Settings, Notepad, Mail, Chat, Browser, Calendar, Map, CCTV, Music, and System Information.
- A desktop window manager with focus, minimize, close, taskbar, per-app singleton handling, and configurable window sizes.
- Dark, Light, and Olive desktop themes, together with desktop wallpapers and system artwork.
- Native SQF desktop-app registration through `CfgAE3Apps` and runtime registration, plus web/JavaScript desktop extension and command/reply APIs.
- GUI workflows for mission intel: emails, chat messages, browser history, webpages, calendar events, media, maps, CCTV feeds, locked files, and filesystem browsing.
- Desktop launcher files seeded in the virtual filesystem, allowing missions to control which applications appear in a user's Desktop folder.
- Per-laptop interface modes for terminal-only, desktop-only, or combined access, with independent GUI/TUI restrictions for sides, player UIDs, and custom conditions.
- Made the laptop and flash drive inventory items available through the Virtual Arsenal and ACE Arsenal, and exposed the flash-drive world object to the Virtual Arsenal and Zeus.
- New 3DEN attributes and Zeus modules for adding intel, websites, calendar entries, interface-access rules, and live device operations.
- Laptop save and restore modules, with save-slot dialogs.
- New desktop-focused Zeus tools for creating and editing laptop files, folders, browser content, users, connections, and device state during live operations.
- Expanded terminal commands and support functions for SSH, network messaging, IP information, grep, sudo, unlock, command tokenization, simulated file transfers, and SSH session lifecycle management.
- Filesystem helpers for permissions, symlinks, directory/file creation, search, existence checks, and desktop launcher seeding.
- Router and connection-management features including password prompts, static IP configuration, wireless scanning, subnet/address checks, router configuration UI, and network-device validation.
- Calendar-event helpers, inventory-prop spawning/removal, device-initialization checks, and laptop state capture/application support.
- New sample browser sites and galleries, desktop artwork, image-to-base64 conversion tools, GitHub issue templates, a pull-request template, and expanded player, mission-maker, developer, API, and system documentation.

### Removed
- Deprecated terminal encryption/cracking commands and their supporting functions: `crack` and `crypto`.
- Legacy security-command and game modules, including their old Zeus-module variants.
- The former `ipconfig` and terminal `chat` command implementations, replaced by the newer IP and messaging workflow.
- Generator-running and battery-level helper functions that are no longer part of the updated power implementation.
- Archived design files, source artwork, source fonts, sound archives, and other development assets from the distributed project tree.
- Superseded top-level wiki pages for architecture, API reference, configuration, terminal guidance, security commands, encryption examples, and OS command customization; their material is now organized into the new documentation hierarchy.

### Changed
- Reworked the laptop lifecycle: deployment, pickup, inventory conversion, naming, storage, power-on/off/standby behavior, and state synchronization.
- Rebuilt terminal input and display handling, including keyboard layouts, history, autocomplete, mouse-wheel input, key events, render buffers, prompt handling, and battery/output updates.
- Updated the ArmaOS shell, command parsing, user/session handling, virtual filesystem integration, and terminal UI to support the expanded command set and GUI/TUI coexistence.
- Expanded integration across the ArmaOS, filesystem, networking, power, flash-drive, interaction, and main addons so devices, filesystems, power states, and network state are consistently available to desktop and terminal workflows.
- Updated ACE interactions, Zeus and 3DEN configuration, event handlers, string tables, vehicle definitions, editor categories, and public APIs across the mod.
- Added a dedicated-server requirement for Desktop mode: server administrators must allow `css`, `js`, and `md` in `allowedLoadFileExtensions[]` and `allowedHTMLLoadExtensions[]`; `b64` and `svg` must also be allowed when loading desktop images or alternate wallpapers.
- Documented the complete server extension allow-lists required by the GUI/Desktop browser, including HTML, text, CSS, JavaScript, Markdown, base64, and SVG content.
- Improved flash-drive and filesystem behavior, including mounting, unmounting, file movement, ownership, directory navigation, and permission checks.
- Updated power-device behavior for consumers, batteries, generators, solar panels, standby/crash states, fuel and charge tracking, and power connections.
- Reorganized and substantially expanded the README, Steam Workshop page, and wiki for v2 installation, server extension allow-lists, feature coverage, mission setup, developer extension points, testing, and contribution guidance.
- Added repository contribution workflow support and updated release/build metadata and automation for v2.0.0.0.

## Update 1 (v1.0.0.1)

### Added
- N/A

### Removed
- N/A

### Changed
- Fixed 'Add Security Commands' module breaking unix commands.

## Initial Public Release (v1.0.0.0)

### Added
- 16 New Themes + 4 Original Themes (20 in Total)
- Ability to carry laptops to inventory (with an experimental system implemented as well for future testing)
- Zeus File Browser
- Linear / Sorted Single ACE Interaction
- New Bootup Message
- More keyboard layout
- Autocompletion for files and commands inside the terminal
- Customizable settings for almost everything
- More localization checkes
- More stringtable localization
- New Battery status
- New Public API for custom development 

### Removed
- N/A

### Changed
- Refactored the code to meet new HEMTT standards
- Fix serialization warnings for performance
- Most API calls to be standardized

## Archive
