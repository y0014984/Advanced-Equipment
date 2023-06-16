/**
 * PUBLIC
 *
 * This function creates a network connection from the _from object to the _to object.
 *
 * Arguments:
 * 1: From <OBJECT>
 * 2: To <OBJECT>
 *
 * Results:
 * None
 *
 * Examples:
 * [_laptop, _router] call AE3_network_fnc_createNetworkConnection;
 * [_router, _router] call AE3_network_fnc_createNetworkConnection;
 *
 */

params ["_from", "_to"];

[_from, _to] spawn 
{
    params ["_from", "_to"];
    
    // wait until both devices have relevant variables set; this indicates that the init process is done
    waitUntil { !(isNil { _from getVariable "AE3_network_address"; }) && !(isNil { _to getVariable "AE3_network_children"; }) };

    if (isNil { _from getVariable "AE3_network_children"; }) then
    {
        [_from, _to] call AE3_network_fnc_connect_device2router;
    }
    else
    {
        [_from, _to] call AE3_network_fnc_connect_router2router;
    };
};