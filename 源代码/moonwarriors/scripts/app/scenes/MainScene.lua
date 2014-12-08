local LevelManager = require("LevelManager")
local Ship = require("Ship")
local Explosion = require("Explosion")
local Bullet = require("Bullet")
local Enemy = require("Enemy")
local HitEffect = require("HitEffect")
local SparkEffect = require("SparkEffect")
local Bg = require("Background")
local BackSky = Bg.BackSky
local BackTileMap = Bg.BackTileMap

STATE_PLAYING = 0
STATE_GAMEOVER = 1
MAX_CONTAINT_WIDTH = 40
MAX_CONTAINT_HEIGHT = 40

g_sharedGameLayer = nil

-- 主场景
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

-- 构造函数
function MainScene:ctor()        
    self._time = 0
    self._ship = nil
    self._backSky = nil
    self._backSkyHeight = 0
    self._backSkyRe = nil
    self._levelManager = nil
    self._tmpScore = 0
    self._isBackSkyReload = false
    self._isBackTileReload = false
    self.lbScore = nil
    self.screenRect = nil
    self.explosionAnimation = {}
    self._beginPos = cc.p(0, 0)
    self._state = STATE_PLAYING
    self._explosions = nil
    self._texOpaqueBatch = nil
    self._texTransparentBatch = nil
    
    self:init()
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

-- 初始化函数
function MainScene:init()
    local bRet = false

    -- reset global values
    MW.CONTAINER.ENEMIES = {}
    MW.CONTAINER.ENEMY_BULLETS = {}
    MW.CONTAINER.PLAYER_BULLETS = {}
    MW.CONTAINER.EXPLOSIONS = {}
    MW.CONTAINER.SPARKS = {}
    MW.CONTAINER.HITS = {}
    MW.CONTAINER.BACKSKYS = {}
    MW.CONTAINER.BACKTILEMAPS = {}
    MW.ACTIVE_ENEMIES = 0

    MW.SCORE = 0
    MW.LIFE = 4
    self._state = STATE_PLAYING

    -- 加载纹理图片
    display.addSpriteFramesWithFile(res.textureOpaquePack_plist, res.textureOpaquePack_png)
    display.addSpriteFramesWithFile(res.textureTransparentPack_plist, res.textureTransparentPack_png)
    display.addSpriteFramesWithFile(res.explosion_plist, res.explosion_png)
    display.addSpriteFramesWithFile(res.b01_plist, res.b01_png)

    -- create touch layer
    self.layer = display.newLayer()
    self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
    self:addChild(self.layer)
    
    self.layer:setTouchEnabled(true)

    -- OpaqueBatch
    self._texOpaqueBatch = display.newBatchNode(res.textureOpaquePack_png)
    local blendFunc = ccBlendFunc:new()                                                                          
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    self._texOpaqueBatch:setBlendFunc(blendFunc)
    self:addChild(self._texOpaqueBatch)
    
    -- TransparentBatch
    self._texTransparentBatch = display.newBatchNode(res.textureTransparentPack_png)
    self:addChild(self._texTransparentBatch)
    
    self._levelManager = LevelManager.new(self)

    self.screenRect = cc.rect(0, 0, display.width, display.height + 10)

    -- score
    self.lbScore = cc.LabelBMFont:create("Score: 0", res.arial_14_fnt)
    self.lbScore:setAnchorPoint(1, 0)
    self.lbScore:setAlignment(ui.TEXT_ALIGN_RIGHT)
    self:addChild(self.lbScore, 1000)
    self.lbScore:setPosition(display.width - 5, display.height - 30)

    -- ship life
    local life = display.newSprite("#ship01.png")
    life:setScale(0.6)
    life:setPosition(30, display.height - 22)
    self._texTransparentBatch:addChild(life, 1, 5)

    -- ship Life count
    self._lbLife = cc.LabelTTF:create("0", "Arial", 20)
    self._lbLife:setPosition(60, display.height - 22)
    self._lbLife:setColor(cc.c3b(255, 0, 0))
    self:addChild(self._lbLife, 1000)

    -- ship
    self._ship = Ship.new()
    self._texTransparentBatch:addChild(self._ship, self._ship.zOrder, MW.UNIT_TAG.PLAYER)

    -- explosion batch node    
    self._explosions = display.newBatchNode(res.explosion_png)
    local blendFunc = ccBlendFunc:new()                                                                          
    blendFunc.src = GL_SRC_ALPHA                                                                                       
    blendFunc.dst = GL_ONE
    self._explosions:setBlendFunc(blendFunc)
    self:addChild(self._explosions)
    Explosion.sharedExplosion()

    -- accept touch now!

--    if (sys.capabilities.hasOwnProperty('keyboard')) then
--        self:setKeyboardEnabled(true)
--    end

--    if (sys.capabilities.hasOwnProperty('mouse')) then
--        -- if ('mouse' in sys.capabilities)
--        self:setMouseEnabled(true)
--    end

--    if (sys.capabilities.hasOwnProperty('touches')) then
--        -- if ('touches' in sys.capabilities)
--        self:setTouchEnabled(true)
--    end

    -- schedule
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.update))
    self:scheduleUpdate()
    self:schedule(handler(self, self.scoreCounter), 1)

    if (MW.SOUND) then
        audio.playMusic(res.bgMusic_mp3, true)
    end

    bRet = true

    g_sharedGameLayer = self

    -- pre set
    Bullet.preSet()
    Enemy.preSet()
    HitEffect.preSet()
    SparkEffect.preSet()
    Explosion.preSet()
    BackSky.preSet()
    BackTileMap.preSet()

    self:initBackground()
    
    -- "Main Menu"菜单按钮
    local sysMenu = ui.newTTFLabelMenuItem({  
        text = "Main Menu",
        font = "Arial",
        size = 18,
        listener = handler(self, self.onSysMenu)
    })
    
    local menu = ui.newMenu({sysMenu})
    menu:setPosition(0, 0)
    sysMenu:setAnchorPoint(0, 0)
    sysMenu:setPosition(display.width-95, 5)
    self:addChild(menu, 1, 2)
    
    return bRet
end

function MainScene:onSysMenu(pSender)
    app:enterScene("SysMenuScene", nil, "fade", 1.2)
end

function MainScene:scoreCounter()
    if self._state == STATE_PLAYING then
        self._time = self._time + 1
        self._levelManager:loadLevelResource(self._time)
    end
end

function MainScene:onTouchesMoved(touches, event)
    self:processEvent(touches[0])
end

function MainScene:onMouseDragged(event)
    self:processEvent(event)
end

function MainScene:onTouch(event)
    if (event.name == "moved" or event.name == "dragged") then
        if self._state == STATE_PLAYING then
            local delta = cc.PointSub(cc.p(event.x, event.y), cc.p(event.prevX, event.prevY)) 
            local x, y = self._ship:getPosition()
            local curPos = cc.p(x, y)
            curPos = cc.PointAdd(curPos, delta)
            curPos = cc.PointClamp(curPos, cc.p(0, 0), cc.p(display.width, display.height))
            self._ship:setPosition(curPos)
        end
    end
    return true
end

function MainScene:onKeyDown(e)
    MW.KEYS[e] = true
end

function MainScene:onKeyUp(e)
    MW.KEYS[e] = false
end

function MainScene:update(dt)
    if (self._state == STATE_PLAYING) then
        self:checkIsCollide()
        self:removeInactiveUnit(dt)
        self:checkIsReborn()
        self:updateUI()
        self:_movingBackground(dt)
    end
end

-- 检测是否碰撞
function MainScene:checkIsCollide()
    local selChild, bulletChild
    -- check collide
    local locShip = self._ship
    for i = 1, #MW.CONTAINER.ENEMIES do
        selChild = MW.CONTAINER.ENEMIES[i]
        if selChild.active then
            for j = 1, #MW.CONTAINER.PLAYER_BULLETS do
                bulletChild = MW.CONTAINER.PLAYER_BULLETS[j]
                if (bulletChild.active and self:collide(selChild, bulletChild)) then
                    bulletChild:hurt()
                    selChild:hurt()
                end
            end
            if (self:collide(selChild, locShip)) then
                if (locShip.active) then
                    selChild:hurt()
                    locShip:hurt()
                end
            end
        end
    end

    for i = 1, #MW.CONTAINER.ENEMY_BULLETS do
        selChild = MW.CONTAINER.ENEMY_BULLETS[i]
        if (selChild.active and self:collide(selChild, locShip)) then
            if (locShip.active) then
                selChild:hurt()
                locShip:hurt()
            end
        end
    end
end

-- 移除不活动个体
function MainScene:removeInactiveUnit(dt)
    local selChild
    local children = self._texOpaqueBatch:getChildren()
    for i = 0, children:count()-1 do
        selChild = children:objectAtIndex(i)
        if (selChild and selChild.active) then
            selChild:update(dt)
        end
    end

    children = self._texTransparentBatch:getChildren()
    for i = 0, children:count()-1 do
        selChild = children:objectAtIndex(i)
        if (selChild and selChild.active) then
            selChild:update(dt)
        end
    end
end

function MainScene:checkIsReborn()
    local locShip = self._ship
    if (MW.LIFE > 0 and (not locShip.active)) then
        locShip:born()
    elseif (MW.LIFE <= 0 and (not locShip.active)) then
        self._state = STATE_GAMEOVER
        -- XXX: needed for JS bindings.
        self._ship = nil
        local array  = CCArray:create()
        array:addObject(cc.DelayTime:create(0.2))
        array:addObject(cc.CallFuncN:create(handler(self, self.onGameOver)))
        self:runAction(cc.Sequence:create(array))
    end
end

function MainScene:updateUI()
    if (self._tmpScore < MW.SCORE) then
        self._tmpScore = self._tmpScore + 1
    end
    self._lbLife:setString(MW.LIFE .. '')
    self.lbScore:setString("Score: " .. self._tmpScore)
end

function MainScene:collide(a, b)
    local x1, y1 = a:getPosition()
    local x2, y2 = b:getPosition()
    if (math.abs(x1 - x2) > MAX_CONTAINT_WIDTH or math.abs(y1 - y2) > MAX_CONTAINT_HEIGHT) then
        return false
    end

    local aRect = a:collideRect(x1, y1)
    local bRect = b:collideRect(x2, y2)
    return cc.rectIntersectsRect(aRect, bRect)
end

function MainScene:initBackground()
    self._backSky = BackSky.getOrCreate()
    self._backSkyHeight = self._backSky:getContentSize().height;

    self:moveTileMap()
    self:schedule(handler(self, self.moveTileMap), 5)
end

function MainScene:moveTileMap()
    local backTileMap = BackTileMap.getOrCreate()
    local ran = math.random()
    backTileMap:setPosition(ran * 320, display.height)
    local move = cc.MoveBy:create(ran * 2 + 10, cc.p(0, -display.height-240))
    local fun = cc.CallFunc:create(function()
        backTileMap:destroy()
    end)
    local array  = CCArray:create()
    array:addObject(move)
    array:addObject(fun)
    backTileMap:runAction(cc.Sequence:create(array))
end

function MainScene:_movingBackground(dt)
    local movingDist = 16 * dt       -- background's moving rate is 16 pixel per second

    local locSkyHeight = self._backSkyHeight 
    local locBackSky = self._backSky
    local currPosY = locBackSky:getPositionY() - movingDist
    local locBackSkyRe = self._backSkyRe

    if (locSkyHeight + currPosY <= display.height) then
        if (locBackSkyRe ~= nil) then
            error("The memory is leaking at moving background")
        end
        
        locBackSkyRe = self._backSky
        self._backSkyRe = self._backSky

        -- create a new background
        self._backSky = BackSky.getOrCreate()
        locBackSky = self._backSky
        locBackSky:setPositionY(currPosY + locSkyHeight - 2)
    else
        locBackSky:setPositionY(currPosY)

        if (locBackSkyRe) then
            -- locBackSkyRe
            currPosY = locBackSkyRe:getPositionY() - movingDist
            if (currPosY + locSkyHeight < 0) then
                locBackSkyRe:destroy()
                self._backSkyRe = nil
            else
                locBackSkyRe:setPositionY(currPosY)
            end
        end
    end
end

function MainScene:onGameOver()
    app:enterScene("GameOverScene", nil, "fade", 1.2)
end

function MainScene:addEnemy(enemy, z, tag)
    self._texTransparentBatch:addChild(enemy, z, tag)
end

function MainScene:addExplosions(explosion)
    self._explosions:addChild(explosion)
end

function MainScene:addBulletHits(hit, zOrder)
    self._texOpaqueBatch:addChild(hit, zOrder)
end

function MainScene:addSpark(spark)
    self._texOpaqueBatch:addChild(spark)
end

function MainScene:addBullet(bullet, zOrder, mode)
    self._texOpaqueBatch:addChild(bullet, zOrder, mode)
end
    
return MainScene
