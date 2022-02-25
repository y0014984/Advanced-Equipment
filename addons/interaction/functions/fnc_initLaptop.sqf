/**
 * Initializes a laptop.
 *
 * Arguments:
 * 0: Laptop <OBJECT>
 *
 * Returns:
 * None
 */

params["_laptop"];

if (_laptop getVariable 'AE3_interaction_closeState' == 1) then
{
    [_laptop] call (_laptop getVariable "AE3_interaction_fnc_close");
}
else
{
    [_laptop] call (_laptop getVariable "AE3_interaction_fnc_open");
};