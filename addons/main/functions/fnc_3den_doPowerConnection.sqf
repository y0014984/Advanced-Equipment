params ["_type", "_entity0", "_entity1"];

// _entity0 = from object
// _entity1 = to object

//diag_log [_type, _entity0, _entity1];

[_entity0, _entity1] spawn
{
    params ["_entity0", "_entity1"];
    waitUntil { !isNil "BIS_fnc_init" };
    //hint "power connection";

    // wait until both devices have relevant variables set; this indicates that the init process is done
    waitUntil { !(isNil { _entity0 getVariable "AE3_power_hasInternal"; }) && !(isNil { _entity1 getVariable "AE3_power_connectedDevices"; }) };

    private _hasInternal = _entity0 getVariable "AE3_power_hasInternal";

    private _device = objNull;

    if (_hasInternal) then { _device = _entity0 getVariable "AE3_power_internal"; } else { _device = _entity0; };

    [_device, _entity1] call AE3_power_fnc_connectToGeneratorAction;
};