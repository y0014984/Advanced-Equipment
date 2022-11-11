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
    case 0: { _powerStateString = "Off"; };
    case 1: { _powerStateString = "On"; };
    case 2: { _powerStateString = "Standby"; };
    default { _powerStateString = "Unknown"; };
};

_powerStateString