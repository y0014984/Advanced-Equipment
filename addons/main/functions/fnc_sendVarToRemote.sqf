/*
 * Author: Root, Wasserstoff
 * Description: Sets a local variable to a remote client for multiplayer synchronization.
 *
 * Arguments:
 * 0: _caller <NUMBER> - Client ID to send the variable to
 * 1: _namespace <NAMESPACE> - Namespace containing the variable
 * 2: _variable <STRING> - Name of the variable to send
 *
 * Return Value:
 * None
 *
 * Example:
 * [clientOwner, missionNamespace, "myVariable"] call AE3_main_fnc_sendVarToRemote;
 *
 * Public: No
 */

params['_caller', '_namespace', '_variable'];

private _value = _namespace getVariable _variable;
_namespace setVariable [_variable, _value, _caller];
_namespace setVariable [_variable + "_trans", true, _caller];
