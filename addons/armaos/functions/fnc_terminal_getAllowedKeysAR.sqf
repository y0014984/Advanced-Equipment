/*
 * Author: Root
 * Description: Returns the allowed keyboard key mappings for Arabic (AR) layout.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [TODO] call AE3_armaos_fnc_terminal_getAllowedKeysAR;
 *
 * Public: No
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

// Arabic (Standard Arabic 101) keyboard layout
// order: _shift, _ctrl, _alt

private _allowedKeys = createHashMapFromArray
[
	// Arabic letters
	[format ["%1-%2-%3-%4", DIK_Q, false, false, false], "ض"],
	[format ["%1-%2-%3-%4", DIK_Q, true, false, false], "َ"],
	[format ["%1-%2-%3-%4", DIK_W, false, false, false], "ص"],
	[format ["%1-%2-%3-%4", DIK_W, true, false, false], "ً"],
	[format ["%1-%2-%3-%4", DIK_E, false, false, false], "ث"],
	[format ["%1-%2-%3-%4", DIK_E, true, false, false], "ُ"],
	[format ["%1-%2-%3-%4", DIK_E, false, false, true], "€"],
	[format ["%1-%2-%3-%4", DIK_R, false, false, false], "ق"],
	[format ["%1-%2-%3-%4", DIK_R, true, false, false], "ٌ"],
	[format ["%1-%2-%3-%4", DIK_T, false, false, false], "ف"],
	[format ["%1-%2-%3-%4", DIK_T, true, false, false], "لإ"],
	[format ["%1-%2-%3-%4", DIK_Y, false, false, false], "غ"],
	[format ["%1-%2-%3-%4", DIK_Y, true, false, false], "إ"],
	[format ["%1-%2-%3-%4", DIK_U, false, false, false], "ع"],
	[format ["%1-%2-%3-%4", DIK_U, true, false, false], "`"],
	[format ["%1-%2-%3-%4", DIK_I, false, false, false], "ه"],
	[format ["%1-%2-%3-%4", DIK_I, true, false, false], "÷"],
	[format ["%1-%2-%3-%4", DIK_O, false, false, false], "خ"],
	[format ["%1-%2-%3-%4", DIK_O, true, false, false], "×"],
	[format ["%1-%2-%3-%4", DIK_P, false, false, false], "ح"],
	[format ["%1-%2-%3-%4", DIK_P, true, false, false], "؛"],
	[format ["%1-%2-%3-%4", DIK_LBRACKET, false, false, false], "ج"],
	[format ["%1-%2-%3-%4", DIK_LBRACKET, true, false, false], "<"],
	[format ["%1-%2-%3-%4", DIK_RBRACKET, false, false, false], "د"],
	[format ["%1-%2-%3-%4", DIK_RBRACKET, true, false, false], ">"],
	[format ["%1-%2-%3-%4", DIK_A, false, false, false], "ش"],
	[format ["%1-%2-%3-%4", DIK_A, true, false, false], "ِ"],
	[format ["%1-%2-%3-%4", DIK_S, false, false, false], "س"],
	[format ["%1-%2-%3-%4", DIK_S, true, false, false], "ٍ"],
	[format ["%1-%2-%3-%4", DIK_D, false, false, false], "ي"],
	[format ["%1-%2-%3-%4", DIK_D, true, false, false], "]"],
	[format ["%1-%2-%3-%4", DIK_F, false, false, false], "ب"],
	[format ["%1-%2-%3-%4", DIK_F, true, false, false], "["],
	[format ["%1-%2-%3-%4", DIK_G, false, false, false], "ل"],
	[format ["%1-%2-%3-%4", DIK_G, true, false, false], "لأ"],
	[format ["%1-%2-%3-%4", DIK_H, false, false, false], "ا"],
	[format ["%1-%2-%3-%4", DIK_H, true, false, false], "أ"],
	[format ["%1-%2-%3-%4", DIK_J, false, false, false], "ت"],
	[format ["%1-%2-%3-%4", DIK_J, true, false, false], "ـ"],
	[format ["%1-%2-%3-%4", DIK_K, false, false, false], "ن"],
	[format ["%1-%2-%3-%4", DIK_K, true, false, false], "،"],
	[format ["%1-%2-%3-%4", DIK_L, false, false, false], "م"],
	[format ["%1-%2-%3-%4", DIK_L, true, false, false], "/"],
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, false, false, false], "ك"],
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, true, false, false], ":"],
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, false, false, false], "ط"],
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, true, false, false], """"],
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, false, false, false], "\"],
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, true, false, false], "|"],
	[format ["%1-%2-%3-%4", DIK_Z, false, false, false], "ئ"],
	[format ["%1-%2-%3-%4", DIK_Z, true, false, false], "~"],
	[format ["%1-%2-%3-%4", DIK_X, false, false, false], "ء"],
	[format ["%1-%2-%3-%4", DIK_X, true, false, false], "ْ"],
	[format ["%1-%2-%3-%4", DIK_C, false, false, false], "ؤ"],
	[format ["%1-%2-%3-%4", DIK_C, true, false, false], "}"],
	[format ["%1-%2-%3-%4", DIK_V, false, false, false], "ر"],
	[format ["%1-%2-%3-%4", DIK_V, true, false, false], "{"],
	[format ["%1-%2-%3-%4", DIK_B, false, false, false], "لا"],
	[format ["%1-%2-%3-%4", DIK_B, true, false, false], "لآ"],
	[format ["%1-%2-%3-%4", DIK_N, false, false, false], "ى"],
	[format ["%1-%2-%3-%4", DIK_N, true, false, false], "آ"],
	[format ["%1-%2-%3-%4", DIK_M, false, false, false], "ة"],
	[format ["%1-%2-%3-%4", DIK_M, true, false, false], "'"],
	[format ["%1-%2-%3-%4", DIK_COMMA, false, false, false], "و"],
	[format ["%1-%2-%3-%4", DIK_COMMA, true, false, false], ","],
	[format ["%1-%2-%3-%4", DIK_PERIOD, false, false, false], "ز"],
	[format ["%1-%2-%3-%4", DIK_PERIOD, true, false, false], "."],
	[format ["%1-%2-%3-%4", DIK_SLASH, false, false, false], "ظ"],
	[format ["%1-%2-%3-%4", DIK_SLASH, true, false, false], "؟"],
	[format ["%1-%2-%3-%4", DIK_GRAVE, false, false, false], "ذ"],
	[format ["%1-%2-%3-%4", DIK_GRAVE, true, false, false], "ّ"],
	// Numbers and symbols (Arabic-Indic numerals for base, Western for shift)
	[format ["%1-%2-%3-%4", DIK_1, false, false, false], "1"],
	[format ["%1-%2-%3-%4", DIK_1, true, false, false], "!"],
	[format ["%1-%2-%3-%4", DIK_2, false, false, false], "2"],
	[format ["%1-%2-%3-%4", DIK_2, true, false, false], "@"],
	[format ["%1-%2-%3-%4", DIK_3, false, false, false], "3"],
	[format ["%1-%2-%3-%4", DIK_3, true, false, false], "#"],
	[format ["%1-%2-%3-%4", DIK_4, false, false, false], "4"],
	[format ["%1-%2-%3-%4", DIK_4, true, false, false], "$"],
	[format ["%1-%2-%3-%4", DIK_5, false, false, false], "5"],
	[format ["%1-%2-%3-%4", DIK_5, true, false, false], "%"],
	[format ["%1-%2-%3-%4", DIK_6, false, false, false], "6"],
	[format ["%1-%2-%3-%4", DIK_6, true, false, false], "^"],
	[format ["%1-%2-%3-%4", DIK_7, false, false, false], "7"],
	[format ["%1-%2-%3-%4", DIK_7, true, false, false], "&"],
	[format ["%1-%2-%3-%4", DIK_8, false, false, false], "8"],
	[format ["%1-%2-%3-%4", DIK_8, true, false, false], "*"],
	[format ["%1-%2-%3-%4", DIK_9, false, false, false], "9"],
	[format ["%1-%2-%3-%4", DIK_9, true, false, false], "("],
	[format ["%1-%2-%3-%4", DIK_0, false, false, false], "0"],
	[format ["%1-%2-%3-%4", DIK_0, true, false, false], ")"],
	[format ["%1-%2-%3-%4", DIK_MINUS, false, false, false], "-"],
	[format ["%1-%2-%3-%4", DIK_MINUS, true, false, false], "_"],
	[format ["%1-%2-%3-%4", DIK_EQUALS, false, false, false], "="],
	[format ["%1-%2-%3-%4", DIK_EQUALS, true, false, false], "+"],
	// Space
	[format ["%1-%2-%3-%4", DIK_SPACE, false, false, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, true, false, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, false, true, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, false, false, true], " "],
	// Numpad
	[format ["%1-%2-%3-%4", DIK_NUMPAD0, false, false, false], "0"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD1, false, false, false], "1"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD2, false, false, false], "2"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD3, false, false, false], "3"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD4, false, false, false], "4"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD5, false, false, false], "5"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD6, false, false, false], "6"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD7, false, false, false], "7"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD8, false, false, false], "8"],
	[format ["%1-%2-%3-%4", DIK_NUMPAD9, false, false, false], "9"],
	[format ["%1-%2-%3-%4", DIK_MULTIPLY, false, false, false], "*"],
	[format ["%1-%2-%3-%4", DIK_NUMPADSLASH, false, false, false], "/"],
	[format ["%1-%2-%3-%4", DIK_ADD, false, false, false], "+"],
	[format ["%1-%2-%3-%4", DIK_SUBTRACT, false, false, false], "-"],
	[format ["%1-%2-%3-%4", DIK_DECIMAL, false, false, false], "."]
];

_allowedKeys
