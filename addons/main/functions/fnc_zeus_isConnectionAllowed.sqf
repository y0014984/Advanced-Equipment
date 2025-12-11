/*
 * Author: Root, y0014984
 * Description: Validates whether a network or power connection in Zeus is allowed based on object classes.
 * Checks if source and target objects are compatible and not the same object. Provides visual feedback to the Zeus curator on validation failure.
 *
 * Arguments:
 * 0: _type <STRING> - Connection type name for feedback messages
 * 1: _from <OBJECT> - Source object of the connection
 * 2: _to <OBJECT> - Target object of the connection
 * 3: _allowedFromClasses <ARRAY> - Array of allowed source object classnames
 * 4: _allowedToClasses <ARRAY> - Array of allowed target object classnames
 *
 * Return Value:
 * Connection validity <BOOL> - true if connection is allowed, false otherwise
 *
 * Example:
 * private _allowed = ["Power", _generator, _laptop, ["Land_PortableGenerator_01_sand_F_AE3"], ["Land_Laptop_03_sand_F_AE3"]] call AE3_main_fnc_zeus_isConnectionAllowed;
 *
 * Public: No
 */

params ["_type", "_from", "_to", "_allowedFromClasses", "_allowedToClasses"];

private _notAllowed = false;

if (!((typeOf _from) in _allowedFromClasses)) then
{
    _notAllowed = true;
    [objNull, format [localize "STR_AE3_Main_Connections_Forbidden1", _type]] call BIS_fnc_showCuratorFeedbackMessage;
};

if (!((typeOf _to) in _allowedToClasses)) then
{
    _notAllowed = true;
    [objNull, format [localize "STR_AE3_Main_Connections_Forbidden2", _type]] call BIS_fnc_showCuratorFeedbackMessage;
};

if (_from isEqualTo _to) then
{
    _notAllowed = true;
    [objNull, format [localize "STR_AE3_Main_Connections_Forbidden3", _type]] call BIS_fnc_showCuratorFeedbackMessage;
};

/* if _from isequalto _module or _to is equalto _module then remove connection */

if (_notAllowed) exitWith
{
    // if connection is not allowed then return 'false'
    false;
};

// if connection is allowed then return 'true'
true;

