if Config.Phone ~= "yflip" then return end
if Config.Debug then print("Phone Set To ", Config.Phone) end

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

local function getPlayerDataByUId(identifier)
    local PlayerSrc = GetPlayerByID(identifier)
    if not PlayerSrc then return nil end
    return PlayerSrc
end

function GetPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
	local imei = getImeiByPhoneNumber(phoneNumber)
	if not imei then return nil end
	local identifier = getCitIDByImei(imei)
	if not imei then return nil end
	local src = getPlayerDataByUId(identifier)
	return src
end

function GetPlayerCoords(source)
	if not source then return nil end
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    return coords
end