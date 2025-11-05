/**
 * Returns device power state.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 
 * Returns:
 * 0: Power State <STRING> "Off", "On", "Standby" or "Unknown"
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
