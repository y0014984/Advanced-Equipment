/*
STRG + I für den Import aus dem Config File:
	configfile >> "PPS_Main_Dialog"
*/

class RscListbox;
class RscText;
class RscEdit;
class RscButton;
class RscSlider;

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