--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================

inMenu = true
local showblips = true
local atbank = false
local bankMenu = true


--===============================================
--==             Core Threading                ==
--===============================================
if bankMenu then
	Citizen.CreateThread(function()
    while true do
      Wait(0)
      if nearBank() then
		if IsControlJustPressed(1, 38) then
			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			TriggerServerEvent('bank:balance')
		end
			  
		if IsControlJustPressed(1, 322) then
			inMenu = false
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
        DisplayHelpText("Press ~INPUT_PICKUP~ to access the bank ~b~")
      elseif nearATM() then
		if IsControlJustPressed(1, 38) then
			inMenu = true
			SetNuiFocus(true, true)
			SendNUIMessage({type = 'openGeneral'})
			TriggerServerEvent('bank:balance')
		end
			  
		if IsControlJustPressed(1, 322) then
			inMenu = false
			SetNuiFocus(false, false)
			SendNUIMessage({type = 'close'})
		end
        DisplayHelpText("Press ~INPUT_PICKUP~ to access the ATM ~b~")
      end

   
    end
  end)
end
--===============================================
--==             Map Blips	                   ==
--===============================================
Citizen.CreateThread(function()
	
	if showblips then
	  for k,v in ipairs(config.banks)do
		local blip = AddBlipForCoord(v.x, v.y, v.z)
		SetBlipSprite(blip, v.id)
		SetBlipScale(blip, 1.0)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(tostring(v.name))
		EndTextCommandSetBlipName(blip)
	  end
	end
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNetEvent('currentbalance1')
AddEventHandler('currentbalance1', function(balance)
	local id = PlayerId()
	local playerName = GetPlayerName(id)
	
	SendNUIMessage({
		type = "balanceHUD",
		balance = balance,
		player = playerName
	})
end)
--===============================================
--==           Deposit Event                   ==
--===============================================
RegisterNUICallback('deposit', function(data)
	TriggerServerEvent('bank:deposit', tonumber(data.amount))
end)

--===============================================
--==          Withdraw Event                   ==
--===============================================
RegisterNUICallback('withdrawl', function(data)
	TriggerServerEvent('bank:withdraw', tonumber(data.amountw))
end)

--===============================================
--==         Balance Event                     ==
--===============================================
RegisterNUICallback('balance', function()
	TriggerServerEvent('bank:balance')
end)

RegisterNetEvent('balance:back')
AddEventHandler('balance:back', function(balance)
	SendNUIMessage({type = 'balanceReturn', bal = balance})
end)
--===============================================
--==         Transfer Event                    ==
--===============================================
RegisterNUICallback('transfer', function(data)
	TriggerServerEvent('bank:transfer', data.to, data.amountt)
	
end)
--===============================================
--==               NUIFocusoff                 ==
--===============================================
RegisterNUICallback('NUIFocusOff', function()
  inMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({type = 'closeAll'})
end)
--===============================================
--==            Capture Bank Distance          ==
--===============================================
function nearBank()
	local player = GetPlayerPed(-1)
	local coords = GetEntityCoords(player, 0)
	
	for _, search in pairs(config.banks) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, coords['x'], coords['y'], coords['z'], true)
		
		if distance <= 3 then
			return true
		end
	end
end

function nearATM()
	local player = GetPlayerPed(-1)
	local coords = GetEntityCoords(player, 0)
	for _, search in pairs(config.atms) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, coords['x'], coords['y'], coords['z'], true)
		if distance <= 3 then
			return true
		end
	end
end


function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		RemoveMultiplayerBankCash()
		RemoveMultiplayerHudCash()
	end
end)