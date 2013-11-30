local mine = Entities.Derive("base") or {}

function mine:load()
	self.velocity = { x = 0, y = 0}
	self:loadBody()
end


function mine:loadBody()
	self.radius = 8
	self.angle = 0
	
	self.Mode = "NEUTRAL"
	self.Charge = 0
	
	self.Owner = nil
	
	self.body = Collider:addCircle(self.x,self.y, self.radius)
	--self.fixture:setRestitution(0.2)
	self.body:setUserData(self)
end

function mine:update(dt)
	local body  = self.body
	body:move(self.velocity.x * dt, self.velocity.y * dt)
	self.x, self.y = body:center()
	
	if self.Charge <= 0 then
		self.Charge = 0
		self.Mode = "NEUTRAL"
	end
	
	if self.Mode == "BLUE" then
		--GET NEAREST PLAYER..
	elseif self.Mode == "RED" and self.Charge < 60 then
		self.Charge = self.Charge - dt * 10
	end
end

function mine:draw()
	local i, j = 0,0
	
	if 		self.Mode == "NEUTRAL" 	then
	i, j = 0,0
	elseif 	self.Mode == "RED" 		then
	i = 1
	elseif 	self.Mode == "BLUE" 	then
	j = 1
	elseif 	self.Mode == "GREEN" 	then
	i,j = 1,1
	end
	
	local quad = love.graphics.newQuad(i*16, j*16, 16, 16, images["mines"]:getWidth(), images["mines"]:getHeight())
	love.graphics.drawq(images["mines"],quad,self.x-self.radius,self.y-self.radius)
	
	if DEBUG then
		self.body:draw('line', 8)
		love.graphics.print(self.Charge,self.x+10,self.y)
		love.graphics.circle("line", self.x, self.y, self.radius, 18)
	end
end

function mine:Die()
	Entities.Spawn("FlashEffect", self.x-8, self.y-8)
	--self.fixture:setUserData(nil)
	--self.body:destroy()
end

function mine:getPosition()
	return self.x, self.y
end

return mine;