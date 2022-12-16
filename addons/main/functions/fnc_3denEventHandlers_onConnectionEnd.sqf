// _type <STRING> = Connection Name/Type; same as data property
// _from <[[OBJECT]]> = Array of 3den Objects starting the connection; You can multiselect and connect all at once
// _to <OBJECT> = 3den Object the connection goes to
// Array of Eden entities
// [objects, groups, triggers, systems, waypoints, markers, layers, comments]
// https://community.bistudio.com/wiki/Array_of_Eden_Entities

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
    private _allowedPowerFromClasses =
    [
        "Land_BatteryPack_01_open_sand_F_AE3",
        "Land_BatteryPack_01_open_black_F_AE3",
        "Land_BatteryPack_01_open_olive_F_AE3",
        "Land_Laptop_03_sand_F_AE3",
        "Land_Laptop_03_black_F_AE3",
        "Land_Laptop_03_olive_F_AE3",
        "Land_Router_01_sand_F_AE3",
        "Land_Router_01_black_F_AE3",
        "Land_Router_01_olive_F_AE3",
        "Land_PortableLight_double_F_AE3",
        "Land_PortableLight_single_F_AE3",
        "Land_PortableLight_02_double_sand_F_AE3",
        "Land_PortableLight_02_double_black_F_AE3",
        "Land_PortableLight_02_double_olive_F_AE3",
        "Land_PortableLight_02_double_yellow_F_AE3",
        "Land_PortableLight_02_quad_sand_F_AE3",
        "Land_PortableLight_02_quad_black_F_AE3",
        "Land_PortableLight_02_quad_olive_F_AE3",
        "Land_PortableLight_02_quad_yellow_F_AE3",
        "Land_PortableLight_02_single_sand_F_AE3",
        "Land_PortableLight_02_single_black_F_AE3",
        "Land_PortableLight_02_single_olive_F_AE3",
        "Land_PortableLight_02_single_yellow_F_AE3"
    ];

    private _allowedPowerToClasses =
    [
        "Land_PortableGenerator_01_sand_F_AE3_Dummy",
        "Land_PortableGenerator_01_black_F_AE3_Dummy",
        "Land_PortableGenerator_01_F_AE3_Dummy",
        "Land_PortableGenerator_01_sand_F_AE3",
        "Land_PortableGenerator_01_black_F_AE3",
        "Land_PortableGenerator_01_F_AE3",
        "Land_BatteryPack_01_open_sand_F_AE3",
        "Land_BatteryPack_01_open_black_F_AE3",
        "Land_BatteryPack_01_open_olive_F_AE3",
        "Land_SolarPanel_04_sand_F_AE3",
        "Land_SolarPanel_04_black_F_AE3",
        "Land_SolarPanel_04_olive_F_AE3",
        "Land_PortableSolarPanel_01_sand_F_AE3",
        "Land_PortableSolarPanel_01_olive_F_AE3"
    ];

    private _fromObjects = _from select 0;
    {
        ["AE3_PowerConnection", _x, _to, _allowedPowerFromClasses, _allowedPowerToClasses] call AE3_main_fnc_3den_checkConnection;
    } forEach _fromObjects;
};

/* ================================================================================ */
