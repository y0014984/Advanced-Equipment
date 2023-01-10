/**
 * Mounts a filesystem which is connect via a given interface.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: File <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options > 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooManyOptions", "mount"] ] call AE3_armaos_fnc_shell_stdout; };
if (count _options < 1) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooFewOptions", "mount"] ] call AE3_armaos_fnc_shell_stdout; };

private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

try
{
	[_computer, _options select 0, _username] call AE3_flashdrive_fnc_mount;
}catch
{
	[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
};