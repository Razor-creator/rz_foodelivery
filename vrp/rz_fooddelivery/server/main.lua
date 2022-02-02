local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","banking")

RegisterServerEvent('rz_fooddelivery:newlocations')
AddEventHandler('rz_fooddelivery:newlocations', function(firstname, lastname, pizza, kebab, drinks, callid, x, y ,z, street)
	MySQL.Async.fetchAll('INSERT IGNORE INTO rz_fooddelivery(firstname, lastname, pizza, kebab, drinks, callid, x, y, z, street) VALUES(@firstname, @lastname, @pizza, @kebab, @drinks, @callid, @x, @y, @z, @street)', {firstname = firstname, lastname = lastname, pizza = pizza, kebab = kebab, drinks = drinks, callid = callid, x = x, y = y, z = z, street = street})
end)

--[[  IKKE BRUG | Bruges til troubleshooting
RegisterCommand("test", function(source)
	local source = source
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.PlayerData.job.name == Config.PermGroup then
		MySQL.Async.fetchAll('SELECT * FROM rz_fooddelivery', {}, function(result)
			if #result > 0 then
				TriggerClientEvent('rz_fooddelivery:menuopen', source, result, fal)
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = Config.NoCalls, length = 2500})
			end
		end)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = Config.IngenAdgang, length = 2500})
	end
end)]]

RegisterServerEvent('rz_fooddelivery:openmenu')
AddEventHandler('rz_fooddelivery:openmenu', function()
	local source = source
    local Player = vRP.getUserId({source})
	if vRP.hasGroup({Player,Config.PermGroup}) then
		MySQL.Async.fetchAll('SELECT * FROM rz_fooddelivery', {}, function(result)
			if #result > 0 then
				TriggerClientEvent('rz_fooddelivery:menuopen', source, result, fal)
			else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = Config.NoCalls, length = 2500})
			end
		end)
	else
		TriggerClientEvent('QBCore:Notify', source, Config.IngenAdgang)
	end
end)


RegisterServerEvent('rz_fooddelivery:getbycoords')
AddEventHandler('rz_fooddelivery:getbycoords', function(callid)
	local source = source
	local Player = vRP.getUserId({source})
	MySQL.Async.fetchAll('SELECT * FROM rz_fooddelivery WHERE callid = @callid', {
        ['@callid'] = callid
    }, function(result)
			TriggerClientEvent('rz_fooddelivery:setgps', source, result[1].x, result[1].y, result[1].z)
			TriggerClientEvent('rz_fooddelivery:newcoords', source, result[1].x, result[1].y, result[1].z)
			MySQL.Async.fetchAll('DELETE FROM rz_fooddelivery WHERE callid = @callid', {
				['@callid'] = callid
			})
	end)
end)

RegisterServerEvent('rz_fooddelivery:getdetails')
AddEventHandler('rz_fooddelivery:getdetails', function(callid)
	local source = source
	local Player = vRP.getUserId({source})
	MySQL.Async.fetchAll('SELECT * FROM rz_fooddelivery WHERE callid = @callid', {
        ['@callid'] = callid
    }, function(result)
		if #result > 0 then
			--print('Ordrenummer: '.. result[1].callid.. ', Levreres til: ' .. result[1].firstname .. ' ' .. result[1].lastname)
			TriggerClientEvent('rz_fooddelivery:setdetails', source, result)
		end
	end)
end)

RegisterServerEvent('rz_fooddelivery:getpaid')
AddEventHandler('rz_fooddelivery:getpaid', function()
	local source = source
    local Player = vRP.getUserId({source})
    vRP.giveBankMoney({PLayer,Config.payment})
end)