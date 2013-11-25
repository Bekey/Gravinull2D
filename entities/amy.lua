local Amy = Entities.Derive("base") or {}

function Amy:load()
	self:loadBody()
	self:loadArm()
	self:loadJoint()
	
	if not self.teamColor then self.teamColor = math.random() end
	self.armourPlating = self:colorPlate(self.teamColor, images["amy_plate"])
	
	self.Health = self.Health or 100
	
	self.Score = 0

	self.Grappled = false
	self.Grabbed = false

	self.isGrappling = false
	self.isGrabbing = false
	self.isHolding = false

	self.canGrapple = true
	self.canShoot = true
	
	self.canGrab = true
	self.canChangeMode = true
	self.shootingMode = "RED"
end

function Amy:Hurt(Object)
	local score = 0
	if Object.Charge > self.Health then
		score = math.floor(self.Health/10) + 3
	else
		score = math.floor(Object.Charge/10)
	end
	self.Health = self.Health - Object.Charge
	Object.Owner.Score = Object.Owner.Score + score
	
	if self.Health <= 0 then
		
	end
end

function Amy:loadBody()
	self.r_body = 0
	self.w_body = 64
	self.h_body = 25

	self.body = love.physics.newBody(world, self.x,self.y, "dynamic")
	self.shape = love.physics.newRectangleShape(self.w_body, self.h_body)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setUserData(self)
	self.body:setFixedRotation(true)
end

function Amy:loadArm()
	self.r_arm = 0
	self.w_arm = 35
	self.h_arm = 13

	self.player_arm = {}
	self.player_arm.body = love.physics.newBody(world, self.x+5,self.y+13, "dynamic")
	self.player_arm.shape = love.physics.newRectangleShape(self.w_arm, self.h_arm)
	self.player_arm.fixture = love.physics.newFixture(self.player_arm.body, self.player_arm.shape)
end

function Amy:loadJoint()
	self.joint = love.physics.newRevoluteJoint(self.body, self.player_arm.body, self.x-12,self.y+5, false )
	self.joint:enableLimit(true)
	self.joint:setLimits(math.rad(-5), math.rad(180))
end

function Amy:update(dt)
	self.x, self.y = self:getPosition()
	if self.Health <= 0 then
	end
end

function Amy:mousepressed(x, y, button)
end

function Amy:draw()
	local body = self.fixture:getBody()
	local x1, y1, x2, y2 = self.body:getWorldPoints(self.shape:getPoints())
	self.r_body = body:getAngle()


	local player_arm = self.player_arm.fixture:getBody()
	local x, y = player_arm:getPosition( )
	self.r_arm = player_arm:getAngle()

	do
		local quad = self:getBodyPart("amy/amy_joint")
		love.graphics.drawq(images["amy/amy_joint"], quad, math.floor(x1), math.floor(y1), self.r_body,1,1,-18,-14,0,0)
	end
	do
		local x1,y1, x2,y2 = self.player_arm.body:getWorldPoints(self.player_arm.shape:getPoints())
		local quad = self:getBodyPart("amy/amy_arm")
		love.graphics.drawq(images["amy/amy_arm"], quad, math.floor(x1), math.floor(y1), self.r_arm,1,1,0,0,0,0)
	end
	do
		local quad = self:getBodyPart("amy/amy_plating")
		love.graphics.drawq(self.armourPlating, quad, math.floor(x1), math.floor(y1), self.r_body,1,1,0,0,0,0)
	end
	do
		local quad = self:getBodyPart("amy/amy_gears")
		love.graphics.drawq(images["amy/amy_gears"], quad, math.floor(x1), math.floor(y1), self.r_body,1,1,0,0,0,0)
	end
	if self.isGrappling and Grappled then
		local tx, ty = Grappled.fixture:getBody():getPosition()
		love.graphics.line(self:getX()+20, self:getY()+22, tx, ty)
	end
	
	if DEBUG then
		love.graphics.print(self.Health,self.x+35,self.y+10)
		love.graphics.print(self.Score,self.x+35,self.y+25)
		love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
		love.graphics.polygon("line", self.player_arm.body:getWorldPoints(self.player_arm.shape:getPoints()))
	end
end

function Amy:getBodyPart(string)
	local quad = love.graphics.newQuad(0, 0, images[string]:getWidth(), images[string]:getHeight(), images[string]:getWidth(), images[string]:getHeight())
	return quad
end

function Amy:colorPlate(T_Color, source)
	local function RGB(r, g, b, a)
		local var_R, var_G, var_B = r/255, g/255, b/255
		local var_Min, var_Max = math.min(var_R, var_G, var_B), math.max(var_R, var_G, var_B)
		local del_Max = var_Max - var_Min
		
		local l, h, s = ( var_Max + var_Min ) / 2,  0, 0
		if del_Max ~= 0 then
			if l < 0.5 then s = del_Max / ( var_Max + var_Min )
			else s = del_Max / ( 2 - var_Max - var_Min ) end
			local del_R, del_G, del_B
			del_R = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
			del_G = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
	    	del_B = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max
			if var_R == var_Max then h = del_B - del_G
			elseif var_G == var_Max then h = ( 1 / 3 ) + del_R - del_B
			elseif  var_B == var_Max then h = ( 2 / 3 ) + del_G - del_R end
			if h < 0 then
				h = h + 1
			end
			if h > 1.0 then
				h = h - 1
			end
		end
		return h, s, l, a
	end
	local function Hue_2_RGB( v1, v2, vH )
	   if vH < 0 then vH = vH+1 end
	   if vH > 1 then vH = vH-1 end
	   if ( 6 * vH ) < 1 then return ( v1 + ( v2 - v1 ) * 6 * vH ) end
	   if ( 2 * vH ) < 1 then return ( v2 ) end
	   if ( 3 * vH ) < 2 then return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 ) end
	   return v1
	end
	local function HLS(h, s, l, a)
	    if s<= 0 then return l*255,l*255,l*255,a
	    
	    else
	    	local var_2, var_1, r, g, b
	    	if ( l < 0.5 ) then
	    		var_2 = l * ( 1 + s )
	    	else
	    		var_2 = ( l + s ) - ( s * l )
	    	end
	    	
	    	var_1 = 2 * l - var_2
			r = 255 * Hue_2_RGB( var_1, var_2, h + ( 1 / 3 ) )
			g = 255 * Hue_2_RGB( var_1, var_2, h )
			b = 255 * Hue_2_RGB( var_1, var_2, h - ( 1 / 3 ) )
		
			return r, g, b, a
		end	
	end
	
	local function hueShift(x, y, r, g, b, a)
		local H, L, S, A = RGB(r, g, b, a)
		
		H = T_Color + H
		
		local R, G, B, A = HLS(H, L, S, A)
		
		return R, G, B, A 
	end
	
	source:mapPixel(hueShift)
	return love.graphics.newImage(source)
end

function Amy:getPosition()
	local x1, y1, x2, y2 = self.body:getWorldPoints(self.shape:getPoints())
	return (x1+(x2-x1)/2), (y1+(y2-y1)/2)
end

function Amy:getX()
	local x1, y1, x2, y2 = self.body:getWorldPoints(self.shape:getPoints())
	return (x1+(x2-x1)/2)
end

function Amy:getY()
	local x1, y1, x2, y2 = self.body:getWorldPoints(self.shape:getPoints())
	return (y1+(y2-y1)/2)
end

function Amy:getPlayer()
	return Amy
end

return Amy;