/**
 * Switches the used keyboard layout for terminal inputs by cycling through the given layouts. Active layout is written to the button text.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Keyboard Layout UI Button <CONTROL>
 * 3: UI Text Field <CONTROL>
 *
 * Results:
 * None
 */

params ["_computer", "_languageButton", "_consoleOutput"];

private _terminal = _computer getVariable "AE3_terminal";
private _terminalKeyboardLayout = _terminal get "AE3_terminalKeyboardLayout";

private _availableLanguages = ["DE", "US"];

private _actualLanguageIndex = _availableLanguages find _terminalKeyboardLayout;

private _newLanguageIndex = 0;

if ((count _availableLanguages) > (_actualLanguageIndex + 1)) then 
{
	_newLanguageIndex = _actualLanguageIndex + 1;
};

_terminal set ["AE3_terminalKeyboardLayout", _availableLanguages select _newLanguageIndex];

_languageButton ctrlSetText "KEYBOARD " + (_availableLanguages select _newLanguageIndex);
ctrlSetFocus _consoleOutput;

_computer setVariable ["AE3_terminal", _terminal];