// File: fnc_shell_transferMedium.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Picks the simulated transfer medium for a copy between two paths on the same device:
 * "usb" when either path lies under /mnt (a mounted flash drive), otherwise "local".
 *
 * Arguments:
 * 0: _source <STRING> - Source path
 * 1: _target <STRING> - Destination path
 *
 * Return Value:
 * "usb" or "local" <STRING>
 *
 * Example:
 * ["/home/user/a.txt", "/mnt/usb0/a.txt"] call AE3_armaos_fnc_shell_transferMedium; // "usb"
 *
 * Public: Yes
 */

params [["_source", "", [""]], ["_target", "", [""]]];

["local", "usb"] select ((_source find "/mnt") == 0 || (_target find "/mnt") == 0)
