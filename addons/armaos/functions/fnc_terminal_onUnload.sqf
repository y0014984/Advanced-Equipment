// File: fnc_terminal_onUnload.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Unload handler for the terminal dialog: releases the mutex, removes the
 * per-frame handlers and syncs the serializable terminal state back to the server.
 *
 * Arguments:
 * 0: _display <DISPLAY> - The terminal dialog being closed
 * 1: _exitCode <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * _consoleDialog displayAddEventHandler ["Unload", { _this call AE3_armaos_fnc_terminal_onUnload }];
 *
 * Public: No
 */

params ["_display", "_exitCode"];

private _computer = _display getVariable ["AE3_computer", objNull];
if (isNull _computer) exitWith {};

// When the terminal is hosted inside the (native) desktop, an AE3_desktop_session is active and that
// desktop owns the laptop lock and manages the screen (lock texture while open, idle image on its own
// unload). In that case this handler must NOT release the mutex or reset the screen, or it would drop
// the lock and clobber the desktop while the desktop is still open.
private _inDesktop = !isNull ((uiNamespace getVariable ["AE3_desktop_session", createHashMap]) getOrDefault ["display", displayNull]);

// Remove the per-frame handlers if they were installed. When the terminal is closed before startup
// finishes wiring them up they are absent, so guard against the missing handle.
private _handleUpdateBatteryStatus = _display getVariable ["AE3_handleUpdateBatteryStatus", -1];
if (_handleUpdateBatteryStatus isNotEqualTo -1) then { [_handleUpdateBatteryStatus] call CBA_fnc_removePerFrameHandler; };

/* ------------- UI on Texture ------------ */

private _handleUpdateUiOnTexture = _display getVariable ["AE3_handleUpdateUiOnTexture", -1];
if (_handleUpdateUiOnTexture isNotEqualTo -1) then { [_handleUpdateUiOnTexture] call CBA_fnc_removePerFrameHandler; };

/* ---------------------------------------- */

// The session-local terminal state only exists once startup populated it. When the terminal was closed
// before it was set up there is nothing to tear down or persist, so skip the SSH end and state sync.
private _terminal = _computer getVariable ["AE3_terminal", nil];
if (!isNil "_terminal") then {
	// End an active SSH session (releases the remote mutex and pushes the remote filesystem)
	[_computer] call AE3_armaos_fnc_shell_sshEnd;

	// A session elevated through su drops back to the account it was logged in as. The terminal resumes
	// where it was left for whoever opens it next, so an elevated shell must not be part of what is
	// persisted.
	private _suStack = _terminal getOrDefault ["AE3_terminalSuStack", []];
	if (_suStack isNotEqualTo []) then {
		private _originalUser = _suStack select 0;
		_terminal set ["AE3_terminalLoginUser", _originalUser];
		_computer setVariable ["AE3_filepointer", [_originalUser] call AE3_armaos_fnc_shell_getHomeDir];
		[_computer] call AE3_armaos_fnc_terminal_updatePromptPointer;
	};
	_terminal deleteAt "AE3_terminalSuStack";

	// Extract only essential data for network sync (avoid HashMap serialization)
	private _terminalSyncData = [
		_terminal get "AE3_terminalBuffer",
		_terminal get "AE3_terminalApplication",
		_terminal get "AE3_terminalPrompt",
		_terminal get "AE3_terminalScrollPosition",
		_terminal get "AE3_terminalLoginUser",
		_terminal get "AE3_terminalCommandHistory"
	];
	_computer setVariable ["AE3_terminal_sync", _terminalSyncData, [clientOwner, 2]];

	private _filepointer = _computer getVariable "AE3_filepointer";
	_computer setVariable ["AE3_filepointer", _filepointer, [clientOwner, 2]];
};

// Standalone terminal: restore the idle screen and release the laptop. Inside the desktop the desktop
// keeps ownership and cleans up on its own unload.
if (!_inDesktop) then {
	[_computer, "\z\ae3\addons\armaos\textures\Laptop_4_to_3_On.paa"] call AE3_armaos_fnc_computer_release;
	// The session is over, so the watchers that pull a user out of a laptop they can no longer be at
	// (death, unconsciousness, respawn) have nothing left to guard.
	missionNamespace setVariable ["AE3_computer_session", objNull];
};
