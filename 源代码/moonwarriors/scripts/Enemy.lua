local EnemyType = require("config.EnemyType")
local Bullet = require("Bullet")
local Explosion = require("Explosion")
local SparkEffect = require("SparkEffect")
local scheduler = require("framework.scheduler")

-- 敌机类
local Enemy = class("Enemy", function()
    return display.newSprite()
end)

-- 构造函数
function Enemy:ctor(arg)
    self.eID = 0
    self.enemyType = 1
    self.active = true
    self.speed = 200
    self.bulletSpeed = MW.BULLET_SPEED.ENEMY
    self.HP = 15
    self.bulletPowerValue = 1
    self.moveType = nil
    self.scoreValue = 200
    self.zOrder = 1000
    self.delayTime = 1 + 1.2 * math.random()
    self.attackMode = MW.ENEMY_MOVE_TYPE.NORMAL
    self._hurtColorLife = 0
    self.HP = arg.HP
    self.moveType = arg.moveType
    self.scoreValue = arg.scoreValue
    self.attackMode = arg.attackMode
    self.enemyType = arg.type
    self._timeTick = 0
    
    self:setDisplayFrame(display.newSpriteFrame(arg.textureName))
    self:schedule(handler(self, self.shoot), self.delayTime)
    -- self.handle = scheduler.scheduleGlobal(handler(self, self.shoot), self.delayTime)
end  

function Enemy:update(dt)
    local x, y = self:getPosition()
    if ((x < 0 or x > 320) and (y < 0 or y > 480)) then
        self.active = false
    end
    self._timeTick = self._timeTick + dt
    if (self._timeTick > 0.1) then
        self._timeTick = 0
        if (self._hurtColorLife > 0) then
            self._hurtColorLife = self._hurtColorLife - 1 
        end
    end

    x, y = self:getPosition()
    if (x < 0 or x > g_sharedGameLayer.screenRect.width 
        or y < 0 or y > g_sharedGameLayer.screenRect.height 
        or self.HP <= 0) then
        self.active = false
        self:destroy()
    end
end

function Enemy:destroy()
    MW.SCORE = MW.SCORE + self.scoreValue
    local a = Explosion.getOrCreateExplosion()
    local x, y = self:getPosition()
    a:setPosition(x, y)
    SparkEffect.getOrCreateSparkEffect(x, y)
    if (MW.SOUND) then
        audio.playSound(res.explodeEffect_mp3)
    end
    self:setVisible(false)
    self.active = false
    self:stopAllActions()
    --self:unschedule(self.shoot)
    --scheduler.unscheduleGlobal(self.handle)
    MW.ACTIVE_ENEMIES = MW.ACTIVE_ENEMIES - 1
end

-- 射击
function Enemy:shoot()
    local x, y = self:getPosition()
    local b = Bullet.getOrCreateBullet(self.bulletSpeed, "W2.png", self.attackMode, 3000, MW.UNIT_TAG.ENMEY_BULLET)
    b:setPosition(x, y - self:getContentSize().height * 0.2)
end

-- 损害
function Enemy:hurt()
    self._hurtColorLife = 2
    self.HP = self.HP - 1
end

-- 碰撞矩形
function Enemy:collideRect(x, y)
    local a = self:getContentSize()
    return cc.rect(x - a.width / 2, y - a.height / 4, a.width, a.height / 2+20)
end
    
function Enemy.getOrCreateEnemy(arg)
    local selChild = nil
    for j = 1, #MW.CONTAINER.ENEMIES do
        selChild = MW.CONTAINER.ENEMIES[j]

        if (selChild.active == false and selChild.enemyType == arg.type) then
            selChild.HP = arg.HP
            selChild.active = true
            selChild.moveType = arg.moveType
            selChild.scoreValue = arg.scoreValue
            selChild.attackMode = arg.attackMode
            selChild._hurtColorLife = 0

            selChild:schedule(handler(selChild, selChild.shoot), selChild.delayTime)
            -- selChild.handle = scheduler.scheduleGlobal(handler(selChild, selChild.shoot), selChild.delayTime)
            selChild:setVisible(true)
            MW.ACTIVE_ENEMIES = MW.ACTIVE_ENEMIES + 1
            return selChild
        end
    end
    selChild = Enemy.create(arg)
    MW.ACTIVE_ENEMIES = MW.ACTIVE_ENEMIES + 1
    return selChild
end

function Enemy.create(arg)
    local enemy = Enemy.new(arg)
    g_sharedGameLayer:addEnemy(enemy, enemy.zOrder, MW.UNIT_TAG.ENEMY)
    table.insert(MW.CONTAINER.ENEMIES, enemy)
    return enemy
end

function Enemy.preSet()
    local enemy = nil
    for i = 1, 3 do
        for j = 1, #EnemyType do
            enemy = Enemy.create(EnemyType[j])
            enemy:setVisible(false)
            enemy.active = false
            enemy:stopAllActions()
            --enemy:unscheduleAllCallbacks()
        end
    end
end

return Enemy