local Amy = Entities.Derive("base") or {}

function Amy:load()
	self.velocity = {x = 0, y = 0} 
	self:loadBody()
	
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

	self.body = Collider:addRectangle(self.x,self.y, self.w_body,self.h_body)
	--self.fixture:setUserData(self)
	--self.body:setFixedRotation(true)
end

function Amy:update(dt)
	local body  = self.body
	body:move(self.velocity.x * dt, self.velocity.y * dt)
	self.x, self.y = body:center()
	
	if self.Health <= 0 then
	end
end

function Amy:mousepressed(x, y, button)
end

function Amy:draw()
	self.body:draw('fill')
	if self.isGrappling and self.Grappled then
		local tx, ty = self.Grappled.x, self.Grappled.y
		love.graphics.line(self.x+20, self.y+22, tx, ty)
	end
	if DEBUG then
		local mx, my = cam:mousepos()
		local angle1 = math.atan2(my-self.y, mx-self.x)+math.rad(-4)
		local angle2 = math.atan2(my-self.y, mx-self.x)+math.rad(4)
		local ax, ay = 333*math.cos(angle1)+self.x, 333*math.sin(angle1)+self.y
		local bx, by = 333*math.cos(angle2)+self.x, 333*math.sin(angle2)+self.y
		
		local tearDrop = Collider:addPolygon(	self.x, self.y,
												ax, ay,
												bx, by)
		tearDrop:draw()
		local x1,y1, x2,y2 = tearDrop:bbox()
		love.graphics.rectangle('line', x1,y1, x2-x1,y2-y1)
		for shape in pairs(Collider:shapesInRange(tearDrop:bbox())) do
			if shape ~= tearDrop then
				love.graphics.setColor(255,40,40)
				love.graphics.setLineWidth(2)
				shape:draw()
				love.graphics.setLineWidth(1)
				love.graphics.setColor(255,255,255)
			end
		end
		Collider:remove(tearDrop)
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
	return self.x, self.y
end

function Amy:getX()
	return self.x
end

function Amy:getY()
	return self.y
end

function Amy:getPlayer()
	return Amy
end

return Amy;