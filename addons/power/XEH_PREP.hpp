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
PREP(getBatteryLevel);
PREP(getFuelLevel);
PREP(getPowerState);
PREP(getPowerOutput);

/* Setter */
PREP(setBatteryLevel);
PREP(setFuelLevel);

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

/* Controller */
PREP(turnOffDevice);
PREP(turnOnDevice);
PREP(standbyDevice);

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

/* Connections */
PREP(createPowerConnection);
PREP(removePowerConnection);

PREP(simulateNetwork);
PREP(simulationLoop);