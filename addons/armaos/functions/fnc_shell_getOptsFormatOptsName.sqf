params ["_shortOpt", "_longOpt", "_optType", "_optSelect"];

if (!(_shortOpt isEqualTo "")) then { _shortOpt = "-" + _shortOpt; };
if (!(_longOpt isEqualTo "")) then { _longOpt = "--" + _longOpt; };

private _optName = format ["%1/%2", _shortOpt, _longOpt];

if (_shortOpt isEqualTo "") then { _optName = format ["%1", _longOpt]; };
if (_longOpt isEqualTo "") then { _optName = format ["%1", _shortOpt]; };

if (_optType isEqualTo "string") then { _optName = _optName + "=<STRING>"; };
if (_optType isEqualTo "number") then { _optName = _optName + "=<NUMBER>"; };

if ((_optType isEqualTo "stringSelect") || (_optType isEqualTo "numberSelect")) then
{
    private _optSelectString = _optSelect joinString "|";
    _optName = _optName + "=<" + _optSelectString + ">";
};

_optName;