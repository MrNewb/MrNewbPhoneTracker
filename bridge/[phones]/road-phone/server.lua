if GetResourceState('roadphone') ~= 'started' then return end

function GetPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
    local Target = exports['roadphone']:getPlayerFromPhone(phoneNumber)
    if not Target then return nil end
    return Target.source
end