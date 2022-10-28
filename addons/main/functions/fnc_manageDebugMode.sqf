params ["_debugMode"];

if (_debugMode) then
{
    private _loopScriptHandle = [] spawn 
        {
            while { true } do
            {
                systemChat "AE3 DEBUG MODE ENABLED";

                sleep 5;
            };
        };

    localNamespace setVariable ["AE3_DebugModeLoopScriptHandle", _loopScriptHandle];
}
else
{
    _loopScriptHandle = localNamespace getVariable "AE3_DebugModeLoopScriptHandle";
    terminate _loopScriptHandle;

    systemChat "AE3 DEBUG MODE DISABLED";
};