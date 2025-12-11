/*
 * Author: Root, y0014984
 * Description: Returns the current power state of a device as a localized string. Power states are: 0 = Off, 1 = On, 2 = Standby, -1 = Unknown.
 *
 * Arguments:
 * 0: _target <OBJECT> - Device to check
 *
 * Return Value:
 * Localized power state string <STRING>
 *
 * Example:
 * private _state = [_laptop] call AE3_power_fnc_getPowerState;
 * hint format ["Device is: %1", [_generator] call AE3_power_fnc_getPowerState];
 *
 * Public: Yes
 */

params ["_target"];

private _powerState = _target getVariable ["AE3_power_powerState", -1];

private _powerStateString = "";

switch (_powerState) do
{
    case 0: { _powerStateString = localize "STR_AE3_Power_Interaction_PowerStateOff"; };
    case 1: { _powerStateString = localize "STR_AE3_Power_Interaction_PowerStateOn"; };
    case 2: { _powerStateString = localize "STR_AE3_Power_Interaction_PowerStateStandby"; };
    default { _powerStateString = localize "STR_AE3_Power_Interaction_PowerStateUnknown"; };
};

_powerStateString
