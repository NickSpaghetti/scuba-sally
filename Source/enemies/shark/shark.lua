import "../enemy"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics;
local screenWidth = pd.display.getWidth()
local direction = {right = 1, left = -1}

class('Shark').extends(Enemy)

function Shark:init(x,y)
    local sharkImage = gfx.image.new('enemies/shark/shark')
    assert(sharkImage, "Failed to load image of shark")
    Shark.super.init(self,x,y,sharkImage,EnemeyMovementPath.Horzontal,1)
    self.moveSpeed = 2
    self:setCenter(0,0)
    self:setCollideRect(0,0, self:GetPixelSize())
    self.direction = direction.right
    self:setVisible(true)
end


function Shark:update()
    --Shark should only move Horzontal
    local nextX = (self.moveSpeed * self.direction) + self.x
    local actualX, actualY, collisiosn, length = self:moveWithCollisions(nextX,self.y)
    if(actualX < 0 or actualX >= screenWidth - self.width) then
        --since left is -1 it will always flip to the oppsite when multiplying by sharks direction
        self.direction = self.direction * direction.left
        if(self.direction == direction.left) then
            self:setImageFlip(gfx.kImageFlippedX)
        else 
            self:setImageFlip(gfx.kImageUnflipped)
        end
    end
end