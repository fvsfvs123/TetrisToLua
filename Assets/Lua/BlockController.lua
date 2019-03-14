--[[
    Block Controller
]]
require("BlockConfig")
require("Util")

BlockController = {}

local this = BlockController

local winScore = 1000               -- 胜利分数
local fallSpeed = 1                 -- 下落速度
local duration = 0.0                -- 自动下落时间间隔
local maxDuration = 0.4             -- 自动下落最大时间间隔
local score = 0                     -- 分数


function this.Start()
    this.InitBoard()

    currentBlock = {['mainIndex'] = 1, ['subIndex'] = 1, ['curRow'] = 1, ['curColumn'] = 1, ['block']={}}
    nextBlock = {['mainIndex'] = 1, ['subIndex'] = 1}

    
    this.RandomBlock(false)
    this.NewBlock()
    this.RandomBlock(false)
end


function this.Update()
    if GameMode.CheckGameOver() then
        return 
    end

    duration = duration - Time.deltaTime
    if duration <= 0.0 then
        this.Fall()
        duration = maxDuration
    end

end

--[[
    方块下落
]]
function this.Fall()
    local row = currentBlock['curRow']  + fallSpeed

    -- 已经落底 检查是否可以消除
    if this.CheckGround(row, currentBlock['curColumn']) then        
        this.InsetBoard()

        len =  this.RefreshBoard()

        -- 分数增加
        if len >= 1 and len <= #ScoreList then
            score = score + ScoreList[len]

            if score >= winScore then
                this.GameOver()
            end
            
            HUD.RefreshScore(score)
            print('score: '..score )
        end
        
        -- 渲染主面板
        BlockRenderer.RendererBoard()

        -- 更新当前和下一个俄罗斯方块
        this.NewBlock()
        this.RandomBlock(true)

    else -- 不落底，当前俄罗斯方块的所在行数增加
        currentBlock['curRow'] = row
    end
end

--[[
    把下落方块数据插入进主面板
]]
function this.InsetBoard()
    local row = currentBlock['curRow']
    local column = currentBlock['curColumn']
    local block = currentBlock['block']

    -- 触顶，游戏结束
    if row < 1 then
        this.GameOver()
    end

    for i=1,#block do
        for j=1,#block[i] do
            if block[i][j] == 1 then
                board[row + i][column + j] = 1
            end
        end
    end

    -- 清空当前俄罗斯方块数据
    currentBlock = {['mainIndex'] = 1, ['subIndex'] = 1, ['curRow'] = 1, ['curColumn'] = 1, ['block']={}}
end

--[[
    左右平移
    @param: left--true 向左平移; false 向右平移
]]
function this.HorizontalMove( left )
    -- 检查左右是否有障碍或者墙壁
    if this.CheckWall(left) then
        return 
    end

    if left==true then
        currentBlock['curColumn'] = currentBlock['curColumn'] -1
    else
        currentBlock['curColumn'] = currentBlock['curColumn'] +1
    end
end

--[[
    检查触及地面
    @param: row 即将下落的行
    @param: column 当前方块所在列
    return： true 下面有障碍; false 下面无障碍
]]
function this.CheckGround(row, column)
    local block = currentBlock['block']

    -- 遍历查询方块数据的下面是否有障碍或者到底了
    for i=#block, 1, -1 do
        for j=1,#block[i] do
            if block[i][j] == 1 then
                -- 触底
                if row + i-1 >= BoardHeight then  
                    return true
                end

                -- 下方有方块
                if row +i >= 1 then
                    if board[row + i][column + j] == 1 then
                        return true
                    end
                end

            end
        end
    end

    return false
end

--[[
    检查是否碰触到墙壁
]]
function this.CheckWall(left)
    local block = currentBlock['block']
    local min = 5 
    local max = 0

    -- 拿到当前俄罗斯方块最左和最右的那个方块
    for i=1, #block do
        for j=1,#block[i] do
            if block[i][j] == 1 then
                if j < min then
                    min = j
                end

                if j > max then 
                    max = j
                end
            end
        end
    end

    local curRow = currentBlock['curRow']
    local curColumn = currentBlock['curColumn']
    if left==true then --left border
        local col = curColumn + min
        -- 左边界
        if col <= 1 then 
            return true
        else
            -- 左边是否有障碍
            for i=1, #block do
                for j=1,#block[i] do
                    if curRow +i >= 1 then
                        if block[i][j] == 1 and board[curRow + i][curColumn+j-1] == 1 then
                            return true
                        end
                    end
                end
            end
            
        end
    else -- right border
        local col = curColumn + max
        -- 右边界
        if col >= BoardWidth then 
            return true
        else
            -- 右边是否有障碍
            for i=1, #block do
                for j=1,#block[i] do
                    if curRow +i >= 1 then
                        if block[i][j] == 1 and board[curRow + i][curColumn+j+1] == 1 then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

--[[
    有方块插入，刷新主面板操作
    return：消除的行数
]]
function this.RefreshBoard()
    local eliminate = {}
    for i=BoardHeight,1, -1 do
        sum = 0
        for j= 1, BoardWidth do 
            sum = sum +board[i][j]
        end

        -- 如果和跟宽度一样，说明此行每列都填满了方块
        if sum == BoardWidth then
            table.insert( eliminate, i )
        end
    end

    -- 清除已经满了的行
    local len = #eliminate

    -- PS：这儿是从最底下开始清除，这样第二次清除的时候，第二次清除的那一行又变成了第一行
    if len > 0 then
        for i=1, len do
            for j= eliminate[i] + (i-1), 2, -1 do
                Util.Clone(board[j-1], board[j])
            end 
            for j = 1, #board[1] do
                board[1][j] = 0
            end
        end
    end

    return len
end

--[[
    初始化主面板
]]
function this.InitBoard()
    for i=1,BoardHeight do
        board[i] = {}
        for j=1,BoardWidth do
            board[i][j] = 0
        end
    end
end

--[[
    把下一个俄罗斯方块赋值给当前俄罗斯方块
]]
function this.NewBlock()
    currentBlock['mainIndex'] = nextBlock['mainIndex'] 
    currentBlock['subIndex'] = nextBlock['subIndex']
    currentBlock['curRow'] = -3 
    currentBlock['curColumn'] = BoardWidth /2 - 1

    Util.Clone(BlockList[nextBlock['mainIndex']][currentBlock['subIndex']], currentBlock['block'])

    nextBlock['mainIndex']  = 0 
    nextBlock['subIndex'] = 0
end

--[[
    随机下一个俄罗斯方块
]]
function this.RandomBlock(isRender)
    math.randomseed(os.time())
    nextBlock['mainIndex'] = math.random(#BlockList)
    nextBlock['subIndex'] = math.random( #BlockList[nextBlock['mainIndex'] ] )

    if isRender then
        BlockRenderer.RendererNextBlock()
    end
end

--[[
    旋转方块
]]
function this.RotateBlock(  )
    local idx = currentBlock['mainIndex']
    local idx1 = currentBlock['subIndex']
    local len = #BlockList[idx]

    if len == 1 then
        return 
    end

    if idx1 == len then
        idx1 = 1
    else
        idx1 = idx1 + 1
    end

    if this.CanRotateBlock(currentBlock['curRow'], currentBlock['curColumn'], idx, idx1) == true then
        currentBlock['subIndex'] = idx1
        currentBlock['block'] = {}
        Util.Clone(BlockList[idx][idx1], currentBlock['block'])
    end
    
end

--[[
    是否能旋转方块
    旋转后超出边界，这个时候不能旋转
    
    @param: row 当前方块所在行
    @param: column 当前方块所在列
    @param: mainIndex 旋转后方块在方块表中的形状位置
    @param: subIndex 旋转后方块在形状表中的位置
    return： true 可以旋转; false 不能旋转
]]
function this.CanRotateBlock(row, column, mainIndex, subIndex)
    local block = BlockList[mainIndex][subIndex]

    -- 遍历上下左右是否出边界或者有障碍
    for i=1,#block do
        for j=1,#block[i] do
            if block[i][j] == 1 then
                local newRow = row + i
                local newCol = column + j
                if newCol < 1 or newCol > BoardWidth  then
                    return false
                elseif newRow < 1 or newRow > BoardHeight then
                    return false
                elseif  board[newRow][newCol] == 1 then 
                    return false
                end
            end
        end
    end

    return true
end

--[[
    打印主面板，调试用
]]
function this.PrintBoard()
    for i=1,BoardHeight do
        str = string.format( "%2d|%s", i, table.concat( board[i], ', ' ) )
        print(str)
    end
end

--[[
    游戏结束
]]
function this.GameOver()
    GameMode.GameOver()
    HUD.GameOver()
end

--this.InitBoard()
--this.PrintBoard()
