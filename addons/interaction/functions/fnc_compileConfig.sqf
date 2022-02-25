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
	'equipment',
	[
		getText (_equipmentCfg >> "displayName"),
		getNumber (_equipmentCfg >> "animatableLampsCount"),
		getNumber (_equipmentCfg >> "closeState"),
		compile (getText (_equipmentCfg >> "init")),
		compile (getText (_equipmentCfg >> "openAction")),
		compile (getText (_equipmentCfg >> "closeAction"))
	]
];

private _aceWorkaround = (_equipmentCfg >> "AE3_aceWorkaround");
if(!isNull _aceWorkaround) then
{
	_config set ["aceWorkaround", true];

	private _aceDragging = (_aceWorkaround >> "AE3_aceDragging");
	if (!isNull _aceDragging) then
	{
		_config set 
		[
			'aceDragging',
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
			'aceCarrying',
			[
				getNumber (_aceCarrying >> "ae3_dragging_canCarry"),
				getArray (_aceCarrying >> "ae3_dragging_carryPosition"),
				getNumber (_aceCarrying >> "ae3_dragging_carryDirection")
			]
		];
	};
};