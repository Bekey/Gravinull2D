local flash = Entities.Derive("effect") or {}

function flash:load()
	self.anim = newAnimation(images["effects/flash"], 16, 16, 0.1, 0)
	self.anim:setMode("once")
end

return flash;