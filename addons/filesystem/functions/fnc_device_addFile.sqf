/**
 * PUBLIC
 *
 * Adds a file to a given Device. Device could be a comupter or a flash drive.
 * Logs and displays an error message if file already exists; On other errors it throws an exception.
 * Needs to run on server.
 *
 * Arguments:
 * 1: Device <OBJECT>
 * 2: Path <STRING>
 * 3: Content <STRING>
 * 4: isCode <BOOL>
 * 5: Owner <STRING>
 * 6: Permissions <[ARRAY]>
 * 7: isEncrypted <BOOL> Optional
 * 8: encryptionAlgorithm <STRING> Optional
 * 9: encryptionKey <STRING> Optional
 *
 * Results:
 * none
 *
 * Examples:
 * [_device, "/tmp/new/example.txt", "Lorem ipsum dolor sit amet", false, "root", [[false, true, true], [false, true, true]]] call AE3_filesystem_fnc_device_addFile;
 * [_device, "/test.prg", "hint 'hello world';", true, "root", [[true, false, false], [true, false, false]]] call AE3_filesystem_fnc_device_addFile;
 * [_device, "/tmp/password.txt", "secret", false, "root", [[false, true, true], [false, true, true]], true, "caesar", "13"] call AE3_filesystem_fnc_device_addFile;
 *
 * Permissions:
 * [[owner execute, owner read, owner write], [everyone execute, everyone read, everyone write]]
 */

params ["_computer", "_path", "_content", "_isCode", "_owner", "_permissions", ["_isEncrypted", false], ["_encryptionAlgorithm", nil], ["_encryptionKey", nil]];

if (!isServer) exitWith {};

private _filesystem = _computer getVariable "AE3_filesystem";

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
        diag_log format ["AE3 exception: %1", _exception];
		["AE3 exception: %1", _exception] call BIS_fnc_error;
    }
    else
    {
        throw _exception;
    };
};

_computer setVariable ["AE3_filesystem", _filesystem];
