--	Entities.lua
--=============================================--
local entities = {}
entities.objects = {}
entities.BID = 0
entities.SID = 0
entities.bollocks = {} -- It's actually effects but the name just seems weird after a while.
entities.EID = 0
entities.walls = {}
entities.path = "entities/"

local register = {}
--local id = 0

function entities:loadAll()
	register["player"] = 		love.filesystem.load( entities.path .. "player.lua" )
	register["amy"] = 			love.filesystem.load( entities.path .. "amy.lua" )
	register["mine"] = 			love.filesystem.load( entities.path .. "mine.lua" )
	register["redmine"] = 		love.filesystem.load( entities.path .. "redmine.lua" )
	register["bluemine"] = 		love.filesystem.load( entities.path .. "bluemine.lua" )
	register["FlashEffect"] = 	love.filesystem.load( entities.path .. "effects/flash.lua" )
	
	self:LoadLevel()
end

function entities.Derive(name)
	return love.filesystem.load( entities.path .. name .. ".lua" )()
end

function entities:LoadLevel() --TODO: Optimize using: http://love2d.org/forums/viewtopic.php?f=4&t=54654&p=131862#p132045 & http://www.love2d.org/wiki/TileMerging
	local layer = map("Ground")
	self.walls = {}
	for x, y, tile in layer:iterate() do
		if tile.properties.obstacle then
			self:makeObstacle(x, y, tile)
		end
	end
end

function entities:makeObstacle(x, y, tile)
	local wall = self.walls[#self.walls+1]
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

function entities.Replicate(id, name, x, y, params)
	assert(register[name], string.format("Entity %s doesn't exist", name))
	local entity = register[name]()
	entities.SID = id
	
	entity.id = id
	entity.type = name
	entity:setPos(x, y)
	entity:load(params)
	
	entities.objects[id] = entity
	
	if entity.type == "player" then player = entities.objects[id] end
	
	return entities.getEntityById(id)
end

function entities.Spawn(name, x, y, params)
	assert(register[name], string.format("Entity %s doesn't exist", name))
	local entity = register[name]()
	
	entities.BID = entities.SID
	repeat
		entities.BID = entities.BID + 1 
	until entities.getEntityById(entities.BID) == nil
	
	entity.id = entities.BID
	entity.type = name
	entity:setPos(x, y)
	entity:load(params)
	
	entities.objects[entities.BID] = entity
	
	if entity.type == "player" then player = entities.objects[entities.BID] end
	
	return entities.getEntityById(entities.BID)
end

function entities.Destroy(id)
	if entities.getEntityById(id) then
		if entities.objects[id].Die then
			entities.objects[id]:Die()
		end
		entities.objects[id] = nil
	end
end

function entities.getEntityById(id)
	return entities.objects[id] or nil
end

-- EFFECTS
--==========================================================--
function entities.newEffect(name, x, y, params)
	assert(register[name], string.format("Effect %s doesn't exist", name))
	local effect = register[name]()
	entities.EID = entities.EID + 1 
	effect.id = entities.EID
	effect.type = name
	effect:setPos(x, y)
	effect:load(params)
	
	entities.bollocks[entities.EID] = effect
	
	return entities.getEffectById(entities.EID)
end

function entities.getEffectById(id)
	return entities.bollocks[id] or nil
end

function entities.DestroyEffect(id)
	if entities.getEffectById(id) then
		if entities.bollocks[id].Die then
			entities.bollocks[id]:Die()
		end
		entities.bollocks[id] = nil
	end
end

-- REST
--==========================================================--
function entities:update(dt)
	for _, entity in pairs(entities.objects) do
		if entity.update then
			entity:update(dt)
		end
	end
	for _, effect in pairs(entities.bollocks) do
		if effect.update then
			effect:update(dt)
		end
	end
end

function entities:draw()
	for _, entity in pairs(entities.objects) do
		if entity.draw then
			entity:draw()
		end
	end
	for _, effect in pairs(entities.bollocks) do
		if effect.draw then
			effect:draw()
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