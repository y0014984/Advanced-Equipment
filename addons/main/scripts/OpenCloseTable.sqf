//_handle = [_object, _mode] execVM "Scripts\OpenCloseTable.sqf";

params ["_object", "_mode"];

hint format ["_object: %1\n_mode: %2", _object, _mode];

switch (_mode) do
{
	case 0: {
		_object animate ['Wing_L_hide_source', 0, true];
		_object animate ['Wing_R_hide_source', 0, true];
		_object animate ['Lid_2_hide_source', 1, true];
		_object animate ['Lid_1_hide_source', 1, true];
		};
	case 1: {
		_object animate ['Wing_L_hide_source', 1, true];
		_object animate ['Wing_R_hide_source', 1, true];
		_object animate ['Lid_2_hide_source', 0, true];
		_object animate ['Lid_1_hide_source', 0, true];
	};
	default { hint "default" };
};
