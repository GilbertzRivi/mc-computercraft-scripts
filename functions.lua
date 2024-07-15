
local function isInteger(num)
    return type(num) == "number" and math.floor(num) == num
end

local function convertToInteger(input)
    local suffix = input:sub(#input, #input)
    local number = string.sub(input, 1, -2)
    number = string.gsub(number, ",", ".")
    number = tonumber(number)
    if isInteger(suffix) then
       return input:gsub(",", ".")
    end

    local multipliers = {
        K = 1e3,
        M = 1e6,
        G = 1e9,
        T = 1e12,
        P = 1e15,
        E = 1e18,
        Z = 1e21,
        Y = 1e24,
    }
    
    if suffix and multipliers[suffix] then
        number = number * multipliers[suffix]
    end

    return number
end

local function formatNumber(num)
    local suffixes = {"", "K", "M", "G", "T", "P", "E", "Z", "Y"}
    local suffix_index = 1

    while num >= 1000 and suffix_index < #suffixes do
        num = num / 1000
        suffix_index = suffix_index + 1
    end

    local formatted_num = string.format("%.2f", num)
    local length_with_suffix = #formatted_num + 1

    if length_with_suffix < 5 then
        formatted_num = string.format("%." .. (4 - #formatted_num) .. "f", num)
    elseif length_with_suffix > 5 then
        formatted_num = string.format("%.1f", num)
    end

    if num < 10 then
        formatted_num = string.format("%.3f", num)
        if #formatted_num > 5 then
            formatted_num = string.sub(formatted_num, 1, 5)
        end
        formatted_num = formatted_num:gsub(",", ".")
    elseif num < 100 then
        formatted_num = string.format("%.2f", num)
        if #formatted_num > 5 then
            formatted_num = string.sub(formatted_num, 1, 4)
        end
    else
        formatted_num = string.format("%.1f", num)
        if #formatted_num > 5 then
            formatted_num = string.sub(formatted_num, 1, 3)
        end
    end

    formatted_num = formatted_num:gsub("%.$", "")

    return formatted_num .. suffixes[suffix_index]
end

local function kelvinToCelsius(kelvin)
    return math.floor(kelvin - 273.15)
end

local function celsiusToKelvin(celsius)
    return math.floor(celsius + 273.15)
end

local function formatToThreeDigits(num)
    local formattedNum

    if num >= 10 then
        formattedNum = string.format("%.1f", num)
    elseif num >= 1 then
        formattedNum = string.format("%.2f", num)
    else
        formattedNum = string.format("%.3f", num)
    end

    if #formattedNum > 4 then
        formattedNum = formattedNum:sub(1, 4)
    end

    if formattedNum == "100." then
        return 100
    else
        return tonumber(formattedNum)
    end
end

local function calculateCenterX(parent, label)
    return math.ceil(((parent.getWidth()+1)/2) - ((string.len(label.getText())+1)/2)) + 1
end

local function isTablePopulated(table)
    for _ in pairs(table) do
        return true
    end
    return false
end

local function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

return {
    isInteger = isInteger,
    convertToInteger = convertToInteger,
    formatNumber = formatNumber,
    kelvinToCelsius = kelvinToCelsius,
    celsiusToKelvin = celsiusToKelvin,
    formatToThreeDigits = formatToThreeDigits,
    calculateCenterX = calculateCenterX,
    isTablePopulated = isTablePopulated,
    indexOf = indexOf
}