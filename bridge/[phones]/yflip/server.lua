if Config.Phone ~= "yflip" then return print("yflip SS Off") end

local function getCitIDByImei(imei)	
	local response = MySQL.query.await('SELECT `holder_identifier` FROM `yphone_holders` WHERE `phone_imei` = ?;', { imei })

	if response and #response > 0 then 
		return response[1].holder_identifier 
	end

	return nil

end

local function getImeiByPhoneNumber(phoneNumber)	
	local response = MySQL.query.await('SELECT `phone_imei` FROM `yphone_sim_cards` WHERE `sim_number` = ?;', { phoneNumber })

	if response and #response > 0 then 
		return response[1].phone_imei
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
	local imei = getImeiByPhoneNumber(phoneNumber)
	if not imei then return nil end
	local citizenId = getCitIDByImei(imei)
	if not imei then return nil end
	local src = getPlayerDataByCitizenId(citizenId)
	return src
end

function getPlayerCoords(source)
	if not source then return nil end
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    return coords
end