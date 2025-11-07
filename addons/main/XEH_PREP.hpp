/* Object Exchange */
PREP(replace);

/* Remote Server Var Functions */
PREP(getRemoteVar);
PREP(sendVarToRemote);

/* Debug Mode and Overlay */
PREP(manageDebugMode);
PREP(initDebugOverlay);
PREP(killDebugOverlay);

/* Eden Editor Functions */
PREP(3denEventHandlers_onConnectionEnd);
PREP(3den_checkConnection);

/* Misc */
PREP(getPlayersInRange);
PREP(waitForFilesystem);

/* Terminate */
PREP(terminateDevice);

/* Zeus/Curator Functions */
PREP(zeus_initAttributes);
PREP(zeus_updateAttributes);

PREP(zeus_turnOnDevice);
PREP(zeus_turnOffDevice);
PREP(zeus_standbyDevice);

PREP(zeus_openObject);
PREP(zeus_closeObject);

PREP(zeus_module_addUser);
PREP(zeus_module_addSecurityCommands);
PREP(zeus_module_addGames);
PREP(zeus_module_addFile);
PREP(zeus_module_addDir);
PREP(zeus_module_addConnection);

PREP(zeus_checkForComputer);

PREP(zeus_isConnectionAllowed);

PREP(zeus_resetDevice);
PREP(zeus_openFilesystemBrowser);
PREP(zeus_filesystemBrowser_init);
PREP(zeus_filesystemBrowser_refresh);
PREP(zeus_filesystemBrowser_onDblClick);
PREP(zeus_filesystemBrowser_goBack);
PREP(zeus_filesystemBrowser_createFile);
PREP(zeus_filesystemBrowser_createFolder);
PREP(zeus_filesystemBrowser_saveFile);
PREP(zeus_filesystemBrowser_delete);
PREP(zeus_filesystemBrowser_onUnload);
PREP(zeus_filesystemBrowser_applyChanges);
PREP(zeus_filesystemBrowser_rename);
PREP(zeus_filesystemBrowser_move);
PREP(zeus_browser_newFile);
PREP(zeus_browser_newFolder);
