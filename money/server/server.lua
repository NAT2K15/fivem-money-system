if (GetCurrentResourceName() ~= "money") then
    print("[^1DEBUG^0] Please make sure the resource name is ^3money^0 or else exports won't work.")
end

local accounts = {}

RegisterNetEvent('NAT2K15:CHECKSQL')
AddEventHandler('NAT2K15:CHECKSQL', function(steam, discord, first_name, last_name, twt, dept, dob, gender, data) 
    local src = source
    if(accounts[src]) then
        MySQL.Async.execute("UPDATE money SET bank = @bank, amount = @amount WHERE steam = @steam AND first = @first AND last = @last AND dept = @dept", {["@bank"] = accounts[src].bank, ["@amount"] = accounts[src].amount, ["@steam"] = steam, ["@first"] = accounts[src].first, ["@last"] = accounts[src].last, ["@dept"] = accounts[src].dept})
        
    end
    MySQL.Async.fetchAll("SELECT * FROM money WHERE steam = @steam AND first = @first AND last = @last AND dept = @dept", {["@steam"] = steam, ["@first"] = first_name, ["@last"] = last_name, ["@dept"] = dept}, function(data) 
        if(data[1] == nil) then
            MySQL.Async.execute("INSERT INTO money (steam, discord, first, last, dept, bank) VALUES (@steam, @discord, @first, @last, @dept, @bank)", {["@steam"] = steam, ["@discord"] = discord, ["@first"] = first_name, ["@last"] = last_name,  ["@dept"] = dept, ["@bank"] = config.starting_money })
            accounts[src] = {steam = steam, discord = discord, amount = 0, bank = tonumber(config.starting_money), cycle = config.deptPay[dept], dept = dept, first = first_name, last = last_name}
            TriggerClientEvent('NAT2K15:UPDATECLIENTMONEY', src, accounts[src])
        else 
            accounts[src] = {steam = steam, discord = discord, amount = tonumber(data[1].amount), bank = tonumber(data[1].bank), cycle = config.deptPay[dept], dept = dept, first = first_name, last = last_name}
            TriggerClientEvent('NAT2K15:UPDATECLIENTMONEY', src, accounts[src])
        end
    end)
end)

-- if(config.enable_change_your_own_cycle) then
--     RegisterCommand('setsalary', function(source, args, message) 
--         local length = args[1];
--         if(length == nil) then return TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Please ensure to have a valid amount.") end
--         length = tonumber(length)
--         if(length == nil) then return TriggerClientEvent('chatMessage', source, "[^3SYSTEM^0] Please ensure to have a valid amount.") end
--         if(length > 99999) then length = 99999 end
--         if(length < 0) then length = config.deptPay[accounts[source].dept] end
--         TriggerClientEvent('chatMessage', source, "[^3BANK^0] Your daily salary has been changed to ^2" .. length)
--         if(accounts[source]) then
--             accounts[source].cycle = length
--             TriggerClientEvent('NAT2K15:UPDATECLIENTMONEY', source, accounts[source])
--         end
--     end)
-- end

AddEventHandler('playerDropped', function(reason) 
    local src = source
    if(accounts[src]) then 
        MySQL.Async.fetchAll("SELECT * FROM money WHERE steam = @steam AND first = @first AND last = @last AND dept = @dept", {["@steam"] = accounts[src].steam, ["@first"] =  accounts[src].first, ["@last"] =  accounts[src].last, ["@dept"] =  accounts[src].dept}, function(data) 
            if(data[1] ~= nil) then
                MySQL.Async.execute("UPDATE money SET amount = @amount, bank = @bank WHERE steam = @steam AND first = @first AND last = @last AND dept = @dept", {["@steam"] = accounts[src].steam, ["@amount"] = tonumber(accounts[src].amount), ["@bank"] = tonumber(accounts[src].bank), ["@first"] =  accounts[src].first, ["@last"] =  accounts[src].last, ["@dept"] =  accounts[src].dept})
                print("^3[Money Saving Account]^0 Saving " .. accounts[src].discord .. " Steam: " .. accounts[src].discord .. " Name: " .. accounts[src].first .. " " .. accounts[src].last .. "Bank: " .. accounts[src].bank .. " Cash: " .. accounts[src].amount)
            end
        end)
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(config.cycle_length * 1000 * 60) -- config.cycle_length * 1000 * 60
        for _, player in ipairs(GetPlayers()) do
            player = tonumber(player)
            local src = player
            if(accounts[player]) then
                if(accounts[player].dept) then
                    accounts[player].bank =  config.deptPay[accounts[player].dept] + tonumber(accounts[player].bank)
                    TriggerClientEvent('NAT2K15:UPDATEPAYCHECK', player, player, accounts[player])
                end
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
        TriggerClientEvent('NAT2K15:UPDATEPAY', id, id, accounts[id])
        return true
    else 
        return nil
    end
end)

exports('sendmoney', function(id, sendid, idarray, sendidarray) 
    if(accounts[id]) then
        accounts[id].amount = idarray.cash
        accounts[id].bank = idarray.bank
        TriggerClientEvent('NAT2K15:UPDATEPAY', id, id, accounts[id])
    end

    if(accounts[sendid]) then
        accounts[sendid].amount = sendidarray.cash
        accounts[sendid].bank = sendidarray.bank
        TriggerClientEvent('NAT2K15:UPDATEPAY', sendid, id, accounts[sendid])
    end
end)


exports('bankNotify', function(id, message) 
    TriggerClientEvent('NAT2K15:BANKNOTIFY', id, message)
end)
