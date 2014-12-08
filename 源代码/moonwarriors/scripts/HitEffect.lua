-- 打击特效
local HitEffect = class("HitEffect", function()
    return display.newSprite("#hit.png")
end)

-- 构造函数
function HitEffect:ctor()
    self.active = true

    local blendFunc = ccBlendFunc:new()                                                                          
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    self:setBlendFunc(blendFunc)
end

function HitEffect:reset(x, y, rotation, scale)
    self:setPosition(cc.p(x, y))
    self:setRotation(rotation)
    self:setScale(scale)
    self:runAction(cc.ScaleBy:create(0.3, 2, 2))
    local array  = CCArray:create()
    array:addObject(cc.FadeOut:create(0.3))
    array:addObject(cc.CallFunc:create(handler(self, self.destroy)))
    self:runAction(cc.Sequence:create(array))
end
    
function HitEffect:destroy()
    self:setVisible(false)
    self.active = false
end

function HitEffect.getOrCreateHitEffect(x, y, rotation, scale)
    local selChild = nil
    for i = 1, #MW.CONTAINER.HITS do
        selChild = MW.CONTAINER.HITS[i]
        if (selChild.active == false) then
            selChild:setVisible(true)
            selChild.active = true
            selChild:reset(x, y, rotation, scale)
            return selChild
        end
    end
    selChild = HitEffect.create()
    selChild:reset(x, y, rotation, scale)
    return selChild
end

function HitEffect.create()
    local hitEffect = HitEffect.new()
    g_sharedGameLayer:addBulletHits(hitEffect, 9999)
    table.insert(MW.CONTAINER.HITS, hitEffect)
    return hitEffect
end

function HitEffect.preSet()
    local hitEffect = nil
    for i = 1, 10 do
        hitEffect = HitEffect.create()
        hitEffect:setVisible(false)
        hitEffect.active = false
    end
end

return HitEffect