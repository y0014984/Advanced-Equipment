# Intel, Mail, Chat, and Media

AE3 supports several ways to deliver information to players. Use the format that best matches how you want players to discover the clue.

## Files

Files are best for notes, logs, reports, passwords, and documents. Players can open them from the GUI Files app or terminal (`cat`). Add with `AE3: Add File` / `AE3: Add Directory`. See [Filesystem](Filesystem.md).

## Webpages

Webpages are best for intranet pages, public-looking sites, status boards, indexes, and browser-based trails. Add with `AE3: Add Webpage`. See [Browser and Webpages](Browser-and-Webpages.md).

## Browser History

Browser history is best for showing what a previous user looked at. It works well paired with actual webpages — a history entry to a page that doesn't exist is a dead end. Add with `AE3: Add Browser History`.

## Email

Email is best for communication between characters or organizations. Use sender, recipient, subject, and time to add context. Add with `AE3: Add Email`.

Good email uses:

- Orders from HQ.
- Personal messages.
- Suspicious forwarded mail.
- Password hints.
- Meeting details.

## Calendar Events

Calendar events are best for dates, appointments, meetings, delivery schedules, deadlines, and future objectives. Add with `AE3: Add Calendar Event` (Date, Title, Location/Details).

## Media

Media is best for visual or audio evidence:

- Photos.
- Audio recordings.
- Videos.
- Mission-provided images.

Add with `AE3: Add Media` (source path, media type, laptop path, path type, web-view flag). Keep media files reasonably sized and test them on a dedicated server — large media assets are a common source of stutter/desync in multiplayer previews.

## Locked Files

Locked files are best when players need to find a password elsewhere. Avoid making passwords random guesses — put the password in another clue, such as an email, browser page, note, or flash drive. See [Encryption and Security](Encryption-and-Security.md).

## Chat

Chat is useful for network communication and live-feeling computer systems. It works best when players understand which devices can communicate — pair it with [Networking](Networking.md) so the chat participants make sense as laptops on the same network.

## Sharing Intel Out of the Mail and Messenger Apps

Players can take intel out of the Email and Messenger apps two ways.

**Save to a file.** The reader in Email has an **Export** button (also on a message's right-click menu),
and a Messenger conversation has one on its toolbar. Both open the normal Save As dialog and write a
plain-text file into the laptop's own filesystem, owned by whoever is logged in. Once saved, the file
behaves like any other: `cat` it in the terminal, copy it to a flash drive, or SSH/`scp` it to another
laptop. This is the intended route for passing intel between laptops in-mission.

**Copy to the real clipboard.** The **Copy** button next to Export copies the From, To, Subject or
Body of an email, or the whole message; a Messenger conversation can be copied whole, and a single
message from its right-click menu. This writes to the player's actual OS clipboard, so it can be
pasted into notes or documents outside the game. If the embedded browser blocks a direct clipboard
write, a dialog opens with the text preselected so Ctrl+C still works.

## Choosing the Right Intel Type

| Goal | Use |
| --- | --- |
| Direct document | File |
| Social/narrative context | Email |
| Web/intranet clue | Webpage |
| "someone was here" trail | Browser history |
| Visual/audio evidence | Media |
| Password-gated content | Locked file |
| Time-sensitive clue | Calendar event |
| Live device-to-device feel | Chat |

A typical layered clue: an email hints at a URL → the webpage names a file → the file is locked → the password is on a flash drive found elsewhere. See [Add Intel, Mail, Chat, or Media](../Examples/Add-Intel-Mail-Chat-or-Media.md) for a full worked example.

## Related Pages

- [Desktop API](../Reference/Desktop-API.md) and [Browser API](../Reference/Browser-API.md) — scripted calls for adding intel.
- [Add Intel, Mail, Chat, or Media](../Examples/Add-Intel-Mail-Chat-or-Media.md) — step-by-step tutorial.
