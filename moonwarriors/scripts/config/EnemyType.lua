-- 敌人类型
local EnemyType = {
    {
        type = 0,                               -- 类型ID
        textureName = "E0.png",                 -- 战机图片
        bulletType = "W2.png",                  -- 子弹图片
        HP = 1,                                 -- 生命值
        moveType = MW.ENEMY_MOVE_TYPE.ATTACK,   -- 移动类型(ATTACK、VERTICAL、HORIZONTAL、OVERLAP)(攻击、垂直、水平、重叠)
        attackMode = MW.ENEMY_MOVE_TYPE.NORMAL, -- 攻击模式(NORMAL、TSUIHIKIDAN)
        scoreValue = 15                         -- 成绩值
    },
    {
        type = 1,
        textureName = "E1.png",
        bulletType = "W2.png",
        HP = 2,
        moveType = MW.ENEMY_MOVE_TYPE.ATTACK,
        attackMode = MW.ENEMY_MOVE_TYPE.NORMAL,
        scoreValue = 40
    },
    {
        type = 2,
        textureName = "E2.png",
        bulletType = "W2.png",
        HP = 4,
        moveType = MW.ENEMY_MOVE_TYPE.HORIZONTAL,
        attackMode = MW.ENEMY_ATTACK_MODE.TSUIHIKIDAN,
        scoreValue = 60
    },
    {
        type = 3,
        textureName = "E3.png",
        bulletType = "W2.png",
        HP = 6,
        moveType = MW.ENEMY_MOVE_TYPE.OVERLAP,
        attackMode = MW.ENEMY_MOVE_TYPE.NORMAL,
        scoreValue = 80
    },
    {
        type = 4,
        textureName = "E4.png",
        bulletType = "W2.png",
        HP = 10,
        moveType = MW.ENEMY_MOVE_TYPE.HORIZONTAL,
        attackMode = MW.ENEMY_ATTACK_MODE.TSUIHIKIDAN,
        scoreValue = 150
    },
    {
        type = 5,
        textureName = "E5.png",
        bulletType = "W2.png",
        HP = 15,
        moveType = MW.ENEMY_MOVE_TYPE.HORIZONTAL,
        attackMode = MW.ENEMY_MOVE_TYPE.NORMAL,
        scoreValue = 200
    }
}

return EnemyType