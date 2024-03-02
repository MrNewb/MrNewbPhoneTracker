if Config.Logs ~= "qb" then return end
if Config.Debug then print("Logs Set To ", Config.Logs) end

function Logs(src, msg)
	return TriggerEvent('qb-log:server:CreateLog', GetCurrentResourceName(), GetCurrentResourceName(), 'red', msg)
end