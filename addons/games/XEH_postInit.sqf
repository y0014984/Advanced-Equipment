// File: XEH_postInit.sqf
#include "script_component.hpp"

if (!hasInterface) exitWith {};

// The server answers every request with one JSON string. It is decoded once here and handed to both
// front ends: pushed into the web desktop if one is open, and raised as a local event the terminal
// session loop waits on. Neither front end ever receives another seat's hidden cards or ships - the
// server has already stripped them.
["ae3_games_view", {
    params [["_json", ""]];

    if (_json isEqualTo "") exitWith {};

    // Every piece of text the server put in the answer travels as a stringtable key, because the
    // server may well be a dedicated one running another language than the player. Keys can sit at
    // any depth - a table title, a refusal, a row in the lobby list - so the whole answer is walked
    // once here and each key is turned into this client's own language.
    private _fnc_localizeDeep = {
        params ["_value"];

        if (_value isEqualType "") exitWith
        {
            if ((_value select [0, 4]) isEqualTo "$STR") then {localize (_value select [1])} else {_value};
        };

        if (_value isEqualType []) exitWith {_value apply {[_x] call _fnc_localizeDeep}};

        if (_value isEqualType createHashMap) exitWith
        {
            private _out = createHashMap;

            {
                _out set [_x, [_y] call _fnc_localizeDeep];
            } forEach _value;

            _out
        };

        _value
    };

    private _payload = [[_json, 2] call CBA_fnc_parseJSON] call _fnc_localizeDeep;
    private _textKey = _payload getOrDefault ["textKey", ""];

    if (_textKey isNotEqualTo "") then {_payload set ["text", _textKey]};

    missionNamespace setVariable [QGVAR(lastView), _payload];
    missionNamespace setVariable [QGVAR(viewSeq), (missionNamespace getVariable [QGVAR(viewSeq), 0]) + 1];

    ["ae3_games_viewUpdated", [_payload]] call CBA_fnc_localEvent;

    ["games_view", _payload] call AE3_desktop_fnc_jsSend;
}] call CBA_fnc_addEventHandler;

// The roster a curator asked for, which arrives as plain rows rather than a HashMap
["ae3_games_rosterResult", {
    _this call FUNC(zeus_showRoster);
}] call CBA_fnc_addEventHandler;

// Web desktop front end. Registration is local effect, so it runs on every client.
[] call FUNC(registerApps);
