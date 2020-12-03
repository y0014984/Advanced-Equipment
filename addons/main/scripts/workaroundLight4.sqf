
_entity = light4;

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



[_entity, true, [0, 1, 1], 0] call ace_dragging_fnc_setCarryable;
[_entity, true, [0, 1, 0], 90] call ace_dragging_fnc_setDraggable;

[_entity, 2] call ace_cargo_fnc_setSize;

_handle = [_entity, "Land_PortableLight_02_folded_sand_F", "Lampe", 1, 3] execVM "\z\ae3\addons\main\scripts\OpenCloseAction.sqf";

_entity setHitpointDamage [format["Hit_Light_%1",1], 1];
_entity setHitpointDamage [format["Hit_Light_%1",2], 1];
_entity setHitpointDamage [format["Hit_Light_%1",3], 1];
_entity setHitpointDamage [format["Hit_Light_%1",4], 1];

_handle = [_entity, "Lampe 1", 1, 0, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffActionLight.sqf";
_handle = [_entity, "Lampe 2", 2, 0, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffActionLight.sqf";
_handle = [_entity, "Lampe 3", 3, 0, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffActionLight.sqf";
_handle = [_entity, "Lampe 4", 4, 0, 0.5] execVM "\z\ae3\addons\main\scripts\OnOffActionLight.sqf";

/* -------------------------------------------------------------------------------- */

/*

_entity = box4;

_handle = [_entity, "Land_PortableLight_02_quad_sand_F (light4)", "Lampe", 1, 3] execVM "\z\ae3\addons\main\scripts\OpenCloseAction.sqf";

*/