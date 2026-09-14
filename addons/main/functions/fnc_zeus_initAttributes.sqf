// File: fnc_zeus_initAttributes.sqf
/*
 * Author: Root, y0014984
 * Description: Initializes the Zeus Asset Attributes interface on load. Runs locally on the Zeus curator's machine.
 * Gathers and displays information about the selected AE3 asset including power status, power output, power requirements, IP address, fuel level, and battery level.
 * Continuously updates the display with live asset information.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The Zeus asset attributes display
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call AE3_main_fnc_zeus_initAttributes;
 *
 * Public: No
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

    /* ======================================== */

    private _headlineCtrl = _display displayCtrl 1000;

	//private _config = configFile >> "CfgVehicles" >> (typeOf _entity);
    //private _displayName = getText (_config >> "displayName");
    private _displayName = [_entity, true] call ace_cargo_fnc_getNameItem;
	_headlineCtrl ctrlSetText format [localize "STR_AE3_Main_Zeus_ObjectHeader", _displayName];

    // Derive device status directly from config (compileDevice no longer broadcasts this per object).
    private _isPowerDevice = isClass (configOf _entity >> "AE3_Device");

    // This could be the case for the desk
    if (!_isPowerDevice) exitWith {};

    // Wait for asset init to finish. The flag is set on the server and replicated, so on a dedicated
    // server it can still be in flight when the curator opens the dialog. The wait is bounded so a
    // flag that never arrives leaves a usable panel instead of a dead one.
    private _initDeadline = diag_tickTime + 5;
    waitUntil { !isNil { _entity getVariable "AE3_power_initDone" } || {diag_tickTime > _initDeadline} };

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
            _prefix = "k"; // kWatts
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

            // Connections overview (power + network, incoming and outgoing)
            _status pushBack "------------";

            private _powerProvider = _entity getVariable ["AE3_power_powerCableDevice", objNull];
            if (!isNull _powerProvider) then
            {
                _status pushBack (format ["Power source: %1", [_powerProvider, true] call ace_cargo_fnc_getNameItem]);
            };

            private _connectedPowerDevices = _entity getVariable ["AE3_power_connectedDevices", []];
            if (_connectedPowerDevices isNotEqualTo []) then
            {
                _status pushBack (format ["Powered devices: %1", count _connectedPowerDevices]);
                {
                    _status pushBack (format ["  - %1", [_x, true] call ace_cargo_fnc_getNameItem]);
                } forEach _connectedPowerDevices;
            };

            private _networkParent = _entity getVariable ["AE3_network_parent", objNull];
            if (!isNull _networkParent) then
            {
                _status pushBack (format ["Network gateway: %1 (%2)", [_networkParent, true] call ace_cargo_fnc_getNameItem, [_networkParent getVariable ["AE3_network_address", [127,0,0,1]]] call AE3_network_fnc_ip2str]);
            };

            private _networkChildren = _entity getVariable ["AE3_network_children", []];
            if (_networkChildren isNotEqualTo []) then
            {
                _status pushBack (format ["Network clients: %1", count _networkChildren]);
                {
                    _status pushBack (format ["  - %1 (%2)", [_x, true] call ace_cargo_fnc_getNameItem, [_x getVariable ["AE3_network_address", [127,0,0,1]]] call AE3_network_fnc_ip2str]);
                } forEach _networkChildren;
            };

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

    // Every power device gets the on/off toggle, mirroring the state the ACE interaction on the object
    // would show. A device the curator has just placed reports state 0 until it finishes initializing.
    private _powerStateLabelCtrl = _display displayCtrl 1014;
    private _powerStateCheckCtrl = _display displayCtrl 1322;
    { _x ctrlShow true } forEach [_powerStateLabelCtrl, _powerStateCheckCtrl];
    _powerStateCheckCtrl ctrlEnable true;
    _powerStateCheckCtrl cbSetChecked ((_entity getVariable ["AE3_power_powerState", 0]) isEqualTo 1);

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

    // Router wireless fields stay hidden for other asset types.
    if (_entity getVariable ["AE3_cap_isRouter", false]) then
    {
        private _rangeLabelCtrl = _display displayCtrl 1003;
        private _rangeEditCtrl = _display displayCtrl 1910;
        private _gatewayLabelCtrl = _display displayCtrl 1004;
        private _gatewayEditCtrl = _display displayCtrl 1911;
        private _ssidLabelCtrl = _display displayCtrl 1005;
        private _ssidEditCtrl = _display displayCtrl 1912;
        private _passwordLabelCtrl = _display displayCtrl 1010;
        private _passwordEditCtrl = _display displayCtrl 1915;
        private _extSshLabelCtrl = _display displayCtrl 1012;
        private _extSshCheckCtrl = _display displayCtrl 1321;
        private _extAllowLabelCtrl = _display displayCtrl 1013;
        private _extAllowEditCtrl = _display displayCtrl 1917;

        { _x ctrlShow true } forEach [_rangeLabelCtrl, _rangeEditCtrl, _gatewayLabelCtrl, _gatewayEditCtrl, _ssidLabelCtrl, _ssidEditCtrl, _passwordLabelCtrl, _passwordEditCtrl, _extSshLabelCtrl, _extSshCheckCtrl, _extAllowLabelCtrl, _extAllowEditCtrl];
        _rangeEditCtrl ctrlEnable true;
        _gatewayEditCtrl ctrlEnable true;
        _ssidEditCtrl ctrlEnable true;
        _passwordEditCtrl ctrlEnable true;
        _extSshCheckCtrl ctrlEnable true;
        _extAllowEditCtrl ctrlEnable true;

        _rangeEditCtrl ctrlSetText str (_entity getVariable ["AE3_network_wirelessRange", 100]);
        _gatewayEditCtrl ctrlSetText ([_entity getVariable ["AE3_network_address", [192, 168, 0, 1]]] call AE3_network_fnc_ip2str);
        _ssidEditCtrl ctrlSetText (_entity getVariable ["ace_cargo_customName", ""]);
        _passwordEditCtrl ctrlSetText (_entity getVariable ["AE3_network_password", ""]);
        _extSshCheckCtrl cbSetChecked (_entity getVariable ["AE3_network_allowExternalSsh", false]);
        _extAllowEditCtrl ctrlSetText (_entity getVariable ["AE3_network_externalAllow", ""]);
    };

    /* ======================================== */

    // Terminal attributes are shown only for assets with a terminal.
    if (_entity getVariable ["AE3_cap_hasTerminal", false]) then
    {
        private _hostLabelCtrl = _display displayCtrl 1006;
        private _hostEditCtrl = _display displayCtrl 1913;
        private _sshLabelCtrl = _display displayCtrl 1007;
        private _sshCheckCtrl = _display displayCtrl 1320;
        private _ipLabelCtrl = _display displayCtrl 1011;
        private _ipEditCtrl = _display displayCtrl 1916;
        private _rtLabelCtrl = _display displayCtrl 1008;
        private _rtComboCtrl = _display displayCtrl 1600;
        private _pwLabelCtrl = _display displayCtrl 1009;
        private _pwEditCtrl = _display displayCtrl 1914;
        private _connectBtnCtrl = _display displayCtrl 2900;
        private _disconnectBtnCtrl = _display displayCtrl 2910;

        { _x ctrlShow true } forEach [_hostLabelCtrl, _hostEditCtrl, _sshLabelCtrl, _sshCheckCtrl, _ipLabelCtrl, _ipEditCtrl, _rtLabelCtrl, _rtComboCtrl, _pwLabelCtrl, _pwEditCtrl, _connectBtnCtrl, _disconnectBtnCtrl];
        _hostEditCtrl ctrlEnable true;
        _sshCheckCtrl ctrlEnable true;
        _ipEditCtrl ctrlEnable true;
        _rtComboCtrl ctrlEnable true;
        _pwEditCtrl ctrlEnable true;

        _hostEditCtrl ctrlSetText (_entity getVariable ["ace_cargo_customName", "armaOS"]);
        _sshCheckCtrl cbSetChecked (_entity getVariable ["AE3_ssh_enabled", true]);
        _ipEditCtrl ctrlSetText (_entity getVariable ["AE3_network_staticIp", ""]);

        // List routers in reach (within each router's wireless range); preselect the current parent.
        private _parent = _entity getVariable ["AE3_network_parent", objNull];
        lbClear _rtComboCtrl;
        // Nearby objects cover the common case; the mission-wide registry is merged in so a router
        // whose wireless range reaches further than the proximity scan is still offered.
        private _routers = (nearestObjects [_entity, [], 300]) select { _x getVariable ["AE3_cap_isRouter", false] };
        {
            if (!isNull _x && {alive _x} && {!(_x in _routers)}) then { _routers pushBack _x; };
        } forEach (missionNamespace getVariable ["AE3_network_routers", []]);
        {
            private _r = _x;
            private _range = _r getVariable ["AE3_network_wirelessRange", 100];
            if ((_entity distance _r) <= _range) then
            {
                private _objName = [_r, false] call ace_cargo_fnc_getNameItem;
                private _networkName = _r getVariable ["ace_cargo_customName", ""];
                private _ip = [_r getVariable ["AE3_network_address", [192, 168, 0, 1]]] call AE3_network_fnc_ip2str;
                // Lead with the network (SSID) name so routers read as "Test (12.12.44.212) [Rugged Router (Black)]".
                private _label = if (_networkName isEqualTo "") then { format ["%1 (%2)", _objName, _ip] } else { format ["%1 (%2) [%3]", _networkName, _ip, _objName] };
                private _i = _rtComboCtrl lbAdd _label;
                _rtComboCtrl lbSetData [_i, netId _r];
                if (_r isEqualTo _parent) then { _rtComboCtrl lbSetCurSel _i; };
            };
        } forEach _routers;
    };

    /* ======================================== */
};
