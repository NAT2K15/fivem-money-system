--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================



RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local _source = source
	local xPlayer = exports.money:getaccount(_source)
	amount = tonumber(amount)
	if xPlayer == nil or amount == nil or amount < 0 then
		exports.money:bankNotify(_source, "There was an error getting the account Information")
	else
		local quickmath = xPlayer.amount - amount;
		if(quickmath < 0 or quickmath == nil) then
			exports.money:bankNotify(_source, "You don't have enough money to execute this transaction.")
		else 
			local fix = {cash = quickmath, bank = xPlayer.bank + amount}
			exports.money:updateaccount(_source, fix)
			exports.money:bankNotify(_source, "You have deposited: ~g~$" .. amount)
		end
	end
end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local _source = source
	local xPlayer = exports.money:getaccount(_source)
	amount = tonumber(amount)
	if xPlayer == nil or amount == nil or amount < 0 then
		exports.money:bankNotify(_source, "There was an error getting the account Information")
	else
		local quickmath = xPlayer.bank - amount;
		if(quickmath < 0 or quickmath == nil) then
			exports.money:bankNotify(_source, "You don't have enough money to execute this transaction.")
		else 
			local fix = {cash = xPlayer.amount + amount, bank = quickmath}
			exports.money:updateaccount(_source, fix)
			exports.money:bankNotify(_source, "You have withdraw: ~g~$" .. amount)
		end
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = exports.money:getaccount(_source)
	if xPlayer == nil then
		exports.money:bankNotify(_source, "There was an error getting the account Information")
	else
		TriggerClientEvent('currentbalance1', _source, xPlayer.bank)
	end
end)


RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amountt)
	local _source = source
	local xPlayer = exports.money:getaccount(_source)
	local rip = tonumber(to)
	local zPlayer = exports.money:getaccount(rip)
	local amount = tonumber(amountt)
	if tonumber(_source) == rip then
		exports.money:bankNotify(_source, "You cannot transfer funds to yourself.")
	elseif (amount == nil or amount < 0) then
		exports.money:bankNotify(_source, "Invalid amount.")
	else
		if (rip == nil) then
			exports.money:bankNotify(_source, "You cannot transfer funds to yourself.")
		else 
			local quickmath = xPlayer.bank - amount;
			if(quickmath < 0 or quickmath == nil) then
				exports.money:bankNotify(_source, "There was an error getting the account Information.")
			else 
				local xarray = {cash = xPlayer.amount, bank = quickmath}
				local zarray = {cash = zPlayer.amount, bank = zPlayer.bank + amount}
				exports.money:updateaccount(_source, xarray)
				exports.money:updateaccount(rip, zarray)
				exports.money:bankNotify(_source, "You have transfered ~r~$" .. amount .. " to " .. GetPlayerName(tonumber(to)) .. " [#" .. to .. "]")
				exports.money:bankNotify(rip, "You have received: ~g~$" .. amount .. " from ~g~" .. GetPlayerName(tonumber(_source)) .. " [#" .. to .. "]")
			end	
		end
	end
end)

