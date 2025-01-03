import "CoreLibs/sprites"
import "CoreLibs/graphics"
import 'pulp-audio'

playdate.display.setRefreshRate(20)

local gfx = playdate.graphics
local spritelib = gfx.sprite
local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()

local gameState = "titleScreen"
pulp.audio.init("sounds/pulp-songs.json","sounds/pulp-sounds.json")

function loadTitleScreen()
    -- Create your title screen graphics here
    gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, screenWidth, screenHeight)
    local titleImage = gfx.image.new("images/launch/scuba_sally_title_card")
    local y = screenHeight/2 - titleImage.height/2
    titleImage:draw(screenWidth/2 - titleImage.width/2, y)
    
    -- Transition to title screen and play sound
    gameState = "titleScreen"
    pulp.audio.playSong('launchTheme')
end

function playdate.update()
    pulp.audio.update()
    
    if gameState == "titleScreen" then
        loadTitleScreen()
    end
    
    spritelib.update()
end