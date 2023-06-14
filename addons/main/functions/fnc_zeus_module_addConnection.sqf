params ["_display", "_exitCode", "_event"];

// der folgende Code funktioniert irgendwie nicht
private _module = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _module) exitWith {};

/* ---------------------------------------- */

if (_event isEqualTo "onLoad") then
{
    private _syncedObjects = synchronizedObjects _module;

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
    private _type = lbCurSel _typeCtrl;

    // get Data from Display namespace
    private _from = _display getVariable ["entity1", objNull];
    private _to = _display getVariable ["entity2", objNull];
    private _switch = _display getVariable ['switch', false];

    // check for empty but mandatory input fields
    // module is still there an could be opened and filled in with valid input
    // but currently, this case will be catched by UI logic, defined directly in config
    if(isNull _from) exitWith { [objNull, "From missing"] call BIS_fnc_showCuratorFeedbackMessage; };
    if(isNull _to) exitWith { [objNull, "To missing"] call BIS_fnc_showCuratorFeedbackMessage; };

    if (_switch) then
    {
        private _tmpFrom = _from;
        private _tmpTo = _to;
        _from = _tmpTo;
        _to = _tmpFrom;
    };

    private _fromNameWithAceCargoName = [_from, true] call ace_cargo_fnc_getNameItem;
    private _toNameWithAceCargoName = [_to, true] call ace_cargo_fnc_getNameItem;

    private _message = format ["from: %1 to: %2", _fromNameWithAceCargoName, _toNameWithAceCargoName];

    // add connection
    if (_type == 0) then
    {
        [_type, _from, _to] call AE3_main_fnc_3den_doPowerConnection;
        ["AE3 Power Connection added", _message, 5] call BIS_fnc_curatorHint;
    };
    if (_type == 1) then
    {
        [_type, _from, _to] call AE3_main_fnc_3den_doNetworkConnection;
        ["AE3 Network Connection added", _message, 5] call BIS_fnc_curatorHint;
    };

    // delete module if dialog cancelled or computer not linked to module
    deleteVehicle _module;
};

/* ---------------------------------------- */