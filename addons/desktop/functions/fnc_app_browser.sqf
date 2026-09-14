// File: fnc_app_browser.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Desktop "Browser" app: looks up in-game webpages registered with
 * AE3_desktop_fnc_registerWebpage. Supports clickable links: page content may contain
 * [[url|label]] tokens, which are rendered as a link strip below the page. Back button
 * navigates the session history. Every visited URL is appended to the laptop's
 * /var/log/browser_history file (plantable/readable intel trail).
 *
 * Arguments:
 * 0: _winId <NUMBER>
 * 1: _ctrlGroup <CONTROL>
 * 2: _computer <OBJECT>
 * 3: _args <ANY> - optional [_url] to open directly
 *
 * Return Value:
 * App callbacks <HASHMAP>
 *
 * Public: No
 */

params ["_winId", "_ctrlGroup", "_computer", "_args"];

private _session = uiNamespace getVariable ["AE3_desktop_session", createHashMap];
private _display = _session getOrDefault ["display", displayNull];
private _theme = _session getOrDefault ["theme", createHashMap];

(ctrlPosition _ctrlGroup) params ["", "", "_w", "_h"];

/* back + address bar + go + history */
private _backBtn = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
_backBtn ctrlSetPosition [0.01, 0.045, 0.05, 0.035];
_backBtn ctrlSetText "<";
_backBtn ctrlSetBackgroundColor (_theme getOrDefault ["titlebar", [0,0,0,1]]);
_backBtn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
_backBtn ctrlCommit 0;

private _addressCtrl = _display ctrlCreate ["RscEdit", -1, _ctrlGroup];
_addressCtrl ctrlSetPosition [0.07, 0.045, _w - 0.31, 0.035];
_addressCtrl ctrlSetText (_args param [0, "home.root"]);
_addressCtrl ctrlCommit 0;

private _goBtn = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
_goBtn ctrlSetPosition [_w - 0.235, 0.045, 0.07, 0.035];
_goBtn ctrlSetText (localize "STR_AE3_Desktop_Browser_Go");
_goBtn ctrlSetBackgroundColor (_theme getOrDefault ["accent", [0.2,0.5,0.8,1]]);
_goBtn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
_goBtn ctrlCommit 0;

private _historyBtn = _display ctrlCreate ["RscButton", -1, _ctrlGroup];
_historyBtn ctrlSetPosition [_w - 0.16, 0.045, 0.15, 0.035];
_historyBtn ctrlSetText (localize "STR_AE3_Desktop_Browser_History");
_historyBtn ctrlSetBackgroundColor (_theme getOrDefault ["titlebar", [0,0,0,1]]);
_historyBtn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
_historyBtn ctrlCommit 0;

/* page area + link strip */
private _pageCtrl = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroup];
_pageCtrl ctrlSetPosition [0.01, 0.09, _w - 0.02, _h - 0.19];
_pageCtrl ctrlCommit 0;

/* ---------------------------------------- */

_pageCtrl setVariable ["AE3_computer", _computer];
_pageCtrl setVariable ["AE3_addressCtrl", _addressCtrl];
_pageCtrl setVariable ["AE3_group", _ctrlGroup];
_pageCtrl setVariable ["AE3_size", [_w, _h]];
_pageCtrl setVariable ["AE3_navStack", []];
_pageCtrl setVariable ["AE3_linkCtrls", []];

private _navigate = {
	params ["_pageCtrl", "_url", ["_isBack", false]];

	private _computer = _pageCtrl getVariable "AE3_computer";
	private _addressCtrl = _pageCtrl getVariable "AE3_addressCtrl";
	private _group = _pageCtrl getVariable "AE3_group";
	(_pageCtrl getVariable "AE3_size") params ["_w", "_h"];
	private _display = ctrlParent _pageCtrl;
	private _session = uiNamespace getVariable ["AE3_desktop_session", createHashMap];
	private _theme = _session getOrDefault ["theme", createHashMap];

	_url = toLower ([_url] call CBA_fnc_trim);
	if (_url isEqualTo "") exitWith {};

	// session history (for the back button)
	if (!_isBack) then
	{
		private _stack = _pageCtrl getVariable "AE3_navStack";
		_stack pushBack _url;
		_pageCtrl setVariable ["AE3_navStack", _stack];
	};
	_addressCtrl ctrlSetText _url;

	// remove old link buttons
	{
		ctrlDelete _x;
	} forEach (_pageCtrl getVariable "AE3_linkCtrls");
	_pageCtrl setVariable ["AE3_linkCtrls", []];

	private _pages = +(missionNamespace getVariable ["AE3_Desktop_Webpages", createHashMap]);
	private _localPages = _computer getVariable ["AE3_Desktop_Webpages", createHashMap];
	{
		_pages set [_x, _localPages get _x];
	} forEach (keys _localPages);
	private _html = "";
	private _links = []; // [[url, label], ...]

	if (_url isEqualTo "home.root") then
	{
		// built-in homepage: all registered pages become links
		_html = format ["<t size='1.4' color='#5da8e8'>%1</t><br/>", localize "STR_AE3_Desktop_Browser_HomeTitle"];
		{
			(_pages get _x) params ["_title"];
			_links pushBack [_x, _title];
		} forEach (keys _pages);
		if (_links isEqualTo []) then { _html = _html + "<br/>" + (localize "STR_AE3_Desktop_Browser_NoPages"); };
	}
	else
	{
		if (_url in _pages) then
		{
			(_pages get _url) params ["_title", "_content"];

			// extract [[url|label]] link tokens; inline they render as underlined text,
			// the actual click targets are the link strip buttons below the page
			private _plain = [];
			{
				private _line = _x;

				{
					(_x select 1) params ["_linkUrl"];
					(_x select 2) params ["_label"];
					_links pushBack [_linkUrl, _label];
				} forEach (_line regexFind ["\[\[([^\]\|]+)\|([^\]]+)\]\]", 0]);

				_line = _line regexReplace ["\[\[([^\]\|]+)\|([^\]]+)\]\]", "<t color='#5da8e8' underline='1'>$2</t>"];
				_plain pushBack _line;
			} forEach (_content splitString endl);

			_html = format ["<t size='1.4' color='#5da8e8'>%1</t><br/><br/>%2", _title, _plain joinString "<br/>"];
		}
		else
		{
			_html = format ["<t size='1.4' color='#e85d5d'>404</t><br/><br/>%1", format [localize "STR_AE3_Desktop_Browser_NotFound", _url]];
		};
	};

	_pageCtrl ctrlSetStructuredText (parseText _html);

	// link strip (max 8 links, two rows of four)
	private _linkCtrls = [];
	{
		if (_forEachIndex >= 8) exitWith {};
		_x params ["_linkUrl", "_label"];

		private _btn = _display ctrlCreate ["RscButton", -1, _group];
		_btn ctrlSetPosition [
			0.01 + ((_w - 0.02) / 4) * (_forEachIndex mod 4),
			(_h - 0.095) + 0.045 * floor (_forEachIndex / 4),
			(_w - 0.05) / 4,
			0.04
		];
		_btn ctrlSetText _label;
		_btn ctrlSetBackgroundColor (_theme getOrDefault ["accent", [0.2,0.5,0.8,1]]);
		_btn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
		_btn ctrlCommit 0;

		_btn setVariable ["AE3_pageCtrl", _pageCtrl];
		_btn setVariable ["AE3_url", _linkUrl];
		_btn ctrlAddEventHandler ["ButtonClick", {
			params ["_btn"];
			private _pageCtrl = _btn getVariable "AE3_pageCtrl";
			[_pageCtrl, _btn getVariable "AE3_url"] call (_pageCtrl getVariable "AE3_navigate");
		}];

		_linkCtrls pushBack _btn;
	} forEach _links;
	_pageCtrl setVariable ["AE3_linkCtrls", _linkCtrls];

	// append to the on-disk browser history (intel trail)
	private _filesystem = _computer getVariable ["AE3_filesystem", []];
	if (_filesystem isNotEqualTo []) then
	{
		try
		{
			[[], _filesystem, "/var/log/browser_history", "", "root", "root", [[true, true, false], [true, false, false]]] call AE3_filesystem_fnc_ensureFile;
			[[], _filesystem, "/var/log/browser_history", "root", format ["[%1] %2%3", [dayTime, "HH:MM"] call BIS_fnc_timeToString, _url, endl], true] call AE3_filesystem_fnc_writeToFile;
			_computer setVariable ["AE3_filesystem", _filesystem, 2];
		}
		catch
		{
			INFO_1("Could not write browser history: %1",_exception);
		};
	};
};

_pageCtrl setVariable ["AE3_navigate", _navigate];

/* ---------------------------------------- */

_goBtn setVariable ["AE3_ctx", [_pageCtrl, _addressCtrl]];
_goBtn ctrlAddEventHandler ["ButtonClick", {
	params ["_button"];
	((_button getVariable "AE3_ctx")) params ["_pageCtrl", "_addressCtrl"];
	[_pageCtrl, ctrlText _addressCtrl] call (_pageCtrl getVariable "AE3_navigate");
}];

_backBtn setVariable ["AE3_pageCtrl", _pageCtrl];
_backBtn ctrlAddEventHandler ["ButtonClick", {
	params ["_button"];
	private _pageCtrl = _button getVariable "AE3_pageCtrl";

	private _stack = _pageCtrl getVariable "AE3_navStack";
	if (count _stack < 2) exitWith {};
	_stack deleteAt (count _stack - 1); // current page
	private _previous = _stack select -1;
	_pageCtrl setVariable ["AE3_navStack", _stack];

	[_pageCtrl, _previous, true] call (_pageCtrl getVariable "AE3_navigate");
}];

_historyBtn setVariable ["AE3_pageCtrl", _pageCtrl];
_historyBtn ctrlAddEventHandler ["ButtonClick", {
	params ["_button"];
	private _pageCtrl = _button getVariable "AE3_pageCtrl";
	private _computer = _pageCtrl getVariable "AE3_computer";
	private _group = _pageCtrl getVariable "AE3_group";
	(_pageCtrl getVariable "AE3_size") params ["_w", "_h"];
	private _display = ctrlParent _pageCtrl;
	private _session = uiNamespace getVariable ["AE3_desktop_session", createHashMap];
	private _theme = _session getOrDefault ["theme", createHashMap];

	{ ctrlDelete _x; } forEach (_pageCtrl getVariable "AE3_linkCtrls");
	_pageCtrl setVariable ["AE3_linkCtrls", []];

	private _filesystem = _computer getVariable ["AE3_filesystem", []];
	private _entries = [];
	try
	{
		private _content = [[], _filesystem, "/var/log/browser_history", "root", 0] call AE3_filesystem_fnc_getFile;
		if (_content isEqualType "" && _content isNotEqualTo "") then
		{
			{
				private _line = [_x] call CBA_fnc_trim;
				if (_line isNotEqualTo "") then
				{
					private _spaceIdx = _line find " ";
					if (_spaceIdx > 0) then
					{
						private _url = _line select [_spaceIdx + 1];
						if (_url isNotEqualTo "") then { _entries pushBack [_url, _line]; };
					};
				};
			} forEach (_content splitString endl);
		};
	}
	catch {};

	private _html = format ["<t size='1.4' color='#5da8e8'>%1</t><br/>", localize "STR_AE3_Desktop_Browser_History"];
	if (_entries isEqualTo []) then { _html = _html + "<br/>" + (localize "STR_AE3_Desktop_Browser_NoHistory"); };
	_pageCtrl ctrlSetStructuredText (parseText _html);

	private _linkCtrls = [];
	{
		if (_forEachIndex >= 8) exitWith {};
		_x params ["_url", "_label"];
		private _btn = _display ctrlCreate ["RscButton", -1, _group];
		_btn ctrlSetPosition [
			0.01 + ((_w - 0.02) / 4) * (_forEachIndex mod 4),
			(_h - 0.095) + 0.045 * floor (_forEachIndex / 4),
			(_w - 0.05) / 4,
			0.04
		];
		_btn ctrlSetText _label;
		_btn ctrlSetBackgroundColor (_theme getOrDefault ["accent", [0.2,0.5,0.8,1]]);
		_btn ctrlSetTextColor (_theme getOrDefault ["text", [1,1,1,1]]);
		_btn ctrlCommit 0;
		_btn setVariable ["AE3_pageCtrl", _pageCtrl];
		_btn setVariable ["AE3_url", _url];
		_btn ctrlAddEventHandler ["ButtonClick", {
			params ["_btn"];
			private _pageCtrl = _btn getVariable "AE3_pageCtrl";
			[_pageCtrl, _btn getVariable "AE3_url"] call (_pageCtrl getVariable "AE3_navigate");
		}];
		_linkCtrls pushBack _btn;
	} forEach _entries;
	_pageCtrl setVariable ["AE3_linkCtrls", _linkCtrls];
}];

// open homepage (or the passed/restored url) immediately
[_pageCtrl, _args param [0, "home.root"]] call _navigate;

createHashMapFromArray [
	["addressCtrl", _addressCtrl],
	["getState", {
		private _ctrl = _this getOrDefault ["addressCtrl", controlNull];
		if (isNull _ctrl) exitWith { [] };
		[ctrlText _ctrl]
	}]
]
