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

-- does what it says on the tin.
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

-- creates a streetlight that you gotta not bump into.
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
    streetlight:setCollideRect(0,0, 185, 17)
    streetlight:setGroups({2}) -- group 2 is things that kill nick
    streetlight:add()

    return streetlight
end

-- spawns the entire level.  This uses some randomness to always give you a new
-- adventure.
function spawnEnv()
    -- start with some randomness
    math.randomseed(playdate.getSecondsSinceEpoch())

    makeGround()
    local space = 100

    for c=1,5 do
        local thisSpace = (c * 120) + math.random(0, 70)
        spawnStreetlight(-1 * (space + thisSpace), c % 2 == 0)
        space = thisSpace
    end
end
