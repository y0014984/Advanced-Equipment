// File: fnc_removeNetworkConnection.sqf
/**
 * PUBLIC
 *
 * Removes the network connection (Uplink) for a given device and updates the available interactions.
 *
 * Arguments:
 * 0: Network Consumer <OBJECT>
 * 
 * Returns:
 * None
 *
 * Example:
 * [_entity] call AE3_network_fnc_removeNetworkConnection;
 *
 */

params ["_networkConsumer"];

if (isNull _networkConsumer) exitWith { false };

// Leaving a network re-leases the remaining devices on that router, so the disconnect is applied on
// the server where the full device registry is available to detect duplicate addresses.
if (!isServer) exitWith
{
	["ae3_network_disconnectDevice", [netId _networkConsumer]] call CBA_fnc_serverEvent;
	true
};

private _networkProvider = _networkConsumer getVariable ["AE3_network_parent", objNull];

if (!(isNull _networkProvider)) then
{
    // remove network consumer from network providers list of connected devices
	private _connectedDevices = _networkProvider getVariable ["AE3_network_children", []];
    _connectedDevices = _connectedDevices - [_networkConsumer];
    _networkProvider setVariable ["AE3_network_children", _connectedDevices, true];

    if((_connectedDevices isNotEqualTo [])) then
    {
        [_networkProvider] call AE3_network_fnc_dhcp_refresh;
    };

    // set network provider to "network disconnected" if it has no connected children and no connected parent-parent
    if (_connectedDevices isEqualTo []) then
    {
        private __networkProviderParent = _networkProvider getVariable ["AE3_network_parent", objNull];
        if (isNull __networkProviderParent) then
        {
            [_networkProvider, "networkConnected", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
        };
    };
};

// remove network connection from network consumer
_networkConsumer setVariable ["AE3_network_parent", nil, true];

// set network consumer to "network disconnected" if it has no connected children
if (count call {_networkConsumer getVariable ["AE3_network_children", []]} == 0) then
{
    [_networkConsumer, "networkConnected", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
};

// reset ip address of network consumer
_networkConsumer setVariable ["AE3_network_staticIp", "", true];
_networkConsumer setVariable ["AE3_network_address", [127, 0, 0, 1], true];

true;
