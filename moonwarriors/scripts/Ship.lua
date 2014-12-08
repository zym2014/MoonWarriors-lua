local Bullet = require("Bullet")
local Explosion = require("Explosion")

-- 玩家战机类
local Ship = class("Ship", function()
    return display.newSprite("#ship01.png")
end)

-- 构造函数
function Ship:ctor()
    self.speed = 220
    self.bulletSpeed = MW.BULLET_SPEED.SHIP
    self.HP = 5
    self.bulletTypeValue = 1
    self.bulletPowerValue = 1
    self.throwBombing = false
    self.canBeAttack = true
    self.isThrowingBomb = false
    self.zOrder = 3000
    self.maxBulletPowerValue = 4
    self.appearPosition = cc.p(160, 60)
    self._hurtColorLife = 0
    self.active = true
    self.bornSprite = nil
    self._timeTick = 0

    -- init life
    self:setTag(self.zOrder)
    self:setPosition(self.appearPosition)

    -- ship animate
    local frames = display.newFrames("ship%02d.png", 1, 2)
    local animation = display.newAnimation(frames, 0.1)
    local animate = cc.Animate:create(animation)
    self:runAction(cc.RepeatForever:create(animate))
    self:schedule(handler(self, self.shoot), 1 / 6)

    self:initBornSprite()
    self:born()
end

function Ship:update(dt)
    -- Keys are only enabled on the browser
--    if (sys.platform == "browser") then
--        local x, y = self:getPosition()
--        if ((MW.KEYS[cc.KEY.w] or MW.KEYS[cc.KEY.up]) and y <= display.height) then
--            y = y + dt * self.speed
--        end
--        
--        if ((MW.KEYS[cc.KEY.s] or MW.KEYS[cc.KEY.down]) and y >= 0) then
--            y = y - dt * self.speed
--        end
--        
--        if ((MW.KEYS[cc.KEY.a] or MW.KEYS[cc.KEY.left]) and x >= 0) then
--            x = x - dt * self.speed
--        end
--        
--        if ((MW.KEYS[cc.KEY.d] or MW.KEYS[cc.KEY.right]) and x <= display.width) then
--            x = x + dt * self.speed
--        end
--        
--        self:setPosition(cc.p(x, y))
--    end

    if (self.HP <= 0) then
        self.active = false
        self:destroy()
    end
    
    self._timeTick = self._timeTick + dt
    if (self._timeTick > 0.1) then
        self._timeTick = 0
        if (self._hurtColorLife > 0) then
            self._hurtColorLife = self._hurtColorLife - 1
        end
    end
end

-- 射击
function Ship:shoot(dt)
    -- this.shootEffect();
    local offset = 13
    local x, y = self:getPosition()
    local cs = self:getContentSize()
    local a = Bullet.getOrCreateBullet(self.bulletSpeed, "W1.png", MW.ENEMY_ATTACK_MODE.NORMAL, 3000, MW.UNIT_TAG.PLAYER_BULLET)
    a:setPosition(x + offset, y + 3 + cs.height * 0.3)

    local b = Bullet.getOrCreateBullet(self.bulletSpeed, "W1.png", MW.ENEMY_ATTACK_MODE.NORMAL, 3000, MW.UNIT_TAG.PLAYER_BULLET)
    b:setPosition(x - offset, y + 3 + cs.height * 0.3)
end
    
function Ship:destroy()
    MW.LIFE = MW.LIFE - 1

    local explosion = Explosion.getOrCreateExplosion()
    explosion:setPosition(self:getPosition())

    if (MW.SOUND) then
        audio.playSound(res.shipDestroyEffect_mp3)
    end
end

-- 损害
function Ship:hurt()
    if (self.canBeAttack) then
        self._hurtColorLife = 2
        self.HP = self.HP - 1
    end
end

-- 碰撞矩形
function Ship:collideRect(x, y)
    local a = self:getContentSize()
    return cc.rect(x - a.width / 2, y - a.height / 2, a.width, a.height / 2)
end

function Ship:initBornSprite()
    self.bornSprite = display.newSprite("#ship03.png")
    local blendFunc = ccBlendFunc:new()                                                                          
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    self.bornSprite:setBlendFunc(blendFunc)
    self.bornSprite:setPosition(self:getContentSize().width / 2, 12)
    self.bornSprite:setVisible(false)
    self:addChild(self.bornSprite, 3000, 99999)
end
    
function Ship:born()
    -- revive effect
    self.canBeAttack = false
    self.bornSprite:setScale(8)
    self.bornSprite:runAction(cc.ScaleTo:create(0.5, 1, 1))
    self.bornSprite:setVisible(true)
    local blinks = cc.Blink:create(3, 9)
    local makeBeAttack = cc.CallFuncN:create(function(t)
        t.canBeAttack = true
        t:setVisible(true)
        t.bornSprite:setVisible(false)
    end)
    local array = CCArray:create()
    array:addObject(cc.DelayTime:create(0.5))
    array:addObject(blinks)
    array:addObject(makeBeAttack)
    self:runAction(cc.Sequence:create(array))

    self.HP = 5
    self._hurtColorLife = 0
    self.active = true
end

return Ship