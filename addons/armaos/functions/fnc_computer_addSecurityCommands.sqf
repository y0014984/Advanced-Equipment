/*
 * Author: Root
 * Description: Adds selected security commands (crypto, crack) to a given computer. Must be executed on the server.
 *
 * Arguments:
 * 0: _computer <OBJECT> - The computer object to add security commands to
 * 1: _isCrypto <BOOL> - Whether to add the crypto command for encryption/decryption
 * 2: _isCrack <BOOL> - Whether to add the crack command for password cracking
 *
 * Return Value:
 * None
 *
 * Example:
 * [_computer, true, true] call AE3_armaos_fnc_computer_addSecurityCommands;
 *
 * Public: Yes
 */

params ["_computer", "_isCrypto", "_isCrack"];

if (!isServer) exitWith {};

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
