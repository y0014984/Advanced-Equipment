/*
 * Author: Root, Wasserstoff
 * Description: Lists all USB interfaces on a computer with their connection and mount status, formatted for terminal output
 *
 * Arguments:
 * 0: _computer <OBJECT> - Computer object to list USB interfaces from
 *
 * Return Value:
 * Formatted interface list for terminal display <ARRAY> - Array of [text, color] pairs for terminal rendering
 *
 * Example:
 * [laptop] call AE3_flashdrive_fnc_lsInterfaces;
 *
 * Public: No
 */

params['_computer'];

private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];
private _occupiedList = _computer getVariable "AE3_USB_Interfaces_occupied";
private _mountedList = _computer getVariable "AE3_USB_Interfaces_mounted";

private _result = [[[localize "STR_AE3_Flashdrive_Result_USBInterfacesHeader"]]];

{
	_y params ['_index', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];

	private _device = "";
	private _mountstr = "";

	private _occupied = _occupiedList select _index;
	private _mounted = _mountedList select _index;
	if (isNull _occupied) then
	{
		_device = localize "STR_AE3_Flashdrive_Result_DeviceNone";
	}else
	{
		_device = localize "STR_AE3_Flashdrive_Result_DeviceFlashDrive";
	};

	if (_mounted) then
	{
		_mountstr = localize "STR_AE3_Flashdrive_Result_StatusMounted";
	};

	_result pushBack [[format ["%1 -  %2", _x, _device]], [format ["    %1", _mountstr],"#8ce10b"]];
} forEach _interfaces;

_result;
