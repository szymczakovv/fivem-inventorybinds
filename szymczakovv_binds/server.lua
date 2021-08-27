ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local InventorySlots = {}

local settings = {
	cache = {},
    cache_used = {},
	timer = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
	},
    weapons = {
        'WEAPON_PISTOL',
        'WEAPON_CERAMICPISTOL',
        'WEAPON_KNIFE',
        'WEAPON_PISTOL_MK2',
        'WEAPON_SNSPISTOL_MK2',
        'WEAPON_VINTAGEPISTOL',
        'WEAPON_SNSPISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_NIGHTSTICK',
        'WEAPON_KNIFE',
        'WEAPON_DAGGER',
        'WEAPON_BAT',
        'WEAPON_BOTTLE',
        'WEAPON_FLASHLIGHT',
        'WEAPON_SWITCHBLADE',
        'WEAPON_STUNGUN',
        'WEAPON_SNSPISTOL',
        'WEAPON_MACHETE',
        'WEAPON_HEAVYPISTOL',
        'WEAPON_REVOLVER'
    }
}

LoadSlots = function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local PreSlots = {}
	
	MySQL.Async.fetchAll("SELECT identifier, slots FROM users WHERE identifier = @identifier", {
		["@identifier"] = xPlayer.getIdentifier()
	}, function(result)

		if result[1].slots ~= nil then
			local data = json.decode(result[1].slots)
			table.insert(PreSlots , {
				identifier = tostring(result[1].identifier),
				first = tostring(data.first),
				second = tostring(data.second),
				third = tostring(data.third),
				fourth = tostring(data.fourth),
				fifth = tostring(data.fifth),
			})
			table.insert(InventorySlots , {
				identifier = tostring(result[1].identifier),
				first = tostring(data.first),
				second = tostring(data.second),
				third = tostring(data.third),
				fourth = tostring(data.fourth),
				fifth = tostring(data.fifth),
			})
		else
			table.insert(PreSlots , {
				identifier = tostring(result[1].identifier),
				first = tostring("Brak"),
				second = tostring("Brak"),
				third = tostring("Brak"),
				fourth = tostring("Brak"),
				fifth = tostring("Brak"),
			})
			table.insert(InventorySlots , {
				identifier = tostring(result[1].identifier),
				first = tostring("Brak"),
				second = tostring("Brak"),
				third = tostring("Brak"),
				fourth = tostring("Brak"),
				fifth = tostring("Brak"),
			})
		end
	end)
	return PreSlots
end

RegisterNetEvent("definitelynotPK:LoadSlots")
AddEventHandler("definitelynotPK:LoadSlots", function()
	local _source = source
	local slots = LoadSlots(_source)

	Wait(2000)
	TriggerClientEvent("szymczakovv:updatebinds", _source, slots)
end)

SelectSlot = function(identifier)
	local toreturn
	for i=1, #InventorySlots, 1 do
		local slot = InventorySlots[i]
		if (tostring(slot.identifier) == tostring(identifier)) then 
			toreturn = slot
		end
	end
	return toreturn
end

CheckWeapons = function(item)
	local send = false	
	for i=1, #settings.weapons, 1 do
		if (string.lower(item) == string.lower(settings.weapons[i])) then
			send = true 
		end
	end
	return send
end

CanUse = function(source, identifier, itemName, data)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if (itemName == tostring('Brak') or itemName == nil) then
        xPlayer.showNotification('Brak przypisanego klawisza')
    else
        if CheckWeapons(itemName) == true then
            local count = xPlayer.getInventoryItem(itemName).count
            if count > 0 then
				TriggerClientEvent('szymczakovv:IsWeapon', _source, itemName)
            else
                xPlayer.showNotification("Nie posiadasz tego przedmiotu! - Usunięto wpis z bazy danych")
                DeleteFromSlot(source, identifier, data)
            end
        else
            local count = xPlayer.getInventoryItem(itemName).count
            if count > 0 then
                return true
            else
                xPlayer.showNotification("Nie posiadasz tego przedmiotu! - Usunięto wpis z bazy danych")
                DeleteFromSlot(source, identifier, data)
            end
        end
    end
end

UseSlot = function(source, identifier, slot_out)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #InventorySlots, 1 do
		if ((tostring(InventorySlots[i].identifier)) == tostring(identifier)) then 
			local sloty = InventorySlots[i]
			local data = slot_out
			if data == 'first' then
				to_use = sloty.first
			elseif data == 'second' then
				to_use = sloty.second
			elseif data == 'third' then
				to_use = sloty.third
			elseif data == 'fourth' then
				to_use = sloty.fourth
			elseif data == 'fifth' then
				to_use = sloty.fifth
			end
			if CanUse(_source, identifier, to_use, data) == true then
				TriggerClientEvent('szymczakovv:useItem', _source, to_use)
			end
		end
	end
end

RegisterItemToSlot = function(source, slot_out, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #InventorySlots, 1 do
		local sloty = InventorySlots[i]
		if ((tostring(sloty.identifier)) == tostring(xPlayer.getIdentifier())) then
			local data = slot_out
			if data == 'first' then
				sloty.first = item
			elseif data == 'second' then
				sloty.second = item
			elseif data == 'third' then
				sloty.third = item
			elseif data == 'fourth' then
				sloty.fourth = item
			elseif data == 'fifth' then
				sloty.fifth = item
			end

			UpdateSlotsDB(sloty, item, xPlayer.getIdentifier(), _source)
		end
	end
end

DeleteFromSlot = function(source, identifier, slot_out)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i=1, #InventorySlots, 1 do
		local sloty = InventorySlots[i]
		if ((tostring(sloty.identifier)) == tostring(identifier)) then 
			local data = slot_out
			if data == 'first' then
				sloty.first = "Brak"
			elseif data == 'second' then
				sloty.second = "Brak"
			elseif data == 'third' then
				sloty.third = "Brak"
			elseif data == 'fourth' then
				sloty.fourth = "Brak"
			elseif data == 'fifth' then
				sloty.fifth = "Brak"
			end
			UpdateSlotsDB(sloty, item, xPlayer.getIdentifier(), _source)
		end
	end	
end

UpdateSlotsDB = function(sloty, item, identifier, source)
	local _source = source
	TriggerClientEvent("szymczakovv:updatebinds", _source, sloty)
	MySQL.Async.execute('UPDATE users SET slots = @sloty WHERE identifier = @license',
	{
		['@sloty'] = json.encode(sloty),
		['@license'] = identifier
	})
end

RegisterServerEvent('szymczakovv:RegisterItemToSlot')
AddEventHandler('szymczakovv:RegisterItemToSlot', function(itemnum, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	RegisterItemToSlot(_source, itemnum, item)
end)

RegisterServerEvent('szymczakovv:UseItemFromBind')
AddEventHandler('szymczakovv:UseItemFromBind', function(num)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	UseSlot(_source, xPlayer.getIdentifier(), num)
end)

RegisterServerEvent('szymczakovv:deleteBind')
AddEventHandler('szymczakovv:deleteBind', function(num)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	DeleteFromSlot(_source, xPlayer.getIdentifier(), num)
end)

ESX.RegisterServerCallback('szymczakovv:getBinds', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local data = SelectSlot(xPlayer.getIdentifier())
	if data ~= nil then
		cb(data.first, data.second, data.third, data.fourth, data.fifth)
	else
		cb("Brak","Brak","Brak","Brak","Brak")
	end
end)
