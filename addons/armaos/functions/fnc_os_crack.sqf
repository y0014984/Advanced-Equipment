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

if (count _options < 2) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasTooFewOptions", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _algorythm = "";
private _mode = "";
private _message = "";

// recognized options are overwritten by "" so the resulting string is the message to process; No need for quotations
{
    if (_x isEqualTo "-a") then { _algorythm = _options select (_forEachIndex + 1); _options set [_forEachIndex, ""]; _options set [_forEachIndex + 1, ""]; };
    if (_x isEqualTo "-m") then { _mode = _options select (_forEachIndex + 1); _options set [_forEachIndex, ""]; _options set [_forEachIndex + 1, ""]; };
} forEach _options;

private _allowedAlgorythms = ["caesar"];
private _allowedModes = ["bruteforce", "statistics"];

if (!(_mode in _allowedModes)) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasMissingMode", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

// remove all empty strings from options array
_message = _options - [""];

_message = _message joinString " ";

if (_message isEqualTo "") exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasMissingMessage", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _result = [];

private _allowedAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

// convert all characters to upper case
_message = toUpper _message;

// filter message with allowed characters
_message = [_message, _allowedAlphabet + " "] call BIS_fnc_filterString;

if (_mode isEqualTo "bruteforce") then
{
    if (!(_algorythm in _allowedAlgorythms)) exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasMissingAlgorythm", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

    if (_algorythm == "caesar") then
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