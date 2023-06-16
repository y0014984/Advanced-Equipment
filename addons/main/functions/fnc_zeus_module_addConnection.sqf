/**
 * PRIVATE
 *
 * This function is assigned to the 'onLoad' and 'onUnload' Events of the Zeus Module Interface: addConnection
 * This function runs local on the computer of the curator/zeus because it is UI triggered.
 * The function makes changes to the asset according the the user input.
 * This module needs to be placed individually and needs two synced objects.
 * After processing the module will be deleted.
 *
 * Arguments:
 * 1: Display <OBJECT>
 * 2: Exit Code <NUMBER>
 * 3: Event <STRING>
 *
 * Results:
 * Visual Feedback in Zeus
 *
 */

params ["_display", "_exitCode", "_event"];

// der folgende Code funktioniert irgendwie nicht
private _module = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _module) exitWith {};

/* ---------------------------------------- */

if (_event isEqualTo "onLoad") then
{
    private _syncedObjects = synchronizedObjects _module;

    // remove connection to itself
    _module synchronizeObjectsRemove [_module];

    // remove all unnecessary connections
    if ((count _syncedObjects) > 2) then
    {
        private _connectionsToDelete = _syncedObjects deleteRange [2, (count _syncedObjects) - 1];
        _module synchronizeObjectsRemove _connectionsToDelete;
    };

    // set ok button state
    private _okCtrl = _display getVariable ["okCtrl", objNull];
    if ((count _syncedObjects) > 1) then
    {
        _okCtrl ctrlEnable true;
    }
    else
    {
        _okCtrl ctrlEnable false;
    };

    // fill 'From' field
    if ((count _syncedObjects) > 0) then
    {
        private _from = _syncedObjects select 0;
        private _fromNameWithAceCargoName = [_from, true] call ace_cargo_fnc_getNameItem;
        private _fromCtrl = _display displayCtrl 1401;
        _fromCtrl ctrlSetText _fromNameWithAceCargoName;
        _display setVariable ["entity1", _from];
    };

    // fill 'To' field
    if ((count _syncedObjects) > 1) then
    {
        private _to = _syncedObjects select 1;
        private _toNameWithAceCargoName = [_to, true] call ace_cargo_fnc_getNameItem;
        private _toCtrl = _display displayCtrl 1402;
        _toCtrl ctrlSetText _toNameWithAceCargoName;
        _display setVariable ["entity2", _to];
    };
};

/* ---------------------------------------- */

if (_event isEqualTo "onUnload") then
{
    // 2 = canceled dialog
    if (_exitCode == 2) exitWith {};

    // get Settings from UI
    private _typeCtrl = _display displayCtrl 1501;
    private _type = lbCurSel _typeCtrl; // 0 = Power Connection; 1 = Network Connection
    if (_type == 0) then { _type = "AE3_PowerConnection"; } else { _type = "AE3_NetworkConnection"; };

    // get Data from Display namespace
    private _from = _display getVariable ["entity1", objNull];
    private _to = _display getVariable ["entity2", objNull];
    private _switch = _display getVariable ['switch', false];

    // check for empty but mandatory input fields
    // module is still there an could be opened and filled in with valid input
    // but currently, this case will be catched by UI logic, defined directly in config
    if(isNull _from) exitWith { [objNull, localize "STR_AE3_Main_Zeus_FromMissing"] call BIS_fnc_showCuratorFeedbackMessage; };
    if(isNull _to) exitWith { [objNull, localize "STR_AE3_Main_Zeus_ToMissing"] call BIS_fnc_showCuratorFeedbackMessage; };

    if (_switch) then
    {
        private _tmpFrom = _from;
        private _tmpTo = _to;
        _from = _tmpTo;
        _to = _tmpFrom;
    };

    private _fromNameWithAceCargoName = [_from, true] call ace_cargo_fnc_getNameItem;
    private _toNameWithAceCargoName = [_to, true] call ace_cargo_fnc_getNameItem;

    private _message = format ["'%1': %2 '%3': %4", localize "STR_AE3_Main_Zeus_From", _fromNameWithAceCargoName, localize "STR_AE3_Main_Zeus_To", _toNameWithAceCargoName];

    // add connection: type == 0 is power connection and type == 1 is network connection
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

        if ([_type, _from, _to, _allowedPowerFromClasses, _allowedPowerToClasses] call AE3_main_fnc_zeus_isConnectionAllowed) then
        {
            [_from, _to] call AE3_power_fnc_createPowerConnection;
            [localize "STR_AE3_Main_Zeus_PowerConnectionAdded", _message, 5] call BIS_fnc_curatorHint;

            // delete module if dialog cancelled or computer not linked to module
            deleteVehicle _module;
        }
        else
        {
            // remove connections
            _module synchronizeObjectsRemove [_from, _to];
        };
    };

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

        if ([_type, _from, _to, _allowedNetworkFromClasses, _allowedNetworkToClasses] call AE3_main_fnc_zeus_isConnectionAllowed) then
        {
            [_from, _to] call AE3_network_fnc_createNetworkConnection;
            [localize "STR_AE3_Main_Zeus_NetworkConnectionAdded", _message, 5] call BIS_fnc_curatorHint;

            // delete module if dialog cancelled or computer not linked to module
            deleteVehicle _module;
        }
        else
        {
            // remove connections
            _module synchronizeObjectsRemove [_from, _to];
        };
    };
};

/* ---------------------------------------- */