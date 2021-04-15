function help_message(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function giveWeapon(hash)
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(hash), 999, false, false)
end

function notify_message(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(true, false)
end

function notifyPicture(icon, type, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, type, sender, title, text)
    DrawNotification(false, true)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
    end

function position_verf(x, y, z, cx, cy, cz, radius)
    local t1 = x - cx
    local t12 = t1^2
    
    local t2 = y-cy
    local t21 = t2^2
    
    local t3 = z - cz
    local t31 = t3^2
    
    return (t12 + t21 + t31) <= radius^2
end
    
positions = {
    {1548.94,836.82,76.65,0},
    {1858.64,3690.97,33.56,0},
}

local policeloadout = {
	{['i'] = 1, ['weapon'] = "WEAPON_FLASHLIGHT"},
	{['i'] = 2, ['weapon'] = "WEAPON_COMBATPISTOL"},
   	{['i'] = 3, ['weapon'] = "WEAPON_VINTAGEPISTOL"},
	{['i'] = 4, ['weapon'] = "WEAPON_STUNGUN"},
	{['i'] = 5, ['weapon'] = "WEAPON_PUMPSHOTGUN"},
    {['i'] = 6, ['weapon'] = "WEAPON_PUMPSHOTGUN_MK2"},
	{['i'] = 7, ['weapon'] = "WEAPON_CARBINERIFLE"},
	{['i'] = 8, ['weapon'] = "WEAPON_NIGHTSTICK"},
}

RegisterNetEvent("yt:policeLoadout")
AddEventHandler("yt:policeLoadout", function()
 RemoveAllPedWeapons(GetPlayerPed(-1))
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local player = GetPlayerPed(-1)
        local playerLoc = GetEntityCoords(player)

        for _,location in ipairs(positions) do

            x = location[1]
            y = location[2]
            z = location[3]

            DrawMarker(27, x, y, z, 0, 0, 0, 0, 0, 0, 1.101, 1.1001, 0.2001, 0, 127, 255, 200, 0, 0, 0, 1)
            if position_verf(playerLoc.x, playerLoc.y, playerLoc.z, x, y, z, 1) then
				help_message("~BLIP_INFO_ICON~ Press E to get loadout")
                if IsControlJustReleased( 0, 38 ) then
					 if Config.tnotify == false then
						help_message("~BLIP_INFO_ICON~ Grabbing police loadout")
					end
					if Config.tnotify == true then
						exports['t-notify']:Image({
                            style = 'info',
                            duration = Config.armourtimer * 1000 - 1000,
                            title = 'Grabbing Police Loadout',
                            image = Config.imagenotify,
                            sound = false
                        })
					end
                    loadAnimDict( "amb@world_human_cop_idles@male@base" )
                    loadAnimDict( "amb@world_human_cop_idles@male@idle_a" )
                    TaskPlayAnim(GetPlayerPed(-1),"amb@world_human_cop_idles@male@base", "base",2.0, -1.0, 7000, 0, 7, false, false, false)
                    TaskPlayAnim(GetPlayerPed(-1),"amb@world_human_cop_idles@male@idle_a", "idle_a",3.0, -1.0, 7000, 0, 7, false, false, false)
                    local playerPed = GetPlayerPed(-1)
                    Citizen.Wait(Config.armourtimer * 1000)
	                    for k,v in ipairs(policeloadout) do
	                	Citizen.Trace("Weapon: "..v.i.." "..v.weapon.." Given to ".. playerPed)
	                      GiveWeaponToPed(playerPed, GetHashKey(v.weapon), 9999, true, true)
                          SetPedComponentVariation(GetPlayerPed(-1), 9, Config.armournumber, Config.armourtexture, 0)
                          SetPedArmour(GetPlayerPed(-1), Config.armourlevel)
                     end
					  if Config.tnotify == false then
                        help_message("~BLIP_INFO_ICON~ Police Loadout Given")
					  end
						if Config.tnotify == true then
							exports['t-notify']:Image({
                                style = 'info',
                                duration = Config.armourtimer * 1000 - 1000,
                                title = 'Police Loadout Given',
                                image = Config.imagenotify,
                                sound = false
                            })
						end
					end
                end
            end
        end
    end)
