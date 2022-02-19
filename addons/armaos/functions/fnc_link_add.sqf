params['_computer', '_name', '_path', ['_description', ''], ['_man', '']];

private _links = _computer getVariable ['AE3_Links', createHashMap];

if(_name in _links) then
{
	throw "Link already exists!";
};

_links set [_name, [_path, _description, _man]];

_computer setVariable ['AE3_Links', _links, True];