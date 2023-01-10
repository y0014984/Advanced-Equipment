/**
 * Creates an humandreadable STRING, that describes an command option.
 *
 * Arguments:
 * 1: Short Form of Option <STRING>
 * 2: Long Form of Option <STRING>
 * 3: Option Type <STRING>
 * 4: Select Options <[STRING]>
 *
 * Results:
 * 1: Command Description <STRING>
 *
 */

params ["_shortOpt", "_longOpt", "_optType", "_optSelect"];

if (!(_shortOpt isEqualTo "")) then { _shortOpt = "-" + _shortOpt; };
if (!(_longOpt isEqualTo "")) then { _longOpt = "--" + _longOpt; };

private _optName = format ["%1/%2", _shortOpt, _longOpt];

if (_shortOpt isEqualTo "") then { _optName = format ["%1", _longOpt]; };
if (_longOpt isEqualTo "") then { _optName = format ["%1", _shortOpt]; };

if (_optType isEqualTo "string") then { _optName = _optName + "=<STRING>"; };
if (_optType isEqualTo "number") then { _optName = _optName + "=<NUMBER>"; };

if (_optType isEqualTo "file") then { _optName = _optName + "=<FILE>"; };
if (_optType isEqualTo "folder") then { _optName = _optName + "=<FOLDER>"; };

if (_optType isEqualTo "fileExist") then { _optName = _optName + "=<EXISTING FILE>"; };
if (_optType isEqualTo "folderExist") then { _optName = _optName + "=<EXISTING FOLDER>"; };

if (_optType isEqualTo "fileNonExist") then { _optName = _optName + "=<NON EXISTING FILE>"; };
if (_optType isEqualTo "folderNonExist") then { _optName = _optName + "=<NON EXISTING FOLDER>"; };

if ((_optType isEqualTo "stringSelect") || (_optType isEqualTo "numberSelect")) then
{
    private _optSelectString = _optSelect joinString "|";
    _optName = _optName + "=<" + _optSelectString + ">";
};

_optName;