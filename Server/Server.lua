ESX = exports['es_extended']:getSharedObject()

local bulletProofList = {}

CreateThread(function()
	while true do
		Wait(2000)
		
		for _, playerId in ipairs(GetPlayers()) do
			local src = tostring(playerId)
			local plyPed = GetPlayerPed(playerId)
			local pedBProof = GetPedArmour(plyPed) or 0
			
			if bulletProofList[tostring(src)] ~= nil and bulletProofList[tostring(src)].time ~= nil then
				local listMetaData = bulletProofList[tostring(src)].metadata
				
				local invItems = exports.ox_inventory:GetInventoryItems(tonumber(src), false)
				local slotId = 0
				
				for k, v in pairs(invItems) do
					if v.name ~= nil then
						if v.name == "armor" then
							if v.metadata ~= nil then
								if v.metadata.timeused == bulletProofList[tostring(src)].time then
									slotId = v.slot
								end
							end
						end
					end
				end
				
				if slotId ~= nil and slotId ~= 0 then
					exports.ox_inventory:SetDurability(tonumber(src), slotId, pedBProof)
				else
					bulletProofList[tostring(src)] = {time = nil, metadata = nil}
					SetPedArmour(plyPed, 0)
				end
			end
		end
	end
end)

exports('use_bulletproofvest', function(event, item, inventory, slot, data)
	local src = inventory.id
	
    if event == 'usingItem' then
		if bulletProofList[tostring(src)] ~= nil then
			if bulletProofList[tostring(src)].time ~= nil then
				local plyPed = GetPlayerPed(src)
				
				SetPedComponentVariation(plyPed, 9, 0, 0, 0)
				
				bulletProofList[tostring(src)] = {time = nil, metadata = nil}
				SetPedArmour(plyPed, 0)
				return
			end
		end
        local itemSlot = exports.ox_inventory:GetSlot(inventory.id, slot)
				
		local plyPed = GetPlayerPed(src)
		local metadata = itemSlot.metadata
		
		metadata.alreadyUsed = true
		
		local time = os.time()
		
		if bulletProofList[tostring(src)] == nil then
			bulletProofList[tostring(src)] = {time = nil, metadata = nil}
		end
		
		bulletProofList[tostring(src)] = {time = time, metadata = metadata}
		
		metadata.timeused = time
		
		local durability = metadata.durability or 0
		
		SetPedArmour(plyPed, durability)
		
		TriggerClientEvent("__mlrpVest__:__putVestOn__", src)
		
		if metadata.alreadyUsed then
			metadata.description = "Gebrauchsspuren: Gefunden"
		else
			metadata.description = "Gebrauchsspuren: Nicht gefunden"
		end
		
		
		exports.ox_inventory:SetMetadata(src, itemSlot.slot, metadata)
    end
end)
 
local hookId = exports.ox_inventory:registerHook('createItem', function(payload)	
	local metadata = payload.metadata
	
	if metadata.durability == nil or not tonumber(metadata.durability) then
	
		metadata.label = "Schutzweste"
		metadata.alreadyUsed = false
		metadata.durability = 100
		metadata.timeused = 0
		metadata.description = "Gebrauchsspuren: Nicht gefunden"
		
		return metadata
	else
		return metadata
	end
end, {
    itemFilter = {
        armor = true
    }
})