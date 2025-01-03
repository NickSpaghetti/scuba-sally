import "CoreLibs/sprites"
import "CoreLibs/graphics"
import 'pulp-audio'

playdate.display.setRefreshRate(20)

local gfx = playdate.graphics
local spritelib = gfx.sprite
local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()

local gameState = "loading"

function playdate.init()
    pulp.audio.init()
    loadTitleScreen()
end

function loadTitleScreen()
    -- Create your title screen graphics here
    local titleImage = gfx.image.new("images/launch/titlecard.png")
    local titleSprite = gfx.sprite.new(titleImage)
    titleSprite:moveTo(200, 120)
    titleSprite:add()
    
    -- Transition to title screen and play sound
    gameState = "titleScreen"
    pulp.audio.playSound('launchTheme')
end

function playdate.update()
    pulp.audio.update()
    
    if gameState == "titleScreen" then
        -- Handle title screen interactions here
    end
    
    spritelib.update()
end