/**
 * Encrypts/Decrypts string or file by using a specific algorythm and key. Outputs encrypted/decrypted message to stdout.
 *
 * Arguments:
 * 1: -a Algorythm <STRING> Optional
 * 2: -k Key <STRING>
 * 3: -m Mode <STRING> "encrypt" or "decrypt"
 * 4: Message to Process <STRING>
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

private _commandOpts = 
	[
		["_mode", "m", "mode", "stringSelect", "", true, "sets the mode", ["encrypt", "decrypt"]],
        ["_algorithm", "a", "algorithm", "stringSelect", "caesar", false, "sets the algorithm", ["caesar"]],
        ["_key", "k", "key", "string", "", true, "sets the key/password/pin"]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
            ["options", "OPTIONS", true, false],
			["path", "MESSAGE", true, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _message = _ae3OptsThings joinString " ";

if (_message isEqualTo "") exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasMissingMessage", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _encryptedMessage = "";

// select mode
if ((_mode isEqualTo "encrypt") || (_mode isEqualTo "decrypt")) then
{
    // select algorythm
    if (_algorithm == "caesar") then
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
            [_computer, localize "STR_AE3_ArmaOS_Exception_CaesarCypherNeedsIntegerGreaterNullAsKey"] call AE3_armaos_fnc_shell_stdout;
        };
    };
};

