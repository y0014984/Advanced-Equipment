/**
  * Function is triggered by CBA setting changed value event handler. Starts/Stops the debug mode loop.
  * 
  * Arguments:
  * 1: Debug Mode Status <BOOL>
  * 
  * Results:
  * None
  *
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
