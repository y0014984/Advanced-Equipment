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

private _result = 
{

	if(!isNil {_x getVariable ['AE3_network_childern']}) then
	{
		if(_cmp == _x) exitWith {true};

		if([_x, _cmp] call AE3_network_fnc_connect_isCyclic) exitWith {true};
	};

}forEach (_entity getVariable ['AE3_network_children', []]);

if(isNil "_result") exitWith {false};

true;