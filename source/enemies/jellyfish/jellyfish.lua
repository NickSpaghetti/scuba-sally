import "../enemy"
import "CoreLibs/object"
import 'CoreLibs/timer'

local pd <const> = playdate
local gfx <const> = pd.graphics;
local screenHeight = pd.display.getHeight()
local direction = {up = 1, down = -1}

class('JellyFish').extends(Enemy)

function JellyFish:init(x,y,travelRange)
    local jellyFishImage = gfx.image.new('enemies/jellyfish/jellyfish')
    assert(jellyFishImage, "Failed to load image of jellyfish")
    JellyFish.super.init(self,x,y,jellyFishImage,EnemeyMovementPath.Horzontal,1)
    self:setCenter(0,0)
    self:setCollideRect(0,0, self:GetPixelSize())
    self.direction = direction.down
    self.yTravelRange = travelRange
    self.yTravelBounds = {
        Max = math.min(y + self.yTravelRange, screenHeight - self.height), --bottom of screen
        Min = math.max(y - self.yTravelRange,0), -- top of screen
        Default = y
    }
    self.pauseTimer = nil
    self:setVisible(true)
end

function JellyFish:update()
    if(self.pauseTimer ~= nil) then
        return
    end
    --JellyFish should only move up and down between a specific screenHeight
    print("current y:"..self.y)
    print("current default y:"..self.yTravelBounds.Default)
    local nextY = (self.moveSpeed * self.direction) + self.y
    print("nextY:"..nextY)
    nextY = math.max(self.yTravelBounds.Min,math.min(nextY,self.yTravelBounds.Max))
    print("nexty after mining:"..nextY)
    local actualX, actualY, collisiosn, length = self:moveWithCollisions(self.x,nextY)
    print("actualY:"..actualY)
    if(actualY <= self.yTravelBounds.Min or actualY >= self.yTravelBounds.Max) then
        --since down is -1 it will always flip to the oppsite when multiplying by sharks direction
        self.direction = self.direction * direction.down
        if actualY <= self.yTravelBounds.Min then
            self:moveWithCollisions(self.x,self.yTravelBounds.Min)
            self:pause(1)
        elseif actualY >= self.yTravelBounds.Max then
            self:moveWithCollisions(self.x,self.yTravelBounds.Max)
            self:pause(1)
        end
    end
end

function JellyFish:pause(durationSeconds) 
    self.pauseTimer = pd.timer.new(durationSeconds * 1000, function ()
        self.pauseTimer = nil
    end)
end