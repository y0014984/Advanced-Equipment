/*
 * Author: Root
 * Description: Validates command syntax by checking if provided arguments match the expected command syntax pattern.
 *
 * Arguments:
 * 0: _syntax <STRING> - TODO: Add description
 * 1: _things <ARRAY> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_syntax, _things] call AE3_armaos_fnc_shell_getOptsCheckSyntax;
 *
 * Public: No
 */

params ["_syntax", "_things"];

private _result = false;

private _thingsCountVariants = [];

{
	// for all syntax variants ...
	
	private _thingsCountMin = 0;
	private _thingsCountMax = 0;

	private _syntaxVariant = _x;
	
	{
		// ... calculate the expected things count
		
		private _elementType = _x select 0;
		private _elementRequired = _x select 2;
		private _elementCountUnlimited = _x select 3;
		
		if (_forEachIndex == 0) then { continue; }; // skip loop iteration for 1st element, which is the command itself
		if (_elementType isEqualTo "options") then { continue; }; // skip loop iteration for options element

        //
        // decision matrix
        //
        // required | unlimited | _thingsCountMin | _thingsCountMax
        // --------------------------------------------------------
        // true     | true      | + 1             | set to -1
        // true     | false     | + 1             | + 1, if not already set to -1
        // false    | true      | ---             | set to -1
        // false    | false     | ---             | ---
        // --------------------------------------------------------
        //

		if (_elementRequired) then
        {
            _thingsCountMin = _thingsCountMin + 1;
        };

        if (_elementCountUnlimited) then
        {
            _thingsCountMax = -1;
        };

        if (_elementRequired && !_elementCountUnlimited && (_thingsCountMax != -1)) then
        {
            _thingsCountMax = _thingsCountMax + 1;
        };

	} forEach _syntaxVariant;
	
	_thingsCountVariants pushBack [_thingsCountMin, _thingsCountMax];   

} forEach _syntax;

private _currentThingsCount = count _things;

{
    _x params ["_min", "_max"];

	// the current count only needs to match one syntax variant
	if ((_currentThingsCount >= _min) && ((_currentThingsCount <= _max) || (_max == -1))) exitWith { _result = true; };
	
} forEach _thingsCountVariants;

_result;
