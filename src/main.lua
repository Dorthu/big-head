import "CoreLibs/sprites"
import "CoreLibs/graphics"
import "nick"

local gfx <const> = playdate.graphics

local nick = Nick()

function playdate:update()
    gfx.sprite.update()
end
