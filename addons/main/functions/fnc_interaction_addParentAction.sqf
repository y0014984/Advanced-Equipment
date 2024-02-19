/**
 * Creates the parent iteraction for every device and returns the action path.
 *
 * Arguments:
 * 0: Entity <OBJECT>
 * 1: Action Name <STRING>
 * 
 * Return:
 * Action Path <ARRAY>
 *
 */

params["_entity", "_name"];

// get or add parent action
private _parentActionPath = _entity getVariable ["AE3_parentActionPath", []];
if (_parentActionPath isEqualTo []) then
{
    private _parentAction = ["AE3_ParentAction", _name, "", {}, {true}] call ace_interact_menu_fnc_createAction;
    _parentActionPath = [_entity, 0, ["ACE_MainActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;
    _entity setVariable ["AE3_parentActionPath", _parentActionPath];
};

_parentActionPath;