function notify(msg)
    turtle.select(4)
    turtle.equipRight()
    modem = peripheral.wrap("right")
    modem.open(2137)
    modem.transmit(2137, 2137, msg)
    turtle.select(4)
    turtle.equipRight()
end

function setUpMiner()
    turtle.select(1)
    turtle.placeUp()
    turtle.turnRight()
    turtle.forward()
    turtle.forward()
    turtle.select(2)
    turtle.placeUp()
    turtle.back()
    turtle.back()
    turtle.back()
    turtle.back()
    turtle.select(3)
    turtle.placeUp()
    turtle.forward()
    turtle.forward()
    turtle.turnLeft()
    miner = peripheral.wrap("top")
    return miner
end

function dissasembleMiner()
    turtle.digUp()
    turtle.turnRight()
    turtle.forward()
    turtle.forward()
    turtle.digUp()
    turtle.back()
    turtle.back()
    turtle.back()
    turtle.back()
    turtle.digUp()
    turtle.forward()
    turtle.forward()
    turtle.turnLeft()
    turtle.select(5)
    turtle.transferTo(1)
    turtle.select(6)
    turtle.transferTo(2)
    turtle.select(7)
    turtle.transferTo(3)
end


function removeFilters(miner)
    for _, filter in ipairs(miner.getFilters()) do
        miner.removeFilter(filter)
    end
end

function setFilter(miner, setTag)
    filter = {
        enabled = true,
        replaceTarget = "minecraft:air",
        requiresReplacement = false,
        tag = setTag,
        type = "MINER_TAG_FILTER"
    }
    miner.addFilter(filter)
end

function fwrd()
    if turtle.detect() then
        turtle.dig()
        turtle.select(5)
        turtle.dropUp()
    end
    turtle.forward()
end

mined = 0
tag = arg[1]
toMine = tonumber(arg[2])
movedTimes = 0
notify("miner started, mining " .. toMine .. " " .. tag)

while mined < toMine do
    notify("Moving forward " .. movedTimes + 1 .. " time")
    for _ = 1, 64 do
        fwrd()
    end
    movedTimes = movedTimes + 1
    minerInstance = setUpMiner()
    removeFilters(minerInstance)
    setFilter(minerInstance, tag)
    minerInstance.start()
    leftToMine = minerInstance.getToMine()
    mined = mined + minerInstance.getToMine()
    notify("Found " .. leftToMine .. " " .. tag .. " here")
    while leftToMine > 0 do
        sleep(1)
        leftToMine = minerInstance.getToMine()
    end
    notify("Mined " .. mined .. " in total")
    dissasembleMiner()
end

notify("Mined " .. mined .. " in total, returning to the starting location")

turtle.turnLeft()
turtle.turnLeft()
for _ = 1, 64 * movedTimes do
    fwrd()
end

notify("returned, program end")
