-- 爆炸类
local Explosion = class("Explosion", function()
    return display.newSprite("#explosion_01.png")
end)

-- 构造函数
function Explosion:ctor()
    self.tmpWidth = 0
    self.tmpHeight = 0
    self.active = true

    local blendFunc = ccBlendFunc:new()                                                                          
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    self:setBlendFunc(blendFunc)

    local sz = self:getContentSize()
    self.tmpWidth = sz.width
    self.tmpHeight = sz.height
    self.animation = display.getAnimationCache("Explosion")
end

-- 播放爆炸动画
function Explosion:play()
    local array = CCArray:create()
    array:addObject(cc.Animate:create(self.animation))
    array:addObject(cc.CallFunc:create(handler(self, self.destroy)))
    self:runAction(cc.Sequence:create(array))
end

function Explosion:destroy()
    self:setVisible(false)
    self.active = false
    self:stopAllActions()
end

function Explosion.sharedExplosion()
    local frames = display.newFrames("explosion_%02d.png", 1, 35)
    local animation = display.newAnimation(frames, 0.04)
    display.setAnimationCache("Explosion", animation)
end

function Explosion.getOrCreateExplosion()
    local selChild = nil
    for i = 1, #MW.CONTAINER.EXPLOSIONS do
        selChild = MW.CONTAINER.EXPLOSIONS[i]
        if (selChild.active == false) then
            selChild:setVisible(true)
            selChild.active = true
            selChild:play()
            return selChild
        end
    end
    selChild = Explosion.create()
    selChild:play()
    return selChild
end

function Explosion.create()
    local explosion = Explosion.new()
    g_sharedGameLayer:addExplosions(explosion)
    table.insert(MW.CONTAINER.EXPLOSIONS, explosion)
    return explosion
end

function Explosion.preSet()
    local explosion = nil
    for i = 1, 6 do
        explosion = Explosion.create()
        explosion:setVisible(false)
        explosion.active = false
    end
end

return Explosion