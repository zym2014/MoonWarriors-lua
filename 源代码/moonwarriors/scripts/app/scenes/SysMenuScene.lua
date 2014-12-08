require("config.GameConfig")
require("Effect")

-- 系统菜单场景(New Game、Option、About)
local SysMenuScene = class("SysMenuScene", function()
    return display.newScene("SysMenuScene")
end)

-- 构造函数
function SysMenuScene:ctor()
    self:init()
end

function SysMenuScene:onEnter()
end

function SysMenuScene:onExit()
end

-- 初始化函数
function SysMenuScene:init()
    local bRet = false
    
    display.addSpriteFramesWithFile(res.textureTransparentPack_plist, res.textureTransparentPack_png)

    -- 背景图片
    local bg = display.newSprite(res.loading_png)
    bg:setAnchorPoint(0, 0)
    local size = bg:getContentSize()
    bg:setScaleY(display.height/size.height)
    self:addChild(bg, 0, 1)
    
    -- Logo图片
    self.logo = display.newSprite(res.logo_png, 0, display.height-230)
    self.logo:setAnchorPoint(0, 0)
    self:addChild(self.logo, 10, 1)

    local newGameNormal = cc.Sprite:create(res.menu_png, cc.rect(0, 0, 126, 33))
    local newGameSelected = cc.Sprite:create(res.menu_png, cc.rect(0, 33, 126, 33))
    local newGameDisabled = cc.Sprite:create(res.menu_png, cc.rect(0, 33 * 2, 126, 33))
    
    local gameSettingsNormal = cc.Sprite:create(res.menu_png, cc.rect(126, 0, 126, 33))
    local gameSettingsSelected = cc.Sprite:create(res.menu_png, cc.rect(126, 33, 126, 33))
    local gameSettingsDisabled = cc.Sprite:create(res.menu_png, cc.rect(126, 33 * 2, 126, 33))
    
    local aboutNormal = cc.Sprite:create(res.menu_png, cc.rect(252, 0, 126, 33))
    local aboutSelected = cc.Sprite:create(res.menu_png, cc.rect(252, 33, 126, 33))
    local aboutDisabled = cc.Sprite:create(res.menu_png, cc.rect(252, 33 * 2, 126, 33))
    
    local flare = cc.Sprite:create(res.flare_jpg)
    flare:setVisible(false)
    self:addChild(flare)
    
    local newGame = ui.newImageMenuItem({
        image = newGameNormal,
        imageSelected = newGameSelected,
        imageDisabled = newGameDisabled,
        listener = function()
            self:onButtonEffect()
            -- self:onNewGame()
            flareEffect(flare, self, handler(self, self.onNewGame))
        end
    })

    local gameSettings = ui.newImageMenuItem({
        image = gameSettingsNormal,
        imageSelected = gameSettingsSelected,
        imageDisabled = gameSettingsDisabled,
        listener = handler(self, self.onSettings)
    })
    
    local about = ui.newImageMenuItem({
        image = aboutNormal,
        imageSelected = aboutSelected,
        imageDisabled = aboutDisabled,
        listener = handler(self, self.onAbout)
    })
    
    local menu = ui.newMenu({newGame, gameSettings, about})
    menu:alignItemsVerticallyWithPadding(10);
    menu:setPosition(display.cx, display.cy - 80)
    self:addChild(menu, 1, 2)
    
    self:schedule(handler(self, self.update), 0.1)

    self._ship = display.newSprite("#ship01.png")
    self._ship:setAnchorPoint(0, 0)
    local pos = cc.p(math.random() * display.width, 0)
    self._ship:setPosition(pos)
    self:addChild(self._ship, 0, 4)
    
    self._ship:runAction(cc.MoveBy:create(2, cc.p(math.random() * display.width, pos.y + display.height + 100)))

    if MW.SOUND then
        audio.setMusicVolume(0.7)
        audio.playMusic(res.mainMainMusic_mp3, true)
    end
    
    bRet = true

    return bRet
end

-- New Game菜单按钮
function SysMenuScene:onNewGame(pSender)
    app:enterScene("MainScene", nil, "fade", 1.2)
    -- load resources
--    cc.LoaderScene.preload(g_maingame, function () {
--        var scene = cc.Scene.create()
--            scene.addChild(GameLayer.create());
--            scene.addChild(GameControlMenu.create());
--            cc.Director.getInstance().replaceScene(cc.TransitionFade.create(1.2, scene));
--        }, this);
--    }
end

-- Option菜单按钮
function SysMenuScene:onSettings(pSender)
    self.onButtonEffect()
    app:enterScene("SettingsScene", nil, "fade", 1.2)
end

-- About菜单按钮
function SysMenuScene:onAbout(pSender)
    self.onButtonEffect()
    app:enterScene("AboutScene", nil, "fade", 1.2)
end

-- 帧事件
function SysMenuScene:update()
    if self._ship:getPositionY() > 480 then
        local pos = cc.p(math.random() * display.width, 10)
        self._ship:setPosition(pos)
        self._ship:runAction(cc.MoveBy:create(
            5 * math.random(),
            cc.p(math.random() * display.width, pos.y + 480)))
    end
end

-- 播放点击菜单按钮音效
function SysMenuScene:onButtonEffect()
    if MW.SOUND then
        audio.playSound(res.buttonEffet_mp3)
    end
end

return SysMenuScene
