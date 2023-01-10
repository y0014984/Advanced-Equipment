/**
 * Receives a status update and sets ACE3 dragging, carrying and cargo accordingly. Should be executed on server.
 *
 * Arguments:
 * 0: Equipment <OBJECT>
 * 1: Condition <STRING>
 * 2: Status <BOOLEAN>
 *
 * Returns:
 * none
 *
 * Example:
 * [_computer, "inUse", false] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
 */

params ["_target", "_condition", "_status"];

// ace_dragging_fnc_setCarryable and ace_dragging_fnc_setDraggable need to be executed on all machines with JIP
// ace_cargo_fnc_setSize can be executed locally because it handles JIP and remoteExecCall on it's own

//this function only runs once per triggered interaction by player on server machine
private _settingsAce3 = _target getVariable "AE3_SettingsACE3";
if (isNil "_settingsAce3") exitWith {};

private _isBlocked = _settingsAce3 getOrDefault ["isBlocked", false, true];

if (!(_condition isEqualTo "init")) then
{
    _settingsAce3 set [_condition, _status];
} 
else
{
    // condition = init
    // _isBlocked needs to be true on init
    _isBlocked = true;
};

private _powerConnected = _settingsAce3 getOrDefault ["powerConnected", false, true];
private _networkConnected = _settingsAce3 getOrDefault ["networkConnected", false, true];
private _unwrapped = _settingsAce3 getOrDefault ["unwrapped", false, true];
private _turnedOn = _settingsAce3 getOrDefault ["turnedOn", false, true];
private _inUse = _settingsAce3 getOrDefault ["inUse", false, true];

// ACE3 Carry, Drag and Load will only be available if the device is not connected via power/network, 
// not unfold/opened/expanded, not turned on
if (_powerConnected || _networkConnected || _unwrapped || _turnedOn || _inUse) then
{
    // block the device, if it isn't blocked already
    if (!_isBlocked) then
    {
        if (_settingsAce3 get "ae3_dragging_canDrag") then
        {
            [_target, false] remoteExecCall ["ace_dragging_fnc_setDraggable", 0, true];
        };
        if (_settingsAce3 get "ae3_dragging_canCarry") then
        {
            [_target, false] remoteExecCall ["ace_dragging_fnc_setCarryable", 0, true];
        };
        if (_settingsAce3 get "ae3_cargo_canLoad") then
        {
            [_target, -1] call ace_cargo_fnc_setSize;
        };

        _settingsAce3 set ["isBlocked", true];
    };
}
else
{
    // unblock the device, if it isn't unblocked already
    if (_isBlocked) then
    {
        if (_settingsAce3 get "ae3_dragging_canDrag") then
        {
            private _canDrag = _settingsAce3 get "ae3_dragging_canDrag";
            private _dragPosition = _settingsAce3 get "ae3_dragging_dragPosition";
            private _dragDirection = _settingsAce3 get "ae3_dragging_dragDirection";
            [_target, _canDrag, _dragPosition, _dragDirection] remoteExecCall ["ace_dragging_fnc_setDraggable", 0, true];
        }
        else
        {
            [_target, false] remoteExecCall ["ace_dragging_fnc_setDraggable", 0, true];
        };
        if (_settingsAce3 get "ae3_dragging_canCarry") then
        {
            private _canCarry = _settingsAce3 get "ae3_dragging_canCarry";
            private _carryPosition = _settingsAce3 get "ae3_dragging_carryPosition";
            private _carryDirection = _settingsAce3 get "ae3_dragging_carryDirection";
            [_target, _canCarry, _carryPosition, _carryDirection] remoteExecCall ["ace_dragging_fnc_setCarryable", 0, true];
        }
        else
        {
            [_target, false] remoteExecCall ["ace_dragging_fnc_setCarryable", 0, true];
        };
        if (_settingsAce3 get "ae3_cargo_canLoad") then
        {
            private _canLoad = _settingsAce3 get "ae3_cargo_canLoad";
            private _cargoSize = _settingsAce3 get "ae3_cargo_size";

            // The following  line is a bug fix that is nesessary until the correspondig ACE3 issue is fixed, see here:
            // https://github.com/acemod/ACE3/issues/9109
            _target setVariable ["ace_cargo_setSize_jipID", nil, true];
            
            [_target, _cargoSize] call ace_cargo_fnc_setSize;
        }
        else
        {
            [_target, -1] call ace_cargo_fnc_setSize;
        };

        _settingsAce3 set ["isBlocked", false];
    };
};

// ensures that cargo rename feature is enabled on all assets, no matter if canLoad is true
// some classes have a disabled renaming feature via ACE3 config, like the yellow lamps
_target setVariable ["ace_cargo_noRename", false, true];

_target setVariable ["AE3_SettingsACE3", _settingsAce3];