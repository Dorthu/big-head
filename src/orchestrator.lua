import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

-- load up graphics
local sprStreetlight <const> = gfx.image.new("images/streetlight")
assert(sprStreetlight)

local sprites = {}


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
    sprites[1] = spawnStreetlight(-20, true)
    sprites[2] = spawnStreetlight(-140, false)
end
