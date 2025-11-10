/**
 * Wrapper function to initialize a computer/device completely.
 * Runs all initialization steps and sets the ready flag only when everything is complete.
 * This ensures Zeus modules and other systems don't try to use the device before it's fully initialized.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Config <CONFIG> (Optional)
 *
 * Results:
 * None
 *
 * Example:
 * [_laptop, configFile >> "AE3_FilesystemObjects"] call AE3_armaos_fnc_device_initComplete;
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
