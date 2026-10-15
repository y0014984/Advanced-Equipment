// File: fnc_tui_chess.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: The /games/chess terminal command. Checks the computer is on a network, since a table
 * is reached over the in-game network, then hands over to the shared game session loop. Client only.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Computer running the command
 * 1: _options <ARRAY> - Command options, none are used
 * 2: _commandName <STRING> - Name the command was called by
 *
 * Return Value:
 * None
 *
 * Example:
 * call AE3_games_fnc_tui_chess;
 *
 * Public: No
 */

params ["_computer", ["_options", []], ["_commandName", "chess"]];

if (isNull _computer) exitWith {};

// A table lives on the network, so a computer with no uplink has nothing to reach. The same-network
// requirement can be switched off, in which case any powered computer may play.
private _needsNetwork = [_computer, "RequireSameNetwork"] call FUNC(getSetting);

if (_needsNetwork isEqualTo true && {isNull (_computer getVariable ["AE3_network_parent", objNull])}) exitWith
{
    [_computer, format ["  %1", localize "STR_AE3_Games_Terminal_NoNetwork"]] call AE3_armaos_fnc_shell_stdout;
};

["chess", _computer] call FUNC(tui_session);
