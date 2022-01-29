/*
 * Turns off the generator.
 *
 * Arguments:
 * 0: Generator <OBJECT>
 * 1: If the ace progress bar is shown <BOOL>
 * 
 * Return:
 * None
*/
params ["_entity", ["_silent", false]];

_powerState = _entity getVariable "AE3_powerState";

_turnOffTime = 3;

_handle = [_entity] spawn AE3_power_fnc_playGeneratorStopSound;

_handle = _entity getVariable "AE3_generatorRunningSoundHandle";
terminate _handle;

if (!_silent) then 
{
	[
		_turnOffTime,
		[_entity], 
		{

		},
		{},
		("Turn Off")
	] call ace_common_fnc_progressBar;
};

[_entity, true, [0, 1, 0], 0] call ace_dragging_fnc_setDraggable;

[_entity] call AE3_power_fnc_removeProviderHandler;