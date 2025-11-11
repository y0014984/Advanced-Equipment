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
