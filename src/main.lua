-- Uncle Nick's Big Head
--  by Dorthu
--
--  This is a stupid, weird game whose purpose is to introduce me to playdate.
--  This game is about my brother, and inflating his head so he floats off to
--  space like a balloon, while avoiding obstacles.
--
--  No offense, Nick.
import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "nick"
import "camera"
import "orchestrator"

local gfx <const> = playdate.graphics

local sprLose <const> = gfx.image.new("images/tmp-lose")
assert(sprLose)

local sprElevationBar <const> = gfx.image.new("images/elevation-bar")
local sprElevationBarPlayer <const> = gfx.image.new("images/elevation-bar-player")
assert(sprElevationBar)
assert(sprElevationBarPlayer)

local nick = nil
local camera = nil
local playerIndicator = nil

function restartGame()
    gfx.sprite.removeAll() -- clean slate plx
    nick = Nick()
    camera = Camera(nick)
    camLast = camera.offset
    spawnEnv(nick)

    -- do the sidebar thing
    local sidebar = gfx.sprite.new()
    sidebar:setImage(sprElevationBar)
    sidebar:setIgnoresDrawOffset(true)
    sidebar:moveTo(390, 120)
    sidebar:setZIndex(400)
    sidebar:add()
    playerIndicator = gfx.sprite.new()
    playerIndicator:setImage(sprElevationBarPlayer)
    playerIndicator:setIgnoresDrawOffset(true)
    playerIndicator:setZIndex(401)
    playerIndicator:moveTo(385, 230)
    playerIndicator:add()

    function playerIndicator:update()
        local _, playerY = nick:getPosition()
        local percentComplete = playerY / 50
        local x, y = self:getPosition()
        y = 230 + percentComplete
        self:moveTo(x, y)
    end

    function nick:collisionResponse(other)
        print(other)
        lose()
    end
end

local gameState = 1 -- 0 = ended, 1 = running
restartGame()

function playdate:update()
    if gameState == 1 then
        gfx.clear()
        camera:update()

        -- check for losing the game
        local _, bottomY = gfx.getDrawOffset()
        local _, nickY = nick:getPosition()
        if nickY > (-1* bottomY) + 240 then lose() end
    else
        if playdate.buttonJustPressed(playdate.kButtonA) then
            restartGame()
            gameState = 1
        end
    end

    -- always update sprites tho
    gfx.sprite.update()
end

function lose()
    gameState = 0
    s = gfx.sprite.new()
    s:setImage(sprLose)
    s:setZIndex(100)
    s:moveTo(200, 120)
    s:setIgnoresDrawOffset(true)
    s:add()
    -- stop nick
    nick.update = function() end
    -- stop accelerometer
    playdate.stopAccelerometer()
end
