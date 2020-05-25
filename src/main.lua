import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "nick"
import "camera"
import "orchestrator"

local gfx <const> = playdate.graphics

local sprLose <const> = gfx.image.new("images/tmp-lose")
assert(sprLose)

-- initialization - TODO make this a function so we can restart the game
local nick = Nick()
local camera = Camera(nick)
spawnEnv()

function playdate:update()
    gfx.clear()
    camera:update()
    dx, dy = gfx.getDrawOffset()
    gfx.sprite.update()

    -- check for losing the game
    local _, bottomY = gfx.getDrawOffset()
    local _, nickY = nick:getPosition()
    if nickY > (-1* bottomY) + 240 then lose() end
end

function lose()
    s = gfx.sprite.new()
    s:setImage(sprLose)
    s:moveTo(200, 120)
    s:setIgnoresDrawOffset(true)
    s:add()
    -- stop nick
    nick.update = function() end
end
