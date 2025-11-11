/*
 * Author: Root
 * Description: Returns the allowed keyboard key mappings for Russian (RU) layout.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [TODO] call AE3_armaos_fnc_terminal_getAllowedKeysRU;
 *
 * Public: No
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

// Russian (ЙЦУКЕН) keyboard layout
// order: _shift, _ctrl, _alt

private _allowedKeys = createHashMapFromArray
[
	// Russian letters (ЙЦУКЕН layout)
	[format ["%1-%2-%3-%4", DIK_Q, false, false, false], "й"],
	[format ["%1-%2-%3-%4", DIK_Q, true, false, false], "Й"],
	[format ["%1-%2-%3-%4", DIK_W, false, false, false], "ц"],
	[format ["%1-%2-%3-%4", DIK_W, true, false, false], "Ц"],
	[format ["%1-%2-%3-%4", DIK_E, false, false, false], "у"],
	[format ["%1-%2-%3-%4", DIK_E, true, false, false], "У"],
	[format ["%1-%2-%3-%4", DIK_R, false, false, false], "к"],
	[format ["%1-%2-%3-%4", DIK_R, true, false, false], "К"],
	[format ["%1-%2-%3-%4", DIK_T, false, false, false], "е"],
	[format ["%1-%2-%3-%4", DIK_T, true, false, false], "Е"],
	[format ["%1-%2-%3-%4", DIK_Y, false, false, false], "н"],
	[format ["%1-%2-%3-%4", DIK_Y, true, false, false], "Н"],
	[format ["%1-%2-%3-%4", DIK_U, false, false, false], "г"],
	[format ["%1-%2-%3-%4", DIK_U, true, false, false], "Г"],
	[format ["%1-%2-%3-%4", DIK_I, false, false, false], "ш"],
	[format ["%1-%2-%3-%4", DIK_I, true, false, false], "Ш"],
	[format ["%1-%2-%3-%4", DIK_O, false, false, false], "щ"],
	[format ["%1-%2-%3-%4", DIK_O, true, false, false], "Щ"],
	[format ["%1-%2-%3-%4", DIK_P, false, false, false], "з"],
	[format ["%1-%2-%3-%4", DIK_P, true, false, false], "З"],
	[format ["%1-%2-%3-%4", DIK_LBRACKET, false, false, false], "х"],
	[format ["%1-%2-%3-%4", DIK_LBRACKET, true, false, false], "Х"],
	[format ["%1-%2-%3-%4", DIK_RBRACKET, false, false, false], "ъ"],
	[format ["%1-%2-%3-%4", DIK_RBRACKET, true, false, false], "Ъ"],
	[format ["%1-%2-%3-%4", DIK_A, false, false, false], "ф"],
	[format ["%1-%2-%3-%4", DIK_A, true, false, false], "Ф"],
	[format ["%1-%2-%3-%4", DIK_S, false, false, false], "ы"],
	[format ["%1-%2-%3-%4", DIK_S, true, false, false], "Ы"],
	[format ["%1-%2-%3-%4", DIK_D, false, false, false], "в"],
	[format ["%1-%2-%3-%4", DIK_D, true, false, false], "В"],
	[format ["%1-%2-%3-%4", DIK_F, false, false, false], "а"],
	[format ["%1-%2-%3-%4", DIK_F, true, false, false], "А"],
	[format ["%1-%2-%3-%4", DIK_G, false, false, false], "п"],
	[format ["%1-%2-%3-%4", DIK_G, true, false, false], "П"],
	[format ["%1-%2-%3-%4", DIK_H, false, false, false], "р"],
	[format ["%1-%2-%3-%4", DIK_H, true, false, false], "Р"],
	[format ["%1-%2-%3-%4", DIK_J, false, false, false], "о"],
	[format ["%1-%2-%3-%4", DIK_J, true, false, false], "О"],
	[format ["%1-%2-%3-%4", DIK_K, false, false, false], "л"],
	[format ["%1-%2-%3-%4", DIK_K, true, false, false], "Л"],
	[format ["%1-%2-%3-%4", DIK_L, false, false, false], "д"],
	[format ["%1-%2-%3-%4", DIK_L, true, false, false], "Д"],
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, false, false, false], "ж"],
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, true, false, false], "Ж"],
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, false, false, false], "э"],
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, true, false, false], "Э"],
	[format ["%1-%2-%3-%4", DIK_Z, false, false, false], "я"],
	[format ["%1-%2-%3-%4", DIK_Z, true, false, false], "Я"],
	[format ["%1-%2-%3-%4", DIK_X, false, false, false], "ч"],
	[format ["%1-%2-%3-%4", DIK_X, true, false, false], "Ч"],
	[format ["%1-%2-%3-%4", DIK_C, false, false, false], "с"],
	[format ["%1-%2-%3-%4", DIK_C, true, false, false], "С"],
	[format ["%1-%2-%3-%4", DIK_V, false, false, false], "м"],
	[format ["%1-%2-%3-%4", DIK_V, true, false, false], "М"],
	[format ["%1-%2-%3-%4", DIK_B, false, false, false], "и"],
	[format ["%1-%2-%3-%4", DIK_B, true, false, false], "И"],
	[format ["%1-%2-%3-%4", DIK_N, false, false, false], "т"],
	[format ["%1-%2-%3-%4", DIK_N, true, false, false], "Т"],
	[format ["%1-%2-%3-%4", DIK_M, false, false, false], "ь"],
	[format ["%1-%2-%3-%4", DIK_M, true, false, false], "Ь"],
	[format ["%1-%2-%3-%4", DIK_COMMA, false, false, false], "б"],
	[format ["%1-%2-%3-%4", DIK_COMMA, true, false, false], "Б"],
	[format ["%1-%2-%3-%4", DIK_PERIOD, false, false, false], "ю"],
	[format ["%1-%2-%3-%4", DIK_PERIOD, true, false, false], "Ю"],
	[format ["%1-%2-%3-%4", DIK_SLASH, false, false, false], "."],
	[format ["%1-%2-%3-%4", DIK_SLASH, true, false, false], ","],
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, false, false, false], "\"],
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, true, false, false], "/"],
	[format ["%1-%2-%3-%4", DIK_GRAVE, false, false, false], "ё"],
	[format ["%1-%2-%3-%4", DIK_GRAVE, true, false, false], "Ё"],
	// Numbers and symbols
	[format ["%1-%2-%3-%4", DIK_1, false, false, false], "1"],
	[format ["%1-%2-%3-%4", DIK_1, true, false, false], "!"],
	[format ["%1-%2-%3-%4", DIK_2, false, false, false], "2"],
	[format ["%1-%2-%3-%4", DIK_2, true, false, false], """"],
	[format ["%1-%2-%3-%4", DIK_2, false, false, true], "@"],
	[format ["%1-%2-%3-%4", DIK_3, false, false, false], "3"],
	[format ["%1-%2-%3-%4", DIK_3, true, false, false], "№"],
	[format ["%1-%2-%3-%4", DIK_3, false, false, true], "#"],
	[format ["%1-%2-%3-%4", DIK_4, false, false, false], "4"],
	[format ["%1-%2-%3-%4", DIK_4, true, false, false], ";"],
	[format ["%1-%2-%3-%4", DIK_4, false, false, true], "$"],
	[format ["%1-%2-%3-%4", DIK_5, false, false, false], "5"],
	[format ["%1-%2-%3-%4", DIK_5, true, false, false], "%"],
	[format ["%1-%2-%3-%4", DIK_6, false, false, false], "6"],
	[format ["%1-%2-%3-%4", DIK_6, true, false, false], ":"],
	[format ["%1-%2-%3-%4", DIK_7, false, false, false], "7"],
	[format ["%1-%2-%3-%4", DIK_7, true, false, false], "?"],
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
