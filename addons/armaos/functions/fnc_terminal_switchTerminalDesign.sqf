/*
 * Author: Root, y0014984
 * Description: Cycles through available terminal designs.
 *
 * Arguments:
 * 0: _consoleDialog <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_consoleDialog] call AE3_armaos_fnc_terminal_switchTerminalDesign;
 *
 * Public: No
 */

params ["_consoleDialog"];

private _consoleOutput = _consoleDialog displayCtrl 1100;
private _computer = _consoleOutput getVariable "AE3_computer";
private _terminal = _computer getVariable "AE3_terminal";

private _currentDesignIndex = 0;

//AE3_TerminalDesign is a CBA setting
if (!isMultiplayer || (isServer && hasInterface)) then
{
	// In singeplayer or as host in a multiplayer session
	_currentDesignIndex = ["AE3_TerminalDesign", "server"] call CBA_settings_fnc_get;
}
else
{
	// As client in a multiplayer session
	_currentDesignIndex = ["AE3_TerminalDesign", "client"] call CBA_settings_fnc_get;
};

private _designs = _terminal get "AE3_terminalDesigns";

// cycle through the designs
private _currentDesignIndex = _currentDesignIndex + 1;
if (_currentDesignIndex == (count _designs)) then { _currentDesignIndex = 0; };

private _currentDesign = _designs select _currentDesignIndex;

// Store the new design index in terminal hashmap
_terminal set ["AE3_terminalDesign", _currentDesignIndex];
_computer setVariable ["AE3_terminal", _terminal];

// set the design
[_consoleDialog, _currentDesign] call AE3_armaos_fnc_terminal_setTerminalDesign;

// write/sync changed terminal design back to CBA settings
if (!isMultiplayer || (isServer && hasInterface)) then
{
	// In singeplayer or as host in a multiplayer session
	["AE3_TerminalDesign", _currentDesignIndex, 0, "server", true] call CBA_settings_fnc_set;
}
else
{
	// As client in a multiplayer session
	["AE3_TerminalDesign", _currentDesignIndex, 0, "client", true] call CBA_settings_fnc_set;
};

private _consoleOutput = _consoleDialog displayCtrl 1100;

// set focus to text field, otherwise focus stays on button and prohibits additional text input
ctrlSetFocus _consoleOutput;
