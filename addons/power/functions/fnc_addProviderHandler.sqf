/*
 * Author: Root
 * Description: Creates a per-frame handler loop for power providers (generators, batteries, solar panels). Monitors power state and capacity every second, automatically shutting down connected devices if power becomes insufficient. The handler continuously calls the provider's calculation function to update power state.
 *
 * Arguments:
 * 0: _generator <OBJECT> - Power provider object (generator, battery, or solar panel)
 * 1: _generatorFnc <CODE> - Calculation function that returns [powerState, powerOutput]
 * 2: _internal <BOOL> - (Optional, default: false) Whether this is an internal device
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator, AE3_power_fnc_fuelConsumption] call AE3_power_fnc_addProviderHandler;
 * [_battery, AE3_power_fnc_batteryCalculation, false] remoteExecCall ["AE3_power_fnc_addProviderHandler", 2];
 *
 * Public: No
 */
params['_generator', '_generatorFnc', ['_internal', false]];

_generator setVariable ['AE3_power_powerCapacity', 0];

private _generatorTurnoff = {
	params ['_generator'];
	{
		[_x] call (_x getVariable 'AE3_power_fnc_turnOffWrapper');
	}forEach (_generator getVariable ['AE3_power_connectedDevices', []]);

};

if(!_internal) then
{
	_generatorTurnoff = _generator getVariable 'AE3_power_fnc_turnOffWrapper';
};

// Get power update interval from CBA setting
private _updateInterval = missionNamespace getVariable ["AE3_Power_UpdateInterval", 1.0];

private _handle = [
	{
		private _handle = _this select 1;
		(_this select 0) params ['_generator', '_generatorFnc', '_generatorTurnoff'];

		([_generator] call _generatorFnc) params['_powerState', '_newPower'];

		if(!_powerState) then
		{
			[_generator, [true]] call _generatorTurnoff;
		};

		if(_newPower != (_generator getVariable ['AE3_power_powerCapacity', 0])) then
		{
			_generator setVariable ['AE3_power_powerCapacity', _newPower];

			if(_newPower < _generator getVariable ['AE3_power_powerReq', 0]) then
			{
				[_generator, [true]] call _generatorTurnoff;
			}
		}
	},
	_updateInterval,
	[_generator, _generatorFnc, _generatorTurnoff]
] call CBA_fnc_addPerFrameHandler;

if(_handle < 0) exitWith {throw "GeneratorInitError";};

_generator setVariable ['AE3_power_generatorHandle', _handle];
