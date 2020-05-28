local gfx <const> = playdate.graphics

local sprUfo <const> = gfx.image.new("images/ufo")
local sptBullet <const> = gfx.imagetable/new("images/bullet")
assert(sprUfo)
assert(sptBullet)

class("Ufo").extends(gfx.sprite)

function Ufo:init()
    Ufo.super.init(self)
end

function Ufo:update()
    -- move around and shoot and stuff
end
