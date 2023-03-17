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

_computer setObjectTexture [1, "#(rgb,1024,1024,1)ui('AE3_ArmaOS_Main_Dialog','AE3_UiOnTexture')"];

_computer setVariable ["AE3_UiOnTexActive", true]; // local variable on computer object is sufficient