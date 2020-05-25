import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

-- load up graphics
local sprStreetlight <const> = gfx.image.new("images/streetlight")
assert(sprStreetlight)

local sprGrass1 <const> = gfx.image.new("images/grass-1")
local sprGrass2 <const> = gfx.image.new("images/grass-2")
assert(sprGrass1)
assert(sprGrass2)

local sprites = {}

function makeGround()
    local s = gfx.sprite.new()
    s.counter = 0
    s:moveTo(200,  -5)
    s:setImage(sprGrass1)
    s:setScale(2)
    s:add()

    function s:update()
        s.counter += 1
        if s.counter == 15 then
            s:setImage(sprGrass2)
        elseif s.counter > 30 then
            s:setImage(sprGrass1)
            s.counter = 0
        end
    end

    return s
end

function spawnStreetlight(height, leftSide)
    local streetlight = gfx.sprite.new()
    local x = 94
    local flip = gfx.kImageUnflipped
    if not leftSide then
        x = 306
        flip = gfx.kImageFlippedX
    end

    streetlight:setImage(sprStreetlight, flip)
    streetlight:moveTo(x, height)
    streetlight:add()

    return streetlight
end

function spawnEnv()
    makeGround()
    sprites[1] = spawnStreetlight(-220, true)
    sprites[2] = spawnStreetlight(-370, false)
    sprites[3] = spawnStreetlight(-470, true)
    sprites[4] = spawnStreetlight(-600, false)
end
