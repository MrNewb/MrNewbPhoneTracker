if Config.Phone.NPWD ~= true then return print("NPWD SS Off") end

local function getPlayerCitizenid(phoneNumber)
    if not phoneNumber then return nil end

    local query = 'SELECT `citizenid` FROM `players` WHERE `phone_number` = @phoneNumber'
    local response = MySQL.query.await(query, { phoneNumber = phoneNumber })

    if response and #response > 0 then
        local citizenId = response[1].citizenid
        return citizenId
    else
        return nil
    end
end

function getPlayerCoords(TargetSource)
    if not TargetSource then return nil end

    local TargetPed = GetPlayerPed(TargetSource)
    local coords = GetEntityCoords(TargetPed)
    
    return { x = coords.x, y = coords.y, z = coords.z }
end

function getPlayerSource(phoneNumber)
    local CitizenID = getPlayerCitizenid(tostring(phoneNumber))
    local PlayerSource = QBCore.Functions.GetPlayerByCitizenId(CitizenID)
    if not CitizenID then return nil end

    if not PlayerSource.PlayerData.source then return nil end
    return PlayerSource.PlayerData.source
end