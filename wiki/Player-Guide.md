# Player Guide

This page explains what players can do with AE3 equipment in a mission. Mission makers decide which systems are available, so not every mission will use every feature.

## Using AE3 Equipment

AE3 equipment is normally used through ACE interactions. Look at the object, open the ACE interaction menu, and choose the available action.

Common actions include:

- Open or close a laptop.
- Use a terminal.
- Use a desktop.
- Turn a device on, off, or standby.
- Connect or disconnect a flash drive.
- Mount or unmount USB storage.
- Check power, battery, or fuel state.
- Configure or connect to a network when allowed by the mission.

Some actions disappear when the object is in use, connected, powered on, inside cargo, or otherwise unavailable.

## Laptops

Laptops can expose one or two computer interfaces.

### Desktop GUI

The graphical desktop is used like an in-game computer. Depending on the mission, you may see apps such as:

- Files: browse folders and open documents.
- Browser: open mission webpages and follow clues.
- Mail: read emails planted by the mission maker or Zeus.
- Chat: communicate through AE3 network systems.
- Calendar: inspect scheduled events.
- Map: view map-related information.
- CCTV: view registered cameras.
- Music: play audio media.
- SysInfo: inspect system information.
- Terminal: use a command line inside the desktop.

### Terminal TUI

The terminal is a text interface. It is used for command-line style gameplay: listing files, reading logs, changing directories, checking network state, pinging other devices, using SSH, mounting flash drives, and unlocking passworded files.

Useful commands to try if they are installed:

- `help`: show commands available on this laptop.
- `man <command>`: show help for one command.
- `ls`: list files.
- `cd`: change folders.
- `cat`: read a file.
- `ip`: show network information.
- `ping`: test a remote address.
- `ssh`: connect to a remote laptop.
- `lsusb`: list USB interfaces.
- `mount`: mount a flash drive.
- `umount`: safely unmount a flash drive.
- `unlock`: open a passworded file.

If a command does not work, the mission maker may not have installed it on that laptop.

## Carrying a Laptop

Some laptops can be picked up as an inventory item ("Take Laptop" ACE interaction) and carried, then placed back down later with a "Deploy laptop" ACE self-action from your inventory. Picking one up preserves its content (users, files, mail, browser pages) — only its power state resets, so a deployed laptop starts off and needs to be turned on again. When deploying, you may be prompted to give the laptop a custom name, which then shows next to its item name (e.g. "Command Board (RootBook 3)") so you can tell multiple carried laptops apart.

If a laptop can't be picked up, someone else may be using its terminal/desktop, or the mission maker may have disabled portability for that one.

## User Accounts

Some laptops require a username and password. Credentials may be given in the briefing, found in a note, hidden in an email, recovered from browser history, or provided by Zeus during play.

If you log in but cannot read a file, the file may belong to a different user or require a password.

## Power

Some devices must be powered before they work.

- Generators may need fuel.
- Batteries may need charge.
- Solar panels may depend on sunlight and orientation.
- Routers and laptops may have internal batteries but still run out or start off.

If a laptop will not turn on, look for a power source or ask whether the mission includes a power puzzle.

## Networking

Networks allow laptops to communicate. A router usually defines the local network. If the laptop has network access, you may be able to:

- View its current address.
- Ping another device.
- Connect to another laptop through SSH.
- Use chat or messaging.
- Access network-based mission clues.

Network range, router passwords, static addresses, and external access rules are controlled by the mission.

## Games

If the mission allows it, two or more laptops on the same network can play each other: chess, checkers,
uno, ludo, snakes and ladders, blackjack, rock paper scissors and battleship. They are in the desktop
menu under *Games & Entertainment* and in the terminal under `/games`, and both ways play at the same
table, so a player at a shell can play a player at a desktop.

One laptop opens a table, the others join it, and a table with more than two seats is started by the
laptop that opened it. You can leave the game and come back: shutting the laptop, walking away, dying or
reconnecting all keep your seat, and the game offers the match back under *Continue* with the board as
you left it. Playing uses a little extra power, so a long game costs battery. See
[Games](Systems/Games.md).

## Flash Drives

Flash drives can hold files and clues.

Typical flow:

1. Pick up or receive a flash drive.
2. Use ACE to connect it to a laptop USB port.
3. Use the terminal to list USB devices.
4. Mount the flash drive.
5. Open its files through the terminal or desktop Files app.
6. Unmount it before disconnecting when the mission expects careful handling.

## If Something Seems Broken

Check these first:

- Is the device powered?
- Is someone else already using the laptop?
- Are you using the correct interface, GUI or terminal?
- Do you have the right username and password?
- Is the flash drive mounted?
- Is the router powered and within range?
- Did Zeus or the mission maker restrict access to your side or player?
