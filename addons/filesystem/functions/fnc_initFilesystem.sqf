/**
 * Initilizes the filesystem.
 *
 * Arguments:
 * 0: Target <OBJECT>
 *
 * Results:
 * None
 */

params['_entity'];


private _filesystem = [createHashMapFromArray [

	// Essential user commands
	["bin", [createHashMap, 'root']],

	// Essential system commands
	["sbin", [createHashMap, 'root']],

	// User home dirs.
	["home", [createHashMap, 'root']],

	// Root home dir
	["root", [createHashMap, 'root']],

	// Mount file for tmp filesystems
	["mnt", [createHashMap, 'root']],

	// temporaray files saved between reboots
	["tmp", [createHashMap, '']]
], 'root'];

_entity setVariable ['AE3_filesystem', _filesystem, True];
_entity setVariable ['AE3_filepointer', [], True];