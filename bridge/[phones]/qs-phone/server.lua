if Config.Phone ~= "NewQsPhone" then return print("NewQsPhone SS Off") end

local function getOwnerByPhoneNumber(phoneNumber)
    local response = MySQL.query.await('SELECT `citizenid` FROM `players` WHERE `inventory` LIKE \'%"phone":"' .. phoneNumber .. '"%\'', {})

    if response and #response > 0 then
        return response[1].citizenid
    end
	
	return nil

end

local function getPlayerDataByCitizenId(citizenId)
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenId)
    if not Player then return nil end
    return Player.PlayerData.source
end

function getPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
    local citizenId = getOwnerByPhoneNumber(phoneNumber)
    if not citizenId then return nil end
    local src = getPlayerDataByCitizenId(citizenId)
    return src
end

function getPlayerCoords(source)
	if not source then return nil end
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    return coords
end