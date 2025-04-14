if GetResourceState('yseries') ~= 'started' then return end

function GetPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
	local response = exports.yseries:GetPlayerSourceIdByPhoneNumber(phoneNumber)
	return response
end