params ["_computer", "_commandOpts"];

{
	private _shortOpt = _x select 1;
	private _longOpt = _x select 2;
	private _optType = _x select 3;
	private _optDefaultValue = _x select 4;
	private _optRequired = _x select 5;
	private _optHelp = _x select 6;
	private _optSelect = [];

	if ((_optType isEqualTo "stringSelect") || (_optType isEqualTo "numberSelect")) then { _optSelect = _x select 7; };

	private _optName = [_shortOpt, _longOpt, _optType, _optSelect] call AE3_armaos_fnc_shell_getOptsFormatOptsName;

    if (_optRequired) then { _optRequired = " (Required)"} else { _optRequired = ""; };

    private _result = format ["%1%2 : %3", _optName, _optRequired, _optHelp];
    [_computer, _result] call AE3_armaos_fnc_shell_stdout;
} forEach _commandOpts;