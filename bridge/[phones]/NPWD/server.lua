if GetResourceState('NPWD') ~= 'started' then return end

--Untested code, please test before using in production.
function GetPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
    local players = Bridge.Framework.GetPlayers()
    for _, playerID in pairs(players) do
        local phoneData = exports.npwd.getPlayerData({ source = playerID })
        local meh = phoneData.phoneNumber
        if meh == phoneNumber then
            return playerID
        end
    end
	return nil
end