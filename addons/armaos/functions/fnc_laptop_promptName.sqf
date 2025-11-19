/*
 * Author: Root
 * Description: Shows a dialog to prompt player to name their laptop
 *
 * Arguments:
 * 0: _defaultName <STRING> - Default name to show in the input field
 *
 * Return Value:
 * <STRING> - The entered name, or default name if cancelled
 *
 * Example:
 * ["Laptop_1"] call AE3_armaos_fnc_laptop_promptName;
 *
 * Public: No
 */

params [["_defaultName", "Laptop"]];

// Reset the dialog result variables
uiNamespace setVariable ["AE3_laptop_nameDialog_result", _defaultName];
uiNamespace setVariable ["AE3_laptop_nameDialog_confirmed", false];

// Create the dialog
createDialog "AE3_LaptopNameDialog";

// Wait for dialog to be created
waitUntil {!isNull (findDisplay 87654)};

// Set default text
private _display = findDisplay 87654;
private _editCtrl = _display displayCtrl 1001;
_editCtrl ctrlSetText _defaultName;
ctrlSetFocus _editCtrl;

// Wait for dialog to close
waitUntil {isNull (findDisplay 87654)};

// Get the result
private _confirmed = uiNamespace getVariable ["AE3_laptop_nameDialog_confirmed", false];
private _result = uiNamespace getVariable ["AE3_laptop_nameDialog_result", _defaultName];

// Return the entered name or default
[_defaultName, _result] select (_confirmed && (_result != ""))
