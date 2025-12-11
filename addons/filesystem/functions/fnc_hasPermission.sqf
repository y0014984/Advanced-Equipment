/*
 * Author: Root, y0014984, Wasserstoff
 * Description: Checks if a user has the specified permission on a filesystem object. Throws exception if permission denied. Root user and empty owner always pass. Checks owner permissions first, then everyone permissions.
 *
 * Arguments:
 * 0: _fileObject <ARRAY> - Filesystem object [content, owner, permissions]
 * 1: _user <STRING> - User to check permissions for
 * 2: _permission <NUMBER> - Permission to check (0: Execute, 1: Read, 2: Write)
 *
 * Return Value:
 * None (throws exception if permission denied)
 *
 * Example:
 * [_fileObj, "root", 1] call AE3_filesystem_fnc_hasPermission;
 * [_dirObj, "user", 2] call AE3_filesystem_fnc_hasPermission;
 *
 * Public: Yes
 */

params['_fileObject', '_user', '_permission'];

private _owner = _fileObject select 1;
private _permissions = _fileObject select 2;

if(_owner isEqualTo '' || _user isEqualTo 'root') exitWith {};

if(_permissions select 1 select _permission) exitWith {};

if((_owner isEqualTo _user) && (_permissions select 0 select _permission)) exitWith {};

throw localize "STR_AE3_Filesystem_Exception_MissingPermissions";
