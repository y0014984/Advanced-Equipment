/**
 * Uses the AE3 Equipment config to compile a hashmap 
 * for the object.
 *
 * Argmuments:
 * 0: Equipment Config <CONFIG>
 * 1: Config <HASHMAP>
 *
 * Returns:
 * None
 *
 */


params["_equipmentCfg", "_config"];

_config set
[
	'equipment',
	[
		getNumber (_equipmentCfg >> "_animatableLampsCount")
	]
];