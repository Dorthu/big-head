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

local sprBird1 <const> = gfx.image.new("images/bird1")
local sprBird2 <const> = gfx.image.new("images/bird2")
assert(sprBird1)
assert(sprBird2)

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

function spawnBird(height, x)
    local bird = gfx.sprite.new()
    bird:setImage(sprBird1)
    bird:moveTo(x, height)
    bird:setCollideRect(11, 19, 38, 12)
    bird:setGroups({2})
    bird:add()
    bird.direction = 1
    bird.counter = 1
    bird.speed = math.random(3, 7)

    function bird:update()
        local x, y = self:getPosition()
        local needsUpdate = false
        if x > 350 then
            self.direction = -1
            needsUpdate = true
        elseif x < 50 then
            self.direction = 1
            needsUpdate = true
        end
        self:moveTo(x+(self.speed*self.direction), y)
        self.counter += 1
        if needsUpdate or self.counter == 11 or self.counter == 21 then
            local flip = gfx.kImageUnflipped
            if self.direction < 0 then flip = gfx.kImageFlippedX end
            if self.counter >= 11 and self.counter < 21 then
                self:setImage(sprBird2, flip)
            else
                self:setImage(sprBird1, flip)
                self.counter = 1
            end
        end
    end
end

-- spawns the entire level.  This uses some randomness to always give you a new
-- adventure.
function spawnEnv()
    -- start with some randomness
    math.randomseed(playdate.getSecondsSinceEpoch())

    makeGround()
    local space = 100

    -- spawn the streetlight region
    for c=1,5 do
        local thisSpace = (c * 60) + math.random(0, 40)
        spawnStreetlight(-1 * (space + thisSpace), c % 2 == 0)
        space += thisSpace
    end

    -- spawn the bird region
    for c=1,5 do
        local thisSpace = (c * 70) + math.random(-30, 50)
        spawnBird(-1 * (space + thisSpace), math.random(0, 300))
        space += thisSpace
    end
end
