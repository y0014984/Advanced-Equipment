/**
 * Compiles the (usb) interface from config for an object's class.
 * Analoge to ACE3 MenuCompile.
 *
 * Argmuments:
 * 0: Entity
 *
 * Returns:
 * None
 *
 */

params['_entity'];

private _class = (typeOf _entity);
private _class_name = _class + "_flashdrive";

if(isNil {missionNamespace getVariable _class_name}) then 
{

	private _deviceCfg = configFile >> "CfgVehicles" >> _class >> "AE3_USB_Interface";

	if (!isClass _deviceCfg) exitWith 
	{
		missionNamespace setVariable [_class_name, ""];
	};

	private _config = [_deviceCfg] call AE3_flashdrive_fnc_compileConfig;
	missionNamespace setVariable [_class_name, _config];
};

private _config = missionNamespace getVariable _class_name;

if(_config isEqualType "") exitWith {};


// Workaround, because the compiled config for USB interfaces does not contain a device name
private _tmpDeviceCfg = configFile >> "CfgVehicles" >> _class >> "AE3_Device";
private _parentActionName = getText (_tmpDeviceCfg >> "displayName");

[_entity,  _config, _parentActionName] call AE3_flashdrive_fnc_initInterface;