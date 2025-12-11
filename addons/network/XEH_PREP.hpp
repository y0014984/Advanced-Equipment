/* Actions */


/* Init */
PREP(initNetworkDevice);
PREP(initRouter);

/* Backend */
PREP(connect_router2router);
PREP(connect_device2router);
PREP(connect_isCyclic);
PREP(disconnect);

PREP(ping);

PREP(dhcp_get);
PREP(dhcp_refresh);
PREP(dhcp_onTurnOn);

/* Generic */
PREP(ip2str);

/* Connections */
PREP(createNetworkConnection);
PREP(removeNetworkConnection);
