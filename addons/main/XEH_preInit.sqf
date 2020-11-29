/* ================================================================================ */

[
	"Land_MultiScreenComputer_01_sand_F",
	"Init",
	{
		params ["_entity"];
		_handle = [_entity, "Bildschirm 1", 1, 1, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffAction.sqf";
		_handle = [_entity, "Bildschirm 2", 2, 1, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffAction.sqf";
		_handle = [_entity, "Bildschirm 3", 3, 1, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffAction.sqf";
		_handle = [_entity, "Land_MultiScreenComputer_01_closed_sand_F", "3 Bildschirme Computer", 2, 3] execVM "\z\ae3\addons\main\scripts\OpenCloseAction.sqf";
	}, 
	true, 
	[], 
	true
] call CBA_fnc_addClassEventHandler;

/* -------------------------------------------------------------------------------- */

[
	"Land_MultiScreenComputer_01_closed_sand_F", 
	"Init", 
	{
		params ["_entity"]; 
		[_entity, true, [0, 1, 1], 0] call ace_dragging_fnc_setCarryable;
		[_entity, true, [0, 1, 0], 90] call ace_dragging_fnc_setDraggable;
		[_entity, 2] call ace_cargo_fnc_setSize;
		_handle = [_entity, "Land_MultiScreenComputer_01_sand_F", "3 Bildschirme Computer", 1, 3] execVM "\z\ae3\addons\main\scripts\OpenCloseAction.sqf";
	}, 
	true, 
	[], 
	true
] call CBA_fnc_addClassEventHandler;

/* ================================================================================ */

[
	"Land_PortableLight_02_double_sand_F",
	"Init",
	{
		params ["_entity"];
		_handle = [_entity, "Lampe 1", 1, 1, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffAction.sqf";
		_handle = [_entity, "Lampe 2", 2, 1, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffAction.sqf";
		_handle = [_entity, "Land_PortableLight_02_folded_sand_F", "Lampe doppelt", 2, 3] execVM "\z\ae3\addons\main\scripts\OpenCloseAction.sqf";
	}, 
	true, 
	[], 
	true
] call CBA_fnc_addClassEventHandler;

/* -------------------------------------------------------------------------------- */

[
	"Land_PortableLight_02_folded_sand_F",
	"Init",
	{
		params ["_entity"];
		[_entity, true, [0, 1, 1], 0] call ace_dragging_fnc_setCarryable;
		[_entity, true, [0, 1, 0], 90] call ace_dragging_fnc_setDraggable;
		[_entity, 2] call ace_cargo_fnc_setSize;
		_handle = [_entity, "Land_PortableLight_02_double_sand_F", "Lampe doppelt", 1, 3] execVM "\z\ae3\addons\main\scripts\OpenCloseAction.sqf";
	}, 
	true, 
	[], 
	true
] call CBA_fnc_addClassEventHandler;

_action = ["test", "test", "", {hint format ["Hello: %1", "World"]}, {true}] call ace_interact_menu_fnc_createAction;
["Land_PortableLight_02_folded_sand_F", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
["Land_MultiScreenComputer_01_sand_F", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;

/* ================================================================================ */

[
	"Land_SolarPanel_04_sand_F",
	"Init",
	{
		params ["_entity"];
		_handle = [_entity, "Panel 1 Pitch", "Panel_1_Pitch", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Panel 2 Pitch", "Panel_2_Pitch", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Panels Yaw", "Panels_Yaw", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
	}, 
	true, 
	[], 
	true
] call CBA_fnc_addClassEventHandler;

/* ================================================================================ */

[
	"Land_PortableLight_02_quad_sand_F",
	"Init",
	{
		params ["_entity"];
		_handle = [_entity, "Light 1 Pitch", "Light_1_pitch_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 1 Extend", "Light_1_extend_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 1 Yaw", "Light_1_yaw_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 2 Pitch", "Light_2_pitch_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 2 Extend", "Light_2_extend_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 2 Yaw", "Light_2_yaw_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 3 Pitch", "Light_3_pitch_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 3 Extend", "Light_3_extend_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 3 Yaw", "Light_3_yaw_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 4 Pitch", "Light_4_pitch_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 4 Extend", "Light_4_extend_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
		_handle = [_entity, "Light 4 Yaw", "Light_4_yaw_source", 0.5] execVM "\z\ae3\addons\main\scripts\RotateAction.sqf";
	}, 
	true, 
	[], 
	true
] call CBA_fnc_addClassEventHandler;

/* ================================================================================ */