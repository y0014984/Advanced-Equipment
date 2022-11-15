/**
 * Puts computer in standby mode.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options >= 1) exitWith { [_computer, "'standby' has no options"] call AE3_armaos_fnc_shell_stdout; };

_computer setVariable ["AE3_computer_mutex", objNull, true];
closeDialog 1;

private _handle = [_computer] spawn (_computer getVariable "AE3_power_fnc_standbyWrapper");