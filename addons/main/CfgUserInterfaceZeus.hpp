/* ================================================================================ */

class RscText;
class RscEdit;
class RscCheckbox;
class RscButton;
class RscXSliderH;
class RscButtonMenuOK;
class RscButtonMenuCancel;

/* ================================================================================ */

class AE3_UserInterface_Zeus_Asset_Details
{
	idd = 16986;
	movingEnable = true;
	enableSimulation = true;

    onLoad = "params ['_display', ['_config', configNull]]; [_display] call AE3_main_fnc_zeus_initAttributes;";
    onUnload = "params ['_display', '_exitCode']; [_display, _exitCode] call AE3_main_fnc_zeus_updateAttributes;";

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
            text = "AE3 Asset Details"; //--- ToDo: Localize;
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 0 * GUI_GRID_H + GUI_GRID_Y;
            w = 40 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,1};
        };

        class RscText_1400: RscText
        {
            idc = 1400;
            text = "";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 39 * GUI_GRID_W;
            h = 6 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};
			style = ST_MULTI;
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

/* ================================================================================ */

class AE3_UserInterface_Zeus_Module_AddUser
{
	idd = 16986;
	movingEnable = true;
	enableSimulation = true;

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] call AE3_main_fnc_zeus_module_addUser;";
    onUnload = "params ['_display', '_exitCode']; [_display, _exitCode, 'onUnload'] call AE3_main_fnc_zeus_module_addUser;";

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
            text = "Module: Add User"; //--- ToDo: Localize;
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
			style = ST_MULTI;
			lineSpacing = 1;
        };

        class RscText_1001: RscText
        {
            idc = 1001;

            text = "Username"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1002: RscText
        {
            idc = 1002;

            text = "Password"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscEdit_1401: RscEdit
        {
            idc = 1401;
            text = "admin";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; private _newText = ctrlText _control; _display setVariable ['username', _newText];";
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['username', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _password = _display getVariable ['password', '']; if ((_newText isEqualTo '') || (_password isEqualTo '')) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscEdit_1402: RscEdit
        {
            idc = 1402;
            text = "admin123";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; private _newText = ctrlText _control; _display setVariable ['password', _newText];";
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['password', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _username = _display getVariable ['username', '']; if ((_newText isEqualTo '') || (_username isEqualTo '')) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

         class RscButtonMenuOK_2600: RscButtonMenuOK
        {
            x = 37 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['okCtrl', _control];";
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

/* ================================================================================ */

class AE3_UserInterface_Zeus_Module_AddSecurityCommands
{
	idd = 16986;
	movingEnable = true;
	enableSimulation = true;

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] call AE3_main_fnc_zeus_module_addSecurityCommands;";
    onUnload = "params ['_display', '_exitCode']; [_display, _exitCode, 'onUnload'] call AE3_main_fnc_zeus_module_addSecurityCommands;";

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
            text = "Module: Add Security Commands"; //--- ToDo: Localize;
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
			style = ST_MULTI;
			lineSpacing = 1;
        };

        class RscText_1001: RscText
        {
            idc = 1001;

            text = "crypto";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1002: RscText
        {
            idc = 1002;

            text = "crack";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscCheckbox_1401: RscCheckbox
        {
            idc = 1401;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1402: RscCheckbox
        {
            idc = 1402;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
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

/* ================================================================================ */

class AE3_UserInterface_Zeus_Module_AddGames
{
	idd = 16986;
	movingEnable = true;
	enableSimulation = true;

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] call AE3_main_fnc_zeus_module_addGames;";
    onUnload = "params ['_display', '_exitCode']; [_display, _exitCode, 'onUnload'] call AE3_main_fnc_zeus_module_addGames;";

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
            text = "Module: Add Games"; //--- ToDo: Localize;
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
			style = ST_MULTI;
			lineSpacing = 1;
        };

        class RscText_1001: RscText
        {
            idc = 1001;

            text = "snake";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscCheckbox_1401: RscCheckbox
        {
            idc = 1401;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
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

/* ================================================================================ */

class AE3_UserInterface_Zeus_Module_AddFile
{
	idd = 16986;
	movingEnable = true;
	enableSimulation = true;

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] call AE3_main_fnc_zeus_module_addFile;";
    onUnload = "params ['_display', '_exitCode']; [_display, _exitCode, 'onUnload'] call AE3_main_fnc_zeus_module_addFile;";

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
            text = "Module: Add File"; //--- ToDo: Localize;
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
			style = ST_MULTI;
			lineSpacing = 1;
        };

        class RscText_1001: RscText
        {
            idc = 1001;

            text = "Path"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscEdit_1401: RscEdit
        {
            idc = 1401;
            text = "/tmp/new/example.txt";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; private _newText = ctrlText _control; _display setVariable ['path', _newText];";
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['path', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _username = _display getVariable ['username', '']; if ((_newText isEqualTo '') || (_username isEqualTo '')) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscText_1002: RscText
        {
            idc = 1002;

            text = "File content"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscEdit_1402: RscEdit
        {
            idc = 1402;
            text = "Lorem ipsum dolor sit amet";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 4 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

			style = ST_MULTI;
			lineSpacing = 1;
        };

        class RscText_1003: RscText
        {
            idc = 1003;

            text = "Is code?"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscCheckbox_1301: RscCheckbox
        {
            idc = 1301;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 0;
        };

        class RscText_1004: RscText
        {
            idc = 1004;

            text = "File owner"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 16.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscEdit_1403: RscEdit
        {
            idc = 1403;
            text = "root";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 16.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; private _newText = ctrlText _control; _display setVariable ['username', _newText];";
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['username', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _path = _display getVariable ['path', '']; if ((_newText isEqualTo '') || (_path isEqualTo '')) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscText_1005: RscText
        {
            idc = 1005;

            text = "Permissions"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1006: RscText
        {
            idc = 1006;

            text = "R"; //--- ToDo: Localize;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1007: RscText
        {
            idc = 1007;

            text = "W"; //--- ToDo: Localize;
            x = 10 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1008: RscText
        {
            idc = 1008;

            text = "X"; //--- ToDo: Localize;
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1009: RscText
        {
            idc = 1009;

            text = "R"; //--- ToDo: Localize;
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1010: RscText
        {
            idc = 1010;

            text = "W"; //--- ToDo: Localize;
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1011: RscText
        {
            idc = 1011;

            text = "X"; //--- ToDo: Localize;
            x = 18 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1012: RscText
        {
            idc = 1012;

            text = "Owner"; //--- ToDo: Localize;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 18 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1013: RscText
        {
            idc = 1013;

            text = "Everyone"; //--- ToDo: Localize;
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 18 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscCheckbox_1302: RscCheckbox
        {
            idc = 1302;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1303: RscCheckbox
        {
            idc = 1303;
            x = 10 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1304: RscCheckbox
        {
            idc = 1304;
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 0;
        };

        class RscCheckbox_1305: RscCheckbox
        {
            idc = 1305;
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1306: RscCheckbox
        {
            idc = 1306;
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1307: RscCheckbox
        {
            idc = 1307;
            x = 18 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 0;
        };

         class RscButtonMenuOK_2600: RscButtonMenuOK
        {
            x = 37 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['okCtrl', _control];";
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

/* ================================================================================ */

class AE3_UserInterface_Zeus_Module_AddDir
{
	idd = 16986;
	movingEnable = true;
	enableSimulation = true;

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] call AE3_main_fnc_zeus_module_addDir;";
    onUnload = "params ['_display', '_exitCode']; [_display, _exitCode, 'onUnload'] call AE3_main_fnc_zeus_module_addDir;";

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
            text = "Module: Add Directory"; //--- ToDo: Localize;
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
			style = ST_MULTI;
			lineSpacing = 1;
        };

        class RscText_1001: RscText
        {
            idc = 1001;

            text = "Path"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscEdit_1401: RscEdit
        {
            idc = 1401;
            text = "/tmp/new";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; private _newText = ctrlText _control; _display setVariable ['path', _newText];";
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['path', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _username = _display getVariable ['username', '']; if ((_newText isEqualTo '') || (_username isEqualTo '')) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscText_1004: RscText
        {
            idc = 1004;

            text = "Directory owner"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscEdit_1403: RscEdit
        {
            idc = 1403;
            text = "root";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; private _newText = ctrlText _control; _display setVariable ['username', _newText];";
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['username', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _path = _display getVariable ['path', '']; if ((_newText isEqualTo '') || (_path isEqualTo '')) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscText_1005: RscText
        {
            idc = 1005;

            text = "Permissions"; //--- ToDo: Localize;
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1006: RscText
        {
            idc = 1006;

            text = "R"; //--- ToDo: Localize;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1007: RscText
        {
            idc = 1007;

            text = "W"; //--- ToDo: Localize;
            x = 10 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1008: RscText
        {
            idc = 1008;

            text = "X"; //--- ToDo: Localize;
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1009: RscText
        {
            idc = 1009;

            text = "R"; //--- ToDo: Localize;
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1010: RscText
        {
            idc = 1010;

            text = "W"; //--- ToDo: Localize;
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1011: RscText
        {
            idc = 1011;

            text = "X"; //--- ToDo: Localize;
            x = 18 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1012: RscText
        {
            idc = 1012;

            text = "Owner"; //--- ToDo: Localize;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 12 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1013: RscText
        {
            idc = 1013;

            text = "Everyone"; //--- ToDo: Localize;
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 12 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscCheckbox_1302: RscCheckbox
        {
            idc = 1302;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1303: RscCheckbox
        {
            idc = 1303;
            x = 10 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1304: RscCheckbox
        {
            idc = 1304;
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1305: RscCheckbox
        {
            idc = 1305;
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1306: RscCheckbox
        {
            idc = 1306;
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckbox_1307: RscCheckbox
        {
            idc = 1307;
            x = 18 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

         class RscButtonMenuOK_2600: RscButtonMenuOK
        {
            x = 37 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['okCtrl', _control];";
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

/* ================================================================================ */