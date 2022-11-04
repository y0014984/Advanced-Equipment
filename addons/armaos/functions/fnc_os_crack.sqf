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

if (count _options < 2) exitWith { [_computer, "'crack' has too few options"] call AE3_armaos_fnc_shell_stdout; };

// parse options --> perhaps we should develop a general options parsing algorythm
private _algorythm = "";
private _mode = "";
private _message = "";

// recognized options are overwritten by "" so the resulting string is the message to process; No need for quotations
{
    if (_x isEqualTo "-a") then { _algorythm = _options select (_forEachIndex + 1); _options set [_forEachIndex, ""]; _options set [_forEachIndex + 1, ""]; };
    if (_x isEqualTo "-m") then { _mode = _options select (_forEachIndex + 1); _options set [_forEachIndex, ""]; _options set [_forEachIndex + 1, ""]; };
} forEach _options;

// remove all empty strings from options array
_message = _options - [""];

_message = _message joinString " ";

private _result = [];

if (_mode isEqualTo "bruteforce") then
{
    if (_algorythm == "caesar") then
    {
        private _allowedAlphabet = " ABCDEFGHIJKLMNOPQRSTUVWXYZ";

        for "_i" from 1 to (count _allowedAlphabet) do
        {
            private _test = format ["Test %1: %2", _i, [_i, "decrypt", _message] call AE3_armaos_fnc_encryption_caesar];
            _result pushBack _test;
        };
    };
};

[_computer, _result] call AE3_armaos_fnc_shell_stdout;