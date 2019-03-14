--[[
    HUD
]]
HUD ={}

local this = HUD
local scoreText
local gameOverObj

function this.Start(  )
    scoreText = GameObject.Find('Root/Score'):GetComponent('Text')
    gameOverObj = GameObject.Find('Root/GameOver')

    local restartBtn = gameOverObj.transform: Find('RestartBtn').gameObject
    UIEvent.AddButtonOnClick(restartBtn, RestartGame)           -- 绑定重启按钮的委托事件

    gameOverObj:SetActive(false)
    this.RefreshScore(0)
end

function this.Update(  )
    
end

--[[
    刷新分数
]]
function this.RefreshScore(score)
    scoreText.text = string.format('Score: %d', score)
end

--[[
    游戏结束
]]
function this.GameOver()
    gameOverObj:SetActive(true)
end

--[[
    重启游戏
]]
function RestartGame()
    SceneManagement.SceneManager.LoadScene('Game')
end