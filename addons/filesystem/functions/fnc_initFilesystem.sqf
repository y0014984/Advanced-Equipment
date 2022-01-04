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


private _filesystem = createHashMapFromArray [

	// Essential user commands
	["bin", createHashMap],

	// Essential system commands
	["sbin", createHashMap],

	// User home dirs.
	["home", createHashMap],

	// Root home dir
	["root", createHashMap],

	// Mount file for tmp filesystems
	["mnt", createHashMap],

	// temporaray files saved between reboots
	["tmp", createHashMap]
];

_entity setVariable ['AE3_filesystem', _filesystem, True];
_entity setVariable ['AE3_filepointer', [], True];