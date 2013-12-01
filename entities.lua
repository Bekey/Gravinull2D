--	Entities.lua
--=============================================--
local entities = {}
entities.objects = {}
entities.path = "entities/"

local register = {}
local id = 0


function entities:loadAll()
	register["player"] = love.filesystem.load( entities.path .. "player.lua" )
	register["amy"] = love.filesystem.load( entities.path .. "amy.lua" )
	register["mine"] = love.filesystem.load( entities.path .. "mine.lua" )
	register["FlashEffect"] = love.filesystem.load( entities.path .. "effects/flash.lua" )

	self:LoadObjects()
	self:LoadLevel()
end

function entities:LoadObjects()
	local layer = map("Objects")
	for i = 1, #layer.objects do
	local obj = layer.objects[i]
		if obj.name == "player" then
			player = self.Spawn(obj.name, obj.x, obj.y) --TODO: Better way to make the player global?
		else
			self.Spawn(obj.name, obj.x, obj.y)
		end
	end
	layer:toCustomLayer() --TODO: Not break when love.load is called twice
end

function entities:LoadLevel() --TODO: Optimize using: http://love2d.org/forums/viewtopic.php?f=4&t=54654&p=131862#p132045 & http://www.love2d.org/wiki/TileMerging
	local layer = map("Ground")
	entities.objects.walls = {}
	local walls = entities.objects.walls
	for x, y, tile in layer:iterate() do
		if tile.properties.obstacle then
			local wall = walls[#walls+1]
			local w, h, xOffset, yOffset
			
			w = tile.properties.width or map.tileWidth
			h = tile.properties.height or map.tileHeight
			xOffset = tile.properties.xOffset or 0
			yOffset = tile.properties.yOffset or 0
			
			local body = love.physics.newBody(world, x*map.tileWidth+xOffset+w/2, y*map.tileHeight+yOffset+h/2)
			local shape = love.physics.newRectangleShape(w, h)
			
			wall = love.physics.newFixture(body, shape)
			wall:setMask(16)
			wall:setUserData("wall")
		end
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
		entity:setPos(x, y) --TODO: Validate if it exists, or move into :load()
		entity:load()
		entities.objects[id] = entity
		
		return entities.objects[id]
	else
		love.errhand("Entity " .. name .. " does not exist!")
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
	for _, entity in pairs(entities.objects) do
		if entity.update then
			entity:update(dt)
		end
	end
end

function entities:draw()
	for _, entity in pairs(entities.objects) do
		if entity.draw then
			entity:draw()
		end
	end
end

function entities:mousepressed(x,y,button)
	for _, entity in pairs(entities.objects) do
		if entity.mousepressed then
			entity:mousepressed(x, y, button)
		end
	end
end

function entities:mousereleased(x,y,button)
	for _, entity in pairs(entities.objects) do
		if entity.mousereleased then
			entity:mousereleased(x, y, button)
		end
	end
end

return entities