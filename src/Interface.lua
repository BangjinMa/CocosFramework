local Interface = class("Interface")

require("framework.FrameworkInit")

Interface.SCENETYPE = {
    LOBBYSCENE = 1,
}

function Interface:reLoadCommonMode()
    package.loaded["games.init"] = nil
    require("games.init")
end

function Interface.startScene(SceneType , data)
    -- Interface.reLoadCommonMode()
    if(SceneType == Interface.SCENETYPE.LOBBYSCENE)then 
        local mainScene = require("MainScene").new()
        display.runScene(mainScene)
    end
end

return Interface