/**
 * Checks if a network is cyclic.
 *
 * Arguments:
 * 0: Router <OBJECT>
 * 1: Cmp. Router <OBJECT>
 *
 * Returns:
 * 0: If cyclic <BOOL>
 */

params['_entity', '_cmp'];

private _result = false;

{
	if(_cmp == _x) then 
	{
		_result = true;
		break;
	};

	if([_x, _cmp] call AE3_network_fnc_connect_isCyclic) then 
	{
		_result = true;
		break;
	};
}forEach (_entity getVariable ['AE3_network_children', []]);

_result;