--[[
--]]

local addon_storage = ...
local config = addon_storage.config

local addon_data = addon_storage.data
local intkey_table_names = {vehicles = true}
addon_data = table.deep_copy_normalized( addon_data, intkey_table_names )
addon_storage.data = addon_data

if not addon_data.loggedTimes then addon_data.loggedTimes = {} end
loggedTimes = addon_data.loggedTimes
local loggedTimes = loggedTimes
if not loggedTimes.vehicles then loggedTimes.vehicles = {} end
vehicles = loggedTimes.vehicles
local vehicles = vehicles
if not loggedTimes.steamids then loggedTimes.steamids = {} end
steamids = loggedTimes.steamids
local steamids = steamids

--Function declarations
local addon_callback
local add_new_vehicleEntry
local extractInformation
local millisecondsConverter
local updateSteamIdTable
local retrieveSteamID
local compare
local updateRankings

--Field declarations
local lapTimes = {}
local dirtyFlag = false

local lib_helper = LibHelper.new()

--Configurable messages via addon config
local msgPrevious = "Previous personal best was: "
local msgNew = "New personal best: "

local persist_at = GetServerUptimeMs() + 30000

function updateSteamIdTable(steamid, name)
    steamids[steamid] = name
    dirtyFlag = true     
end

function retrieveSteamID(name)
    for k,v in pairs(steamids) do
        if v == name then
            return k
        end
    end
end

--Adds the entry to the vehicles list
function add_new_vehicleEntry(event, participant)
    local info = lib_helper:extractInformation(participant, event, session.attributes.WetnessAverage)
    local steamid = retrieveSteamID(info.name)

    if not vehicles[info.vehicleId] then
        vehicles[info.vehicleId] = {}
    end
    if not vehicles[info.vehicleId].lapTimes then
        vehicles[info.vehicleId].lapTimes = {}
    end
  
    vTimes = vehicles[info.vehicleId].lapTimes
    local logtime = os.date("%Y-%m-%d %H:%M:%S")
    if not vTimes[steamid] then
        print ( "[" .. logtime .. "] LAP: * " .. info.name .. " just did a " .. lib_helper:millisecondsConverter(info.lapTime) .. " in a ".. get_vehicle_name_by_id(info.vehicleId) .. " Rank:#" .. newRank )
        vTimes[steamid] = {}
        vTimes[steamid] = info
        vTimes = lib_helper:sortRankingAndReturn(vTimes)
        local newRank = vTimes[steamid].rank
        SendChatToMember(info.refId, msgNew .. lib_helper:millisecondsConverter(info.lapTime) .. " Rank:#" .. newRank)
        SendChatToAll( "* LAP: " .. info.name .. " just did a " ..  lib_helper:millisecondsConverter(info.lapTime) .. " in a " .. get_vehicle_name_by_id(info.vehicleId) .. " Rank:#" .. newRank )
        dirtyFlag = true     
    end
    if vTimes[steamid].lapTime > info.lapTime then
        vTimes = lib_helper:sortRankingAndReturn(vTimes)
        local prevRank = vTimes[steamid].rank
        vTimes[steamid] = {}
        vTimes[steamid] = info
        vTimes = lib_helper:sortRankingAndReturn(vTimes)
        local newRank = vTimes[steamid].rank
        print ( "[" .. logtime .. "] LAP: * " .. info.name .. " just did a " .. lib_helper:millisecondsConverter(info.lapTime) .. " Rank:#" .. newRank .. " in a ".. get_vehicle_name_by_id(info.vehicleId) .. ". Previous best was " .. lib_helper:millisecondsConverter(vTimes[steamid].lapTime) .. " Rank:#" .. prevRank)
        SendChatToMember(info.refId, msgNew  .. lib_helper:millisecondsConverter(info.lapTime) .. " Rank:#" .. newRank .. " " .. msgPrevious .. lib_helper:millisecondsConverter(vTimes[steamid].lapTime) .. " Rank:#".. prevRank) 
        SendChatToAll( "* LAP: " .. info.name .. " just did a " ..  lib_helper:millisecondsConverter(info.lapTime) .. " in a " .. get_vehicle_name_by_id(info.vehicleId) .. " Rank:#" .. newRank )
        dirtyFlag = true  
    end
    
end

--Main addon entry point
function addon_callback(callback, ...)
    if callback == Callback.Tick then
        local now = GetServerUptimeMs()
        if now > persist_at then
            SavePersistentData()
            dirtyFlag = false
            persist_at = now + 30000
        end
    end
    if callback == Callback.EventLogged then
        local event = ...
        if event.type == "Player" then
            if event.name == "PlayerJoined" then
                local steamid = event.attributes.SteamId
                local name = event.attributes.Name
                updateSteamIdTable(steamid, name)
                print( retrieveSteamID(name) )
            end
        end

        if event.type == "Participant" then
            local pid = event.participantid
            local participant = session.participants[pid]
            if event.name == "Lap" then
                if event.CountThisLapTimes ~= 0 then
                    add_new_vehicleEntry(event, participant)
                end
            end
        end
    end
end

RegisterCallback(addon_callback)
EnableCallback(Callback.Tick)
EnableCallback(Callback.EventLogged)
