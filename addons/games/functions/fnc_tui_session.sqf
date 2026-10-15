// File: fnc_tui_session.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: The terminal front end of a networked game, and the only one available on a computer
 * where the browser interface is not. It is a lobby and a prompt: the server still owns the match, so
 * this asks for the lobby, sends the moves a player types and prints what comes back. A view that
 * arrives while the prompt is waiting is printed straight away, which is how a player sees the
 * opponent move without pressing anything. Quitting closes the game but keeps the seat, so the match
 * can be picked up again later; leaving gives the seat up. Client only, and it suspends, so it runs
 * from a command's own scheduled context.
 *
 * Arguments:
 * 0: _gameId <STRING> - Game id
 * 1: _computer <OBJECT> - Computer the session runs on
 *
 * Return Value:
 * None
 *
 * Example:
 * ["chess", _computer] call AE3_games_fnc_tui_session;
 *
 * Public: No
 */

params [["_gameId", "", [""]], ["_computer", objNull, [objNull]]];

if (isNull _computer) exitWith {};

private _deviceNetId = netId _computer;

uiNamespace setVariable [QGVAR(tuiComputer), _computer];
uiNamespace setVariable [QGVAR(tuiTable), ""];
uiNamespace setVariable [QGVAR(tuiGame), _gameId];

// Printed by the event handler below as well as by the prompt loop, so both show the same thing
private _fnc_printView =
{
    params ["_target", "_payload"];

    private _kind = _payload getOrDefault ["kind", ""];

    if (_kind isEqualTo "notice") exitWith
    {
        [_target, format ["  %1", _payload getOrDefault ["text", ""]]] call AE3_armaos_fnc_shell_stdout;
    };

    if (_kind isEqualTo "lobby") exitWith
    {
        private _lines = ["", format ["  %1", localize "STR_AE3_Games_Terminal_LobbyTitle"], ""];

        _lines pushBack format ["  %1:", localize "STR_AE3_Games_Terminal_Resumable"];

        private _mine = _payload getOrDefault ["resumable", []];
        private _open = _payload getOrDefault ["joinable", []];

        if (_mine isEqualTo []) then
        {
            _lines pushBack format ["    %1", localize "STR_AE3_Games_Terminal_None"];
        }
        else
        {
            {
                private _label = _x getOrDefault ["name", ""];

                if (_label isEqualTo "") then {_label = _x getOrDefault ["title", ""]};

                _lines pushBack format ["    %1) %2 - %3, %4/%5 seated", _forEachIndex + 1, _label, _x getOrDefault ["phase", ""], _x getOrDefault ["seated", 0], _x getOrDefault ["seatCount", 0]];
            } forEach _mine;
        };

        _lines pushBack "";
        _lines pushBack format ["  %1:", localize "STR_AE3_Games_Terminal_Joinable"];

        if (_open isEqualTo []) then
        {
            _lines pushBack format ["    %1", localize "STR_AE3_Games_Terminal_None"];
        }
        else
        {
            {
                private _label = _x getOrDefault ["name", ""];

                if (_label isEqualTo "") then {_label = _x getOrDefault ["title", ""]};

                _lines pushBack format ["    %1) %2 on %3, %4/%5 seated", _forEachIndex + 1, _label, _x getOrDefault ["host", ""], _x getOrDefault ["seated", 0], _x getOrDefault ["seatCount", 0]];
            } forEach _open;
        };

        _lines pushBack "";
        _lines pushBack format ["  %1", localize "STR_AE3_Games_Terminal_LobbyHelp"];

        uiNamespace setVariable [QGVAR(tuiLobby), [_mine, _open]];

        [_target, _lines] call AE3_armaos_fnc_shell_stdout;
    };

    if (_kind isNotEqualTo "table") exitWith {};

    uiNamespace setVariable [QGVAR(tuiTable), _payload getOrDefault ["id", ""]];

    private _seat = _payload getOrDefault ["seat", 0];
    private _phase = _payload getOrDefault ["phase", "lobby"];
    private _lines = [];

    if (_phase isEqualTo "lobby") then
    {
        private _tableName = _payload getOrDefault ["name", ""];

        if (_tableName isEqualTo "") then {_tableName = _payload getOrDefault ["title", ""]};

        _lines pushBack "";
        _lines pushBack format ["  %1", _tableName];
        _lines pushBack format ["  %1", localize "STR_AE3_Games_Terminal_WaitingSeats"];
        _lines pushBack "";

        // Who is sitting where, and the side each of them asked for while the table is still open
        {
            _x params [["_seatIndex", 0], ["_seatLabel", ""], ["_seatPref", "random"]];

            private _row = format ["    %1) %2", _seatIndex + 1, _seatLabel];

            if (_seatIndex isEqualTo _seat) then {_row = _row + "   (you)"};
            if ((_payload getOrDefault ["sideChoice", "none"]) isEqualTo "colour") then {_row = _row + format ["   wants %1", _seatPref]};
            if ((_payload getOrDefault ["starter", -1]) isEqualTo _seatIndex) then {_row = _row + "   starts"};

            _lines pushBack _row;
        } forEach (_payload getOrDefault ["seats", []]);

        _lines pushBack "";
        _lines pushBack format ["  %1", localize "STR_AE3_Games_Terminal_LobbyOptions"];
    }
    else
    {
        _lines = [_payload getOrDefault ["gameId", ""], _payload getOrDefault ["view", []], _seat] call FUNC(tui_renderBoard);

        if (_phase isEqualTo "over") then
        {
            private _winner = _payload getOrDefault ["winner", -1];
            private _key = "STR_AE3_Games_Terminal_Draw";

            if (_winner isEqualTo _seat) then {_key = "STR_AE3_Games_Terminal_YouWon"};
            if (_winner >= 0 && (_winner isNotEqualTo _seat)) then {_key = "STR_AE3_Games_Terminal_YouLost"};

            _lines pushBack format ["  %1", localize _key];
        }
        else
        {
            private _turnKey = ["STR_AE3_Games_Terminal_TheirTurn", "STR_AE3_Games_Terminal_YourTurn"] select ((_payload getOrDefault ["turn", -1]) isEqualTo _seat);

            _lines pushBack format ["  %1", localize _turnKey];

            if (((_payload getOrDefault ["view", []]) param [2, false]) isEqualTo true) then
            {
                _lines pushBack format ["  %1", localize "STR_AE3_Games_Terminal_InCheck"];
            };
        };

        _lines pushBack format ["  %1", localize "STR_AE3_Games_Terminal_GameHelp"];
    };

    [_target, _lines] call AE3_armaos_fnc_shell_stdout;
};

uiNamespace setVariable [QGVAR(tuiPrint), _fnc_printView];

// Prints an update the moment it arrives, so a player watching the prompt sees the opponent's move
private _handler = ["ae3_games_viewUpdated", {
    params ["_payload"];

    private _computer = uiNamespace getVariable [QGVAR(tuiComputer), objNull];

    if (isNull _computer) exitWith {};
    if ((_payload getOrDefault ["device", ""]) isNotEqualTo netId _computer) exitWith {};

    [_computer, _payload] call (uiNamespace getVariable [QGVAR(tuiPrint), {}]);
}] call CBA_fnc_addEventHandler;

[_deviceNetId, _gameId] call FUNC(getTables);

private _running = true;

while {_running} do
{
    private _input = [_computer] call AE3_armaos_fnc_shell_stdin;
    private _text = toLowerANSI ([_input] param [0, ""]);
    private _words = _text splitString " ";
    private _command = _words param [0, ""];
    private _argument = parseNumber (_words param [1, "0"]);

    // Anything the player typed after the command word, with its own capitals left alone, which is
    // what a table name needs
    private _rest = "";

    if (count _words > 1) then {_rest = ((([_input] param [0, ""]) splitString " ") select [1]) joinString " "};
    private _tableId = uiNamespace getVariable [QGVAR(tuiTable), ""];
    private _lobby = uiNamespace getVariable [QGVAR(tuiLobby), [[], []]];

    switch (_command) do
    {
        case "": {};
        case "quit":
        {
            _running = false;
        };
        case "new":
        {
            [_deviceNetId, _gameId, _rest] call FUNC(hostTable);
        };
        case "name":
        {
            if (_tableId isNotEqualTo "") then {[_deviceNetId, _tableId, "name", _rest] call FUNC(setTableOption)};
        };
        case "seatname";
        case "me":
        {
            // Naming your own seat decides nothing, so unlike the rest of these it also works once
            // the match has started
            if (_tableId isNotEqualTo "") then {[_deviceNetId, _tableId, "seatname", _rest] call FUNC(setTableOption)};
        };
        case "pref";
        case "side":
        {
            if (_tableId isNotEqualTo "") then {[_deviceNetId, _tableId, "pref", _words param [1, ""]] call FUNC(setTableOption)};
        };
        case "starter":
        {
            // Seats are counted from one at the prompt and from zero underneath
            if (_tableId isNotEqualTo "") then {[_deviceNetId, _tableId, "starter", str (_argument - 1)] call FUNC(setTableOption)};
        };
        case "dummy":
        {
            if (_tableId isNotEqualTo "") then {[_deviceNetId, _tableId] call FUNC(addDummySeat)};
        };
        case "seat":
        {
            if (_tableId isNotEqualTo "") then {[_deviceNetId, _tableId, _argument - 1] call FUNC(setActiveSeat)};
        };
        case "refresh":
        {
            [_deviceNetId, _gameId] call FUNC(getTables);
        };
        case "start":
        {
            // A table with room left waits for its host rather than starting on its own
            if (_tableId isNotEqualTo "") then {[_deviceNetId, _tableId] call FUNC(startTable)};
        };
        case "lobby":
        {
            uiNamespace setVariable [QGVAR(tuiTable), ""];

            if (_tableId isNotEqualTo "") then {[_deviceNetId, _tableId, false] call FUNC(setGameOpen)};

            [_deviceNetId, _gameId] call FUNC(getTables);
        };
        case "resume";
        case "join":
        {
            private _list = [_lobby param [1, []], _lobby param [0, []]] select (_command isEqualTo "resume");
            private _row = _list param [_argument - 1, createHashMap];
            private _id = _row getOrDefault ["id", ""];

            if (_id isEqualTo "") then
            {
                [_computer, format ["  %1", localize "STR_AE3_Games_Terminal_Unknown"]] call AE3_armaos_fnc_shell_stdout;
            }
            else
            {
                [_deviceNetId, _id] call FUNC(joinTable);
                [_deviceNetId, _id, true] call FUNC(setGameOpen);
            };
        };
        case "leave":
        {
            if (_tableId isNotEqualTo "") then
            {
                [_deviceNetId, _tableId] call FUNC(leaveTable);

                uiNamespace setVariable [QGVAR(tuiTable), ""];

                [_deviceNetId, _gameId] call FUNC(getTables);
            };
        };
        case "board";
        case "status":
        {
            private _payload = missionNamespace getVariable [QGVAR(lastView), createHashMap];

            [_computer, _payload] call _fnc_printView;
        };
        default
        {
            // Anything else is a move in the game's own notation
            if (_tableId isEqualTo "") then
            {
                [_computer, format ["  %1", localize "STR_AE3_Games_Terminal_Unknown"]] call AE3_armaos_fnc_shell_stdout;
            }
            else
            {
                [_deviceNetId, _tableId, _text, clientOwner] call FUNC(applyMove);
            };
        };
    };
};

["ae3_games_viewUpdated", _handler] call CBA_fnc_removeEventHandler;

private _tableId = uiNamespace getVariable [QGVAR(tuiTable), ""];

// Quitting keeps the seat: only the game's power draw and the live output stop
if (_tableId isNotEqualTo "") then
{
    [_deviceNetId, _tableId, false] call FUNC(setGameOpen);
};

uiNamespace setVariable [QGVAR(tuiComputer), objNull];
uiNamespace setVariable [QGVAR(tuiTable), ""];
