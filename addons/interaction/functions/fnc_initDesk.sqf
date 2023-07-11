/**
 * Initializes a desk, especially it's open/close state.
 *
 * Arguments:
 * 0: Desk <OBJECT>
 *
 * Returns:
 * None
 */

params["_desk"];

if (_desk getVariable "AE3_interaction_closeState" == 1) then
{
    [_desk] call (_desk getVariable "AE3_interaction_fnc_close");
}
else
{
    [_desk] call (_desk getVariable "AE3_interaction_fnc_open");
};

// Workaround to know in Zeus UI if the asset initialized completely.
// The desk is currently the only asset that has Zeus UI but no power functions.
// TODO: We should introduce a mechanism that allows to determine easily, if an asset is 
// initalized by all modules ort not.
// See this issue: https://github.com/y0014984/Advanced-Equipment/issues/367

_desk setVariable ["AE3_power_hasInternal", false];