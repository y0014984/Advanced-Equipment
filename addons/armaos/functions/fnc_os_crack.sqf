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

params ["_computer", "_options", "_commandName"];

private _commandOpts = 
	[
		["_mode", "m", "mode", "stringSelect", "", true, localize "STR_AE3_ArmaOS_CommandHelp_Crack_mode", ["bruteforce", "statistics", "key"]],
        ["_algorithm", "a", "algorithm", "stringSelect", "caesar", false, localize "STR_AE3_ArmaOS_CommandHelp_Crack_algorithm", ["caesar", "columnar"]]
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

[_computer, _result] call AE3_armaos_fnc_shell_stdout;