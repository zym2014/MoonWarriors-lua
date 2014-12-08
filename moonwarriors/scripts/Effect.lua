-- 闪光特效
function flareEffect(flare, target, callback)
    flare:setVisible(true)
    flare:stopAllActions()
    local blendFunc = ccBlendFunc:new()                                                                          
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    flare:setBlendFunc(blendFunc)
    flare:setOpacity(0)
    flare:setPosition(-30, display.height-(480-297))
    flare:setRotation(-120)
    flare:setScale(0.2)

    local opacityAnim = cc.FadeTo:create(0.5, 255)
    local opacDim = cc.FadeTo:create(1, 0)
    local biggeAnim = cc.ScaleBy:create(0.7, 1.2, 1.2)
    local biggerEase = cc.EaseSineOut:create(biggeAnim)
    local moveAnim = cc.MoveBy:create(0.5, cc.p(328, 0))
    local easeMove = cc.EaseSineOut:create(moveAnim)
    local rotateAnim = cc.RotateBy:create(2.5, 90)
    local rotateEase = cc.EaseExponentialOut:create(rotateAnim)
    local bigger = cc.ScaleTo:create(0.5, 1)

    local onComplete = cc.CallFuncN:create(callback)
    local killflare = cc.CallFunc:create(function()
        flare:getParent():removeChild(self, true)
    end)
    
    local array  = CCArray:create()
    array:addObject(opacityAnim)
    array:addObject(biggerEase)
    array:addObject(opacDim)
    array:addObject(killflare)
    array:addObject(onComplete)
    flare:runAction(cc.Sequence:create(array))
    flare:runAction(easeMove)
    flare:runAction(rotateEase)
    flare:runAction(bigger)
end

function removeFromParent(sprite)
    sprite:removeFromParent()
end

function spark(ccpoint, parent, scale, duration)
    scale = scale or 0.3
    duration = duration or 0.5

    local one = display.newSprite("#explode1.png")
    local two = display.newSprite("#explode2.png")
    local three = display.newSprite("#explode3.png")

    one:setPosition(ccpoint)
    two:setPosition(ccpoint)
    three:setPosition(ccpoint)

    -- parent.addChild(one);
    parent:addSpark(two)
    parent:addSpark(three)
    one:setScale(scale)
    two:setScale(scale)
    three:setScale(scale)

    three:setRotation(math.random() * 360)

    local left = cc.RotateBy:create(duration, -45)
    local right = cc.RotateBy:create(duration, 45)
    local scaleBy = cc.ScaleBy:create(duration, 3, 3)
    local fadeOut = cc.FadeOut:create(duration)
    local remove = cc.CallFuncN:create(removeFromParent)
    local array  = CCArray:create()
    array:addObject(fadeOut)
    array:addObject(remove)
    local seq = cc.Sequence:create(array)

    one:runAction(left)
    two:runAction(right)

    one:runAction(scaleBy)
    two:runAction(clone(scaleBy))
    three:runAction(clone(scaleBy))

    one:runAction(seq)
    two:runAction(clone(seq))
    three:runAction(clone(seq))
end

