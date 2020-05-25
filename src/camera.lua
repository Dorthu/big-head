local gfx <const> = playdate.graphics

class("Camera").extends()

local topPadding <const> = 150

function Camera:init(followMe)
    self.follow = followMe
    self.offset = -240
    gfx.setDrawOffset(0, 240)
end

function Camera:update()
    if self.follow ~= nil then
        local _, offY = self.follow:getPosition()

        -- we scrollin'?
        if self.offset > offY - topPadding then
            offY = offY-topPadding + self.offset

            -- don't scroll too fast
            if offY < -5 then offY = -5 end

            self.offset += offY
            gfx.setDrawOffset(0, -1*self.offset)
        end
    end
end
