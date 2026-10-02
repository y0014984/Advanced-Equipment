// File: fnc_netScan.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Lists AE3 routers within wireless range of the laptop for the web Network app.
 * Routers are tagged AE3_cap_isRouter by AE3_network_fnc_initRouter. Returns a lightweight list
 * (ssid + ip + netId) the client uses to render and to request a connection. Client-local read.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The bound laptop
 *
 * Return Value:
 * Networks <ARRAY> of <HASHMAP> - keys: ssid, ip, netId, current, locked
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]]];

if (isNull _computer) exitWith { [] };

// Each router advertises its OWN wireless range: a laptop sees a network only when it sits
// within that router's range, not a single global radius. Scan out to the configured maximum, then
// keep routers whose individual range reaches this laptop.
private _scanCap = missionNamespace getVariable [QGVAR(wirelessRangeMax), 500];
private _parent = _computer getVariable ["AE3_network_parent", objNull];

// nearestObjects only finds routers that stand in the world. A router carried by a player - a backpack
// broadcasting a network - is not one of them, so the registry every router adds itself to on init is
// scanned alongside it. Both lists then face the same alive, range and power tests, and the union is
// deduplicated so a router that appears in both is listed once.
private _candidates = nearestObjects [_computer, [], _scanCap];
{
   _candidates pushBackUnique _x;
} forEach (missionNamespace getVariable ["AE3_network_routers", []]);

private _routers = _candidates select {
    (_x != _computer) && {alive _x} && {_x getVariable ["AE3_cap_isRouter", false]} &&
    {(_computer distance _x) <= (_x getVariable ["AE3_network_wirelessRange", 100])} &&
    {(_x getVariable ["AE3_power_powerState", 0]) == 1}
};

private _list = [];
{
    private _ssid = _x getVariable ["ace_cargo_customName", ""];
    if (_ssid isEqualTo "") then { _ssid = getText (configOf _x >> "displayName"); };
    if (_ssid isEqualTo "") then { _ssid = typeOf _x; };
    _list pushBack createHashMapFromArray [
        ["ssid", _ssid],
        ["ip", ([_x getVariable ["AE3_network_address", [127, 0, 0, 1]]] call AE3_network_fnc_ip2str)],
        ["netId", netId _x],
        ["current", _x isEqualTo _parent],
        ["locked", (_x getVariable ["AE3_network_password", ""]) isNotEqualTo ""]
    ];
} forEach _routers;

_list
