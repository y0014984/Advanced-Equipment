/* Module Functions */
PREP(moduleUserlist);

/* Shell Functions */
PREP(shell_process);
PREP(shell_getAvailableCommands);
PREP(shell_findLoginUser);
PREP(shell_validatePassword);

/* Computer Functions */
PREP(computer_playSoundStart);
PREP(computer_playSoundStop);
PREP(computer_playSoundStandby);

PREP(computer_addActionStandby);
PREP(computer_addActionTurnOn);
PREP(computer_addActionTurnOff);

/* OS Internal Functions */
PREP(os_cd);
PREP(os_chat);
PREP(os_clear);
PREP(os_date);
PREP(os_history);
PREP(os_ipconfig);
PREP(os_logout);
PREP(os_ls);
PREP(os_man);
PREP(os_mv);
PREP(os_ping);
PREP(os_print);
PREP(os_rm);
PREP(os_shutdown);
PREP(os_standby);
PREP(os_standby);

/* Terminal Functions */
PREP(terminal_init);
PREP(terminal_addEventHandler);
PREP(terminal_addChar);
PREP(terminal_addCharToPassword);
PREP(terminal_addLines);
PREP(terminal_removeChar);
PREP(terminal_removeCharFromPassword);
PREP(terminal_addHeader);
PREP(terminal_setPrompt);
PREP(terminal_updateOutput);
PREP(terminal_getAllowedKeysDE);
PREP(terminal_getAllowedKeysUS);
PREP(terminal_getHeaderText);
PREP(terminal_updateBufferVisable);
PREP(terminal_updatePromptPointer);
PREP(terminal_addToHistory);
PREP(terminal_switchKeyboardLayout);
PREP(terminal_setCommandLineByHistory);