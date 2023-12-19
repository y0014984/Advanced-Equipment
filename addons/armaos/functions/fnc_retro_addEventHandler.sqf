/**
 * Adds event handler to a given control.
 *
 * Arguments:
 * 0: Dialog <DIALOG>
 *
 * Results:
 * None
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