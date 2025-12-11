/*
 * Author: Root
 * Description: Calculates and returns the world-space normal vectors for a dual solar panel system. Uses panel yaw and pitch angles stored in object variables to compute 3D orientation vectors. Used for solar efficiency calculations based on sun position.
 *
 * Arguments:
 * 0: _solar <OBJECT> - Solar panel object
 *
 * Return Value:
 * [Panel 1 normal vector, Panel 2 normal vector] <ARRAY>
 *
 * Example:
 * private _normals = [_solarPanel] call AE3_power_fnc_multSolarPanelOrientation;
 *
 * Public: No
 */

params['_solar'];

private _jaw = _solar getVariable ['Panels_Yaw', 0];
private _pitch_1 = -((_solar getVariable ['Panel_1_Pitch', 0]) - 45);
private _pitch_2 = -((_solar getVariable ['Panel_2_Pitch', 0]) - 45);

private _panelVec_1 = [sin _pitch_1 * cos _jaw, sin _pitch_1 * sin _jaw, cos _pitch_1];
private _panelVec_2 = [sin _pitch_2 * cos _jaw, sin _pitch_2 * sin _jaw, cos _pitch_2];

[_solar vectorModelToWorld _panelVec_1, _solar vectorModelToWorld _panelVec_2];
