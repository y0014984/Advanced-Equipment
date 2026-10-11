# Terminal TUI

The Terminal TUI is AE3's command-line computer interface. It is intended for missions where players inspect files, use network tools, mount USB drives, unlock files, or operate a laptop through typed commands instead of a mouse-driven desktop.

## Common Player Commands

The exact command list depends on the laptop — a mission maker chooses which commands exist. Players should start with:

| Command | Purpose |
| --- | --- |
| `help` | List available commands. |
| `man <command>` | Show manual text for a command. |
| `ls` | List files and folders. |
| `cd <path>` | Change folder. |
| `cat <file>` | Read a file. |
| `whoami` | Show current logged-in user. |
| `ip` | Show network information. |
| `ping <ip>` | Check whether another address is reachable. |
| `ssh <ip>` | Connect to a remote laptop. |
| `msg <ip> <text>` | Send a network message. |
| `lsusb` | List connected USB interfaces. |
| `mount <interface>` | Mount a flash drive. |
| `umount <interface>` | Unmount a flash drive. |
| `unlock <path> <password>` | Open a passworded file. |
| `echo <text> > <file>` | Write text to a file (`>>` appends). Works with any command's output. |
| `cp <source> <dest>` | Copy a file; large files take time (progress shown). |

Not every laptop has every command — see [Terminal Commands](../Reference/Terminal-Commands.md) for the full list, including optional security commands (`crypto`, `crack`) and games (`snake`).

Example session investigating a laptop cold:

```text
whoami
ls /home
cd /home/admin
ls
cat notes.txt
ip
ssh 10.0.0.42
```

## Good Terminal Mission Content

Use terminal gameplay for:

- Log inspection (`/var/log/...`).
- Finding hidden files (files that exist but aren't linked from any GUI app).
- Network discovery (`ip`, `ping`, subnets).
- SSH chains between laptops on the same or bridged networks.
- Flash drive handling (`lsusb`, `mount`, `umount`).
- Passworded or encrypted file puzzles (`unlock`, `crypto`, `crack`).
- Minimalist terminals where players must infer what to do — a bare `help` and a locked file can carry an entire investigation.

Avoid placing all clues in GUI-only apps if the laptop is configured as CLI-only, and vice versa — check the laptop's Interface Mode before designing content for it.

## Mission-Maker Setup

In 3DEN:

1. Set laptop Interface Mode to `cli` or `both` (see [Laptops and Interfaces](Laptops-and-Interfaces.md)).
2. Add a user (`AE3: Add User`).
3. Add folders and files (`AE3: Add Directory`, `AE3: Add File`).
4. Enable security commands or custom command setup via laptop attributes/modules if the mission needs them.
5. Add network and flash drive gameplay only if players have enough clues to use it.
6. Preview and test with the same interface players will use — CLI-only content is easy to accidentally leave undiscoverable if you only test through the GUI.

## Related Pages

- [Terminal Commands](../Reference/Terminal-Commands.md) — full command reference, custom command example.
- [ArmaOS API](../Reference/ArmaOS-API.md) — scripted terminal setup.
- [Extending Terminal TUI](../Developer/Extending-Terminal-TUI.md) — adding new commands as an addon developer.
- [Add Custom Terminal Commands](../Examples/Add-Custom-Terminal-Commands.md) — worked example.
