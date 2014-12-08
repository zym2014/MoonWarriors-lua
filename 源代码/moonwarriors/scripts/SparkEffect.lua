-- 火花物效
local SparkEffect = class("SparkEffect")

-- 构造函数
function SparkEffect:ctor()
    self.active = true
    self.scale = 1.2
    self.duration = 0.7

    -- 爆炸图片一
    self.spark1 = display.newSprite("#explode2.png")
    local blendFunc = ccBlendFunc:new()
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    self.spark1:setBlendFunc(blendFunc)
    
    -- 爆炸图片二
    self.spark2 = display.newSprite("#explode3.png")
    local blendFunc = ccBlendFunc:new()
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    self.spark2:setBlendFunc(blendFunc)
end

function SparkEffect:reset(x, y)
    self.spark1:setPosition(cc.p(x, y))
    self.spark2:setPosition(cc.p(x, y))

    self.spark1:setScale(self.scale)
    self.spark2:setScale(self.scale)
    self.spark2:setRotation(math.random() * 360)

    local right = cc.RotateBy:create(self.duration, 45)
    local scaleBy = cc.ScaleBy:create(self.duration, 3, 3)
    local array = CCArray:create()
    array:addObject(cc.FadeOut:create(self.duration))
    array:addObject(cc.CallFunc:create(handler(self, self.destroy)))
    local seq = cc.Sequence:create(array)

    self.spark1:runAction(right)
    self.spark1:runAction(scaleBy)
    self.spark1:runAction(seq)

    self.spark2:runAction(clone(scaleBy))
    self.spark2:runAction(clone(seq))
end

function SparkEffect:destroy()
    self.active = false
    self.spark1:setVisible(false)
    self.spark2:setVisible(false)
    self.spark1:stopAllActions()
    self.spark2:stopAllActions()
end

function SparkEffect.getOrCreateSparkEffect(x, y)
    local selChild = nil
    for i = 1, #MW.CONTAINER.SPARKS do
        selChild = MW.CONTAINER.SPARKS[i]
        if (selChild.active == false) then
            selChild.active = true
            selChild.spark1:setVisible(true)
            selChild.spark2:setVisible(true)
            selChild:reset(x, y)
            return selChild
        end
    end
    local spark = SparkEffect.create()
    spark:reset(x, y)
    return spark
end

function SparkEffect.create()
    local sparkEffect = SparkEffect.new()
    g_sharedGameLayer:addSpark(sparkEffect.spark1)
    g_sharedGameLayer:addSpark(sparkEffect.spark2)
    table.insert(MW.CONTAINER.SPARKS, sparkEffect)
    return sparkEffect
end

function SparkEffect.preSet()
    local sparkEffect = nil
    for i = 1, 6 do
        sparkEffect = SparkEffect.create()
        sparkEffect.active = false
        sparkEffect.spark1:setVisible(false)
        sparkEffect.spark2:setVisible(false)
    end
end

return SparkEffect