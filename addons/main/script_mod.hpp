#define MAINPREFIX z
#define PREFIX ae3

#include "script_version.hpp"

#define VERSION MAJOR.MINOR.PATCH.BUILD
#define VERSION_AR MAJOR,MINOR,PATCH,BUILD

// Fix for HEMTT check - VERSION_CONFIG needs quoted version
#define VERSION_CONFIG version = QUOTE(VERSION); versionStr = QUOTE(VERSION); versionAr[] = {VERSION_AR}

// UI on Texture feature comes with Arma 3 v2.12
#define REQUIRED_VERSION 2.12
