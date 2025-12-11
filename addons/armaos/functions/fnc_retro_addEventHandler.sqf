/*
 * Author: Root, y0014984
 * Description: Adds keyboard event handlers to a retro graphics canvas for interactive applications.
 *
 * Arguments:
 * 0: _dialog <DISPLAY> - The canvas display
 *
 * Return Value:
 * Event handler ID <NUMBER>
 *
 * Example:
 * [_canvas] call AE3_armaos_fnc_retro_addEventHandler;
 *
 * Public: No
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_dialog"];

/* ================================================================================ */

private _result = _dialog displayAddEventHandler
[
	"KeyDown", 
	{
		params ["_dialog", "_key", "_shift", "_ctrl", "_alt"];

		private _keyDownEventHandlerSettings = _dialog getVariable "AE3_Retro_KeyDownEventHandlerSettings";

		/* ---------------------------------------- */
		
		if (_key in _keyDownEventHandlerSettings) then
		{
			private _func = _keyDownEventHandlerSettings get _key;
			[_dialog] call _func;
		};

		/* ---------------------------------------- */

		true // Intercepts the default action, eg. pressing escape won't close the dialog.
	}
];

/* ================================================================================ */
