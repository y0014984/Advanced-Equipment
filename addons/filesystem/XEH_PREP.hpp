/* Device Functions */
PREP(device_addFile);
PREP(device_addDir);
PREP(device_writeFile);
PREP(device_setFileSize);
PREP(device_withFilesystem);

/* Module Functions */
PREP(module_addFile);
PREP(module_addDir);

/* Base Functions */
PREP(initFilesystem);
PREP(resolvePntr);
PREP(chdir);
PREP(getParentDir);
PREP(lsdir);
PREP(createDir);
PREP(createFile);
PREP(ensureDir);
PREP(ensureFile);
PREP(writeToFile);
PREP(getFile);
PREP(getFileEntry);
PREP(getFileSize);
PREP(setFileSize);
PREP(parseSize);
PREP(formatSize);
PREP(mvObj);
PREP(delObj);
PREP(hasPermission);
PREP(findFilesystemObject);
PREP(searchFilesystem);
PREP(fsObjExists);
PREP(symlink);
PREP(symlinkTarget);
PREP(seedDesktop);
PREP(chown);
PREP(chmod);
PREP(mount);
PREP(unmount);
