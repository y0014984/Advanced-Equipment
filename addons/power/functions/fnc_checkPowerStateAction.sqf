params ["_target"];

_powerState = _target getVariable ["AE3_powerState", -1];

_powerStateString = "";

switch (_powerState) do
{
    case 0: { _powerStateString = "Off"; };
    case 1: { _powerStateString = "On"; };
    case 2: { _powerStateString = "Standby"; };
    default { _powerStateString = "Unknown"; };
};

hint format ["Device Power State is: %1", _powerStateString];