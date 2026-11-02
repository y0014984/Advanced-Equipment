#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Whether a device or router is on a network: it has an address other than 127.0.0.1 and is either a
 * router or connected to one. Power is not checked. Any machine.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device
 *
 * Return Value:
 * Online <BOOL>
 *
 * Example:
 * if ([_laptop] call AE3_network_fnc_isOnline) then { hint "on a network"; };
 *
 * Public: Yes
 */

params [["_device", objNull, [objNull]]];

!isNull _device
    && {(_device getVariable ["AE3_network_address", [127, 0, 0, 1]]) isNotEqualTo [127, 0, 0, 1]}
    && {_device getVariable ["AE3_cap_isRouter", false] || {!isNull (_device getVariable ["AE3_network_parent", objNull])}}
