/**
 * Initializes and adds onEachFrame Event Handler to draw Debug Information above AE3 objects.
 *
 * Arguments:
 * 0: AE3 Objects [<OBJECT>]
 * 
 * Results:
 * None
 */

/* 
// This task could also accomplished with the drawIcon3D Event Handler, 
// but this Event Handler does not support line breaks or struktured text,
// but we need multiline output to show all needed information.

addMissionEventHandler
	[
		"Draw3D",
		{
			drawIcon3D
				[
					"", // icon texture
					[
						[1,0,0,1], // icon color
						[1,0,0,1] // text color
					],
					ASLToAGL getPosASLVisual cursorTarget, // position in AGL
					0, // icon width
					0, // icon height
					0, // icon angle
					"Hello </br> World", // text
					1, // shadow: 0=no, 1=on, 2=outline
					0.05, // text size
					"PuristaMedium", // font
					"left", // text align "left", "center", "right"
					false, // draw side arrows
					0, // text offset x
					0 // text offset y
				];
		}
	];

*/

params ["_ae3Objects"];

{
	private _obj = _x;
	private _objId = _forEachIndex;

	_display = findDisplay 46;
	_control = _display ctrlCreate ["RscStructuredText", 17654 + _objId];

	_control ctrlSetBackgroundColor [0.835, 0.345, 0.345, 0.5];
	_control ctrlSetTextColor [1, 1, 1, 1];
	_control ctrlSetFontHeight 0.03;
	_control ctrlSetPositionW 0.25;
	_control ctrlSetPositionH 0.25;
	_control ctrlCommit 0;
	
	_ae3Objects set [_forEachIndex, [_x, _control]];
		
	[
		str _objId, // EH ID
		"onEachFrame",
		{
			params ["_obj", "_objId"];

			private _display = findDisplay 46;
			private _control = _display displayCtrl 17654 + _objId;
			
			private _debugText = [];
			
			private _class = typeOf _obj;
			_debugText pushBack format ["Device Class: %1", _class];

			private _powerState = [_obj] call AE3_power_fnc_getPowerState;
			_debugText pushBack format ["Power State: %1", _powerState];

			if (_class isEqualTo "Land_PortableGenerator_01_sand_F_AE3") then
			{
				private _fuelLevel = [_obj] call AE3_power_fnc_getFuelLevel;
				_fuelLevel = [_fuelLevel, 1, 2] call CBA_fnc_formatNumber; // 123.45
				_debugText pushBack format ["Fuel Level: %1 l", _fuelLevel];

				private _powerOutput = [_obj] call AE3_power_fnc_getPowerOutput;
				_powerOutput = [_powerOutput, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
				_debugText pushBack format ["Power Output: %1 W", _powerOutput];
			};
			
			_debugText = _debugText joinString "<br/>";

			_control ctrlSetStructuredText (parseText format ["<t align='center'> %1 </t>", _debugText]);

			private _w = (ctrlPosition _control) select 2;
			private _h = (ctrlPosition _control) select 3;
			
			private _pos2D = worldToScreen ((getPosVisual _obj) vectorAdd [ 0, 0, 2 ]);
		
			if (count _pos2D > 0) then
			{	
				_control ctrlSetPosition
				[
					(_pos2D select 0) - _w / 2,
					(_pos2D select 1) - _h / 2,
					_w,
					_h
				];
		
				_control ctrlSetFade 0;
				_control ctrlCommit 0;
			}
			else
			{
				_control ctrlSetFade 1;
				_control ctrlCommit 0;
			};
		}, 
		[_obj, _objId]
	] call BIS_fnc_addStackedEventHandler;

} forEach _ae3Objects;

