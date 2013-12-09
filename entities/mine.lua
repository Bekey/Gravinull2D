local mine = Entities.Derive("base") or {}
mine.RADIUS = 8
mine.TIMER = 0

function mine:load()	
	self.MODE = "NEUTRAL"
	self.CHARGE = 0
	self.OWNER = nil
	self.TARGET = nil
	self.GRABBABLE = true
	
	
	self:loadBody()
end

function mine:loadBody()
	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	local shape = love.physics.newCircleShape(self.RADIUS)
	
	self.fixture = love.physics.newFixture(self.body, shape)
	self.fixture:setRestitution(0.2)
	self.fixture:setUserData(self)
end

function mine:update(dt)
	self.x, self.y = self.body:getPosition()
end

function mine:draw()
	self:drawMine(0,0)
end

function mine:drawMine(x,y)
	local quad = love.graphics.newQuad(x*16, y*16, 16, 16, images["mines"]:getWidth(), images["mines"]:getHeight())
	love.graphics.draw(images["mines"],quad,self.x-self.RADIUS,self.y-self.RADIUS)
	
	if DEBUG then
		love.graphics.print(self.CHARGE,self.x+10,self.y)
		love.graphics.circle("line", self.x, self.y, self.RADIUS, 18)
	end
end

function mine:Die()
	Entities.newEffect("FlashEffect", self.x-8, self.y-8)
	self.fixture:setUserData(nil)
	self.body:destroy()
end

return mine;