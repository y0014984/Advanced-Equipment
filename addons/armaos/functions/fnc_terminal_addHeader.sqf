params ["_computer"];

private _header = [] call AE3_armaos_fnc_headerText;

[_computer, _header] call AE3_armaos_fnc_terminal_addLines;