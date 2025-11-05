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
		["_mode", "m", "mode", "stringSelect", "", true, localize "STR_AE3_ArmaOS_CommandHelp_Crypto_mode", ["encrypt", "decrypt"]],
        ["_algorithm", "a", "algorithm", "stringSelect", "caesar", false, localize "STR_AE3_ArmaOS_CommandHelp_Crypto_algorithm", ["caesar", "columnar"]],
        ["_key", "k", "key", "string", "", true, localize "STR_AE3_ArmaOS_CommandHelp_Crypto_key"]
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

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
private _mode = ""; private _algorithm = "caesar"; private _key = "";
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

private _message = _ae3OptsThings joinString " ";

if (_message isEqualTo "") exitWith { [ _computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasMissingMessage", _commandName] ] call AE3_armaos_fnc_shell_stdout; };

private _encryptedMessage = "";

// select mode
if ((_mode isEqualTo "encrypt") || (_mode isEqualTo "decrypt")) then
{
    // select algorythm
    switch (_algorithm) do
    {
        case "caesar": {
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

        case "columnar": {
            if ((count _key) > 1) then
            {
                _message = _message regexReplace [" ", "_"];
                
                private _processedMessage = [_key, _mode, _message] call AE3_armaos_fnc_encryption_columnar;

                if (_processedMessage isEqualTo "") exitWith {
                    [_computer, localize "STR_AE3_ArmaOS_Exception_ColumnarCipherLengthOfKeyAndMessageDoNotMatch"] call AE3_armaos_fnc_shell_stdout;
                };
                
                [_computer, _processedMessage] call AE3_armaos_fnc_shell_stdout;
            }
            else
            {
                [_computer, localize "STR_AE3_ArmaOS_Exception_ColumnarCipherNeedsStringLengthGreaterOneAsKey"] call AE3_armaos_fnc_shell_stdout;
            };
        };
    };
};

