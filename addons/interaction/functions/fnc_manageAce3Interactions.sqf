
// Example: [_computer, ["powerConnected", true]] call AE3_interaction_fnc_manageAce3Interactions

params ["_target", "_condition", "_status"];

private _settingsAce3 = _target getVariable "AE3_SettingsACE3";
if (!isNil "_settingsAce3") then
{
    _settingsAce3 set [_condition, _status];

    private _powerConnected = _settingsAce3 getOrDefault ["powerConnected", false, true];
    private _networkConnected = _settingsAce3 getOrDefault ["powerConnected", false, true];
    private _unwrapped = _settingsAce3 getOrDefault ["unwrapped", false, true];
    private _turnedOn = _settingsAce3 getOrDefault ["turnedOn", false, true];

    // ACE3 Carry, Drag and Load will only be available if the device is not connected via power/network, 
    // not unfold/opened/expanded, not turned on
    if (_powerConnected || _networkConnected || _unwrapped || _turnedOn) then
    {
        if (_settingsAce3 get "ae3_dragging_canDrag") then
        {
            [_target, false] remoteExecCall ["ace_dragging_fnc_setDraggable", 0, true];
            _settingsAce3 set ["ae3_dragging_dragIsActive", false];
        };
        if (_settingsAce3 get "ae3_dragging_canCarry") then
        {
            [_target, false] remoteExecCall ["ace_dragging_fnc_setCarryable", 0, true];
            _settingsAce3 set ["ae3_dragging_carryIsActive", false];
        };
    }
    else
    {
        if (_settingsAce3 get "ae3_dragging_canDrag") then
        {
            private _canDrag = _settingsAce3 get "ae3_dragging_canDrag";
            private _dragPosition = _settingsAce3 get "ae3_dragging_dragPosition";
            private _dragDirection = _settingsAce3 get "ae3_dragging_dragDirection";
            [_target, _canDrag, _dragPosition, _dragDirection] remoteExecCall ["ace_dragging_fnc_setDraggable", 0, true];
            _settingsAce3 set ["ae3_dragging_dragIsActive", true];
        };
        if (_settingsAce3 get "ae3_dragging_canCarry") then
        {
            private _canCarry = _settingsAce3 get "ae3_dragging_canCarry";
            private _carryPosition = _settingsAce3 get "ae3_dragging_carryPosition";
            private _carryDirection = _settingsAce3 get "ae3_dragging_carryDirection";
            [_target, _canCarry, _carryPosition, _carryDirection] remoteExecCall ["ace_dragging_fnc_setCarryable", 0, true];
            _settingsAce3 set ["ae3_dragging_carryIsActive", true];
        };
    };

	_target setVariable ["AE3_SettingsACE3", _settingsAce3, true];
};