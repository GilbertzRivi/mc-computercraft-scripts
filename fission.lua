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

wasteBarrelsReaders = {peripheral.find("blockReader")}

reactorNum = 8

reactor0 = peripheral.wrap("fissionReactorLogicAdapter_0")
turbine0 = peripheral.wrap("turbineValve_1")
switch0 = peripheral.wrap("redstoneIntegrator_9")
monitor0 = peripheral.wrap("monitor_5")
reactor1 = peripheral.wrap("fissionReactorLogicAdapter_1")
turbine1 = peripheral.wrap("turbineValve_0")
switch1 = peripheral.wrap("redstoneIntegrator_10")
monitor1 = peripheral.wrap("monitor_6")
reactor2 = peripheral.wrap("fissionReactorLogicAdapter_2")
turbine2 = peripheral.wrap("turbineValve_2")
switch2 = peripheral.wrap("redstoneIntegrator_11")
monitor2 = peripheral.wrap("monitor_7")
reactor3 = peripheral.wrap("fissionReactorLogicAdapter_3")
turbine3 = peripheral.wrap("turbineValve_3")
switch3 = peripheral.wrap("redstoneIntegrator_12")
monitor3 = peripheral.wrap("monitor_12")
reactor4 = peripheral.wrap("fissionReactorLogicAdapter_4")
turbine4 = peripheral.wrap("turbineValve_4")
switch4 = peripheral.wrap("redstoneIntegrator_13")
monitor4 = peripheral.wrap("monitor_11")
reactor5 = peripheral.wrap("fissionReactorLogicAdapter_5")
turbine5 = peripheral.wrap("turbineValve_5")
switch5 = peripheral.wrap("redstoneIntegrator_14")
monitor5 = peripheral.wrap("monitor_10")
reactor6 = peripheral.wrap("fissionReactorLogicAdapter_6")
turbine6 = peripheral.wrap("turbineValve_6")
switch6 = peripheral.wrap("redstoneIntegrator_15")
monitor6 = peripheral.wrap("monitor_9")
reactor7 = peripheral.wrap("fissionReactorLogicAdapter_7")
turbine7 = peripheral.wrap("turbineValve_7")
switch7 = peripheral.wrap("redstoneIntegrator_16")
monitor7 = peripheral.wrap("monitor_8")

reactors = {
    reactor0,
    reactor1,
    reactor2,
    reactor3,
    reactor4,
    reactor5,
    reactor6,
    reactor7,
}

turbines = {
    turbine0,
    turbine1,
    turbine2,
    turbine3,
    turbine4,
    turbine5,
    turbine6,
    turbine7,
}

switches = {
    switch0,
    switch1,
    switch2,
    switch3,
    switch4,
    switch5,
    switch6,
    switch7,
}

monitors = {
    monitor0,
    monitor1,
    monitor2,
    monitor3,
    monitor4,
    monitor5,
    monitor6,
    monitor7,
}

switchData = {
    {
        on = "right",
        off = "left"
    },
    {
        on = "right",
        off = "left"
    },
    {
        on = "right",
        off = "left"
    },
    {
        on = "right",
        off = "left"
    },
    {
        on = "right",
        off = "left"
    },
    {
        on = "right",
        off = "left"
    },
    {
        on = "right",
        off = "left"
    },
    {
        on = "right",
        off = "left"
    },
}

wasteData = {}

reactorData = {}
turbineData = {}
data = {}
screens = {}

for i=1,reactorNum do
    reactorData[i] = {}
end

for i=1,reactorNum do
    turbineData[i] = {}
end

for i=1,reactorNum do
    data[i] = {}
end

for i=1,reactorNum do
    screens[i] = {}
end

local function switchReactorState()
    while true do
        local _, monitor, x, y = os.pullEvent("monitor_touch")
        local monitorNames = {}
        for i, monitor in pairs(monitors) do
            monitorNames[i] = peripheral.getName(monitor)
        end
        local reactorIndex = indexOf(monitorNames, monitor)
        local curState = reactors[reactorIndex].getStatus()
        if curState then
            switches[reactorIndex].setOutput(switchData[reactorIndex].off, true)
            os.sleep(0.2)
            switches[reactorIndex].setOutput(switchData[reactorIndex].off, false)
        else
            switches[reactorIndex].setOutput(switchData[reactorIndex].on, true)
            os.sleep(0.2)
            switches[reactorIndex].setOutput(switchData[reactorIndex].on, false)
        end
    end
end

local function extractFissionData(logicAdapter)

    local damage = logicAdapter.getDamagePercent()
    local temperature = kelvinToCelsius(logicAdapter.getTemperature())
    local setBurnRate = logicAdapter.getBurnRate()
    local burnRate = logicAdapter.getActualBurnRate()
    local maxBurnRate = logicAdapter.getMaxBurnRate()
    local coolant = logicAdapter.getCoolant()["amount"]
    local coolantCapacity = logicAdapter.getCoolantCapacity()
    local fuel = logicAdapter.getFuel()["amount"]/1000
    local fuelCapacity = logicAdapter.getFuelCapacity()/1000
    local waste = logicAdapter.getWaste()["amount"]/1000
    local wasteCapacity = logicAdapter.getWasteCapacity()/1000
    local heatedCoolant = logicAdapter.getHeatedCoolant()["amount"]
    local heatedCoolantCapacity = logicAdapter.getHeatedCoolantCapacity()
    local status = logicAdapter.getStatus()
    local coolantPercentage = 0
    local fuelPercentage = 0
    local wastePercentage = 0
    local heatedCoolantPercentage = 0
    local burnRatePercentage = 0

    if coolant ~= 0 then coolantPercentage = formatToThreeDigits((coolant/coolantCapacity)*100) else coolantPercentage = 0 end
    if fuel ~= 0 then fuelPercentage = formatToThreeDigits((fuel/fuelCapacity)*100) else fuelPercentage = 0 end
    if waste ~= 0 then wastePercentage = formatToThreeDigits((waste/wasteCapacity)*100) else wastePercentage = 0 end
    if heatedCoolant ~= 0 then heatedCoolantPercentage = formatToThreeDigits((heatedCoolant/heatedCoolantCapacity)*100) else heatedCoolantPercentage = 0 end
    if burnRate ~= 0 then burnRatePercentage = formatToThreeDigits((burnRate/maxBurnRate)*100) else burnRatePercentage = 0 end

    coolant = formatNumber(coolant)
    coolantCapacity = formatNumber(coolantCapacity)
    fuel = formatNumber(fuel)
    fuelCapacity = formatNumber(fuelCapacity)
    waste = formatNumber(waste)
    wasteCapacity = formatNumber(wasteCapacity)
    heatedCoolant = formatNumber(heatedCoolant)
    heatedCoolantCapacity = formatNumber(heatedCoolantCapacity)

    data = {
        fuel = {
            fuel = fuel,
            fuelCapacity = fuelCapacity,
            fuelPercentage = fuelPercentage
        },
        waste = {
            waste = waste,
            wasteCapacity = wasteCapacity,
            wastePercentage = wastePercentage
        },
        coolant = {
            coolant = coolant,
            coolantCapacity = coolantCapacity,
            coolantPercentage = coolantPercentage
        },
        heatedCoolant = {
            heatedCoolant = heatedCoolant,
            heatedCoolantCapacity = heatedCoolantCapacity,
            heatedCoolantPercentage = heatedCoolantPercentage
        },
        burnRate = {
            burnRate = burnRate,
            setBurnRate = setBurnRate,
            maxBurnRate = maxBurnRate,
            burnRatePercentage = burnRatePercentage
        },
        health = {
            temperature = temperature,
            damage = damage,
            status = status
        }
    }
    return data
end

local function extractTurbineData(turbineValve)
    local steam = turbineValve.getSteam()["amount"]/1000
    local steamCapacity = turbineValve.getSteamCapacity()/1000
    local energy = turbineValve.getEnergy()*0.4
    local maxEnergy = turbineValve.getMaxEnergy()*0.4
    local flowRate = turbineValve.getFlowRate()/1000
    local maxFlowRate = turbineValve.getMaxFlowRate()/1000
    local maxEnergyProduction = turbineValve.getMaxProduction()*0.4
    local energyProduction = turbineValve.getProductionRate()*0.4
    local steamPercentage = 0
    local energyPercentage = 0
    local flowRatePercentage = 0
    local energyProductionPercentage = 0

    if steam ~= 0 then steamPercentage = formatToThreeDigits((steam/steamCapacity)*100) else steamPercentage = 0 end
    if energy ~= 0 then energyPercentage = formatToThreeDigits((energy/maxEnergy)*100) else energyPercentage = 0 end
    if flowRate ~= 0 then flowRatePercentage = formatToThreeDigits((flowRate/maxFlowRate)*100) else flowRatePercentage = 0 end
    if energyProduction ~= 0 then energyProductionPercentage = formatToThreeDigits((energyProduction/maxEnergyProduction)*100) else energyProductionPercentage = 0 end

    steam = formatNumber(steam)
    steamCapacity = formatNumber(steamCapacity)
    energy = formatNumber(energy)
    maxEnergy = formatNumber(maxEnergy)
    flowRate = formatNumber(flowRate)
    maxFlowRate = formatNumber(maxFlowRate)
    energyProduction = formatNumber(energyProduction)
    maxEnergyProduction = formatNumber(maxEnergyProduction)

    data = {
        steam = {
            steam = steam,
            steamCapacity = steamCapacity,
            steamPercentage = steamPercentage,
        },
        energy = {
            energy = energy,
            maxEnergy = maxEnergy,
            energyPercentage = energyPercentage,
        },
        flowRate = {
            flowRate = flowRate,
            maxFlowRate = maxFlowRate,
            flowRatePercentage = flowRatePercentage,
        },
        energyProduction = {
            energyProduction = energyProduction,
            maxEnergyProduction = maxEnergyProduction,
            energyProductionPercentage = energyProductionPercentage,
        }
    }
    return data
end

local function extractBarrelData(readers)
    storageWaste = 0
    storageWasteCapacity = 512*64
    for i, reader in pairs(readers) do
        blockData = reader.getBlockData()
        if isTablePopulated(blockData.GasTanks) then
            storageWaste = storageWaste + blockData.GasTanks[0].stored.amount
        end
    end
    storageWastePercentage = 0
    storageWaste = storageWaste / 1000
    if storageWaste ~= 0 then storageWastePercentage = formatToThreeDigits((storageWaste/storageWasteCapacity)*100) else storageWastePercentage = 0 end
    data = {
        storageWaste = {
            storageWaste = formatNumber(storageWaste),
            storageWasteCapacity = formatNumber(storageWasteCapacity),
            storageWastePercentage = storageWastePercentage,
        }
    }
    return data
end

local function getData(reactorData, turbineData, barrelsData)
    local fissleData = {}
    for k, v in pairs(reactorData) do
        fissleData[k] = v
    end
    for k, v in pairs(turbineData) do
        fissleData[k] = v
    end
    for k, v in pairs(barrelsData) do
        fissleData[k] = v
    end
    return fissleData
end

local function screenBuilder(monitor)
    
    local screenElements = {}
    monitor.setTextScale(1)
    local monitorFrame = basalt.addMonitor():setMonitor(monitor)

    local frame = monitorFrame
        :addFrame()
        :setPosition(1,1)
        :setSize("parent.w", "parent.h")
        :setBackground(colors.gray)

    local reactorFlexFrame = frame
        :addFrame()
        :setSize(24, "parent.h-2")
        :setPosition(2, 2)
        :setBackground(colors.cyan)
        :setBorder(colors.black)
        :setShadow(colors.gray)

    local reactorFlex = reactorFlexFrame
        :addFlexbox()
        :setWrap("wrap")
        :setPosition(2, 2)
        :setSize("parent.w - 2", "parent.h - 2")
        :setBackground(colors.cyan)
        :setForeground(colors.black)

    local reactorStatusLabel = reactorFlex:addLabel()
        :setText("Fission Reactor Status")
        :setSize(22, 1)

    local reactorStatusFrame = reactorFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["reactor"] = {}
    screenElements["reactor"]["statusFrame"] = reactorStatusFrame
    screenElements["reactor"]["status"] = reactorStatusFrame:addLabel()
    screenElements["reactor"]["tempLabel"] = reactorStatusFrame:addLabel()
    screenElements["reactor"]["dmgLabel"] = reactorStatusFrame:addLabel()

    local fuelFrame = reactorFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["reactor"]["fuelFrame"] = fuelFrame
    screenElements["reactor"]["fuelTextLabel"] = fuelFrame:addLabel()
    screenElements["reactor"]["fuelText"] = fuelFrame:addLabel()
    screenElements["reactor"]["fuelBar"] = fuelFrame:addProgressbar()
    screenElements["reactor"]["fuelText2"] = fuelFrame:addLabel()
    screenElements["reactor"]["burnRateText"] = fuelFrame:addLabel()
    screenElements["reactor"]["burnRateBar"] = fuelFrame:addProgressbar()
    screenElements["reactor"]["burnRateText2"] = fuelFrame:addLabel()

    local coolantFrame = reactorFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["reactor"]["coolantFrame"] = coolantFrame
    screenElements["reactor"]["coolantTextLabel"] = coolantFrame:addLabel()
    screenElements["reactor"]["coolantBar"] = coolantFrame:addProgressbar()
    screenElements["reactor"]["coolantText"] = coolantFrame:addLabel()

    local wasteFrame = reactorFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["reactor"]["wasteFrame"] = wasteFrame
    screenElements["reactor"]["wasteTextLabel"] = wasteFrame:addLabel()
    screenElements["reactor"]["wasteBar"] = wasteFrame:addProgressbar()
    screenElements["reactor"]["wasteText"] = wasteFrame:addLabel()

    local heatedCoolantFrame = reactorFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["reactor"]["heatedCoolantFrame"] = heatedCoolantFrame
    screenElements["reactor"]["heatedCoolantTextLabel"] = heatedCoolantFrame:addLabel()
    screenElements["reactor"]["heatedCoolantBar"] = heatedCoolantFrame:addProgressbar()
    screenElements["reactor"]["heatedCoolantText"] = heatedCoolantFrame:addLabel()

    local turbineFlexFrame = frame
        :addFrame()
        :setSize(24, "parent.h-2")
        :setPosition(26, 2)
        :setBackground(colors.cyan)
        :setBorder(colors.black)
        :setShadow(colors.gray)

    local turbineFlex = turbineFlexFrame
        :addFlexbox()
        :setWrap("wrap")
        :setPosition(2, 2)
        :setSize("parent.w - 2", "parent.h - 2")
        :setBackground(colors.cyan)
        :setForeground(colors.black)

    local turbineStatusLabel = turbineFlex:addLabel()
        :setText("Industrial Turbine Status")
        :setSize(22, 1)

    local energyProductionFrame = turbineFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["turbine"] = {}
    screenElements["turbine"]["energyProductionFrame"] = energyProductionFrame
    screenElements["turbine"]["productionTextLabel"] = energyProductionFrame:addLabel()
    screenElements["turbine"]["productionBar"] = energyProductionFrame:addProgressbar()
    screenElements["turbine"]["productionText"] = energyProductionFrame:addLabel()

    local energyStorageFrame = turbineFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["turbine"]["energyStorageFrame"] = energyStorageFrame
    screenElements["turbine"]["energyTextLabel"] = energyStorageFrame:addLabel()
    screenElements["turbine"]["energyBar"] = energyStorageFrame:addProgressbar()
    screenElements["turbine"]["energyText"] = energyStorageFrame:addLabel()

    local steamFrame = turbineFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["turbine"]["steamFrame"] = steamFrame
    screenElements["turbine"]["steamTextLabel"] = steamFrame:addLabel()
    screenElements["turbine"]["steamBar"] = steamFrame:addProgressbar()
    screenElements["turbine"]["steamText"] = steamFrame:addLabel()

    local flowRateFrame = turbineFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["turbine"]["flowRateFrame"] = flowRateFrame
    screenElements["turbine"]["flowRateTextLabel"] = flowRateFrame:addLabel()
    screenElements["turbine"]["flowRateBar"] = flowRateFrame:addProgressbar()
    screenElements["turbine"]["flowRateText"] = flowRateFrame:addLabel()

    local storageWasteFrame = turbineFlex:addFrame()
        :setSize(22, 6)
        :setBackground(colors.lightGray)
        :setBorder(colors.black)

    screenElements["storageWaste"] = {}
    screenElements["storageWaste"]["storageWasteFrame"] = storageWasteFrame
    screenElements["storageWaste"]["storageWasteTextLabel"] = storageWasteFrame:addLabel()
    screenElements["storageWaste"]["storageWasteBar"] = storageWasteFrame:addProgressbar()
    screenElements["storageWaste"]["storageWasteText"] = storageWasteFrame:addLabel()

    return screenElements

end

local function updateScreens(screen, data)

    local reactorStatus = ""

    if data.health.status then reactorStatus = "ON" else reactorStatus = "OFF" end

    screen.reactor.status:setText(reactorStatus)
        :setPosition(calculateCenterX(screen.reactor.statusFrame, screen.reactor.status), 2)

    screen.reactor.tempLabel:setText(string.format("Reactor temp: %dC", data.health.temperature))
    screen.reactor.tempLabel:setPosition(calculateCenterX(screen.reactor.statusFrame, screen.reactor.tempLabel), 3)

    screen.reactor.dmgLabel:setText(string.format("Reactor dmg: %d", data.health.damage))
    screen.reactor.dmgLabel:setPosition(calculateCenterX(screen.reactor.statusFrame, screen.reactor.dmgLabel), 4)

    local statusColor = colors.green
    if celsiusToKelvin(data.health.temperature) > 600 or data.health.damage > 15 then statusColor = colors.yellow
    elseif celsiusToKelvin(data.health.temperature) > 1000 or data.health.damage > 30 then statusColor = colors.orange
    elseif celsiusToKelvin(data.health.temperature) > 1200 or data.health.damage > 60 then statusColor = colors.red
    end
    if data.health.status ~= true then statusColor = colors.red
    end

    screen.reactor.statusFrame:setBackground(statusColor)

    screen.reactor.fuelTextLabel:setText("Fissle Fuel")
    screen.reactor.fuelTextLabel:setPosition(calculateCenterX(screen.reactor.fuelFrame, screen.reactor.fuelTextLabel), 2)

    screen.reactor.fuelText:setText("Stored")
    screen.reactor.fuelText:setPosition(2, 3)

    screen.reactor.fuelBar:setDirection("right")
    screen.reactor.fuelBar:setSize(7, 1)
    screen.reactor.fuelBar:setProgressBar(colors.blue)
    screen.reactor.fuelBar:setProgress(tonumber(data.fuel.fuelPercentage))
    screen.reactor.fuelBar:setPosition(9, 3)

    screen.reactor.fuelText2:setText(string.format("%s", data.fuel.fuelPercentage) .. "%")
    screen.reactor.fuelText2:setPosition(17, 3)

    screen.reactor.burnRateText:setText("Burn")
    screen.reactor.burnRateText:setPosition(2, 4)

    screen.reactor.burnRateBar:setDirection("right")
    screen.reactor.burnRateBar:setSize(7, 1)
    screen.reactor.burnRateBar:setProgressBar(colors.blue)
    screen.reactor.burnRateBar:setProgress(tonumber(data.burnRate.burnRatePercentage))
    screen.reactor.burnRateBar:setPosition(9, 4)

    screen.reactor.burnRateText2:setText(string.format("%s", data.burnRate.burnRatePercentage) .. "%")
    screen.reactor.burnRateText2:setPosition(17, 4)

    local fuelColor = colors.green
    if tonumber(data.fuel.fuelPercentage) < 60 then fuelColor = colors.yellow
    elseif tonumber(data.fuel.fuelPercentage) < 30 then fuelColor = colors.orange
    elseif tonumber(data.fuel.fuelPercentage) < 15 then fuelColor = colors.red
    end
    screen.reactor.fuelFrame:setBackground(fuelColor)

    screen.reactor.coolantTextLabel:setText("Coolant")
    screen.reactor.coolantTextLabel:setPosition(calculateCenterX(screen.reactor.coolantFrame, screen.reactor.coolantTextLabel), 3)

    screen.reactor.coolantBar:setDirection("right")
    screen.reactor.coolantBar:setSize(14, 1)
    screen.reactor.coolantBar:setProgressBar(colors.blue)
    screen.reactor.coolantBar:setProgress(tonumber(data.coolant.coolantPercentage))
    screen.reactor.coolantBar:setPosition(2, 4)

    screen.reactor.coolantText:setText(string.format("%s", data.coolant.coolantPercentage) .. "%")
    screen.reactor.coolantText:setPosition(17, 4)

    local coolantColor = colors.green
    if tonumber(data.coolant.coolantPercentage) < 80 then coolantColor = colors.yellow
    elseif tonumber(data.coolant.coolantPercentage) < 60 then coolantColor = colors.orange
    elseif tonumber(data.coolant.coolantPercentage) < 40 then coolantColor = colors.red
    end
    screen.reactor.coolantFrame:setBackground(coolantColor)

    screen.reactor.wasteTextLabel:setText("Nuclear Waste")
    screen.reactor.wasteTextLabel:setPosition(calculateCenterX(screen.reactor.wasteFrame, screen.reactor.wasteTextLabel), 3)

    screen.reactor.wasteBar:setDirection("right")
    screen.reactor.wasteBar:setSize(14, 1)
    screen.reactor.wasteBar:setProgressBar(colors.blue)
    screen.reactor.wasteBar:setProgress(tonumber(data.waste.wastePercentage))
    screen.reactor.wasteBar:setPosition(2, 4)

    screen.reactor.wasteText:setText(string.format("%s", data.waste.wastePercentage) .. "%")
    screen.reactor.wasteText:setPosition(17, 4)

    local wasteColor = colors.green
    if tonumber(data.waste.wastePercentage) > 25 then wasteColor = colors.yellow
    elseif tonumber(data.waste.wastePercentage) > 50 then wasteColor = colors.orange
    elseif tonumber(data.waste.wastePercentage) > 75 then wasteColor = colors.red
    end
    screen.reactor.wasteFrame:setBackground(wasteColor)

    screen.reactor.heatedCoolantTextLabel:setText("Heated Coolant")
    screen.reactor.heatedCoolantTextLabel:setPosition(calculateCenterX(screen.reactor.heatedCoolantFrame, screen.reactor.heatedCoolantTextLabel), 3)

    screen.reactor.heatedCoolantBar:setDirection("right")
    screen.reactor.heatedCoolantBar:setSize(14, 1)
    screen.reactor.heatedCoolantBar:setProgressBar(colors.blue)
    screen.reactor.heatedCoolantBar:setProgress(tonumber(data.heatedCoolant.heatedCoolantPercentage))
    screen.reactor.heatedCoolantBar:setPosition(2, 4)

    screen.reactor.heatedCoolantText:setText(string.format("%s", data.heatedCoolant.heatedCoolantPercentage) .. "%")
    screen.reactor.heatedCoolantText:setPosition(17, 4)

    local heatedCoolantColor = colors.green
    if tonumber(data.heatedCoolant.heatedCoolantPercentage) > 15 then heatedCoolantColor = colors.yellow
    elseif tonumber(data.heatedCoolant.heatedCoolantPercentage) > 30 then heatedCoolantColor = colors.orange
    elseif tonumber(data.heatedCoolant.heatedCoolantPercentage) > 60 then heatedCoolantColor = colors.red
    end
    screen.reactor.heatedCoolantFrame:setBackground(heatedCoolantColor)

    screen.turbine.productionTextLabel:setText("Energy Generation")
    screen.turbine.productionTextLabel:setPosition(calculateCenterX(screen.turbine.energyProductionFrame, screen.turbine.productionTextLabel), 3)

    screen.turbine.productionBar:setDirection("right")
    screen.turbine.productionBar:setSize(14, 1)
    screen.turbine.productionBar:setProgressBar(colors.blue)
    screen.turbine.productionBar:setProgress(tonumber(data.energyProduction.energyProductionPercentage))
    screen.turbine.productionBar:setPosition(2, 4)

    screen.turbine.productionText:setText(string.format("%s", data.energyProduction.energyProductionPercentage) .. "%")
    screen.turbine.productionText:setPosition(17, 4)

    local productionColor = colors.yellow
    if convertToInteger(data.energyProduction.energyProduction) >= 0.95 * convertToInteger(data.energyProduction.maxEnergyProduction) then productionColor = colors.purple
    elseif convertToInteger(data.energyProduction.energyProduction) >= 0.6 * convertToInteger(data.energyProduction.maxEnergyProduction) then productionColor = colors.green
    end
    screen.turbine.energyProductionFrame:setBackground(productionColor)

    screen.turbine.energyTextLabel:setText("Stored Energy")
    screen.turbine.energyTextLabel:setPosition(calculateCenterX(screen.turbine.energyStorageFrame, screen.turbine.energyTextLabel), 3)

    screen.turbine.energyBar:setDirection("right")
    screen.turbine.energyBar:setSize(14, 1)
    screen.turbine.energyBar:setProgressBar(colors.blue)
    screen.turbine.energyBar:setProgress(tonumber(data.energy.energyPercentage))
    screen.turbine.energyBar:setPosition(2, 4)

    screen.turbine.energyText:setText(string.format("%s", data.energy.energyPercentage) .. "%")
    screen.turbine.energyText:setPosition(17, 4)

    local energyColor = colors.green
    if tonumber(data.energy.energyPercentage) > 50 then energyColor = colors.yellow
    elseif tonumber(data.energy.energyPercentage) > 65 then energyColor = colors.orange
    elseif tonumber(data.energy.energyPercentage) > 80 then energyColor = colors.red
    end
    screen.turbine.energyStorageFrame:setBackground(energyColor)

    screen.turbine.steamTextLabel:setText("Steam")
    screen.turbine.steamTextLabel:setPosition(calculateCenterX(screen.turbine.steamFrame, screen.turbine.steamTextLabel), 2)

    screen.turbine.steamBar:setDirection("right")
    screen.turbine.steamBar:setSize(14, 1)
    screen.turbine.steamBar:setProgressBar(colors.blue)
    screen.turbine.steamBar:setProgress(tonumber(data.steam.steamPercentage))
    screen.turbine.steamBar:setPosition(2, 4)

    screen.turbine.steamText:setText(string.format("%s", data.steam.steamPercentage) .. "%")
    screen.turbine.steamText:setPosition(17, 4)

    local steamColor = colors.green
    if tonumber(data.steam.steamPercentage) > 66 then steamColor = colors.yellow
    elseif tonumber(data.steam.steamPercentage) > 80 then steamColor = colors.orange
    elseif tonumber(data.steam.steamPercentage) > 95 then steamColor = colors.red
    end
    screen.turbine.steamFrame:setBackground(steamColor)

    screen.turbine.flowRateTextLabel:setText("Flow Rate")
    screen.turbine.flowRateTextLabel:setPosition(calculateCenterX(screen.turbine.flowRateFrame, screen.turbine.flowRateTextLabel), 3)

    screen.turbine.flowRateBar:setDirection("right")
    screen.turbine.flowRateBar:setSize(14, 1)
    screen.turbine.flowRateBar:setProgressBar(colors.blue)
    screen.turbine.flowRateBar:setProgress(tonumber(data.flowRate.flowRatePercentage))
    screen.turbine.flowRateBar:setPosition(2, 4)

    screen.turbine.flowRateText:setText(string.format("%s", data.flowRate.flowRatePercentage) .. "%")
    screen.turbine.flowRateText:setPosition(17, 4)

    local flowRateColor = colors.green
    if tonumber(data.flowRate.flowRatePercentage) > 66 then flowRateColor = colors.yellow
    elseif tonumber(data.flowRate.flowRatePercentage) > 80 then flowRateColor = colors.orange
    elseif tonumber(data.flowRate.flowRatePercentage) > 95 then flowRateColor = colors.red
    end
    screen.turbine.flowRateFrame:setBackground(flowRateColor)

    screen.storageWaste.storageWasteTextLabel:setText("Waste Storage")
    screen.storageWaste.storageWasteTextLabel:setPosition(calculateCenterX(screen.storageWaste.storageWasteFrame, screen.storageWaste.storageWasteTextLabel), 3)

    screen.storageWaste.storageWasteBar:setDirection("right")
    screen.storageWaste.storageWasteBar:setSize(14, 1)
    screen.storageWaste.storageWasteBar:setProgressBar(colors.blue)
    screen.storageWaste.storageWasteBar:setProgress(tonumber(data.storageWaste.storageWastePercentage))
    screen.storageWaste.storageWasteBar:setPosition(2, 4)

    screen.storageWaste.storageWasteText:setText(string.format("%s", data.storageWaste.storageWastePercentage) .. "%")
    screen.storageWaste.storageWasteText:setPosition(17, 4)

    local storageWasteColor = colors.green
    if data.storageWaste.storageWastePercentage > 60 then storageWasteColor = colors.yellow
    elseif data.storageWaste.storageWastePercentage > 75 then storageWasteColor = colors.orange
    elseif data.storageWaste.storageWastePercentage > 90 then storageWasteColor = colors.red
    end
    screen.storageWaste.storageWasteFrame:setBackground(storageWasteColor)

end

local function wasteDataLoop()
    while true do
        wasteData = extractBarrelData(wasteBarrelsReaders)
        os.sleep(0.5)
    end
end

local function getDataLoop(index)
    return function()
        while true do
            reactorData[index] = extractFissionData(reactors[index])
            turbineData[index] = extractTurbineData(turbines[index])
            os.sleep(0.5)
        end
    end
end

local function screenLoop()

    wasteData = extractBarrelData(wasteBarrelsReaders)
    
    for i=1,reactorNum do
        reactorData[i] = extractFissionData(reactors[i])
        turbineData[i] = extractTurbineData(turbines[i])
    end

    for i=1,reactorNum do
        screens[i] = screenBuilder(monitors[i])
    end
    
    while true do        
        for i=1,reactorNum do
            data[i] = getData(reactorData[i], turbineData[i], wasteData)
        end

        for i=1,reactorNum do
            updateScreens(screens[i], data[i])
        end
        os.sleep(0.5)
    end
end

local function mainLoop()
    parallel.waitForAny(
        wasteDataLoop,
        getDataLoop(1),
        getDataLoop(2),
        getDataLoop(3),
        getDataLoop(4),
        getDataLoop(5),
        getDataLoop(6),
        getDataLoop(7),
        getDataLoop(8),
        switchReactorState,
        screenLoop
    )
end

parallel.waitForAny(basalt.autoUpdate, mainLoop)