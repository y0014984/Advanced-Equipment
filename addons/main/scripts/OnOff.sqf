//_handle = [_object, _texture, _mode] execVM "Scripts\OnOff.sqf";

params ["_object", "_texture", "_mode"];

_color = "#(argb,8,8,3)color(1,1,1,1.0,co)";

switch (_mode) do
{
	case 1: { _color = "#(argb,8,8,3)color(1,1,1,1.0,co)"; };
	case 2: { _color = "#(argb,8,8,3)color(0,0,0,0.0,co)"; };
	default { hint "default" };
};

_object setObjectTextureGlobal [_texture, _color];