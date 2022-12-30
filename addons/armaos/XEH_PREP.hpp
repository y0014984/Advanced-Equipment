/* Module Functions */
PREP(module_addUser);
PREP(module_addHackingCommands);
PREP(module_addSecurityCommands);

/* Shell Functions */
PREP(shell_process);
PREP(shell_findLoginUser);
PREP(shell_validatePassword);
PREP(shell_getHomeDir);
PREP(shell_executeFile);
PREP(shell_stdout);
PREP(shell_stdin);
PREP(shell_writeToLogfile);

/* Computer Functions */
PREP(computer_playSoundStart);
PREP(computer_playSoundStop);
PREP(computer_playSoundStandby);

PREP(computer_standby);
PREP(computer_turnOn);
PREP(computer_turnOff);

/* OS Link Functions */
PREP(link_add);
PREP(link_init);

PREP(securityCommands_init);
PREP(hackingCommands_init);

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
PREP(os_ping);
PREP(os_rm);
PREP(os_shutdown);
PREP(os_standby);
PREP(os_whoami);
PREP(os_crypto);
PREP(os_crack);
PREP(os_find);

/* Encryption Functions */
PREP(encryption_caesar);

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
PREP(terminal_removeChar);
PREP(terminal_addHeader);
PREP(terminal_setPrompt);
PREP(terminal_updateOutput);
PREP(terminal_getAllowedKeysDE);
PREP(terminal_getAllowedKeysFR);
PREP(terminal_getAllowedKeysUS);
PREP(terminal_getHeaderText);
PREP(terminal_updateBufferVisable);
PREP(terminal_updatePromptPointer);
PREP(terminal_addToHistory);
PREP(terminal_setKeyboardLayout);
PREP(terminal_switchKeyboardLayout);
PREP(terminal_setCommandLineByHistory);
PREP(terminal_setInputMode);
PREP(terminal_updateBatteryStatus);