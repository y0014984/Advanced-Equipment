/**
 * Prints/outputs the string argument to stdout.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Options <[STRING]>
 * 3: Command Name <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts =
[
    ["_backslashInterpretion", "e", "", "bool", false, false, localize "STR_AE3_ArmaOS_CommandHelp_Echo_backslash"]
];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
			["options", "OPTIONS", false, false],
            ["path", "TEXT", true, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _text = _ae3OptsThings joinString " ";

if (_backslashInterpretion) then
{
	_result = [];

	while { true } do
	{
		private _pos = _text find "\n";
		if (_pos != -1) then
		{
			_result pushBack (_text select [0, _pos]);		
			_text = _text select [_pos + 2];
		}
		else
		{
			_result pushBack _text;
			break;
		};
	};

	_text = _result;
};

[_computer, _text] call AE3_armaos_fnc_shell_stdout;