-- 游戏结束场景
local GameOverScene = class("GameOverScene", function()
    return display.newScene("GameOverScene")
end)

-- 构造函数
function GameOverScene:ctor()
    local bRet = false
    
    -- 背景图片
    local bg = display.newSprite(res.loading_png)
    bg:setAnchorPoint(0, 0)
    local size = bg:getContentSize()
    bg:setScaleY(display.height/size.height)
    self:addChild(bg, 0, 1)

    -- 闪光图片
    local flare = display.newSprite(res.flare_jpg)
    self:addChild(flare)
    flare:setVisible(false)
    
    -- "Game Over"图片
    local logo = display.newSprite(res.gameOver_png)
    logo:setAnchorPoint(0, 0)
    logo:setPosition(0, display.height-180)
    self:addChild(logo, 10, 1)

    -- "Your Score"文本标签
    local lbScore = ui.newTTFLabel({text = "Your Score:" .. MW.SCORE, 
        font = "Arial Bold", size = 16})
    lbScore:setPosition(160, display.height-200)
    lbScore:setColor(cc.c3b(250, 179, 0))
    self:addChild(lbScore, 10)
    
    -- "Play Again"菜单按钮
    local playAgainNormal = cc.Sprite:create(res.menu_png, cc.rect(378, 0, 126, 33))
    local playAgainSelected = cc.Sprite:create(res.menu_png, cc.rect(378, 33, 126, 33))
    local playAgainDisabled = cc.Sprite:create(res.menu_png, cc.rect(378, 33 * 2, 126, 33))

    local playAgain = ui.newImageMenuItem({
        image = playAgainNormal,
        imageSelected = playAgainSelected,
        imageDisabled = playAgainDisabled,
        listener = function()
            flareEffect(flare, self, handler(self, self.onPlayAgain))
        end
    })
    
    local menu = ui.newMenu({playAgain})
    menu:setPosition(display.cx, display.height-260)
    self:addChild(menu, 1, 2)
    
    -- "Cocos2d-x"图片
    local cocos2dhtml5 = display.newSprite(res.cocos2d_html5_png)
    cocos2dhtml5:setPosition(160, display.height-330)
    self:addChild(cocos2dhtml5, 10)
    
    -- "Download Cocos2d-html5"菜单按钮
    local menu1 = ui.newTTFLabelMenuItem({  
        text = "Download Cocos2d-html5",
        font = "Arial",
        size = 14,
        aligh = ui.TEXT_ALIGN_CENTER,  
    -- listener = self.onBackCallback
    })

    -- "Download This Sample"菜单按钮
    local menu2 = ui.newTTFLabelMenuItem({  
        text = "Download This Sample",
        font = "Arial",
        size = 14,
        aligh = ui.TEXT_ALIGN_CENTER,  
    -- listener = self.onBackCallback
    })

    local menu = ui.newMenu({menu1, menu2})
    menu:alignItemsVerticallyWithPadding(10)
    menu:setPosition(160, display.height-400)
    self:addChild(menu)
    
    -- 播放背景音乐
    if MW.SOUND then
        audio.playMusic(res.mainMainMusic_mp3)
    end

    bRet = true

    return bRet
end

-- "Play Again"菜单按钮
function GameOverScene:onPlayAgain(pSender)
    app:enterScene("MainScene", nil, "fade", 1.2)
end

return GameOverScene