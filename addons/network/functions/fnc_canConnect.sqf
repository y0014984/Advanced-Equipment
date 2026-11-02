#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Whether a device may join or stay on a router over wireless. Checks in order, the first failure
 * is returned: router alive and powered on ("Network offline"), distance within
 * AE3_network_fnc_getWirelessRange ("Out of range"), router AE3_network_acceptConnections ("Connections
 * blocked"), registered connect conditions, then the password when one is given ("Wrong password"). Used by the
 * ACE menu, the Network app and the wireless sweep. Any machine; the server result is authoritative.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device
 * 1: _router <OBJECT> - The router
 * 2: _password <STRING> - (Optional, default: nil) Password to check. nil skips the password check
 *
 * Return Value:
 * [allowed, reason] <ARRAY> - reason is "" when allowed
 *
 * Example:
 * ([_laptop, _router] call AE3_network_fnc_canConnect) params ["_allowed", "_reason"];
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]], ["_router", objNull, [objNull]], ["_password", nil, [""]]];

if (isNull _device || {isNull _router} || {!alive _router} || {!(_router getVariable ["AE3_cap_isRouter", false])}) exitWith {
    [false, "Network offline"]
};
if (!([_router] call AE3_power_fnc_isPoweredOn)) exitWith { [false, "Network offline"] };
if ((_device distance _router) > ([_router, _device] call FUNC(getWirelessRange))) exitWith { [false, "Out of range"] };
if !(_router getVariable ["AE3_network_acceptConnections", true]) exitWith { [false, "Connections blocked"] };

private _result = [true, ""];
{
    private _verdict = [_device, _router] call _y;
    if (isNil "_verdict") then { continue; };
    if (_verdict isEqualType true) then { _verdict = [_verdict, ""]; };
    if !(_verdict isEqualType []) then { continue; };
    _verdict params [["_allowed", true, [true]], ["_reason", "", [""]]];
    if (!_allowed) exitWith {
        _result = [false, ["Connection refused", _reason] select (_reason isNotEqualTo "")];
    };
} forEach (missionNamespace getVariable [QGVAR(connectConditions), createHashMap]);

if !(_result select 0) exitWith { _result };

private _routerPassword = _router getVariable ["AE3_network_password", ""];
if (!isNil "_password" && _routerPassword isNotEqualTo "" && {_password isNotEqualTo _routerPassword}) exitWith {
    [false, "Wrong password"]
};

[true, ""]
