/* Actions */
PREP(checkBatteryLevelAction);
PREP(checkFuelLevelAction);
PREP(checkPowerStateAction);
PREP(turnOffGeneratorAction);
PREP(turnOnGeneratorAction);
PREP(turnOffBatteryAction);
PREP(turnOnBatteryAction);
PREP(connectToGeneratorAction);
PREP(disconnectFromGeneratorAction);

/* Init */
PREP(compileDevice);
PREP(initDevice);
PREP(initPowerInterface);
PREP(initBattery);
PREP(initGenerator);
PREP(initConsumer);

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

