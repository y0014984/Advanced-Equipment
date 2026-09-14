/* Actions */


/* Init */
PREP(initNetworkDevice);
PREP(initRouter);
PREP(router_onTurnOff);
PREP(applyRouterConfig);
PREP(attr_router);
PREP(router_openConfig);
PREP(router_applyConfigDialog);

/* Backend */
PREP(connect_router2router);
PREP(connect_device2router);
PREP(promptConnect);
PREP(connectSubmitPassword);
PREP(connect_isCyclic);
PREP(disconnect);

PREP(ping);
PREP(resolve);
PREP(wirelessSweep);

PREP(dhcp_get);
PREP(dhcp_refresh);
PREP(dhcp_onTurnOn);
PREP(ipInUse);
PREP(setStaticIp);
PREP(setStaticIpZeus);
PREP(setSshEnabled);

/* Generic */
PREP(ip2str);
PREP(str2ip);
PREP(ipInSubnet);

/* Connections */
PREP(createNetworkConnection);
PREP(removeNetworkConnection);
