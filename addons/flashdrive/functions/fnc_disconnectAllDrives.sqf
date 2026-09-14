// File: fnc_disconnectAllDrives.sqf
/*
 * Author: Root
 * Description: Disconnects every flash drive currently connected to a computer, converting each back
 * to an inventory item for the given player. Used before a laptop is picked up into inventory so no
 * drive is left orphaned in the world (attached to a removed/hidden laptop) where it could be taken
 * and then act on a dead parent. Runs on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer whose drives should be disconnected
 * 1: _player <OBJECT> - The player who receives the drives as items
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, _player] call AE3_flashdrive_fnc_disconnectAllDrives;
 *
 * Public: Yes
 */

params ["_computer", "_player"];

if (!isServer) exitWith {};
if (isNull _computer) exitWith {};

private _occupiedList = +(_computer getVariable ["AE3_USB_Interfaces_occupied", []]);
private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];
private _mountedList = _computer getVariable ["AE3_USB_Interfaces_mounted", []];
private _savedDrives = [];

{
    private _obj = _x;
    if (!isNull _obj) then
    {
        private _name = _obj getVariable ["AE3_Flashdrive_Interface", ""];
        private _cfg = _interfaces getOrDefault [_name, []];
        if (_cfg isNotEqualTo []) then
        {
            private _wasMounted = _mountedList param [_cfg select 0, false];
            private _item = [_computer, _player, _cfg] call AE3_flashdrive_fnc_disconnectFlashDrive;
            if (_item isEqualType "" && _item isNotEqualTo "") then {
                _savedDrives pushBack [_name, _item, _wasMounted];
            };
        };
    };
} forEach _occupiedList;

_savedDrives
