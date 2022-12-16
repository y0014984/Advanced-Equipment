params ["_type", "_from"];

// _type <STRING> = Connection Name/Type; same as data property
// _from <[OBJECT]> = Array of 3den Objects starting the connection; You can multiselect and connect all at once

// this function only triggers if it's executed by another way then the context menu
// for example this function fires if you connect to solders via a default group connection by using CTRL

// (format ["_type: %1 - _from: %2", _type, _from]) call BIS_fnc_3DENNotification;