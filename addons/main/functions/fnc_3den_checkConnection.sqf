/*
 * Author: Root
 * Description: Validates a network or power connection in Eden Editor. Checks if the connection is between allowed object classes,
 * prevents self-connections, and warns about multiple connections of the same type. Removes invalid connections and provides
 * visual feedback via Eden Editor notifications.
 *
 * Arguments:
 * 0: _type <STRING> - Connection type (AE3_PowerConnection or AE3_NetworkConnection)
 * 1: _from <OBJECT> - Source object of the connection
 * 2: _to <OBJECT> - Destination object of the connection
 * 3: _allowedFromClasses <ARRAY> - Array of allowed source object class names
 * 4: _allowedToClasses <ARRAY> - Array of allowed destination object class names
 *
 * Return Value:
 * None
 *
 * Example:
 * ["AE3_NetworkConnection", laptop1, router1, ["Land_Laptop_03_sand_F_AE3"], ["Land_Router_01_sand_F_AE3"]] call AE3_main_fnc_3den_checkConnection;
 *
 * Public: No
 */

params ["_type", "_from", "_to", "_allowedFromClasses", "_allowedToClasses"];

private _removeConnection = false;

private _messageType = 1; // 0 = notification (green), 1 = warning (red)
private _messageDuration = 5; // in seconds
private _messageAnimate = true;

if (!((typeOf _from) in _allowedFromClasses)) then
{
    _removeConnection = true;
    [(format [localize "STR_AE3_Main_Connections_Forbidden1", _type]), _messageType, _messageDuration, _messageAnimate] call BIS_fnc_3DENNotification;
};

if (!((typeOf _to) in _allowedToClasses)) then
{
    _removeConnection = true;
    [(format [localize "STR_AE3_Main_Connections_Forbidden2", _type]), _messageType, _messageDuration, _messageAnimate] call BIS_fnc_3DENNotification;
};

if (_from isEqualTo _to) then
{
    _removeConnection = true;
    [localize "STR_AE3_Main_Connections_Forbidden3", _messageType, _messageDuration, _messageAnimate] call BIS_fnc_3DENNotification;
};

// get all 3DEN connections for asset '_from', including the new connection
private _fromConnections = get3DENConnections _from;

private _typeCounter = 0;
{
    _x params ["_tmpType", "_tmpTo"];

    if (_type isEqualTo _tmpType) then { _typeCounter = _typeCounter + 1; };
} forEach _fromConnections;

if (_removeConnection) exitWith
{
    // if one of the above checks needs to remove the given connection
    remove3DENConnection [_type, [_from], _to];
};

// check if the asset '_from' already has a connection of the given _type, but to another device
// this prevents to have more then one connection of a type for the source asset
// we use a distinct direction for our connections: the consumer is source and the generator is destination of the connection
// so a lamp can only be connected to one power source (this does not prevent that a power source is the destination for multiple connections)
// but this could prevent connections like multiple lamps to a battery and battery to generator
// so we can't remove the connection but instead we could give a warning

if (_typeCounter > 1) then
{
    _messageType = 0;
    [(format [localize "STR_AE3_Main_Connections_Warning", _type]), _messageType, _messageDuration, _messageAnimate] call BIS_fnc_3DENNotification;
};
