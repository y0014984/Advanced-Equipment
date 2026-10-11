// File: fnc_zeus_applyConnection.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Creates a power or network connection between two devices, validating the endpoints
 * against the allowed producer/consumer (power) or laptop/router (network) class lists. Shared by the
 * legacy Zeus Add Connection dialog and its Zeus Enhanced dialog variant. Runs on the curator's
 * machine. On success the connection is created, the curator is notified and the module is deleted;
 * on failure the endpoints are un-synchronised from the module and it is left in place.
 *
 * Arguments:
 * 0: _from <OBJECT> - Source device
 * 1: _to <OBJECT> - Target device
 * 2: _type <STRING> - "AE3_PowerConnection" or "AE3_NetworkConnection"
 * 3: _switch <BOOL> - Swap source/target before connecting
 * 4: _module <OBJECT> - The module logic (deleted on success)
 *
 * Return Value:
 * Whether the connection was created <BOOL>
 *
 * Example:
 * [_from, _to, "AE3_PowerConnection", false, _module] call AE3_main_fnc_zeus_applyConnection;
 *
 * Public: No
 */

params ["_from", "_to", "_type", ["_switch", false], ["_module", objNull]];

if (isNull _from) exitWith { [objNull, localize "STR_AE3_Main_Zeus_FromMissing"] call BIS_fnc_showCuratorFeedbackMessage; false };
if (isNull _to) exitWith { [objNull, localize "STR_AE3_Main_Zeus_ToMissing"] call BIS_fnc_showCuratorFeedbackMessage; false };

if (_switch) then
{
    private _tmp = _from;
    _from = _to;
    _to = _tmp;
};

private _fromNameWithAceCargoName = [_from, true] call ace_cargo_fnc_getNameItem;
private _toNameWithAceCargoName = [_to, true] call ace_cargo_fnc_getNameItem;
private _message = format ["'%1': %2 '%3': %4", localize "STR_AE3_Main_Zeus_From", _fromNameWithAceCargoName, localize "STR_AE3_Main_Zeus_To", _toNameWithAceCargoName];

private _allowedFromClasses = [];
private _allowedToClasses = [];

if (_type isEqualTo "AE3_PowerConnection") then
{
    private _config = configFile >> "CfgVehicles";

    // Consumers/batteries may receive power, producers/batteries may supply it.
    _allowedFromClasses =
    "
        isClass (_x >> 'AE3_Device' >> 'AE3_Consumer') ||
        isClass (_x >> 'AE3_Device' >> 'AE3_Battery')
    " configClasses _config;
    { _allowedFromClasses set [_forEachIndex, configName _x]; } forEach _allowedFromClasses;

    _allowedToClasses =
    "
        isClass (_x >> 'AE3_Device' >> 'AE3_Generator') ||
        isClass (_x >> 'AE3_Device' >> 'AE3_SolarGenerator') ||
        isClass (_x >> 'AE3_Device' >> 'AE3_Battery')
    " configClasses _config;
    { _allowedToClasses set [_forEachIndex, configName _x]; } forEach _allowedToClasses;
}
else
{
    _allowedFromClasses =
    [
        "Land_Laptop_03_sand_F_AE3",
        "Land_Laptop_03_black_F_AE3",
        "Land_Laptop_03_olive_F_AE3",
        "Land_PortableServer_01_black_F_AE3",
        "Land_PortableServer_01_olive_F_AE3",
        "Land_PortableServer_01_sand_F_AE3",
        "Land_Router_01_sand_F_AE3",
        "Land_Router_01_black_F_AE3",
        "Land_Router_01_olive_F_AE3"
    ];

    _allowedToClasses =
    [
        "Land_Router_01_sand_F_AE3",
        "Land_Router_01_black_F_AE3",
        "Land_Router_01_olive_F_AE3"
    ];
};

if !([_type, _from, _to, _allowedFromClasses, _allowedToClasses] call FUNC(zeus_isConnectionAllowed)) exitWith
{
    // Endpoints failed validation - detach them from the module so it can be reconfigured.
    _module synchronizeObjectsRemove [_from, _to];
    false
};

if (_type isEqualTo "AE3_PowerConnection") then
{
    [_from, _to] call AE3_power_fnc_createPowerConnection;
    [localize "STR_AE3_Main_Zeus_PowerConnectionAdded", _message, 5] call BIS_fnc_curatorHint;
}
else
{
    [_from, _to] call AE3_network_fnc_createNetworkConnection;
    [localize "STR_AE3_Main_Zeus_NetworkConnectionAdded", _message, 5] call BIS_fnc_curatorHint;
};

deleteVehicle _module;
true
