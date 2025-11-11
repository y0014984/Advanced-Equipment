/*
 * Author: Root
 * Description: Adjusts an animatable aspect of an object based on mouse scroll input. Applies min/max clamping
 * and a scroll multiplier to control animation speed. Used by animateInteraction for interactive equipment.
 *
 * Arguments:
 * 0: _equipment <OBJECT> - The equipment object to animate
 * 1: _animateItem <STRING> - The animation source name
 * 2: _min <NUMBER> - Minimum animation value
 * 3: _max <NUMBER> - Maximum animation value
 * 4: _scroll <NUMBER> - Mouse scroll value
 * 5: _multiplier <NUMBER> - Multiplier to adjust scroll sensitivity
 *
 * Return Value:
 * None
 *
 * Example:
 * [_laptop, "Screen_Angle", 0, 1, 0.1, 0.05] call AE3_interaction_fnc_animateAction;
 *
 * Public: No
 */

params ["_equipment", "_animateItem", "_min", "_max", "_scroll", "_multiplier"];

private _animateValue = _equipment getVariable [_animateItem, 0];

private _newAnimateValue = _animateValue + (_scroll * _multiplier);

if (_newAnimateValue < _min) then { _newAnimateValue = _min; };
if (_newAnimateValue > _max) then { _newAnimateValue = _max; };

_equipment animateSource [_animateItem, _newAnimateValue, true];

_equipment setVariable [_animateItem, _newAnimateValue];
