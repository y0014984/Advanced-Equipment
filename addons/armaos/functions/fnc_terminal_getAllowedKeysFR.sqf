/**
 * Creates and returns a hashmap for FR keyboard layout.
 *
 * Arguments:
 * None
 *
 * Results:
 * Keyboard Layout <HASHMAP>
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

// order: _shift, _ctrl, _alt

private _allowedKeys = createHashMapFromArray 
[
	[format ["%1-%2-%3-%4", DIK_A, false, false, false], "q"], // 30
	[format ["%1-%2-%3-%4", DIK_A, true, false, false], "Q"], // 30
	[format ["%1-%2-%3-%4", DIK_B, false, false, false], "b"],
	[format ["%1-%2-%3-%4", DIK_B, true, false, false], "B"],
	[format ["%1-%2-%3-%4", DIK_C, false, false, false], "c"],
	[format ["%1-%2-%3-%4", DIK_C, true, false, false], "C"],
	[format ["%1-%2-%3-%4", DIK_D, false, false, false], "d"],
	[format ["%1-%2-%3-%4", DIK_D, true, false, false], "D"],
	[format ["%1-%2-%3-%4", DIK_E, false, false, false], "e"],
	[format ["%1-%2-%3-%4", DIK_E, true, false, false], "E"],
	[format ["%1-%2-%3-%4", DIK_F, false, false, false], "f"],
	[format ["%1-%2-%3-%4", DIK_F, true, false, false], "F"],
	[format ["%1-%2-%3-%4", DIK_G, false, false, false], "g"],
	[format ["%1-%2-%3-%4", DIK_G, true, false, false], "G"],
	[format ["%1-%2-%3-%4", DIK_H, false, false, false], "h"],
	[format ["%1-%2-%3-%4", DIK_H, true, false, false], "H"],
	[format ["%1-%2-%3-%4", DIK_I, false, false, false], "i"],
	[format ["%1-%2-%3-%4", DIK_I, true, false, false], "I"],
	[format ["%1-%2-%3-%4", DIK_J, false, false, false], "j"],
	[format ["%1-%2-%3-%4", DIK_J, true, false, false], "J"],
	[format ["%1-%2-%3-%4", DIK_K, false, false, false], "k"],
	[format ["%1-%2-%3-%4", DIK_K, true, false, false], "K"],
	[format ["%1-%2-%3-%4", DIK_L, false, false, false], "l"],
	[format ["%1-%2-%3-%4", DIK_L, true, false, false], "L"],
	[format ["%1-%2-%3-%4", DIK_M, false, false, false], ","], // 50
	[format ["%1-%2-%3-%4", DIK_M, true, false, false], "?"], // 50
	[format ["%1-%2-%3-%4", DIK_N, false, false, false], "n"],
	[format ["%1-%2-%3-%4", DIK_N, true, false, false], "N"],
	[format ["%1-%2-%3-%4", DIK_O, false, false, false], "o"],
	[format ["%1-%2-%3-%4", DIK_O, true, false, false], "O"],
	[format ["%1-%2-%3-%4", DIK_P, false, false, false], "p"],
	[format ["%1-%2-%3-%4", DIK_P, true, false, false], "P"],
	[format ["%1-%2-%3-%4", DIK_Q, false, false, false], "a"], // 16
	[format ["%1-%2-%3-%4", DIK_Q, true, false, false], "A"], // 16
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
	[format ["%1-%2-%3-%4", DIK_W, false, false, false], "z"], // 17
	[format ["%1-%2-%3-%4", DIK_W, true, false, false], "Z"], // 17
	[format ["%1-%2-%3-%4", DIK_X, false, false, false], "x"],
	[format ["%1-%2-%3-%4", DIK_X, true, false, false], "X"],
	[format ["%1-%2-%3-%4", DIK_Y, false, false, false], "y"], // 21
	[format ["%1-%2-%3-%4", DIK_Y, true, false, false], "Y"], // 21
	[format ["%1-%2-%3-%4", DIK_Z, false, false, false], "w"], // 44
	[format ["%1-%2-%3-%4", DIK_Z, true, false, false], "W"], // 44
	[format ["%1-%2-%3-%4", DIK_1, false, false, false], "&"],
	[format ["%1-%2-%3-%4", DIK_1, true, false, false], "1"],
	[format ["%1-%2-%3-%4", DIK_2, false, false, false], "é"],
	[format ["%1-%2-%3-%4", DIK_2, true, false, false], "2"],
	[format ["%1-%2-%3-%4", DIK_3, false, false, false], """"],
	[format ["%1-%2-%3-%4", DIK_3, true, false, false], "3"],
	[format ["%1-%2-%3-%4", DIK_4, false, false, false], "'"],
	[format ["%1-%2-%3-%4", DIK_4, true, false, false], "4"],
	[format ["%1-%2-%3-%4", DIK_5, false, false, false], "("],
	[format ["%1-%2-%3-%4", DIK_5, true, false, false], "5"],
	[format ["%1-%2-%3-%4", DIK_6, false, false, false], "-"],
	[format ["%1-%2-%3-%4", DIK_6, true, false, false], "6"], 
	[format ["%1-%2-%3-%4", DIK_7, false, false, false], "è"],
	[format ["%1-%2-%3-%4", DIK_7, true, false, false], "7"],
	[format ["%1-%2-%3-%4", DIK_7, false, false, true], "ò"],
	[format ["%1-%2-%3-%4", DIK_8, false, false, false], "_"],
	[format ["%1-%2-%3-%4", DIK_8, true, false, false], "8"],
	[format ["%1-%2-%3-%4", DIK_8, false, false, true], "\"],
	[format ["%1-%2-%3-%4", DIK_9, false, false, false], "c"], // weird sign
	[format ["%1-%2-%3-%4", DIK_9, true, false, false], "9"],
	[format ["%1-%2-%3-%4", DIK_9, false, false, true], "^"],
	[format ["%1-%2-%3-%4", DIK_0, false, false, false], "à"],
	[format ["%1-%2-%3-%4", DIK_0, true, false, false], "0"],
	[format ["%1-%2-%3-%4", DIK_0, false, false, true], "@"],
	[format ["%1-%2-%3-%4", DIK_SPACE, false, false, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, true, false, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, false, true, false], " "],
	[format ["%1-%2-%3-%4", DIK_SPACE, false, false, true], " "],
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, false, false, false], "m"], // 39
	[format ["%1-%2-%3-%4", DIK_SEMICOLON, true, false, false], "M"], // 39
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, false, false, false], "ù"], // 40
	[format ["%1-%2-%3-%4", DIK_APOSTROPHE, true, false, false], "%"], // 40
	[format ["%1-%2-%3-%4", DIK_LBRACKET, false, false, false], "^"], // 26
	[format ["%1-%2-%3-%4", DIK_LBRACKET, true, false, false], "Ü"], // 26 ???
	[format ["%1-%2-%3-%4", DIK_MINUS, false, false, false], ")"], // 12
	[format ["%1-%2-%3-%4", DIK_MINUS, true, false, false], "°"], // 12
	[format ["%1-%2-%3-%4", DIK_MINUS, false, false, true], "]"], // 12
	[format ["%1-%2-%3-%4", DIK_EQUALS, false, false, false], "="], // 13
	[format ["%1-%2-%3-%4", DIK_EQUALS, true, false, false], "+"], // 13
	[format ["%1-%2-%3-%4", DIK_EQUALS, false, false, true], "}"], // 13
	[format ["%1-%2-%3-%4", DIK_RBRACKET, false, false, false], "$"], // 27
	[format ["%1-%2-%3-%4", DIK_RBRACKET, true, false, false], "£"], // 27
	[format ["%1-%2-%3-%4", DIK_RBRACKET, false, false, true], ""], // 27 - weird sign, looks like a bug
	[format ["%1-%2-%3-%4", DIK_GRAVE, false, false, false], "²"], // 41
	[format ["%1-%2-%3-%4", DIK_GRAVE, true, false, false], ""], // 41 - not assigned
	[format ["%1-%2-%3-%4", DIK_COMMA, false, false, false], ";"], // 51
	[format ["%1-%2-%3-%4", DIK_COMMA, true, false, false], "."], // 51
	[format ["%1-%2-%3-%4", DIK_PERIOD, false, false, false], ":"], // 52
	[format ["%1-%2-%3-%4", DIK_PERIOD, true, false, false], "/"], // 52
	[format ["%1-%2-%3-%4", DIK_SLASH, false, false, false], "!"], // 53
	[format ["%1-%2-%3-%4", DIK_SLASH, true, false, false], "§"], // 53
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, false, false, false], "*"], // 43
	[format ["%1-%2-%3-%4", DIK_BACKSLASH, true, false, false], "µ"], // 43
	[format ["%1-%2-%3-%4", DIK_OEM_102, false, false, false], "<"], // 86
	[format ["%1-%2-%3-%4", DIK_OEM_102, true, false, false], ">"], // 86
	[format ["%1-%2-%3-%4", DIK_OEM_102, false, false, true], ""], // 86 - not assigned
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
	[format ["%1-%2-%3-%4", DIK_DECIMAL, false, false, false], ","]
];

_allowedKeys