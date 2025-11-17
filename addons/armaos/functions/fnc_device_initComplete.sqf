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

if (_wasRestored) then {
	// Device was restored from item - filesystem already exists, don't overwrite it
	// But still need to initialize other systems

	// Step 1: Re-initialize OS command links (CODE references must be regenerated)
	[_entity] call AE3_armaos_fnc_link_init;

	// Step 2: Re-initialize network device (in case network topology changed)
	[_entity] call AE3_network_fnc_initNetworkDevice;

	// Mark as ready
	if (isServer) then {
		_entity setVariable ["AE3_filesystemReady", true, true];
	};
} else {
	// Fresh device - perform full initialization
	// Step 1: Initialize filesystem
	[_entity, _config] call AE3_filesystem_fnc_initFilesystem;

	// Step 2: Initialize OS command links
	[_entity] call AE3_armaos_fnc_link_init;

	// Step 3: Initialize network device
	[_entity] call AE3_network_fnc_initNetworkDevice;

	// All initialization complete - now set the ready flag
	if (isServer) then {
		_entity setVariable ["AE3_filesystemReady", true, true];
	};
};
