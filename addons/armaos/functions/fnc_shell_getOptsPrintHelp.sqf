/*
 * Author: Root, y0014984
 * Description: Prints formatted help text for a command, showing syntax, options, and descriptions.
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _commandSettings <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _commandSettings] call AE3_armaos_fnc_shell_getOptsPrintHelp;
 *
 * Public: No
 */

params ["_computer", "_commandSettings"];

private _commandName = _commandSettings select 0;
private _commandOpts = _commandSettings select 1;
private _commandSyntax = _commandSettings select 2;

// print command syntax to stdout
[_computer, [localize "STR_AE3_ArmaOS_Result_GetOpts_CommandSyntax", ""]] call AE3_armaos_fnc_shell_stdout;
{
	private _commandSyntaxString = "";
	private _commandSyntaxVariant = _x;
	{
		private _commandSyntaxType = _x select 0;
		private _commandSyntaxElement = _x select 1;
		private _isRequired = _x select 2;
		private _isUnlimited = _x select 3;
		
		if (_commandSyntaxType isNotEqualTo "command") then
		{
			// if syntax element is set to 'unlimited' ... is appended
			if (_isUnlimited) then { _commandSyntaxElement = _commandSyntaxElement + "..."; };
			// if syntax element is not set to 'required' it is enclosed in [ ]; not for command
			if (!(_isRequired)) then { _commandSyntaxElement = "[" + _commandSyntaxElement + "]"; };
		};
		
		_commandSyntaxString = _commandSyntaxString + _commandSyntaxElement + " ";
	} forEach _commandSyntaxVariant;
	
	[_computer, _commandSyntaxString] call AE3_armaos_fnc_shell_stdout;
} forEach _commandSyntax;

[_computer, ""] call AE3_armaos_fnc_shell_stdout;

// print command options to stdout
[_computer, [localize "STR_AE3_ArmaOS_Result_GetOpts_CommandOptionen", ""]] call AE3_armaos_fnc_shell_stdout;
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

// also add the help option to every command help output
private _result = format ["%1 : %2", "-h/--help", localize "STR_AE3_ArmaOS_CommandHelp_GetOpts_help"];
[_computer, _result] call AE3_armaos_fnc_shell_stdout;
