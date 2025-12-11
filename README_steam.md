[h1]Advanced Equipment Revamped (AE3)[/h1]

[b]A modular framework and equipment pack featuring ArmaOS - a Unix-like terminal system for Arma 3.[/b]

Advanced Equipment Revamped (AE3) delivers a functional terminal laptop running ArmaOS with 25+ Unix commands, virtual filesystem, power management system, and a complete range of connected equipment including generators, batteries, flash drives, solar panels, lamps, and interactable objects. Designed as both a standalone mod and extensible framework for developers.

Tested with 67+ players on dedicated servers. Requires both server and clients to have this mod.

[b]Current version - 1.0.0.0[/b]

[img]https://github.com/y0014984/Advanced-Equipment/raw/master/design/Advanced-Eqipment-Logo-Simple-Font.png[/img]

[hr][/hr]
[h2]Key Features[/h2]

[h3]ArmaOS Terminal System[/h3]
[list]
[*][b]25+ Unix Commands:[/b] ls, cd, cat, mkdir, rm, mv, cp, touch, find, chown, mount, umount, and more
[*][b]20 Terminal Themes:[/b] Classic (ArmaOS, C64, Apple II, Amber), Modern (Midnight Blue, Teal, Neon Violet), Accessibility (High Contrast, Deuteranopia, Tritanopia, Protanopia optimized)
[*][b]9 Keyboard Layouts:[/b] Arabic, German, French, Hebrew, Hungarian, Italian, Russian, Turkish, US English
[*][b]Command History & Autocomplete:[/b] Navigate previous commands with arrow keys
[*][b]Shell Script Execution:[/b] Create and run .sh files
[*][b]Built-in Snake Game:[/b] Classic retro game playable in terminal
[*][b]Security Tools:[/b] crypto (Caesar/Columnar cipher encryption) and crack (decryption)
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

[h3]Power Management System[/h3]
[list]
[*][b]Battery Simulation:[/b] Capacity in Watt-hours (Wh), charge/discharge tracking
[*][b]Multiple Power Sources:[/b] Portable generators (5,000W), large mobile radar generators, solar panels
[*][b]Dynamic Solar Output:[/b] Based on sun position and panel orientation
[*][b]Power Connections:[/b] Link devices to power sources
[*][b]Consumption Tracking:[/b] Per-device and per-operation monitoring
[*][b]Standby Modes:[/b] Reduced power consumption when idle
[*][b]Configurable Costs:[/b] All power consumption values adjustable via CBA settings
[/list]

[h3]Multiplayer Optimized[/h3]
[list]
[*][b]Tested with 67+ Players:[/b] Proven on dedicated servers
[*][b]UI-on-Texture Rendering:[/b] Network-optimized to prevent serialization overhead
[*][b]Player Range Detection:[/b] Efficient UI updates only for nearby players
[*][b]Remote Variable Sync:[/b] Cross-client state management
[/list]

[hr][/hr]
[h2]Equipment Included[/h2]

[table]
[tr]
[th]Equipment[/th]
[th]Description[/th]
[th]Power[/th]
[/tr]
[tr]
[td][b]Terminal Laptop (ArmaOS)[/b][/td]
[td]Interactive computer with animated lid, full Unix-like OS[/td]
[td]Battery powered, rechargeable[/td]
[/tr]
[tr]
[td][b]USB Flash Drives[/b][/td]
[td]Removable storage, mountable filesystems, item/object conversion[/td]
[td]N/A[/td]
[/tr]
[tr]
[td][b]Portable Generators[/b][/td]
[td]3 variants (default, black, sand) - 5,000W output, 5L fuel capacity[/td]
[td]1.5L/h consumption[/td]
[/tr]
[tr]
[td][b]Large Mobile Radar Generator[/b][/td]
[td]High-capacity stationary power source[/td]
[td]470L fuel capacity[/td]
[/tr]
[tr]
[td][b]Battery Units[/b][/td]
[td]Rechargeable power storage[/td]
[td]Charge/discharge dynamically[/td]
[/tr]
[tr]
[td][b]Portable Lamps[/b][/td]
[td]14 variants: Single/Double/Rugged (yellow, olive, black, sand)[/td]
[td]25W-100W depending on type[/td]
[/tr]
[tr]
[td][b]Solar Power Generators[/b][/td]
[td]Clean energy with dynamic sun-based output[/td]
[td]0W consumption[/td]
[/tr]
[tr]
[td][b]Rugged Desks[/b][/td]
[td]3 variants (olive, black, sand) - workspace furniture[/td]
[td]N/A[/td]
[/tr]
[tr]
[td][b]Desk Chairs[/b][/td]
[td]3 variants (olive, black, sand) - ACE sitting support[/td]
[td]N/A[/td]
[/tr]
[/table]

[hr][/hr]
[h2]For Players[/h2]

[h3]Terminal Access[/h3]
[olist]
[*]ACE Interact on AE3 laptop → Equipment → Terminal → Use Terminal
[*]Log in with credentials (configured by mission maker/Zeus)
[*]Type [b]help[/b] to see all available commands
[*]Type [b]man <command>[/b] for detailed command documentation
[/olist]

[h3]Available Commands[/h3]

[b]File Operations:[/b]
[code]
ls                     # List directory contents
ls -l                  # Detailed list with permissions
cd <directory>         # Change directory
cat <file>             # Display file contents
mkdir <directory>      # Create directory
rm <file>              # Remove file
rm -r <directory>      # Remove directory recursively
touch <file>           # Create empty file
cp <source> <dest>     # Copy file
mv <source> <dest>     # Move/rename file
find <pattern>         # Search filesystem
chown <user> <file>    # Change file ownership
[/code]

[b]USB & Storage:[/b]
[code]
lsusb                  # List connected USB devices
mount <device> <path>  # Mount USB drive or remote filesystem
umount <path>          # Unmount filesystem
[/code]

[b]System Commands:[/b]
[code]
clear                  # Clear terminal screen
whoami                 # Display current user
help                   # Show all commands
man <command>          # Display command manual
history                # Show command history
date                   # Display date and time
echo <text>            # Print text to terminal
shutdown               # Power off computer
standby                # Enter low-power standby mode
ping <target>          # Test network connectivity
ipconfig               # Display network information
[/code]

[b]Security & Encryption:[/b]
[code]
crypto <file> <method> <key>    # Encrypt file (Caesar/Columnar cipher)
crack <file> <method> <key>     # Decrypt encrypted file
[/code]

[b]Games:[/b]
[code]
snake                  # Play classic Snake game
[/code]

[h3]Power Management[/h3]
[list]
[*]Operations consume battery power (measured in Watt-hours)
[*]Commands fail if insufficient power available
[*]Recharge using generators, solar panels, or battery units
[*]Use [b]standby[/b] command to reduce power consumption
[*]Monitor battery status via ACE interaction menu
[/list]

[h3]USB Flash Drives[/h3]
[list]
[*]Pick up flash drives as inventory items
[*]Place in world to mount on nearby laptop
[*]Use [b]lsusb[/b] to see connected drives
[*]Use [b]mount[/b] command to access filesystem
[*]Transfer files between terminals
[/list]

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

[h3]Asset Attributes[/h3]
Configure equipment in real-time via Zeus attributes:
[list]
[*]Power state (on/off/standby)
[*]Battery levels (Wh remaining)
[*]Fuel levels (Liters)
[/list]

[hr][/hr]
[h2]For Mission Makers[/h2]

[h3]Eden Editor[/h3]
Modules available under [b]Systems (F5) → Advanced Equipment[/b]. Place equipment objects from editor, then use modules to configure them.

[h3]Initialization Scripts[/h3]

[b]Add User Account:[/b]
[code]
[_laptop, "hacker", "password123"] remoteExec ["AE3_armaos_fnc_computer_addUser", 2];
[/code]

[b]Add Games:[/b]
[code]
[_laptop, true] remoteExec ["AE3_armaos_fnc_computer_addGames", 2];
[/code]

[b]Initialize Generator:[/b]
[code]
// [generator, maxOutput(W), fuelCapacity(L), currentFuel(L)]
[_generator, 5000, 5, 5] remoteExec ["AE3_power_fnc_initGenerator", 2];
[/code]

[b]Create File Programmatically:[/b]
[code]
// [laptop, filePath, content, owner]
[_laptop, "/home/user/readme.txt", "Welcome to ArmaOS", "user"] remoteExec ["AE3_filesystem_fnc_createFile", 2];
[/code]

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

[b]Development:[/b]
[list]
[*][b]Debug Mode:[/b] Enable development logging and diagnostics
[/list]

[hr][/hr]
[h2]Technical Requirements[/h2]

[b]Dependencies (Required):[/b]
[list]
[*][b]CBA_A3[/b] - Community Base Addons (for settings, events, function compilation)
[*][b]ACE3[/b] - Advanced Combat Environment 3 (for interaction menus)
[/list]

[b]Installation:[/b]
[list]
[*]Requires installation on [b]both server and clients[/b]
[*]Load order: CBA → ACE3 → Advanced Equipment
[/list]

[hr][/hr]
[h2]For Developers[/h2]

[h3]API & Framework[/h3]
Advanced Equipment provides 70+ functions across multiple addons for developers to extend functionality:

[list]
[*][b]Terminal System:[/b] Create custom OS commands, modify shell behavior
[*][b]Filesystem:[/b] Programmatic file/directory operations, permission management
[*][b]Power System:[/b] Register custom power consumers/producers
[*][b]Network:[/b] IP addressing, routing, connectivity simulation
[*][b]Interaction:[/b] Add custom ACE interactions to equipment
[/list]

[h3]Extensibility[/h3]
[list]
[*]Modular addon structure for easy extension
[*]CBA-based function compilation (PREP macro)
[*]Config-driven equipment and command registration
[*]Event system for terminal/filesystem/power events
[*]Network-safe serialization patterns
[/list]

[b]Example - Creating Custom OS Command:[/b]
[code]
// In your addon's functions folder: fnc_os_mycmd.sqf
params ["_computer", "_args"];

// Your command logic here
private _output = "Hello from custom command!";

// Return output to terminal
_output
[/code]

Register in CfgOsFunctions.hpp:
[code]
class mycmd {
    script = "mymod_armaos_fnc_os_mycmd";
    description = "My custom command";
};
[/code]

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

Tags: #Arma3 #Steam #Workshop #Mod #Terminal #Unix #Linux #ArmaOS #Equipment #Power #Generator #Solar #Battery #ACE3 #Interaction #Zeus #Editor #Eden #Framework #API #Developer #Multiplayer #Filesystem #Encryption #Retro #C64 #Apple #Accessibility

gaming,game,video,arma,arma 3,terminal,unix,linux,shell,laptop,computer,equipment,power,generator,solar,battery,ace3,interaction,zeus,editor,eden,mission,framework,api,developer,mod,modding,script,sqf,multiplayer,dedicated server,filesystem,crypto,encryption,retro,c64,apple,vintage,accessibility,armaos,command line,cli,usb,flash drive,lamp,desk,furniture,milsim,military,simulation,tactical,realistic
