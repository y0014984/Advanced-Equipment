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
    case 0: { _powerStateString = "Off"; };
    case 1: { _powerStateString = "On"; };
    case 2: { _powerStateString = "Standby"; };
    default { _powerStateString = "Unknown"; };
};

hint format ["Device Power State is: %1", _powerStateString];