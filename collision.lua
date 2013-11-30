local collision = {}

function collision.on_collide(dt, shape_a, shape_b)
	local aUD, bUD = shape_a:getUserData(), shape_b:getUserData()
    if aUD and bUD then
    	if aUD == "wall" then
			bUD.velocity.x = -bUD.velocity.x
			bUD.velocity.y = -bUD.velocity.y
    	elseif bUD == "wall" then
			aUD.velocity.x = -aUD.velocity.x
			aUD.velocity.y = -aUD.velocity.y
        end
	end
end

function collision.beginContact(a, b, coll)
	local A, B = a:getUserData(), b:getUserData()
	if A and B then -- Ugly array of if statements.
		--	AMY - MINE
		--======================================================================
		if ((A.type == "mine" and A.Mode ~= "NEUTRAL") and (B.type == "amy" or B.type == "player")) or 
		((A.type == "amy" or A.type == "player") and (B.type == "mine" and B.Mode ~= "NEUTRAL")) then
		--======================================================================		
			local dx, dy = coll:getNormal()	
			local x1, y1 = coll:getPositions( )
			A.body:applyLinearImpulse(-dx * 1.5, -dy * 1.5, x1, y1)
			B.body:applyLinearImpulse( dx * 1.5,  dy * 1.5, x1, y1)
			if  (A.type == "mine") then
				if B.Hurt then B:Hurt(A) end
			elseif (B.type == "mine") then
				if A.Hurt then A:Hurt(B) end
			end
		end
		
		--
		
    end
end

function collision.endContact(a, b, coll)
end

function collision.preSolve(a, b, coll)
end

function collision.postSolve(a, b, coll)
end

return collision