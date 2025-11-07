/**
 * Resets the selected device to default state.
 * This includes resetting the filesystem, clearing terminal history,
 * and resetting all user modifications.
 *
 * Arguments:
 * None
 *
 * Results:
 * None
 */

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

// Confirm reset action
private _confirm = ["Are you sure you want to reset this device?", "Confirm Reset", "Yes", "No"] call BIS_fnc_guiMessage;

if (!_confirm) exitWith {};

[_entity] spawn
{
	params ["_entity"];

	// Reset filesystem to default
	private _config = ((configOf _entity) >> "AE3_FilesystemObjects");
	[_entity, _config] call AE3_filesystem_fnc_initFilesystem;

	// Reset file pointer
	_entity setVariable ["AE3_filepointer", [], true];

	// Reset terminal if it exists
	private _terminal = _entity getVariable ["AE3_terminal", nil];
	if (!isNil "_terminal") then
	{
		// Clear terminal buffer
		_terminal set ["AE3_terminalBuffer", []];

		// Clear command history
		_terminal set ["AE3_terminalCommandHistory", []];
		_terminal set ["AE3_terminalCommandHistoryIndex", -1];

		// Reset scroll position
		_terminal set ["AE3_terminalScrollPosition", 0];

		// Clear login user
		_terminal set ["AE3_terminalLoginUser", ""];

		// Reset to login mode
		_terminal set ["AE3_terminalApplication", "LOGIN"];

		// Clear input buffer
		if (_terminal get "AE3_terminalInputBuffer" != nil) then
		{
			_terminal deleteAt "AE3_terminalInputBuffer";
		};

		// Update terminal variable
		_entity setVariable ["AE3_terminal", _terminal, true];
	};

	// Clear users hashmap (will be recreated from config)
	_entity setVariable ["AE3_users", nil];

	// Clear security commands if any
	_entity setVariable ["AE3_hasSecurityCommands", nil];

	// Clear games if any
	_entity setVariable ["AE3_hasGames", nil];

	// Clear custom links
	_entity setVariable ["AE3_Links", createHashMap, true];

	// Clear USB mounts
	_entity setVariable ["AE3_mounts", [], true];

	// Reinitialize default users from config
	private _usersConfig = ((configOf _entity) >> "AE3_users");
	if (isClass _usersConfig) then
	{
		[_entity, _usersConfig] call AE3_armaos_fnc_computer_addUser;
	};

	["Advanced Equipment", localize "STR_AE3_Main_Zeus_DeviceReset", 5] call BIS_fnc_curatorHint;
};
