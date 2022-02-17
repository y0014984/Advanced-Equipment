params ["_target", "_router"];

_router = _target getVariable "AE3_networkCableDevice";

if (!isNil "_router") then
{
	_connectedDevices = _router getVariable "AE3_power_connectedDevices";

	_index = _connectedDevices findIf {_x isEqualTo _target};

	_connectedDevices deleteAt _index;

	_router setVariable ["AE3_power_connectedDevices", _connectedDevices, true];
};

_target setVariable ["AE3_networkConnectionState", 0, true];

_target setVariable ["AE3_networkCableDevice", nil, true];

[_target, true, [0, 1, 1], 0] call ace_dragging_fnc_setCarryable;

[_target, 1] call ace_cargo_fnc_setSize;

/* ========================*/

_ipAddress = _target getVariable ["AE3_ipAddress", "127.0.0.1"];

_dhcpLeases = _router getVariable ["AE3_dhcpLeases", -1];

_usedLease = parseNumber ((_ipAddress splitString ".") select 3);

_dhcpLeases set [_usedLease, -1];

_router setVariable ["AE3_dhcpLeases", _dhcpLeases];

_ipAddress = "127.0.0.1";

_target setVariable ["AE3_ipAddress", _ipAddress, true];

/* ========================*/
