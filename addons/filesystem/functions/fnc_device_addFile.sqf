/*
 * Author: Root, y0014984
 * Description: Adds a file to a device's filesystem (laptop or flash drive). Supports code compilation and encryption. Must run on server. Logs error if file already exists, throws exception for other errors.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device object (computer or flash drive)
 * 1: _path <STRING> - Path to new file
 * 2: _content <STRING> - File content (plain text or code string)
 * 3: _isCode <BOOL> - If true, content will be compiled as code
 * 4: _owner <STRING> - Owner of the file
 * 5: _permissions <ARRAY> - Permissions [[owner x,r,w],[everyone x,r,w]]
 * 6: _isEncrypted <BOOL> (Optional, default: false) - If true, content will be encrypted
 * 7: _encryptionAlgorithm <STRING> (Optional) - Encryption algorithm ("caesar" or "columnar")
 * 8: _encryptionKey <STRING> (Optional) - Encryption key
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "/tmp/test.txt", "Hello World", false, "root", [[false,true,true],[false,true,false]]] call AE3_filesystem_fnc_device_addFile;
 * [_laptop, "/bin/script.sqf", "hint 'test';", true, "root", [[true,false,false],[true,false,false]]] call AE3_filesystem_fnc_device_addFile;
 * [_laptop, "/secure.txt", "secret", false, "root", [[false,true,true],[false,false,false]], true, "caesar", "13"] call AE3_filesystem_fnc_device_addFile;
 *
 * Public: Yes
 */

params ["_computer", "_path", "_content", "_isCode", "_owner", "_permissions", ["_isEncrypted", false], ["_encryptionAlgorithm", nil], ["_encryptionKey", nil]];

if (!isServer) exitWith {};

// Validate computer object
if (isNull _computer) exitWith {
	diag_log format ["AE3 ERROR: fnc_device_addFile called with null computer object. Path: %1", _path];
	["AE3 ERROR: Cannot add file to null computer object. Path: %1", _path] call BIS_fnc_error;
};

private _filesystem = _computer getVariable ["AE3_filesystem", nil];

// Validate filesystem exists
if (isNil "_filesystem") exitWith {
	diag_log format ["AE3 ERROR: Computer %1 has no filesystem initialized. Cannot add file: %2", _computer, _path];
	["AE3 ERROR: Computer has no filesystem. Please wait for initialization to complete and try again."] call BIS_fnc_error;
};

if(_isCode) then
{
	_content = compile _content;
};

if (_isEncrypted) then 
{
	private _mode = "encrypt";

	private _crypto_fnc = {};

	switch (_encryptionAlgorithm) do
	{
		case "caesar":
		{
			_crypto_fnc = 
			{
				params ["_encryptionKey", "_mode", "_row"];

				_encryptionKey = _encryptionKey call BIS_fnc_parseNumber; // needs a number
				_encryptionKey = round _encryptionKey; // needs an integer
				if (_encryptionKey < 1) then { _encryptionKey = 1; }; // needs to be >= 1
				if (_encryptionKey > 25) then { _encryptionKey = 25; }; // needs to be <= 25

				[_encryptionKey, _mode, _row] call AE3_armaos_fnc_encryption_caesar;
			};
		};
		case "columnar":
		{
			_crypto_fnc =
			{
				params ["_encryptionKey", "_mode", "_row"];

				_row = _row regexReplace [" ", "_"];

				while {(count _encryptionKey) < 2 } do 
				{
					_encryptionKey = _encryptionKey + "_"; // min. length 2
				};

				[_encryptionKey, _mode, _row] call AE3_armaos_fnc_encryption_columnar;
			};
		};
	};

	_content = _content splitString endl;

	{
		private _row = [_encryptionKey, _mode, _x] call _crypto_fnc;
		_content set [_forEachIndex, _row];
	} forEach _content;

	_content = _content joinString endl;
};

// throws exception if file already exists
try
{
    [
        [],
        _filesystem,
        _path,
        _content,
        "root",
        _owner,
        _permissions
    ] call AE3_filesystem_fnc_createFile;
}
catch
{
    private _normalizedException = _exception regexReplace ["'(.+)'", "'%1'"];
    if (_normalizedException isEqualTo (localize "STR_AE3_Filesystem_Exception_AlreadyExists")) then
    {
        diag_log format ["AE3: File already exists: %1", _exception];
		["AE3: File already exists: %1", _exception] call BIS_fnc_error;
    }
    else
    {
        diag_log format ["AE3 ERROR: Failed to create file %1: %2", _path, _exception];
        throw _exception;
    };
};

// Save filesystem back to computer with configurable sync mode
// 0 = Server Only (flag 2), 1 = Global (flag true)
private _syncMode = missionNamespace getVariable ["AE3_Filesystem_SyncMode", 0];
private _syncFlag = [2, true] select (_syncMode == 1);
_computer setVariable ["AE3_filesystem", _filesystem, _syncFlag];
