import "CoreLibs/sprites"
import "CoreLibs/graphics"

local gfx <const> = playdate.graphics

local lowThreshold <const> = 5
local midThreshold <const> = 15
local bigThreshold <const> = 40

local gravity <const> = 8

local frameTable <const> = {
    gfx.image.new("images/nick_head_small"),
    gfx.image.new("images/nick_head_med"),
    gfx.image.new("images/nick_head_big"),
    gfx.image.new("images/nick_head_huge"),
}

local bodyImageGround = gfx.image.new("images/nick_body_smol")
local bodyImageTakeoff = gfx.image.new("images/nick_body_takeoff")
local bodyImageFly = gfx.image.new("images/nick_body_fly")
local bodyImageCharge = gfx.image.new("images/nick_body_charge")
local bodyImageLunge = gfx.image.new("images/nick_body_lunge")
local bodyImageLunge2 = gfx.image.new("images/nick_body_lunge_end")
assert(bodyImageGround)
assert(bodyImageTakeoff)
assert(bodyImageFly)
assert(bodyImageCharge)
assert(bodyImageLunge)
assert(bodyImageLunge2)

for _, c in ipairs(frameTable) do
    assert(c)
end

class("NickBody").extends(gfx.sprite)

function NickBody:init()
    self:setImage(bodyImageGround)
    self:add()
    self:setZIndex(4)
    self:setCenter(.48, -.5)
end

class("Nick").extends(gfx.sprite)

function Nick:init()
    self:setImage(frameTable[1])
    self:setZIndex(5)
    self:add()
    self:moveTo(200, -60)
    self.inflation = 0.0
    self.inflationFrame = 1
    self.body = NickBody()
    self.flightStage = 0
    self.chargingDash = 0
    self.dashSpeed = 0
    self.dashFrame = 0
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

    -- update the body's image for takeoff
    if self.flightStage == 0 and self.inflation > 0 then
        self.flightStage = 1
        self.body:setImage(bodyImageTakeoff)
        playdate.startAccelerometer() -- we're flyin' now
    elseif self.flightStage == 1 and self.inflation > 1 then
        self.flightStage = 2
        self.body:setImage(bodyImageFly)
    end

    -- move based on how inflated our head is
    local x, y = self:getPosition()
    local stageGravity = gravity
    if self.flightStage == 0 then stageGravity = 0 end
    y -= self.inflation/3 - stageGravity

    -- dash things
    if self.dashSpeed ~= 0 then
        self.dashFrame += 1
        local thisChange = self.dashFrame/2
        local flip = gfx.kImageUnflipped

        if self.dashSpeed > 0 then
            flip = gfx.kImageFlippedX
            thisChange *= -1
        end

        if math.abs(thisChange) > math.abs(self.dashSpeed) then
            thisChange = self.dashSpeed
        end

        self.dashSpeed += thisChange

        if math.abs(self.dashSpeed) > 6 then
            self.body:setImage(bodyImageLunge, flip)
        elseif math.abs(self.dashSpeed) > 1 then
            self.body:setImage(bodyImageLunge2, flip)
        else
            self.dashspeed = 0
            self.dashFrame = 0
            self.body:setImage(bodyImageFly)
        end
    elseif self.chargingDash == 0 then
        if playdate.buttonJustPressed(playdate.kButtonLeft) then
            self.chargingDash = -1
            self.body:setImage(bodyImageCharge)
        elseif playdate.buttonJustPressed(playdate.kButtonRight) then
            self.chargingDash = 1
            self.body:setImage(bodyImageCharge, gfx.kImageFlippedX) -- flipped
        end
    else
        if self.chargingDash == -1 and playdate.buttonJustReleased(playdate.kButtonLeft) then
            self.dashSpeed = -15
            self.chargingDash = 0
        elseif self.chargingDash == 1 and playdate.buttonJustReleased(playdate.kButtonRight) then
            self.dashSpeed = 15
            self.chargingDash = 0
        end
    end

    local drift = playdate.readAccelerometer()
    if drift == nil then drift = 0 else drift *= 2 end

    x += self.dashSpeed + drift

    if x < 5 then
        x = 5
    elseif x > 395 then
        x = 395
    end

    self:moveTo(x, y)

    -- fix our body
    self.body:moveTo(self:getPosition())
end
