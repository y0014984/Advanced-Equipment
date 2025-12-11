/*
 * Author: Root
 * Description: Handles the termination/deletion of an AE3 device. Automatically turns off the device and removes all power and network connections (both incoming and outgoing).
 * Can be triggered automatically when an asset is deleted by Zeus, or called manually.
 *
 * Arguments:
 * 0: _device <OBJECT> - The device to terminate
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop] call AE3_main_fnc_terminateDevice;
 *
 * Public: Yes
 */

params ["_device"];

private _powerState = _device getVariable ["AE3_power_powerState", nil];

// if the device has a powerState, then it's a power device and can be turned off
// Also connections can be removed if in place
if (!isNil "_powerState") then
{
    /* ================================================================================ */

    // turn off device
    [_device] call AE3_power_fnc_turnOffDevice;

    /* ================================================================================ */

    // if _device == power provider (has connected power devices) then remove all power connections from connected power consumers
    private _connectedPowerConsumers = _device getVariable ["AE3_power_connectedDevices", []];
    {
        [_x] call AE3_power_fnc_removePowerConnection;
    } forEach _connectedPowerConsumers;
    // safely remove all power connections from power provider itself
    _connectedPowerConsumers = [];
    _device setVariable ["AE3_power_connectedDevices", _connectedPowerConsumers, true];

    // if _device == power consumer (has a connected power cable device) then remove power connection
    private _powerProvider = _device getVariable ["AE3_power_powerCableDevice", objNull];
    if(!(isNull _powerProvider)) then
    {
        [_device] call AE3_power_fnc_removePowerConnection;
    };

    /* ================================================================================ */

    // if _device == network provider (has connected network devices) then remove all network connections from connected network consumers
    private _connectedNetworkConsumers = _device getVariable ["AE3_network_children", []];
    {
        [_x] call AE3_network_fnc_removeNetworkConnection;
    } forEach _connectedNetworkConsumers;
    // safely remove all network connections from network provider itself
    _connectedNetworkConsumers = [];
    _device setVariable ["AE3_network_children", _connectedNetworkConsumers, true];

    // if _device == network consumer (has a network parent) then remove network connection
    private _networkProvider = _device getVariable ["AE3_network_parent", objNull];
    if(!(isNull _networkProvider)) then
    {
        [_device] call AE3_network_fnc_removeNetworkConnection;
    };

    /* ================================================================================ */
};

// Check if this device is a laptop in stable mode tracking
private _laptopTracker = missionNamespace getVariable ["AE3_LAPTOP_STABLE_TRACKER", createHashMap];

// Find if this laptop object is tracked
private _trackedItem = "";
{
    if (_y == _device) exitWith {
        _trackedItem = _x;
    };
} forEach _laptopTracker;

// If found, clean up the tracker and remove the item from whoever has it
if (_trackedItem != "") then {
    // Remove from tracker
    _laptopTracker deleteAt _trackedItem;
    missionNamespace setVariable ["AE3_LAPTOP_STABLE_TRACKER", _laptopTracker, true];

    // Find and remove the item from any unit or container
    {
        if (_trackedItem in (items _x)) then {
            [_x, _trackedItem] call CBA_fnc_removeItem;
            if (AE3_DebugMode) then {
                diag_log format ["AE3: Removed stable laptop item %1 from %2 due to laptop destruction", _trackedItem, _x];
            };
        };
    } forEach (allUnits + vehicles);
};
