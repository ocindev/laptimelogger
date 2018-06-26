# Laptime logger for Project Cars 2 Dedicated Server


This lua addon logs valid personal best laptimes for participants on the Dedicated Server sorted by the vehicle. It outputs the result into a *_data.json file in the lua_config folder.

## JSON Data Format:

```javascript
...
 "loggedTimes" : {
    "steamids" : {
        "<steamId>" : "<name>",
        "<steamId>" : "<name>"
    },
    "vehicles" : {
        "<vehicleId>" : {
            "lapTimes" : {
                "<steamId>" : {
                    "lapTime" : "<laptime>",
                    "name" : "<name>",
                    "refId" : "<refId>",
                    "vehicleId" : "<vehicleId>",
                    "isWet" : "<isWet>",
                    "rank" : "<rank>"
                },
                "<steamId>" : {...}
            }
            
        },
        "<vehicleId>" : {...}
    }
 }
```

## Values:
* \<steamid> : steamID64
* \<vehicleId> : vehicleId of the used car
* \<name> : the users steam name, get automatically updated on joining
* \<refid> : the participants refid, only valid for the current session
* \<iswet> : Whether the track is wet(1) or not(2) (session attribute wettnessAverage > 190)
* \<rank> : the users rank for the car identified by its vehicleId




## Features:
Ingame chat notification for:

* New personal best and previous personal best [self-info]
* Valid Laptime [server-wide]
* Server-wide rank for current car

Chat commands: 

* !rank - outputs rank for the current car
* !pb - outputs personal best for the current car


## Installation:

* Download the [latest release](https://github.com/nweiser94/lua_scripts/tree/logv1.0) and extract it
* Copy the logger folder into \<DedicatedServerPath>\lua\
* Add the addon to the server.cfg

```javascript
luaApiAddons : [
    ... // other addons
    "logger",
]
```
