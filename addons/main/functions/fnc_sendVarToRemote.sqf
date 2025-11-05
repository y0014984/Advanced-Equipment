/**
 * Sets a local variable to a remote client.
 *
 * Arguments:
 * 0: Client ID <INT>
 * 1: Namespace of the variable <NAMESPACE>
 * 2: Variable name <STRING>
 * 
 * Return:
 * Nothing
 */

params['_caller', '_namespace', '_variable'];

private _value = _namespace getVariable _variable;
_namespace setVariable [_variable, _value, _caller];
_namespace setVariable [_variable + "_trans", true, _caller];
