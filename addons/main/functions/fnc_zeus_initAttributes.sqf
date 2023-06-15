/**
 * PRIVATE
 *
 * This function is assigned to the 'onLoad' Event of the default AE3 Asset Attributes Zeus Interface, called AE3_UserInterface_Zeus_Asset_Details
 * This function runs local on the computer of the curator/zeus because it is UI triggered.
 * This function will gather information about the current placed/opened asset in Zeus if it's an AE3 asset.
 * The provided Information contains Power Status, Power Output, Power Req, IP Address, Fuel Level and Bettery Level
 *
 * Arguments:
 * None
 *
 * Results:
 * Visual Feedback in Zeus UI Window
 *
 */

params ["_display"];

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

// The interface is shown up too fast; waitUntil the variables are valid
// The interface is faster then our init process for object variables
// on my test system it takes 3 waitUntil cycles for the variables to be available

[_display, _entity] spawn
{
    params ["_display", "_entity"];

    private _counter = 0;

    // weit for asset init to finish
    waitUntil { !isNil { _entity getVariable "AE3_power_hasInternal" }; };

    /* ======================================== */

    private _headlineCtrl = _display displayCtrl 1000;
	private _class = (typeOf _entity);
	private _config = configFile >> "CfgVehicles" >> _class;
	private _displayName = getText (_config >> "displayName");
	_headlineCtrl ctrlSetText format [localize "STR_AE3_Main_Zeus_ObjectHeader", _displayName, _class];

    /* ======================================== */

    private _statusUpdateHandle = [_display, _entity] spawn
    {
        params ["_display", "_entity"];

        while { true; } do
        {
            private _statusCtrl = _display displayCtrl 1400;
            private _status = [];

            _status pushBack localize "$STR_AE3_Main_Zeus_ObjectStatus";
            _status pushBack "------------";

            // Power State
            private _powerState = [_entity] call AE3_power_fnc_getPowerState;
            _status pushBack (format [localize "STR_AE3_Power_Interaction_PowerStateHint", _powerState]);

            // Power Output
            private _powerOutput = [_entity] call AE3_power_fnc_getPowerOutput;
            private _powerCap = _entity getVariable ['AE3_power_powerCapacity', 0];
            private _prefix = "k"; // kWatts
            _powerCap = _powerCap * 3600;
            if (_powerCap < 1.0) then
            {
                _powerCap = _powerCap * 1000;
                _prefix = "";
            };
            _status pushBack (format [localize "STR_AE3_Power_Interaction_PowerOutputHint", _powerCap, _prefix]);

            // Power Required
            private _powerReq = _entity getVariable ["AE3_power_powerReq", 0];
            private _prefix = "k"; // kWatts
            _powerReq = _powerReq * 3600;
            if (_powerReq < 1.0) then
            {
                _powerReq = _powerReq * 1000;
                _prefix = "";
            };
            _status pushBack (format [localize "STR_AE3_Power_Interaction_PowerReqHint", _powerReq, _prefix]);

            // IP Address
            private _ip = _entity getVariable ["AE3_network_address", []];
            private _ipString = [_ip] call AE3_network_fnc_ip2str;
            _status pushBack (format ["%1: %2", localize "STR_AE3_Network_General_IpAddress", _ipString]);

            private _statusString = _status joinString endl;
            _statusCtrl ctrlSetText _statusString;

            sleep 1;
        };
    };

    _display setVariable ["AE3_statusUpdateHandle", _statusUpdateHandle];

    /* ======================================== */

    private _batteryLevelSliderCtrl = _display displayCtrl 1900;
    private _batteryLevelCtrl = _display displayCtrl 1401;
    private _fuelLevelSliderCtrl = _display displayCtrl 1901;
    private _fuelLevelCtrl = _display displayCtrl 1402;

    private _battery = _entity;
    private _hasInternal = _entity getVariable "AE3_power_hasInternal";
    if (_hasInternal) then { _battery = _entity getVariable "AE3_power_internal"; };

    private _generator = _entity;

    /* ======================================== */

    // if asset has battery, init battery level controls
    if (!isNil { _battery getVariable "AE3_power_batteryCapacity" }) then
    {
        private _result = [_battery] call AE3_power_fnc_getBatteryLevel;
        _result params ["_batteryLevel", "_batteryLevelPercent", "_batteryCapacity"];
        
        _batteryLevelPercent = round _batteryLevelPercent;

        _batteryLevelSliderCtrl sliderSetPosition _batteryLevelPercent;
        _batteryLevelCtrl ctrlSetText format ['%1%2', _batteryLevelPercent, '%'];
    }
    else
    {
        // disable controls
        _batteryLevelSliderCtrl ctrlEnable false;
        _batteryLevelCtrl ctrlEnable false;
    };

    /* ======================================== */

    // if asset has fuel, init fuel level controls
    if (!isNil { _generator getVariable "AE3_power_fuelCapacity" }) then
    {
        private _result = [_generator] call AE3_power_fnc_getFuelLevel;
        _result params ["_fuelLevel", "_fuelLevelPercent", "_fuelCapacity"];

        _fuelLevelPercent = round _fuelLevelPercent;

        _fuelLevelSliderCtrl sliderSetPosition _fuelLevelPercent;
        _fuelLevelCtrl ctrlSetText format ['%1%2', _fuelLevelPercent, '%'];
    }
    else
    {
        // disable controls
        _fuelLevelSliderCtrl ctrlEnable false;
        _fuelLevelCtrl ctrlEnable false;
    };

    /* ======================================== */
};