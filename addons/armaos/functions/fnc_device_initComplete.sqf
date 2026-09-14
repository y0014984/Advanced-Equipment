// File: fnc_device_initComplete.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Marks a device as fully initialized after all setup is complete.
 *
 * Arguments:
 * 0: _entity <STRING> - TODO: Add description
 * 1: _config <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_entity, _config] call AE3_armaos_fnc_device_initComplete;
 *
 * Public: No
 */

params ["_entity", "_config"];

// Check if device was restored from inventory (already has filesystem)
// Only skip filesystem initialization if it exists AND is marked as ready
// This prevents issues with partial initialization from item restore
private _filesystem = _entity getVariable ["AE3_filesystem", nil];
private _wasRestored = !isNil "_filesystem" && {_filesystem isEqualType []};

if (!_wasRestored) then {
	// Fresh device - initialize filesystem first
	[_entity, _config] call AE3_filesystem_fnc_initFilesystem;
	// Seed the app-launcher catalog + root's ~/Desktop; a laptop always has a root user.
	private _fs = _entity getVariable ["AE3_filesystem", []];
	if (_fs isNotEqualTo []) then {
		[_fs, "/root", "root"] call AE3_filesystem_fnc_seedDesktop;
		_entity setVariable ["AE3_filesystem", _fs];
	};

	// Give the device a root account so a permitted root login has a password to check against.
	// The per-device AE3_rootPassword (Eden attribute / API) wins over the mission-wide default.
	if (isServer) then {
		private _userlist = _entity getVariable ["AE3_Userlist", createHashMap];
		if !("root" in _userlist) then {
			private _rootPassword = _entity getVariable ["AE3_rootPassword", ""];
			if (_rootPassword isEqualTo "") then {
				_rootPassword = missionNamespace getVariable ["AE3_DefaultRootPassword", "toor"];
			};
			_userlist set ["root", _rootPassword];
			_entity setVariable ["AE3_Userlist", _userlist, true];
		};
	};
};

// (Re-)initialize OS command links (CODE references must be regenerated after item restore)
// and the network device. Exceptions here must not prevent the ready flag from being set,
// otherwise Zeus modules report "Filesystem not ready" forever (bug on dedicated servers).
try {
	[_entity] call AE3_armaos_fnc_link_init;
} catch {
	ERROR_2("link_init failed for %1: %2",typeOf _entity,_exception);
};

try {
	[_entity] call AE3_network_fnc_initNetworkDevice;
} catch {
	ERROR_2("initNetworkDevice failed for %1: %2",typeOf _entity,_exception);
};

// All initialization complete - now set the ready flag and capability flags
if (isServer) then {
	// Publish the superuser roster from whatever /etc/sudoers the device was seeded with (addon config,
	// Eden attribute, restored state). Permission checks run on clients, whose filesystem copy can lag
	// behind, so the roster has to be broadcast rather than read out of the file on each machine.
	private _sudoers = [_entity] call AE3_armaos_fnc_computer_getSudoers;
	if (_sudoers isNotEqualTo []) then {
		_entity setVariable ["AE3_sudoers", _sudoers, true];
	};

	_entity setVariable ["AE3_cap_hasTerminal", true, true];
	_entity setVariable ["AE3_cap_hasFilesystem", true, true];
	_entity setVariable ["AE3_filesystemReady", true, true];

	// Notify listeners (e.g. the desktop addon's computer/media registry)
	["ae3_armaos_deviceReady", [_entity]] call CBA_fnc_localEvent;
};
