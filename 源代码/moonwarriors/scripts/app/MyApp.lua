
require("config")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    CCFileUtils:sharedFileUtils():addSearchPath("res/ImageRaw/")
    CCFileUtils:sharedFileUtils():addSearchPath("res/Music/")
    self:enterScene("SysMenuScene")
end

return MyApp
