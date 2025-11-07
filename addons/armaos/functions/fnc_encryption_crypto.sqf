/**
 * Programmatically encrypt or decrypt text using a specific algorithm and key.
 * This function can be called directly by scripts without requiring terminal interaction.
 *
 * Arguments:
 * 0: Message <STRING> - The message to encrypt or decrypt
 * 1: Mode <STRING> - Operation mode: "encrypt" or "decrypt"
 * 2: Key <STRING or NUMBER> - Encryption/decryption key (integer for caesar, string for columnar)
 * 3: Algorithm <STRING> (Optional, default: "caesar") - Encryption algorithm: "caesar" or "columnar"
 *
 * Return Value:
 * <STRING> - The encrypted or decrypted message. Returns empty string on error.
 *
 * Example:
 * // Encrypt with Caesar cipher
 * private _encrypted = ["HELLO WORLD", "encrypt", 3, "caesar"] call AE3_armaos_fnc_encryption_crypto;
 *
 * // Decrypt with Caesar cipher
 * private _decrypted = ["KHOOR ZRUOG", "decrypt", 3, "caesar"] call AE3_armaos_fnc_encryption_crypto;
 *
 * // Encrypt with Columnar transposition
 * private _encrypted = ["HELLO WORLD", "encrypt", "PASSWORD", "columnar"] call AE3_armaos_fnc_encryption_crypto;
 *
 * // Decrypt with Columnar transposition
 * private _decrypted = ["ENCRYPTED", "decrypt", "PASSWORD", "columnar"] call AE3_armaos_fnc_encryption_crypto;
 *
 * Public: Yes
 */

params [
	["_message", "", [""]],
	["_mode", "", [""]],
	["_key", "", ["", 0]],
	["_algorithm", "caesar", [""]]
];

// Validate inputs
if (_message isEqualTo "") exitWith {
	["AE3_armaos_fnc_encryption_crypto: Message parameter is required"] call BIS_fnc_error;
	"";
};

if (_mode isEqualTo "") exitWith {
	["AE3_armaos_fnc_encryption_crypto: Mode parameter is required (encrypt or decrypt)"] call BIS_fnc_error;
	"";
};

if !(_mode in ["encrypt", "decrypt"]) exitWith {
	[format ["AE3_armaos_fnc_encryption_crypto: Invalid mode '%1'. Must be encrypt or decrypt", _mode]] call BIS_fnc_error;
	"";
};

if (_key isEqualTo "" || _key isEqualTo 0) exitWith {
	["AE3_armaos_fnc_encryption_crypto: Key parameter is required"] call BIS_fnc_error;
	"";
};

if !(_algorithm in ["caesar", "columnar"]) exitWith {
	[format ["AE3_armaos_fnc_encryption_crypto: Invalid algorithm '%1'. Must be caesar or columnar", _algorithm]] call BIS_fnc_error;
	"";
};

private _processedMessage = "";

// Select algorithm
switch (_algorithm) do {
	case "caesar": {
		// Convert key to number if it's a string
		if (_key isEqualType "") then {
			_key = parseNumber _key;
		};

		// No float, floor the key
		_key = floor _key;

		if (_key > 0) then {
			_processedMessage = [_key, _mode, _message] call AE3_armaos_fnc_encryption_caesar;
		} else {
			[format ["AE3_armaos_fnc_encryption_crypto: Caesar cipher requires an integer key greater than 0, got: %1", _key]] call BIS_fnc_error;
		};
	};

	case "columnar": {
		// Convert key to string if it's a number
		if (_key isEqualType 0) then {
			_key = str _key;
		};

		if ((count _key) > 1) then {
			// Replace spaces with underscores for columnar cipher
			_message = _message regexReplace [" ", "_"];

			_processedMessage = [_key, _mode, _message] call AE3_armaos_fnc_encryption_columnar;

			if (_processedMessage isEqualTo "") then {
				[format ["AE3_armaos_fnc_encryption_crypto: Columnar cipher - key and message lengths do not match for proper transposition"]] call BIS_fnc_error;
			};
		} else {
			[format ["AE3_armaos_fnc_encryption_crypto: Columnar cipher requires a string key with length > 1, got: '%1'", _key]] call BIS_fnc_error;
		};
	};
};

_processedMessage
