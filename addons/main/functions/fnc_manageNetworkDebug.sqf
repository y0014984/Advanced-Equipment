/*
 * Author: Root
 * Description: Toggles AE3 network debug logging. When enabled, logs all AE3-related remoteExec traffic observed on the local machine via diag_log.
 *
 * Arguments:
 * 0: _enabled <BOOL> - Enable/disable logging
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call AE3_main_fnc_manageNetworkDebug;
 *
 * Public: No
 */

params ["_enabled"];

private _ehName = "HandleRemoteExec";
private _ehId = missionNamespace getVariable ["AE3_NetworkDebugEH", -1];

missionNamespace setVariable ["AE3_NetworkDebugEnabled", _enabled];

if (_enabled) then {
	if (_ehId >= 0) exitWith {};

	_ehId = addMissionEventHandler [
		_ehName,
		{
			params ["_fnName", "_args", "_target", "_isJip"];

			// Only log when network debug is enabled and the function is AE3-prefixed
			if !(missionNamespace getVariable ["AE3_NetworkDebugEnabled", false]) exitWith {true};
			if !(_fnName isEqualType "") exitWith {true};
			if (_fnName find "AE3_" != 0) exitWith {true};

			private _sender = if (!isNil "remoteExecutedOwner") then { remoteExecutedOwner } else { -1 };
			diag_log format ["[AE3][NET][recv] fn=%1 target=%2 jip=%3 sender=%4 args=%5", _fnName, _target, _isJip, _sender, _args];

			// Always allow execution
			true
		}
	];

	missionNamespace setVariable ["AE3_NetworkDebugEH", _ehId];
} else {
	if (_ehId >= 0) then {
		removeMissionEventHandler [_ehName, _ehId];
	};
	missionNamespace setVariable ["AE3_NetworkDebugEH", nil];
};
