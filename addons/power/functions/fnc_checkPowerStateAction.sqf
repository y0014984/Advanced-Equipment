/**
 * Display device power state via hint.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * None
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

hint format [localize "STR_AE3_Power_Interaction_PowerStateHint", _powerStateString];