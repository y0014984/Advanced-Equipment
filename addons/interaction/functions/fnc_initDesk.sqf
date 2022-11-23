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