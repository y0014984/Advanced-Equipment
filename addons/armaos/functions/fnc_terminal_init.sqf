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

if (!dialog) then
{
	private _ok = createDialog "AE3_ArmaOS_Main_Dialog";
	if (!_ok) then {hint localize "STR_AE3_ArmaOS_Exception_DialogFailed"};
};

private _consoleDialog = findDisplay 15984;
private _consoleOutput = _consoleDialog displayCtrl 1100;
private _languageButton = _consoleDialog displayCtrl 1310;
private _designButton = _consoleDialog displayCtrl 1320;
private _titleControl = _consoleDialog displayCtrl 1000;

// Set dialog title from CBA setting
_titleControl ctrlSetText AE3_TerminalDialogTitle;

[_computer, "AE3_filesystem"] call AE3_main_fnc_getRemoteVar;
[_computer, "AE3_filepointer"] call AE3_main_fnc_getRemoteVar;

private _pointer = [];
if (isNil { _computer getVariable "AE3_filepointer" }) then 
{
	_computer setVariable ["AE3_filepointer", _pointer, [clientOwner, 2]];
};
_pointer = _computer getVariable "AE3_filepointer";

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

// Only nessecary to allow Event Handlers the access to _computer
_consoleOutput setVariable ["AE3_computer", _computer];
_consoleDialog setVariable ["AE3_computer", _computer];

// Restore terminal state from sync data if available (from previous session)
[_computer, "AE3_terminal_sync"] call AE3_main_fnc_getRemoteVar;
private _terminalSyncData = _computer getVariable ["AE3_terminal_sync", nil];
if (!isNil "_terminalSyncData") then {
	_terminal set ["AE3_terminalBuffer", _terminalSyncData select 0];
	_terminal set ["AE3_terminalApplication", _terminalSyncData select 1];
	_terminal set ["AE3_terminalPrompt", _terminalSyncData select 2];
	_terminal set ["AE3_terminalScrollPosition", _terminalSyncData select 3];
	_terminal set ["AE3_terminalLoginUser", _terminalSyncData select 4];

	// Reconstruct rendered buffer from raw buffer to preserve terminal content
	private _restoredBuffer = _terminalSyncData select 0;
	private _renderedBuffer = [];
	{
		_renderedBuffer pushBack ([_computer, _x] call AE3_armaos_fnc_terminal_renderLine);
	} forEach _restoredBuffer;
	_terminal set ["AE3_terminalRenderedBuffer", _renderedBuffer];
};

// Keep terminal local to client (no network sync of HashMap)
_computer setVariable ["AE3_terminal", _terminal];

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

private _handleUpdateBatteryStatus = [_computer, _consoleDialog] call AE3_armaos_fnc_terminal_updateBatteryStatus;
_consoleDialog setVariable ["AE3_handleUpdateBatteryStatus", _handleUpdateBatteryStatus];

/* ------------- UI on Texture ------------ */

private _handleUpdateUiOnTexture = [_computer, _consoleDialog] call AE3_armaos_fnc_terminal_uiOnTex_addUpdateAllEventHandler;
_consoleDialog setVariable ["AE3_handleUpdateUiOnTexture", _handleUpdateUiOnTexture];

/* ---------------------------------------- */

[_consoleDialog, _consoleOutput, _languageButton, _designButton] call AE3_armaos_fnc_terminal_addEventHandler;

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

[_computer, _consoleOutput] call AE3_armaos_fnc_terminal_updateOutput;

_computer setVariable ["AE3_terminal", _terminal];

[_computer, "inUse", true] remoteExecCall ["AE3_interaction_fnc_manageAce3Interactions", 2];
