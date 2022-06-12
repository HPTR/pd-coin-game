import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local playerSprite = nil
local gfx <const> = playdate.graphics
local playerSpeed = 4
local playTimer = nil
local playTime = 30 * 1000

-- Timer function
local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function initialise()
	-- Adds player sprite to middle of screen
	local playerImage = gfx.image.new("images/player")
	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(200, 120)
	playerSprite:add()

	-- Adds background to edge of screen
	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function (x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)

	resetTimer()
end

initialise()

function playdate.update()
	-- If timer is 0, movement will not be processed. Pressing A will reset the timer
	if playTimer.value == 0 then
		if playdate.buttonIsPressed(playdate.kButtonA) then
			resetTimer()
			moveCoin()
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
	end

	playdate.timer.updateTimers()
	gfx.sprite.update()

	-- Draws timer - text, time remaining, x and y coords
	gfx.drawText("Time: " .. math.ceil(playTimer.value / 1000), 5, 5)
end