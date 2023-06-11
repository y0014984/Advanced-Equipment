params ["_computer", "_isCrypto", "_isCrack"];

if (_isCrypto) then
{
    //--- add 'crypto' command to all synced computers
    [_computer, "CfgSecurityCommands", ["crypto"]] call AE3_armaos_fnc_link_init;
};
if (_isCrack) then
{
    //--- add 'crack' command to all synced computers
    [_computer, "CfgSecurityCommands", ["crack"]] call AE3_armaos_fnc_link_init;
};