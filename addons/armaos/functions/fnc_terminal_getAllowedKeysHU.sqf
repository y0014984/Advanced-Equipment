/*
 * Author: Root
 * Description: Returns the allowed keyboard key mappings for Hungarian (HU) layout.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [TODO] call AE3_armaos_fnc_terminal_getAllowedKeysHU;
 *
 * Public: No
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

// Hungarian (QWERTZ) keyboard layout
// order: _shift, _ctrl, _alt

private _allowedKeys = createHashMapFromArray
[
	[format ["%1-%2-%3-%4", DIK_A, false, false, false], "a"],
	[format ["%1-%2-%3-%4", DIK_A, true, false, false], "A"],
	[format ["%1-%2-%3-%4", DIK_B, false, false, false], "b"],
	[format ["%1-%2-%3-%4", DIK_B, true, false, false], "B"],
	[format ["%1-%2-%3-%4", DIK_C, false, false, false], "c"],
	[format ["%1-%2-%3-%4", DIK_C, true, false, false], "C"],
	[format ["%1-%2-%3-%4", DIK_C, false, false, true], "&"],
	[format ["%1-%2-%3-%4", DIK_D, false, false, false], "d"],
	[format ["%1-%2-%3-%4", DIK_D, true, false, false], "D"],
	[format ["%1-%2-%3-%4", DIK_E, false, false, false], "e"],
	[format ["%1-%2-%3-%4", DIK_E, true, false, false], "E"],
	[format ["%1-%2-%3-%4", DIK_E, false, false, true], "€"],
	[format ["%1-%2-%3-%4", DIK_F, false, false, false], "f"],
	[format ["%1-%2-%3-%4", DIK_F, true, false, false], "F"],
	[format ["%1-%2-%3-%4", DIK_F, false, false, true], "["],
	[format ["%1-%2-%3-%4", DIK_G, false, false, false], "g"],
	[format ["%1-%2-%3-%4", DIK_G, true, false, false], "G"],
	[format ["%1-%2-%3-%4", DIK_G, false, false, true], "]"],
	[format ["%1-%2-%3-%4", DIK_H, false, false, false], "h"],
	[format ["%1-%2-%3-%4", DIK_H, true, false, false], "H"],
	[format ["%1-%2-%3-%4", DIK_I, false, false, false], "i"],
	[format ["%1-%2-%3-%4", DIK_I, true, false, false], "I"],
	[format ["%1-%2-%3-%4", DIK_I, false, false, true], "í"],
	[format ["%1-%2-%3-%4", DIK_J, false, false, false], "j"],
	[format ["%1-%2-%3-%4", DIK_J, true, false, false], "J"],
	[format ["%1-%2-%3-%4", DIK_K, false, false, false], "k"],
	[format ["%1-%2-%3-%4", DIK_K, true, false, false], "K"],
	[format ["%1-%2-%3-%4", DIK_L, false, false, false], "l"],
	[format ["%1-%2-%3-%4", DIK_L, true, false, false], "L"],
	[format ["%1-%2-%3-%4", DIK_M, false, false, false], "m"],
	[format ["%1-%2-%3-%4", DIK_M, true, false, false], "M"],
	[format ["%1-%2-%3-%4", DIK_N, false, false, false], "n"],
	[format ["%1-%2-%3-%4", DIK_N, true, false, false], "N"],
	[format ["%1-%2-%3-%4", DIK_N, false, false, true], "}"],
	[format ["%1-%2-%3-%4", DIK_O, false, false, false], "o"],
	[format ["%1-%2-%3-%4", DIK_O, true, false, false], "O"],
	[format ["%1-%2-%3-%4", DIK_P, false, false, false], "p"],
	[format ["%1-%2-%3-%4", DIK_P, true, false, false], "P"],
	[format ["%1-%2-%3-%4", DIK_Q, false, false, false], "q"],
	[format ["%1-%2-%3-%4", DIK_Q, true, false, false], "Q"],
	[format ["%1-%2-%3-%4", DIK_Q, false, false, true], "\"],
	[format ["%1-%2-%3-%4", DIK_R, false, false, false], "r"],
	[format ["%1-%2-%3-%4", DIK_R, true, false, false], "R"],
	[format ["%1-%2-%3-%4", DIK_S, false, false, false], "s"],
	[format ["%1-%2-%3-%4", DIK_S, true, false, false], "S"],
	[format ["%1-%2-%3-%4", DIK_T, false, false, false], "t"],
	[format ["%1-%2-%3-%4", DIK_T, true, false, false], "T"],
	[format ["%1-%2-%3-%4", DIK_U, false, false, false], "u"],
	[format ["%1-%2-%3-%4", DIK_U, true, false, false], "U"],
	[format ["%1-%2-%3-%4", DIK_V, false, false, false], "v"],
	[format ["%1-%2-%3-%4", DIK_V, true, false, false], "V"],
	[format ["%1-%2-%3-%4", DIK_V, false, false, true], "@"],
	[format ["%1-%2-%3-%4", DIK_W, false, false, false], "w"],
	[format ["%1-%2-%3-%4", DIK_W, true, false, false], "W"],
	[format ["%1-%2-%3-%4", DIK_W, false, false, true], "|"],
	[format ["%1-%2-%3-%4", DIK_X, false, false, false], "x"],
	[format ["%1-%2-%3-%4", DIK_X, true, false, false], "X"],
	[format ["%1-%2-%3-%4", DIK_X, false, false, true], "#"],
	// Note: Y and Z are swapped in Hungarian QWERTZ layout
	[format ["%1-%2-%3-%4", DIK_Y, false, false, false], "z"],
	[format ["%1-%2-%3-%4", DIK_Y, true, false, false], "Z"],
	[format ["%1-%2-%3-%4", DIK_Z, false, false, false], "y"],
	[format ["%1-%2-%3-%4", DIK_Z, true, false, false], "Y"],
	[format ["%1-%2-%3-%4", DIK_Z, false, false, true], ">"],
	// Numbers and symbols
	[format ["%1-%2-%3-%4", DIK_1, false, false, false], "1"],
	[format ["%1-%2-%3-%4", DIK_1, true, false, false], "'"],
	[format ["%1-%2-%3-%4", DIK_1, false, false, true], "~"],
	[format ["%1-%2-%3-%4", DIK_2, false, false, false], "2"],
	[format ["%1-%2-%3-%4", DIK_2, true, false, false], """"],
	[format ["%1-%2-%3-%4", DIK_3, false, false, false], "3"],
	[format ["%1-%2-%3-%4", DIK_3, true, false, false], "+"],
	[format ["%1-%2-%3-%4", DIK_3, false, false, true], "^"],
	[format ["%1-%2-%3-%4", DIK_4, false, false, false], "4"],
	[format ["%1-%2-%3-%4", DIK_4, true, false, false], "!"],
	[format ["%1-%2-%3-%4", DIK_4, false, false, true], "¢"],
	[format ["%1-%2-%3-%4", DIK_5, false, false, false], "5"],
	[format ["%1-%2-%3-%4", DIK_5, true, false, false], "%"],
	[format ["%1-%2-%3-%4", DIK_6, false, false, false], "6"],
	[format ["%1-%2-%3-%4", DIK_6, true, false, false], "/"],
	[format ["%1-%2-%3-%4", DIK_7, false, false, false], "7"],
	[format ["%1-%2-%3-%4", DIK_7, true, false, false], "="],
	[format ["%1-%2-%3-%4", DIK_7, false, false, true], "`"],
	[format ["%1-%2-%3-%4", DIK_8, false, false, false], "8"],
	[format ["%1-%2-%3-%4", DIK_8, true, false, false], "("],
	[format ["%1-%2-%3-%4", DIK_9, false, false, false], "9"],
	[format ["%1-%2-%3-%4", DIK_9, true, false, false], ")"],
	[format ["%1-%2-%3-%4", DIK_0, false, false, false], "ö"],
	[format ["%1-%2-%3-%4", DIK_0, true, false, false], "Ö"],
	// Space
	[format ["%1-%2-%3-%4", DIK_SPACE, false, false, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, true, false, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, false, true, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, false, false, true], " "],
	// Hungarian specific characters
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, false, false, false], "é"],
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, true, false, false], "É"],
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, false, false, true], "$"],
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, false, false, false], "á"],
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, true, false, false], "Á"],
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, false, false, true], "<"],
	[format ["%1-%2-%3-%4", DIK_LBRACKET, false, false, false], "ő"],
	[format ["%1-%2-%3-%4", DIK_LBRACKET, true, false, false], "Ő"],
	[format ["%1-%2-%3-%4", DIK_LBRACKET, false, false, true], "÷"],
	[format ["%1-%2-%3-%4", DIK_RBRACKET, false, false, false], "ú"],
	[format ["%1-%2-%3-%4", DIK_RBRACKET, true, false, false], "Ú"],
	[format ["%1-%2-%3-%4", DIK_RBRACKET, false, false, true], "×"],
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, false, false, false], "ű"],
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, true, false, false], "Ű"],
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, false, false, true], "¤"],
	// Other symbols
	[format ["%1-%2-%3-%4", DIK_MINUS, false, false, false], "ü"],
	[format ["%1-%2-%3-%4", DIK_MINUS, true, false, false], "Ü"],
	[format ["%1-%2-%3-%4", DIK_EQUALS, false, false, false], "ó"],
	[format ["%1-%2-%3-%4", DIK_EQUALS, true, false, false], "Ó"],
	[format ["%1-%2-%3-%4", DIK_COMMA, false, false, false], ","],
	[format ["%1-%2-%3-%4", DIK_COMMA, true, false, false], "?"],
	[format ["%1-%2-%3-%4", DIK_COMMA, false, false, true], ";"],
	[format ["%1-%2-%3-%4", DIK_PERIOD, false, false, false], "."],
	[format ["%1-%2-%3-%4", DIK_PERIOD, true, false, false], ":"],
	[format ["%1-%2-%3-%4", DIK_SLASH, false, false, false], "-"],
	[format ["%1-%2-%3-%4", DIK_SLASH, true, false, false], "_"],
	[format ["%1-%2-%3-%4", DIK_SLASH, false, false, true], "*"],
	[format ["%1-%2-%3-%4", DIK_GRAVE, false, false, false], "0"],
	[format ["%1-%2-%3-%4", DIK_GRAVE, true, false, false], "§"],
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
