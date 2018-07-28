--[[
    Helper library for the laptimelogger Lua addon.
--]]

local LibHelper = {}



function LibHelper.new()
    local instance = {}
    setmetatable(instance, LibHelper)
    return instance
end


-- Sorts a associative table based on its associated value.
function LibHelper:sortAssociativeTable(tbl, sortFunction)
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end

    table.sort(keys, function(a,b) return sortFunction(tbl[a], tbl[b]) end)

    return keys
end

-- Sorts and returns a laptime table
function LibHelper:sortRankingAndReturn(tbl)
    local sortedKeys = self:sortAssociativeTable(tbl, function(a,b) return a.lapTime < b.lapTime end)
    return self:updateRankings(sortedKeys, tbl)
end




-- Converts a laptime in ms into an human readable format.
function LibHelper:millisecondsConverter(time)
    if lapTime <= 0 then
        return "00:00:00"
    else
        local totalSeconds = math.floor(lapTime / 1000)
        local milliseconds = lapTime % 1000
        local seconds = totalSeconds % 60
        local minutes = math.floor(totalSeconds / 60)

        return string.format("%02d:%02d:%03d",minutes, seconds, milliseconds)
    end
end

-- Creates an object holding participant and event related infos
function LibHelper:extractParticipantInformation(participant, event, wetness)
    local logtime = os.time(os.date("!*t"))
    local iswet = 0
    if wetness > 190 then
        iswet = 1
    end
    return {
        refId = participant.attributes.RefId,
        vehicleId = participant.attributes.VehicleId,
        name = participant.attributes.Name,
        lapTime = event.attributes.LapTime,
        wet = iswet,
        logtime = logtime,
    }
end



-- Updates the rankings of a given lapTime table
function LibHelper:updateRankings(sortedKeys, lapTimes )
    for i, v in ipairs(sortedKeys) do
            lapTimes[v].rank = i
    end
    return lapTimes
end

-- Returns the ranking for the participant specifed by its steamid
function LibHelper:getRanking(list, steamid)
    for i, v in ipairs(list) do
        if v.steamId == steamid then
            return v.rank
        end
    end
end







