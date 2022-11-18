/**
 * Checks power output of a generator or solar panel.
 *
 * Argmuments:
 * 0: Entity <OBJECT>
 *
 * Returns:
 * None
 */

params['_entity'];

[_entity] spawn {
	params['_entity'];
	
	[_entity, "AE3_power_powerCapacity"] call AE3_main_fnc_getRemoteVar;

	private _powerCap = _entity getVariable ['AE3_power_powerCapacity', 0];
	hint format [localize "STR_AE3_Power_Interaction_PowerOutputHint", _powerCap * 3600 * 1000];

}