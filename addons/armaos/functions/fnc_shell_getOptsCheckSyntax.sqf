/**
 * checks the amount of things against the defined syntax
 *
 * Arguments:
 * 1: Syntax <[ARRAY]>
 * 2: Things <[STRING]>
 *
 * Results:
 * 1: Result <BOOLEAN>
 *
 * See AE3 wiki on how to you this in your own commands and applications
 *
 * things count conventions:
 * 0 = no things
 * -1 = unlimited things, minimum 1
 * 1-X = exact number of things
 *
 */

params ["_syntax", "_things"];

private _result = false;

private _thingsCountVariants = [];

{
	// for all syntax variants ...
	
	private _thingsCountMin = 0;
	private _thingsCountMax = -1;

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
        }
        else
        {
            _thingsCountMax = _thingsCountMax + 1;
        };

        if (_elementRequired && !_elementCountUnlimited && (_thingsCountMax != -1)) then
        {
            _thingsCountMax = _thingsCountMax + 1;
        };

	} forEach _syntaxVariant;
	
	_thingsCountVariants pushBack _thingsCount;   

} forEach _syntax;

private _currentThingsCount = count _things;

{
	// the current count only needs to match one syntax variant
	if (_currentThingsCount == _x) exitWith { _result = true; };
	
	// with unlimited count allowed there only needs to be one element as a minimum
	if ((_x == -1) && (_currentThingsCount >= 1)) exitWith { _result = true; };
} forEach _thingsCountVariants;

_result;