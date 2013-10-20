local mine = entities.Derive("base")

function mine:load()
	self:loadBody()
end


function mine:loadBody()
	self.r_body = 8
	self.angle = 0
	self.isGrappleAble = true
	self.isGrabbable = true
	self.isGrabbed = false
	self.Mode = "NEUTRAL"

	self.mine = {}
	self.mine.body = love.physics.newBody(world, self.x,self.y, "dynamic")
	self.mine.shape = love.physics.newCircleShape(self.r_body)
	self.mine.fixture = love.physics.newFixture(self.mine.body, self.mine.shape)
	self.mine.fixture:setRestitution(0.2)

end

function mine:update(dt)
	self.mine.body:setActive(not self.isGrabbed)
end

function mine:draw()
	if not self.isGrabbed then
		local player_body = self.mine.fixture:getBody()
		local x, y = self.mine.body:getPosition()
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
		
		love.graphics.drawq(images["mines"],quad,x-8,y-8,0,1,1,0,0,0,0)

	end
end

function mine:Grab()
	self.isGrabbed = true
	self.isGrabbable = false
	self.isGrappleAble = false
	return self.isGrabbed
end

function mine:Shoot(x,y,angle, mode)
	local delta = vector(0,0)

	self.isGrabbed = false
	self.isGrabbable = true
	self.isGrappleAble = true
	self.Mode = mode

	local x2, y2 = 50*math.cos(angle)+x, 50*math.sin(angle)+y

	self.mine.body:setPosition(x2,y2)
	delta.x = x2 - x
	delta.y = y2 - y
	delta:normalized()
	self.mine.body:setActive(true)

	self.mine.body:applyForce(delta.x*1500, delta.y*1500)
	
	Timer.add(10, function() self.Mode = "NEUTRAL" end)

end

function mine:getPosition()
	local x, y = self.mine.body:getPosition()
	return x, y
end

return mine;