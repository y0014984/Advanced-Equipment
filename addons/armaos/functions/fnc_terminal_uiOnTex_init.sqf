/**
 * Initializes the texture on the given object for the "UI on texture" feature. 
 *
 * Arguments:
 * 1: Computer <OBJECT>
 *
 * Results:
 * None
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

_computer setObjectTexture [1, "#(rgb,1024,1024,1)ui('AE3_ArmaOS_Main_Dialog','AE3_UiOnTexture')"];

_computer setVariable ["AE3_UiOnTexActive", true]; // local variable on computer object is sufficient

