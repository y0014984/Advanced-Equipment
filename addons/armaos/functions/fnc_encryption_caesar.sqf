/**
 * Encrypts/Decrypts string with ceasar cypher.
 *
 * Arguments:
 * 1: Key <NUMBER>
 * 2: Mode <STRING>
 * 3: Message <STRING>
 *
 * Results:
 * 1: Encrypted/Decrypted Message <STRING>
 */

// this encryption is especially made to allow manual decryption or bruteforce

// later we could implement processing complete files, for new you can use only one line

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
    if (!(_x isEqualTo " ")) then
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