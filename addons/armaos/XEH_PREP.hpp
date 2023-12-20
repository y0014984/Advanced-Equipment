/* Module Functions */
PREP(module_addUser);
PREP(module_addSecurityCommands);
PREP(module_addGames);

/* Shell Functions */
PREP(shell_process);
PREP(shell_findLoginUser);
PREP(shell_validatePassword);
PREP(shell_getHomeDir);
PREP(shell_executeFile);
PREP(shell_stdout);
PREP(shell_stdin);
PREP(shell_writeToLogfile);
PREP(shell_getOpts);
PREP(shell_getOptsConvertArgType);
PREP(shell_getOptsCreateSearchArray);
PREP(shell_getOptsFormatOptsName);
PREP(shell_getOptsParseLongForm);
PREP(shell_getOptsParseShortForm);
PREP(shell_getOptsPrintHelp);
PREP(shell_getOptsSplitOptionArgument);
PREP(shell_getOptsCheckSyntax);

/* Retro Games */
PREP(games_snake);

/* Retro Gaming Functions */
PREP(retro_createCanvas);
PREP(retro_showSplashScreen);
PREP(retro_setPixelColor);
PREP(retro_getPixelColor);
PREP(retro_getCanvasHeight);
PREP(retro_getCanvasWidth);
PREP(retro_addEventHandler);

/* Computer Functions */
PREP(computer_playSoundStart);
PREP(computer_playSoundStop);
PREP(computer_playSoundStandby);

PREP(computer_standby);
PREP(computer_turnOn);
PREP(computer_turnOff);

PREP(computer_addUser);
PREP(computer_addSecurityCommands);
PREP(computer_addGames);

PREP(computer_getLocality);

PREP(computer_clone);

/* OS Link Functions */
PREP(link_add);
PREP(link_init);

/* OS Internal Functions */
PREP(os_cat);
PREP(os_cd);
PREP(os_chat);
PREP(os_clear);
PREP(os_date);
PREP(os_echo);
PREP(os_exit);
PREP(os_help);
PREP(os_history);
PREP(os_ipconfig);
PREP(os_ls);
PREP(os_man);
PREP(os_mkdir);
PREP(os_mv);
PREP(os_cp);
PREP(os_ping);
PREP(os_rm);
PREP(os_shutdown);
PREP(os_standby);
PREP(os_whoami);
PREP(os_crypto);
PREP(os_crack);
PREP(os_find);
PREP(os_mount);
PREP(os_unmount);
PREP(os_chown);
PREP(os_lsusb);

/* Encryption Functions */
PREP(encryption_caesar);
PREP(encryption_columnar);

/* Terminal Functions */
PREP(terminal_init);
PREP(terminal_addEventHandler);

PREP(terminal_addCharToInput);
PREP(terminal_removeCharFromInput);
PREP(terminal_shiftInputBuffer);
PREP(terminal_getInput);

PREP(terminal_renderLine);
PREP(terminal_reRenderBuffer);

PREP(terminal_addChar);
PREP(terminal_addLines);
PREP(terminal_appendLine);
PREP(terminal_removeChar); // unused
PREP(terminal_addHeader);
PREP(terminal_setPrompt);
PREP(terminal_updateOutput);
PREP(terminal_getHeaderText);
PREP(terminal_updateBufferVisible);
PREP(terminal_updatePromptPointer);
PREP(terminal_addToHistory);
PREP(terminal_setTerminalDesign);
PREP(terminal_switchTerminalDesign);
PREP(terminal_setCommandLineByHistory);
PREP(terminal_setInputMode);
PREP(terminal_updateBatteryStatus);

PREP(terminal_uiOnTex_init);
PREP(terminal_uiOnTex_updateAll);
PREP(terminal_uiOnTex_updateOutput);
PREP(terminal_uiOnTex_updateBatteryStatus);
PREP(terminal_uiOnTex_setTerminalDesign);
PREP(terminal_uiOnTex_addUpdateAllEventHandler);