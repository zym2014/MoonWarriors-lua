require("config.Level")
local Enemy = require("Enemy")
local EnemyType = require("config.EnemyType")

-- 等级管理器
local LevelManager = class("LevelManager")

-- 构造函数
function LevelManager:ctor(gameLayer)
    if not gameLayer then
        print("gameLayer must be non-nil")
        return
    end
    
    self._gameLayer = gameLayer
    self:setLevel(Level1)
end

-- 设置等级
function LevelManager:setLevel(level)
    local enemies = level.enemies
    for i = 1, #level.enemies do
        enemies[i].ShowTime = self:_minuteToSecond(enemies[i].ShowTime)
    end
    self._currentLevel = level
end

-- 分转换为秒
function LevelManager:_minuteToSecond(minuteStr)
    if not minuteStr then
        return 0
    end
    
    if (type(minuteStr) ~= "number") then
        local mins = minuteStr:split(':')
        if (#mins == 1) then
            return tonumber(mins[1])
        else
            return tonumber(mins[1])* 60 + tonumber(mins[2])
        end
    else
        return minuteStr
    end
end
    
function LevelManager:loadLevelResource(deltaTime)
    if (MW.ACTIVE_ENEMIES >= self._currentLevel.enemyMax) then
        return
    end
    
    -- load enemy
    local locCurrentLevel = self._currentLevel
    for i = 1, #locCurrentLevel.enemies do
        local selEnemy = locCurrentLevel.enemies[i]
        if selEnemy then
            if selEnemy.ShowType == "Once" then
                if selEnemy.ShowTime == deltaTime then
                    for tIndex = 1, #selEnemy.Types do
                        self:addEnemyToGameLayer(selEnemy.Types[tIndex])
                    end
                end
            elseif selEnemy.ShowType == "Repeate" then
                if deltaTime % selEnemy.ShowTime == 0 then
                    for rIndex = 1, #selEnemy.Types do
                        self:addEnemyToGameLayer(selEnemy.Types[rIndex])
                    end
                end
            end
        end
    end
end

function LevelManager:addEnemyToGameLayer(enemyType)
    local addEnemy = Enemy.getOrCreateEnemy(EnemyType[enemyType+1])
    local enemypos = cc.p( 80 + (display.width - 160) * math.random(), display.height)
    local enemycs =  addEnemy:getContentSize()
    addEnemy:setPosition( enemypos )

    local x, y
    local offset, tmpAction
    local a0 = 0
    local a1 = 0
    if addEnemy.moveType == MW.ENEMY_MOVE_TYPE.ATTACK then
        x, y = self._gameLayer._ship:getPosition()
        tmpAction = cc.MoveTo:create(1, cc.p(x, y))
    elseif addEnemy.moveType == MW.ENEMY_MOVE_TYPE.VERTICAL then
        offset = cc.p(0, -display.height - enemycs.height)
        tmpAction = cc.MoveBy:create(4, offset)
    elseif addEnemy.moveType == MW.ENEMY_MOVE_TYPE.HORIZONTAL then
        offset = cc.p(0, -100 - 200 * math.random())
        a0 = cc.MoveBy:create(0.5, offset)
        a1 = cc.MoveBy:create(1, cc.p(-50 - 100 * math.random(), 0))
        local onComplete = cc.CallFuncN:create(function (pSender) 
            local a2 = cc.DelayTime:create(1)
            local a3 = cc.MoveBy:create(1, cc.p(100 + 100 * math.random(), 0))
            local array  = CCArray:create()
            array:addObject(a2)
            array:addObject(a3)
            -- array:addObject(a2:clone())
            array:addObject(clone(a2))
            array:addObject(a3:reverse())
            pSender:runAction(cc.RepeatForever:create(
                cc.Sequence:create(array)
            ))
        end)
        local array = CCArray:create()
        array:addObject(a0)
        array:addObject(a1)
        array:addObject(onComplete)
        tmpAction = cc.Sequence:create(array)
    elseif addEnemy.moveType == MW.ENEMY_MOVE_TYPE.OVERLAP then
        local newX = ((enemypos.x <= display.width / 2) and 320) or -320
        a0 = cc.MoveBy:create(4, cc.p(newX, -240))
        a1 = cc.MoveBy:create(4,cc.p(-newX,-320))
        local array = CCArray:create()
        array:addObject(a0)
        array:addObject(a1)
        tmpAction = cc.Sequence:create(array)
    end

    addEnemy:runAction(tmpAction)
end

return LevelManager