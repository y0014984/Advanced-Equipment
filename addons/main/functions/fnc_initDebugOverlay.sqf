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
	private _obj = _x select 0;

	private _objId = _forEachIndex;

	_display = findDisplay 46;
	_control = _display ctrlCreate ["RscStructuredText", 17654 + _objId];

	_control ctrlSetBackgroundColor [0.835, 0.345, 0.345, 0.5];
	_control ctrlSetTextColor [1, 1, 1, 1];
	_control ctrlSetFontHeight 0.025;
	_control ctrlSetPositionW 0.3;
	_control ctrlSetPositionH 0.3;
	_control ctrlCommit 0;
	
	_ae3Objects set [_forEachIndex, [_obj, _control]];
		
	[
		str _objId, // EH ID
		"onEachFrame",
		{
			params ["_obj", "_objId"];

			private _display = findDisplay 46;
			private _control = _display displayCtrl 17654 + _objId;
			
			private _debugText = [];
			
			// This function combines item name and custom name in format ["%1 [%2]", _itemName, _customName]
			private _aceCargoName = [_obj, true] call ace_cargo_fnc_getNameItem;
			_debugText pushBack format [localize "STR_AE3_Main_DebugMode_ACE3CargoName", _aceCargoName];

			/* 
			// Getting and Setting ACE3 Cargo Custom Name
			cursorObject setVariable ["ACE_cargo_customName", "Generator 1", true];
			cursorObject getVariable "ACE_cargo_customName";
			// result "Generator 1"
			*/

			private _class = typeOf _obj;
			_debugText pushBack format [localize "STR_AE3_Main_DebugMode_DeviceClass", _class];

			private _powerState = [_obj] call AE3_power_fnc_getPowerState;
			_debugText pushBack format [localize "STR_AE3_Main_DebugMode_PowerState", _powerState];

			// fuel consuming devices
			if (_class isEqualTo "Land_PortableGenerator_01_sand_F_AE3") then
			{
				private _result = [_obj] call AE3_power_fnc_getFuelLevel;
				_result params ["_fuelLevel", "_fuelLevelPercent", "_fuelCapacity"];
				_fuelLevel = [_fuelLevel, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
				_fuelLevelPercent = [_fuelLevelPercent, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
				_fuelCapacity = [_fuelCapacity, 1, 0, true] call CBA_fnc_formatNumber; // 1,234 and 123
				_debugText pushBack format [localize "STR_AE3_Main_DebugMode_FuelLevel", _fuelLevel, _fuelLevelPercent, "%", _fuelCapacity];
			};

			// power generating devices
			if (
				_class isEqualTo "Land_PortableGenerator_01_sand_F_AE3" ||
				_class isEqualTo "Land_SolarPanel_04_sand_F_AE3" ||
				_class isEqualTo "Land_PortableSolarPanel_01_sand_F_AE3"
				) then
			{
				private _powerOutput = [_obj] call AE3_power_fnc_getPowerOutput;
				_powerOutput = [_powerOutput, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
				_debugText pushBack format [localize "STR_AE3_Main_DebugMode_PowerOutput", _powerOutput];

				_connectedDevices = _obj getVariable ["AE3_power_connectedDevices", []];
				_debugText pushBack format [localize "STR_AE3_Main_DebugMode_ConnectedPowerDevices", count _connectedDevices];
			};

			// devices with internal battery
			if (
				_class isEqualTo "Land_Laptop_03_sand_F_AE3" ||
				_class isEqualTo "Land_BatteryPack_01_open_sand_F_AE3" ||
				_class isEqualTo "Land_SolarPanel_04_sand_F_AE3"
				) then
			{
				private _battery = _obj;
				// this check can't be done for solar panel, because the variable has not been set; I'm not sure why
				if ((_obj getVariable ["AE3_power_InternalBattery", false]) || (_class isEqualTo "Land_SolarPanel_04_sand_F_AE3")) then 
				{
					_battery = _obj getVariable "AE3_power_Internal"; 
				};
				private _result = [_battery] call AE3_power_fnc_getBatteryLevel;
				_result params ["_batteryLevel", "_batteryLevelPercent", "_batteryCapacity"];
				_batteryLevel = [_batteryLevel, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
				_batteryLevelPercent = [_batteryLevelPercent, 1, 1, true] call CBA_fnc_formatNumber; // 1,234.5 and 123.4
				_batteryCapacity = [_batteryCapacity, 1, 0, true] call CBA_fnc_formatNumber; // 1,234 and 123
				_debugText pushBack format [localize "STR_AE3_Main_DebugMode_BatteryLevel", _batteryLevel, _batteryLevelPercent, "%", _batteryCapacity];
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

