/* Object Exchange */
PREP(replace);

/* Remote Server Var Functions */
PREP(getRemoteVar);
PREP(sendVarToRemote);

/* Debug Mode and Overlay */
PREP(manageDebugMode);
PREP(initDebugOverlay);
PREP(killDebugOverlay);

/* Eden Editor Connections */
PREP(3denEventHandlers_onConnectionEnd);
PREP(3den_checkConnection);
PREP(3den_doNetworkConnection);
PREP(3den_doPowerConnection);

/* Misc */
PREP(getPlayersInRange);

/* Terminate */
PREP(terminateDevice);

/* Zeus/Curator Functions */
PREP(zeus_initAttributes);
PREP(zeus_updateAttributes);

PREP(zeus_turnOnDevice);
PREP(zeus_turnOffDevice);
PREP(zeus_standbyDevice);

PREP(zeus_openDevice);
PREP(zeus_closeDevice);

PREP(zeus_module_addUser);
PREP(zeus_module_addSecurityCommands);
PREP(zeus_module_addGames);
PREP(zeus_module_addFile);
PREP(zeus_module_addDir);
PREP(zeus_module_addConnection);