local client = lube.udpClient()
Sequence = -1

function client.onReceive(data)
	local function compare(a, b)
		return math.abs(a - b) > 1
	end
	local t = loadstring(data)()
	if t[1] > Sequence then
		Sequence = t[1]
		for k, v in pairs(t) do
			if type(v) ~= "number" then
				if k == "CREATE" then
					if v[1] and v[2] then
						Entities.Spawn(v[1], v[2], v[3], v[4], v[5])
					end
				elseif k == "KILL" then
					Entities.Destroy(v[1])
				elseif k == "SYNC" then
					for _, e in pairs(v) do
						local entity = Entities.objects[e[1]]
						if entity then
							if compare(entity.x,e[3]) and compare(entity.y,e[4]) then
								entity.body:setPosition(e[3], e[4])
							end
							if e[5] and e[6] then
								local vx, vy = entity.body:getLinearVelocity()
								if compare(vx, e[5]) and compare(vy, e[6]) then
									entity.body:setLinearVelocity(e[5], e[6])
								end
							end
							if e[2] == "mine" then
								entity.Owner = e[7] or nil
								entity.Mode = e[8] or "NEUTRAL"
								if e[8] == "BLUE" then
									entity.Charge = 20
								elseif e[8] == "RED" then
									entity.Charge = e[9]
								else
									entity.Charge = 0
								end
								entity.Target = e[10] or nil
							elseif e[2] == "amy" or e[2] == "player" then
								entity.Health = e[7]
								entity.Score = e[8]
								entity.Grappled = Entities.objects[e[9]] or nil
								entity.Grabbed = Entities.objects[e[10]] or nil
							end
						else
							Entities.Spawn(e[1], e[2], e[3], e[4], {e[5], e[6], e[7], e[8], e[9], e[10]})
						end
					end
				end
			end
		end
	end
end

client.handshake = "DEA PRO MIHI, AUDITE MEUS DICO. PATEFACIO PRODIGIUM PRO NOS TOTUS."
client.callbacks.recv = client.onReceive
client:setPing(true, 1, "Bored now...\n")


return client