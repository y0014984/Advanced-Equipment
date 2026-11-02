#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Returns the devices connected to a router. Cascaded child routers are left out unless requested.
 * Returns a new array. Any machine.
 *
 * Arguments:
 * 0: _router <OBJECT> - The router
 * 1: _includeRouters <BOOL> - (Optional, default: false) Include cascaded child routers
 *
 * Return Value:
 * Clients <ARRAY> of <OBJECT>
 *
 * Example:
 * private _laptops = [_router] call AE3_network_fnc_getClients;
 *
 * Public: Yes
 */

params [["_router", objNull, [objNull]], ["_includeRouters", false, [false]]];

if (isNull _router) exitWith { [] };

(_router getVariable ["AE3_network_children", []]) select {
    !isNull _x && {_includeRouters || {!(_x getVariable ["AE3_cap_isRouter", false])}}
}
