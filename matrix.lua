local functions = require("functions")
local basalt = require("/basalt")

isInteger = functions.isInteger
convertToInteger = functions.convertToInteger
formatNumber = functions.formatNumber
kelvinToCelsius = functions.kelvinToCelsius
celsiusToKelvin = functions.celsiusToKelvin
formatToThreeDigits = functions.formatToThreeDigits
calculateCenterX = functions.calculateCenterX
isTablePopulated = functions.isTablePopulated
indexOf = functions.indexOf

inductionPort = peripheral.wrap("inductionPort_1")
monitor = peripheral.wrap("monitor_13")

function calculateFillTime(transferRate, capacity)
    local totalSeconds = capacity / transferRate / 20
    
    local minutes = math.floor(totalSeconds / 60)
    seconds = totalSeconds % 60

    local hours = math.floor(minutes / 60)
    minutes = minutes % 60

    local days = math.floor(hours / 24)
    hours = hours % 24

    return days, hours, minutes, seconds
end

local function getData(port)
    input = port.getLastInput()*0.4
    inputR = formatNumber(input)
    output = port.getLastOutput()*0.4
    outputR = formatNumber(output)
    transfer = input + output
    transferR = formatNumber(transfer)
    maxTransfer = port.getTransferCap()*0.4
    maxTransferR = formatNumber(maxTransfer)
    energy = port.getEnergy()*0.4
    energyR = formatNumber(energy)
    energyCapacity = port.getMaxEnergy()*0.4
    energyCapacityR = formatNumber(energyCapacity)
    energyPercentage = 0

    if energy ~= 0 then energyPercentage = formatToThreeDigits((energy/energyCapacity)*100) else energyPercentage = 0 end

    data = {
        raw = {
            input = input,
            output = output,
            transfer = transfer,
            maxTransfer = maxTransfer,
            energy = energy,
            energyCapacity = energyCapacity,
            energyPercentage = energyPercentage
        },
        formatted = {
            input = inputR,
            output = outputR,
            transfer = transferR,
            maxTransfer = maxTransferR,
            energy = energyR,
            energyCapacity = energyCapacityR,
            energyPercentage = energyPercentage
        }
    }

    return data

end

function screenBuilder(monitor)

    local screenElements = {}
    monitor.setTextScale(1)
    local monitorFrame = basalt.addMonitor():setMonitor(monitor)

    local frame = monitorFrame
        :addFrame()
        :setPosition(1,1)
        :setSize("parent.w", "parent.h")
        :setBackground(colors.gray)

    local FlexFrame = frame
        :addFrame()
        :setSize(24, "parent.h-2")
        :setPosition(2, 2)
        :setBackground(colors.cyan)
        :setBorder(colors.black)
        :setShadow(colors.gray)

    local Flex = FlexFrame
        :addFlexbox()
        :setWrap("wrap")
        :setPosition(2, 2)
        :setSize("parent.w - 2", "parent.h - 2")
        :setBackground(colors.cyan)
        :setForeground(colors.black)

    local StatusLabel = Flex:addLabel()
        :setText("Induction Matrix Status")
        :setSize(22, 1)

    local iFrame = Flex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["iFrame"] = iFrame
    screenElements["iLabel"] = iFrame:addLabel()
    screenElements["iBar"] = iFrame:addProgressbar()
    screenElements["iLabel2"] = iFrame:addLabel()

    local oFrame = Flex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["oFrame"] = oFrame
    screenElements["oLabel"] = oFrame:addLabel()
    screenElements["oBar"] = oFrame:addProgressbar()
    screenElements["oLabel2"] = oFrame:addLabel()

    local transferFrame = Flex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["transferFrame"] = transferFrame
    screenElements["transferFrameLabel"] = transferFrame:addLabel()
    screenElements["transferFrameBar"] = transferFrame:addProgressbar()
    screenElements["transferFrameLabel2"] = transferFrame:addLabel()

    local energyFrame = Flex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["energyFrame"] = energyFrame
    screenElements["energyLabel"] = energyFrame:addLabel()
    screenElements["energyBar"] = energyFrame:addProgressbar()
    screenElements["energyLabel2"] = energyFrame:addLabel()

    local timeFrame = Flex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["timeFrame"] = timeFrame
    screenElements["timeLabel"] = timeFrame:addLabel()
    screenElements["timeLabel2"] = timeFrame:addLabel()

    return screenElements

end

local function updateScreens(screen, data)

    screen.iLabel:setText(string.format("Input: %sFE", data.formatted.input))
    screen.iLabel:setPosition(calculateCenterX(screen.iFrame, screen.iLabel), 3)

    screen.iBar:setDirection("right")
    screen.iBar:setSize(14, 1)
    screen.iBar:setProgressBar(colors.blue)
    screen.iBar:setProgress((data.raw.input / data.raw.maxTransfer)*100)
    screen.iBar:setPosition(2, 4)

    screen.iLabel2:setText(string.format("%s", formatToThreeDigits((data.raw.input / data.raw.maxTransfer)*100)) .. "%")
    screen.iLabel2:setPosition(17, 4)

    screen.oLabel:setText(string.format("Output: %sFE", data.formatted.output))
    screen.oLabel:setPosition(calculateCenterX(screen.oFrame, screen.oLabel), 3)

    screen.oBar:setDirection("right")
    screen.oBar:setSize(14, 1)
    screen.oBar:setProgressBar(colors.blue)
    screen.oBar:setProgress((data.raw.output / data.raw.maxTransfer)*100)
    screen.oBar:setPosition(2, 4)

    screen.oLabel2:setText(string.format("%s", formatToThreeDigits((data.raw.output / data.raw.maxTransfer)*100)) .. "%")
    screen.oLabel2:setPosition(17, 4)

    screen.transferFrameLabel:setText(string.format("Transfer: %sFE", data.formatted.transfer))
    screen.transferFrameLabel:setPosition(calculateCenterX(screen.transferFrame, screen.transferFrameLabel), 3)

    screen.transferFrameBar:setDirection("right")
    screen.transferFrameBar:setSize(14, 1)
    screen.transferFrameBar:setProgressBar(colors.blue)
    screen.transferFrameBar:setProgress((data.raw.transfer / data.raw.maxTransfer)*100)
    screen.transferFrameBar:setPosition(2, 4)

    screen.transferFrameLabel2:setText(string.format("%s", formatToThreeDigits((data.raw.transfer / data.raw.maxTransfer)*100)) .. "%")
    screen.transferFrameLabel2:setPosition(17, 4)

    screen.energyLabel:setText(string.format("Energy: %sFE", data.formatted.energy))
    screen.energyLabel:setPosition(calculateCenterX(screen.energyFrame, screen.energyLabel), 3)

    screen.energyBar:setDirection("right")
    screen.energyBar:setSize(14, 1)
    screen.energyBar:setProgressBar(colors.blue)
    screen.energyBar:setProgress(data.raw.energyPercentage)
    screen.energyBar:setPosition(2, 4)

    screen.energyLabel2:setText(string.format("%s", data.raw.energyPercentage) .. "%")
    screen.energyLabel2:setPosition(17, 4)

    d, h, m, s = calculateFillTime(data.raw.input - data.raw.output, data.raw.energyCapacity - data.raw.energy)
    screen.timeLabel:setText("Time untill full")
    screen.timeLabel:setPosition(calculateCenterX(screen.timeFrame, screen.timeLabel), 3)
    screen.timeLabel2:setText(string.format("%dd, %dh, %dm, %ds", d, h, m, s))
    screen.timeLabel2:setPosition(calculateCenterX(screen.timeFrame, screen.timeLabel2), 4)

end

function mainLoop()
    screen = screenBuilder(monitor)

    while true do
        data = getData(inductionPort)
        updateScreens(screen, data)
        os.sleep(0.5)
    end
end

parallel.waitForAny(basalt.autoUpdate, mainLoop)