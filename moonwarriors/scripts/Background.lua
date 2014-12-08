local BackSky = class("BackSky", function()
    return display.newSprite("#bg01.png")
end)

function BackSky:ctor()
    self.active = true
    self:setAnchorPoint(0, 0)
end

function BackSky:destroy()
    self:setVisible(false)
    self.active = false
end

function BackSky.create()
    local background = BackSky.new()
    g_sharedGameLayer:addChild(background, -10)
    table.insert(MW.CONTAINER.BACKSKYS, background)
    return background
end

function BackSky.getOrCreate()
    local selChild = nil
    for j = 1, #MW.CONTAINER.BACKSKYS do
        selChild = MW.CONTAINER.BACKSKYS[j]
        if (selChild.active == false) then
            selChild:setVisible(true)
            selChild.active = true
            return selChild
        end
    end
    selChild = BackSky.create()
    return selChild
end

function BackSky.preSet()
    local background = null
    for i = 1, 2 do
        background = BackSky.create()
        background:setVisible(false)
        background.active = false
    end
end

local BackTileMapLvl1 = {
    "lvl1_map1.png",
    "lvl1_map2.png",
    "lvl1_map3.png",
    "lvl1_map4.png"
}

local BackTileMap = class("BackTileMap", function()
    return display.newSprite()
end)

function BackTileMap:ctor(frameName)
    self.active = true
    self:setDisplayFrame(display.newSpriteFrame(frameName))
    self:setAnchorPoint(0.5, 0)
end

function BackTileMap:destroy()
    self:setVisible(false)
    self.active = false
end

function BackTileMap.create(frameName)
    local backTileMap = BackTileMap.new(frameName)
    g_sharedGameLayer:addChild(backTileMap, -9)
    table.insert(MW.CONTAINER.BACKTILEMAPS, backTileMap)
    return backTileMap
end

function BackTileMap.getOrCreate()
    local selChild = nil
    for j = 1, #MW.CONTAINER.BACKTILEMAPS do
        selChild = MW.CONTAINER.BACKTILEMAPS[j]
        if (selChild.active == false) then
            selChild:setVisible(true)
            selChild.active = true
            return selChild
        end
    end
    selChild = BackTileMap.create(BackTileMapLvl1[math.random()*4])
    return selChild
end

function BackTileMap.preSet()
    local backTileMap = nil
    for i = 1, #BackTileMapLvl1 do
        backTileMap = BackTileMap.create(BackTileMapLvl1[i])
        backTileMap:setVisible(false)
        backTileMap.active = false
    end
end

local Bg = {}
Bg.BackSky = BackSky
Bg.BackTileMap = BackTileMap
return Bg