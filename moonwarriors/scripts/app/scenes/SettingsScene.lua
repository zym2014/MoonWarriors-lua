-- 设置场景
local SettingsScene = class("SettingsScene", function()
    return display.newScene("SettingsScene")
end)

-- 构造函数
function SettingsScene:ctor()
    self:init()
end

-- 初始化函数
function SettingsScene:init()
    local bRet = false
    
    -- 背景图片
    local bg = display.newSprite(res.loading_png)
    bg:setAnchorPoint(0, 0)
    size = bg:getContentSize()
    bg:setScaleY(display.height/size.height)
    self:addChild(bg, 0, 1)

    -- "Option"标题图片
    local title = cc.Sprite:create(res.menuTitle_png, cc.rect(0, 0, 134, 34))
    title:setPosition(display.cx, display.height - 120)
    self:addChild(title)

    -- "Sound"菜单文本
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(18)
    local title1 = cc.MenuItemFont:create("Sound")
    title1:setEnabled(false)

    -- "On/Off"菜单按钮
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(26)
    local item1 = cc.MenuItemToggle:create()
    item1:addSubItem(cc.MenuItemFont:create("On"))
    item1:addSubItem(cc.MenuItemFont:create("Off"))
    item1:addNodeEventListener(cc.MENU_ITEM_CLICKED_EVENT, function(tag)
        self:onSoundControl(tag)
    end)
    local state = (MW.SOUND and 0) or 1     -- var state = MW.SOUND ? 0 : 1;
    item1:setSelectedIndex(state)

    -- "Mode"菜单文本
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(18)
    local title2 = cc.MenuItemFont:create("Mode")
    title2:setEnabled(false)

    -- "Easy/Normal/Hard"菜单按钮
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(26)
    local item2 = cc.MenuItemToggle:create()
    item2:addSubItem(cc.MenuItemFont:create("Easy"))
    item2:addSubItem(cc.MenuItemFont:create("Normal"))
    item2:addSubItem(cc.MenuItemFont:create("Hard"))
    item2:addNodeEventListener(cc.MENU_ITEM_CLICKED_EVENT, function(tag)
        self:onModeControl(tag)
    end)
    item2:setSelectedIndex(0)
    
    -- "Go back"菜单按钮
    local back = ui.newTTFLabelMenuItem({  
        text = "Go back",
        font = "Arial",
        size = 20,
        aligh = ui.TEXT_ALIGN_CENTER,  
        listener = self.onBackCallback,  
        -- x = display.cx,  
        -- y = 40,  
        tag = 2  
    })
    back:setScale(0.8)
    
    local menu = ui.newMenu({title1, title2, item1, item2, back})
    local arrCols = CCArray:create()
    arrCols:addObject(CCInteger:create(2))
    arrCols:addObject(CCInteger:create(2))
    arrCols:addObject(CCInteger:create(1))
    menu:alignItemsInColumnsWithArray(arrCols)
    arrCols:removeAllObjects()
    menu:setPosition(display.cx, display.cy)
    self:addChild(menu)
    
    back:setPositionY(back:getPositionY() - 50)
    
    bRet = true
    
    return bRet
end

-- "Go back"菜单按钮
function SettingsScene:onBackCallback(pSender)
    app:enterScene("SysMenuScene", nil, "fade", 1.2)
end

-- "On/Off"菜单按钮
function SettingsScene:onSoundControl()
    MW.SOUND = not MW.SOUND
    if MW.SOUND then
        audio.playMusic(res.mainMainMusic_mp3)
    else
        audio.stopMusic()
    end
end

-- "Easy/Normal/Hard"菜单按钮
function SettingsScene:onModeControl()

end

return SettingsScene
