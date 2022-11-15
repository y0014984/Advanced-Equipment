/**
 * Encrypts/Decrypts string or file by using a specific algorythm and key. Outputs encrypted/decrypted message to stdout.
 *
 * Arguments:
 * 1: -a Algorythm <STRING> Optional
 * 2: -k Key <STRING> Optional
 * 3: -m Mode <STRING> "encrypt" or "decrypt"
 * 4: Message to Process <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options"];

if (count _options < 3) exitWith { [_computer, "'crypto' has too few options"] call AE3_armaos_fnc_shell_stdout; };

private _algorythm = "";
private _key = "";
private _mode = "";
private _message = "";

// recognized options are overwritten by "" so the resulting string is the message to process; No need for quotations
{
    if (_x isEqualTo "-a") then { _algorythm = _options select (_forEachIndex + 1); _options set [_forEachIndex, ""]; _options set [_forEachIndex + 1, ""]; };
    if (_x isEqualTo "-k") then { _key = _options select (_forEachIndex + 1); _options set [_forEachIndex, ""]; _options set [_forEachIndex + 1, ""]; };
    if (_x isEqualTo "-m") then { _mode = _options select (_forEachIndex + 1); _options set [_forEachIndex, ""]; _options set [_forEachIndex + 1, ""]; };
} forEach _options;

private _allowedAlgorythms = ["caesar"];
private _allowedModes = ["encrypt", "decrypt"];

if (!(_algorythm in _allowedAlgorythms)) exitWith { [_computer, "'crypto' has unknown or missing algorythm"] call AE3_armaos_fnc_shell_stdout; };
if (!(_mode in _allowedModes)) exitWith { [_computer, "'crypto' has unknown or missing mode"] call AE3_armaos_fnc_shell_stdout; };
if (_key isEqualTo "") exitWith { [_computer, "'crypto' has unknown or missing key"] call AE3_armaos_fnc_shell_stdout; };

// remove all empty strings from options array
_message = _options - [""];

_message = _message joinString " ";

if (_message isEqualTo "") exitWith { [_computer, "'crypto' has unknown or missing message"] call AE3_armaos_fnc_shell_stdout; };

private _encryptedMessage = "";

// select mode
if ((_mode isEqualTo "encrypt") || (_mode isEqualTo "decrypt")) then
{
    // select algorythm
    if (_algorythm == "caesar") then
    {
        // no float
        _key = floor (parseNumber _key);

        if (_key > 0) then
        { 
            private _processedMessage = [_key, _mode, _message] call AE3_armaos_fnc_encryption_caesar;

            [_computer, _processedMessage] call AE3_armaos_fnc_shell_stdout;
        }
        else
        {
            [_computer, "Caesar Cypher needs an integer greater then 0 as key"] call AE3_armaos_fnc_shell_stdout;
        };
    }
    else
    {
        [_computer, "Unknown algorythm"] call AE3_armaos_fnc_shell_stdout;
    };
}
else
{
    [_computer, "Unknown mode"] call AE3_armaos_fnc_shell_stdout;
};

