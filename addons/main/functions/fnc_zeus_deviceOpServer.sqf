// File: fnc_zeus_deviceOpServer.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Server-side handler for Zeus device operations (event "ae3_main_zeusDeviceOp").
 * Ensures the target computer's filesystem is initialized (on demand), performs the requested
 * operation and reports the result back to the curator via the "ae3_main_zeusOpFeedback" event.
 * Replaces the old client-side waitForFilesystem polling, which timed out on dedicated servers.
 *
 * Arguments:
 * 0: _computerNetId <STRING> - netId of the target computer
 * 1: _op <STRING> - Operation: "addUser", "addSudoer", "addCalendarEvent", "addGames", "addFile", "addDir"
 * 2: _args <ARRAY> - Operation arguments (see the matching AE3 server function)
 * 3: _curatorOwner <NUMBER> - clientOwner of the requesting curator (for feedback)
 *
 * Return Value:
 * None
 *
 * Example:
 * ["ae3_main_zeusDeviceOp", [netId _laptop, "addUser", ["user", "pw"], clientOwner]] call CBA_fnc_serverEvent;
 *
 * Public: No
 */

params ["_computerNetId", "_op", "_args", "_curatorOwner"];

if (!isServer) exitWith {};

private _computer = objectFromNetId _computerNetId;

private _ready = [_computer] call AE3_armaos_fnc_device_ensureInit;

if (!_ready) exitWith
{
	WARNING_2("Zeus op '%1' failed: %2 is not an initialized AE3 device",_op,typeOf _computer);
	["ae3_main_zeusOpFeedback", [false, _op, _args], _curatorOwner] call CBA_fnc_ownerEvent;
};

// Honor each op's own success/failure so the curator gets accurate feedback. addCalendarEvent, for
// example, returns false on a non-ISO date - previously this always reported success, so a rejected
// event looked like it had been added. Ops that do not return a bool are treated as success.
private _result = true;
switch (_op) do
{
	case "addUser":              { ([_computer] + _args) call AE3_armaos_fnc_computer_addUser; };
	case "addSudoer":            { _result = ([_computer] + _args) call AE3_armaos_fnc_computer_addSudoer; };
	case "addCalendarEvent":     { _result = ([_computer] + _args) call AE3_armaos_fnc_computer_addCalendarEvent; };
	case "addGames":             { ([_computer] + _args) call AE3_armaos_fnc_computer_addGames; };
	case "addFile":              { ([_computer] + _args) call AE3_filesystem_fnc_device_addFile; };
	case "addDir":               { ([_computer] + _args) call AE3_filesystem_fnc_device_addDir; };
	default
	{
		WARNING_1("Unknown Zeus device op '%1'",_op);
	};
};
if !(_result isEqualType true) then { _result = true; };

["ae3_main_zeusOpFeedback", [_result, _op, _args], _curatorOwner] call CBA_fnc_ownerEvent;
