/* ================================================================================ */

class RscText;
class RscEdit;
class RscXSliderH;
class RscButton;
class RscButtonMenuOK;
class RscButtonMenuCancel;

/* ================================================================================ */

class AE3_UserInterface_Zeus
{
	idd = 16986;
	movingEnable = true;
	enableSimulation = true;

    onLoad = "params ['_displayOrControl', ['_config', configNull]]; [_displayOrControl] call AE3_main_fnc_zeus_initAttributes;";
    onUnload = "params ['_display', '_exitCode']; if (_exitCode == 1) then { [_display] call AE3_main_fnc_zeus_updateAttributes; };";
    // ok = 1, cancel = 2

	class controlsBackground
	{
		// size 40x25
		class RscText_900: RscText
		{
			// Background
			idc = 900;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 21 * GUI_GRID_H;
			colorBackground[] = {0.2,0.2,0.2,1}; // light grey
		};
	};

	class controls
	{
        class RscText_1000: RscText
        {
            idc = 1000;
            text = "Headline"; //--- ToDo: Localize;
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 0 * GUI_GRID_H + GUI_GRID_Y;
            w = 40 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,1};
        };

        class RscText_1400: RscText
        {
            idc = 1400;
            text = "Details\nline2\nline3"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 39 * GUI_GRID_W;
            h = 6 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};
			style = ST_MULTI + ST_NO_RECT;
			lineSpacing = 1;
        };

        class RscText_1001: RscText
        {
            idc = 1001;

            text = "Battery Level"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1002: RscText
        {
            idc = 1002;

            text = "Fuel Level"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscSlider_1900: RscXSliderH
        {
            idc = 1900;
            sliderPosition = 0;
            sliderRange[] = {0,100};
            sliderStep = 1;

            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 28 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['batterySliderCtrl', _control];";
            onSliderPosChanged = "params ['_control', '_newValue']; private _display = ctrlParent _control; private _text = _display getVariable 'batteryTextCtrl'; _text ctrlSetText format ['%1%2', _newValue, '%'];";
        };

        class RscSlider_1901: RscXSliderH
        {
            idc = 1901;
            sliderPosition = 0;
            sliderRange[] = {0,100};
            sliderStep = 1;

            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 28 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['fuelSliderCtrl', _control];";
            onSliderPosChanged = "params ['_control', '_newValue']; private _display = ctrlParent _control; private _text = _display getVariable 'fuelTextCtrl'; _text ctrlSetText format ['%1%2', _newValue, '%'];";
        };

        class RscEdit_1401: RscEdit
        {
            idc = 1401;
            text = "0%"; //--- ToDo: Localize;
            x = 36.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['batteryTextCtrl', _control];"; 
            //onEditChanged = "params ['_control', '_newText']; private _display = ctrlParent _control; private _slider = _display getVariable 'batterySliderCtrl'; private _newValue = (round (_newText call BIS_fnc_parseNumber)); _slider sliderSetPosition _newValue; _control ctrlSetText format ['%1%2', _newValue, '%'];";
            onKillFocus = "params ['_control']; private _newText = ctrlText _control; _newText = [_newText, '0123456789.,'] call BIS_fnc_filterString; private _display = ctrlParent _control; private _slider = _display getVariable 'batterySliderCtrl'; private _newValue = ((round (_newText call BIS_fnc_parseNumber)) min 100); _slider sliderSetPosition _newValue; _control ctrlSetText format ['%1%2', _newValue, '%'];";
        };

        class RscEdit_1402: RscEdit
        {
            idc = 1402;
            text = "0%"; //--- ToDo: Localize;
            x = 36.5 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['fuelTextCtrl', _control];"; 
            //onEditChanged = "params ['_control', '_newText']; private _display = ctrlParent _control; private _slider = _display getVariable 'batterySliderCtrl'; private _newValue = (round (_newText call BIS_fnc_parseNumber)); _slider sliderSetPosition _newValue; _control ctrlSetText format ['%1%2', _newValue, '%'];";
            onKillFocus = "params ['_control']; private _newText = ctrlText _control; _newText = [_newText, '0123456789.,'] call BIS_fnc_filterString; private _display = ctrlParent _control; private _slider = _display getVariable 'fuelSliderCtrl'; private _newValue = ((round (_newText call BIS_fnc_parseNumber)) min 100); _slider sliderSetPosition _newValue; _control ctrlSetText format ['%1%2', _newValue, '%'];";
        };

        class RscButton_2100: RscButton
        {
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "CLOSE";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_closeDevice;";
        };

        class RscButton_2200: RscButton
        {
            x = 4 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "OPEN";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_openDevice;";
        };

        class RscButton_2300: RscButton
        {
            x = 7.5 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 4 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "STANDBY";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_standbyDevice;";
        };

        class RscButton_2400: RscButton
        {
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 4 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "TURN OFF";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_turnOffDevice;";
        };

        class RscButton_2500: RscButton
        {
            x = 16.5 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 4 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "TURN ON";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_turnOnDevice;";
        };

        class RscButtonMenuOK_2600: RscButtonMenuOK
        {
            x = 37 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
        };

        class RscButtonMenuCancel_2700: RscButtonMenuCancel
        {
            x = 31 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
        };
	};
};
