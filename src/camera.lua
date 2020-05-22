local gfx <const> = playdate.graphics

class("Camera").extends()

local topPadding <const> = 50

function Camera:init(followMe)
    self.follow = followMe
    self.offset = 0
end

function Camera:update()
    if self.follow ~= nil then
        local _, offY = self.follow:getPosition()

        if self.offset > offY then
            gfx.setDrawOffset(0, -1*offY+topPadding)
            self.offset = offY
        end
    end
end
