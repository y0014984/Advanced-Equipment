/**
 * PUBLIC
 *
 * Disconnects a device from its parent router.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * None
 *
 * Example:
 * [_entity] call AE3_network_fnc_disconnect;
 *
 */

params['_entity'];

[_entity] call AE3_network_fnc_removeNetworkConnection;