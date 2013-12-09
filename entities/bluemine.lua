-- Bluemine.lua
--=============================================--
local bluemine = Entities.Derive("mine") or {}

function bluemine:load(owner, target)
	self.MODE = "BLUE"
	self.CHARGE = 20
	self.OWNER = owner or nil
	self.TARGET = target or nil
	self.GRABBABLE = false
	self:loadBody()
end

function bluemine:update(dt)
	self.x, self.y = self.body:getPosition()
	if self.TIMER > 10 then
		self.CHARGE = 0
		self.OWNER = nil
		self.TARGET = nil
		self.MODE = "NEUTRAL"
	else
		self.TIMER = self.TIMER + dt
		--GET NEAREST PLAYER
	end
end

function bluemine:draw()
	if self.MODE == "NEUTRAL" then self:drawMine(0,0) else
		self:drawMine(0,1)
	end
end

return bluemine;