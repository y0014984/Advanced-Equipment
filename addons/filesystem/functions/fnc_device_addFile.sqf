// File: fnc_device_addFile.sqf
#include "..\script_component.hpp"
/*
 * Author: Root, y0014984
 * Description: Adds a file to a device's filesystem (laptop, server or flash drive). Supports code compilation, encryption and a virtual size. Must run on server. An existing file is left untouched unless _overwrite is set (use AE3_filesystem_fnc_device_writeFile to change file content). While the device is in use the file is written to the user's authoritative copy asynchronously; otherwise synchronously, throwing for errors other than an existing file.
 *
 * Arguments:
 * 0: _computer <OBJECT> - Device object (computer or flash drive)
 * 1: _path <STRING> - Path to new file
 * 2: _content <STRING> - File content (plain text or code string)
 * 3: _isCode <BOOL> - If true, content will be compiled as code
 * 4: _owner <STRING> - Owner of the file
 * 5: _permissions <ARRAY> - Permissions [[owner r,w,x],[everyone r,w,x]]
 * 6: _isEncrypted <BOOL> (Optional, default: false) - If true, content will be encrypted
 * 7: _encryptionAlgorithm <STRING> (Optional) - Encryption algorithm ("caesar" or "columnar")
 * 8: _encryptionKey <STRING> (Optional) - Encryption key
 * 9: _overwrite <BOOL> (Optional, default: false) - If true, an existing file whose name matches
 *    case-INSENSITIVELY in the target directory is removed first (so the new file replaces it)
 * 10: _isPicture <BOOL> (Optional, default: false) - If true, _content is treated as a raw base64
 *    image and stored as an inline picture marker for the in-OS web viewer (overrides code/encryption)
 * 11: _pictureType <STRING> (Optional, default: "auto") - Image MIME hint: "auto" (detect from the
 *    base64 magic bytes), or one of "png"/"jpeg"/"gif"/"bmp"/"webp" to force it
 * 12: _size <NUMBER|STRING> (Optional, default: -1) - Virtual file size in bytes or with a unit
 *    ("50MB"); only affects copy/download duration and listings. -1 = real content size
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "/tmp/test.txt", "Hello World", false, "root", [[false,true,true],[false,true,false]]] call AE3_filesystem_fnc_device_addFile;
 * [_laptop, "/bin/script.sqf", "hint 'test';", true, "root", [[true,false,false],[true,false,false]]] call AE3_filesystem_fnc_device_addFile;
 * [_laptop, "/secure.txt", "secret", false, "root", [[false,true,true],[false,false,false]], true, "caesar", "13"] call AE3_filesystem_fnc_device_addFile;
 * [_server, "/data/plans.bin", "<binary>", false, "root", [[true,true,false],[true,false,false]], false, nil, nil, false, false, "auto", "800MB"] call AE3_filesystem_fnc_device_addFile;
 *
 * Public: Yes
 */

params ["_computer", "_path", "_content", "_isCode", "_owner", "_permissions", ["_isEncrypted", false], ["_encryptionAlgorithm", nil], ["_encryptionKey", nil], ["_overwrite", false], ["_isPicture", false], ["_pictureType", "auto"], ["_size", -1]];

if (!isServer) exitWith {};

// Validate computer object
if (isNull _computer) exitWith {
	ERROR_1("device_addFile called with null computer object. Path: %1",_path);
};

private _filesystem = _computer getVariable ["AE3_filesystem", nil];

// Validate filesystem exists
if (isNil "_filesystem") exitWith {
	ERROR_2("Computer %1 has no filesystem initialized. Cannot add file: %2",_computer,_path);
};

// Inline base64 picture: store the raw base64 as a media marker the in-OS web viewer renders as a
// data URL. Used when the source image cannot be shipped as a real texture in the mission. This path
// overrides code/encryption (both would corrupt the payload) and is size-capped, since the content
// rides the network filesystem sync and the CEF ExecJS transport.
if (_isPicture) then
{
	_isCode = false;
	_isEncrypted = false;

	if !(_content isEqualType "") exitWith { _content = ""; };

	// Strip an optional "data:<mime>;base64," URL prefix and all whitespace/newlines so only the raw
	// base64 alphabet remains (the marker splits on "|", which base64 never contains).
	private _b64 = _content;
	private _comma = _b64 find ";base64,";
	if (_comma != -1) then { _b64 = _b64 select [_comma + 8]; };
	_b64 = _b64 regexReplace ["\s+", ""];

	if ((count _b64) > AE3_MAX_PICTURE_B64) exitWith
	{
		ERROR_2("Picture file %1 rejected: base64 length %2 exceeds the maximum",_path,count _b64);
	};

	// Resolve the MIME type: honor an explicit hint, otherwise detect from the base64 magic prefix.
	private _type = toLower _pictureType;
	private _mime = switch (_type) do
	{
		case "png":  { "image/png" };
		case "jpeg": { "image/jpeg" };
		case "jpg":  { "image/jpeg" };
		case "gif":  { "image/gif" };
		case "bmp":  { "image/bmp" };
		case "webp": { "image/webp" };
		default { "" };
	};

	if (_mime isEqualTo "") then
	{
		private _head = _b64 select [0, 8];
		_mime = call
		{
			if ((_head select [0, 5]) isEqualTo "iVBOR") exitWith { "image/png" };
			if ((_head select [0, 4]) isEqualTo "/9j/") exitWith { "image/jpeg" };
			if ((_head select [0, 6]) isEqualTo "R0lGOD") exitWith { "image/gif" };
			if ((_head select [0, 5]) isEqualTo "UklGR") exitWith { "image/webp" };
			if ((_head select [0, 2]) isEqualTo "Qk") exitWith { "image/bmp" };
			"image/png"
		};
	};

	_content = AE3_MEDIA_B64_PREFIX + _mime + "|" + _b64;
};

if(_isCode) then
{
	_content = compile _content;

	// Code files (executables) must never be encrypted - encryption would destroy the compiled
	// CODE value and make the command unexecutable. Silently override and log.
	if (_isEncrypted) then
	{
		WARNING_1("Encryption requested for code file %1 - ignored (code files cannot be encrypted)",_path);
		_isEncrypted = false;
	};
};

if (_isEncrypted) then
{
	private _mode = "encrypt";
	private _hasCipher = true;
	private _addonAlgorithm = _encryptionAlgorithm;
	private _addonHandler = {};
	private _crypto_fnc = {};

	switch (_encryptionAlgorithm) do
	{
		case "caesar":
		{
			_crypto_fnc =
			{
				params ["_encryptionKey", "_mode", "_row"];

				_encryptionKey = _encryptionKey call BIS_fnc_parseNumber;
				_encryptionKey = round _encryptionKey;
				if (_encryptionKey < 1) then { _encryptionKey = 1; };
				if (_encryptionKey > 25) then { _encryptionKey = 25; };

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
					_encryptionKey = _encryptionKey + "_";
				};

				[_encryptionKey, _mode, _row] call AE3_armaos_fnc_encryption_columnar;
			};
		};
		default
		{
			private _handlers = missionNamespace getVariable ["AE3_filesystem_encryptionHandlers", createHashMap];
			_addonHandler = _handlers getOrDefault [_encryptionAlgorithm, {}];
			if (_addonHandler isEqualTo {}) then
			{
				_hasCipher = false;
				WARNING_1("Unknown file encryption algorithm %1 - storing plaintext",_encryptionAlgorithm);
			}
			else
			{
				_crypto_fnc =
				{
					params ["_encryptionKey", "_mode", "_row"];
					[_addonAlgorithm, _mode, _row, _encryptionKey] call _addonHandler;
				};
			};
		};
	};

	if (_hasCipher) then
	{
		_content = _content splitString endl;

		{
			private _row = [_encryptionKey, _mode, _x] call _crypto_fnc;
			_content set [_forEachIndex, _row];
		} forEach _content;

		_content = _content joinString endl;
	};
};

_size = [_size] call AE3_filesystem_fnc_parseSize;

// Creates the file (honoring overwrite mode) inside the given filesystem; "already exists" is skipped.
private _apply = {
	params ["_fs", "_blockArgs"];
	_blockArgs params ["_filePath", "_fileContent", "_fileOwner", "_filePerms", "_doOverwrite", "_fileSize"];

	// Overwrite mode (used by media registration): remove any case-insensitive name match in the target
	// directory first, so "Intel.PNG" replaces an existing "intel.png" instead of coexisting or being
	// skipped as "already exists".
	if (_doOverwrite) then
	{
		private _parts = (_filePath splitString "/") select { _x isNotEqualTo "" };
		if (_parts isNotEqualTo []) then
		{
			private _fname = _parts deleteAt (count _parts - 1);
			try
			{
				private _pdir = [_parts, _fs] call AE3_filesystem_fnc_resolvePntr;
				private _pcontent = _pdir select 0;
				{
					if ((toLower _x) isEqualTo (toLower _fname)) exitWith { _pcontent deleteAt _x; };
				} forEach (keys _pcontent);
			} catch {};
		};
	};

	private _created = [[], _fs, _filePath, _fileContent, "root", _fileOwner, _filePerms] call AE3_filesystem_fnc_ensureFile;
	if (!_created) then
	{
		INFO_1("File already exists, skipping: %1",_filePath);
	};

	if (_created && _fileSize >= 0) then
	{
		[[], _fs, _filePath, "root", _fileSize] call AE3_filesystem_fnc_setFileSize;
	};
};

private _args = [_path, _content, _owner, _permissions, _overwrite, _size];

// Device in use: the user's client holds the authoritative copy, so write there instead.
if (!isNull (_computer getVariable ["AE3_computer_mutex", objNull])) exitWith
{
	[_computer, _apply, _args] spawn AE3_filesystem_fnc_device_withFilesystem;
};

try
{
	[_filesystem, _args] call _apply;
}
catch
{
	ERROR_2("Failed to create file %1: %2",_path,_exception);
	throw _exception;
};

// Save filesystem back to computer with configurable sync mode
// 0 = Server Only (flag 2), 1 = Global (flag true)
private _syncMode = missionNamespace getVariable ["AE3_Filesystem_SyncMode", 0];
private _syncFlag = [2, true] select (_syncMode == 1);
_computer setVariable ["AE3_filesystem", _filesystem, _syncFlag];
