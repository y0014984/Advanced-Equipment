_mode = param [0,"",[""]];
_input = param [1,[],[[]]];

switch _mode do
{
	// Default object init
	case "init":
	{
		_logic = _input param [0, objNull, [objNull]]; // Module logic
		_isActivated = _input param [1, true, [true]]; // True when the module was activated, false when it is deactivated
		_isCuratorPlaced = _input param [2, false, [true]]; // True if the module was placed by Zeus
		// ... code here...
	};
	// When some attributes were changed (including position and rotation)
	case "attributesChanged3DEN": 
	{
		_logic = _input param [0, objNull, [objNull]];
		// ... code here...
	};
	// When added to the world (e.g., after undoing and redoing creation)
	case "registeredToWorld3DEN": 
	{
		_logic = _input param [0, objNull, [objNull]];
		// ... code here...
	};
	// When removed from the world (i.e., by deletion or undoing creation)
	case "unregisteredFromWorld3DEN": 
	{
		_logic = _input param [0, objNull, [objNull]];
		// ... code here...
	};
	// When connection to object changes (i.e., new one is added or existing one removed)
	case "connectionChanged3DEN": 
	{
		_logic = _input param [0, objNull, [objNull]];
		// ... code here...
	};
	// When object is being dragged
	case "dragged3DEN": 
	{
		_logic = _input param [0, objNull, [objNull]];
		// ...code here...
	};
};
true