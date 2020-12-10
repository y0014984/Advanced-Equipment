params ["_target", "_generator"];

//hint format ["Target: %1\nGenerator: %2", _target, _generator];

_target setVariable ["AE3_powerConsumptionState", 1, true];

_target setVariable ["AE3_powerCableDevice", _generator, true];