local tabletObject = nil
tagetmad = false
madafleveret = false
coordsx = 0
coordsy = 0
coordsz = 0

local random_first_names = {
    "Adam",
	"Agnes",
	"Aksel",
	"Albert",
	"Alberte",
	"Alexander",
	"Alfred",
	"Alma",
	"Andrea",
	"Anna",
	"Anton",
	"Arthur",
	"Asger",
	"Asta",
	"Astrid",
	"August",
	"Augusta",
	"Aya",
	"Benjamin",
	"Bertram",
	"Carl",
	"Caroline",
	"Christian",
	"Clara",
	"Elias",
	"Ella",
	"Ellen",
	"Ellie",
	"Elliot",
	"Emil",
	"Emilie",
	"Emily",
	"Emma",
	"Esther",
	"Felix",
	"Filippa",
	"Frederik",
	"Freja",
	"Frida",
	"Ida",
	"Isabella",
	"Jakob",
	"Jeff",
	"Johan",
	"Johanne",
	"Josefine",
	"Karla",
	"Konrad",
	"Lauge",
	"Laura",
	"Laurits",
	"Lea",
	"Liam",
	"Lily",
	"Liv",
	"Liva",
	"Louie",
	"Lucas",
	"Luna",
	"Lærke",
	"Mads",
	"Magne",
	"Magnus",
	"Maja",
	"Malthe",
	"Marcus",
	"Marie",
	"Marius",
	"Mathias",
	"Mathilde",
	"Mikkel",
	"Mille",
	"Naja",
	"Nanna",
	"Noah",
	"Nohr",
	"Nora",
	"Oliver",
	"Olivia",
	"Oscar",
	"Otto",
	"Philip",
	"Rosa",
	"Saga",
	"Sara",
	"Sebastian",
	"Signe",
	"Sofia",
	"Sofie",
	"Storm",
	"Theo",
	"Theodor",
	"Thor",
	"Tilde",
	"Valdemar",
	"Victor",
	"Victoria",
	"Vigga",
	"Viggo",
	"Villads",
	"William"
}

local random_last_names = {
    "Andersen",
	"Christensen",
	"Christiansen",
	"Hansen",
	"Jensen",
	"Johansen",
	"Jørgensen",
	"Knudsen",
	"Kristensen",
	"Larsen",
	"Madsen",
	"Møller",
	"Nielsen",
	"Olsen",
	"Pedersen",
	"Petersen",
	"Poulsen",
	"Rasmussen",
	"Sørensen",
	"Thomsen"
}


Citizen.CreateThread(function()
	Citizen.Wait(Config.delay)
	while true do
		Citizen.Wait(10000)
        local firstname = random_first_names[math.random(1,#random_first_names)]
        local lastname = random_last_names[math.random(1,#random_last_names)]
		local pizza = math.random(1, 10)
		local kebab = math.random(1, 10)
		local drinks = math.random(1, 10)
		local callid = math.random(1111111, 9999999)
		local num = math.random(1, #Config.levering)
		local x = Config.levering[num].x
		local y = Config.levering[num].y
		local z = Config.levering[num].z
		local streethash = GetStreetNameAtCoord(x, y ,z)
		local street = GetStreetNameFromHashKey(tonumber(streethash))
		TriggerServerEvent("rz_fooddelivery:newlocations", firstname, lastname, pizza, kebab, drinks, callid, x, y ,z, street)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.start) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, 67)
        SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 29)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.bliplabel)
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for k,v in pairs(Config.start) do
            DrawMarker(20,v.x, v.y, v.z-0.2, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 23, 99, 161, 200, 0, 0, 0, 50)
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.x, v.y, v.z) < 2 then
                DrawText3Ds(v.x, v.y, v.z+0.15, "~b~[E]~w~ - Åben Menu")
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent('rz_fooddelivery:openmenu', source)
                end
            end
        end
    end
end)

function openMenu()
	TriggerServerEvent('rz_fooddelivery:openmenu', source)
end


RegisterNUICallback("exit", function(data)
    SetDisplay(false)
    DeleteEntity(tabletObject)
    ClearPedTasks(GetPlayerPed(-1))
    tabletObject = nil
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetDisplay(false)
    end
end)


RegisterNetEvent('rz_fooddelivery:menuopen')
AddEventHandler('rz_fooddelivery:menuopen', function(result, fal)
    if Config.Animation then
        local dict = "amb@world_human_seat_wall_tablet@female@base"
        RequestAnimDict(dict)
        if tabletObject == nil then
            tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(GetPlayerPed(-1)), 1, 1, 1)
            AttachEntityToEntity(tabletObject, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        end
        while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
        if not IsEntityPlayingAnim(GetPlayerPed(-1), dict, 'base', 3) then
            TaskPlayAnim(GetPlayerPed(-1), dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
        end
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "ordre", 
            status = true, 
            ordre = result,
            name = fal
        })
    else
        SetNuiFocus(true, true)
        SendNUIMessage({type = "ordre", status = true, ordre = result, name = fal})
    end
end)

RegisterNetEvent('rz_fooddelivery:spawncar')
    AddEventHandler('rz_fooddelivery:spawncar',function()
	for k, v in pairs(Config.garage) do
      	local vehiclehash = GetHashKey(Config.car)
      	RequestModel(vehiclehash)
      	while not HasModelLoaded(vehiclehash) do
          	RequestModel(vehiclehash)
          	Citizen.Wait(1)
     	end
      	local spawned_car = CreateVehicle(vehiclehash,v.x, v.y, v.z, true, false)
      	SetEntityAsMissionEntity(spawned_car, true, true)
	end
end)

RegisterNUICallback("gps", function(data)
    TriggerServerEvent('rz_fooddelivery:getbycoords', data.callid)
    tagetmad = true
	madafleveret = false
	if Config.usecar then
		TriggerEvent('rz_fooddelivery:spawncar')
	end
end)

RegisterNUICallback("detaljer", function(data)
    TriggerServerEvent('rz_fooddelivery:getdetails', data.callid)
end)

RegisterNetEvent('rz_fooddelivery:setdetails')
AddEventHandler('rz_fooddelivery:setdetails', function(result)
    SendNUIMessage({
        type = "details",
        details = result
    })
end)

RegisterNetEvent('rz_fooddelivery:setgps')
AddEventHandler('rz_fooddelivery:setgps', function(x, y, z)
    SetNewWaypoint(tonumber(x), tonumber(y))
    tagetmad = true
    madafleveret = false
    local x = tonumber(x)
    local y = tonumber(y)
    local z = tonumber(z)
    coordsx = tonumber(x)
    coordsy = tonumber(y)
    coordsz = tonumber(z)
    TriggerEvent('rz_fooddelivery:newcoords', x, y ,z)
	exports['mythic_notify']:DoHudText('sucess', Config.Leveringstart, { ['background-color'] = '#6495ed', ['color'] = '#ffffff' })
end)


function SetDisplay(bool)
    show = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ordre",
        status = bool
    })
end

function NewXYZ(x, y ,z)
    local x = x
    local y = y
    local z = z
    coordsx = x 
    coordsy = y 
    coordsz = z 
end

RegisterNetEvent('rz_fooddelivery:newcoords')
AddEventHandler('rz_fooddelivery:newcoords', function(x, y, z)
    NewXYZ(tonumber(x), tonumber(y) ,tonumber(z))
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if tagetmad == true then
            x = coordsx
            y = coordsy
            z = coordsz
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), x, y, z) < 2 then
                DrawMarker(20, x, y, z-0.2, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 23, 99, 161, 200, 0, 0, 0, 50)
                DrawText3Ds(x, y, z+0.10, "~b~[E]~w~ Aflever maden")
                if IsControlJustPressed(1, 38) then
                    exports['progressBars']:startUI(3000, "Afleverer maden...")
                    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WINDOW_SHOP_BROWSE", 0, true)
                    Citizen.Wait(3000)
                    local ped = PlayerPedId()
                    local x,y,z = table.unpack(GetEntityCoords(ped, false))
                    local streetName, crossing = GetStreetNameAtCoord(x, y, z)
                    streetName = GetStreetNameFromHashKey(streetName)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    TriggerServerEvent('rz_fooddelivery:getpaid')
                    Citizen.Wait(1)
                    exports['mythic_notify']:DoHudText('sucess', 'Du har modtaget dine drikkepenge.', { ['background-color'] = '#6495ed', ['color'] = '#ffffff' })
                    Citizen.Wait(1000)
                    tagetmad = false
                    madafleveret = true
                end
            end
        end
    end
end)


-- 3D TEXT -- 
function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 20, 20, 20, 150)
end
