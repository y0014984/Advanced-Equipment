/**
 * List all interfaces.
 * 
 * Arguments:
 * 0: Computer <OBJECT>
 *
 * Returns:
 * 0: Interfaces <[STRING]>
 */

params['_computer'];

if(!isServer) then
{
	[_computer, "AE3_USB_Interfaces"] call AE3_main_fnc_getRemoteVar;
};
private _interfaces = _computer getVariable ["AE3_USB_Interfaces", createHashMap];

private _result = [[["USB Interfaces:"]]];

{
	_y params ['_occupied', '_mounted', '_name', '_rel_pos', '_rot_yaw', '_rot_pitch', '_rot_roll'];
	
	private _device = "";
	private _mountstr = "";


	if (isNull _occupied) then
	{
		_device = "None";
	}else
	{
		_device = "Flash Drive";
	};

	if (_mounted) then
	{
		_mountstr = "mounted";
	};

	_result pushBack [[format ["%1 -  %2", _x, _device]], [format ["    %1", _mountstr],"#8ce10b"]];
} forEach _interfaces;

_result;