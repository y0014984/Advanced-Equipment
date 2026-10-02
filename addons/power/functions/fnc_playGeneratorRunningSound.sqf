// File: fnc_playGeneratorRunningSound.sqf
/*
 * Author: Root
 * Description: Keeps a running generator's engine loop audible on this machine. The generator classes are prop-based and so have no engine simulation, which leaves the "Sounds >> Engine" config entry - whose volume is driven by engineOn - silent. This plays that same sound as an engine-looped local sound for as long as the generator reports itself running, and stops it when it does not. Registers one per-frame handler per generator and does nothing if one is already running for it. The sound is played locally on each machine rather than broadcast, so each player hears exactly one copy.
 *
 * Arguments:
 * 0: _entity <OBJECT> - Generator object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_generator] call AE3_power_fnc_playGeneratorRunningSound;
 *
 * Public: No
 */

params ["_entity"];

if (isNull _entity) exitWith {};

// One loop per generator per machine
if (!isNil { _entity getVariable "AE3_power_runningSoundPfh" }) exitWith {};

private _config = configOf _entity;
getArray (_config >> "Sounds" >> "Engine" >> "sound") params [["_filename", ""], ["_volume", 1], ["_pitch", 1], ["_maxDistance", 100]];

if (_filename isEqualTo "") exitWith {};

private _pfh = [
	{
		params ["_args", "_handle"];
		_args params ["_entity", "_filename", "_volume", "_pitch", "_maxDistance"];

		private _soundId = _entity getVariable ["AE3_power_runningSoundId", -1];

		private _fnc_stop = {
			if (_soundId >= 0) then
			{
				stopSound _soundId;
				_entity setVariable ["AE3_power_runningSoundId", nil];
				_entity setVariable ["AE3_power_runningSoundPos", nil];
			};
		};

		if (!alive _entity) exitWith
		{
			call _fnc_stop;
			_entity setVariable ["AE3_power_runningSoundPfh", nil];
			[_handle] call CBA_fnc_removePerFrameHandler;
		};

		// The start sound raises the engine sound flag once it has finished playing and the stop sound
		// clears it, so the loop covers exactly the stretch the engine sound config used to cover
		private _running = (_entity getVariable ["AE3_power_engineSoundOn", false]) && {(_entity getVariable ["AE3_power_powerState", 0]) isEqualTo 1};

		if (!_running) exitWith { call _fnc_stop; };

		// A looping sound is fixed at the position it started from, so it is restarted if the
		// generator has been carried or dragged away from where the loop began
		private _position = getPosASL _entity;

		if (_soundId >= 0) then
		{
			if ((_entity getVariable ["AE3_power_runningSoundPos", _position]) distance _position > 2) then
			{
				call _fnc_stop;
				_soundId = -1;
			};
		};

		if (_soundId < 0) then
		{
			// Trailing arguments are the local and loop flags: looping requires the sound to be local
			private _id = playSound3D [_filename, _entity, false, _position, _volume, _pitch, _maxDistance, 0, true, true];

			_entity setVariable ["AE3_power_runningSoundId", _id];
			_entity setVariable ["AE3_power_runningSoundPos", _position];
		};
	},
	1,
	[_entity, _filename, _volume, _pitch, _maxDistance]
] call CBA_fnc_addPerFrameHandler;

_entity setVariable ["AE3_power_runningSoundPfh", _pfh];
