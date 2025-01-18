import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics;
EnemeyMovementPath = {NoMovement = 0, Horzontal = 1, Vertical = 2, AllAxies = 3}

class('Enemy').extends(gfx.sprite)

function Enemy:init(x,y,image,movementPath, isDefetable)
    self:setImage(image)
    self:moveTo(x,y)
    local _height, _width = image:getSize()
    self.width = _height
    self.height = _width
    self.moveSpeed = 1
    self.movementPath = movementPath
    self.isDefetable = isDefetable
end

function Enemy:GetPixelSize()
    return self.height,self.width
end

