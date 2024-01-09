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

    /* ======================================== */

    private _headlineCtrl = _display displayCtrl 1000;

	//private _config = configFile >> "CfgVehicles" >> (typeOf _entity);
    //private _displayName = getText (_config >> "displayName");
    private _displayName = [_entity, true] call ace_cargo_fnc_getNameItem;
	_headlineCtrl ctrlSetText format [localize "STR_AE3_Main_Zeus_ObjectHeader", _displayName];

    waitUntil { !isNil { _entity getVariable "AE3_power_isDevice" }; };
    private _isPowerDevice = _entity getVariable ["AE3_power_isDevice", false];

    // This could be the case for the desk
    if (!_isPowerDevice) exitWith {};

    // wait for asset init to finish
    waitUntil { !isNil { _entity getVariable "AE3_power_initDone" }; };

    /* ======================================== */

    private _statusUpdateHandle = [_display, _entity] spawn
    {
        params ["_display", "_entity"];

        while { true; } do
        {
            private _statusCtrl = _display displayCtrl 1400;
            private _status = [];

            _status pushBack localize "STR_AE3_Main_Zeus_ObjectStatus";
            _status pushBack "------------";

            // Class Name
            private _className = typeOf _entity;
            _status pushBack (format [localize "STR_AE3_Main_Zeus_ClassName", _className]);

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

    private _fileExplorerCtrl = _display displayCtrl 1500;
    private _fileContentCtrl = _display displayCtrl 1501;

    private _fsEntity = _entity;

    /* ======================================== */

    // if asset has battery, init battery level controls
    if (!isNil { _battery getVariable "AE3_power_batteryCapacity" }) then
    {
        // enable controls
        _batteryLevelSliderCtrl ctrlEnable true;
        _batteryLevelCtrl ctrlEnable true;

        private _result = [_battery] call AE3_power_fnc_getBatteryLevel;
        _result params ["_batteryLevel", "_batteryLevelPercent", "_batteryCapacity"];
        
        _batteryLevelPercent = round _batteryLevelPercent;

        _batteryLevelSliderCtrl sliderSetPosition _batteryLevelPercent;
        _batteryLevelCtrl ctrlSetText format ['%1%2', _batteryLevelPercent, '%'];
    };

    /* ======================================== */

    // if asset has fuel, init fuel level controls
    if (!isNil { _generator getVariable "AE3_power_fuelCapacity" }) then
    {
        // enable controls
        _fuelLevelSliderCtrl ctrlEnable true;
        _fuelLevelCtrl ctrlEnable true;

        private _result = [_generator] call AE3_power_fnc_getFuelLevel;
        _result params ["_fuelLevel", "_fuelLevelPercent", "_fuelCapacity"];

        _fuelLevelPercent = round _fuelLevelPercent;

        _fuelLevelSliderCtrl sliderSetPosition _fuelLevelPercent;
        _fuelLevelCtrl ctrlSetText format ['%1%2', _fuelLevelPercent, '%'];
    };

    /* ======================================== */

    // if asset has filesystem, init filesystem tree view
    if (!isNil {_fsEntity getVariable "AE3_filesystem"}) then
    {
        private _pointer = [];
        private _filesystem = _fsEntity getVariable ["AE3_filesystem", []];

        private _current = [_pointer, _filesystem] call AE3_filesystem_fnc_resolvePntr;

        private _treePath = []; // path for the RscTree item controls

        private _fnc_tree_recursive =
        {
            params ["_pointer", "_filesystem", "_treePath", "_pointerLUT", ["_itemId", 0]];

            private _content = _filesystem select 0; // HASHMAP

            {
                // Hashmap forEach variables: KEY = _x && VALUE = _y

                private _treePathIndex = _fileExplorerCtrl tvAdd [_treePath, _x];

                private _newTreePath = +_treePath;
                _newTreePath append [_treePathIndex];

                _pointerLUT set [_itemId, [_pointer, _x]];
                _fileExplorerCtrl tvSetValue [_newTreePath, _itemId];
                _itemId = _itemId + 1;

                private _contentType = typeName (_y select 0);

                switch _contentType do
                {
                    case "HASHMAP":
                        {
                            private _currentPointer = +_pointer;
                            _currentPointer pushBack _x;

                            _fileExplorerCtrl tvSetData [_newTreePath, ""];

                            _itemId = [_currentPointer, _y, _newTreePath, _pointerLUT, _itemId] call _fnc_tree_recursive;
                        };
                    case "CODE":
                        {
                            _fileExplorerCtrl tvSetData [_newTreePath, ""];
                        };
                    case "STRING":
                        {
                            _fileExplorerCtrl tvSetData [_newTreePath, _y select 0];
                        };
                    default
                        {
                            _fileExplorerCtrl tvSetData [_newTreePath, format ["%1", (_y select 0)]];
                        };
                };
            } forEach _content;

            _itemId;
        };

        private _pointerLUT = createHashMap;

        [_pointer, _current, _treePath, _pointerLUT] call _fnc_tree_recursive;

        _fileExplorerCtrl setVariable ["pointerLUT", _pointerLUT];

        _fileExplorerCtrl tvSortAll [[], false];
    };

    /* ======================================== */
};