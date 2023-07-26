/**
 * PRIVATE
 *
 * This function checks wether or not a network or power connection in Zeus is valid or not. 
 * If connection is not valid, it will be removed. Gives visual feeedback in Zeus.
 * This function is private because it only makes sense in context of Zeus UI.
 *
 * Arguments:
 * 1: Type <STRING>
 * 2: From <OBJECT>
 * 3: To <OBJECT>
 * 4: Allowed From Classes <[STRING]>
 * 5: Allowed To Classes <[STRING]>
 *
 * Results:
 * 1: Result <BOOL>
 *
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

