# Laptime logger for Project Cars 2 Dedicated Server


This lua addon logs valid personal best laptimes for participants on the Dedicated Server sorted by the vehicle. It outputs the results into a *_data.json file in the lua_config folder.

JSON Data Format:

```javascript
...
 "loggedTimes" : {
    "steamids" : {
        "<steamId>" : {
        "name" : <name>"
        },
        "<steamId>" : {
        "name" : "<name>"
        }
    },
    "vehicles" : {
        "<vehicleId>" : {
            "lapTimes" : {
                "<steamId>" : {
                    "lapTime" : "<laptime>",
                    "name" : "<name>",
                    "refId" : "<refId>",
                    "vehicleId" : "<vehicleId>",
                    "isWet" : "<isWet",
                    "rank" : "<rank>"
                },
                "<steamId>" : {...}
            }
            
        },
        "<vehicleId>" : {...}
    }
 }
```

Ingame chat notification for:

* New personal best and previous personal best [self-info]
* Valid Laptime [server-wide]
* Server-wide rank for current car

Chat commands: 

* !rank - outputs rank for the current car
* !pb - outputs personal best for the current car
