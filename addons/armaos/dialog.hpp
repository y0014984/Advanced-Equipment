class RscListbox;
class RscText;
class RscStructuredText;
class RscEdit;
class RscButton;
class RscSlider;
class RscPicture;
class RscPictureKeepAspect;

/* ================================================================================ */

class AE3_ArmaOS_Main_Dialog
{
	idd = 15984;
	movingEnable = true;
	enableSimulation = true;
	class controlsBackground
	{
		class RscText_1000: RscText
		{
			idc = 1000;
			text = "TERMINAL";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
			font = "EtelkaMonospaceProBold";
		};
		class RscPicture_1050: RscPictureKeepAspect
		{
			idc = 1050;
			text = "\z\ae3\addons\armaos\images\AE3_battery_0_percent.paa";
			x = 38 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 1.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class RscText_1100: RscStructuredText
		{
			// Console Output
			idc = 1100;
			text = "";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 21 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			
			style = ST_MULTI;
			lineSpacing = 1;
			font = "EtelkaMonospacePro";
		};
		class RscButton_1300: RscButton
		{
			idc = 1300;
			text = "EXIT";
			x = 32 * GUI_GRID_W + GUI_GRID_X;
			y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
			
			action = "closeDialog 1;";
			font = "EtelkaMonospaceProBold";
		};
		class RscButton_1310: RscButton
		{
			idc = 1310;
			text = "KEYBOARD";
			x = 23.5 * GUI_GRID_W + GUI_GRID_X;
			y = 23.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.5};
			
			font = "EtelkaMonospaceProBold";
		};
	};
	class controls
	{
		class RscPicture_1500: RscPicture
		{
			// Damaged Overlay; size max 40x25 GUI_GRID
			idc = 1500;
			text = "";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 25 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0}; // transparent
		};
	};
};

/* ================================================================================ */

class AE3_ArmaOS_Waiting_Dialog
{
	idd = 16983;
	movingEnable = true;
	enableSimulation = true;
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