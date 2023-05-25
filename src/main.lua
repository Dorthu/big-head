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
local sprWin <const> = gfx.image.new("images/tmp-win")
assert(sprLose)

local sprElevationBar <const> = gfx.image.new("images/elevation-bar")
local sprElevationBarPlayer <const> = gfx.image.new("images/elevation-bar-player")
assert(sprElevationBar)
assert(sprElevationBarPlayer)

local nick = nil
local camera = nil
local playerIndicator = nil
local fadePatterns = {
    {0xff, 0xdd, 0xff, 0x77, 0xff, 0xdd, 0xff, 0x77},
    {0xcc, 0x33, 0xcc, 0x33, 0xcc, 0x33, 0xcc, 0x33},
    {0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55, 0xaa, 0x55},
    {0x55, 0x44, 0x11, 0x55, 0xaa, 0x88, 0x22, 0xaa},
    {0x00, 0x22, 0x00, 0x88, 0x00, 0x22, 0x00, 0x88},
}
local curPattern = 0
local bgImg = nil
local bgSpr = nil

function restartGame()
    gfx.sprite.removeAll() -- clean slate plx
    nick = Nick()
    camera = Camera(nick)
    camLast = camera.offset
    spawnEnv(nick, camera)

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

    -- reset background
    curPattern = 0
    bgImg = gfx.image.new(400, 240)
    bgSpr = gfx.sprite.new()
    bgSpr:setImage(bgImg)
    bgSpr:moveTo(200,120)
    bgSpr:setIgnoresDrawOffset(true)
    bgSpr:setZIndex(-1000)

    function playerIndicator:update()
        local _, playerY = nick:getPosition()
        local percentComplete = playerY / 10
        local x, y = self:getPosition()
        y = 230 + percentComplete
        self:moveTo(x, y)

        if percentComplete < -230 then
            win()
        end

        -- do we update the background?
        local updatePattern = false

        if curPattern == 0 and percentComplete < -75 then
            bgSpr:add()
            curPattern += 1
            updatePattern = true
        elseif (curPattern == 1 and percentComplete < -90)
                or (curPattern == 2 and percentComplete < -105)
                or (curPattern == 3 and percentComplete < - 120)
                or (curPattern == 4 and percentComplete < -135) then
            curPattern += 1
            updatePattern = true
        elseif curPattern == 5 and percentComplete < -150 then
            gfx.pushContext(bgImg)
            gfx.setColor(gfx.kColorBlack)
            gfx.fillRect(0,0,400,240)
            gfx.popContext()
        end

        if updatePattern then
            gfx.pushContext(bgImg)
            gfx.setPattern(fadePatterns[curPattern])
            gfx.fillRect(0,0,400,240)
            gfx.popContext()
        end
    end

    function nick:collisionResponse(other)
        lose()
     end
end

local gameState = 1 -- 0 = ended, 1 = running
restartGame()

local tmpCtr = 0

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

function win()
    gameState = 0
    s = gfx.sprite.new()
    s:setImage(sprWin)
    s:setZIndex(100)
    s:moveTo(200,120)
    s:setIgnoresDrawOffset(true)
    s:add()
    -- stop everything
    nick.update = function() end
    playdate.stopAccelerometer()
end
