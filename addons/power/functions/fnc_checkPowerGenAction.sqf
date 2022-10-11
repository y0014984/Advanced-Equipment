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


private _powerCap = _entity getVariable ['AE3_power_powerCapacity', 0];

hint format ["Current power output: %1 W", _powerCap * 3600 * 1000];