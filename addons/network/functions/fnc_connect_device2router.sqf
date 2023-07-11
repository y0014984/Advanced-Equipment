/**
 * Connect a device to a router.
 *
 * Arguments:
 * 0: Device to connect <OBJECT>
 * 1: Parent router <OBJECT>
 *
 * Returns:
 * None
 */

params ["_device", "_parent"];

private _children = _parent getVariable ["AE3_network_children", []];
_parent setVariable ["AE3_network_children", _children + [_device], true];

_device setVariable ["AE3_network_parent", _parent, true];
_device setVariable ["AE3_network_address", [_device] call AE3_network_fnc_dhcp_get, true];

if (isNull _parent) then
{
    [_device, "networkConnected", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
}
else
{
    [_device, "networkConnected", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
    [_parent, "networkConnected", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
};