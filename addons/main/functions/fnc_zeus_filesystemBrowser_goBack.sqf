/**
 * Goes back to parent directory in filesystem browser.
 *
 * Arguments:
 * None
 *
 * Results:
 * None
 */

private _display = findDisplay 16993;
if (isNull _display) exitWith {};

private _pointer = _display getVariable ["AE3_pointer", []];

if (count _pointer > 0) then
{
	_pointer deleteAt ((count _pointer) - 1);
	_display setVariable ["AE3_pointer", _pointer];
	[_display] call AE3_main_fnc_zeus_filesystemBrowser_refresh;
};
