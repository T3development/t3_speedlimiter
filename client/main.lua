ESX, QBCore = nil, nil
LastVeh, Limit = nil, true

Citizen.CreateThread(function()
	if Config.Framework == 'ESX' then
		while ESX == nil do
            ESX = exports["es_extended"]:getSharedObject()
			Citizen.Wait(0)
		end
	elseif Config.Framework == 'QB' then
		while QBCore == nil do
			QBCore = exports['qb-core']:GetCoreObject()
			Citizen.Wait(0)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		while not IsPedInAnyVehicle(PlayerPedId(), false) do
			Citizen.Wait(5000)
		end
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= LastVeh and vehicle ~= nil then
            LastVeh = vehicle
            if Config.Framework == 'ESX' then
                ESX.TriggerServerCallback('t3_speedlimiter:isUnlimited', function(result)
                    if result then
                        Limit = false
                    else
                        Limit = true
                    end
                end, GetVehicleNumberPlateText(vehicle))
            elseif Config.Framework == 'QB' then
                QBCore.Functions.TriggerCallback('t3_speedlimiter:isUnlimited', function(result)
                    if result then
                        Limit = false
                    else
                        Limit = true
                    end
                end, GetVehicleNumberPlateText(vehicle))
            end
        end
		if vehicle ~= nil and Limit then
			setSpeed(Config.Limit,vehicle)
		elseif vehicle ~= nil and not Limit then
			setSpeed(100000,vehicle)
		end
	end
end)

function setSpeed(speed,vehicle)
	local vehicleDefaultSpeed = GetVehicleEstimatedMaxSpeed(vehicle)
	local vehicleClass = GetVehicleClass(vehicle)
	if Config.Unit == 'KMH' then
		speed = speed / 3.6
    elseif Config.Unit == 'MPH' then
		speed = speed / 2.23694
	end
	if (vehicleClass ~= 16) or  (vehicleClass ~= 15) then
		if vehicleDefaultSpeed > speed then
			if Config.Whitelist.enabled then
				local veh = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
				for k,v in pairs(Config.Whitelist.list) do
					if v == veh then 
						SetVehicleMaxSpeed(vehicle, 0.0)
						return
					end
				end
			end
			SetVehicleMaxSpeed(vehicle, speed)
		else
			SetVehicleMaxSpeed(vehicle, 0.0)
		end
	end
end

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end
function continue(data)
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    TriggerServerEvent('t3_speedlimiter:delimit', GetVehicleNumberPlateText(vehicle))
    Limit = false
    local vehicleDefaultSpeed = GetVehicleEstimatedMaxSpeed(vehicle)
    SetVehicleMaxSpeed(vehicle, 0.0)
	-- Ped Animation
	if data and data.ped then
		Citizen.CreateThread(function()
			FreezeEntityPosition(vehicle, true)
			SetVehicleDoorOpen(vehicle, 4, false, false)
			Citizen.Wait(500)
			LoadAnim('mini@repair')
			TaskPlayAnim(data.ped, 'mini@repair', 'fixing_a_ped', 2.0, 2.0, -1, 51, 0, false, false, false)
			Citizen.Wait(2000)
			ClearPedTasks(data.ped)
			Citizen.Wait(500)
			SetVehicleDoorShut(vehicle, 4, false)
			Citizen.Wait(500)
			FreezeEntityPosition(vehicle, false)
			-- Notification
			TriggerEvent('t3_speedlimiter:notify', 'Speed Limiter', 'Vehicle Delimited', 5000, 'success')
		end)
	end
end
RegisterNetEvent('t3_speedlimiter:delimit', function(data)
	if data and data.price then
		if Config.Framework == 'ESX' then
			ESX.TriggerServerCallback('t3_speedlimiter:funds', function(result)
				if result == true then
					continue(data)
				end
			end, data.price)
		elseif Config.Framework == 'QB' then
			QBCore.Functions.TriggerCallback('t3_speedlimiter:funds', function(result)
				if result == true then
					continue(data)
				end
			end, data.price)
		end
	end
end)