import "CoreLibs/animation"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics
local geo <const> = playdate.geometry

local sprUfo <const> = gfx.image.new("images/ufo")
local sptBullet <const> = gfx.imagetable.new("images/bullet")
assert(sprUfo)
assert(sptBullet)

class("Bullet").extends(gfx.sprite)

function Bullet:init(loc, move)
    Bullet.super.init(self)

    self.move = move
    self.lifetime = 10
    self:moveTo(loc:unpack())
    local anim = gfx.animation.loop.new(sptBullet)
    self:setImage(sptBullet:getImage(15%3+1))
    self:setCollideRect(2, 2, 6, 6)
    self:setGroups({2})
    self:add()
end

function Bullet:update()
    self.lifetime -= 1
    self:moveBy(self.move:unpack())
    self:setImage(sptBullet:getImage(15%3+1))
end


class("Ufo").extends(gfx.sprite)

function Ufo:init(nick, height)
    Ufo.super.init(self)

    self.nick = nick
    self.height = height
    self:setImage(sprUfo)
    self:moveTo(200, height)
    self:add()
    self.ticker = 0
    self.shotPattern = math.random(1, 3)
    self.shooting = false
    self.shootTimer = 0
end

function Ufo:update()
    -- move around and shoot and stuff
    self.ticker += 1

    if not self.shooting and self.ticker % 10 == 0 and math.random(1, 10) == 1 then
        self.shooting = true
        self.shootTimer = math.random(2, 4)
    end

    if self.shooting and self.ticker % 5 == 0 then
        local bX, bY = self:getPosition()
        bY += 10
        local spawnPoint = geo.point.new(bX, bY)
        local mv = geo.vector2D.new(0, 0)

        if self.shootPattern == 1 then
            mv.dx = -5
            mv.dy = 5
            Bullet(spawnPoint, mv:copy())
            mv.dx = 0
            Bullet(spawnPoint, mv:copy())
            mv.dx = 5
            Bullet(spawnPoint, mv:copy())
        elseif self.shootPattern == 2 then
            mv.dx = -3
            mv.dy = 5
            Bullet(spawnPoint, mv:copy())
            mv.dx = 3
            Bullet(spawnPoint, mv:copy())
        else
            mv.dy = 5
            Bullet(spawnPoint, mv:copy())
        end

        self.shootTimer -= 1
        if self.shootTimer < 1 then
            self.shooting = false
            self.shootPattern = math.random(1, 3)
        end
    end
end
