[h1]Advanced Equipment Revamped (AE3)[/h1]

[b]Interactive computers, networks, power, and mission intel for Arma 3.[/b]
Advanced Equipment Revamped turns laptops, routers, flash drives, generators, batteries, solar panels, and lights into usable mission systems. Build investigations, infiltration objectives, logistics puzzles, cyber gameplay, and live Zeus intel drops with a shared desktop, terminal, filesystem, network, and power framework.

[b]Current version:[/b] 2.1.0.0

[img]https://i.ibb.co/B5MQstpb/AE3-Desktop.png[/img]
[hr]
[h2]Requirements[/h2]
[list]
[*][url=https://steamcommunity.com/workshop/filedetails/?id=450814997]CBA_A3[/url]
[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=463939057]ACE3[/url]
[/list]
[b]Dedicated servers using the Desktop GUI must allow these file types:[/b]
[code]
allowedLoadFileExtensions[] = {"css", "js", "md", "b64", "svg"};
allowedHTMLLoadExtensions[] = {"css", "js", "md", "b64", "svg"};
[/code]
Load AE3 on the server and all clients.
[hr]
[h2]What AE3 Adds[/h2]
[table]
[tr][th]System[/th][th]Gameplay[/th][/tr]
[tr][td][b]Laptops[/b][/td][td]Configurable Terminal, Desktop, or both; users, passwords, permissions, and per-player access rules.[/td][/tr]
[tr][td][b]Desktop[/b][/td][td]Files, Terminal, Settings, Notepad, Mail, Chat, Browser, Calendar, Map, CCTV, Music, and SysInfo apps.[/td][/tr]
[tr][td][b]Terminal[/b][/td][td]Files, users, permissions, networking, SSH, messaging, USB, encryption, cracking, shutdown, and standby commands.[/td][/tr]
[tr][td][b]Filesystem[/b][/td][td]Folders, files, ownership, permissions, symlinks, mounts, and shared GUI/terminal access.[/td][/tr]
[tr][td][b]Networks[/b][/td][td]Routers, SSIDs, passwords, DHCP, static IPs, gateways, ping, SSH, routing, and messages.[/td][/tr]
[tr][td][b]Power[/b][/td][td]Generators, batteries, solar panels, fuel, charge, connections, standby, overloads, and computer crashes.[/td][/tr]
[tr][td][b]Intel[/b][/td][td]Emails, webpages, history, media, calendar events, CCTV, readable files, and locked/encrypted content.[/td][/tr]
[tr][td][b]Games[/b][/td][td]Snake, Ludo, Chess, Checkers, Uno, Snakes n Ladders, Blackjack, and Battleship.[/td][/tr]
[/table]
[hr]
[h2]For Players[/h2]
[h3]Use a Laptop[/h3]
Approach an AE3 laptop through the ACE interaction menu. Depending on the mission setup, it can expose:
[list]
[*][b]Terminal only:[/b] a command-line computer for files, users, networking, SSH, messaging, USB drives, and puzzle gameplay.
[*][b]Desktop only:[/b] a graphical interface for readable intel, browser pages, mail, files, maps, CCTV, media, chat, and settings.
[*][b]Both:[/b] a complete computer experience with shared files and accounts across the GUI and CLI.
[/list]
Access can be restricted by side, player UID, user account, password, or a custom mission condition.
[h3]Desktop Apps & Mission Intel[/h3]
The Desktop is designed for readable, in-world information. Browse mission webpages and history, read email, open files, view media, inspect calendars, use maps, watch configured CCTV feeds, and communicate through the available apps. Mission content added by Zeus or the mission maker appears in the same interface players use.
[img]https://i.ibb.co/WvRjjjGw/AE3-Media.png[/img]
[h3]Terminal Gameplay[/h3]
The terminal supports familiar file and user-management workflows alongside mission systems. Players can navigate folders, read files, manage permissions, inspect and connect to networks, use SSH, exchange network messages, mount USB drives, work with encrypted material, and control a laptop's power state.
Use [b]help[/b], [b]-h[/b], or [b]--help[/b] with a command to see its syntax and examples.
[h3]Flash Drives & USB[/h3]
Flash drives can be carried, placed, connected to a laptop USB interface, mounted, unmounted, and browsed from either interface. Their virtual filesystems persist, making them useful for physically moving mission intel, credentials, tools, or data between locations.
[img]https://i.ibb.co/B5n1CccW/AE3-Arsenal.png[/img]
[h3]Networks & Power[/h3]
Routers create mission networks with a configurable SSID, password, range, gateway, and powered state. Laptops can obtain DHCP or static addresses, route through gateways, ping hosts, use SSH, and exchange messages across the network.
Power matters: generators, batteries, and solar panels can supply connected equipment. Fuel, battery charge, solar output, links, standby behavior, overloads, and failures all affect laptops, routers, lights, and other consumers.
[img]https://i.ibb.co/Q7v26b2K/AE3-Router.png[/img]
[hr]
[h2]For Zeus Curators[/h2]
AE3 Zeus tools let you create and alter a live scenario without restarting it. Add or edit users, files, folders, webpages, browser history, emails, media, calendar events, encrypted/locked files, and CCTV content while players are in the mission.
[list]
[*]Turn laptops and other devices on, off, into standby, or crash them.
[*]Connect or disconnect power and network links.
[*]Open a laptop filesystem browser and edit its contents live.
[*]Set GUI and terminal access for specific players, sides, or groups.
[*]Drop new intel, media, messages, and network objectives into an active operation.
[/list]
[img]https://i.ibb.co/prfyv7NW/AE3-Zeus.png[/img]
[hr]
[h2]For Mission Makers[/h2]
AE3 supports editor modules, object attributes, and SQF APIs for building computer-driven scenarios. Create laptops with users, passwords, home directories, files, locked files, emails, webpages, browser history, media, calendar entries, CCTV cameras, custom terminal commands, and custom desktop apps.
Configure:
[list]
[*]Laptop interface mode and independent GUI/terminal access rules.
[*]Router SSID, password, range, gateway, DHCP/static addressing, and external routing.
[*]Generators, batteries, solar panels, consumers, power links, fuel, and charge.
[*]USB devices and persistent filesystems for physical data-transfer objectives.
[*]Readable intelligence chains across files, email, webpages, media, and network systems.
[/list]
[hr]
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
[*][url=https://steamcommunity.com/sharedfiles/filedetails/?id=2738615029]Misery[/url] - Survival framework dedicated to creating a rich development environment for scenario designers
[/list]
[hr]
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
[hr]
[h2]Links[/h2]
[url=https://github.com/y0014984/Advanced-Equipment][img]https://i.imgur.com/lPLHihO.gif[/img][/url]
[url=https://discord.gg/qQXg8tB7gr][img]https://i.imgur.com/8B7UcQ2.gif[/img][/url]
[url=https://steamcommunity.com/sharedfiles/filedetails/?id=3751482007]Development Build[/url]
[hr]
Tags: #Arma3 #Steam #Workshop #Mod #Terminal #Unix #Linux #ArmaOS #Equipment #Power #Generator #Solar #Battery #ACE3 #Interaction #Zeus #Editor #Eden #Framework #API #Developer #Multiplayer #Filesystem #Encryption #Retro #C64 #Apple #Accessibility gaming,game,video,arma,arma 3, terminal, unix, linux, shell, laptop, computer, equipment, power, generator, solar, battery, ace3, interaction, zeus, editor, eden, mission, framework, api, developer, mod, modding, script, sqf, multiplayer, dedicated server, filesystem, crypto, encryption, retro, c64, apple, vintage, accessibility, armaos, command line, cli, usb, flash drive, lamp, desk, furniture, milsim, military, simulation, tactical, realistic
