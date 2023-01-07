/**
 * Uses the AE3 Interface config to compile a hashmap 
 * for the object.
 *
 * Argmuments:
 * 0: Interface Config <CONFIG>
 *
 * Returns:
 * 0: Config <ARRAY>
 *
 */


params['_deviceCfg', '_config'];

private _interfaceCfg = "true" configClasses _deviceCfg;

private _config = createHashMap;

{
	_config set [configName _x,
	[
		objNull,
		false,
		configName _x,
		(_x >> "rel_pos") call BIS_fnc_getCfgDataArray,
		getNumber (_x >> "rot_yaw"),
		getNumber (_x >> "rot_pitch"),
		getNumber (_x >> "rot_roll")
	]];
}forEach _interfaceCfg;

_config;