/* Actions */
PREP(checkBatteryLevelAction);
PREP(checkFuelLevelAction);
PREP(checkPowerStateAction);
PREP(turnOffGeneratorAction);
PREP(turnOnGeneratorAction);
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
PREP(powerConsumption);
PREP(updatePower);
PREP(updateSelfPower);


/* Helper */
PREP(playGeneratorRunningSound);
PREP(playGeneratorStartSound);
PREP(playGeneratorStopSound);
PREP(showBatteryLevel);

