Config = {}

Config.Framework = 'QB' -- 'ESX' or 'QB'
Config.Unit = 'MPH' -- 'MPH' or 'KMH'
Config.Limit = 155
Config.Whitelist = {
    enabled = true,
    list = {
        --'POLICE1',
        --'POLICE2',
    }
}

Config.NPC = {
    enabled = true,
    location = vector4(108.0937, 6625.2417, 30.7872, 302.5849),
    price = 10000,
}

RegisterNetEvent("t3_speedlimiter:notify", function(title, msg, duration, type)
    --add your own notification system here or select one of the following
      --ESX.ShowNotification(msg)
      QBCore.Functions.Notify(msg, type)
      --exports['okokNotify']:Alert(title, string.gsub(msg, '(~[rbgypcmuonshw]~)', ''), duration, type)
      --exports['mythic_notify']:DoCustomHudText(type, string.gsub(msg, '(~[rbgypcmuonshw]~)', ''), duration)
end)