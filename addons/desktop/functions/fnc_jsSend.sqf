// File: fnc_jsSend.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: SQF->JS bridge for the web desktop (WS-B). Pushes a call into the live browser
 * control via ctrlWebBrowserAction ["ExecJS", ...]. The JS side exposes a global dispatcher
 * (window.AE3_recv) that receives the command name and a JSON-encoded payload. Used by backend
 * functions to deliver replies/events to the running web UI. Safe to call when no web desktop is
 * open (it no-ops). Client-only.
 *
 * Arguments:
 * 0: _command <STRING> - Command/handler name the JS side understands
 * 1: _payload <ANY> (Optional, default: []) - Data, JSON-encoded before being sent
 *
 * Return Value:
 * None
 *
 * Example:
 * ["devList", [_type, _list]] call AE3_desktop_fnc_jsSend;
 *
 * Public: No
 */

params [["_command", "", [""]], ["_payload", []]];

private _ctrl = uiNamespace getVariable [QGVAR(browserCtrl), controlNull];
if (isNull _ctrl) exitWith {};
if (_command isEqualTo "") exitWith {};

// Unicode-safe escaping of user generated text
forceUnicode 1;
private _json = [_payload] call CBA_fnc_encodeJSON;
forceUnicode -1;
if ((missionNamespace getVariable [QGVAR(debug), false]) || {missionNamespace getVariable ["AE3_DebugMode", false]}) then {
    diag_log text format ["[AE3 desktop] SQF->JS '%1'", _command];
};
private _js = format ["window.AE3_recv && window.AE3_recv('%1', %2)", _command, _json];
[_ctrl, ["ExecJS", _js]] call FUNC(browserAction);
