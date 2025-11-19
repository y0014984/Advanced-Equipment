/*
 * Author: Root
 * Description: Initializes a power device with turn on/off/standby actions and conditions. Sets up ACE3 interaction menus, creates wrapper functions, and stores device state. Handles both equipment devices (laptops) with submenu structure and standalone devices with simple menu structure.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Device object to initialize
 * 1: _name <STRING> - (Optional, default: "Device") Display name
 * 2: _powerState <NUMBER> - (Optional, default: 0) Initial power state (0=off, 1=on, 2=standby)
 * 3: _initFnc <CODE> - (Optional, default: {}) Initialization function
 * 4: _turnOnFnc <CODE> - (Optional, default: {}) Turn on function
 * 5: _turnOnCondition <CODE> - (Optional, default: {true}) Turn on condition check
 * 6: _turnOffFnc <CODE> - (Optional, default: {}) Turn off function
 * 7: _turnOffCondition <CODE> - (Optional, default: {true}) Turn off condition check
 * 8: _standbyFnc <CODE> - (Optional, default: {}) Standby function
 * 9: _standbyCondition <CODE> - (Optional, default: {true}) Standby condition check
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "Laptop", 0, {}, _turnOnCode, {true}, _turnOffCode, {true}] call AE3_power_fnc_initDevice;
 *
 * Public: No
 */

params ["_entity", ["_name", "Device"], ["_powerState", 0], ["_initFnc", {}], ["_turnOnFnc", {}], ["_turnOnCondition", {true}], ["_turnOffFnc", {}], ["_turnOffCondition", {true}], ["_standbyFnc", {}], ["_standbyCondition", {true}]];

private _turnOnWrapper = {
	params['_target', ['_args', []]];

	_turnOnFnc =  _target getVariable "AE3_power_fnc_turnOn";
	_result = [_target] + _args call _turnOnFnc;
	if(isNil '_result') then {_result = false};

	if(_result) then
	{
		_target setVariable ['AE3_power_powerState', 1, true];
	};
	
};

private _turnOffWrapper = {
	params['_target', ['_args', []]];

	_turnOffFnc =  _target getVariable "AE3_power_fnc_turnOff";
	_result = [_target] + _args call _turnOffFnc;
	if(isNil '_result') then {_result = false};

	if(_result) then
	{
		_target setVariable ['AE3_power_powerState', 0, true];
	};
	
};

private _standbyWrapper = {
	params['_target', ['_args', []]];

	_standbyFnc =  _target getVariable "AE3_power_fnc_standby";
	_result = [_target] + _args call _standbyFnc;
	if(isNil '_result') then {_result = false};

	if(_result) then
	{
		_target setVariable ['AE3_power_powerState', 2, true];
	};
	
};

if(!isDedicated) then
{
	// Check if power device interactions have already been added
	// This prevents duplicate actions when device is deployed from inventory
	private _powerActionsAdded = _entity getVariable ["AE3_power_actionsAdded", false];

	// Declare outside debug block for use in nested blocks
	private _actionsBeforeCount = 0;

	if (AE3_DebugMode) then {
		// DEBUG: Log power action attempts with timestamp and stack trace
		diag_log format ["[AE3 DEBUG] [%1] ===== initDevice called on %2 (type: %3) | powerActionsAdded: %4 =====", time, _entity, typeOf _entity, _powerActionsAdded];
		diag_log format ["[AE3 DEBUG] [%1] Call stack: %2", time, diag_stacktrace];

		// DEBUG: Check ALL flag states
		private _laptopFlag = _entity getVariable ["AE3_interaction_laptopActionsAdded", "UNDEFINED"];
		private _equipmentFlag = _entity getVariable ["AE3_interaction_equipmentActionsAdded", "UNDEFINED"];
		private _hasEquipmentFlag = _entity getVariable ["AE3_interaction_hasEquipmentAction", "UNDEFINED"];
		diag_log format ["[AE3 DEBUG] [%1] Current flag states: power=%2 | laptop=%3 | equipment=%4 | hasEquipment=%5", time, _powerActionsAdded, _laptopFlag, _equipmentFlag, _hasEquipmentFlag];

		// DEBUG: Count ACE actions before we do anything
		private _existingActionsBefore = _entity getVariable ["ace_interact_menu_Act_SelfActions", []];
		if (_existingActionsBefore isEqualType []) then {
			_actionsBeforeCount = count _existingActionsBefore;
		};
		diag_log format ["[AE3 DEBUG] [%1] ACE actions on device BEFORE initDevice: %2", time, _actionsBeforeCount];
	};

	if (!_powerActionsAdded) then {
		// Mark that we're adding the power actions IMMEDIATELY to prevent race conditions
		// (local only - ACE actions are per-client)
		if (AE3_DebugMode) then {
			diag_log format ["[AE3 DEBUG] [%1] initDevice: SETTING powerActionsAdded flag to TRUE for %2", time, _entity];
		};
		_entity setVariable ["AE3_power_actionsAdded", true];
		if (AE3_DebugMode) then {
			diag_log format ["[AE3 DEBUG] [%1] Adding power actions for %2", time, _entity];
		};

		// Ensure equipment parent action exists (creates if needed)
		[_entity] call AE3_interaction_fnc_ensureEquipmentParent;

		private _hasEquipmentAction = _entity getVariable ["AE3_interaction_hasEquipmentAction", false];
		private _parentPath = [];
		private _powerSubmenuPath = [];

		if (_hasEquipmentAction) then {
			// Nest under equipment action with Power submenu
			_parentPath = ["ACE_MainActions", "AE3_EquipmentAction"];

			// Create Power submenu
			private _powerSubmenu = ["AE3_PowerSubmenu", "Power", "", {}, {true}] call ace_interact_menu_fnc_createAction;
			[_entity, 0, _parentPath, _powerSubmenu] call ace_interact_menu_fnc_addActionToObject;

			_powerSubmenuPath = _parentPath + ["AE3_PowerSubmenu"];
		} else {
			// Create standalone device parent for non-laptop devices
			private _parentAction = ["AE3_DeviceAction", _name, "", {}, {true}] call ace_interact_menu_fnc_createAction;
			[_entity, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;

			_powerSubmenuPath = ["ACE_MainActions", "AE3_DeviceAction"];
		};

		// Add check power state action
		private _power = ["AE3_PowerAction", localize "STR_AE3_Power_Interaction_CheckPowerState", "", {[_target] call AE3_power_fnc_checkPowerStateAction}, {true}] call ace_interact_menu_fnc_createAction;
		[_entity, 0, _powerSubmenuPath, _power] call ace_interact_menu_fnc_addActionToObject;
		if (AE3_DebugMode) then {
			diag_log format ["[AE3 DEBUG] [%1] Added power actions for %2 under path: %3", time, _entity, _powerSubmenuPath];
		};

		// Add turn on/off action
		if (!((_turnOnFnc isEqualTo {}) || (_turnOffFnc isEqualTo {}))) then
		{

			_turnOn = ["AE3_TurnOnAction", localize "STR_AE3_Power_Interaction_TurnOn", "",
						{
							params ['_target', '_player', '_params'];
							_target setVariable ['AE3_power_mutex', true, true];
							[_target] spawn {
								params['_target'];
								[_target] call (_target getVariable "AE3_power_fnc_turnOnWrapper");
								_target setVariable ['AE3_power_mutex', false, true];
							};

						},
						{
							((_target call (_target getVariable ["AE3_power_fnc_turnOnCondition", {true}]) and
								(alive _target) and
							(_target getVariable 'AE3_power_powerState' != 1) and
							!(_target getVariable ['AE3_power_mutex', false]) and
							(_target getVariable ['AE3_interaction_closeState', 0] == 0))) //and
							},
						{}] call ace_interact_menu_fnc_createAction;

			_turnOff = ["AE3_TurnOffAction", localize "STR_AE3_Power_Interaction_TurnOff", "",
							{
								params ['_target', '_player', '_params'];

								_target setVariable ['AE3_power_mutex', true, true];
								[_target] spawn {
									params['_target'];
									[_target] call (_target getVariable "AE3_power_fnc_turnOffWrapper");
									_target setVariable ['AE3_power_mutex', false, true];
								};
							},
							{((_target call (_target getVariable ["AE3_power_fnc_turnOffCondition", {true}])) and (alive _target) and  (_target getVariable 'AE3_power_powerState' != 0) and !(_target getVariable ['AE3_power_mutex', false]) and (_target getVariable ['AE3_interaction_closeState', 0] == 0))}, // and ([_target] call (_target getVariable ["AE3_power_fnc_turnOffCondition", {true}])))
							{}] call ace_interact_menu_fnc_createAction;

			[_entity, 0, _powerSubmenuPath, _turnOn] call ace_interact_menu_fnc_addActionToObject;
			[_entity, 0, _powerSubmenuPath, _turnOff] call ace_interact_menu_fnc_addActionToObject;

			// Standby action
			if((_standbyFnc isNotEqualTo {})) then
			{
				_standby = ["AE3_StandbyAction", localize "STR_AE3_Power_Interaction_Standby", "",
							{
								params ['_target', '_player', '_params'];

								_target setVariable ['AE3_power_mutex', true, true];
								[_target] spawn {
									params['_target'];
									[_target] call (_target getVariable "AE3_power_fnc_standbyWrapper");
									_target setVariable ['AE3_power_mutex', false, true];
								};
							},
							{((_target call (_target getVariable ["AE3_power_fnc_standbyCondition", {true}])) and (alive _target) and (_target getVariable 'AE3_power_powerState' == 1) and !(_target getVariable ['AE3_power_mutex', false]) and (_target getVariable ['AE3_interaction_closeState', 0] == 0))}, // and ([_target] call (_target getVariable ["AE3_power_fnc_standbyCondition", {true}]))
							{}] call ace_interact_menu_fnc_createAction;

				[_entity, 0, _powerSubmenuPath, _standby] call ace_interact_menu_fnc_addActionToObject;
			};

		};

		if (AE3_DebugMode) then {
			// DEBUG: Count ACE actions after adding power actions
			private _actionsAfterCount = 0;
			private _existingActionsAfter = _entity getVariable ["ace_interact_menu_Act_SelfActions", []];
			if (_existingActionsAfter isEqualType []) then {
				_actionsAfterCount = count _existingActionsAfter;
			};
			diag_log format ["[AE3 DEBUG] [%1] ACE actions on device AFTER adding power actions: %2 (added %3 actions)", time, _actionsAfterCount, _actionsAfterCount - _actionsBeforeCount];
		};
	} else {
		if (AE3_DebugMode) then {
			diag_log format ["[AE3 DEBUG] [%1] Power actions already added for %2, skipping", time, _entity];

			// DEBUG: Count actions even when skipping to detect duplicates
			private _actionsCount = 0;
			private _existingActions = _entity getVariable ["ace_interact_menu_Act_SelfActions", []];
			if (_existingActions isEqualType []) then {
				_actionsCount = count _existingActions;
			};
			diag_log format ["[AE3 DEBUG] [%1] Current ACE actions on device: %2", time, _actionsCount];
		};
	};
};

if(isServer) then
{
	// Only set initial power state if laptop was not restored from inventory
	// The restoration flag is set by fnc_laptop_item2obj before variables are restored
	private _wasRestored = _entity getVariable ["AE3_laptop_restored", false];
	if (!_wasRestored) then {
		_entity setVariable ["AE3_power_powerState", _powerState, true];
	};
	// else: power state was already restored from saved data, don't overwrite it
};

_entity setVariable ["AE3_power_fnc_turnOn", _turnOnFnc];
_entity setVariable ["AE3_power_fnc_turnOnCondition", _turnOnCondition];
_entity setVariable ["AE3_power_fnc_turnOnWrapper", _turnOnWrapper];
_entity setVariable ["AE3_power_fnc_turnOff", _turnOffFnc];
_entity setVariable ["AE3_power_fnc_turnOffCondition", _turnOffCondition];
_entity setVariable ["AE3_power_fnc_turnOffWrapper", _turnOffWrapper];
_entity setVariable ["AE3_power_fnc_standby", _standbyFnc];
_entity setVariable ["AE3_power_fnc_standbyCondition", _standbyCondition];
_entity setVariable ["AE3_power_fnc_standbyWrapper", _standbyWrapper];

[_entity] call _initFnc;
