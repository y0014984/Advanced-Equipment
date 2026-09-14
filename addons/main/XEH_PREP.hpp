/* Object Exchange */
PREP(replace);

/* Remote Server Var Functions */
PREP(getRemoteVar);
PREP(sendVarToRemote);

/* Debug Mode and Overlay */
PREP(manageDebugMode);
PREP(manageNetworkDebug);
PREP(netLog);
PREP(initDebugOverlay);
PREP(killDebugOverlay);

/* Eden Editor Functions */
PREP(3denEventHandlers_onConnectionEnd);
PREP(3den_checkConnection);

/* Misc */
PREP(getPlayersInRange);
PREP(waitForFilesystem);
PREP(hasCapability);

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

PREP(zeus_connectToRouter);
PREP(zeus_disconnectFromRouter);

PREP(zeus_module_addUser);
PREP(zeus_module_addSudoer);
PREP(zeus_module_addCalendarEvent);
PREP(zeus_module_addFile);
PREP(zeus_module_addDir);
PREP(zeus_module_addConnection);

/* Optional ZEN (Zeus Enhanced) Dynamic Dialog compat */
PREP(zen_createDialog);
PREP(zen_module_addUser);
PREP(zen_module_addSudoer);
PREP(zen_module_addCalendarEvent);
PREP(zen_module_addFile);
PREP(zen_module_addDir);
PREP(zen_module_addConnection);
PREP(zeus_applyConnection);

PREP(zeus_checkForComputer);

PREP(zeus_deviceOpServer);
PREP(zeus_deviceOpFeedback);

PREP(zeus_isConnectionAllowed);

PREP(zeus_openFilesystemBrowser);
PREP(zeus_filesystemBrowser_init);
PREP(zeus_filesystemBrowser_refresh);
PREP(zeus_filesystemBrowser_pickPath);
PREP(zeus_filesystemBrowser_onSelect);
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
PREP(zeus_filesystemBrowser_populateTree);
PREP(zeus_browser_newFile);
PREP(zeus_browser_newFolder);
