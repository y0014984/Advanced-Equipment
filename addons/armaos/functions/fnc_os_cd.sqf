/**
 * Changes/sets the current working directory of a given terminal on a given computer.
 * Also returns informations about the success of the command.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Folder/Directory <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _options = _options joinString " ";

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

try
{
	private _result = [_computer getVariable ["AE3_filepointer", []], 
				_computer getVariable ["AE3_filesystem", createHashMap], 
				_options,
				_username] call AE3_filesystem_fnc_chdir;

	[(_result select 1), _username, 0] call AE3_filesystem_fnc_hasPermission;
	_computer setVariable ["AE3_filepointer", _result select 0];

}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};