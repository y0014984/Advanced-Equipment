# Games

Eight turn-based games played **between** AE3 computers on the same in-game network, one player per
computer. Every game exists twice over - as a desktop app and as a terminal command - and both play at
the same table, so a player at a shell can play a player at a desktop.

| Game | Seats | Notes |
|---|---|---|
| Chess | 2 | Castling, promotion to queen, check, checkmate and stalemate. No en passant. |
| Checkers | 2 | Forced captures, multiple jumps, kings. |
| Uno | 2-8 | Skips, reverses, draw twos, wilds and wild draw fours. |
| Ludo | 2-4 | Four tokens each, sixes leave the yard and roll again, captures send a token home. |
| Snakes and Ladders | 1-4 | Playable alone. Sixes roll again; the last square needs an exact roll. |
| Blackjack | 2-8 | Automatic dealer drawing to seventeen, first seat to three rounds wins. |
| Rock Paper Scissors | 2 | Both players throw at once, first to three rounds. Both throws are shown once the round is settled. |
| Battleship | 2 | Lay your own fleet out or take a random one; a hit fires again. |

## Playing

**Desktop.** Open the computer's desktop and look under *Games & Entertainment*. Each game opens on a
lobby: **New game** opens a table, **Join** takes a seat at someone else's, and **Continue** goes back
to a match this computer already sits at. A table with more than two seats is started by the computer
that opened it, once enough players have sat down; a full table starts by itself.

**New game** asks for a name first. That name is what everyone else sees in their lobby, so four games
of chess on one network can be told apart; leave it blank to use the game's own name.

Games are drawn as boards - a coloured chess board, a ludo cross, a printed snakes and ladders board,
cards for uno and blackjack, two charted grids for battleship. A mission can switch that off, in which
case every game falls back to the plain lists the terminal uses.

### Before the match starts

In **chess**, each player picks *white*, *black* or *random* in the table's lobby. Two players cannot
take the same side, and the table will not start until every choice is a different one; a player who
asked for random is dealt whatever is left.

In every other game but rock paper scissors, the host picks which seat moves first by pressing
**Starts first** beside that seat.

### Playing every side yourself

A mission can allow **practice seats**. With them on, the computer hosting a table can press **Add
practice seat** to take another seat at its own table, and a row of buttons under the board switches
between the seats it holds. That makes it possible to set a game up and play both sides of it from one
laptop while building or checking a mission. It is off by default.

Every computer carries every game from the moment it starts up, Snake included. The **AE3: Add Games**
module - in Eden and in Zeus - is how that is narrowed: it has a checkbox per game, all ticked, and a
computer synced to it keeps the ticked games and loses the unticked ones. In Zeus, drop it on the
computer you mean. Without Zeus Enhanced loaded the curator version leaves the full set alone, since
there is no dialog to ask with.

**Terminal.** The same games are commands under `/games` - `chess`, `checkers`, `uno`, `ludo`,
`snakesladders`, `blackjack`, `rps`, `battleship`. The lobby takes `new`, `join <number>`,
`resume <number>`, `start`, `refresh` and `quit`. A table's lobby also takes `name <text>`,
`pref white|black|random`, `starter <seat>`, `dummy` and `seat <n>`. A match takes the game's own moves
plus `board`, `status`, `seatname <text>` and `leave` and `quit`. `man <game>` explains each game's notation. Each command's board is drawn
in plain text, so it works on every terminal design, and an opponent's move prints as it happens.

### Battleship

A match starts with both players laying a fleet out: pick a ship from the list, set its heading with
the **Heading** button, then click the square its bow sits on. **Random** lays the whole fleet out at
once, **Clear** empties the grid and **Ready** starts the firing, which begins when both players are
ready. Both fleets start on a random layout, so a player who is happy with it can simply press
**Ready**. The number of ships still afloat on each side is shown beside the grids.

At the terminal the same thing is `place <ship> <square> <h|v>`, `random`, `clear` and `ready`.

## Leaving and coming back

A match belongs to the **computers** at the table, not to the people at them, and it lives on the
server. Closing the app, quitting the command, walking away from the laptop, switching it off, dying or
disconnecting all keep your seat - the lobby will offer the match back under *Continue*, with the board
exactly as it was. `leave` gives the seat up for good. A table nobody has moved at for an hour is
closed, which a mission can change or switch off.

## Power

Playing costs the computer a small amount of extra power while a game is on screen, on top of its
normal consumption, so a long game flattens a laptop battery and several games add up on a generator.
A parked match - a seat you hold with the game closed - costs nothing unless a mission raises that.

## Networking

Two computers can share a table when they can reach each other over the in-game network, which a
router, wireless range and power all affect exactly as they do for `ping` or `ssh`. A mission can drop
that requirement, in which case any powered computer can join any table.

## Mission settings

CBA settings under **AE3 Games**: games on or off, hosting allowed, the same-network requirement,
graphical game boards, practice seats, the maximum number of tables, a turn timeout, an abandonment
timeout, and the power draw while playing and while parked.

In Eden: the **AE3: Games** module carries *Games*, *Allow hosting*, *Graphical boards*, *Practice
seats* and *Power draw*. Synced to one or more computers it sets those values on them; placed with
nothing synced it sets them for the whole mission. Each box left on *Mission setting* - or empty, for
the power draw - is left to the mission setting, so a module dropped and not filled in changes
nothing. Laptops carry no games attributes of their own: a laptop has every game, and the **AE3: Add
Games** module is what takes some away.

In Zeus: the same **AE3: Games** module lists every live table, closes one, and sets the session's
values. A value set on a single computer wins over a curator's session value, which wins over the
mission setting.

See also [Games API](../Reference/Games-API.md), [Desktop Apps](../Reference/Desktop-Apps.md) and
[Terminal Commands](../Reference/Terminal-Commands.md).
