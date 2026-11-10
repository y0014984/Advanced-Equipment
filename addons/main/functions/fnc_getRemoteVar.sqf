// File: fnc_getRemoteVar.sqf
/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Retrieves a variable from a remote client and sets it locally. Waits until the variable transfer is complete.
 *
 * Arguments:
 * 0: _namespace <NAMESPACE> - Namespace where the variable should be stored locally
 * 1: _variable <STRING> - Name of the variable to retrieve
 * 2: _from <NUMBER> (Optional) - Client ID to retrieve from, default: 2 (server)
 * 3: _timeout <NUMBER> (Optional) - Seconds to wait before giving up, default: -1 (no limit)
 *
 * Return Value:
 * true when the transfer completed, false on timeout <BOOL>
 *
 * Example:
 * [missionNamespace, "remoteData"] call AE3_main_fnc_getRemoteVar;
 * [missionNamespace, "remoteData", 3] call AE3_main_fnc_getRemoteVar; // From specific client
 * [_laptop, "AE3_filesystem", 3, 10] call AE3_main_fnc_getRemoteVar; // Give up after 10 s
 *
 * Public: No
 */

params['_namespace', '_variable', ['_from', 2], ['_timeout', -1]];

if(!isMultiplayer) exitWith { true };

// If running in unscheduled environment, re-spawn in scheduled environment
// This prevents "Suspending not allowed" errors when called from event handlers
if (!canSuspend) exitWith {
	[_namespace, _variable, _from, _timeout] spawn AE3_main_fnc_getRemoteVar;
};

private _transfer = _variable + "_trans";
_namespace setVariable [_transfer, false];

[clientOwner, _namespace, _variable] remoteExecCall ["AE3_main_fnc_sendVarToRemote", _from];

private _deadline = [-1, diag_tickTime + _timeout] select (_timeout >= 0);

// Wait until the variable is set
waitUntil
{
	// if the var does not exist, waitUntil gets a nil error, because it expects true or false; therefore default value false
	// this could be the case if there are a lot of requests for a var
	(_namespace getVariable [_transfer, false]) || {_deadline >= 0 && {diag_tickTime > _deadline}}
};
private _done = _namespace getVariable [_transfer, false];
_namespace setVariable [_transfer, nil];

_done
