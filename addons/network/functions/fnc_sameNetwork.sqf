// File: fnc_sameNetwork.sqf
/**
 * Author: Root
 * Tests whether two devices share a network: both reach the same top-level router through
 * their AE3_network_parent chains. A device with no uplink is its own network.
 *
 * Arguments:
 * 0: Device A <OBJECT>
 * 1: Device B <OBJECT>
 *
 * Returns:
 * Same network <BOOL>
 */

params [["_a", objNull, [objNull]], ["_b", objNull, [objNull]]];

if (isNull _a || {isNull _b}) exitWith { false };
if (_a isEqualTo _b) exitWith { true };

private _root =
{
	params ["_device"];
	private _depth = 0;
	private _parent = _device getVariable ["AE3_network_parent", objNull];
	while { !isNull _parent && _depth < 32 } do
	{
		_device = _parent;
		_parent = _device getVariable ["AE3_network_parent", objNull];
		_depth = _depth + 1;
	};
	_device
};

([_a] call _root) isEqualTo ([_b] call _root)
