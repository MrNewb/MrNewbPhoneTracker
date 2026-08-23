--[[
	Resolve an online player source from a character phone number.
	Used by the qb-phone adapter (phone lives on charinfo, not a phone-resource export).
	Override when your stack stores phone differently.
]]

---@param phoneNumber string
---@return number|false
function OpenFindSourceByCharPhone(phoneNumber)
	phoneNumber = tostring(phoneNumber)
	local framework = bridge.framework.getResourceName()

	if framework == 'qbx_core' then
		for _, playerId in ipairs(bridge.framework.getPlayers()) do
			local player = exports.qbx_core:GetPlayer(playerId)
			local phone = player and player.PlayerData and player.PlayerData.charinfo and player.PlayerData.charinfo.phone
			if phone and tostring(phone) == phoneNumber then
				return playerId
			end
		end
		return false
	end

	if framework == 'qb-core' then
		local QBCore = exports['qb-core']:GetCoreObject()
		for _, playerId in ipairs(bridge.framework.getPlayers()) do
			local player = QBCore.Functions.GetPlayer(playerId)
			local phone = player and player.PlayerData and player.PlayerData.charinfo and player.PlayerData.charinfo.phone
			if phone and tostring(phone) == phoneNumber then
				return playerId
			end
		end
		return false
	end

	return false
end
