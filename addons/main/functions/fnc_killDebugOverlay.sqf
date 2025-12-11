/*
 * Author: Root, y0014984
 * Description: Removes all onEachFrame event handlers and cleans up debug overlays for AE3 objects.
 * Deletes all associated UI controls.
 *
 * Arguments:
 * 0: _ae3Objects <ARRAY> - Array of AE3 objects with debug overlays to remove
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ae3ObjectsArray] call AE3_main_fnc_killDebugOverlay;
 *
 * Public: No
 */

params ["_ae3Objects"];

{
	private _obj = _x select 0;
    private _control = _x select 1;

    if (_control isNotEqualTo controlNull) then
    {
        private _objId = _forEachIndex;

        [str _objId, "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

        ctrlDelete _control;
    };
} forEach _ae3Objects;
