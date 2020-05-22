import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "nick"
import "camera"

local gfx <const> = playdate.graphics

local nick = Nick()
local camera = Camera(nick)

function playdate:update()
    gfx.clear()
    camera:update()
    dx, dy = gfx.getDrawOffset()
    gfx.sprite.update()
end
