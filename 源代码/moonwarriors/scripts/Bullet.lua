local HitEffect = require("HitEffect")

-- 子弹类
local Bullet = class("Bullet", function()
    return display.newSprite()
end)

-- 构造函数
function Bullet:ctor(bulletSpeed, weaponType, attackMode)
    self.active = true
    self.xVelocity = 0
    self.yVelocity = 200
    self.power = 1
    self.HP = 1
    self.moveType = nil
    self.zOrder = 3000
    self.attackMode = MW.ENEMY_MOVE_TYPE.NORMAL
    self.parentType = MW.BULLET_TYPE.PLAYER
    
    self.yVelocity = -bulletSpeed
    self.attackMode = attackMode
    self:setDisplayFrame(display.newSpriteFrame(weaponType))
    local blendFunc = ccBlendFunc:new()                                                                          
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    self:setBlendFunc(blendFunc)
end

function Bullet:update(dt)
    local x, y = self:getPosition()
    self:setPosition(x - self.xVelocity * dt, y - self.yVelocity * dt)
    if (x < 0 or x > g_sharedGameLayer.screenRect.width 
        or y < 0 or y > g_sharedGameLayer.screenRect.height
        or self.HP <= 0) then
        self:destroy()
    end
end

function Bullet:destroy()
    local x, y = self:getPosition()
    local explode = HitEffect.getOrCreateHitEffect(
        x, y, math.random() * 360, 0.75)
    self.active = false
    self:setVisible(false)
end

-- 损害
function Bullet:hurt()
    self.HP = self.HP - 1
end

-- 碰撞矩形
function Bullet:collideRect(x, y)
    return cc.rect(x - 3, y - 3, 6, 6)
end

function Bullet.getOrCreateBullet(bulletSpeed, 
    weaponType, attackMode, zOrder, mode)
    local selChild = nil
    if (mode == MW.UNIT_TAG.PLAYER_BULLET) then -- 玩家子弹
        for i = 1, #MW.CONTAINER.PLAYER_BULLETS do
            selChild = MW.CONTAINER.PLAYER_BULLETS[i]
            if (selChild.active == false) then
                selChild:setVisible(true)
                selChild.HP = 1
                selChild.active = true
                return selChild
            end
        end
    else    -- 敌机子弹
        for i = 1, #MW.CONTAINER.ENEMY_BULLETS do
            selChild = MW.CONTAINER.ENEMY_BULLETS[i]
            if (selChild.active == false) then
                selChild:setVisible(true)
                selChild.HP = 1
                selChild.active = true
                return selChild
            end
        end
    end
    selChild = Bullet.create(bulletSpeed, weaponType, attackMode, zOrder, mode)
    return selChild
end

function Bullet.create(bulletSpeed, 
    weaponType, attackMode, zOrder, mode)
    local bullet = Bullet.new(bulletSpeed, weaponType, attackMode)
    g_sharedGameLayer:addBullet(bullet, zOrder, mode)
    if (mode == MW.UNIT_TAG.PLAYER_BULLET) then
        table.insert(MW.CONTAINER.PLAYER_BULLETS, bullet)
    else
        table.insert(MW.CONTAINER.ENEMY_BULLETS, bullet)
    end
    return bullet
end

function Bullet.preSet()
    local bullet = nil
    for i = 1, 10 do
        local bullet = Bullet.create(MW.BULLET_SPEED.SHIP, "W1.png", MW.ENEMY_ATTACK_MODE.NORMAL, 3000, MW.UNIT_TAG.PLAYER_BULLET)
        bullet:setVisible(false)
        bullet.active = false
    end
    for i = 1, 10 do
        bullet = Bullet.create(MW.BULLET_SPEED.ENEMY, "W2.png", MW.ENEMY_ATTACK_MODE.NORMAL, 3000, MW.UNIT_TAG.ENMEY_BULLET)
        bullet:setVisible(false)
        bullet.active = false
    end
end

return Bullet