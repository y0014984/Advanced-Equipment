/*
 * Author: Root
 * Description: Encrypts or decrypts a message using Caesar cipher (shift cipher). Shifts each letter by the specified key value. Only processes A-Z characters and spaces.
 *
 * Arguments:
 * 0: _key <NUMBER> - Shift value for encryption/decryption
 * 1: _mode <STRING> - Operation mode ("encrypt" or "decrypt")
 * 2: _message <STRING> - Message to encrypt/decrypt
 *
 * Return Value:
 * Encrypted or decrypted message <STRING>
 *
 * Example:
 * private _encrypted = [3, "encrypt", "HELLO WORLD"] call AE3_armaos_fnc_encryption_caesar;
 *
 * Public: No
 */

params ["_key", "_mode", "_message"];

// normalize Message to allowed characters
private _allowedAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; // 26 Characters

// convert all characters to upper case
_message = toUpper _message;

// filter message with allowed characters
_message = [_message, _allowedAlphabet + " "] call BIS_fnc_filterString;

// normalize key to be lower then alphabet count
_key = _key % (count _allowedAlphabet); // 26 == 0

// encrypt/decrypt message
private _resultingChar = "";
private _resultingMessage = [];

_allowedAlphabet = _allowedAlphabet splitString "";
_message = _message splitString "";

{
    private _encryptionIndex = _allowedAlphabet find _x;

    // ignore spaces for conversion
    if (_x isNotEqualTo " ") then
    {
        private _countAlphabet = count _allowedAlphabet;

        if (_mode isEqualTo "encrypt") then
        {
            _encryptionIndex = (_countAlphabet + (_encryptionIndex  + _key) % _countAlphabet) % _countAlphabet;
        };
        if (_mode isEqualTo "decrypt") then
        {    
            _encryptionIndex = (_countAlphabet + (_encryptionIndex  - _key) % _countAlphabet) % _countAlphabet;
        };

        _resultingChar = _allowedAlphabet select _encryptionIndex;
    }
    else
    {
        _resultingChar = " ";
    };

    _resultingMessage append [_resultingChar];
} forEach _message;

_resultingMessage = _resultingMessage joinString "";

_resultingMessage
