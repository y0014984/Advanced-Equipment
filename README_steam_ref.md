[h1]Root's Cyber Warfare[/h1]

[b]Advanced hacking mod for Arma 3 with terminal-based control over doors, lights, vehicles, drones, and more.[/b]

Fully integrated with ACE3, AE3 ArmaOS terminal, and Zeus/Eden editors. Tested with 67+ players on dedicated servers. Requires both server and clients to have this mod.

[b]Current version - 1.1.1.1[/b]

[img]https://i.imgur.com/EWy3dQc.gif[/img]

[hr][/hr]
[h2]Device Types[/h2]
[table]
[tr]
[th]Device[/th]
[th]Capabilities[/th]
[/tr]
[tr]
[td][b]Doors[/b][/td]
[td]Lock/unlock, prevent breaching[/td]
[/tr]
[tr]
[td][b]Lights[/b][/td]
[td]Turn on/off buildings[/td]
[/tr]
[tr]
[td][b]Drones[/b][/td]
[td]Change faction, disable[/td]
[/tr]
[tr]
[td][b]Vehicles[/b][/td]
[td]Control battery, speed, brakes, lights, engine, alarm[/td]
[/tr]
[tr]
[td][b]Databases[/b][/td]
[td]Download files, execute code[/td]
[/tr]
[tr]
[td][b]Custom[/b][/td]
[td]Scripted devices (generators, alarms)[/td]
[/tr]
[tr]
[td][b]GPS Trackers[/b][/td]
[td]Real-time position tracking[/td]
[/tr]
[tr]
[td][b]Power Grids[/b][/td]
[td]Control lights in radius, explosions[/td]
[/tr]
[/table]

[hr][/hr]
[h2]For Players[/h2]
[h3]Terminal Access[/h3]
[olist]
[*]ACE Interact on AE3 laptop → ArmaOS → Use
[*]Laptop must have hacking tools (configured by Zeus/mission maker)
[/olist]

[img]https://i.postimg.cc/8cf7DQYx/Root-Cyberwarfare-Home-Screen.jpg[/img]

[h3]In-Game Guide[/h3]
A detailed terminal usage guide is available in-game for all players. Open your map and navigate to the [b]Cyberwarfare Guide[/b] section for comprehensive command reference and examples.

[h3]Commands[/h3]
[b]Getting Help:[/b]
[code]
<command> help          # Display detailed help for any command
<command> -h            # Same as help
devices help            # List device types and usage
door help               # Lock/unlock doors syntax
vehicle help            # Vehicle control options
[/code]

[b]List Devices:[/b]
[code]
devices all              # List all accessible devices
devices doors            # List doors only
devices lights           # Lights only
devices drones           # Drones only
devices vehicles         # Vehicles only
devices gps              # GPS trackers
[/code]

[b]Control Devices:[/b]
[code]
# Doors
door <buildingID> <doorID> lock/unlock
door <buildingID> a lock             # Lock all doors

# Lights
light <lightID> on/off

# Vehicles
vehicle <ID> battery <0-100>         # Set battery (>100 = destroy)
vehicle <ID> speed <value>           # Modify speed
vehicle <ID> brakes                  # Apply brakes
vehicle <ID> lights on/off
vehicle <ID> engine on/off
vehicle <ID> alarm <seconds>

# Drones
drone <ID> side <west/east/guer/civ>
drone <ID> disable

# Power Grids
powergrid <ID> on/off
powergrid <ID> overload              # Destroy with explosion

# GPS Tracking
gpstrack <ID>                        # Start tracking (creates marker)

# Custom
custom <ID> on/off
[/code]

[img]https://i.postimg.cc/8507qPyg/Root-Cyberwarfare-File-Download.jpg[/img]

[h3]Power Management[/h3]
Operations consume battery (Watt-hours). Commands fail if insufficient power. Recharge using AE3 power sources.

[h3]GPS Trackers[/h3]
[list]
[*]Attach via ACE Self-Interact → Equipment → Attach GPS Tracker (Self) to attach onto self
[*]Attach via ACE Interact → Equipment → Attach GPS Tracker to attach to other object, player, vehicle or entity.
[*]Search for active GPS Trackers via ACE Interaction menu
[*]Detection is chance-based (improved with configurable detection tool) and provides multiple options based on the search criteria
[/list]
[img]https://i.postimg.cc/Tw4KZYkX/Root-Cyberwarfare-GPSContext.jpg[/img]
[img]https://i.postimg.cc/3RckPJL5/Root-Cyberwarfare-GPSAttach.jpg[/img]
[img]https://i.postimg.cc/7hJ5D8Rt/Root-Cyberwarfare-GPSDetect-Normal.jpg[/img]
[img]https://i.postimg.cc/MHfnx2Lr/Root-Cyberwarfare-GPSDetect-Tool.jpg[/img]

[hr][/hr]
[h2]For Zeus Curators[/h2]
[h3]Quick Setup[/h3]
[olist]
[*]Zeus interface (Y key) → Modules → Root's Cyber Warfare
[*]Place [b]"Add Hacking Tools"[/b] on AE3 laptop
[*]Place device modules on objects to make hackable
[/olist]

[img]https://i.postimg.cc/zvHy5ZQ9/Root-Cyberwarfare-Zeus-Modules.jpg[/img]

[h3]Module Placement Modes[/h3]
[list]
[*][b]Terrain Object Mode:[/b] Place modules directly on terrain objects (buildings, vehicles, etc.) to register them instantly
[*][b]Radius Mode:[/b] Place modules on empty ground to register all compatible objects within a configurable radius (10-3000m)
[*][b]Bulk Registration:[/b] Use radius mode to quickly register multiple devices at once (buildings, lights, vehicles, drones)
[/list]

[h3]Zeus Modules[/h3]
[b]Add Hacking Tools[/b] - Enable laptop hacking capability

[b]Add Hackable Object[/b] - Buildings (auto-detects doors/lights only)

[b]Add Hackable Vehicle[/b] - Configure controllable systems

[b]Add Hackable File[/b] - Downloadable databases

[b]Add GPS Tracker[/b] - Real-time position tracking

[b]Add Custom Device[/b] - Mission-specific scripted devices

[b]Add Power Generator[/b] - Control lights in radius

[b]Modify Power Costs[/b] - Adjust global power consumption

[h3]Device Linking[/h3]
[list]
[*][b]Public:[/b] Accessible to all laptops
[*][b]Private:[/b] Select specific laptops during placement
[*][b]Future Access:[/b] "Available to Future Laptops" checkbox
[/list]

[hr][/hr]
[h2]For Mission Makers[/h2]
[h3]Eden Editor[/h3]
8 modules available under [b]Systems (F5) → Root's Cyber Warfare[/b]. Use synchronization (F5) to link modules to objects.

[img]https://i.postimg.cc/fLrV6T8F/Root-Cyberwarfare-3-DENModules.jpg[/img]

[hr][/hr]
[h2]CBA Settings[/h2]

[img]https://i.postimg.cc/Tw4KZYts/Root-Cyberwarfare-CBASettings.jpg[/img]

Configure in Main Menu → Options → Addon Options → Root Cyber Warfare:
[list]
[*]Power costs for all device types
[*]GPS tracker item classname (default: ACE_Banana)
[*]GPS detection tool (default: Spectrum Device)
[*]GPS detection chances (with/without detection tool)
[*]GPS marker colors (active/last ping)
[/list]

[hr][/hr]
[h2]Credits[/h2]
[b]Author:[/b] Root (xMidnightSnowx)
[b]Mister Adrian[/b] - Author of the [url=https://steamcommunity.com/sharedfiles/filedetails/?id=3454525813]original Cyber Warfare mod[/url]
[url=77th-jsoc.com][b]77th JSOC[/b][/url]

[hr][/hr]
[h2]License[/h2]
[b]APL-SA:[/b] Arma Public License Share Alike
[url=https://www.bohemia.net/community/licenses/arma-public-license-share-alike]Read Full License here[/url]
[img]https://i.postimg.cc/pTxntLMW/APL-SA.png[/img]

TL;DR - What am I allowed to do?
✔️ Redistribute this mod in part or whole publicly [b]ONLY[/b] with clear credit towards the author and with credits linking to this page.
❌ Redistribute this mod in part or whole privately / within a unit [b]WITHOUT[/b] giving any credit.
❌ Port this mod in part or whole to games other than ArmA.

[hr][/hr]
[h2]Links[/h2]
[url=https://github.com/A3-Root/Root_Cyberwarfare][img]https://i.imgur.com/lPLHihO.gif[/img][/url]
[url=https://discord.gg/77th-jsoc-official][img]https://i.imgur.com/8B7UcQ2.gif[/img][/url]

[hr][/hr]
Tags: #Arma 3 #Steam #Workshop #Mod #Root #Script #Zeus #Editor #Eden
gaming,game,video,videos,epic,arma,arma 3,cod,call of duty,modern,warfare,drone,uav,terminal,uplink,connect,satcom,satellite,antenna,control,remote,tool,mod,modding,script,code,sqf,signal,targeting,virtual,reality,awesome,guidance,software,source,steam,workshop,mods,best,top,ten,new,manual,gps,Cyber,war,cyberwar,warfare,electronic,ewo,electronic warfare officer,hacking,terminal,armaos,linux,gui,hacknet,milsim,military,signals,officer
