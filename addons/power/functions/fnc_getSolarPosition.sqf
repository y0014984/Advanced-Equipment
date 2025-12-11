/*
 * Author: Root, Wasserstoff
 * Description: Calculates approximate sun position (zenith and azimuth angles) for current mission date and map location. Uses simplified astronomical formulas valid for dates between 1950 and 2050. Accounts for map latitude/longitude and approximates timezone from longitude. Defaults to Altis coordinates if map has no position data. Source: https://en.wikipedia.org/wiki/Position_of_the_Sun
 *
 * Arguments:
 * None (uses global date variable)
 *
 * Return Value:
 * [Solar zenith angle in degrees, Solar azimuth angle in degrees] <ARRAY>
 *
 * Example:
 * private _sunPos = call AE3_power_fnc_getSolarPosition;
 * _sunPos params ["_zenith", "_azimuth"];
 *
 * Public: No
 */

date params ['_year', '_month', '_day', '_hours', '_minutes'];

/* Get map coordinates */
private _latitude = -getNumber (configFile >> "CfgWorlds" >> worldName >> "latitude"); // Arma uses southing for the latitude for some reason
private _longitude = getNumber (configFile >> "CfgWorlds" >> worldName >> "longitude");

// Default values (Altis)
if(_latitude == 0 && _longitude == 0) then
{
    _latitude = 35.152;
    _longitude = 16.661;
};

// Approximate timezone by longitude
private _timezone = _longitude/180 * 12;

/* Calculating ecliptic coordinates */
// Greenwitch time
private _greenwitch = (_hours + _timezone + _minutes/60)/24;
// J2000.0
private _n = (
            367 * _year
            - floor ( 7 * (_year + floor ((_month + 9) / 12)) / 4)
            + floor (275 * _month / 9)
            + _day
            - 730531.5
			+ _greenwitch);

private _mean_long = 280.460 + 0.9856474 * _n;
private _mean_anomaly = 357.528 + 0.9856003 * _n;

private _ecliptic_long = _mean_long + 1.915 * (sin _mean_anomaly) + 0.020 * (sin (2 * _mean_anomaly));
private _ecliptic_obliquity = 23.439 - 0.0000004 * _n;

/* Converting to Equatorial coordinates */

private _ra = (cos _ecliptic_obliquity * sin _ecliptic_long) atan2 (cos _ecliptic_long);
private _declination = asin (sin _ecliptic_obliquity * sin _ecliptic_long);

/* Converting to Alt-AZ */

private _lst = 280.460618385138 + 360.9856473671519 * _n - _longitude;
private _hourangle = _lst - _ra;

private _zenith = asin (sin _latitude * sin _declination + cos _latitude * cos _declination * cos _hourangle);
private _azimuth = (-cos(_declination) * cos(_latitude) *sin(_hourangle)) atan2 (sin(_declination) - sin(_latitude) * sin(_zenith));
// Shift into range
_azimuth = ((_azimuth % 360) + 360) % 360;

[_zenith, _azimuth];
