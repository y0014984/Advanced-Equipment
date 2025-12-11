/*
 * Author: Root, Wasserstoff
 * Description: Wrapper function for obj2item that triggers the AE3_Flashdrive_takeEH event handler first.
 * If any event handler returns true (indicating it handled the take action), obj2item is not called.
 *
 * Arguments:
 * 0: _target <OBJECT> - Flash drive object to take
 * 1: _player <OBJECT> - Player taking the object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_flashDrive, player] call AE3_flashdrive_fnc_take;
 *
 * Public: No
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
	_this call AE3_flashdrive_fnc_obj2item;
};
