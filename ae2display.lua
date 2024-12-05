bridge = peripheral.wrap("left")
monitor = peripheral.wrap("monitor_2")
env = peripheral.wrap("environmentDetector_0")

local function shortenNumber(number)
    if number >= 1e18 then
        return string.format("%.1f Quintillion", number / 1e18)  -- Quintillions
    elseif number >= 1e15 then
        return string.format("%.1f Quadrillion", number / 1e15)  -- Quadrillions
    elseif number >= 1e12 then
        return string.format("%.1f Trillion", number / 1e12)  -- Trillions
    elseif number >= 1e9 then
        return string.format("%.1f Billion", number / 1e9)   -- Billions
    elseif number >= 1e6 then
        return string.format("%.1f Million", number / 1e6)   -- Millions
    elseif number >= 1e3 then
        return string.format("%.1f Thousand", number / 1e3)   -- Thousands
    else
        return tostring(number)
    end
end

function centerText(mon, text)
    x,y = mon.getSize()
    x1,y1 = mon.getCursorPos()
    mon.setCursorPos((math.floor(x/2) - (math.floor(#text/2))), y1)
    mon.write(text)
end

function formatTime(time)
    time = time + 6000
    if time > 24000 then
        time = time - 24000
    end
    hours = math.floor(time / 1000)
    minutes = math.floor((time % 1000) * 60 / 1000)

    return string.format("%02d:%02d", hours, minutes)
end

while true do
    total = bridge.getTotalItemStorage()
    used = bridge.getUsedItemStorage()
    percentage = math.ceil(used/total*100)
    total = shortenNumber(total)
    used = shortenNumber(used)
    energy = shortenNumber(bridge.getEnergyUsage()*2)
    monitor.setTextScale(1)
    monitor.clear()
    monitor.setCursorPos(1,1)
    centerText(monitor, "Hello user1! current time is " .. formatTime(env.getTime()%24000))
    monitor.setCursorPos(1,2)
    centerText(monitor, "Your AE2 storage capacity")
    monitor.setCursorPos(1,3)
    centerText(monitor, used .. " / " .. total .. " items")
    monitor.setCursorPos(1, 4)
    centerText(monitor, string.rep("#", math.ceil(percentage/2)) .. string.rep("-", math.floor((100-percentage)/2)) .. " " .. percentage .. "%")
    monitor.setCursorPos(1, 5)
    centerText(monitor, "Energy usage is " .. energy .. " FE/t")
    sleep(0.66)
end
