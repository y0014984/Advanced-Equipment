// File: fnc_ping.sqf
/**
 * Returns the device object and the route length for given initial device and
 * target IP. Returns objNull if route is invalid.
 *
 * When AE3 debug mode (or network debug) is enabled, every hop is written to the RPT with the
 * entity, its address, the target, power state, parent, child count and the reason the hop ended
 * (loop / powered off / self match / forwarded via cache, child or parent / dead end). The hop
 * depth prefixes each line so the full route reads top to bottom.
 *
 * Arguments:
 * 0: Device <OBJECT>
 * 1: Target IP <[INT]>
 * 2: Last hop <OBJECT> (Optional)
 * 3: Visited devices <ARRAY> (Optional)
 *
 * Returns:
 * 0: Target <OBJECT>
 * 1: Length <FLOAT>
 */

params ["_entity", "_target", ["_last", objNull], ["_visited", [], [[]]]];

private _dbg = AE3_DebugMode || {missionNamespace getVariable ["AE3_NetworkDebugEnabled", false]};
private _depth = count _visited;
private _trace =
{
	params ["_reason"];
	private _selfIp = if (isNull _entity) then {"-"} else {[_entity getVariable ["AE3_network_address", [0, 0, 0, 0]]] call AE3_network_fnc_ip2str};
	private _name = if (isNull _entity) then {"objNull"} else {[_entity, true] call ace_cargo_fnc_getNameItem};
	private _ps = if (isNull _entity) then {-1} else {_entity getVariable ["AE3_power_powerState", 1]};
	private _parent = if (isNull _entity) then {objNull} else {_entity getVariable ["AE3_network_parent", objNull]};
	private _childCount = if (isNull _entity) then {-1} else {count (_entity getVariable ["AE3_network_children", []])};
	diag_log text format [
		"[AE3][ROUTE] d=%1 at=%2#%3 ip=%4 -> target=%5 power=%6 parent=%7 children=%8 :: %9",
		_depth,
		_name, (if (isNull _entity) then {"-"} else {netId _entity}),
		_selfIp,
		([_target] call AE3_network_fnc_ip2str),
		_ps,
		(if (isNull _parent) then {"none"} else {[_parent, true] call ace_cargo_fnc_getNameItem}),
		_childCount,
		_reason
	];
};

if (isNull _entity || {_entity in _visited}) exitWith
{
	if (_dbg) then {["loop-or-null"] call _trace};
	[objNull, 0];
};

_visited pushBack _entity;

if (!alive _entity || _entity getVariable ["AE3_power_powerState", 1] == 0) exitWith
{
	if (_dbg) then {["dead-or-off"] call _trace};
	[objNull, 0];
};

if (_target isEqualTo [127, 0, 0, 1] || _target isEqualTo (_entity getVariable ["AE3_network_address", [127, 0, 0, 1]])) exitWith
{
	if (_dbg) then {["self-match"] call _trace};
	[_entity, 0];
};

// Routers can forward to cached next hops, children, or their parent router.
if (!isNil {_entity getVariable "AE3_network_children"}) exitWith
{
	private _catch = _entity getVariable ["AE3_network_addressCatch", createHashMap];
	private _targetStr = [_target] call AE3_network_fnc_ip2str;

	private _result = [objNull, 0];
	if (_targetStr in _catch) then
	{
		private _next = _catch get _targetStr;
		private _res = [_next, _target, _entity, +_visited] call AE3_network_fnc_ping;

		if (isNull (_res select 0)) then
		{
			_catch deleteAt _targetStr;
			_entity setVariable ["AE3_network_addressCatch", _catch, true];
		}
		else
		{
			_res set [1, (_res select 1) + (_next distance _entity)];
			_result = _res;
		};
	};
	if (!isNull (_result select 0)) exitWith
	{
		if (_dbg) then {["forwarded-via-cache"] call _trace};
		_result;
	};

	{
		if (_x isEqualTo _last || {_x in _visited}) then {continue};

		private _res = [_x, _target, _entity, +_visited] call AE3_network_fnc_ping;

		if (!isNull (_res select 0)) then
		{
			_catch set [_targetStr, _x];
			_entity setVariable ["AE3_network_addressCatch", _catch, true];

			_res set [1, (_res select 1) + (_x distance _entity)];
			_result = _res;
		};
	} forEach (_entity getVariable ["AE3_network_children", []]);

	if (!isNull (_result select 0)) exitWith
	{
		if (_dbg) then {["forwarded-via-child"] call _trace};
		_result;
	};

	private _parent = _entity getVariable ["AE3_network_parent", objNull];
	if (!isNull _parent && _parent isNotEqualTo _last && {!(_parent in _visited)}) then
	{
		private _res = [_parent, _target, _entity, +_visited] call AE3_network_fnc_ping;

		if (!isNull (_res select 0)) then
		{
			_catch set [_targetStr, _parent];
			_entity setVariable ["AE3_network_addressCatch", _catch, true];

			_res set [1, (_res select 1) + (_parent distance _entity)];
			_result = _res;
		};
	};

	if (_dbg) then {[["forwarded-via-parent", "router-dead-end"] select (isNull (_result select 0))] call _trace};
	_result;
};

private _parent = _entity getVariable ["AE3_network_parent", objNull];
if (!isNull _parent && _parent isNotEqualTo _last && {!(_parent in _visited)}) exitWith
{
	private _res = [_parent, _target, _entity, +_visited] call AE3_network_fnc_ping;
	if (!isNull (_res select 0)) then
	{
		_res set [1, (_parent distance _entity) + (_res select 1)];
	};
	if (_dbg) then {[["forwarded-via-parent", "client-dead-end"] select (isNull (_res select 0))] call _trace};
	_res;
};

if (_dbg) then {["dead-end-no-parent"] call _trace};
[objNull, 0];
