/**
 * Updates/sets the text for the terminal text field, stored in the visable buffer setting in terminal settings of a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: UI Text Field <CONTROL>
 *
 * Results:
 * None
 */

 params ["_computer", "_outputControl"];

[_computer] call AE3_armaos_fnc_terminal_updateBufferVisable;

private _terminal = _computer getVariable "AE3_terminal";

private _terminalBuffer = _terminal get "AE3_terminalBuffer";
private _terminalBufferVisable = _terminal get "AE3_terminalBufferVisable";

_outputControl ctrlSetText (_terminalBufferVisable joinString endl);
ctrlSetFocus _outputControl;