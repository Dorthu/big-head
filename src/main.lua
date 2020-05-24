import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "nick"
import "camera"
import "orchestrator"

local gfx <const> = playdate.graphics

local nick = Nick()
local camera = Camera(nick)
spawnEnv()

function playdate:update()
    gfx.clear()
    camera:update()
    dx, dy = gfx.getDrawOffset()
    gfx.sprite.update()
end
