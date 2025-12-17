[h1]Advanced Equipment Revamped (AE3 - December 2025)[/h1]

[b]A modular framework and equipment pack featuring ArmaOS - a Unix-like terminal system for Arma 3.[/b]

Advanced Equipment Revamped (AE3) delivers a functional terminal laptop running ArmaOS with 30+ default Unix commands, virtual filesystem, power management system, and a complete range of connected equipment including generators, batteries, flash drives, solar panels, lamps, and interactable objects. Designed as both a standalone mod and extensible framework for developers.

Tested with 67+ players on dedicated servers. Requires both server and clients to have this mod.

[b]Current version - 1.0.0.1[/b]

[img]https://github.com/y0014984/Advanced-Equipment/raw/master/AE3_Revamped_Logo.png[/img]

[hr][/hr]
[h2]Key Features[/h2]

[h3]ArmaOS Terminal System[/h3]
[list]
[*][b]25+ Unix Commands:[/b] ls, cd, cat, mkdir, rm, mv, cp, touch, find, chown, mount, umount, and more
[*][b]20 Terminal Themes:[/b] Classic (ArmaOS, C64, Apple II, Amber), Modern (Midnight Blue, Teal, Neon Violet), Accessibility (High Contrast, Deuteranopia, Tritanopia, Protanopia optimized)
[*][b]9 Keyboard Layouts:[/b] Arabic, German, French, Hebrew, Hungarian, Italian, Russian, Turkish, US English
[*][b]Command History & Autocomplete:[/b] Navigate previous commands with arrow keys
[/list]

[h3]Virtual Filesystem[/h3]
[list]
[*][b]Unix-style Directory Structure:[/b] /bin, /sbin, /home, /root, /tmp, /mnt, /var, /sys
[*][b]Permission System:[/b] Read, write, execute permissions per user
[*][b]Mount/Unmount:[/b] USB flash drives and remote filesystems
[*][b]Complete File Operations:[/b] Create, delete, move, copy, read, write files and directories
[*][b]Ownership Management:[/b] chown command for changing file ownership
[*][b]Encrypted Files:[/b] Support for encrypted file storage
[/list]

[h3]Multiplayer Optimized[/h3]
[list]
[*][b]Tested with 67+ Players:[/b] Proven on dedicated servers
[*][b]UI-on-Texture Rendering:[/b] Network-optimized to prevent serialization overhead
[*][b]Player Range Detection:[/b] Efficient UI updates only for nearby players
[*][b]Remote Variable Sync:[/b] Cross-client state management
[/list]


See the [url=https://github.com/y0014984/Advanced-Equipment/wiki]Wiki[/url] for additional information on how to use Advanced Equipment.

[hr][/hr]
[h2]For Players[/h2]

[h3]Terminal Access[/h3]
[olist]
[*]ACE Interact on AE3 laptop → Equipment → Terminal → Use Terminal
[*]Log in with credentials (configured by mission maker/Zeus)
[*]Type [b]help[/b] to see all available commands
[*]Type [b]man <command>[/b] for detailed command documentation
[/olist]

[hr][/hr]
[h2]For Zeus Curators[/h2]

[h3]Quick Setup[/h3]
[olist]
[*]Open Zeus interface (Y key) → Empty Tab → Advanced Equipment Objects (AE3)
[*]Place the required object (laptop, lamps, generators, batteries, power source)
[*]Open Zeus interface (Y key) → Modules Tab → AE3 Main Modules
[*]Place the module needed (Add User, Add Security Commands, Add Games)
[/olist]

[h3]Zeus Modules[/h3]

[b]Add User[/b] - Create user accounts with username/password for terminal login
[b]Add File[/b] - Create files in the virtual filesystem with custom content
[b]Add Directory[/b] - Create directories in the virtual filesystem
[b]Add Games[/b] - Add Snake game to terminal (playable via [b]snake[/b] command)
[b]Add Security Commands[/b] - Add crypto and crack encryption tools

[h3]Filesystem Browser[/h3]
Zeus interface includes a graphical filesystem browser for easy file/directory management without typing commands. Just double click on the laptop.

[hr][/hr]
[h2]For Mission Makers[/h2]
[h3]Eden Editor[/h3]
Modules available under [b]Systems (F5) → Advanced Equipment[/b]. Place equipment objects from editor, then use modules to configure them.

[hr][/hr]
[h2]CBA Settings[/h2]

Configure in Main Menu → Options → Addon Options → Advanced Equipment:

[b]Terminal Settings:[/b]
[list]
[*][b]Terminal Design:[/b] Choose from 20 themes (ArmaOS, C64, Apple II, Amber, Midnight Blue, High Contrast, etc.)
[*][b]Keyboard Layout:[/b] Select from 9 languages (AR, DE, FR, HE, HU, IT, RU, TR, US)
[*][b]Terminal Dialog Title:[/b] Customize dialog header text
[*][b]Terminal Update Rate:[/b] UI-on-Texture refresh interval (default 0.3s)
[*][b]UI-on-Texture Toggle:[/b] Enable/disable multiplayer optimization
[/list]

[hr][/hr]

[h2]Credits[/h2]

[b]Current Maintainer:[/b] Root (xMidnightSnowx)
[b]Original AE3 Development:[/b]
[list]
[*]y0014984 - Original framework creator
[*]Wasserstoff - Core contributions
[*]JulesVerner - Development
[/list]

[b]Related Mods:[/b]
[list]
[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=3591608460]Root's Cyber Warfare[/url] - Device hacking mod built on AE3 framework
[/list]

[hr][/hr]
[h2]License[/h2]
[b]APL-SA:[/b] Arma Public License - Share Alike

[url=https://www.bohemia.net/community/licenses/arma-public-license-share-alike]Read Full License[/url]

[b]TL;DR - What am I allowed to do?[/b]
✅ [b]Attribution Required[/b] - Credit original authors (y0014984, Wasserstoff, JulesVerner) and current maintainer (Root)
✅ [b]Share Alike[/b] - Derivative works must use same APL-SA license
✅ [b]Redistribute publicly[/b] with clear credit and link to this workshop page
❌ [b]Non-Commercial[/b] - No commercial use
❌ [b]Arma Only[/b] - No porting to other games
❌ [b]Private redistribution without credit[/b] is forbidden

[hr][/hr]
[h2]Links[/h2]

[url=https://github.com/y0014984/Advanced-Equipment][b]GitHub Repository[/b][/url]
[url=https://github.com/y0014984/Advanced-Equipment/issues][b]Issue Tracker[/b][/url]

[hr][/hr]
Tags: #Arma3 #Steam #Workshop #Mod #Terminal #Unix #Linux #ArmaOS #Equipment #Power #Generator #Solar #Battery #ACE3 #Interaction #Zeus #Editor #Eden #Framework #API #Developer #Multiplayer #Filesystem #Encryption #Retro #C64 #Apple #Accessibility gaming,game,video,arma,arma 3, terminal, unix, linux, shell, laptop, computer, equipment, power, generator, solar, battery, ace3, interaction, zeus, editor, eden, mission, framework, api, developer, mod, modding, script, sqf, multiplayer, dedicated server, filesystem, crypto, encryption, retro, c64, apple, vintage, accessibility, armaos, command line, cli, usb, flash drive, lamp, desk, furniture, milsim, military, simulation, tactical, realistic
