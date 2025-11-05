/**
 * Adjusts an animatable aspect of an object.
 *
 * Argmuments:
 * 0: Equipment <OBJECT>
 * 1: Animatable Aspect <STRING>
 * 2: min. Value for Animation <NUMBER>
 * 3: max. Value for Animation <NUMBER>
 * 4: Mouse scroll value <NUMBER>
 * 5: Multiplayer to adjust scroll value <NUMBER>
 *
 * Returns:
 * None
 *
 */

params ["_equipment", "_animateItem", "_min", "_max", "_scroll", "_multiplier"];

private _animateValue = _equipment getVariable [_animateItem, 0];

private _newAnimateValue = _animateValue + (_scroll * _multiplier);

if (_newAnimateValue < _min) then { _newAnimateValue = _min; };
if (_newAnimateValue > _max) then { _newAnimateValue = _max; };

_equipment animateSource [_animateItem, _newAnimateValue, true];

_equipment setVariable [_animateItem, _newAnimateValue];
