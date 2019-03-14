--[[
    Game Mode
]]
GameMode = {}

local this = GameMode

local isEnd = false

function this.Start()
    isEnd = false
end

function this.Update()
end

--[[
    游戏结束
]]
function this.GameOver()
    isEnd = true
end

--[[
    查询游戏是否结束
]]
function this.CheckGameOver()
    return isEnd
end