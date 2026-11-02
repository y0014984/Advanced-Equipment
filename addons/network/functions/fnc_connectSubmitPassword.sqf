// File: fnc_connectSubmitPassword.sqf
/*
 * Author: Root
 * Description: Connect button handler for the router password prompt. Compares the entered password
 * against the target router's AE3_network_password; on a match it performs the pending connection
 * and closes the dialog, otherwise it reports a failure and leaves the dialog open to retry.
 * Client-side.
 *
 * Arguments:
 * 0: _control <CONTROL> - The Connect button
 *
 * Return Value:
 * None
 *
 * Example:
 * call AE3_network_fnc_connectSubmitPassword;
 *
 * Public: No
 */

params ["_control"];

private _dlg = ctrlParent _control;
if (isNull _dlg) exitWith {};

private _pending = uiNamespace getVariable ["AE3_network_pendingConnect", []];
if (_pending isEqualTo []) exitWith { _dlg closeDisplay 0; };

_pending params ["_device", "_router", "_connect"];

if (isNull _device || isNull _router) exitWith
{
	uiNamespace setVariable ["AE3_network_pendingConnect", nil];
	_dlg closeDisplay 0;
};

private _entered = ctrlText (_dlg displayCtrl 17041);

if (_entered isEqualTo (_router getVariable ["AE3_network_password", ""])) then
{
	[_device, _router, _entered] call _connect;
	uiNamespace setVariable ["AE3_network_pendingConnect", nil];
	_dlg closeDisplay 0;
}
else
{
	hint localize "STR_AE3_Network_Interaction_WrongPassword";
};
