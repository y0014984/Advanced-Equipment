/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Cycles through available keyboard layouts (US, DE, FR, IT, RU, AR, HE, HU, TR).
 *
 * Arguments:
 * 0: _computer <OBJECT> - TODO: Add description
 * 1: _languageButton <STRING> - TODO: Add description
 * 2: _consoleOutput <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, _languageButton, _consoleOutput] call AE3_armaos_fnc_terminal_switchKeyboardLayout;
 *
 * Public: No
 */

params ["_computer", "_languageButton", "_consoleOutput"];

private _terminal = _computer getVariable "AE3_terminal";
private _terminalKeyboardLayout = _computer getVariable "AE3_terminalKeyboardLayout";

private _availableLanguages = ["AR", "DE", "FR", "HE", "HU", "IT", "RU", "TR", "US"];

private _actualLanguageIndex = _availableLanguages find _terminalKeyboardLayout;

private _newLanguageIndex = 0;

if ((count _availableLanguages) > (_actualLanguageIndex + 1)) then 
{
	_newLanguageIndex = _actualLanguageIndex + 1;
};

_terminalKeyboardLayout = _availableLanguages select _newLanguageIndex;

[_computer, _languageButton, _consoleOutput, _terminalKeyboardLayout] call AE3_armaos_fnc_terminal_setKeyboardLayout;
