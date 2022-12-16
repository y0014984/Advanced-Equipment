params ["_type", "_entity0", "_entity1"];

// _entity0 = from object
// _entity1 = to object

//diag_log [_type, _entity0, _entity1];

[_entity0, _entity1] spawn 
{
    params ["_entity0", "_entity1"];
    waitUntil { !isNil "BIS_fnc_init" };
    //hint "network connection";
    
    // wait until both devices have relevant variables set; this indicates that the init process is done
    waitUntil { !(isNil { _entity0 getVariable "AE3_network_address"; }) && !(isNil { _entity1 getVariable "AE3_network_children"; }) };

    if (isNil { _entity0 getVariable "AE3_network_children"; }) then
    {
        [_entity0, _entity1] call AE3_network_fnc_connect_device2router;
    }
    else
    {
        [_entity0, _entity1] call AE3_network_fnc_connect_router2router;
    };
};