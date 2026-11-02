// File: fnc_wirelessSweep.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Keeps every wireless connection honest for as long as it lasts. A laptop joins a network
 * by standing inside a router's range and giving its password, but nothing held it there afterwards: the
 * connection was made once and then kept regardless of where either end went, so a laptop carried to the
 * far side of the map stayed on the network it left behind and remained reachable over it. A router that
 * is carried - an EWO's backpack - moves the range itself, which makes the check a live one rather than
 * something that can be settled at connect time.
 *
 * Each pass drops the clients that AE3_network_fnc_canConnect no longer allows on their router: router dead
 * or switched off, out of AE3_network_fnc_getWirelessRange, router not accepting connections, or a registered
 * connect condition refusing. A dropped client loses its address and has to connect again.
 *
 * Cascaded child routers are left alone: they manage their own subnets and a mission may deliberately
 * link two routers that stand far apart.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */

if (!isServer) exitWith {};

{
    private _router = _x;

    // getClients returns a copy: removeNetworkConnection edits the children array as it goes.
    {
        private _client = _x;
        ([_client, _router] call FUNC(canConnect)) params ["_allowed", "_reason"];
        if (_allowed) then {continue};

        private _clientOwner = owner _client;
        if (_clientOwner > 0) then {
            ["ae3_desktop_netResult", [false, _reason], _clientOwner] call CBA_fnc_ownerEvent;
        };
        [_client] call FUNC(removeNetworkConnection);
    } forEach ([_router] call FUNC(getClients));
} forEach (call FUNC(getRouters));
