// File: fnc_zeus_updateAttributes.sqf
/*
 * Author: Root, y0014984
 * Description: Handles the Zeus Asset Attributes interface on unload. Runs locally on the Zeus curator's machine.
 * Updates battery level and/or fuel level for the selected device based on slider values set by the curator.
 * Terminates the status update loop and provides feedback on changes made.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The Zeus asset attributes display
 * 1: _exitCode <NUMBER> - Exit code (1 = OK, 2 = Cancel)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display, 1] call AE3_main_fnc_zeus_updateAttributes;
 *
 * Public: No
 */

params ["_display", "_exitCode"];
// _exitCode: ok = 1, cancel = 2

/* ======================================== */

private _statusUpdateHandle = _display getVariable ["AE3_statusUpdateHandle", scriptNull];
if (!isNull _statusUpdateHandle) then { terminate _statusUpdateHandle; };

if (_exitCode == 1) then
{
    /* ======================================== */

    private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
    if (isNull _entity) exitWith {};

    private _battery = _entity;
    private _hasInternal = _entity getVariable "AE3_power_hasInternal";
    if (_hasInternal) then { _battery = _entity getVariable "AE3_power_internal"; };

    private _generator = _entity;

    /* ======================================== */

    private _message = "";

    /* ======================================== */

    // Power devices carry an on/off toggle. It is applied only when it differs from the live state, so
    // confirming the panel again does not restart a generator that is already running, and the switch
    // itself runs on the server because the power state and its mutex are shared across the mission.
    if (isClass (configOf _entity >> "AE3_Device")) then
    {
        private _requestedOn = cbChecked (_display displayCtrl 1322);
        private _currentlyOn = (_entity getVariable ["AE3_power_powerState", 0]) isEqualTo 1;

        if (_requestedOn isNotEqualTo _currentlyOn) then
        {
            private _powerFunction = ["AE3_power_fnc_turnOffDevice", "AE3_power_fnc_turnOnDevice"] select _requestedOn;
            [_entity] remoteExecCall [_powerFunction, 2];

            _message = _message + format [
                localize "STR_AE3_Main_Zeus_NewPowerState",
                localize (["STR_AE3_Power_Interaction_TurnOff", "STR_AE3_Power_Interaction_TurnOn"] select _requestedOn)
            ];
        };
    };

    /* ======================================== */

    // if asset has battery, update battery level
    if (!isNil { _battery getVariable "AE3_power_batteryCapacity" }) then
    {
        private _batteryLevelCtrl = _display displayCtrl 1900;
        private _batteryLevelPercent = sliderPosition _batteryLevelCtrl;

        _message = _message + format [localize "STR_AE3_Main_Zeus_NewBatteryLevel", _batteryLevelPercent, "%"];

        [_battery, _batteryLevelPercent] remoteExecCall ["AE3_power_fnc_setBatteryLevel", 2];
    };

    /* ======================================== */

    // if asset has fuel, update fuel level
    if (!isNil { _generator getVariable "AE3_power_fuelCapacity" }) then
    {
        private _fuelLevelCtrl = _display displayCtrl 1901;
        private _fuelLevelPercent = sliderPosition _fuelLevelCtrl;

        _message = _message + format [localize "STR_AE3_Main_Zeus_NewFuelLevel", _fuelLevelPercent, "%"];

        [_generator, _fuelLevelPercent] call AE3_power_fnc_setFuelLevel;
    };

    /* ======================================== */

    // Router wireless settings are applied through the shared router configuration handler.
    if (_entity getVariable ["AE3_cap_isRouter", false]) then
    {
        private _range = parseNumber (ctrlText (_display displayCtrl 1910));
        private _gateway = ctrlText (_display displayCtrl 1911);
        private _ssid = ctrlText (_display displayCtrl 1912);
        private _password = ctrlText (_display displayCtrl 1915);
        private _extSsh = cbChecked (_display displayCtrl 1321);
        private _extAllow = ctrlText (_display displayCtrl 1917);
        [_entity, _ssid, _range, _password, _gateway, _extSsh, _extAllow] remoteExecCall ["AE3_network_fnc_applyRouterConfig", 2];
        _message = _message + format ["Network name: %1. Wifi range: %2m. Gateway: %3. External SSH: %4.", _ssid, _range, _gateway, ["disabled", "enabled"] select _extSsh];
    };

    /* ======================================== */

    // Terminal-only attributes: hostname, SSH access, static IP. Broadcast from the server.
    if (_entity getVariable ["AE3_cap_hasTerminal", false]) then
    {
        private _hostname = ctrlText (_display displayCtrl 1913);
        private _sshEnabled = cbChecked (_display displayCtrl 1320);
        private _staticIp = ctrlText (_display displayCtrl 1916);
        // Named functions rather than a remote-executed raw setVariable: raw commands need their own
        // exclusions to pass the remote execution filters used on dedicated servers, so routing them
        // through addon functions is what makes these writes land there.
        if (_hostname isNotEqualTo "") then
        {
            [_entity, _hostname] remoteExecCall ["AE3_armaos_fnc_computer_setHostname", 2];
        };
        [_entity, _sshEnabled] remoteExecCall ["AE3_network_fnc_setSshEnabled", 2];
        // Address validation happens on the server, which reports the real verdict back to this curator.
        [_entity, _staticIp, clientOwner] remoteExecCall ["AE3_network_fnc_setStaticIpZeus", 2];
        // The address line only records what was requested; the server sends the accepted/rejected
        // verdict as its own hint once it has validated the address.
        _message = _message + format ["Hostname: %1. SSH: %2. IP requested: %3.", _hostname, ["disabled", "enabled"] select _sshEnabled, [_staticIp, "DHCP"] select (_staticIp isEqualTo "")];
    };

    /* ======================================== */

    ["AE3 Asset Attributes changed", _message, 5] call BIS_fnc_curatorHint;

    /* ======================================== */

    // Nudge any open desktop on the affected laptop to re-read its status so curator changes to
    // hostname, SSH access, battery, wireless settings or IP show without closing and reopening it.
    ["ae3_desktop_sysChanged", []] call CBA_fnc_globalEvent;
};
