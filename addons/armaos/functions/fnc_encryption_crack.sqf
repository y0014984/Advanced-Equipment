/**
 * Programmatically decrypt encrypted text without knowing the key/algorithm using various cryptanalysis methods.
 * This function can be called directly by scripts without requiring terminal interaction.
 *
 * Arguments:
 * 0: Message <STRING> - The encrypted message to crack
 * 1: Mode <STRING> - Cracking mode: "bruteforce", "statistics", or "key"
 * 2: Algorithm <STRING> (Optional, default: "caesar") - Encryption algorithm: "caesar" or "columnar"
 *
 * Return Value:
 * <ARRAY> - Array of strings containing the cracking results
 *
 * Example:
 * // Bruteforce Caesar cipher
 * private _results = ["KHOOR ZRUOG", "bruteforce", "caesar"] call AE3_armaos_fnc_encryption_crack;
 *
 * // Statistics analysis on Caesar cipher
 * private _results = ["ENCRYPTED TEXT", "statistics"] call AE3_armaos_fnc_encryption_crack;
 *
 * // Find possible key lengths for Columnar cipher
 * private _results = ["ENCRYPTEDTEXT", "key", "columnar"] call AE3_armaos_fnc_encryption_crack;
 *
 * Public: Yes
 */

params [
	["_message", "", [""]],
	["_mode", "", [""]],
	["_algorithm", "caesar", [""]]
];

// Validate inputs
if (_message isEqualTo "") exitWith {
	["AE3_armaos_fnc_encryption_crack: Message parameter is required"] call BIS_fnc_error;
	[];
};

if (_mode isEqualTo "") exitWith {
	["AE3_armaos_fnc_encryption_crack: Mode parameter is required (bruteforce, statistics, or key)"] call BIS_fnc_error;
	[];
};

if !(_mode in ["bruteforce", "statistics", "key"]) exitWith {
	[format ["AE3_armaos_fnc_encryption_crack: Invalid mode '%1'. Must be bruteforce, statistics, or key", _mode]] call BIS_fnc_error;
	[];
};

if !(_algorithm in ["caesar", "columnar"]) exitWith {
	[format ["AE3_armaos_fnc_encryption_crack: Invalid algorithm '%1'. Must be caesar or columnar", _algorithm]] call BIS_fnc_error;
	[];
};

private _result = [];

switch (_algorithm) do {
	case "caesar": {
		if (_mode isEqualTo "key") exitWith {
			["AE3_armaos_fnc_encryption_crack: Key mode is not available for Caesar cipher"] call BIS_fnc_error;
			[];
		};

		private _allowedAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

		if (_mode isEqualTo "bruteforce") then {
			// Convert all characters to upper case
			_message = toUpper _message;
			// Filter message with allowed characters
			_message = [_message, _allowedAlphabet + " "] call BIS_fnc_filterString;

			for "_i" from 1 to (count _allowedAlphabet) do {
				private _decrypted = [_i, "decrypt", _message] call AE3_armaos_fnc_encryption_caesar;
				private _test = format ["Key %1: %2", _i, _decrypted];
				_result pushBack _test;
			};
		};

		if (_mode isEqualTo "statistics") then {
			private _statistics = createHashMap;

			{
				if (_x isNotEqualTo " ") then {
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
				private _found = format ["Character '%1' appears %2 times (possible key: %3)", _x, _statistics get _x, _keyIfThisIsAnE];
				_result pushBack _found;
			} forEach _foundChars;
		};
	};

	case "columnar": {
		if (_mode isEqualTo "statistics") exitWith {
			["AE3_armaos_fnc_encryption_crack: Statistics mode is not available for Columnar cipher"] call BIS_fnc_error;
			[];
		};

		private _keyLengths = [];
		private _msgLength = count _message;

		for "_i" from 2 to (_msgLength - 1) do {
			if ((_msgLength mod _i) == 0) then {
				_keyLengths pushBack _i;
			};
		};

		if (_keyLengths isEqualTo []) exitWith {
			[format ["AE3_armaos_fnc_encryption_crack: Message length (%1) is prime, cannot determine key lengths", _msgLength]] call BIS_fnc_error;
			[];
		};

		if (_mode isEqualTo "key") then {
			_result pushBack "Possible key lengths:";
			{
				_result pushBack (str _x);
			} forEach _keyLengths;
		};

		if (_mode isEqualTo "bruteforce") then {
			{
				private _col = _x;
				private _rows = _msgLength / _col;
				_result pushBack (format ["Columns: %1, Rows: %2", _col, _rows]);

				// Extract the segments from the encrypted message
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

_result
