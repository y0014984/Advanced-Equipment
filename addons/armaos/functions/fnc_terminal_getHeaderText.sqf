/**
 * Creates and returns the terminal header information lines as a string array.
 *
 * Arguments:
 * None
 *
 * Results:
 * Header Lines <[STRING]>
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
		"############# 00       ############# ",
		"############# 0  00    ############# ",
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
