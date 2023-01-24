//hint format ["canSuspend: %1", canSuspend]; // true

#include "\a3\ui_f\hpp\definedikcodes.inc"

private _dialog = [] call AE3_armaos_fnc_retro_createCanvas;

// define key down event handler
private _upArrowFunc = { params ["_dialog"]; _dialog setVariable ["AE3_Retro_Snake_Dir", "up"]; };
private _downArrowFunc = { params ["_dialog"]; _dialog setVariable ["AE3_Retro_Snake_Dir", "down"]; };
private _leftArrowFunc = { params ["_dialog"]; _dialog setVariable ["AE3_Retro_Snake_Dir", "left"]; };
private _rightArrowFunc = { params ["_dialog"]; _dialog setVariable ["AE3_Retro_Snake_Dir", "right"]; };
private _escFunc = { params ["_dialog"]; closeDialog 1; _dialog setVariable ["AE3_Retro_Snake_Running", false]; };

// create keydown event handler HashMap
private _keyDownEventHandlerSettings = createHashMapFromArray
[
    [DIK_UPARROW, _upArrowFunc],
    [DIK_DOWNARROW, _downArrowFunc],
    [DIK_LEFTARROW, _leftArrowFunc],
    [DIK_RIGHTARROW, _rightArrowFunc],
    [DIK_ESCAPE, _escFunc]
];

// add event handlers
_dialog setVariable ["AE3_Retro_KeyDownEventHandlerSettings", _keyDownEventHandlerSettings];
[_dialog] call AE3_armaos_fnc_retro_addEventHandler;

// randomize starting direction
private _directions = ["up", "down", "left", "right"];
private _randDir = floor (random 4);
private _dir = _directions select _randDir;
_dialog setVariable ["AE3_Retro_Snake_Dir", _dir];

// get canvas dimensions
private _width = [_dialog] call AE3_armaos_fnc_retro_getCanvasWidth;
private _height = [_dialog] call AE3_armaos_fnc_retro_getCanvasHeight;

// init start position
private _pos = [floor (_width / 2), floor (_height / 2)];

// function adds a new segment to head of snake in current direction
private _addDirToSnakeFunc =
{
    params ["_snake", "_dir"];

    private _head = _snake select ((count _snake) - 1);

    _head params ["_x", "_y"];

    if (_dir isEqualTo "up") then { _y = _y - 1; };
    if (_dir isEqualTo "down") then { _y = _y + 1; };
    if (_dir isEqualTo "left") then { _x = _x - 1; };
    if (_dir isEqualTo "right") then { _x = _x + 1; };

    _head = [_x, _y];

    _snake pushBack _head;

    _snake;
};

// init snake with 8 segments
private _snake = [_pos];
for "_i" from 1 to 7 do { _snake = [_snake, _dir] call _addDirToSnakeFunc; };
{
    _x params ["_posX", "_posY"];
    [_dialog, _posX, _posY, [1,1,1,1]] call AE3_armaos_fnc_retro_setPixelColor;
} forEach _snake;

// function returns random position that does not collide with snake
private _getFoodSpawnPosFunc =
{
    params ["_snake", "_width", "_height"];

    private _spawnPos = [];

    private _posValid = false;

    while { !_posValid } do
    {
        _spawnPos = [floor (random _width), floor (random _height)];

        if (!(_spawnPos in _snake)) then { _posValid = true; };
    };

    _spawnPos;
};

// init food
private _food = [_snake, _width, _height] call _getFoodSpawnPosFunc;
_food params ["_x", "_y"];
[_dialog, _x, _y, [0,1,0,1]] call AE3_armaos_fnc_retro_setPixelColor;

// start game
_dialog setVariable ["AE3_Retro_Snake_Running", true];

// init grow phase
private _growPhase = false;
private _growMaxAmount = 3;
private _growAmount = 0;

// Game loop
while { _dialog getVariable "AE3_Retro_Snake_Running" } do
{
    // set snake speed
    private _speed = ceil ((count _snake) / 10);    // increase snake speed at new length 10, 20, 30 and so on

    _dir = _dialog getVariable "AE3_Retro_Snake_Dir";

    // grow snake in current dir
    _snake = [_snake, _dir] call _addDirToSnakeFunc;
    
    private _head = _snake select ((count _snake) - 1);
    _head params ["_x", "_y"];

    // if snake is out of canvas bounds then game over
    if ((_x < 0) || (_y < 0) || (_x == _width) || (_y == _height)) then { _dialog setVariable ["AE3_Retro_Snake_Running", false]; hint "Fallen. Game over!"; break; };

    // if snake collides with itself then game over
    private _findResult = _snake find _head;
    if (_findResult != ((count _snake) - 1)) then { _dialog setVariable ["AE3_Retro_Snake_Running", false]; hint "Bitten. Game over!"; break; };
    
    // draw pixel at new head pos
    [_dialog, _x, _y, [1,1,1,1]] call AE3_armaos_fnc_retro_setPixelColor;

    if (_head isEqualTo _food) then
    {
        // set new food position
        _food = [_snake, _width, _height] call _getFoodSpawnPosFunc;
        _food params ["_x", "_y"];
        [_dialog, _x, _y, [0,1,0,1]] call AE3_armaos_fnc_retro_setPixelColor;

        _growPhase = true;
        _growAmount = _growMaxAmount - 1 - 1; // minus 1 for start cycle and minus 1 for end cycle
    }
    else
    {
        if (_growPhase) then
        {
            if (_growAmount > 0) then 
            {
                _growAmount = _growAmount - 1;
            }
            else
            {
                _growPhase = false;
            };
        }
        else
        {
            // remove snake's tail
            private _tail = _snake select 0;
            _tail params ["_x", "_y"];
            [_dialog, _x, _y, [0,0,0,1]] call AE3_armaos_fnc_retro_setPixelColor;
            _snake deleteAt 0;
        };
    };

    hint format ["length: %1 \n speed: %2 \n grow phase: %3 \n grow amount: %4", (count _snake), _speed, _growPhase, _growAmount];

    sleep (0.5 / _speed);
};