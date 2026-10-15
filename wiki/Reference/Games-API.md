# Games API

Public functions of the `ae3_games` component. Every one of them is safe to call from a client: a call
that changes a match is routed to the server, which owns it.

See [Games](../Systems/Games.md) for what the games are and how they are played.

## Tables

### `AE3_games_fnc_hostTable`

Opens a table on a device and seats that device first.

```sqf
[netId _computer, "chess", "Officers only"] call AE3_games_fnc_hostTable;
```

`0: _deviceNetId <STRING>`, `1: _gameId <STRING>`, `2: _name <STRING>` (optional, up to 40 characters,
blank for the game's own name). Game ids: `chess`, `checkers`, `uno`, `ludo`,
`snakesladders`, `blackjack`, `rps`, `battleship`. A device that already holds a seat at a table of that
game is sent back to it rather than opening a second one.

### `AE3_games_fnc_joinTable`

Takes a free seat, or hands back the seat the device already holds, which is how a match is resumed.

```sqf
[netId _computer, "chess-3"] call AE3_games_fnc_joinTable;
```

Refused when the match has already started, the table is full, or the two devices cannot reach each
other over the network.

### `AE3_games_fnc_startTable`

Starts a table waiting in its lobby. Only the hosting device may, and only once the game's minimum
number of seats is filled. A full table starts itself.

```sqf
[netId _computer, "uno-2"] call AE3_games_fnc_startTable;
```

### `AE3_games_fnc_leaveTable`

Gives a device's seat up. The table closes when the last seat goes.

```sqf
[netId _computer, "chess-3"] call AE3_games_fnc_leaveTable;
```

### `AE3_games_fnc_closeTable`

Ends a table for everyone at it, telling each player why.

```sqf
["chess-3", "$STR_AE3_Games_Status_Closed"] call AE3_games_fnc_closeTable;
```

`0: _tableId <STRING>`, `1: _reasonKey <STRING>` (optional, a stringtable key).

### `AE3_games_fnc_setTableOption`

Answers one of the questions a table asks: what it is called, what the player at a seat is called,
which side a seat would like, and which seat moves first.

```sqf
[netId _computer, "chess-3", "pref", "white"] call AE3_games_fnc_setTableOption;
[netId _computer, "ludo-1", "starter", "2"] call AE3_games_fnc_setTableOption;
[netId _computer, "uno-4", "name", "Night shift"] call AE3_games_fnc_setTableOption;
[netId _computer, "uno-4", "seatname", "Sgt Hayes"] call AE3_games_fnc_setTableOption;
```

`name` and `starter` are the host's to set; `pref` and `seatname` apply to the seat the calling device
is playing, and `pref` takes `white`, `black` or `random`. Chess is the game that asks for a side; every
other game but rock paper scissors lets the host name a starting seat. `seatname` is capped at 24
characters and an empty one hands the seat back to the computer's own name - it is the only one of the
four that still works after the match has begun, because nothing about the game is decided by it; the
other three are ignored once that happens.

### `AE3_games_fnc_addDummySeat`

Gives the hosting device another seat at its own table, so one computer can play every side while a
mission is built.

```sqf
[netId _computer, "chess-3"] call AE3_games_fnc_addDummySeat;
```

Host only, lobby only, and refused unless the `DebugSeats` setting is on for that computer.

### `AE3_games_fnc_setActiveSeat`

Picks which of the seats a device holds it is playing. Every later move, and the view pushed back to
it, follow that seat.

```sqf
[netId _computer, "chess-3", 1] call AE3_games_fnc_setActiveSeat;
```

## Installing

Every computer is given every game when it starts up, so these two are for changing that set.

### `AE3_games_fnc_installGames`

Gives a computer the terminal commands for the named games, under `/games`. The desktop apps need no
installation - they follow the device's *Games* setting. Waits for the computer to finish
initialising.

```sqf
[_computer, ["chess", "uno"]] call AE3_games_fnc_installGames;
```

`1: _gameIds <ARRAY>` (optional, defaults to every game).

### `AE3_games_fnc_removeGames`

Takes the named games off a computer: the command link goes and so does the file it pointed at, so
the game is not left sitting in `/games`.

```sqf
[_computer, ["uno", "blackjack"]] call AE3_games_fnc_removeGames;
```

### `AE3_games_fnc_gameIds`

Every game id, in the order they are listed to a mission maker. Use it instead of writing the list out.

```sqf
[_computer, call AE3_games_fnc_gameIds] call AE3_games_fnc_installGames;
```

## Settings

### `AE3_games_fnc_getSetting`

Reads a setting as it actually applies to a device, resolving the device's own value first, then a
curator's session override, then the mission setting.

```sqf
private _timeout = [_computer, "TurnTimeout"] call AE3_games_fnc_getSetting;
```

Names: `Enabled`, `AllowHosting`, `RequireSameNetwork`, `GraphicalUI`, `DebugSeats`, `MaxTables`,
`TurnTimeout`, `AbandonTimeout`, `PowerDraw`, `IdleDraw`. Pass `objNull` for a mission-wide read.

### `AE3_games_fnc_setSetting`

Writes one. With a device, the value is that device's; with `objNull`, it is the session override a
curator sets. Omit the value to clear it and fall back to the next source.

```sqf
[_computer, "Enabled", false] call AE3_games_fnc_setSetting;   // this computer has no games
[objNull, "TurnTimeout", 120] call AE3_games_fnc_setSetting;   // whole session
[objNull, "TurnTimeout"] call AE3_games_fnc_setSetting;        // back to the mission setting
```

## Notes for mission scripts

- Table ids look like `chess-3` and are handed out by the server; read them from
  `AE3_games_fnc_getTables`'s reply rather than guessing.
- A match is server state: it survives players closing the game, powering a laptop off, dying and
  reconnecting, but not a mission restart.
- Adding a game of your own means a `fnc_rules_<id>` function on the framework's contract and a row in
  `AE3_games_fnc_gameInfo`; the contract is documented in `addons/games/functions/fnc_rules_chess.sqf`.
