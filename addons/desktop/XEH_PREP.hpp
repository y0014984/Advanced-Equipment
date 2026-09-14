/* Desktop core */
PREP(desktop_open);
PREP(desktop_onUnload);

/* Web desktop (WS-B CEF port): browser display, JS<->SQF bridge */
PREP(desktop_openWeb);
PREP(desktop_webUnload);
PREP(browserAction);
PREP(jsRouter);
PREP(jsSend);
PREP(jsReply);
PREP(deviceLabel);
PREP(registerExtApp);
PREP(registerCmd);
PREP(authUser);
PREP(fsHandle);
PREP(sysInfo);
PREP(netScan);
PREP(netConnectServer);
PREP(netDisconnectServer);
PREP(mapData);
PREP(mailHandle);
PREP(chatPullServer);
PREP(handleRegister);
PREP(handleRelease);
PREP(msgRoute);
PREP(addrRegister);
PREP(addrRelease);
PREP(mailRoute);
PREP(provisionIdentity);
PREP(mapOpen);
PREP(volHandle);
PREP(playDeviceSound);
PREP(routerHandle);
PREP(routeReply);
PREP(sshOpServer);
PREP(setSystemConfig);

PREP(setInterfaceMode);
PREP(setInterfaceAccess);
PREP(canAccessInterface);

/* Window manager */
PREP(wm_createWindow);
PREP(wm_closeWindow);
PREP(wm_getTheme);
PREP(wm_focusWindow);
PREP(wm_minimizeWindow);
PREP(wm_updateTaskbar);

/* App framework */
PREP(app_list);
PREP(registerApp);
PREP(openFile);

/* Built-in apps */
PREP(app_terminal);
PREP(app_files);
PREP(app_settings);
PREP(app_notepad);
PREP(app_mail);
PREP(app_chat);
PREP(app_browser);
PREP(app_calendar);
PREP(app_map);
PREP(app_cctv);
PREP(app_music);
PREP(app_sysinfo);

/* Media + intel registries */
PREP(registerMedia);
PREP(registerPictureB64);
PREP(parseMediaMarker);
PREP(audioPlayer);
PREP(mediaNotify);
PREP(registerWebpage);
PREP(registerSite);
PREP(module_addWebsite);
PREP(zen_module_addWebsite);
PREP(zeus_module_addWebsite);
PREP(addEmail);
PREP(addHistoryEntry);
PREP(addCalendarEvent);
PREP(registerCamera);
PREP(intel_dispatch);
PREP(addLockedFile);
PREP(promptUnlock);
PREP(intel_initFields);
PREP(intel_updateFields);
PREP(intel_browsePath);
PREP(intel_3denLoad);
PREP(intel_3denSave);

/* Zeus/3DEN modules */
PREP(zeus_module_addIntel);
PREP(module_addIntel);
PREP(zeus_module_interfaceAccess);
PREP(module_interfaceAccess);
PREP(module_crashDevice);

/* Optional ZEN (Zeus Enhanced) Dynamic Dialog compat */
PREP(zen_module_addIntel);
PREP(zen_module_addIntel_step2);
PREP(zen_module_interfaceAccess);
PREP(zen_module_crashDevice);
