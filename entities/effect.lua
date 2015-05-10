local effect = Entities.Derive("base") or {}

function effect:load()
end

function effect:update(dt)
	self.anim:update(dt)
	if self.anim:getMode() == "once" then
		if self.anim:getCurrentFrame() == self.anim:getSize() then
			Entities.DestroyEffect(self.id)
		end
	end
end

function effect:draw()
	self.anim:draw(self.x, self.y)
end

function effect:Die()
	self.x, self.y, self.anim = nil, nil, nil
end

return effect;