/**
 * Wrapper for obj2items. Calls AE3_Flashdrive_takeEH Eventhandler.
 * 
 * Arguments:
 * 0: Target object <OBJECT>
 * 1: Player which wants to take the object <Object>
 *
 * Results:
 * None
 */

params ["_target", "_player"]; 

// EH return if they already called obj2item.
private _results = [_target, "AE3_Flashdrive_takeEH", _this, true] call BIS_fnc_callScriptedEventHandler;

private _result = false;

{
	if (isNil "_x") then {break};
	if (!(_x isEqualType true)) then {break};

	_result = _result || _x;
}forEach _results;

if(!_result) then
{
	_this remoteExec ["AE3_flashdrive_fnc_obj2item", 2];
};