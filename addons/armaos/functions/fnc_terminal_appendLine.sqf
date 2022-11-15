params ["_computer", "_inputLine"];

{
	[_computer, _x] call AE3_armaos_fnc_terminal_addChar;
} forEach (_inputLine splitString "");