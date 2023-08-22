/**
 * Gets all players within a radius around the given object and executes a given function, command or script with arguments on these clients.
 *
 * Arguments:
 * 0: Range <NUMBER>
 * 1: Object <OBJECT>
 * 2: Function <STRING> or <CODE>
 * 3: Arguments <ANY>
 * 
 * Return:
 * Nothing
 */

 params ["_range", "_object", "_fnc", "_args"];

private _playersInRange = [_range, _object] call AE3_main_fnc_getPlayersInRange;

// using remoteExec on a zero sized array leads to RPT spam warnings
if ((count _playersInRange) == 0) exitWith {};

// use remoteExec if _fnc is type "string"
if ((typeName _fnc) isEqualTo "STRING") then
{
    _args remoteExec [_fnc, _playersInRange];
};

// use a remote executed "call" if _fnc is type "code"
if ((typeName _fnc) isEqualTo "CODE") then
{
    [_args, _fnc] remoteExec ["call", _playersInRange];
};