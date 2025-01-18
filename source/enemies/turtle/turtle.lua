import "../enemy"
import "CoreLibs/object"
import 'CoreLibs/timer'

local pd <const> = playdate
local gfx <const> = pd.graphics;
local screenWidth = pd.display.getWidth()
local screenHeight = pd.display.getHeight()
local direction = { none = 0, up = 1, down = -1, right = 1, left = -1 }
math.randomseed(pd.getSecondsSinceEpoch())
class('Turtle').extends(Enemy)

function Turtle:init(x, y, xTravelRange, yTravelRange, axies)
    local turtleImage = gfx.image.new('enemies/turtle/turtle')
    assert(turtleImage, "Failed to load image of turtle")
    Turtle.super.init(self, x, y, turtleImage, axies, 0)
    self:setCenter(0, 0)
    self:setCollideRect(0, 0, self:GetPixelSize())
    self.moveSpeed = 0.25
    self.xTravelRange = xTravelRange
    self.yTravelRange = yTravelRange
    self.travelBounds = {
        LeftMax = math.min(x - self.xTravelRange, screenWidth - self.width),   --left side of screen
        RightMax = math.max(x + self.xTravelRange, 0),                         -- rightside of screen
        DownMax = math.min(y + self.yTravelRange, screenHeight - self.height), --bottom of screen
        UpMax = math.max(y - self.yTravelRange, 0),                            -- top of screen
    }
    if(axies == EnemeyMovementPath.Horzontal) then
        self.direction = direction[getRandomDirectionName(direction,{"up", "down"})]
    elseif (axies == EnemeyMovementPath.Vertical) then
        self.direction = direction[getRandomDirectionName(direction,{"right", "left"})]
    elseif (axies == EnemeyMovementPath.AllAxies) then 
        self.direction = direction[getRandomDirectionName(direction,{"up", "down","right", "left"})]
    elseif (axies == EnemeyMovementPath.NoMovement) then
        self.direction = direction.none
    else 
        error("Unsupported axies:"..table.concat(axies,", ")..".  Supported Axies are 0,1,2,3,4")
    end

    if(self.direction == direction.left) then
        self:setImageFlip(gfx.kImageFlippedX)
    end

    
    self.pauseTimer = nil
    self:setVisible(true)
end

function getRandomDirectionName(tbl,filter)
    local keys = {}
    local index = 1
    for key, _ in pairs(tbl) do
        if contains_value(filter,key) then
            keys[index] = key
            index = index + 1
        end
    end
    if (#keys == 0) then
        error("No keys found for your filter:"..filter)
    end
    local index = math.random(1,#keys)
    return keys[index]
end

function contains_value(arr,val)
    for _, value in ipairs(arr) do
        if value == val then
            return true
        end
    end
    return false
end

function Turtle:update()
    if (self.pauseTimer ~= nil) then
        return
    end

    if (self.movementPath == EnemeyMovementPath.Vertical) then
        self:MoveVertical()
    elseif (self.movementPath == EnemeyMovementPath.Horzontal) then
        self:MoveHorzontal()
    end
end

function Turtle:MoveHorzontal()
    local nextX = (self.moveSpeed * self.direction) + self.x
    nextX = math.min(self.travelBounds.RightMax, math.max(nextX, self.travelBounds.LeftMax))
    local actualX, actualY, collisiosn, length = self:moveWithCollisions(nextX, self.y)
    if (actualX <= self.travelBounds.LeftMax or actualX >= self.travelBounds.RightMax) then
        --since down is -1 it will always flip to the oppsite when multiplying by sharks direction
        if actualX <= self.travelBounds.LeftMax then
            self.direction = direction.right
            self:setImageFlip(gfx.kImageUnflipped)
            self:moveWithCollisions(self.travelBounds.LeftMax, self.y)
            self:pause(math.random(1,5))
        elseif actualX >= self.travelBounds.RightMax then
            self.direction = direction.left
            self:setImageFlip(gfx.kImageFlippedX)
            self:moveWithCollisions(self.travelBounds.RightMax, self.y)
            self:pause(math.random(1,5))
        end
    end
end

function Turtle:MoveVertical()
    local nextY = (self.moveSpeed * self.direction) + self.y
    nextY = math.max(self.travelBounds.UpMax,math.min(nextY,self.travelBounds.DownMax))
    local actualX, actualY, collisiosn, length = self:moveWithCollisions(self.x,nextY)
    if(actualY <= self.travelBounds.UpMax or actualY >= self.travelBounds.DownMax) then
        --since down is -1 it will always flip to the oppsite when multiplying by sharks direction
        self.direction = self.direction * direction.down
        if actualY <= self.travelBounds.UpMax then
            self:moveWithCollisions(self.x,self.travelBounds.UpMax)
            self:pause(math.random(1,5))
        elseif actualY >= self.travelBounds.DownMax then
            self:moveWithCollisions(self.x,self.travelBounds.DownMax)
            self:pause(math.random(1,5))
        end
    end
end

function Turtle:pause(durationSeconds)
    self.pauseTimer = pd.timer.new(durationSeconds * 1000, function()
        self.pauseTimer = nil
    end)
end
