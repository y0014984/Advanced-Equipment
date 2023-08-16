/**
 * Initializes the terminal of a given computer by showing the terminal window, initializing terminal settings and adding event handlers.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
 */

#include "\a3\ui_f\hpp\definedikcodes.inc"

params ["_computer"];

[_computer, "inUse", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];

/* ---------------------------------------- */

// Bugfix: All getRemoteVar calls should be done before the dialog is created
// otherwise the dialog is open, not showing anything (depending on how long the server needs for an answer)
// if, in this case, the user closes the dialog, then the laptop becomes inaccessable,
// because the mutex variable is not removed in this case, because the event handler to remove it
// on closing the dialog can't be created because of missing dialog variables

hint "Please be patient while the computer initializes ...";

/* ---------------------------------------- */

[_computer, "AE3_filesystem"] call AE3_main_fnc_getRemoteVar;
[_computer, "AE3_filepointer"] call AE3_main_fnc_getRemoteVar;
[_computer, "AE3_terminal"] call AE3_main_fnc_getRemoteVar;

/* ---------------------------------------- */

private _pointer = [];

if (isNil { _computer getVariable "AE3_filepointer" }) then 
{
	_computer setVariable ["AE3_filepointer", _pointer, [clientOwner, 2]];
};
_pointer = _computer getVariable "AE3_filepointer";

/* ---------------------------------------- */

private _terminal = createHashMapFromArray
	[
		["AE3_terminalBuffer", []],
		["AE3_terminalRenderedBuffer", []],
		["AE3_terminalBufferVisible", []],
		["AE3_terminalScrollPosition", 0],
		["AE3_terminalCursorLine", 0],
		["AE3_terminalCursorPosition", 0],
		["AE3_terminalCommandHistory", createHashMap],
		["AE3_terminalCommandHistoryIndex", -1],
		["AE3_terminalComputer", _computer],
		["AE3_terminalPrompt", "/>"],
		["AE3_terminalApplication", "LOGIN"],
		["AE3_terminalSize", 0.75],
		["AE3_terminalMaxRows", 26],
		["AE3_terminalMaxColumns", 80]
	];

if (isNil { _computer getVariable "AE3_terminal" }) then 
{
	_computer setVariable ["AE3_terminal", _terminal, [clientOwner, 2]];
};
_terminal = _computer getVariable "AE3_terminal";

/* ---------------------------------------- */

private _consoleDialog = createDialog ["AE3_ArmaOS_Main_Dialog", true];

private _consoleOutput = _consoleDialog displayCtrl 1100;
private _languageButton = _consoleDialog displayCtrl 1310;
private _designButton = _consoleDialog displayCtrl 1320;

// Only nessecary to allow Event Handlers the access to _computer
_consoleOutput setVariable ["AE3_computer", _computer];
_consoleDialog setVariable ["AE3_computer", _computer];

[_consoleDialog, _consoleOutput, _languageButton, _designButton] call AE3_armaos_fnc_terminal_addEventHandler;

_terminal set ["AE3_terminalOutput", _consoleOutput];

private _localGameLanguage = language;
// we can determine the language of arma 3 but not the language of the keyboard layout
// if the language is german, it's obvious, that the keyboard layout is also german (this is not the case, if game language is english)
// perhaps we need to provide a CBA setting for changing keyboard layout or allow to change the layout directly in the terminal window

/* ---------------------------------------- */

private _terminalKeyboardLayout = "";

//AE3_KeyboardLayout is a CBA setting
if (!isMultiplayer || (isServer && hasInterface)) then
{
	// In singeplayer or as host in a multiplayer session
	_terminalKeyboardLayout = ["AE3_KeyboardLayout", "server"] call CBA_settings_fnc_get;
}
else
{
	// As client in a multiplayer session
	_terminalKeyboardLayout = ["AE3_KeyboardLayout", "client"] call CBA_settings_fnc_get;
};

// set the keyboard layout on terminal init with layout saved as a CBA setting
[_computer, _languageButton, _consoleOutput, _terminalKeyboardLayout] call AE3_armaos_fnc_terminal_setKeyboardLayout;

/* ---------------------------------------- */

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

// background color header, background color console, font color header, font color console
private _designs =
[
	[[0.125,0.125,0.125,1], [0.2,0.2,0.2,1], [1,1,1,1], [1,1,1,1]], // default armaOS design
	[[0.502,0.459,0.835,1], [0.243,0.192,0.635,1], [0.243,0.192,0.635,1], [0.502,0.459,0.835,1]], // C64 design
	[[0.2,1,0.2,1], [0.157,0.157,0.157,1],[0.157,0.157,0.157,1] , [0.2,1,0.2,1]], // Apple II ( green monochrome)
	[[1,0.69,0,1], [0.157,0.157,0.157,1],[0.157,0.157,0.157,1] , [1,0.69,0,1]] // Amber monochrome
];

_terminal set ["AE3_terminalDesigns", _designs];

private _currentDesign = _designs select _currentDesignIndex;

// set the terminal design on terminal init with design saved as a CBA setting
[_consoleDialog, _currentDesign] call AE3_armaos_fnc_terminal_setTerminalDesign;

/* ---------------------------------------- */

_terminalBuffer = _terminal get "AE3_terminalBuffer";
if (_terminalBuffer isEqualTo []) then
{
	[_computer] call AE3_armaos_fnc_terminal_addHeader;
	
	private _terminalApplication = _terminal get "AE3_terminalApplication";
	if (_terminalApplication == "LOGIN") then
	{
		_terminal set ["AE3_terminalPrompt", "LOGIN>"];
	}
	else 
	{
		[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
	};

	[_computer] call AE3_armaos_fnc_terminal_setPrompt;
};

/* ---------------------------------------- */

// recreate _terminalRenderedBuffer from _terminalBuffer
// because _terminalRenderedBuffer was set to []
// before _terminal was synced to server
[_computer] call AE3_armaos_fnc_terminal_reRenderBuffer;

/* ---------------------------------------- */

[_computer, _consoleOutput] call AE3_armaos_fnc_terminal_updateOutput;

_computer setVariable ["AE3_terminal", _terminal];

/* ---------------------------------------- */

private _handleUpdateBatteryStatus = [_computer, _consoleDialog] call AE3_armaos_fnc_terminal_updateBatteryStatus;
_consoleDialog setVariable ["AE3_handleUpdateBatteryStatus", _handleUpdateBatteryStatus];

/* ------------- UI on Texture ------------ */

private _handleUpdateUiOnTexture = [_computer, _consoleDialog] call AE3_armaos_fnc_terminal_uiOnTex_addUpdateAllEventHandler;
_consoleDialog setVariable ["AE3_handleUpdateUiOnTexture", _handleUpdateUiOnTexture];

/* ---------------------------------------- */

// clear the previously set "be patient" message
hint "";