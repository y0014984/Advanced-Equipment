/* Actions */
PREP(checkBatteryLevelAction);
PREP(checkFuelLevelAction);
PREP(checkPowerStateAction);
PREP(checkPowerOutputAction);
PREP(turnOffGeneratorAction);
PREP(turnOnGeneratorAction);
PREP(turnOffBatteryAction);
PREP(turnOnBatteryAction);
PREP(turnOffSolarAction);
PREP(turnOnSolarAction);
PREP(connectToGeneratorAction);
PREP(disconnectFromGeneratorAction);

/* Getter */
PREP(getFuelLevel);
PREP(getPowerState);
PREP(getPowerOutput);
PREP(getBatteryLevel);

/* Init */
PREP(compileConfig);
PREP(compileDevice);
PREP(initDevice);
PREP(initPowerInterface);
PREP(initBattery);
PREP(initBatteryLevelWithEdenAttribute);
PREP(initGenerator);
PREP(initFuelLevelWithEdenAttribute);
PREP(initConsumer);
PREP(initSolarPanel);
PREP(initDeviceTurnOn);

/* Sys */
PREP(batteryCalculation);
PREP(addProviderHandler);
PREP(removeProviderHandler);
PREP(fuelConsumption);
PREP(updatePower);
PREP(updateSelfPower);


/* Helper */
PREP(playGeneratorRunningSound);
PREP(playGeneratorStartSound);
PREP(playGeneratorStopSound);
PREP(showBatteryLevel);

/* Solar */
PREP(getSolarPosition);
PREP(solarCalculation);
PREP(multSolarPanelOrientation);