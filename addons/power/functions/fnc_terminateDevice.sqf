params ["_device"];

systemchat format ["Deleted entity (General): %1", _device];

// turn off device
[_device] call AE3_power_fnc_turnOffDevice;

//private _generator = _device getVariable ["AE3_power_powerCableDevice", objNull];

// if _device == power provider (has connected power devices) then remove all power connections from connected power consumers
private _connectedPowerDevices = _device getVariable ["AE3_power_connectedDevices", []];
{
    [_x] call AE3_power_fnc_removePowerConnection;
} forEach _connectedPowerDevices;
// safely remove all power connections from power provider itself
_connectedDevices = [];
_device setVariable ["AE3_power_connectedDevices", _connectedDevices, true];

// if _device == power consumer (has a connected power cable device) then remove power connection
private _powerProvider = _device getVariable ["AE3_power_powerCableDevice", objNull];
if(!(isNull _powerProvider)) then
{
    [_device] call AE3_power_fnc_removePowerConnection;
};

/*
// if _device == network provider
[_device] call AE3_power_fnc_removeNetworkConnectionsFromProvider;
// if _device == network consumer
[_device] call AE3_power_fnc_removeNetworkConnectionFromConsumer;
*/


/*
_device addEventHandler
[
    "Deleted",
    {
        params ["_device"];

        systemchat format ["Deleted entity (General): %1", _device];
    }
];

private _class = typeOf _device;
if (_class isEqualTo "ModuleCurator_F") then
{
    _device addEventHandler ["CuratorObjectDeleted", {
        params ["_curator", "_device"];

        systemchat format ["Deleted entity (Curator): %1", _device];
    }];

    _device addEventHandler ["CuratorObjectEdited", {
        params ["_curator", "_device"];

        systemchat format ["Edited entity (Curator): %1", _device];
    }];

    _device addEventHandler ["CuratorObjectPlaced", {
        params ["_curator", "_device"];

        systemchat format ["Placed entity (Curator): %1", _device];
    }];
};
*/