/**
 * Decrypt encrypted text without knowing the key/algorythm using various methods. (bruteforce, statistics, etc.)
 *
 * Arguments:
 * 1: -m Mode <STRING> "bruteforce", "statistics", or "key"
 * 2: -a Algorithm <STRING> Optional, default "caesar"
 * 3: -o Output file <STRING> Optional
 * 4: Input (FILE or STRING) <STRING> File path or quoted string
 *
 * Results:
 * None
 */

params ["_computer", "_options", "_commandName"];

// Help system
if (count _options > 0 && {(_options select 0) in ["-h", "--help"]}) exitWith {
	[_computer, [[["CRACK COMMAND HELP", "#8ce10b"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["Description:", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["Decrypt encrypted text without knowing the key using various cryptanalysis methods."]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["Syntax:", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["crack -m <mode> [-a <algorithm>] [-o <output>] <input>"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["Parameters:", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["-m <mode>", "#008DF8"], ["      - Cracking mode (required)", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["-a <algorithm>", "#008DF8"], [" - Encryption algorithm (default: caesar)", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["-o <output>", "#008DF8"], ["    - Save output to file (optional)", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["<input>", "#008DF8"], ["        - Input file path or quoted string (required)", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["Modes:", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["bruteforce", "#008DF8"], ["  - Try all possible keys/shifts", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["statistics", "#008DF8"], ["  - Analyze character frequency (Caesar only)", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["key", "#008DF8"], ["         - Find possible key lengths (Columnar only)", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["Algorithms:", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["caesar", "#008DF8"], ["    - Caesar cipher (shift cipher)", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  ", ""], ["columnar", "#008DF8"], ["  - Columnar transposition cipher", ""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["Examples:", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  crack -m bruteforce -a caesar ""KHOOR ZRUOG"""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  crack -m statistics -a caesar secret.txt"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  crack -m bruteforce -a caesar -o output.txt encrypted.txt"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  crack -m key -a columnar message.txt"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["  crack -m bruteforce -a columnar /tmp/encrypted.txt"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[[""]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["Note:", "#FFD966"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["- Input can be a file path or a quoted string"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["- Use quotes around strings containing spaces"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["- Statistics mode only works with Caesar cipher"]]]] call AE3_armaos_fnc_shell_stdout;
	[_computer, [[["- Key mode only works with Columnar cipher"]]]] call AE3_armaos_fnc_shell_stdout;
};

private _commandOpts =
	[
		["_mode", "m", "mode", "stringSelect", "", true, localize "STR_AE3_ArmaOS_CommandHelp_Crack_mode", ["bruteforce", "statistics", "key"]],
        ["_algorithm", "a", "algorithm", "stringSelect", "caesar", false, localize "STR_AE3_ArmaOS_CommandHelp_Crack_algorithm", ["caesar", "columnar"]],
		["_output", "o", "output", "string", "", false, "Output file path"]
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
private _mode = ""; private _algorithm = "caesar"; private _output = "";
[] params ([_computer, _options, _commandSettings] call AE3_armaos_fnc_shell_getOpts);

if (!_ae3OptsSuccess) exitWith {};

// Get input - either a file path or a quoted string
private _inputRaw = _ae3OptsThings joinString " ";

if (_inputRaw isEqualTo "") exitWith {
	[_computer, format [localize "STR_AE3_ArmaOS_Exception_CommandHasMissingMessage", _commandName]] call AE3_armaos_fnc_shell_stdout;
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

private _result = [];

switch (_algorithm) do {
    case "caesar": {
        if (_mode isEqualTo "key") exitWith {
            [_computer, localize "STR_AE3_ArmaOS_Exception_CaesarCipherKeyCrackNotAvailable"] call AE3_armaos_fnc_shell_stdout;
        };

        private _allowedAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        if (_mode isEqualTo "bruteforce") then
        {
            // convert all characters to upper case
            _message = toUpper _message;
            // filter message with allowed characters
            _message = [_message, _allowedAlphabet + " "] call BIS_fnc_filterString;

            for "_i" from 1 to (count _allowedAlphabet) do
            {
                private _test = format [localize "STR_AE3_ArmaOS_Result_BruteForceTest", _i, [_i, "decrypt", _message] call AE3_armaos_fnc_encryption_caesar];
                _result pushBack _test;
            };
        };

        if (_mode isEqualTo "statistics") then
        {
            private _statistics = createHashMap;

            {
                if (_x isNotEqualTo " ") then
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
    };
    

    case "columnar": {
        if (_mode isEqualTo "statistics") exitWith {
            [_computer, localize "STR_AE3_ArmaOS_Exception_ColumnarCipherStatisticsCrackNotAvailable"] call AE3_armaos_fnc_shell_stdout;
        };

        private _keyLengths = [];
        private _msgLength = count _message;
        for "_i" from 2 to (_msgLength - 1) do {
            if ((_msgLength mod _i) == 0) then {
                _keyLengths pushBack _i;
            };
        };

        if (_keyLengths isEqualTo []) exitWith {
            [_computer, format [localize "STR_AE3_ArmaOS_Exception_ColumnarCipherMessageLengthIsPrime", _msgLength]] call AE3_armaos_fnc_shell_stdout;
        };

        if (_mode isEqualTo "key") then {
            _result pushBack (localize "STR_AE3_ArmaOS_Result_ColumnarKeyLengths");
            {
                _result pushBack (str _x);
            } forEach _keyLengths;
        };

        if (_mode isEqualTo "bruteforce") then {
            {
                private _col = _x;
                private _rows = _msgLength / _col;
                _result pushBack (format [localize "STR_AE3_ArmaOS_Result_ColumnarColRow", _col, _rows]);

                // extract the segments from the encrypted message
                private _msgArr = _message splitString "";
                private _segments = [];
                private _indx = 0;		
                for "_i" from 1 to _col do {
                    _segments pushBack (_msgArr select [_indx, _rows]);
                    _indx = _indx + _rows;
                };
                for "_i" from 0 to (_rows - 1) do {
                    private _colString = "";
                    for "_j" from 0 to (_col - 1) do {                        
                        _colString = _colString + (format ["%1 ", _segments select _j select _i]);
                    };
                    _result pushBack _colString;
                };
                _result pushBack "";
            } forEach _keyLengths;
        };
    };
};

// Output results
if (_output isNotEqualTo "") then {
	// Write to file
	try {
		private _outputContent = _result joinString endl;
		[_pointer, _filesystem, _output, _outputContent, _username, 2] call AE3_filesystem_fnc_writeToFile;
		[_computer, format ["Results written to: %1", _output]] call AE3_armaos_fnc_shell_stdout;
	} catch {
		[_computer, _exception] call AE3_armaos_fnc_shell_stdout;
	};
} else {
	// Output to stdout
	[_computer, _result] call AE3_armaos_fnc_shell_stdout;
};
