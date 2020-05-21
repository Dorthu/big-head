import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

local lowThreshold <const> = 5
local midThreshold <const> = 15
local bigThreshold <const> = 40

local frameTable <const> = {
    gfx.image.new("images/nick_head_small"),
    gfx.image.new("images/nick_head_med"),
    gfx.image.new("images/nick_head_big"),
    gfx.image.new("images/nick_head_huge"),
}

local bodyImage = gfx.image.new("images/nick_body_ground")
assert(bodyImage)

for _, c in ipairs(frameTable) do
    assert(c)
end

class("NickBody").extends(gfx.sprite)

function NickBody:init()
    self:setImage(bodyImage)
    self:add()
    self:setZIndex(4)
    self:setCenter(.48, -.19)
end

class("Nick").extends(gfx.sprite)

function Nick:init()
    self:setImage(frameTable[1])
    self:setZIndex(5)
    self:add()
    self:moveTo(200, 100)
    self.inflation = 0.0
    self.inflationFrame = 1
    self.body = NickBody()
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

    -- fix our body
    self.body:moveTo(self:getPosition())

    -- move based on how inflated our head is
    local x, y = self:getPosition()
    y -= self.inflation/3
    self:moveTo(x, y)
end
