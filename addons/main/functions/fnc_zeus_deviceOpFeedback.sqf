// File: fnc_zeus_deviceOpFeedback.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Client-side handler for the "ae3_main_zeusOpFeedback" event. Shows curator
 * feedback for a Zeus device operation processed on the server.
 *
 * Arguments:
 * 0: _success <BOOL> - Whether the operation was performed
 * 1: _op <STRING> - Operation name
 * 2: _args <ARRAY> - Original operation arguments
 *
 * Return Value:
 * None
 *
 * Example:
 * [true, "addUser", ["user", "pw"]] call AE3_main_fnc_zeus_deviceOpFeedback;
 *
 * Public: No
 */

params ["_success", "_op", "_args"];

if (!_success) exitWith
{
	[objNull, localize "STR_AE3_Main_Zeus_FilesystemNotReady"] call BIS_fnc_showCuratorFeedbackMessage;
};

switch (_op) do
{
	case "addUser":
	{
		_args params ["_username", "_password"];
		private _message = format ["'%1': %2 '%3': %4", localize "STR_AE3_Main_Zeus_Username", _username, localize "STR_AE3_Main_Zeus_Password", _password];
		[localize "STR_AE3_Main_Zeus_UserAdded", _message, 5] call BIS_fnc_curatorHint;
	};
	case "addSudoer":
	{
		_args params ["_username"];
		private _message = format ["'%1': %2", localize "STR_AE3_Main_Zeus_Username", _username];
		[localize "STR_AE3_Main_Zeus_SudoerAdded", _message, 5] call BIS_fnc_curatorHint;
	};
	case "addGames":
	{
		_args params ["_isSnake"];
		[localize "STR_AE3_Main_Zeus_GamesAdded", format ["snake: %1", _isSnake], 5] call BIS_fnc_curatorHint;
	};
	case "addFile":
	{
		_args params ["_path"];
		[localize "STR_AE3_Main_Zeus_FileAdded", format ["%1: %2", localize "STR_AE3_Main_Zeus_Path", _path], 5] call BIS_fnc_curatorHint;
	};
	case "addDir":
	{
		_args params ["_path"];
		[localize "STR_AE3_Main_Zeus_DirectoryAdded", format ["%1: %2", localize "STR_AE3_Main_Zeus_Path", _path], 5] call BIS_fnc_curatorHint;
	};
};
