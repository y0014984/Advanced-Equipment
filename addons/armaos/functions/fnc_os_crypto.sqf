/*
 * Author: Root
 * Description: Encrypts or decrypts text using specified encryption algorithm and key. Supports caesar and columnar cipher algorithms. Can read from files or direct string input.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 * 1: _options <ARRAY> - Command options and arguments (-m mode, -a algorithm, -k key, -o output file, input)
 * 2: _commandName <STRING> - The name of the command
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, ["-m=encrypt", "-k=3", "-a=caesar", "HELLO WORLD"], "crypto"] call AE3_armaos_fnc_os_crypto;
 *
 * Public: Yes
 */

params ["_computer", "_options", "_commandName"];

// Help system
if (count _options > 0 && {(_options select 0) in ["-h", "--help"]}) exitWith {
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpTitle", "#8ce10b"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpDescription", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpDescriptionText"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpSyntax", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpSyntaxText"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpParameters", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpParamMode"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpParamKey"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpParamAlgorithm"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpParamOutput"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpParamInput"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpModes", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpModeEncrypt"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpModeDecrypt"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpAlgorithms", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpAlgoCaesar"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpAlgoColumnar"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpExamples", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpExample1"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpExample2"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpExample3"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpExample4"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpNote", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpNote1"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpNote2"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpNote3"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[localize "STR_AE3_ArmaOS_Crypto_HelpNote4"]]]] call AE3_armaos_fnc_shell_stdout;
};

private _commandOpts =
	[
		["_mode", "m", "mode", "stringSelect", "", true, localize "STR_AE3_ArmaOS_CommandHelp_Crypto_mode", ["encrypt", "decrypt"]],
        ["_algorithm", "a", "algorithm", "stringSelect", "caesar", false, localize "STR_AE3_ArmaOS_CommandHelp_Crypto_algorithm", ["caesar", "columnar"]],
        ["_key", "k", "key", "string", "", true, localize "STR_AE3_ArmaOS_CommandHelp_Crypto_key"],
		["_output", "o", "output", "string", "", false, localize "STR_AE3_ArmaOS_Crypto_HelpParamOutput"]
	];
private _commandSyntax =
[
	[
			["command", _commandName, true, false],
            ["options", "OPTIONS", true, false],
			["path", "INPUT", true, true]
	]
];
private _commandSettings = [_commandName, _commandOpts, _commandSyntax];

private _ae3OptsSuccess = false; private _ae3OptsThings = [];
private _mode = ""; private _algorithm = "caesar"; private _key = ""; private _output = "";
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

// Validate required mode parameter
if (_mode isEqualTo "") exitWith {
	[_computer, localize "STR_AE3_ArmaOS_Crypto_ErrorModeRequired"] call AE3_armaos_fnc_shell_stdout;
	[_computer, localize "STR_AE3_ArmaOS_Crypto_ErrorModeExample"] call AE3_armaos_fnc_shell_stdout;
};

// Get input - either a file path or a quoted string
private _inputRaw = _ae3OptsThings joinString " ";

if (_inputRaw isEqualTo "") exitWith {
	[_computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasMissingMessage", _commandName]] call AE3_armaos_fnc_shell_stdout;
};

// Warn if input contains algorithm names (likely user error with extra arguments)
private _inputUpper = toUpper _inputRaw;
if ((_inputUpper find "CAESAR" >= 0) || (_inputUpper find "COLUMNAR" >= 0)) then {
	[_computer, localize "STR_AE3_ArmaOS_Crypto_WarningAlgorithmInInput"] call AE3_armaos_fnc_shell_stdout;
	[_computer, localize "STR_AE3_ArmaOS_Crypto_HintUseQuotes"] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
};

// Try to read as file first, otherwise treat as string
private _message = "";
private _pointer = _computer getVariable "AE3_filepointer";
private _filesystem = _computer getVariable "AE3_filesystem";
private _terminal = _computer getVariable "AE3_terminal";
private _username = _terminal get "AE3_terminalLoginUser";

try {
	// Attempt to read as file
	private _fileContent = [_pointer, _filesystem, _inputRaw, _username, 1] call AE3_filesystem_fnc_getFile;

	if (_fileContent isEqualType "") then {
		// Successfully read file
		_message = _fileContent;
	} else {
		// Not a file, treat as string
		_message = _inputRaw;
	};
} catch {
	// File read failed, treat as string input
	_message = _inputRaw;
};

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

				// Output handling
				if (_output isNotEqualTo "") then {
					// Write to file
					try {
						// Create output file if it doesn't exist (rw-rw- permissions)
						try {
							[_pointer, _filesystem, _output, "", _username, _username, [[false, true, true], [false, true, true]]] call AE3_filesystem_fnc_createFile;
						} catch {
							// File already exists, ignore error
						};
						[_pointer, _filesystem, _output, _username, _processedMessage, false] call AE3_filesystem_fnc_writeToFile;
						[_computer, format [localize "STR_AE3_ArmaOS_Result_ResultsWrittenTo", _output]] call AE3_armaos_fnc_shell_stdout;
					} catch {
						[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
					};
				} else {
					// Output to stdout
					[_computer, _processedMessage] call AE3_armaos_fnc_shell_stdout;
				};
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

				// Output handling
				if (_output isNotEqualTo "") then {
					// Write to file
					try {
						// Create output file if it doesn't exist (rw-rw- permissions)
						try {
							[_pointer, _filesystem, _output, "", _username, _username, [[false, true, true], [false, true, true]]] call AE3_filesystem_fnc_createFile;
						} catch {
							// File already exists, ignore error
						};
						[_pointer, _filesystem, _output, _username, _processedMessage, false] call AE3_filesystem_fnc_writeToFile;
						[_computer, format [localize "STR_AE3_ArmaOS_Result_ResultsWrittenTo", _output]] call AE3_armaos_fnc_shell_stdout;
					} catch {
						[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
					};
				} else {
					// Output to stdout
					[_computer, _processedMessage] call AE3_armaos_fnc_shell_stdout;
				};
            }
            else
            {
                [_computer, localize "STR_AE3_ArmaOS_Exception_ColumnarCipherNeedsStringLengthGreaterOneAsKey"] call AE3_armaos_fnc_shell_stdout;
            };
        };
    };
};

