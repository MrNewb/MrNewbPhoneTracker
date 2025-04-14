if GetResourceState('okokPhone') ~= 'started' then return end

function GetPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
    local TargetSource = exports['okokPhone']:getSourceFromPhoneNumber(phoneNumber)
    if not TargetSource then return nil end
    return TargetSource
end