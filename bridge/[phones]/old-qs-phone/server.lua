if GetResourceState('qs-smartphone') ~= 'started' then return end

function GetPlayerSource(phoneNumber)
    if not phoneNumber then return nil end
    local players = Bridge.Framework.GetPlayers()
    for _, v in pairs(players) do
        local playerPhoneNumber = exports['qs-base']:GetPlayerPhone(v)
        if playerPhoneNumber == phoneNumber then
            return v
        end
    end
	return nil
end