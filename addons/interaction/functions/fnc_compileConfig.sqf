/**
 * Uses the AE3 Equipment config to compile a hashmap 
 * for the object.
 *
 * Argmuments:
 * 0: Equipment Config <CONFIG>
 * 1: Config <HASHMAP>
 *
 * Returns:
 * None
 *
 */


params["_equipmentCfg", "_config"];

_config set
[
	"equipment",
	[
		getText (_equipmentCfg >> "displayName"),
		getNumber (_equipmentCfg >> "closeState"),
		compile (getText (_equipmentCfg >> "init")),
		compile (getText (_equipmentCfg >> "openAction")),
		compile ([_equipmentCfg, "openActionCondition", "true"] call BIS_fnc_returnConfigEntry),
		compile (getText (_equipmentCfg >> "closeAction")),
		compile ([_equipmentCfg, "closeActionCondition", "true"] call BIS_fnc_returnConfigEntry),
		[_equipmentCfg, "maxDamage", 1] call BIS_fnc_returnConfigEntry,
		compile ([_equipmentCfg, "damagedAction", "true"] call BIS_fnc_returnConfigEntry),
		compile ([_equipmentCfg, "destroyedAction", "true"] call BIS_fnc_returnConfigEntry)
	]
];

/* ---------------------------------------- */

private _animations = (_equipmentCfg >> "AE3_Animations");
if(!isNull _animations) then
{
	private _animationCounter = 0;

	private _animationPoints = [];

	while {!isNull (_animations >> format ["AE3_Animation_Point_%1", _animationCounter])} do
	{
		private _animationPoint = (_animations >> format ["AE3_Animation_Point_%1", _animationCounter]);

		if(!isNull _animationPoint) then
		{
			private _animationPointDescription = getText (_animationPoint >> "description");
			private _animationPointSelection = getText (_animationPoint >> "selection");

			private _animationMain = (_animationPoint >> "AE3_Animation_Main");
			if (!isNull _animationMain) then
			{
				private	_description = getText (_animationMain >> "description");
				private	_animation = getText (_animationMain >> "animation");
				private	_minValue = getNumber (_animationMain >> "minValue");
				private	_maxValue = getNumber (_animationMain >> "maxValue");
				private	_scrollMultiplier = getNumber (_animationMain >> "scrollMultiplier");

				_animationMain = [_description, _animation, _minValue, _maxValue, _scrollMultiplier];
			};

			private _animationModifiedShift = (_animationPoint >> "AE3_Animation_Modified_Shift");
			if (!isNull _animationModifiedShift) then
			{
				private	_description = getText (_animationModifiedShift >> "description");
				private	_animation = getText (_animationModifiedShift >> "animation");
				private	_minValue = getNumber (_animationModifiedShift >> "minValue");
				private	_maxValue = getNumber (_animationModifiedShift >> "maxValue");
				private	_scrollMultiplier = getNumber (_animationModifiedShift >> "scrollMultiplier");

				_animationModifiedShift = [_description, _animation, _minValue, _maxValue, _scrollMultiplier];
			}
			else
			{
				_animationModifiedShift = [];
			};

			private _animationModifiedCtrl = (_animationPoint >> "AE3_Animation_Modified_Ctrl");
			if (!isNull _animationModifiedCtrl) then
			{
				private	_description = getText (_animationModifiedCtrl >> "description");
				private	_animation = getText (_animationModifiedCtrl >> "animation");
				private	_minValue = getNumber (_animationModifiedCtrl >> "minValue");
				private	_maxValue = getNumber (_animationModifiedCtrl >> "maxValue");
				private	_scrollMultiplier = getNumber (_animationModifiedCtrl >> "scrollMultiplier");

				_animationModifiedCtrl = [_description, _animation, _minValue, _maxValue, _scrollMultiplier];
			}
			else
			{
				_animationModifiedCtrl = [];
			};

			private _animationModifiedAlt = (_animationPoint >> "AE3_Animation_Modified_Alt");
			if (!isNull _animationModifiedAlt) then
			{
				private	_description = getText (_animationModifiedAlt >> "description");
				private	_animation = getText (_animationModifiedAlt >> "animation");
				private	_minValue = getNumber (_animationModifiedAlt >> "minValue");
				private	_maxValue = getNumber (_animationModifiedAlt >> "maxValue");
				private	_scrollMultiplier = getNumber (_animationModifiedAlt >> "scrollMultiplier");

				_animationModifiedAlt = [_description, _animation, _minValue, _maxValue, _scrollMultiplier];
			}
			else
			{
				_animationModifiedAlt = [];
			};

			_animationPoints pushBack [_animationPointDescription, _animationPointSelection, _animationMain, _animationModifiedShift, _animationModifiedCtrl, _animationModifiedAlt];
		};

		_animationCounter = _animationCounter + 1;
	};

	_config set ["animationPoints", _animationPoints];
};


/* ---------------------------------------- */

private _aceWorkaround = (_equipmentCfg >> "AE3_aceWorkaround");
if(!isNull _aceWorkaround) then
{
	_config set ["aceWorkaround", true];

	private _aceDragging = (_aceWorkaround >> "AE3_aceDragging");
	if (!isNull _aceDragging) then
	{
		_config set 
		[
			"aceDragging",
			[
				getNumber (_aceDragging >> "ae3_dragging_canDrag"),
				getArray (_aceDragging >> "ae3_dragging_dragPosition"),
				getNumber (_aceDragging >> "ae3_dragging_dragDirection")
			]
		];
	};

	private _aceCarrying = (_aceWorkaround >> "AE3_aceCarrying");
	if (!isNull _aceCarrying) then
	{
		_config set 
		[
			"aceCarrying",
			[
				getNumber (_aceCarrying >> "ae3_dragging_canCarry"),
				getArray (_aceCarrying >> "ae3_dragging_carryPosition"),
				getNumber (_aceCarrying >> "ae3_dragging_carryDirection")
			]
		];
	};
};