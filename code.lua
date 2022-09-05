--Client-Side
--Colocar esse abaixo da linha 10
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVISIBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Spectate"] = false


--CLIENT-SIDE
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:INITSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:initSpectate")
AddEventHandler("admin:initSpectate",function(source)
	if not NetworkIsInSpectatorMode() then
		local Pid = GetPlayerFromServerId(source)
		local Ped = GetPlayerPed(Pid)

		NetworkSetInSpectatorMode(true,Ped)
		LocalPlayer["state"]["Spectate"] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:resetSpectate")
AddEventHandler("admin:resetSpectate",function()
	if NetworkIsInSpectatorMode() then
		NetworkSetInSpectatorMode(false)
		LocalPlayer["state"]["Spectate"] = false
	end
end)



--SERVER-SIDE


-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = false
RegisterCommand("spectate",function(source,args)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if Spectate then
				Spectate = false
				TriggerClientEvent("admin:resetSpectate",source)
				TriggerClientEvent("Notify",source,"amarelo","Desativado.",5000)
			else
				Spectate = true
				TriggerClientEvent("admin:initSpectate",source)
				TriggerClientEvent("Notify",source,"verde","Ativado.",5000)
			end
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = {}
RegisterCommand("spectate",function(source,args)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			if Spectate[user_id] then
				TriggerClientEvent("Notify",source,"verde","Desativado.",5000)

				local Ped = GetPlayerPed(Spectate[user_id])
				if DoesEntityExist(Ped) then
					SetEntityDistanceCullingRadius(Ped,0.0)
				end

				TriggerClientEvent("admin:resetSpectate",source)
				Spectate[user_id] = nil
			else
				TriggerClientEvent("Notify",source,"verde","Ativado.",5000)

				local nsource = vRP.userSource(args[1])
				if nsource then
					local Ped = GetPlayerPed(nsource)
					if DoesEntityExist(Ped) then
						SetEntityDistanceCullingRadius(Ped,999999999.0)
						Wait(1000)
						TriggerClientEvent("admin:initSpectate",source,nsource)
						Spectate[user_id] = nsource
					end
				end
			end
		end
	end
end)


--SERVER-SIDE
--TROCAR O PLAYERDESCONNECT

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect",function(user_id)
	if Spectate[user_id] then
		Spectate[user_id] = nil
	end
end)


-- VA NO SCRIPT PREMIUM E TROCA ESSA LINHA

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCHECK
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if NetworkIsInSpectatorMode() and not LocalPlayer["state"]["Spectate"] then
			TriggerServerEvent("admin:Print","Ativou o modo espectador.")
		end

		if GetUsingseethrough() then
			TriggerServerEvent("admin:Print","Ativou a visão termica.")
		end

		if GetUsingnightvision() then
			TriggerServerEvent("admin:Print","Ativou a visão noturna.")
		end

		local DetectableTextures = {
			{ txd = "HydroMenu", txt = "HydroMenuHeader", name = "HydroMenu" },
			{ txd = "John", txt = "John2", name = "SugarMenu" },
			{ txd = "darkside", txt = "logo", name = "Darkside" },
			{ txd = "ISMMENU", txt = "ISMMENUHeader", name = "ISMMENU" },
			{ txd = "dopatest", txt = "duiTex", name = "Copypaste Menu" },
			{ txd = "fm", txt = "menu_bg", name = "Fallout" },
			{ txd = "wave", txt = "logo", name = "Wave" },
			{ txd = "wave1", txt = "logo1", name = "Wave (alt.)" },
			{ txd = "meow2", txt = "woof2", name = "Alokas66", x = 1000, y = 1000 },
			{ txd = "adb831a7fdd83d_Guest_d1e2a309ce7591dff86", txt = "adb831a7fdd83d_Guest_d1e2a309ce7591dff8Header6", name = "Guest Menu" },
			{ txd = "hugev_gif_DSGUHSDGISDG", txt = "duiTex_DSIOGJSDG", name = "HugeV Menu" },
			{ txd = "MM", txt = "menu_bg", name = "MetrixFallout" },
			{ txd = "wm", txt = "wm2", name = "WM Menu" }
		}

		for i,data in pairs(DetectableTextures) do
			if data.x and data.y then
				if GetTextureResolution(data.txd,data.txt).x == data.x and GetTextureResolution(data.txd,data.txt).y == data.y then
					TriggerServerEvent("admin:Print","Carregou textura do Monster Menu.")
				end
			else 
				if GetTextureResolution(data.txd,data.txt).x ~= 4.0 then
					TriggerServerEvent("admin:Print","Carregou textura do Monster Menu.")
				end
			end
		end

		Wait(10000)
	end
end)