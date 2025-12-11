/*
 * Author: Root
 * Description: Handles OK button press in laptop naming dialog
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call AE3_armaos_fnc_laptop_nameDialog_OK;
 *
 * Public: No
 */

// Get the entered text from the dialog
private _display = findDisplay 87654;
if (isNull _display) exitWith {};

private _editCtrl = _display displayCtrl 1001;
private _enteredName = ctrlText _editCtrl;

// Trim whitespace
_enteredName = _enteredName trim [" ", 0];

// Store in uiNamespace for retrieval
uiNamespace setVariable ["AE3_laptop_nameDialog_result", _enteredName];
uiNamespace setVariable ["AE3_laptop_nameDialog_confirmed", true];

// Close the dialog
closeDialog 0;
