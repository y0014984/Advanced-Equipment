/*
 * Author: Root
 * Description: Handles connection end events in Eden Editor. Validates and processes network and power connections between devices.
 * This function is triggered when a connection is created in 3DEN editor. It validates the connection type and connected objects,
 * then delegates to appropriate validation functions based on connection type (network or power).
 *
 * Arguments:
 * 0: _type <STRING> - Connection type/name (AE3_PowerConnection or AE3_NetworkConnection)
 * 1: _from <ARRAY> - Array of Eden entities starting the connection (format: [objects, groups, triggers, systems, waypoints, markers, layers, comments])
 * 2: _to <OBJECT> - Eden object the connection goes to
 *
 * Return Value:
 * None
 *
 * Example:
 * ["AE3_NetworkConnection", [[laptop1, laptop2], [], [], [], [], [], [], []], router1] call AE3_main_fnc_3denEventHandlers_onConnectionEnd;
 *
 * Public: No
 */

params ["_type", "_from", "_to"];

//(format ["_type: %1 - _from: %2 - _to: %3", _type, _from, _to]) call BIS_fnc_3DENNotification;

private _allowedTypes = ["AE3_PowerConnection", "AE3_NetworkConnection"]; // These are the "data" values of the connections; in my case equal to class name

// _to is nil if connection got canceled
if ((isNil "_to") || !(_type in _allowedTypes)) exitWith {};

/* ================================================================================ */

// Event Handler currently not necessary
/* _to addEventHandler 
[
    "ConnectionChanged3DEN",
    {
	    params ["_object"];

        //(format ['_object: %1', _object]) call BIS_fnc_3DENNotification;
    }
]; */

/* ================================================================================ */

if (_type isEqualTo "AE3_NetworkConnection") then
{
    private _allowedNetworkFromClasses =
    [
        "Land_Laptop_03_sand_F_AE3",
        "Land_Laptop_03_black_F_AE3",
        "Land_Laptop_03_olive_F_AE3",
        "Land_Router_01_sand_F_AE3",
        "Land_Router_01_black_F_AE3",
        "Land_Router_01_olive_F_AE3"
    ];

    private _allowedNetworkToClasses =
    [
        "Land_Router_01_sand_F_AE3",
        "Land_Router_01_black_F_AE3",
        "Land_Router_01_olive_F_AE3"
    ];

    private _fromObjects = _from select 0;
    {
        ["AE3_NetworkConnection", _x, _to, _allowedNetworkFromClasses, _allowedNetworkToClasses] call AE3_main_fnc_3den_checkConnection;
    } forEach _fromObjects;
};

/* ================================================================================ */

if (_type isEqualTo "AE3_PowerConnection") then
{
    // get all classes defined in CfgVehicles
    private _config = configFile >> "CfgVehicles";

    // filter classes to those, that contain AE3_Device and AE3_Consumer or AE_Battery config
    private _powerConsumers =
    "
        isClass (_x >> 'AE3_Device' >> 'AE3_Consumer') ||
        isClass (_x >> 'AE3_Device' >> 'AE3_Battery')
    " configClasses _config;

    // convert configs to class names
    {
        _powerConsumers set [_forEachIndex, configName _x];
    } forEach _powerConsumers;

    // filter classes to those, that contain AE3_Device and AE3_Generator or AE3_SolarGenerator or AE3_Battery config
    private _powerProducers = 
    "
        isClass (_x >> 'AE3_Device' >> 'AE3_Generator') || 
        isClass (_x >> 'AE3_Device' >> 'AE3_SolarGenerator') ||
        isClass (_x >> 'AE3_Device' >> 'AE3_Battery')
        
    " configClasses _config;

    // convert configs to class names
    {
        _powerProducers set [_forEachIndex, configName _x];
    } forEach _powerProducers;

    // unnecessary assignment but easier to read
    private _allowedPowerFromClasses = _powerConsumers;
    private _allowedPowerToClasses = _powerProducers;

    // check connections; will be eliminated if not allowed
    private _fromObjects = _from select 0;
    {
        ["AE3_PowerConnection", _x, _to, _allowedPowerFromClasses, _allowedPowerToClasses] call AE3_main_fnc_3den_checkConnection;
    } forEach _fromObjects;
};

/* ================================================================================ */
