local RichTextParser = class("RichTextParser")

-- RichTextParser is <font size='20' color='#ffffff'>good </font>RichText
-- 
--

-- local results={
--     [1] = {
--         strValue = "",
--         attribute = {
--             size = 20,
--             url = "",
--             color = "",
--         },
--         strValues = {},
--     }
-- }

local function getNilElement( )
    local element= {
            strValue = "",
            attributes = {},
            strValues = {},
        }
    return element
end

--[[
    color='#ffffff' 字体颜色
    size='20' 字体大小
    type='button' 目前只支持点击事件（button）
    fontPath='font\font.ttf' 字体目录
    id='1' 在type=button的时候被使用并在回调中当作参数
--]]
local parserRule = {
    color = " color='#(.-)'",
    size = " size='(.-)'",
    type = " type='(.-)'",
    fontPath = " fontPath='(.-)'",
    id = " id='(.-)'",
}

function RichTextParser:parser(strValue)
    local elements = {}
    if nil == strValue or string.len(strValue) == 0 then 
        table.insert( elements, getNilElement() ) 
        return elements
    end
    local _strValue = strValue

    while string.len(_strValue) > 0 do
        local _startBeginFont, _startEndFont = string.find(_strValue, "<font ", 1)
        local element = getNilElement()
        if _startBeginFont == 1 then

            local _, _attributEnd = string.find(_strValue, ">", 1)

            for key, value in pairs(parserRule) do 
                local start, _, _colorValue = string.find(_strValue, value)
                if nil ~= start and start < _attributEnd then 
                    element.attributes[key] =  _colorValue
                end
            end

            local _endBeginFont, _endEndFont = string.find(_strValue, "</font>", 1)
            element.strValue = string.sub(_strValue, _attributEnd + 1, _endBeginFont - 1)
            -- sub
            _strValue = string.sub(_strValue, _endEndFont + 1, -1)

        elseif nil == _startBeginFont then
            element.strValue = _strValue
            _strValue = ""
        else
            local strTemp = string.sub(_strValue, 1, _startBeginFont - 1)
            element.strValue = strTemp
            -- sub
            _strValue = string.sub(_strValue, _startBeginFont, -1)

        end
        table.insert( elements, element )
    end

    for _, element in pairs(elements) do
        local str = element.strValue
        local strs = {}
        while string.len(str) > 0 do
            local strTemp = "\n"
            if nil ~= string.find(str, "<br>", 1) then
                local _begin, _end = string.find(str, "<br>", 1)
                if _begin == 1 then
                    str = string.sub(str, _end + 1, -1)
                else
                    strTemp = string.sub(str, 1, _begin - 1)
                    str = string.sub(str, _begin, -1)
                end
            else
                strTemp = str
                str = ""
            end
            table.insert( strs, strTemp )
        end
        element.strValues = clone(strs)
    end

    return elements
end

return RichTextParser