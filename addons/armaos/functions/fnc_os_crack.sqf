/**
 * Decrypt encrypted text without knowing the key/algorythm using various methods. (bruteforce, statistics, etc.)
 *
 * Arguments:
 * 1: -m Mode <STRING> "bruteforce" or "statistics"
 * 2: -a Algorythm <STRING> Optional
 * 3: Message to Process <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

private _commandName = "crack";
private _commandOpts = 
	[
		["_mode", "m", "mode", "stringSelect", "", true, "sets the mode", ["bruteforce", "statistics"]],
        ["_algorithm", "a", "algorithm", "stringSelect", "caesar", false, "sets the algorithm", ["caesar"]]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
            ["options", "OPTIONS", true, false],
			["path", "MESSAGE", true, false]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _message = _ae3OptsThings joinString " ";

if (_message isEqualTo "") exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasMissingMessage", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _result = [];

private _allowedAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

// convert all characters to upper case
_message = toUpper _message;

// filter message with allowed characters
_message = [_message, _allowedAlphabet + " "] call BIS_fnc_filterString;

if (_mode isEqualTo "bruteforce") then
{
    if (_algorithm == "caesar") then
    {
        for "_i" from 1 to (count _allowedAlphabet) do
        {
            private _test = format [localize "STR_AE3_ArmaOS_Result_BruteForceTest", _i, [_i, "decrypt", _message] call AE3_armaos_fnc_encryption_caesar];
            _result pushBack _test;
        };
    };
};

if (_mode isEqualTo "statistics") then
{
    private _statistics = createHashMap;

    {
        if (!(_x isEqualTo " ")) then
        {
            private _count = 0;
            if (_x in _statistics) then { _count = _statistics get _x; };
            _count = _count + 1;

            _statistics set [_x, _count];
        };
    } forEach (_message splitString "");

    private _foundChars = keys _statistics;

    _foundChars sort true;

    private _indexOfE = _allowedAlphabet find "E";
    {
        private _keyIfThisIsAnE = _allowedAlphabet find _x;

        _keyIfThisIsAnE = ((_keyIfThisIsAnE + (count _allowedAlphabet)) - _indexOfE) % (count _allowedAlphabet);

        private _found = format [localize "STR_AE3_ArmaOS_Result_CharacterFoundPossibleKey", _x, _statistics get _x, _keyIfThisIsAnE];     
        _result pushBack _found;
    } forEach _foundChars;
};

[_computer, _result] call AE3_armaos_fnc_shell_stdout;