params ["_type", "_from", "_to", "_allowedFromClasses", "_allowedToClasses"];

if (!((typeOf _from) in _allowedFromClasses) || !((typeOf _to) in _allowedToClasses) || (_from isEqualTo _to)) then
{
    remove3DENConnection [_type, [_from], _to];
    "forbidden connection removed" call BIS_fnc_3DENNotification;
};

// additional check, of _from already has a connection of the given _type, but to another device