local box = entities.Derive("base")

function box:load()
	self.w = 33
	self.h = 3
	self.box = {}
	self.box.body = love.physics.newBody(world, self.x,self.y, "dynamic")
	self.box.shape = love.physics.newRectangleShape(self.w, self.h)
	self.box.fixture = love.physics.newFixture(self.box.body, self.box.shape)
end

function box:setSize( w, h )
	self.w = w
	self.h = h
end

function box:getSize()
	return self.w, self.h;
end

function box:update(dt)

end

function box:draw()
	local body = self.box.fixture:getBody()
	local x, y = body:getPosition( )
	local w, h = self:getSize()

	love.graphics.polygon("fill", self.box.body:getWorldPoints(self.box.shape:getPoints()))
end

return box;