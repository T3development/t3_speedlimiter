if Config.NPC.enabled then
    local n = Config.NPC
    local ped = CreatePed(4, GetHashKey("mp_m_waremech_01"), n.location.x, n.location.y, n.location.z, n.location.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    --Place your target option here
    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = "client",
                event = "t3_speedlimiter:delimit",
                icon = "fas fa-gauge",
                label = "Remove Limiter",
                price = Config.NPC.price,
                ped = ped,
                canInteract = function(entity)
                    if not IsPedInAnyVehicle(PlayerPedId(), true) then
                        return false
                    end
                    if Config.Framework == 'ESX' then
                        ESX.TriggerServerCallback('t3_speedlimiter:isUnlimited', function(result)
                            if result then
                                return false
                            end
                        end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
                    elseif Config.Framework == 'QB' then
                        QBCore.Functions.TriggerCallback('t3_speedlimiter:isUnlimited', function(result)
                            if result then
                                return false
                            end
                        end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false)))
                    end
                    return true
                end,
            },
        },
        distance = 3.0
    })
end