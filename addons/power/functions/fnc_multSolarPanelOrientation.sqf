/**
 * Returns the normal vector of both solar panels.
 * 
 * Arguments:
 * 0: Solar panel <OBJECT>
 *
 * Returns:
 * 0: Normal vector of panel 1
 * 1: Normal vector of panel 2
 */

params['_solar'];

private _jaw = _solar getVariable ['Panels_Yaw', 0];
private _pitch_1 = -((_solar getVariable ['Panel_1_Pitch', 0]) - 45);
private _pitch_2 = -((_solar getVariable ['Panel_2_Pitch', 0]) - 45);

private _panelVec_1 = [sin _pitch_1 * cos _jaw, sin _pitch_1 * sin _jaw, cos _pitch_1];
private _panelVec_2 = [sin _pitch_2 * cos _jaw, sin _pitch_2 * sin _jaw, cos _pitch_2];

[_solar vectorModelToWorld _panelVec_1, _solar vectorModelToWorld _panelVec_2];