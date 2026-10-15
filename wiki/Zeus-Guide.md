# Zeus Guide

This guide explains how a curator can use AE3 during a live mission without writing scripts.

## What Zeus Can Do

Depending on module availability and curator permissions, Zeus can:

- Place AE3 laptops, routers, power devices, lights, and flash drives.
- Turn devices on, off, or standby.
- Open or close equipment.
- Crash laptops.
- Connect laptops to routers.
- Connect devices to power sources.
- Add users.
- Add files and directories.
- Add webpages and browser history through live intel tooling where available.
- Add emails, media, calendar events, and locked files through the relevant Zeus modules or live Add Intel workflow.
- Open a laptop filesystem browser and edit content live.
- Control GUI/TUI access for players or sides.

## Live Laptop Setup

1. Place or select an AE3 laptop.
2. Add a user so players can log in.
3. Decide whether players should use GUI, terminal, or both.
4. Add the content they need: file, email, webpage, media, or locked file.
5. If the laptop needs network access, connect it to a router.
6. If the laptop needs power, connect it to a power source or turn it on if it has charge.
7. Watch players interact and add follow-up content when needed.

## Adding Users

Use the Add User module/dialog when players need credentials.

Fields:

- Username.
- Password.

Target:

- The laptop that should receive the account.

Give credentials through briefing, a note, another laptop, a radio message, or in-character Zeus communication.

## Adding Files and Folders

Use Add Directory before Add File when the file path needs a new folder.

Folder fields:

- Path.
- Owner.
- Permissions.

File fields:

- Path.
- Content.
- Owner.
- Permissions.
- Optional encryption settings.

Players can read files through the GUI Files app or terminal, depending on laptop interface mode.

## Adding Browser Intel

For Browser-based clues:

1. Use the live Add Intel workflow or any exposed browser module/dialog.
2. Add a webpage with URL, title, and content.
3. Add a browser history entry using the same URL.
4. Tell players to check the browser, or let them discover it through history/logs.

Browser history alone is only a trail. The webpage module creates the page content.

## Adding Email

Use email when intel should feel like communication between people or organizations. In Zeus, use the standalone **Add Email** module (the former unified Add Intel module has been split into per-type modules: Add Email, Add Webpage, Add Browser History, Add Media, Add Passworded File).

Useful fields:

- From.
- To.
- Subject.
- Body.
- Received time.
- Create sender/recipient address options.

Players read emails in the Mail app or through laptop files if the mission exposes them.

## Adding Media

Use media for images, audio, or video clues. In Zeus, use the standalone **Add Media** module.

Important fields:

- Source path: where the media file exists.
- Media type.
- Laptop path: where it appears on the laptop.
- Path type: mission file or mod path.

If players cannot open media, verify the file exists in the mission or loaded mod and that the server allows the needed file extension.

## Adding Locked Files

Use passworded files when players need to discover a password first.

Fields:

- Laptop path.
- Password.
- Content.
- Owner.

The password should be discoverable somewhere else in the mission. Avoid making players guess.

## Device Control

Zeus can use AE3 actions/modules to:

- Turn a device on.
- Turn a device off.
- Put a device in standby.
- Crash a laptop.
- Restore a crashed laptop by guiding players to power-cycle it.

Crashing a laptop is useful for sabotage, failed hack consequences, or story beats.

## Power and Network During Play

When players are stuck, check:

- Is the laptop powered?
- Is the router powered?
- Is the power source on and fueled/charged?
- Is the device connected to the correct router?
- Is the router range large enough?
- Is the router password known?
- Is external access required for this route?

## Network Speed and File Sizes

- Drop **AE3: Network Speed** onto a router (whole wifi network) or a laptop/server (whole device, or listed user accounts) and enter a speed in KB/s. `0` = back to default. Everyone uses the mission setting until changed.
- **Add File** has a *Virtual file size* field (`50MB`, `1.5GB`): copying or downloading that file takes as long as that size needs at the player's speed - good for "hold the position while the download runs" moments.

## Games

Drop **AE3: Games** anywhere to see every game running in the mission - which game, how many seats are
taken, who is at them and how long it has been idle - close one, and set the session's rules: games on
or off, whether hosting is allowed, the same-network requirement, whether games are drawn as boards or
as plain lists, whether a host may give itself practice seats, the maximum number of tables, a turn
timeout, the abandonment timeout and the power a game draws. A field left empty hands that value back
to the mission setting.

The same module in Eden sets those values on the computers synced to it. A value set on a single
computer that way beats your session value, which beats the mission setting. Closing a table ends the match for everyone sitting at it. Only a curator can see the
roster, because it names the computers people are playing on. See [Games](Systems/Games.md).

## Headless Servers

Servers (AE3 > Servers) are reached only over the network. Their asset attributes panel shows hostname, SSH, IP/router, power, and a *Needs external power* checkbox (off = mains power).

## Filesystem Browser

The Zeus filesystem browser is for live inspection and editing. Use it to:

- Confirm a file exists.
- Create quick emergency clues.
- Rename or delete incorrect content.
- Check whether a laptop has the expected folders.

Use preplaced 3DEN modules for planned mission content and the filesystem browser for live corrections or dynamic Zeus play.

## Good Zeus Practice

- Add live content only when players have a reason to look for it.
- Keep credentials and passwords discoverable.
- Do not change a clue while a player is reading it unless the mission calls for that effect.
- Prefer adding a new message or page over silently changing old evidence.
- If players are using terminal only, do not add GUI-only clues.
- If players are using desktop only, do not require obscure terminal command knowledge.
