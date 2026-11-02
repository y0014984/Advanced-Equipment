// File: fnc_promptConnect.sqf
/*
 * Author: Root
 * Description: Gate for joining a router from the ACE interaction menu. A non-router device is first
 * checked with AE3_network_fnc_canConnect; a refusal is shown as a hint. When the router has no
 * password the connection is made immediately; when a password is set, a prompt is shown and the
 * connection is only performed once the correct password is entered
 * (AE3_network_fnc_connectSubmitPassword). Client-side.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device (or router) requesting the connection
 * 1: _router <OBJECT> - The router being joined
 * 2: _connect <CODE> - Connection function called as [_device, _router, _password] call _connect on success
 *
 * Return Value:
 * None
 *
 * Example:
 * [_device, _router, AE3_network_fnc_connect_device2router] call AE3_network_fnc_promptConnect;
 *
 * Public: No
 */

params ["_device", "_router", "_connect"];

if (isNull _device || isNull _router) exitWith {};

private _check = if (_device getVariable ["AE3_cap_isRouter", false]) then { [true, ""] } else { [_device, _router] call AE3_network_fnc_canConnect };
if !(_check select 0) exitWith { hint (_check select 1); };

private _password = _router getVariable ["AE3_network_password", ""];

// Open routers (no password) or non-interface machines connect straight away.
if (_password isEqualTo "" || {!hasInterface}) exitWith
{
	[_device, _router, _password] call _connect;
};

if (!createDialog "AE3_NetworkPasswordDialog") exitWith
{
	// Fall back to a direct connection if the dialog cannot be shown.
	[_device, _router, _password] call _connect;
};

uiNamespace setVariable ["AE3_network_pendingConnect", [_device, _router, _connect]];
ctrlSetFocus (findDisplay 17040 displayCtrl 17041);
