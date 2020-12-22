params ["_target", "_router"];

_target setVariable ["AE3_networkConnectionState", 1, true];

_target setVariable ["AE3_networkCableDevice", _router, true];

[_target, false, [0, 1, 1], 0] call ace_dragging_fnc_setCarryable;

[_target, -1] call ace_cargo_fnc_setSize;

_connectedDevices = _router getVariable "AE3_connectedDevices";

_dhcpLeases = _router getVariable ["AE3_dhcpLeases", -1];

_unusedLease = _dhcpLeases findIf { _x isEqualTo -1 };

if (_unusedLease != -1) then
{
	_dhcpLeases set [_unusedLease, _target];

	_router setVariable ["AE3_dhcpLeases", _dhcpLeases];

	_dhcpBase = _router getVariable ["AE3_networkDhcpBase", "10.10.10."];
	_dhcpStart = _router getVariable ["AE3_networkDhcpStart", 0];

	_ipAddress = format ["%1%2", _dhcpBase, (_dhcpStart + _unusedLease)];

	_target setVariable ["AE3_ipAddress", _ipAddress, true];
};

if (isNil "_connectedDevices") then 
{
	_connectedDevices = [_target];
}
else 
{
	_connectedDevices pushBack _target;
};

_router setVariable ["AE3_connectedDevices", _connectedDevices, true];

_target setVariable ["AE3_networkCableDevice", _router, true];