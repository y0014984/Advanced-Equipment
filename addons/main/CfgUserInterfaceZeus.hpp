/* ================================================================================ */

class RscText;
class RscEdit;
class RscCheckBox;
class RscButton;
class RscCombo;
class RscXSliderH;
class RscTree;
class RscButtonMenuOK;
class RscButtonMenuCancel;

/* ================================================================================ */

class AE3_UserInterface_Zeus_Asset_Details
{
	idd = 16986;
	movingEnable = "true";
	enableSimulation = "true";

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
            text = "$STR_AE3_Main_Zeus_AssetDetails";

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
            text = "$STR_AE3_Main_Zeus_BatteryLevel";

            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1002: RscText
        {
            idc = 1002;
            text = "$STR_AE3_Main_Zeus_FuelLevel";

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

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['batterySliderCtrl', _control]; _control ctrlEnable false;";
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

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['fuelSliderCtrl', _control]; _control ctrlEnable false;";
            onSliderPosChanged = "params ['_control', '_newValue']; private _display = ctrlParent _control; private _text = _display getVariable 'fuelTextCtrl'; _text ctrlSetText format ['%1%2', _newValue, '%'];";
        };

        class RscEdit_1401: RscEdit
        {
            idc = 1401;
            text = "0%";

            x = 36.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['batteryTextCtrl', _control]; _control ctrlEnable false;"; 
            //onEditChanged = "params ['_control', '_newText']; private _display = ctrlParent _control; private _slider = _display getVariable 'batterySliderCtrl'; private _newValue = (round (_newText call BIS_fnc_parseNumber)); _slider sliderSetPosition _newValue; _control ctrlSetText format ['%1%2', _newValue, '%'];";
            onKillFocus = "params ['_control']; private _newText = ctrlText _control; _newText = [_newText, '0123456789.,'] call BIS_fnc_filterString; private _display = ctrlParent _control; private _slider = _display getVariable 'batterySliderCtrl'; private _newValue = ((round (_newText call BIS_fnc_parseNumber)) min 100); _slider sliderSetPosition _newValue; _control ctrlSetText format ['%1%2', _newValue, '%'];";
        };

        class RscEdit_1402: RscEdit
        {
            idc = 1402;
            text = "0%";

            x = 36.5 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['fuelTextCtrl', _control]; _control ctrlEnable false;"; 
            //onEditChanged = "params ['_control', '_newText']; private _display = ctrlParent _control; private _slider = _display getVariable 'batterySliderCtrl'; private _newValue = (round (_newText call BIS_fnc_parseNumber)); _slider sliderSetPosition _newValue; _control ctrlSetText format ['%1%2', _newValue, '%'];";
            onKillFocus = "params ['_control']; private _newText = ctrlText _control; _newText = [_newText, '0123456789.,'] call BIS_fnc_filterString; private _display = ctrlParent _control; private _slider = _display getVariable 'fuelSliderCtrl'; private _newValue = ((round (_newText call BIS_fnc_parseNumber)) min 100); _slider sliderSetPosition _newValue; _control ctrlSetText format ['%1%2', _newValue, '%'];";
        };

        class RscText_1600: RscText
        {
            idc = 1600;
            text = "$STR_AE3_Main_Zeus_FileExplorer";

            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 12 * GUI_GRID_H + GUI_GRID_Y;
            w = 19.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };

        class RscTree_1500: RscTree
        {
            idc = 1500;

            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 19.5 * GUI_GRID_W;
            h = 8.5 * GUI_GRID_H;

            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['fileExplorerCtrl', _control];"; 

            onTreeSelChanged = "params ['_control', '_selectionPath']; _control setVariable ['selectionPath', _selectionPath]; private _display = ctrlParent _control; private _fileContentCtrl = _display getVariable ['fileContentCtrl', controlNull]; private _updateButtonCtrl = _display getVariable ['updateButtonCtrl', controlNull]; private _fileContent = _control tvData _selectionPath; _fileContentCtrl ctrlSetText _fileContent; if (_fileContent isEqualTo '') then {_fileContentCtrl ctrlEnable false; _updateButtonCtrl ctrlEnable false;} else {_fileContentCtrl ctrlEnable true; _updateButtonCtrl ctrlEnable true;};";
        };

        class RscText_1601: RscText
        {
            idc = 1601;
            text = "$STR_AE3_Main_Zeus_FileContent";

            x = 20.5 * GUI_GRID_W + GUI_GRID_X;
            y = 12 * GUI_GRID_H + GUI_GRID_Y;
            w = 19 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
        };

        class RscEdit_1501: RscEdit
        {
            idc = 1501;
            text = "";

            x = 20.5 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 19 * GUI_GRID_W;
            h = 7 * GUI_GRID_H;

            colorBackground[] = {-1,-1,-1,0.5};
			style = ST_MULTI;
			lineSpacing = 1;

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['fileContentCtrl', _control];";
        };

        class RscButton_2100: RscButton
        {
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "$STR_AE3_Main_Zeus_Close";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_closeObject;";
        };

        class RscButton_2200: RscButton
        {
            x = 3.5 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "$STR_AE3_Main_Zeus_Open";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_openObject;";
        };

        class RscButton_2300: RscButton
        {
            x = 7 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 4 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "$STR_AE3_Main_Zeus_Standby";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_standbyDevice;";
        };

        class RscButton_2400: RscButton
        {
            x = 11.5 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 4 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "$STR_AE3_Main_Zeus_TurnOff";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_turnOffDevice;";
        };

        class RscButton_2500: RscButton
        {
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 4 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "$STR_AE3_Main_Zeus_TurnOn";

            onButtonClick = "params ['_control']; [] call AE3_main_fnc_zeus_turnOnDevice;";
        };

        class RscButton_2600: RscButton
        {
            x = 35.5 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 4 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "$STR_AE3_Main_Zeus_Update";

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['updateButtonCtrl', _control];";

            onButtonClick = "params ['_control']; [_control] call AE3_main_fnc_zeus_updateFileContent;";
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
	idd = 16987;
	movingEnable = "true";
	enableSimulation = "true";

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] spawn AE3_main_fnc_zeus_module_addUser;";
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
            text = "$STR_AE3_Main_Zeus_Module_AddUser";
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 0 * GUI_GRID_H + GUI_GRID_Y;
            w = 40 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,1};
        };

        class RscText_1400: RscText
        {
            idc = 1400;
            text = "$STR_AE3_Main_Zeus_Module_AddUser_Description";
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

            text = "$STR_AE3_Main_Zeus_Username";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1002: RscText
        {
            idc = 1002;

            text = "$STR_AE3_Main_Zeus_Password";
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
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['username', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _password = _display getVariable ['password', '']; if ((_newText isEqualTo '') || (_password isEqualTo '') || ((_newText find ' ') != -1)) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
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
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['password', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _username = _display getVariable ['username', '']; if ((_newText isEqualTo '') || (_username isEqualTo '') || ((_username find ' ') != -1)) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
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
	idd = 16988;
	movingEnable = "true";
	enableSimulation = "true";

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] spawn AE3_main_fnc_zeus_module_addSecurityCommands;";
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
            text = "$STR_AE3_Main_Zeus_Module_AddSecurityCommands";
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 0 * GUI_GRID_H + GUI_GRID_Y;
            w = 40 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,1};
        };

        class RscText_1400: RscText
        {
            idc = 1400;
            text = "$STR_AE3_Main_Zeus_Module_AddSecurityCommands_Description";
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

        class RscCheckBox_1401: RscCheckBox
        {
            idc = 1401;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1402: RscCheckBox
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
	idd = 16989;
	movingEnable = "true";
	enableSimulation = "true";

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] spawn AE3_main_fnc_zeus_module_addGames;";
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
            text = "$STR_AE3_Main_Zeus_Module_AddGames";
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 0 * GUI_GRID_H + GUI_GRID_Y;
            w = 40 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,1};
        };

        class RscText_1400: RscText
        {
            idc = 1400;
            text = "$STR_AE3_Main_Zeus_Module_AddGames_Description";
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

        class RscCheckBox_1401: RscCheckBox
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
	idd = 16990;
	movingEnable = "true";
	enableSimulation = "true";

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] spawn AE3_main_fnc_zeus_module_addFile;";
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
            text = "$STR_AE3_Main_Zeus_Module_AddFile";
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 0 * GUI_GRID_H + GUI_GRID_Y;
            w = 40 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,1};
        };

        class RscText_1400: RscText
        {
            idc = 1400;
            text = "$STR_AE3_Main_Zeus_Module_AddFile_Description";
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

            text = "$STR_AE3_Main_Zeus_Path";
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
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['path', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _username = _display getVariable ['username', '']; private _key = _display getVariable ['key', '']; if ((_newText isEqualTo '') || (_username isEqualTo '') || (_key isEqualTo '') || ((_newText find ' ') != -1) || ((_username find ' ') != -1)) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscText_1002: RscText
        {
            idc = 1002;

            text = "$STR_AE3_Main_Zeus_FileContent";
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

            text = "$STR_AE3_Main_Zeus_IsCode";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscCheckBox_1301: RscCheckBox
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

            text = "$STR_AE3_Main_Zeus_FileOwner";
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
            w = 11 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; private _newText = ctrlText _control; _display setVariable ['username', _newText];";
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['username', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _path = _display getVariable ['path', '']; private _key = _display getVariable ['key', '']; if ((_newText isEqualTo '') || (_path isEqualTo '') || (_key isEqualTo '') || ((_newText find ' ') != -1) || ((_path find ' ') != -1)) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscText_1005: RscText
        {
            idc = 1005;

            text = "$STR_AE3_Main_Zeus_Permissions";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1006: RscText
        {
            idc = 1006;

            text = "R";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1007: RscText
        {
            idc = 1007;

            text = "W";
            x = 10 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1008: RscText
        {
            idc = 1008;

            text = "X";
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1009: RscText
        {
            idc = 1009;

            text = "R";
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1010: RscText
        {
            idc = 1010;

            text = "W";
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1011: RscText
        {
            idc = 1011;

            text = "X";
            x = 18 * GUI_GRID_W + GUI_GRID_X;
            y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1012: RscText
        {
            idc = 1012;

            text = "$STR_AE3_Main_Zeus_Owner";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 18 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1013: RscText
        {
            idc = 1013;

            text = "$STR_AE3_Main_Zeus_Everyone";
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 18 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscCheckBox_1302: RscCheckBox
        {
            idc = 1302;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1303: RscCheckBox
        {
            idc = 1303;
            x = 10 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1304: RscCheckBox
        {
            idc = 1304;
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 0;
        };

        class RscCheckBox_1305: RscCheckBox
        {
            idc = 1305;
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1306: RscCheckBox
        {
            idc = 1306;
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1307: RscCheckBox
        {
            idc = 1307;
            x = 18 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 0;
        };

        class RscText_1014: RscText
        {
            idc = 1014;

            text = "$STR_AE3_Main_Zeus_EnableEncryption";
            x = 21 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 8 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscCheckBox_1308: RscCheckBox
        {
            idc = 1308;
            x = 29.5 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 0;

            onCheckedChanged = "params ['_control', '_checked']; private _display = ctrlParent _control; private _algorithmCtrl = _display getVariable ['algorithmCtrl', objNull]; private _keyCtrl = _display getVariable ['keyCtrl', objNull]; if (_checked == 1) then { _checked = true; } else { _checked = false; }; _algorithmCtrl ctrlEnable _checked; _keyCtrl ctrlEnable _checked;";
        };

        class RscText_1015: RscText
        {
            idc = 1015;

            text = "$STR_AE3_Main_Zeus_EncryptionAlgorithm";
            x = 21 * GUI_GRID_W + GUI_GRID_X;
            y = 16.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 8 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscCombo_1501: RscCombo
        {
            idc = 1501;
            x = 29.5 * GUI_GRID_W + GUI_GRID_X;
            y = 16.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 10 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            class Items
            {
                class ItemPower
                {
                    text = "$STR_AE3_Main_Zeus_Caesar";
                    default = 1;
                };
                class ItemNetwork
                {
                    text = "$STR_AE3_Main_Zeus_Columnar";
                };
            };

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['algorithmCtrl', _control]; _control ctrlEnable false;";
        };

        class RscText_1016: RscText
        {
            idc = 1016;

            text = "$STR_AE3_Main_Zeus_EncryptionKey";
            x = 21 * GUI_GRID_W + GUI_GRID_X;
            y = 18 * GUI_GRID_H + GUI_GRID_Y;
            w = 8 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscEdit_1405: RscEdit
        {
            idc = 1405;
            text = "13";
            x = 29.5 * GUI_GRID_W + GUI_GRID_X;
            y = 18 * GUI_GRID_H + GUI_GRID_Y;
            w = 10 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            onLoad = "params ['_control']; private _display = ctrlParent _control; _display setVariable ['keyCtrl', _control]; _control ctrlEnable false; private _key = ctrlText _control; _display setVariable ['key', _key];";
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _key = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['key', _key]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _username = _display getVariable ['username', '']; private _path = _display getVariable ['path', '']; if ((_key isEqualTo '') || (_username isEqualTo '') || (_path isEqualTo '')) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
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

class AE3_UserInterface_Zeus_Module_AddDir
{
	idd = 16991;
	movingEnable = "true";
	enableSimulation = "true";

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] spawn AE3_main_fnc_zeus_module_addDir;";
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
            text = "$STR_AE3_Main_Zeus_Module_AddDir";
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 0 * GUI_GRID_H + GUI_GRID_Y;
            w = 40 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,1};
        };

        class RscText_1400: RscText
        {
            idc = 1400;
            text = "$STR_AE3_Main_Zeus_Module_AddDir_Description";
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

            text = "$STR_AE3_Main_Zeus_Path";
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
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['path', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _username = _display getVariable ['username', '']; if ((_newText isEqualTo '') || (_username isEqualTo '') || ((_newText find ' ') != -1) || ((_username find ' ') != -1)) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscText_1004: RscText
        {
            idc = 1004;

            text = "$STR_AE3_Main_Zeus_DirOwner";
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
            onKeyUp = "params ['_control', '_key', '_shift', '_ctrl', '_alt']; private _newText = ctrlText _control; private _display = ctrlParent _control; _display setVariable ['username', _newText]; private _okCtrl = _display getVariable ['okCtrl', objNull]; private _path = _display getVariable ['path', '']; if ((_newText isEqualTo '') || (_path isEqualTo '') || ((_newText find ' ') != -1) || ((_path find ' ') != -1)) then { _okCtrl ctrlEnable false; } else { _okCtrl ctrlEnable true; };";
            // With release of Arma 3 2.14, the onEditChanged event handler is available
            //onEditChanged = "params ['_control', '_newText'];";
        };

        class RscText_1005: RscText
        {
            idc = 1005;

            text = "$STR_AE3_Main_Zeus_Permissions";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1006: RscText
        {
            idc = 1006;

            text = "R";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1007: RscText
        {
            idc = 1007;

            text = "W";
            x = 10 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1008: RscText
        {
            idc = 1008;

            text = "X";
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1009: RscText
        {
            idc = 1009;

            text = "R";
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1010: RscText
        {
            idc = 1010;

            text = "W";
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1011: RscText
        {
            idc = 1011;

            text = "X";
            x = 18 * GUI_GRID_W + GUI_GRID_X;
            y = 13.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1012: RscText
        {
            idc = 1012;

            text = "$STR_AE3_Main_Zeus_Owner";
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 12 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscText_1013: RscText
        {
            idc = 1013;

            text = "$STR_AE3_Main_Zeus_Everyone";
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 12 * GUI_GRID_H + GUI_GRID_Y;
            w = 5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_CENTER;
        };

        class RscCheckBox_1302: RscCheckBox
        {
            idc = 1302;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1303: RscCheckBox
        {
            idc = 1303;
            x = 10 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1304: RscCheckBox
        {
            idc = 1304;
            x = 12 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1305: RscCheckBox
        {
            idc = 1305;
            x = 14 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1306: RscCheckBox
        {
            idc = 1306;
            x = 16 * GUI_GRID_W + GUI_GRID_X;
            y = 15 * GUI_GRID_H + GUI_GRID_Y;
            w = 1 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            checked = 1;
        };

        class RscCheckBox_1307: RscCheckBox
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

class AE3_UserInterface_Zeus_Module_AddConnection
{
	idd = 16992;
	movingEnable = "true";
	enableSimulation = "true";

    onLoad = "params ['_display', ['_config', configNull]]; [_display, 0, 'onLoad'] call AE3_main_fnc_zeus_module_addConnection;";
    onUnload = "params ['_display', '_exitCode']; [_display, _exitCode, 'onUnload'] call AE3_main_fnc_zeus_module_addConnection;";

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
            text = "$STR_AE3_Main_Zeus_Module_AddConnection";
            x = 0 * GUI_GRID_W + GUI_GRID_X;
            y = 0 * GUI_GRID_H + GUI_GRID_Y;
            w = 40 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,1};
        };

        class RscText_1400: RscText
        {
            idc = 1400;
            text = "$STR_AE3_Main_Zeus_Module_AddConnection_Description";
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

            text = "$STR_AE3_Main_Zeus_FromConsumer";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1401: RscText
        {
            idc = 1401;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 9 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};
        };

        class RscText_1004: RscText
        {
            idc = 1004;

            text = "$STR_AE3_Main_Zeus_ToProvider";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscText_1402: RscText
        {
            idc = 1402;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};
        };

        class RscText_1005: RscText
        {
            idc = 1005;

            text = "$STR_AE3_Main_Zeus_ConnectionType";
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 12 * GUI_GRID_H + GUI_GRID_Y;
            w = 7 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;

            style = ST_RIGHT;
        };

        class RscCombo_1501: RscCombo
        {
            idc = 1501;
            x = 8 * GUI_GRID_W + GUI_GRID_X;
            y = 12 * GUI_GRID_H + GUI_GRID_Y;
            w = 31.5 * GUI_GRID_W;
            h = 1 * GUI_GRID_H;
            colorBackground[] = {-1,-1,-1,0.5};

            class Items
            {
                class ItemPower
                {
                    text = "$STR_AE3_Main_Zeus_Power";
                    default = 1;
                };
                class ItemNetwork
                {
                    text = "$STR_AE3_Main_Zeus_Network";
                };
            };
        };

        class RscButton_2100: RscButton
        {
            x = 0.5 * GUI_GRID_W + GUI_GRID_X;
            y = 21 * GUI_GRID_H + GUI_GRID_Y;
            w = 3 * GUI_GRID_W;
            h = 1.5 * GUI_GRID_H;

            text = "$STR_AE3_Main_Zeus_Switch";

            onButtonClick = "params ['_control']; private _display = ctrlParent _control; private _switch = _display getVariable ['switch', false]; if (_switch) then { _switch = false; } else { _switch = true; }; _display setVariable ['switch', _switch]; private _fromCtrl = _display displayCtrl 1401; private _toCtrl = _display displayCtrl 1402; private _fromText = ctrlText _fromCtrl; private _toText = ctrlText _toCtrl; _fromCtrl ctrlSetText _toText; _toCtrl ctrlSetText _fromText;";
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