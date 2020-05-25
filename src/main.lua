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

local nick = nil
local camera = nil

function restartGame()
    gfx.sprite.removeAll() -- clean slate plx
    nick = Nick()
    camera = Camera(nick)
    spawnEnv()

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
