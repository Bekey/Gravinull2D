local client = lube.enetClient()

function client.onReceive(data)
	local t = loadstring(data)()
	for k, v in pairs(t) do
		if k == "CREATE" then
			client.Create(v)
		elseif k == "KILL" then
			client.Kill(v)
		elseif k == "SYNC" then
			client.Sync(v)
		end
	end
end

function client.compare(string, a, b)
	if math.abs(a - b) > 1.5 then
		string = string or "dunno"
		print(string.format("%s! %d - %d = %d", string, a, b, math.abs(a - b)))
		return true
	end
end

function client.Create(v)
	if v[1] and v[2] then
		print(string.format("CREATE == {\n %s \n }", Serialize(v)))
		Entities.Replicate(v[1], v[2], v[3], v[4], v[5])
	end
end
function client.Kill(v)
	if v[1] then
		Entities.Destroy(v[1])
		print(string.format("KILL == {\n %s \n }", Serialize(v)))
	end
end

function client.Sync(v)
	for _, e in pairs(v) do
		local entity = Entities.getEntityById(e[1])
		if entity then
			if 	client.compare("posX",entity.x, e[3]) then
				entity.body:setPosition( e[3], entity.y)
				entity.x = e[3]
			end
			if 	client.compare("posY",entity.y, e[4]) then
				entity.body:setPosition( entity.x, e[4])
			end
			if e[5] and e[6] then
				local vx, vy = entity.body:getLinearVelocity()
				if 	client.compare("VelX",vx, e[5]) then
					entity.body:setLinearVelocity(e[5], vy)
					vx = e[5]
				end
				if	client.compare("Vely",vy, e[6]) then
					entity.body:setLinearVelocity(vx, e[6])
				end
			end
			
			if e[2] == "mine"
			or e[2] == "bluemine"
			or e[2] == "redmine" then
				entity.OWNER = Entities.getEntityById(e[7]) or nil
				entity.MODE = e[8] or "NEUTRAL"
				if e[8] == "BLUE" then
					entity.CHARGE = 20
				elseif e[8] == "RED" then
					entity.CHARGE = e[9]
				else
					entity.CHARGE = 0
				end
				entity.Target = e[10] or nil
			elseif e[2] == "amy"
				or e[2] == "player" then
					entity.Health = e[7]
					entity.Score = e[8]
					entity.Grappled = Entities.getEntityById(e[9]) or nil
					entity.Grabbed = e[10] or nil
			end
		else
			Entities.Replicate(e[1], e[2], e[3], e[4], {e[5], e[6], e[7], e[8], e[9], e[10]})
		end
	end
end

client.handshake = "DEA PRO MIHI, AUDITE MEUS DICO. PATEFACIO PRODIGIUM PRO NOS TOTUS."
client:setPing(true, 1, "Bored now...\n")
client.callbacks.recv = client.onReceive

return client