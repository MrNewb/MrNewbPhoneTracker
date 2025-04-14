if GetResourceState('qb-phone') ~= 'started' or GetResourceState("jp-phone") ~= 'started' or GetResourceState("renewed-phone") ~= 'started' then return end

local qb = exports['qb-core']:GetCoreObject()

function GetPlayerSource(phoneNumber)
	if not phoneNumber then return nil end
	return qb.Functions.GetPlayerByPhone(phoneNumber)
end