/**
 * PRIVATE
 *
 * This function is triggered by the "update" button in the default AE3 Zeus Asset Attributes Interface.
 * It changes the content of the currently selected file in the tree view to the content of the changed edit box above.
 *
 * Arguments:
 * 0: Button <CONTROL>
 *
 * Results:
 * Visual Feedback in Zeus Interface
 *
 * Example:
 * [] call AE3_main_fnc_zeus_updateFileContent;
 *
 */

params ["_button"];

private _entity = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target", objNull];
if (isNull _entity) exitWith {};

private _display = ctrlParent _button;
private _fileExplorerCtrl = _display getVariable ["fileExplorerCtrl", controlNull];
private _fileContentCtrl = _display getVariable ["fileContentCtrl", controlNull];

private _filesystem = _entity getVariable ["AE3_filesystem", []];
private _pointer = [];
private _target = "";
private _user = "root";
private _content = ctrlText _fileContentCtrl; 

private _selectionPath = _fileExplorerCtrl getVariable ["selectionPath", []];

private _pointerLUT = _fileExplorerCtrl getVariable ["pointerLUT", createHashMap];
private _itemId = _fileExplorerCtrl tvValue _selectionPath;
private _pointerArray = _pointerLUT get _itemId;
_pointerArray params ["_pointer", "_target"];

[_pointer, _filesystem, _target, _user, _content] call AE3_filesystem_fnc_setFileContent;
_entity setVariable ["AE3_filesystem", _filesystem, 2];

// update data in fileExplorerCtrl item
_fileExplorerCtrl tvSetData [_selectionPath, _content];

["Advanced Equipment", localize "STR_AE3_Main_Zeus_FileContentChanged", 5] call BIS_fnc_curatorHint;
