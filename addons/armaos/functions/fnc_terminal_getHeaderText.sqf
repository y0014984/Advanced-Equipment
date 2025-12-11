/*
 * Author: Root, Wasserstoff, y0014984
 * Description: Returns the terminal header text (ASCII art logo) for the current terminal design.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [TODO] call AE3_armaos_fnc_terminal_getHeaderText;
 *
 * Public: No
 */

// Build header array using CBA settings
_result = [
	AE3_TerminalBiosVersion,
	AE3_TerminalCopyright,
	AE3_TerminalBootMessage,
	AE3_TerminalTipMessage,
	" "
];

// Add ASCII art if enabled
if (AE3_TerminalShowAsciiArt) then {
	_result append [
		"  #######    ##              ####### ",
		"#########   ####    Root     ####### ",
		"#########   ####  y0014984   ####### ",
		"#########   #### Wasserstoff ####### ",
		"#########   #### JulesVerner ####### ",
		"#########   ####             ####### ",
		"#################################### ",
		"#################################### ",
		"##############       ############### ",
		"############# $#       ############# ",
		"############# !  73    ############# ",
		"#############         ############## ",
		"###############      ############### ",
		"#################################### ",
		"#################################### ",
		"#  ################################# ",
		"#################################### ",
		" ",
		AE3_TerminalTagline,
		" "
	];
};

_result
