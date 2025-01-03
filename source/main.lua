import "CoreLibs/sprites"
import "CoreLibs/graphics"
import 'pulp-audio'

playdate.display.setRefreshRate(30)

local gfx = playdate.graphics
local spritelib = gfx.sprite
local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()

-- reset the screen to white
gfx.setBackgroundColor(gfx.kColorWhite)
gfx.setColor(gfx.kColorWhite)
gfx.fillRect(0, 0, screenWidth, screenHeight)


local titleSprite = spritelib.new()
titleSprite:setImage(gfx.image.new('images/launch/scuba_sally_title_card'))
titleSprite:moveTo(screenWidth / 2, screenHeight / 2)
titleSprite:setZIndex(950)
titleSprite:addSprite()

local backGroundImage = gfx.image.new('images/back_ground')
local backGroundImageHeight = backGroundImage.height
local backGroundSpriteTop = spritelib.new(backGroundImage)
local backGroundSpriteBottom = spritelib.new(backGroundImage)
backGroundSpriteTop:moveTo(200,120)
backGroundSpriteBottom:moveTo(200,120 - backGroundImageHeight)
backGroundSpriteTop:addSprite()
backGroundSpriteBottom:addSprite()

local scrollSpeed = 2
local yOffSet = 0

local possibleGameStates = {inital = 1,ready = 2,playing = 3,paused = 4,over = 5}
local gameState = possibleGameStates.inital

local gameTick = 0
local score = 0
local isButtionDown = false

pulp.audio.init("sounds/pulp-songs.json","sounds/pulp-sounds.json")

local function load_title_screen()
    -- Create your title screen graphics here
    gfx.setColor(gfx.kColorWhite)
	gfx.fillRect(0, 0, screenWidth, screenHeight)
    local readyImage  = gfx.image.new("images/launch/ready")
    local y = screenHeight/2 - titleSprite.height/2
    if not isButtionDown then
        y = y - 3
    end
    readyImage:draw(screenWidth/2 - readyImage.width/2, y)
    -- Transition to title screen and play sound
    pulp.audio.playSong('launchTheme')
end

local function start_game()
    gameState = possibleGameStates.ready
    gameTick = 0
    score = 0
    titleSprite:setImage(gfx.image.new('images/launch/ready'))
	titleSprite:setVisible(true)
end

function playdate.update()
    gameTick = gameTick + 1
    pulp.audio.update()
    
    if gameState == possibleGameStates.inital then
        load_title_screen()
    elseif gameState == possibleGameStates.ready then
        spritelib.update()
        if gameTick > 30 then
			gameState = possibleGameStates.playing
		end
    elseif gameState == possibleGameStates.playing then
        pulp.audio.stopSong()
        titleSprite:setVisible(false)
        spritelib.update()
        yOffSet = (yOffSet + scrollSpeed) % backGroundImageHeight
        backGroundSpriteBottom:moveTo(200, 120 + yOffSet)
        backGroundSpriteBottom:moveTo(200, 120 + yOffSet - backGroundImageHeight)
    end
    
    spritelib.update()
end

function playdate.AButtonDown()
	if gameState == possibleGameStates.inital then
		isButtionDown = true
	elseif gameState == possibleGameStates.over and gameTick > 5  then	-- the ticks thing is just so the player doesn't accidentally restart immediately
		start_game()
	elseif gameState == possibleGameStates.playing then
        -- Add logic here for gameState	
	end
end

function playdate.BButtonDown()
	if gameState == possibleGameStates.inital then
		isButtionDown = true
	elseif gameState == possibleGameStates.over and gameTick > 5  then	-- the ticks thing is just so the player doesn't accidentally restart immediately
		start_game()
	elseif gameState == possibleGameStates.playing then
        -- Add logic here for gameState	
	end
end

function playdate.AButtonUp()

	if gameState == possibleGameStates.inital then
		isButtionDown = false
		start_game()
	end
end

function playdate.BButtonUp()
	if gameState == possibleGameStates.inital then
		isButtionDown = false
		start_game()
	end
end