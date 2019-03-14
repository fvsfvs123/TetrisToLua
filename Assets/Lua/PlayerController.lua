--[[
    Player Controller
]]
PlayerController = {}

local this = PlayerController

local maxHorizontalDuration = 0.08      -- 左右移动最大间隔时间
local maxVerticalDuration = 0.02        -- 按下键最大间隔时间

local leftTime = 0.0
local rightTime = 0.0
local downTime = 0.0


function this.Start()
    leftTime = maxHorizontalDuration
    rightTime = maxHorizontalDuration
    downTime = maxVerticalDuration
end

function this.Update()
    if GameMode.CheckGameOver() then
        return 
    end

    leftTime = leftTime - Time.deltaTime
    rightTime = rightTime - Time.deltaTime
    downTime = downTime - Time.deltaTime

    -- 左移
    if Input.GetKey(KeyCode.A) or Input.GetKey(KeyCode.LeftArrow) then
        if leftTime <= 0.0 then
            BlockController.HorizontalMove(true)
            leftTime = maxHorizontalDuration
        end
    end

    -- 右移
    if Input.GetKey(KeyCode.D) or Input.GetKey(KeyCode.RightArrow) then
        if rightTime <= 0.0 then
            BlockController.HorizontalMove(false)
            rightTime = maxHorizontalDuration
        end
    end

    -- 快速下落
    if Input.GetKey(KeyCode.S) or Input.GetKey(KeyCode.DownArrow) then
        if downTime <= 0.0 then
            BlockController.Fall()
            downTime = maxVerticalDuration
        end
    end
    
    -- 改变形状
    if Input.GetKeyDown(KeyCode.W) or Input.GetKeyDown(KeyCode.UpArrow) then
        BlockController.RotateBlock()
        
    end
end