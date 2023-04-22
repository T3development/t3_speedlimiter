ESX, QBCore = nil, nil
Unlimited = {}
if Config.Framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
    ESX.RegisterServerCallback('t3_speedlimiter:isUnlimited', function(source, cb, plate)
        for k,v in pairs(Unlimited) do
            if v == plate then
                cb(true)
                return
            end
        end
        cb(false)
    end)
    ESX.RegisterServerCallback('t3_speedlimiter:funds', function(source, cb, price)
        local xPlayer = ESX.GetPlayerFromId(source)
        local cash = xPlayer.getMoney()
        if cash >= price then
            xPlayer.removeMoney(price)
            cb(true)
            return
        end
        TriggerClientEvent('t3_speedlimiter:notify', source, 'Speed Limiter', 'Not enough cash!', 5000, 'error')
        cb(false)
    end)
elseif Config.Framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
    QBCore.Functions.CreateCallback('t3_speedlimiter:isUnlimited', function(source, cb, plate)
        for k,v in pairs(Unlimited) do
            if v == plate then
                cb(true)
                return
            end
        end
        cb(false)
    end)
    QBCore.Functions.CreateCallback('t3_speedlimiter:funds', function(source, cb, price)
        local Player = QBCore.Functions.GetPlayer(source)
        local cash = Player.Functions.GetMoney('cash')
        if cash >= price then
            Player.Functions.RemoveMoney('cash', price)
            cb(true)
            return
        end
        TriggerClientEvent('t3_speedlimiter:notify', source, 'Speed Limiter', 'Not enough cash!', 5000, 'error')
        cb(false)
    end)
end
RegisterNetEvent('t3_speedlimiter:delimit', function(plate, price)
    if plate then
		for k,v in pairs(Unlimited) do
			if v == plate then
				return
			end
		end
        table.insert(Unlimited, plate)
    end
end)