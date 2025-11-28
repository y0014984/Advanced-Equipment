/*
 * Author: Root
 * Description: Builds a trimmed UI-on-Texture payload containing only the lines required to render the current viewport.
 *              Reduces network usage by avoiding transmission of the full terminal history. Returns the slice and the
 *              offset index where the visible viewport starts within that slice.
 *
 * Arguments:
 * 0: _rawBuffer <ARRAY> - Full terminal buffer (array of lines)
 * 1: _terminalRows <NUMBER> - Number of rows visible on the UI-on-Texture surface
 * 2: _scrollPosition <NUMBER> - Current scroll position (from end)
 * 3: _maxTransmitLines <NUMBER> - Hard cap on lines to include in the payload
 *
 * Return Value:
 * 0: _bufferSlice <ARRAY> - Trimmed buffer slice to transmit
 * 1: _visibleStartOffset <NUMBER> - Index within the slice where the viewport starts
 *
 * Example:
 * private [_slice, _offset] = [_rawBuffer, 24, 0, 120] call AE3_armaos_fnc_terminal_buildUiPayload;
 *
 * Public: No
 */

params ["_rawBuffer", "_terminalRows", "_scrollPosition", "_maxTransmitLines"];

if (isNil "_rawBuffer") exitWith { [[], 0] };

private _bufferCount = count _rawBuffer;
if (_bufferCount == 0) exitWith { [[], 0] };

// Ensure limits are sane
_terminalRows = (_terminalRows max 1) min 500; // guard against nonsense rows
_maxTransmitLines = (_maxTransmitLines max _terminalRows) max 1; // always allow at least a full viewport

// Compute the intended start/end of the visible viewport within the full buffer
private _startIndex = (_bufferCount - _terminalRows) - _scrollPosition;
_startIndex = _startIndex max 0;
private _endIndex = (_startIndex + _terminalRows) min _bufferCount;

// Fit the slice within the max transmit cap while still containing the viewport
private _sliceStart = _startIndex max (_endIndex - _maxTransmitLines);
_sliceStart = _sliceStart max 0;
private _sliceEnd = (_sliceStart + _maxTransmitLines) min _bufferCount;

private _visibleStartOffset = _startIndex - _sliceStart;
private _bufferSlice = _rawBuffer select [_sliceStart, _sliceEnd - _sliceStart];

[_bufferSlice, _visibleStartOffset];
