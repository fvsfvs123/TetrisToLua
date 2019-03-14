--[[
    渲染
]]
require("BlockConfig")
BlockRenderer = {}

local this = BlockRenderer

local blockPrefab           -- 俄罗斯方块预制体
local boardPanel            -- 显示俄罗斯方块的主面板
local nextPanel             -- 显示下一个俄罗斯方块的面板

local boardObjs = {}        -- 主面板方块对象池
local currentObjs = {}      -- 当前俄罗斯方块对象池
local nextObjs = {}         -- 下一个俄罗斯方块对象池

local lastCount = 0

function this.Start()
    blockPrefab = Resources.Load('Prefabs/Block')
    boardPanel = GameObject.Find('Root/Board')
    nextPanel = GameObject.Find('Root/Next')

    -- 初始化主面板方块对象池
    for i=1,BoardHeight do
        for j=1,BoardWidth do
            local newBlock = GameObject.Instantiate(blockPrefab)
            newBlock.name = 'Board'..tostring(i)..'_'..tostring(j)
            newBlock.transform: SetParent(boardPanel.transform)
            newBlock:GetComponent('RectTransform').anchoredPosition3D = Vector3(-10000, -10000, 0)
            table.insert( boardObjs, newBlock )
        end
    end

    -- 初始化当前俄罗斯方块对象池
    for i=1,4 do
        local newBlock = GameObject.Instantiate(blockPrefab)
        newBlock.name = 'Current'..tostring(i)
        newBlock.transform: SetParent(boardPanel.transform)
        newBlock:GetComponent('RectTransform').anchoredPosition3D = Vector3(-10000, -10000, 0)
        table.insert( currentObjs, newBlock )
    end

    -- 初始化下一个俄罗斯方块对象池
    for i=1,4 do
        local newBlock = GameObject.Instantiate(blockPrefab)
        newBlock.name = 'Next'..tostring(i)
        newBlock.transform: SetParent(nextPanel.transform)
        newBlock:GetComponent('RectTransform').anchoredPosition3D = Vector3(-10000, -10000, 0)

        -- 颜色更改为红色
        -- PS：GetComponentInChildren没有GetComponent可以传入字符串，参数必须传入类型，不然报错 
        newBlock:GetComponentInChildren(typeof(Image)).color = Color(1.0, 0.1, 0.1)
        table.insert( nextObjs, newBlock )
    end

    -- 渲染下一个俄罗斯方块
    this.RendererNextBlock()
end


function this.Update()
    
    --this.RendererBoard()
    this.RendererCurrentBlock()
    --this.RendererNextBlock()
end

--[[
    渲染主面板
]] 
function this.RendererBoard()
    local count = 1
    for i=1,BoardHeight do
        for j=1,BoardWidth do
            if board[i][j] == 1 then
                boardObjs[count]:GetComponent('RectTransform').anchoredPosition3D = Vector3((j- 1) * 50, (i -1) * -50, 0)
                count  = count +1
            end
        end
    end

    if count < lastCount then
        for i=count, lastCount do
            boardObjs[i]:GetComponent('RectTransform').anchoredPosition3D = Vector3(-10000, -10000, 0)
        end
    end

    lastCount = count
end


--[[
    渲染当前俄罗斯方块
]] 
function this.RendererCurrentBlock()
    local row = currentBlock['curRow']
    local column = currentBlock['curColumn']
    local block = currentBlock['block']

    local count = 1

    for i=1,#block do
        for j=1,#block[i] do
            if row + i >= 1 then
                if block[i][j] == 1 then
                    currentObjs[count]:GetComponent('RectTransform').anchoredPosition3D = Vector3((column + j- 1) * 50, (row + i -1) * -50, 0)
                    count  = count +1
                end
            end
        end
    end

end


--[[
    渲染下一个俄罗斯方块
]] 
function this.RendererNextBlock()
    local block = BlockList[nextBlock['mainIndex']][nextBlock['subIndex']]

    local count = 1

    for i=1,#block do
        for j=1,#block[i] do
            if block[i][j] == 1 then
                nextObjs[count]:GetComponent('RectTransform').anchoredPosition3D = Vector3((j- 1) * 50, (i -1) * -50, 0)
                count  = count +1
            end
        end
    end

end