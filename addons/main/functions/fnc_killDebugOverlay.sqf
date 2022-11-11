/**
 * Removes/kills every onEachFrame Event Handler to draw Debug Information above AE3 objects.
 *
 * Arguments:
 * 0: AE3 Objects [<OBJECT>]
 * 
 * Results:
 * None
 */

params ["_ae3Objects"];

{
	private _obj = _x select 0;
    private _control = _x select 1;
	private _objId = _forEachIndex;

    [str _objId, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

    ctrlDelete _control;
} forEach _ae3Objects;