
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- display FPS stats on screen
DEBUG_FPS = true

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "portrait"

-- design resolution
CONFIG_SCREEN_WIDTH  = 320
CONFIG_SCREEN_HEIGHT = 480

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

-- 声音文件扩展名
SoundFileExtName = ".mp3" -- ".ogg"

res = {
    bgMusic_mp3 = "bgMusic" .. SoundFileExtName,
    buttonEffet_mp3 = "buttonEffet" .. SoundFileExtName,
    explodeEffect_mp3 = "explodeEffect" .. SoundFileExtName,
    fireEffect_mp3 = "fireEffect" .. SoundFileExtName,         -- unused
    mainMainMusic_mp3 = "mainMainMusic" .. SoundFileExtName,
    shipDestroyEffect_mp3 = "shipDestroyEffect" .. SoundFileExtName,
    arial_14_fnt = "arial-14.fnt",
    arial_14_png = "arial-14.png",
    b01_plist = "b01.plist",
    b01_png = "b01.png",
    cocos2d_html5_png = "cocos2d-html5.png",
    explode_plist = "explode.plist",              -- unused
    explosion_plist = "explosion.plist",
    explosion_png = "explosion.png",
    flare_jpg = "flare.jpg",
    gameOver_png = "gameOver.png",
    level01_tmx = "level01.tmx",
    loading_png = "loading.png",
    logo_png = "logo.png",
    menu_png = "menu.png",
    menuTitle_png = "menuTitle.png",
    textureOpaquePack_plist = "textureOpaquePack.plist",
    textureOpaquePack_png = "textureOpaquePack.png",
    textureTransparentPack_plist = "textureTransparentPack.plist",
    textureTransparentPack_png = "textureTransparentPack.png"
}
