/**
 * Converts ip list to string
 * 
 * Arguments:
 * 0: IP List <[INT]>
 *
 * Retruns:
 * 0: IP String <STRING>
 */

params ["_ip"];

if(count _ip != 4) exitWith { "0.0.0.0"; };

_ip joinString ".";
