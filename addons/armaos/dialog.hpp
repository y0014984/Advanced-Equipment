class RscListbox;
class RscText;
class RscStructuredText;
class RscEdit;
class RscButton;
class RscSlider;
class RscPicture;
class RscPictureKeepAspect;

/* ================================================================================ */

class AE3_ArmaOS_Retro_Dialog
{
	idd = 15985;
	movingEnable = "true";
	enableSimulation = "true";

	class ControlsBackground
	{
		class AE3_ArmaOS_Retro_Background: RscText
		{
			idc = 2000;
			text = "";
			colorBackground[] = {0,0,0,0};
			x = 0;
			y = 0;
			w = "pixelW * pixelGrid * 1";
			h = "pixelH * pixelGrid * 1";
		};
	};
};

/* ================================================================================ */

class AE3_ArmaOS_Main_Dialog
{
	idd = 15984;
	movingEnable = "true"; // allow moving window by dragging the element with: moving = "true"
	enableSimulation = "true";
	class controlsBackground
	{
		// size 40x25
		class RscText_900: RscText
		{
			// Terminal Header Background
			idc = 900;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 2 * GUI_GRID_H;
			colorBackground[] = {0.125,0.125,0.125,1}; // dark grey
		};
		class RscText_910: RscText
		{
			// Console Output Background
			idc = 910;
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 23 * GUI_GRID_H;
			colorBackground[] = {0.2,0.2,0.2,1}; // light grey
		};
	};
	class controls
	{
		class RscText_1000: RscText
		{
			// Terminal Header
			idc = 1000;
			text = "YOO INDUSTRIES COMPUTER";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 0.25 * GUI_GRID_H + GUI_GRID_Y;
			w = 29.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0}; // transparent
			colorText[] = {1,1,1,1}; // white
			font = "EtelkaMonospaceProBold";
			shadow = 0;
			moving = "true"; // drag title bar to move window
		};
		class RscText_1100: RscStructuredText
		{
			// Console Output
			idc = 1100;
			text = "";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 39 * GUI_GRID_W;
			h = 22 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0}; // transparent
			colorText[] = {1,1,1,1}; // white
			font = "EtelkaMonospacePro";
			shadow = 0;
			style = ST_MULTI;
			lineSpacing = 1;
		};
		class RscEdit_1150: RscEdit
		{
			// Console multilingual Input
			idc = 1150;
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 39 * GUI_GRID_W;
			h = 22 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0}; // transparent
			colorText[] = {0,0,0,0}; // transparent

		};
		class RscButton_1050: RscButton
		{
			// Battery Symbol
			idc = 1050;
			text = "\z\ae3\addons\armaos\images\AE3_battery_0_percent.paa";
			x = 34 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 2 * GUI_GRID_W;
			h = 2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0}; // transparent
			colorBackgroundActive[] = {0,0,0,0.2}; // darken
			colorText[] = {1,1,1,1}; // white; this could prohibit to change color to yellow and red on low battery levels, but is necessary for design changes
			style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
			action = "[(uiNamespace getVariable 'AE3_Battery'), true] call AE3_power_fnc_getBatteryLevel; ctrlSetFocus (uiNamespace getVariable 'AE3_ConsoleOutput');";
			tooltip = "check battery level";
		};
		class RscButton_1320: RscButton
		{
			// Change Design Symbol
			idc = 1320;
			text = "\z\ae3\addons\armaos\images\AE3_bucket.paa";
			x = 36 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 2 * GUI_GRID_W;
			h = 2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0}; // transparent
			colorBackgroundActive[] = {0,0,0,0.2}; // darken
			colorText[] = {1,1,1,1}; // white
			style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
			tooltip = "change terminal design";
		};
		class RscButton_1300: RscButton
		{
			// Close Button
			idc = 1300;
			text = "\z\ae3\addons\armaos\images\AE3_close.paa";
			x = 38 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 2 * GUI_GRID_W;
			h = 2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0}; // transparent
			colorBackgroundActive[] = {0,0,0,0.2}; // darken
			colorText[] = {1,1,1,1}; // white
			style = ST_PICTURE + ST_KEEP_ASPECT_RATIO;
			action = "closeDialog 1;";
			tooltip = "close armaOS";
		};
	};
};

/* ================================================================================ */

class AE3_ArmaOS_Waiting_Dialog
{
	idd = 16983;
	movingEnable = "true";
	enableSimulation = "true";
	class controls
	{
		class RscText_1000: RscText
		{
			idc = 3000;
			text = "WAITING";
			x = 10 * GUI_GRID_W + GUI_GRID_X;
			y = 10 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
			font = "EtelkaMonospaceProBold";
		};
		class RscText_1100: RscText
		{
			// Console Output
			idc = 3100;
			text = "Waiting for other computer to accept connection";
			x = 10 * GUI_GRID_W + GUI_GRID_X;
			y = 12 * GUI_GRID_H + GUI_GRID_Y;
			w = 20 * GUI_GRID_W;
			h = 3 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			
			style = ST_MULTI;
			lineSpacing = 1;
			font = "EtelkaMonospacePro";
		};
		class RscButton_1300: RscButton
		{
			idc = 3300;
			text = "CANCEL";
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 15.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
			
			action = "closeDialog 1;";
			font = "EtelkaMonospaceProBold";
		};
	};
};

/* ================================================================================ */