/*
 * Author: Root
 * Description: Initializes UI-on-Texture rendering for a computer object. Creates a workaround display to preload images and sets the object texture to use the UI render target.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer] call AE3_armaos_fnc_terminal_uiOnTex_init;
 *
 * Public: No
 */

params ["_computer"];

/* -------------- WORKAROUND -------------- */

// Workaround: We need to preload the UI, so the used images are also preloaded; otherwise the
// images creates a "Cannot load mipmap" error on first usage with the UI2Texture feature
// See these tickets:
// https://feedback.bistudio.com/T171035
// https://feedback.bistudio.com/T170766

private _tmpDisplay = findDisplay 46 createDisplay "AE3_ArmaOS_Main_Dialog";
_tmpDisplay closeDisplay 1;

/* ---------------------------------------- */

// Generate unique display name for this computer using its network ID
private _computerNetId = netId _computer;
private _uniqueDisplayName = format ["AE3_UiOnTexture_%1", _computerNetId];

// Store the unique display name on the computer object for later reference
_computer setVariable ["AE3_UiOnTexDisplayName", _uniqueDisplayName, true];

// Set texture using the unique display name
_computer setObjectTexture [1, format ["#(rgb,1024,1024,1)ui('AE3_ArmaOS_Main_Dialog','%1')", _uniqueDisplayName]];

_computer setVariable ["AE3_UiOnTexActive", true]; // local variable on computer object is sufficient

