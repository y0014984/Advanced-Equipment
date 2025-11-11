/*
 * Author: Root
 * Description: Triggered by CBA setting change event handler to start or stop the debug mode loop.
 * Enables/disables system chat debug messages and optional debug overlay (currently disabled for production use).
 *
 * Arguments:
 * 0: _debugMode <BOOL> - Debug mode status (true = enabled, false = disabled)
 *
 * Return Value:
 * None
 *
 * Example:
 * [true] call AE3_main_fnc_manageDebugMode;
 *
 * Public: No
 */

params ["_debugMode"];

// Debug Overlay needs to be optimized for use in dedicated multiplayer missions
// Too many updates via getRemoteVar in getBatteryLevel and getPowerOutput
// Also there needs to be a way to call getBatteryLevel and getPowerOutput in a scheduled way
// See issue #245
private _debugOverlayProductiveUse = false;

if (hasInterface) then
{
    if (_debugMode) then
    {


        private _debugModeLoopHandle = 
        [
            {
                systemChat localize "STR_AE3_Main_DebugMode_enabled";
            }, 
            5, 
            []
        ] call CBA_fnc_addPerFrameHandler;
        
        localNamespace setVariable ["AE3_DebugModeLoopHandle", _debugModeLoopHandle];

        if (_debugOverlayProductiveUse) then
        {
            [] spawn 
            {
                // enable debug overlay
                waitUntil { ((findDisplay 46) isNotEqualTo displayNull) };
                private _objects = missionNamespace getVariable "AE3_DebugOverlay";
                if(!isNil "_objects") then { [_objects] call AE3_main_fnc_initDebugOverlay; };
            };
        };
    }
    else
    {
        _debugModeLoopHandle = localNamespace getVariable "AE3_DebugModeLoopHandle";
        [_debugModeLoopHandle] call CBA_fnc_removePerFrameHandler;

        if ((time >= 5)) then { systemChat localize "STR_AE3_Main_DebugMode_disabled"; };

        if (_debugOverlayProductiveUse) then
        {
            [] spawn 
            {
            //disable debug overlay
            waitUntil { ((findDisplay 46) isNotEqualTo displayNull) };
            private _objects = missionNamespace getVariable "AE3_DebugOverlay";
            if(!isNil "_objects") then { [_objects] call AE3_main_fnc_killDebugOverlay; };
            };
        };
    };
};
