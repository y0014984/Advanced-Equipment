/**
 * Uses the AE3 Device config to compile a hashmap 
 * for the object.
 *
 * Argmuments:
 * 0: Device Config <CONFIG>
 *
 * Returns:
 * 0: Config <ARRAY>
 *
 */


params['_deviceCfg', '_config'];

private _interfaceCfg = "true" configClasses _deviceCfg;

private _config = [];

{
	_config pushBack [
		false,
		configName _x,
		getNumber (_x >> "rel_pos"),
		getNumber (_x >> "rot_yaw"),
		getNumber (_x >> "rot_pitch"),
		getNumber (_x >> "rot_roll")
	];
}forEach _interfaceCfg;

_config;