--[[
    常用方法工具
]]

Util = {}

local this = Util

 --[[
    因为Lua表中赋值操作是引用，没有深拷贝，需要自己实现一个深拷贝
    @param: src 拷贝源表
    @param: dest 拷贝目标表
]]
function this.Clone( src, dest )
    for k,v in pairs(src) do
        if type(v) == 'table' then
            dest[k] = {}
            this.Clone(v, dest[k])
        else
            dest[k] = v
        end
    end
end