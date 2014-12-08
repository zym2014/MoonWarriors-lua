-- 关于场景
local AboutScene = class("AboutScene", function()
    return display.newScene("AboutScene")
end)

-- 构造函数
function AboutScene:ctor()
    self:init()
end

-- 初始化函数
function AboutScene:init()
    local bRet = false
    
    -- 背景图片
    local bg = display.newSprite(res.loading_png)
    bg:setAnchorPoint(0,0)
    local size = bg:getContentSize()
    bg:setScaleY(display.height/size.height)
    self:addChild(bg, 0, 1)

    -- "About"标题图片
    local title = cc.Sprite:create(res.menuTitle_png, cc.rect(0, 36, 100, 34))
    title:setPosition(display.cx, display.height - 60)
    self:addChild(title)

    local text = [[
    This showcase utilizes many features from Cocos2d-html5 engine, including: Parallax background, tilemap, actions, ease, frame animation, schedule, Labels, keyboard Dispatcher, Scene Transition. 
    Art and audio is copyrighted by Enigmata Genus Revenge, you may not use any copyrigted material without permission. This showcase is licensed under GPL. 
        
Cocos2d-html5版: 
    Shengxiang Chen (陈升想) 
    Dingping Lv (吕定平) 
    Effects animation: Hao Wu(吴昊)
    Quality Assurance:  Sean Lin(林顺)
    
Quick-Cocos2d-x移植版：
    ZYM (倚天)  QQ：43156150

源代码下载地址：
https://github.com/zym2014/MoonWarriors-lua
    ]]
    
    -- There is a bug in LabelTTF native. Apparently it fails with some unicode chars.
    local about = ui.newTTFLabel({text = text, font = "Arial", 
        size = 14, align = ui.TEXT_ALIGN_LEFT,
        dimensions = cc.size(display.width * 0.90, 0)
    })
    about:setPosition(display.cx, display.cy - 20)
    about:setAnchorPoint(0.5, 0.5)
    self:addChild(about)
    
    -- "Go back"菜单按钮
    local back = ui.newTTFLabelMenuItem({  
        text = "Go back",
        font = "Arial",
        size = 14,
        aligh = ui.TEXT_ALIGN_CENTER,  
        listener = self.onBackCallback,  
        -- x = display.cx,  
        -- y = 40,  
        tag = 2  
    })
    local menu = ui.newMenu({back})
    menu:setPosition(display.cx, 40)
    self:addChild(menu)
    
    bRet = true

    return bRet
end

-- "Go Back"菜单按钮
function AboutScene:onBackCallback(pSender)
    app:enterScene("SysMenuScene", nil, "fade", 1.2)
end

return AboutScene