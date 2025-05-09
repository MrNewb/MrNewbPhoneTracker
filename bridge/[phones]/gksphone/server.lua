if GetResourceState('gksphone') ~= 'started' then return end

function GetPlayerSource(phoneNumber)
    if not phoneNumber then return nil end
    return exports["gksphone"]:GetSourceByPhone(phoneNumber)
end