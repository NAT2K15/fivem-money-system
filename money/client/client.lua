local stuff = {}
Citizen.CreateThread(function() 
    if NetworkIsSessionActive() then
        Citizen.Wait(100)
        TriggerServerEvent('NAT2K15:UPDATEMONEY')
    end
end)

RegisterNetEvent('NAT2K15:UPDATECLIENTMONEY')
AddEventHandler('NAT2K15:UPDATECLIENTMONEY', function(coolarray)
    local id = GetPlayerServerId(PlayerId())
    stuff = coolarray
    if(stuff[id]) then
        SendNUIMessage({action = "update_money", amount = stuff[id].amount, bank = stuff[id].bank})
    end
end)

RegisterNetEvent('NAT2K15:UPDATEPAYCHECK')
AddEventHandler('NAT2K15:UPDATEPAYCHECK', function(moneyarray) 
    stuff = moneyarray
    local id = GetPlayerServerId(PlayerId())
    if(stuff[id]) then
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName("You have received your daily pay check. Amount: $" .. stuff[id].cycle)
        EndTextCommandThefeedPostMessagetext("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", false, 9, "Bank", "Daily Pay Check")
        EndTextCommandThefeedPostTicker(true, false)
        SendNUIMessage({action = "update_money", amount = stuff[id].amount, bank = stuff[id].bank})
    end
end)

RegisterNetEvent('NAT2K15:UPDATEPAY')
AddEventHandler('NAT2K15:UPDATEPAY', function(id, money) 
    stuff = money
    SendNUIMessage({action = "update_money", amount = stuff[id].amount, bank = stuff[id].bank})
end)

RegisterNetEvent('NAT2K15:BANKNOTIFY')
AddEventHandler('NAT2K15:BANKNOTIFY', function(msg) 
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostMessagetext("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", false, 9, "Bank", "Account Notification")
    EndTextCommandThefeedPostTicker(true, false)
end)

exports('getclientaccount', function(id) 
    if(stuff[id]) then
        return stuff[id]
    else    
        return nil
    end
end)