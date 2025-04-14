if GetResourceState('lb-phone') ~= 'started' then return end

function GetPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
    local playerID = exports["lb-phone"]:GetSourceFromNumber(phoneNumber)
	return playerID
end