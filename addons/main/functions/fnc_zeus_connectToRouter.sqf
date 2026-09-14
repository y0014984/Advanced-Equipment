// File: fnc_zeus_connectToRouter.sqf
/*
 * Author: Root
 * Description: Connects the selected terminal asset to the router chosen in the Zeus Asset Attributes
 * Wi-Fi router picker. Validates the network password (blank = open network), drops any existing
 * connection first, then creates the new network connection on the server. Runs locally on the curator.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The Zeus asset attributes display
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call AE3_main_fnc_zeus_connectToRouter;
 *
 * Public: No
 */

params ["_display"];

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

private _combo = _display displayCtrl 1600;
private _idx = lbCurSel _combo;
if (_idx < 0) exitWith { ["AE3 Network", "Select a router first.", 5] call BIS_fnc_curatorHint; };

private _router = objectFromNetId (_combo lbData _idx);
if (isNull _router) exitWith { ["AE3 Network", "Selected router not found.", 5] call BIS_fnc_curatorHint; };

// Validate the network password: only an actual password (non-blank) is enforced.
private _routerPass = _router getVariable ["AE3_network_password", ""];
private _pass = ctrlText (_display displayCtrl 1914);
if (_routerPass isNotEqualTo "" && _pass isNotEqualTo _routerPass) exitWith
{
    ["AE3 Network", "Wrong network password.", 5] call BIS_fnc_curatorHint;
};

// Drop any current parent, then connect to the chosen router (server-side).
[_entity] remoteExecCall ["AE3_network_fnc_disconnect", 2];
[_entity, _router] remoteExecCall ["AE3_network_fnc_createNetworkConnection", 2];

private _name = [_router, true] call ace_cargo_fnc_getNameItem;
["AE3 Network", format ["Connecting to %1.", _name], 5] call BIS_fnc_curatorHint;
