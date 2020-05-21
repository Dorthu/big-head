local gfx <const> = playdate.graphics

class("Camera").extends()

function Camera:init(followMe)
    self.follow = followMe
end

function Camera:update()
    if self.follow ~= nil then
        local _, offY = self.follow:getPosition()
        gfx.setDrawOffset(0, offY+100)
    end
end
