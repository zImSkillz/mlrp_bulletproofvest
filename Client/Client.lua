ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent("__mlrpVest__:__putVestOn__")
AddEventHandler("__mlrpVest__:__putVestOn__", function()
	local ped = PlayerPedId()

	local currentDrawable = GetPedDrawableVariation(ped, 9)
	
	if currentDrawable == -1 or currentDrawable == 0 then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				-- if Male
				if ESX.PlayerData.job.name == "police" then
					SetPedComponentVariation(ped, 9, 53, 0, 0)
				else
					SetPedComponentVariation(ped, 9, 14, 0, 0)
				end
			else
				-- if Female
				if ESX.PlayerData.job.name == "police" then
					SetPedComponentVariation(ped, 9, 30, 0, 0)
				else
					SetPedComponentVariation(ped, 9, 20, 2, 0)
				end
			end
		end)
	end
end)