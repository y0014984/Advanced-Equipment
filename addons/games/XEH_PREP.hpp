/* Settings */
PREP(getSetting);
PREP(setSetting);

/* Tables (server authority) */
PREP(hostTable);
PREP(joinTable);
PREP(startTable);
PREP(leaveTable);
PREP(closeTable);
PREP(applyMove);
PREP(getTables);
PREP(setGameOpen);
PREP(setTableOption);
PREP(setActiveSeat);
PREP(addDummySeat);

/* Sys */
PREP(gameInfo);
PREP(reachable);
PREP(deviceLabel);
PREP(pushState);
PREP(pushNotice);
PREP(seatOf);
PREP(seatsOf);
PREP(operatorOwner);
PREP(tableSweep);
PREP(manageSweep);
PREP(applyGamePowerLoad);
PREP(gameIds);
PREP(installGames);
PREP(removeGames);
PREP(refreshAvailability);

/* Rules */
PREP(rules_chess);
PREP(rules_checkers);
PREP(rules_uno);
PREP(rules_ludo);
PREP(rules_snakesladders);
PREP(rules_blackjack);
PREP(rules_rps);
PREP(rules_battleship);

/* Modules */
PREP(module_addGames);
PREP(module_games);

/* Zeus */
PREP(getRoster);
PREP(zeus_games);
PREP(zeus_showRoster);

/* Front end - web desktop */
PREP(registerApps);

/* Front end - terminal */
PREP(tui_session);
PREP(tui_renderBoard);
PREP(tui_chess);
PREP(tui_checkers);
PREP(tui_uno);
PREP(tui_ludo);
PREP(tui_snakesladders);
PREP(tui_blackjack);
PREP(tui_rps);
PREP(tui_battleship);
