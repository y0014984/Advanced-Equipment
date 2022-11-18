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
}
else
{
    _debugModeLoopHandle = localNamespace getVariable "AE3_DebugModeLoopHandle";
    [_debugModeLoopHandle] call CBA_fnc_removePerFrameHandler;

    if (time > 3) then { systemChat localize "STR_AE3_Main_DebugMode_disabled"; };
};