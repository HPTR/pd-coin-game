import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

-- Shorthand for accessing graphics
local gfx <const> = playdate.graphics

local playerSprite = nil
local playerSpeed = 5

local playTimer = nil
local playTime = 30 * 1000

local coinSprite = nil
local score = 0

-- Timer function
local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

-- Chooses a random location to place the coin
local function moveCoin()
	local randX = math.random(40, 360)
	local randY = math.random(40, 200)
	coinSprite:moveTo(randX, randY)
end

local function initialise()
	math.randomseed(playdate.getSecondsSinceEpoch())
	-- Adds player sprite to middle of screen and add collision box
	local playerImage = gfx.image.new("images/player")
	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(200, 120)
	playerSprite:setCollideRect(0, 0, playerSprite:getSize())
	playerSprite:add()

	-- Add initial coin to screen at a random location and adds collision box
	local coinImage = gfx.image.new("images/coin")
	coinSprite = gfx.sprite.new(coinImage)
	moveCoin()
	coinSprite:setCollideRect(0, 0, coinSprite:getSize())
	coinSprite:add()

	-- Adds background to edge of screen
	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)
	-- Start the timer
	resetTimer()
end

-- Immediately 'start' the game
initialise()

-- This function is run every frame
function playdate.update()
	-- If timer is 0, movement will not be processed. Pressing A will restart the game
	if playTimer.value == 0 then
		if playdate.buttonIsPressed(playdate.kButtonA) then
			resetTimer()
			moveCoin()
			score = 0
		end
	else
		-- These 4 if statements handle movement, change speed by changing playerSpeed variable
		if playdate.buttonIsPressed(playdate.kButtonUp) then
			playerSprite:moveBy(0, -playerSpeed)
		end

		if playdate.buttonIsPressed(playdate.kButtonRight) then
			playerSprite:moveBy(playerSpeed, 0)
		end

		if playdate.buttonIsPressed(playdate.kButtonDown) then
			playerSprite:moveBy(0, playerSpeed)
		end

		if playdate.buttonIsPressed(playdate.kButtonLeft) then
			playerSprite:moveBy(-playerSpeed, 0)
		end

		-- Creates a list of sprites overlapping the coin, if anything is (can only be player), collect it and spawn another
		local collisions = coinSprite:overlappingSprites()
		if #collisions >= 1 then
			moveCoin()
			score += 1
		end
	end

	playdate.timer.updateTimers()
	gfx.sprite.update()

	-- Draws timer - text, time remaining, x and y coords
	gfx.drawText("Time: " .. math.ceil(playTimer.value / 1000), 5, 5)
	-- Draws current score
	gfx.drawText("Score: " .. score, 320, 5)
end
