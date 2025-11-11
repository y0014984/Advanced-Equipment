/*
 * Author: Root
 * Description: Compiles USB interface configuration from CfgVehicles config into a hashmap containing interface positions and rotations
 *
 * Arguments:
 * 0: _deviceCfg <CONFIG> - Device configuration class containing AE3_USB_Interface subclasses
 * 1: _config <HASHMAP> - Hashmap to store compiled interface data (unused parameter)
 *
 * Return Value:
 * Compiled interface configuration <HASHMAP> - Keys are interface names, values are [index, name, relPos, rotYaw, rotPitch, rotRoll]
 *
 * Example:
 * [configFile >> "CfgVehicles" >> "Laptop_Device_AE3" >> "AE3_USB_Interface", createHashMap] call AE3_flashdrive_fnc_compileConfig;
 *
 * Public: No
 */


params['_deviceCfg', '_config'];

private _interfaceCfg = "true" configClasses _deviceCfg;

private _config = createHashMap;

{
	_config set [configName _x,
	[
		_forEachIndex,
		configName _x,
		(_x >> "rel_pos") call BIS_fnc_getCfgDataArray,
		getNumber (_x >> "rot_yaw"),
		getNumber (_x >> "rot_pitch"),
		getNumber (_x >> "rot_roll")
	]];
}forEach _interfaceCfg;

_config;
