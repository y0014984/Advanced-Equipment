//_handle = [_object, _light, _mode] execVM "Scripts\OnOff.sqf";

params ["_object", "_light", "_mode"];

hint format ["_object: %1\n_light: %2\n_mode: %3", _object, _light, _mode];

switch (_mode) do
{
	case 0: { _object setHitpointDamage [format["Hit_Light_%1", _light], 0]; };
	case 1: { _object setHitpointDamage [format["Hit_Light_%1",_light], 1]; };
	default { hint "default" };
};
