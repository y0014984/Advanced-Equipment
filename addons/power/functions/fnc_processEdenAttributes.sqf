params ["_entity"];

diag_log "AE3 Process Eden Attributes";

if (isServer) then
{

    diag_log "AE3 Process Eden Attributes is Server";

    [_entity] spawn 
    {
        params ["_entity"];

        diag_log "AE3 Process Eden Attributes is Server Spawn";

        // only works with a slightly delay; don't know why
        sleep 10;

        // set fuel level
        private _edenAttributeFuelLevel = _entity getVariable ["AE3_EdenAttribute_FuelLevel", -1]; // check Parent device or so, if Value not set
        if (_edenAttributeFuelLevel != -1) then
        {
            systemChat format ["Fuel Level: %1", _edenAttributeFuelLevel];
            _entity setFuel (_edenAttributeFuelLevel);
        };

        // set battery level
        private _edenAttributePowerLevel = _entity getVariable ["AE3_EdenAttribute_PowerLevel", -1];
        if (_edenAttributePowerLevel != -1) then
        {
            diag_log "AE3 Process Eden Attributes is Server Spawn Power Level -1";
            // see https://docs.google.com/drawings/d/13PQeaJVmAV7EfRuo6_YHFggM9fcFFuzJhywwbU_sPhc/edit
            // for the different battery cases
            private _battery = _entity;

            private _internalBattery = _entity getVariable ["AE3_power_internalBattery", false];
            if(_internalBattery) then
            {
                _battery = _entity getVariable "AE3_power_powerCableDevice";
            };

            private _internal = _entity getVariable ["AE3_power_internal", nil];
            if (!isNil "_internal") then
            {
                _battery = _entity getVariable "AE3_power_internal";
            };

            private _batteryLevel = 1;

            _batteryLevel = _edenAttributePowerLevel;
            private _batteryCapacity = _battery getVariable "AE3_power_batteryCapacity";
            _batteryLevel = _batteryCapacity * _batteryLevel;

            systemChat format ["Battery Level: %1", _edenAttributePowerLevel];
            _battery setVariable ["AE3_power_batteryLevel", _batteryLevel, true];
            diag_log "AE3 Battery Level Set in Process Eden Attributes";
        };
    };
};