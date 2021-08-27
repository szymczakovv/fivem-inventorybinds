<img width="150" height="150" align="left" style="float: left; margin: 0 10px 0 0;" alt="Szymczakovv" src="https://i.imgur.com/42AnCgD.jpg">  

# ESX Inventory Binds
[![Paypal Doante](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.me/oplatyprimerp)
[![Discord](https://discordapp.com/api/guilds/690686401469087756/embed.png)](https://discord.gg/wrSqK6k)

<br></br>
# Authors:
 * Szymczakovv: https://szymczakovv.me/ | https://discord.gg/wrSqK6k
 * definitely not PK!?: https://api-anticheat.xyz/ | https://discord.gg/wNJXWh6
<br></br>
# ICONS:

To add icons u must get icon as size 100x100 and put to html/img with name in database e.g; apple.png

# SQL:

```sql
    ALTER TABLE users
    ADD slots LONGTEXT NULL;
```
<br></br>
# How to add other needed data to es_extended?

 * Go to es_extended/client/functions.lua and search "ESX.ShowInvnetory()" and go to this function,
 * Add this in line 822;
```
  table.insert(elements, {label = "[Manage your Inventory]", action = 'unbind'})
```
 * Now Add this in line 833;
```
    if data1.current.action == 'bind' then
        openBindsMenu(item)
    end
  if data.current.action == 'unbind' then
    ExecuteCommand('bindmanage')
  end
```
 * Go to line: 759 and add this function;
```
  local Weapons = { --// here is list of weapons can add to binds
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
  CheckWeapons = function(item)
    local send = false	
    for i=1, #Weapons, 1 do
      if (string.lower(item) == string.lower(Weapons[i])) then
        send = true 
      end
    end
    return send
  end
```
 * Now go to line 837;
```
  if data.current.usable or CheckWeapons(data.current.value) then
      table.insert(elements, {label = "Assign [1-5]", action = 'bind', type = data.current.type, value = data.current.value, number = data.current.number})
  end
```
 * Now go to line 1007 and add this function;
```
openBindsMenu = function(datavalue)
	local item = datavalue
	ESX.UI.Menu.CloseAll()

	local elements = {}
	
	ESX.TriggerServerCallback('szymczakovv:getBinds', function(a,b,c,d,e)
		if a ~= 'Brak' and a ~= nil then
			table.insert(elements, { label = '[1] - Przypisany: '..tostring(a), what = 'first' })
		else
			table.insert(elements, { label = '[1] - Wolne', what = 'first' })
		end
		if b ~= 'Brak' and b ~= nil then
			table.insert(elements, { label = '[2] - Przypisany: '..tostring(b), what = 'second' })
		else
			table.insert(elements, { label = '[2] - Wolne', what = 'second' })
		end
		if c ~= 'Brak' and c ~= nil then
			table.insert(elements, { label = '[3] - Przypisany: '..tostring(c), what = 'third' })
		else
			table.insert(elements, { label = '[3] - Wolne', what = 'third' })
		end
		if d ~= 'Brak' and d ~= nil then
			table.insert(elements, { label = '[4] - Przypisany: '..tostring(d), what = 'fourth' })
		else
			table.insert(elements, { label = '[4] - Wolne', what = 'fourth'})
		end
		if e ~= 'Brak' and e ~= nil then
			table.insert(elements, { label = '[5] - Przypisany: '..tostring(e), what = 'fifth'})
		else
			table.insert(elements, { label = '[5] - Wolne', what = 'fifth'})
		end
	end)

	Wait(500)

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'bagol',
		{
			title    = "Zarządzanie Ekwipunkiem",
			align	 = "bottom-right",
			elements = elements
		}, function(data, menu)
			TriggerServerEvent('szymczakovv:RegisterItemToSlot', data.current.what, item)
			openBindsMenu(item)
		end,
	function(data, menu)
		menu.close()
	end)
end
```

# SOCIAL MEDIA:
 * https://discord.gg/wrSqK6k
 * https://instagram.com/ou7_szymczakovv
 * https://twitch.tv/szymczakovv 
 * https://www.youtube.com/channel/UCKOp_1PXXfXHgT_01jGCKLg
 * https://twitter.com/szymczakovv
 * https://szymczakovv.me/ | https://szymczakovv.xyz/
