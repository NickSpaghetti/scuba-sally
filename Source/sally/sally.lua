import "CoreLibs/object"

-- math.floor is slow
local floor = function(n)
    return (n - n % 1)
  end

class('Sally').extends(playdate.graphics.sprite)

function Sally:init()
    
    Sally.super.init(self)

    self.swimImages = playdate.graphics.imagetable.new('sally/fish')

	self:setCollideRect(0, 0, 48, 48)
	self:setZIndex(800)

    self.normalState = 1
    self.hoverState = 2

    self:reset()
    self:addSprite()
end

function Sally:reset()
	self.xd = 0
	self.yd = 0
	self.v = 0
	self.justSwam = 0	-- this is just a janky way to handle a two-frame angle animation change when a swim occurs

	self.frame = 0
	self:updateFrame()

	self:moveTo(playdate.display.getWidth() / 4, playdate.display.getHeight() / 4)

	-- state stuff for the hover state
	self.fishState = self.hoverState
	self.hoverTime = 0
	self.hoverY = self.y
	self.wasHovering = true		-- messy and hacky
end

function Sally:up()
	self.wasHovering = false

	if self.fishState == self.normalState then
		if self.v > 160 then
			self.justSwam = 2
		elseif self.v > 100 then
			self.justSwam = 1
		end

		self.v = -160
	end
end

function Sally:left()
	if self.fishState == self.normalState then
		self.xd = -8
	end
end

function Sally:right()
	if self.fishState == self.normalState then
		self.xd = 8
	end
end

function Sally:updateFrame()

	-- figure out what angle we should be using based on our verical velocity
	-- fishAngle goes from 1 to 7, with 3 being completely horizontal
	-- self.frame itself ranges from 0 to 7, while actualFrame oscillates between 0 and 2

	local fishAngle = 3

	if self.fishState == self.normalState then

		if self.justSwam == 2 then
			fishAngle = 5
			self.justSwam = 1
		elseif self.justSwam == 1 then
			fishAngle = 3
			self.justSwam = 0
		else

			if self.v < 60 and self.wasHovering == false then
				fishAngle = 1
			elseif self.v < 90 and self.wasHovering == false then
				fishAngle = 2
			elseif self.v > 280 then
				fishAngle = 7
			elseif self.v > 240 then
				fishAngle = 6
			elseif self.v > 200 then
				fishAngle = 5
			elseif self.v > 150 then
				fishAngle = 4

			if self.v > 90 then
				self.wasHovering = false
			end

			end
		end
	end

	self.frame = (self.frame + 1) % 8
	local actualFrame = floor(self.frame / 2)
	if actualFrame == 3 then
		actualFrame = 1
	end

	-- stop swimming if we're nose-diving
	if self.v > 240 then
		actualFrame = 1
	end

	local tableWidth = 7
	self:setImage(self.swimImages[fishAngle + tableWidth * actualFrame])

end

function Sally:update()

	if self.fishState == self.hoverState then
		self:updateHover()
	else
		self:updateNormal()
	end
end


function Sally:updateNormal()

	local a = 440 -- pixels per second^2
	local dt = 1.0/50

	self:updateFrame()

    --print('v before check: '..self.v)

	self.v = self.v + a * dt
	if self.v > 400 then	-- terminal fish velocity
		self.v = 400
	end

    --print('v after check: '..self.v)

	local distance = self.v * dt
    --print('distance: '..distance)

	-- collision response logic for the fish instance (sally) is handled in main.lua in `function sally:collisionResponse(other)`
	self:moveWithCollisions(self.x + self.xd, self.y + distance)

	-- decelerate any x movement
	if (self.xd > 0.5 or self.xd < -0.5) then
		self.xd = self.xd * 0.8
	else
		self.xd = 0.0
	end

    if self.y >= playdate.display.getHeight() - 25 then  -- 25 pixels from bottom
        self.v = 0
        --self.fishState = self.hoverState  -- switch back to hover state
        --self.hoverY = self.y  -- set new hover height
    end
end


function Sally:updateHover()
	self:updateFrame()

	local dt = 1/20
	self.hoverTime = self.hoverTime + dt
	local occilationsPerSecond = 2.6
	local amplitude = 3.5
	local y = math.sin(math.pi * self.hoverTime * occilationsPerSecond) * amplitude
	self:moveTo(self.x, self.hoverY + y)
end