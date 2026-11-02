// File: fnc_mapOpen.sqf
#include "..\script_component.hpp"
/*
 * Author: Root
 * Description: Opens the native real-world map overlay (AE3_Desktop_MapOverlay) over the web desktop
 *. CEF cannot render Arma's map control, so the Map app calls this to show the genuine
 * RscMapControl centred on the laptop, with local markers for the player and nearby AE3
 * devices/routers. The markers are tracked in uiNamespace and removed by the display's onUnload.
 * Client-only.
 *
 * Arguments:
 * 0: _computer <OBJECT> (Optional, default: objNull) - The laptop this session is bound to
 * 1: _data <HASHMAP> (Optional) - Optional focus: key "pos" [x,y(,z)] to centre on + "label" to mark
 *    (used by the shared device map-link, #0f). When absent, centres on the laptop/player.
 *
 * Return Value:
 * The created display <DISPLAY>
 *
 * Public: No
 */

params [["_computer", objNull, [objNull]], ["_data", createHashMap, [createHashMap]]];

if (!hasInterface) exitWith { displayNull };

private _focus = _data getOrDefault ["pos", []];
private _focusLabel = _data getOrDefault ["label", ""];
private _focusMarker = _data getOrDefault ["marker", true];
// A device map-link supplies a focus position; when it does, the map shows only that one device (plus
// the "You" dot) instead of scattering every nearby AE3 device/router. The generic Map app has no focus
// and still plots everything.
private _hasFocus = _focus isEqualType [] && {count _focus >= 2};

// Parent to the open browser display so the overlay sits on top of the CEF desktop.
private _parent = findDisplay 17010;
if (isNull _parent) then { _parent = findDisplay 46; };

private _display = _parent createDisplay "AE3_Desktop_MapOverlay";
if (isNull _display) exitWith { displayNull };

private _map = _display displayCtrl 17021;

private _center = getPosWorld player;
if (!isNull _computer) then { _center = getPosWorld _computer; };
// A device map-link overrides the centre with the requested grid position.
if (_focus isEqualType [] && {count _focus >= 2}) then { _center = [_focus select 0, _focus select 1, 0]; };

// Centre + zoom the map on the laptop/player (or the focused device).
_map ctrlMapAnimAdd [0, 0.08, _center];
ctrlMapAnimCommit _map;

// Local markers: player + nearby AE3 devices and routers (within 2 km of the centre).
private _markers = [];
private _stamp = round (diag_tickTime * 1000);

private _self = createMarkerLocal [format ["AE3_mapSelf_%1", _stamp], player];
_self setMarkerTypeLocal "mil_dot";
_self setMarkerColorLocal "ColorRed";
_self setMarkerTextLocal "You";
_markers pushBack _self;

// Only plot the surrounding AE3 devices/routers for the generic Map app; a focused device map-link
// wants just its own marker.
if (!_hasFocus) then {
    private _sameOnly = AE3_Desktop_MapSameNetworkOnly && {!isNull _computer};
    {
        private _obj = _x;
        if (_obj isEqualTo player) then { continue };
        private _cfg = configOf _obj;
        private _isRouter = isClass (_cfg >> "AE3_Router");
        private _isDevice = isClass (_cfg >> "AE3_Device");
        if ((_isRouter || _isDevice) && {!_sameOnly || {[_computer, _obj] call AE3_network_fnc_sameNetwork}}) then {
            private _mk = createMarkerLocal [format ["AE3_mapDev_%1_%2", _stamp, _forEachIndex], getPosWorld _obj];
            _mk setMarkerTypeLocal "mil_box";
            _mk setMarkerColorLocal (["ColorGreen", "ColorBlue"] select _isRouter);
            _mk setMarkerSizeLocal [0.7, 0.7];
            _mk setMarkerTextLocal (_obj getVariable ["ace_cargo_customName", ""]);
            _markers pushBack _mk;
        };
    } forEach (nearestObjects [_center, [], 2000]);
};

// Highlighted marker for a focused device
if (_focusMarker && _hasFocus) then {
    private _fm = createMarkerLocal [format ["AE3_mapFocus_%1", _stamp], _center];
    _fm setMarkerTypeLocal "mil_objective";
    _fm setMarkerColorLocal "ColorOrange";
    _fm setMarkerSizeLocal [1, 1];
    if (_focusLabel isNotEqualTo "") then { _fm setMarkerTextLocal _focusLabel; };
    _markers pushBack _fm;
};

uiNamespace setVariable ["AE3_mapOverlayMarkers", _markers];

_display
