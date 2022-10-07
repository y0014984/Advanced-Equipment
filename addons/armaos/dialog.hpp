class RscListbox;
class RscText;
class RscStructuredText;
class RscEdit;
class RscButton;
class RscSlider;

/* ================================================================================ */

class AE3_Rotate_Dialog
{
	idd = 14985;
	movingEnable = true;
	enableSimulation = true;
	class controls
	{
		class AE3_RscText_2000: RscText
		{
			idc = 2000;
			text = "Rotate";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,1};
		};
		class AE3_RscSlider_2500: RscEdit
		{
			idc = 2500;
			text = "";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;

			deletable = 0;
			fade = 0;
			access = 0;
			type = CT_SLIDER;
			style = SL_HORZ;
			color[] = {1,1,1,0.8};
			colorActive[] = {1,1,1,1};
			shadow = 0;		
		};
	};
};

/* ================================================================================ */

class AE3_ArmaOS_Main_Dialog
{
	idd = 15984;
	movingEnable = true;
	enableSimulation = true;
	class controls
	{
		class RscText_1000: RscText
		{
			idc = 1000;
			text = "TERMINAL";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 40 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0.5,0,0.25};
			font = "EtelkaMonospaceProBold";
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
			colorBackground[] = {0,0,0,0.35};
			
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
			colorBackground[] = {0,0.5,0,0.25};
			
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
			colorBackground[] = {0,0.5,0,0.25};
			
			font = "EtelkaMonospaceProBold";
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
			colorBackground[] = {0,0.5,0,0.25};
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
			colorBackground[] = {0,0,0,0.25};
			
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
			colorBackground[] = {0,0.5,0,0.25};
			
			action = "closeDialog 1;";
			font = "EtelkaMonospaceProBold";
		};
	};
};

/* ================================================================================ */