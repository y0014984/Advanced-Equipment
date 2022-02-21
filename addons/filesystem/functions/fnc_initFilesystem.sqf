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

if(!isServer) exitWith {};

private _filesystem = [createHashMapFromArray [

	// Essential user commands
	["bin", [createHashMap, 'root', [[true, true, true], [false, false, false]]]],

	// Essential system commands
	["sbin", [createHashMap, 'root', [[true, true, true], [false, false, false]]]],

	// User home dirs.
	["home", [createHashMap, 'root', [[true, true, true], [false, false, false]]]],

	// Root home dir
	["root", [createHashMap, 'root', [[true, true, true], [false, false, false]]]],

	// Mount file for tmp filesystems
	["mnt", [createHashMap, 'root', [[true, true, true], [false, false, false]]]],

	// temporaray files saved between reboots
	["tmp", [createHashMap, 'root', [[true, true, true], [true, true, true]]]]
], 'root'];

_entity setVariable ['AE3_filesystem', _filesystem, True];
_entity setVariable ['AE3_filepointer', [], True];