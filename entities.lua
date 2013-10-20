entities = {}
entities.objects = {}
entities.path = "entities/"

local register = {}
local id = 0


function entities:loadAll()
	register["box"] = love.filesystem.load( entities.path .. "box.lua" )
	register["player"] = love.filesystem.load( entities.path .. "player.lua" )
	register["mine"] = love.filesystem.load( entities.path .. "mine.lua" )

	do	-- SPAWN MAP OBJECTS
		local layer = map("Objects")
		for i  = 1, #layer.objects do
			local obj = layer.objects[i]
			if obj.name == "player" then
				player = self.Spawn(obj.name, obj.x, obj.y)
			else
				self.Spawn(obj.name, obj.x, obj.y)
			end
		end
		layer:toCustomLayer()
	end
end

function entities.Derive(name)
	return love.filesystem.load( entities.path .. name .. ".lua" )()
end

function entities.Spawn(name, x, y)

	if register[name] then
		id = id + 1
		local entity = register[name]()
		entity.id = id
		entity.type = name
		entity:setPos(x, y)
		entity:load()
		entities.objects[id] = entity
		return entities.objects[id]
	else
		print("Error: Entity " .. name .. " does not exist!")
		return false;
	end
end

function entities.Destroy(id)
	if entities.objects[id] then
		if entities.objects[id].Die then
			entities.objects[id]:Die()
		end
		entities.objects[id] = nil
	end
end

function entities:update(dt)
	for i, entity in pairs(entities.objects) do
		if entity.update then
			entity:update(dt)
		end
	end
end

function entities:draw()
	for i, entity in pairs(entities.objects) do
		if entity.draw then
			entity:draw()
		end
	end
end

