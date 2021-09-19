if (GetCurrentResourceName() ~= "money") then
    print("[^1DEBUG^0] Please make sure the resource name is ^3money^0 or else exports won't work.")
end

local accounts = {}


RegisterNetEvent('NAT2K15:UPDATEMONEY')
AddEventHandler('NAT2K15:UPDATEMONEY', function() 
    local src = source
    local steam = GetPlayerIdentifier(source, 0)
    local discord = ""
    for k,v in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(v, 'discord:') then
			discord = string.sub(v, 9)
		end
	end
    MySQL.Async.fetchAll("SELECT * FROM money WHERE steam = @steam", {["@steam"] = steam}, function(data) 
        if(data[1] == nil) then
            MySQL.Async.execute("INSERT INTO money (steam, discord, bank) VALUES (@steam, @discord, @bank)", {["@steam"] = steam, ["@discord"] = discord, ["@bank"] = config.starting_money })
            accounts[src] = {steam = steam, discord = discord, amount = 0, bank = config.starting_money, cycle = config.cycle_amount}
            TriggerClientEvent('NAT2K15:UPDATECLIENTMONEY', src, accounts)
        else 
            accounts[src] = {steam = steam, discord = discord, amount = data[1].amount, bank = data[1].bank, cycle = config.cycle_amount}
            TriggerClientEvent('NAT2K15:UPDATECLIENTMONEY', src, accounts)
        end
    end)
end)

if(config.enable_change_your_own_cycle) then
    RegisterCommand('setsalary', function(source, args, message) 
        local length = args[1];
        if(length == nil) then return TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Please ensure to have a valid amount.") end
        length = tonumber(length)
        if(length == nil) then return TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Please ensure to have a valid amount.") end
        if(length > 99999) then length = 99999 end
        if(length < 0) then length = config.cycle_amount end
        TriggerClientEvent('chatMessage', source, "[^3BANK^0] Your daily salary has been changed to ^2" .. length)
        if(accounts[source]) then
            accounts[source].cycle = length
            TriggerClientEvent('NAT2K15:UPDATECLIENTMONEY', source, accounts)
        end
    end)
end

AddEventHandler('playerDropped', function(reason) 
    local src = source
    local steam = GetPlayerIdentifier(src, 0)
    MySQL.Async.fetchAll("SELECT * FROM money WHERE steam = @steam", {["@steam"] = steam}, function(data) 
        if(data[1] ~= nil) then
            MySQL.Async.execute("UPDATE money SET amount = @amount, bank = @bank WHERE steam = @steam", {["@steam"] = steam, ["@amount"] = accounts[src].amount, ["@bank"] = accounts[src].bank})
        end
    end)
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(config.cycle_length * 1000 * 60)
        for _, player in ipairs(GetPlayers()) do
            player = tonumber(player)
            local src = player
            if(accounts[player]) then
                accounts[player].bank =  accounts[player].cycle + accounts[player].bank
                TriggerClientEvent('NAT2K15:UPDATEPAYCHECK', player, accounts)
            end
        end
    end
end)

exports('getaccount', function(id) 
    if(accounts[id]) then
        return accounts[id]
    else    
        return nil
    end
end)

exports('updateaccount', function(id, array) 
    if(accounts[id]) then
        accounts[id].amount = array.cash
        accounts[id].bank = array.bank
        TriggerClientEvent('NAT2K15:UPDATEPAY', id, id, accounts)
        return true
    else 
        return nil
    end
end)

exports('sendmoney', function(id, sendid, idarray, sendidarray) 
    if(accounts[id]) then
        accounts[id].amount = idarray.cash
        accounts[id].bank = idarray.bank
        TriggerClientEvent('NAT2K15:UPDATEPAY', id, id, accounts)
    end

    if(accounts[sendid]) then
        accounts[sendid].amount = sendidarray.cash
        accounts[sendid].bank = sendidarray.bank
        TriggerClientEvent('NAT2K15:UPDATEPAY', id, id, accounts)
    end
end)


exports('bankNotify', function(id, message) 
    TriggerClientEvent('NAT2K15:BANKNOTIFY', id, message)
end)