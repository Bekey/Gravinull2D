local player = entities.Derive("base")
local raycast = require("entities.raycast")
local Grappled = nil
local Grabbed = nil

function player:load()

	self:loadBody()
	self:loadArm()
	self:loadJoint()

	self.isGrappling = false
	self.isGrabbing = false
	self.hasGrabbed = false

	self.canGrapple = true
	self.canGrab = true
	self.canShoot = true
	self.canChangeMode = true

	self.shootingMode = "RED"

end


function player:loadBody()
	self.r_body = 0
	self.w_body = 64
	self.h_body = 25

	self.player_body = {}
	self.player_body.body = love.physics.newBody(world, self.x,self.y, "dynamic")
	self.player_body.shape = love.physics.newRectangleShape(self.w_body, self.h_body)
	self.player_body.fixture = love.physics.newFixture(self.player_body.body, self.player_body.shape)
	self.player_body.body:setFixedRotation(true)
end

function player:loadArm()
	self.r_arm = 0
	self.w_arm = 35
	self.h_arm = 13

	self.player_arm = {}
	self.player_arm.body = love.physics.newBody(world, self.x+5,self.y+13, "dynamic")
	self.player_arm.shape = love.physics.newRectangleShape(self.w_arm, self.h_arm)
	self.player_arm.fixture = love.physics.newFixture(self.player_arm.body, self.player_arm.shape)

end

function player:loadJoint()
	self.joint = love.physics.newRevoluteJoint(self.player_body.body, self.player_arm.body, self.x-12,self.y+5, false )
	self.joint:enableLimit(true)
	self.joint:setLimits(math.rad(-5), math.rad(180))
end

function player:update(dt)
	local x,y = self:getPosition()
	local delta = vector(0,0)

	--self.player_arm.body:setAngle(self.joint:getJointAngle()-5*dt)
	---------------------------------------------------
	-- GRAPPLING
	-- TODO: Put that outside :update(dt)
	-- ---------
	if not self.hasGrabbed and love.mouse.isDown("r") then
		if self.isGrappling then
			local tx, ty = Grappled.fixture:getBody():getPosition()
			delta.x = tx - x
			delta.y = ty - y
			delta:normalized()
		else
			Grappled = raycast:ShootRaycast(x+20, y+22, 1024)
			if Grappled then
				self.isGrappling = true
			end
		end
	elseif self.isGrappling then
		self.isGrappling = false
	end

	self.player_body.body:applyForce(delta.x*(1.2+delta:len()/2048), delta.y*(1.2+delta:len()/2048))

end
--i = 0
function player:mousepressed(x2, y2, button)
	local x,y = self:getPosition()
	--i = i + 1
	
	if button == "wd" then
		self.player_arm.body:setAngle(self.joint:getJointAngle()-0.1)
	elseif button == "wu" then
		self.player_arm.body:setAngle(self.joint:getJointAngle()+0.1)
	end

	---------------------------------------------------
	-- GRABBING
	-- TODO: Add holding animation
	-- --------
	if not self.hasGrabbed and self.canGrab and love.mouse.isDown("l") then
		Grabbed = raycast:ShootRaycast(x+20, y+22, 200)

		if not self.hasGrabbed and Grabbed then
			local body = Grabbed.fixture:getBody()
			local x, y = body:getPosition()
			for i, entity in pairs(entities.objects) do
				if entity.type == "mine" then
					local x1, y1 = entity:getPosition()
					if x == x1 and y == y1 then
						self.shootingMode = "RED"
						self.isGrappling = false
						Grabbed = entity

						self.canShoot = false
						Timer.add(0.5, function() self.canShoot = true end)
					end
				end
			end
			if Grabbed:Grab() then
				self.hasGrabbed = true
			end
		end
	end

	if self.hasGrabbed  and self.canShoot and love.mouse.isDown("l") then
		self.hasGrabbed = false

		local angle = math.atan2(camera:mouseGetY()-y, camera:mouseGetX()-x)
		Grabbed:Shoot(x,y,angle, self.shootingMode)

		self.canShoot = false
		self.canGrab = false

		Timer.add(1, function() self.canShoot = true end)
		Timer.add(0.5, function() self.canGrab = true end)

		if self.shootingMode == "BLUE" then
			self.canChangeMode = false
			Timer.add(5, function() self.canChangeMode = true end)
		end
	end

	if self.hasGrabbed and button == "m" then
		-- TODO: Add mode animation, timer, sound
		if self.shootingMode == "RED" then
			self.shootingMode = "BLUE"
		else
			self.shootingMode = "RED"
		end
	end
end

function player:draw()
	local player_body = self.player_body.fixture:getBody()
	local x1, y1, x2, y2 = self.player_body.body:getWorldPoints(self.player_body.shape:getPoints())
	self.r_body = player_body:getAngle()


	local player_arm = self.player_arm.fixture:getBody()
	local x, y = player_arm:getPosition( )
	self.r_arm = player_arm:getAngle()

	do
		local quad = love.graphics.newQuad(0, 0, images["amy_joint"]:getWidth(), images["amy_joint"]:getHeight(), images["amy_joint"]:getWidth(), images["amy_joint"]:getHeight())
		love.graphics.drawq(images["amy_joint"], quad, math.floor(x1), math.floor(y1), self.r_body,1,1,-18,-14,0,0)
	end
	do
		local x1,y1, x2,y2 = self.player_arm.body:getWorldPoints(self.player_arm.shape:getPoints())
		local quad = love.graphics.newQuad(0, 0, images["amy_arm"]:getWidth(), images["amy_arm"]:getHeight(), images["amy_arm"]:getWidth(), images["amy_arm"]:getHeight())
		love.graphics.drawq(images["amy_arm"], quad, math.floor(x1), math.floor(y1), self.r_arm,1,1,0,0,0,0)
	end
	do
		local quad = love.graphics.newQuad(0, 0, images["amy_body"]:getWidth(), images["amy_body"]:getHeight()-4, images["amy_body"]:getWidth(), images["amy_body"]:getHeight()-4)
		love.graphics.drawq(images["amy_body"], quad, math.floor(x1), math.floor(y1), self.r_body,1,1,0,0,0,0)
	end

	if self.isGrappling then
		local tx, ty = Grappled.fixture:getBody():getPosition()
		love.graphics.line(self:getX()+20, self:getY()+22, tx, ty)
	end
	--love.graphics.polygon("line", self.player_body.body:getWorldPoints(self.player_body.shape:getPoints()))
	--love.graphics.polygon("line", self.player_arm.body:getWorldPoints(self.player_arm.shape:getPoints()))
end

function player:getPosition()

	local x1, y1, x2, y2 = self.player_body.body:getWorldPoints(self.player_body.shape:getPoints())
	return (x1+(x2-x1)/2), (y1+(y2-y1)/2)

end

function player:getX()
	local x1, y1, x2, y2 = self.player_body.body:getWorldPoints(self.player_body.shape:getPoints())
	return (x1+(x2-x1)/2)
end

function player:getY()
	local x1, y1, x2, y2 = self.player_body.body:getWorldPoints(self.player_body.shape:getPoints())
	return (y1+(y2-y1)/2)
end

function player:getPlayer()
	return player
end

return player;