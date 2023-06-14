/**
 * PUBLIC
 *
 * Adds selected security commands to a given computer.
 *
 * Arguments:
 * 1: Computer <OBJECT>
 * 2: Crypto <BOOL>
 * 3: Crack <BOOL>
 *
 * Results:
 * None
 *
 * Example:
 * [_computer, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
 *
 */

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