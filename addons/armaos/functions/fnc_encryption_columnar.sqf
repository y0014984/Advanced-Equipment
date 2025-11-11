/*
 * Author: Root
 * Description: Encrypts or decrypts a message using columnar transposition cipher with the specified key.
 *
 * Arguments:
 * 0: _key <STRING> - TODO: Add description
 * 1: _mode <STRING> - TODO: Add description
 * 2: _msg <STRING> - TODO: Add description
 *
 * Return Value:
 * None
 *
 * Example:
 * [_key, _mode, _msg] call AE3_armaos_fnc_encryption_columnar;
 *
 * Public: No
 */

params ["_key", "_mode", "_msg"];

private _result = "";
private _msgLen = count _msg;
private _msgArr = _msg splitString "";
// calculate column of the matrix
private _numCol = count _key;
// calculate maximum row of the matrix
private _numRow = ceil(_msgLen / _numCol);

// transform the key into an unicode-decimal array.
private _keyArr = [];
private _doubles = 1;
{
	private _dec = (toArray _x) select 0;
	if ((_keyArr find _dec) != -1) then {
		// to distinguish multiple occurences of the same character,
		// slightly increase the decimal, without matching another unicode-character
		_dec = _dec + 0.001 * _doubles;
		_doubles = _doubles + 1;
	};
	_keyArr pushBack _dec;
} forEach (_key splitString "");
private _keyArrCopy = + _keyArr;

// en- and decryption
switch (_mode) do {
	case "encrypt": {
		private _cipher = "";

		// amount of empty cells in the matrix
		private _fillNull = floor((_numRow * _numCol) - _msgLen);

		// adding underscores as padding for empty cells
		for "_i" from 1 to _fillNull do {
			_msgArr pushBack "_";
		};

		// create Matrix, insert message and
		// add padding characters row-wise
		private _matrix = [];
		private _indx = 0;
		for "_i" from 1 to _numRow do {
			private _row = _msgArr select [_indx, _numCol];
			_matrix pushBack _row;
			_indx = _indx + _numCol;
		};

		// read matrix column-wise using key		
		for "_i" from 0 to (_numCol - 1) do {
			private _min = selectMin _keyArrCopy;
			private _indx = _keyArr find _min;
			{
				_cipher = _cipher + (_x select _indx);
			} forEach _matrix;
			_keyArrCopy deleteAt (_keyArrCopy find _min);
		};
		copyToClipboard _cipher;
		_result = _cipher;
	};

	case "decrypt": {
		// the message can't be decoded, if the key and message-lengths
		// don't fit a complete transposition
		if ((_msgLen mod _numCol) != 0) exitWith {};

		private _plainText = "";

		// extract the segments from the encrypted message
		private _segments = [];
		private _indx = 0;		
		for "_i" from 1 to _numCol do {
			_segments pushBack (_msgArr select [_indx, _numRow]);
			_indx = _indx + _numRow;
		};

		// sort the segments into the correct order,
		// determined by the key
		private _sortedSegments = [];
		_keyArrCopy sort true;
		{
			private _keyDec = _keyArrCopy select _foreachIndex;
			private _indx = _keyArr find _keyDec;
			_sortedSegments set [_indx, _x];
		} forEach _segments;

		// create the decrypted message from the sorted segments
		for "_i" from 0 to (_numRow - 1) do {
			{				
				_plainText = _plainText + (_x select _i);
			} forEach _sortedSegments;
		};
		_result = _plainText;
	};	
};

_result
