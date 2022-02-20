/**
 * Checks if the given user has the permission in the directory.
 *
 * Arguments:
 * 0: File or folder [<HASHMAP>, <STRING>]
 * 1: User <STRING>
 *
 * Returns:
 * None
 *
 */

params['_fileObject', '_user'];

private _owner = _fileObject select 1;

if(_owner isEqualTo '' || _user isEqualTo 'root') exitWith {};

if(!(_owner isEqualTo _user)) throw 'Missing permissions';