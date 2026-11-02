// File: fnc_terminal_addEventHandler.sqf
#include "..\script_component.hpp"
/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Wires the terminal event handlers (keyboard, scroll, buttons, unload) to the
 * given dialog/controls. The actual handler logic lives in fnc_terminal_onKeyDown,
 * fnc_terminal_onMouseZChanged and fnc_terminal_onUnload so it can be reused by other hosts
 * (e.g. the desktop terminal app).
 *
 * Arguments:
 * 0: _consoleDialog <DISPLAY> - The terminal dialog
 * 1: _terminalCtrl <CONTROL> - Console output control
 * 2: _languageButtonCtrl <CONTROL> - Keyboard layout button
 * 3: _designButtonCtrl <CONTROL> - Terminal design button
 *
 * Return Value:
 * None
 *
 * Example:
 * [_consoleDialog, _terminalCtrl, _languageButtonCtrl, _designButtonCtrl] call AE3_armaos_fnc_terminal_addEventHandler;
 *
 * Public: No
 */

params ["_consoleDialog", "_terminalCtrl", "_languageButtonCtrl", "_designButtonCtrl"];

/* ================================================================================ */

_terminalCtrl ctrlAddEventHandler ["KeyDown", { _this call AE3_armaos_fnc_terminal_onKeyDown }];
_terminalCtrl ctrlAddEventHandler ["Char", { _this call AE3_armaos_fnc_terminal_onChar }];
_terminalCtrl ctrlAddEventHandler ["IMEChar", { _this call AE3_armaos_fnc_terminal_onChar }];

/* ================================================================================ */

_terminalCtrl ctrlAddEventHandler ["MouseZChanged", { _this call AE3_armaos_fnc_terminal_onMouseZChanged }];

/* ================================================================================ */

// Button handlers resolve their display via ctrlParent, so they work in any host display
_languageButtonCtrl ctrlAddEventHandler ["ButtonClick",
	{
		params ["_button"];

		private _display = ctrlParent _button;
		private _consoleOutput = _display displayCtrl 1100;
		private _languageButton = _display displayCtrl 1310;

		private _computer = _consoleOutput getVariable 'AE3_computer';

		[_computer, _languageButton, _consoleOutput] call AE3_armaos_fnc_terminal_switchKeyboardLayout;
	}];

/* ================================================================================ */

_designButtonCtrl ctrlAddEventHandler ["ButtonClick",
	{
		params ["_button"];

		[ctrlParent _button] call AE3_armaos_fnc_terminal_switchTerminalDesign;
	}];

/* ================================================================================ */

// The Unload handler that releases the laptop is wired earlier, in fnc_terminal_init, before the
// terminal performs any suspending state fetches - so an early close still unlocks the device.

/* ================================================================================ */
