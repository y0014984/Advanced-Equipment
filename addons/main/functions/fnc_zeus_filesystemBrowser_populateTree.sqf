/*
 * Author: Root
 * Description: Recursively populates a tree control with the directory structure for the Zeus filesystem browser Move dialog.
 * Excludes the source item being moved and disables subdirectories of the source to prevent moving a directory into itself.
 * Only directories are added to the tree, not files.
 *
 * Arguments:
 * 0: _treeCtrl <CONTROL> - The tree control to populate
 * 1: _dirContent <HASHMAP> - The directory content hashmap to process
 * 2: _currentPath <ARRAY> - The current filesystem path as an array of directory names
 * 3: _treePath <ARRAY> - The current tree control path as an array of indices
 * 4: _sourcePointer <ARRAY> - The source directory path to exclude from the tree
 * 5: _sourceFile <STRING> - The source file/folder name being moved
 *
 * Return Value:
 * None
 *
 * Example:
 * [_treeCtrl, _dirContent, ["home", "user"], [0, 1], ["home"], "documents"] call AE3_main_fnc_zeus_filesystemBrowser_populateTree;
 *
 * Public: No
 */

params ["_treeCtrl", "_dirContent", "_currentPath", "_treePath", "_sourcePointer", "_sourceFile"];

// Get all keys and sort them
private _keys = keys _dirContent;
_keys sort true;

{
	private _name = _x;
	private _obj = _dirContent get _name;
	private _isDir = (typeName (_obj select 0)) isEqualTo "HASHMAP";

	// Only add directories to the tree
	if (_isDir) then
	{
		// Build the full path for this directory
		private _fullPath = +_currentPath;
		_fullPath pushBack _name;

		// Check if this is the source directory being moved
		private _isSourceDir = (_sourcePointer isEqualTo _fullPath) && (_sourceFile isEqualTo "");

		// Check if this is the source file/folder
		private _parentPath = +_fullPath;
		_parentPath deleteAt ((count _parentPath) - 1);
		private _isSourceItem = (_sourcePointer isEqualTo _parentPath) && (_sourceFile isEqualTo _name);

		// Don't add the source directory or its item to the tree
		if (!_isSourceDir && !_isSourceItem) then
		{
			// Add this directory to the tree
			private _index = _treeCtrl tvAdd [_treePath, _name];
			private _newTreePath = _treePath + [_index];

			// Store the full path in the tree data
			private _pathString = "/" + (_fullPath joinString "/");
			_treeCtrl tvSetData [_newTreePath, _pathString];

			// Set folder icon color (blue)
			_treeCtrl tvSetColor [_newTreePath, [0, 0.55, 0.97, 1]];

			// Check if trying to move into a subdirectory of the source
			private _srcPath = _sourcePointer joinString "/";
			if (_sourceFile != "") then {
				_srcPath = _srcPath + "/" + _sourceFile;
			};

			// If the destination starts with the source path, it's a subdirectory
			private _destPath = _fullPath joinString "/";
			private _isSubdir = ((_destPath + "/") find (_srcPath + "/") == 0);

			// Disable subdirectories of the source (can't move into itself)
			if (_isSubdir) then
			{
				_treeCtrl tvSetColor [_newTreePath, [0.5, 0.5, 0.5, 1]];
				_treeCtrl tvSetTooltip [_newTreePath, localize "STR_AE3_Main_Zeus_CannotMoveIntoSubdir"];
			} else {
				// Recursively add subdirectories
				private _subDirContent = _obj select 0;
				[_treeCtrl, _subDirContent, _fullPath, _newTreePath, _sourcePointer, _sourceFile] call AE3_main_fnc_zeus_filesystemBrowser_populateTree;
			};
		};
	};
} forEach _keys;
