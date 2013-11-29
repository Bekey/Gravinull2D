local game = {}

function game:init()
	local width, height, mapwidth, mapheight
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	mapwidth = map.width * map.tileWidth
	mapheight = map.height * map.tileHeight
	
	cam = Camera(0, 0)
	cam:zoom(1)
	cam:setBounds(width/2, height/2, mapwidth - width/2, mapheight - height/2)
	
	Entities:loadAll()
end

function game:update(dt)
	world:update(dt)
	Entities:update(dt)
	Timer.update(dt)
	cam:lookAt(math.floor(player:getX()),math.floor(player:getY()))
end

function game:draw()
	love.graphics.setColor(255, 255, 255)
	cam:attach()
	
	local dx, dy = cam.x - 400, cam.y - 300
	map:setDrawRange(dx, dy,800,600)
	map:draw()

	Entities:draw()

	cam:detach()
end

function game:keypressed(key, unicode)
	map:callback("keypressed", key, unicode)
	if key == 'f4' then
		local x,y = cam:worldCoords(love.mouse.getPosition())
		Entities.Spawn("amy", x, y)
	elseif key == 'f1' then
		DEBUG = not DEBUG
	end
end

function game:mousepressed(x, y, button)
	local x, y = cam:mousepos()
	Entities:mousepressed(x,y,button)
end

function game:mousereleased(x, y, button)
	local x, y = cam:mousepos()
	Entities:mousereleased(x,y,button)
end

return game