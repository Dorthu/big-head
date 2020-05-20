import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

class("Nick").extends(gfx.sprite)

local frameTable <const> = {
    gfx.image.new("images/nick1"),
    gfx.image.new("images/nick2"),
    gfx.image.new("images/nick3"),
    gfx.image.new("images/nick4"),
}

local lowThreshold <const> = 5
local midThreshold <const> = 15
local bigThreshold <const> = 40

for _, c in ipairs(frameTable) do
    assert(c)
end

function Nick:init()
    self:setImage(frameTable[1])
    self:add()
    self:moveTo(150, 200)
    self.inflation = 0.0
    self.inflationFrame = 1
end

function Nick:update()
    -- crank fast enough that our head inflates
    local crank, accel = playdate.getCrankChange()
    if crank < 0 then crank = 0 end

    -- but it deflates too
    local deflationRate = self.inflation/2
    local newInflation = math.max(0, self.inflation + crank - deflationRate)
    local newFrame = -1

    -- did we change state?
    if self.inflationFrame ~= 1 and newInflation < lowThreshold then
        newFrame = 1
    elseif self.inflationFrame ~= 2 and lowThreshold <= newInflation and newInflation <= midThreshold then
        newFrame = 2
    elseif self.inflationFrame ~= 3 and midThreshold < newInflation and newInflation <= bigThreshold then
        newFrame = 3
    elseif self.inflationFrame ~= 4 and bigThreshold < newInflation then
        newFrame = 4
    end

    -- if so, update graphics
    if newFrame ~= -1 then
        self.inflationFrame = newFrame
        self:setImage(frameTable[newFrame]) 
    end

    self.inflation = newInflation

    -- move based on how inflated our head is
end
