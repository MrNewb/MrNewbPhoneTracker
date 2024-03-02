if Config.Phone ~= "NewQsPhone" then return end
if Config.Debug then print("Phone Set To ", Config.Phone) end

local function getOwnerByPhoneNumber(phoneNumber)
    if not phoneNumber then return nil end

    if Config.Framework == "qb" then
        local qbresponse = MySQL.query.await('SELECT `citizenid` FROM `players` WHERE `inventory` LIKE \'%"phone":"' .. phoneNumber .. '"%\'', {})
        if qbresponse and #qbresponse > 0 then
            return qbresponse[1].citizenid
        end

        return nil
    else
        local esxresponse = MySQL.query.await('SELECT `identifier` FROM `users` WHERE `inventory` LIKE \'%"phone":"' .. phoneNumber .. '"%\'', {})
        if esxresponse and #esxresponse > 0 then
            return esxresponse[1].identifier
        end

        return nil
    end

end

local function getPlayerDataByUId(identifier)
    local Player = GetPlayerByID(identifier)
    if not Player then return nil end
    return Player
end

function GetPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
    local identifier = getOwnerByPhoneNumber(phoneNumber)
    if not identifier then return nil end
    local src = getPlayerDataByUId(identifier)
    return src
end

function GetPlayerCoords(source)
	if not source then return nil end
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    return coords
end