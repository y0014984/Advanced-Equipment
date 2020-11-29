params ["_object", "_axis"];

if (!dialog) then {_ok = createDialog "AE3_Rotate_Dialog";};

_ae3RotateDialog = findDisplay 14985;

_ae3RotateSlider = _ae3RotateDialog displayCtrl 2500;

_ae3RotateSlider setVariable ["object", _object];
_ae3RotateSlider setVariable ["axis", _axis];

/* ---------------------------------------- */

_ae3RotateSlider ctrlAddEventHandler
[
	"SliderPosChanged",
	{
		params ["_control", "_newValue"];
		
		//Slider-Werte gehen als Float von 0 bis 10
		
		private _object = _control getVariable "object";
		private _axis = _control getVariable "axis";
		
		hint format ["Objekt: %1 \nAxe: %2\nWert: %3", _object, _axis, _newValue];
		
		_finalValue = 0;
		if (_axis isEqualTo "Panels_Yaw") then {_finalValue = (_newValue * 36) - 180;};	
		if (_axis isEqualTo "Panel_1_Pitch") then {_finalValue = (_newValue * 9) - 45;};	
		if (_axis isEqualTo "Panel_2_Pitch") then {_finalValue = (_newValue * 9) - 45;};	
		
		if (_axis isEqualTo "Light_1_pitch_source") then {_finalValue = (_newValue * 18) - 90;};	
		if (_axis isEqualTo "Light_1_extend_source") then {_finalValue = _newValue * 0.1;};	
		if (_axis isEqualTo "Light_1_yaw_source") then {_finalValue = (_newValue * 36) - 180;};	
		if (_axis isEqualTo "Light_2_pitch_source") then {_finalValue = (_newValue * 18) - 90;};	
		if (_axis isEqualTo "Light_2_extend_source") then {_finalValue = _newValue * 0.1;};	
		if (_axis isEqualTo "Light_2_yaw_source") then {_finalValue = (_newValue * 36) - 180;};	
		if (_axis isEqualTo "Light_3_pitch_source") then {_finalValue = (_newValue * 18) - 90;};	
		if (_axis isEqualTo "Light_3_extend_source") then {_finalValue = _newValue * 0.1;};	
		if (_axis isEqualTo "Light_3_yaw_source") then {_finalValue = (_newValue * 36) - 180;};	
		if (_axis isEqualTo "Light_4_pitch_source") then {_finalValue = (_newValue * 18) - 90;};	
		if (_axis isEqualTo "Light_4_extend_source") then {_finalValue = _newValue * 0.1;};	
		if (_axis isEqualTo "Light_4_yaw_source") then {_finalValue = (_newValue * 36) - 180;};	
		
		_object animateSource [_axis, _finalValue, true];
		
		/*
		xyz animateSource ['Light_1_pitch_source',60,true];
		xyz animateSource ['Light_1_extend_source',0.5,true];
		xyz animateSource ['Light_1_yaw_source',45,true];
		xyz setHitpointDamage ['Hit_Light_1',1];
		xyz animateSource ['Light_2_pitch_source',-20,true];
		xyz animateSource ['Light_2_extend_source',0.7,true];
		xyz animateSource ['Light_2_yaw_source',-45,true];
		xyz setHitpointDamage ['Hit_Light_2',1];	
		*/

	}
];