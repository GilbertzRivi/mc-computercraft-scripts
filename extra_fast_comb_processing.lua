local function getCentrifugePeripherals()
    local centrifugeList = {}
    for _, name in ipairs(peripheral.getNames()) do
        if name:lower():find("centrifuge") then
            table.insert(centrifugeList, {name = name, obj = peripheral.wrap(name)})
        end
    end
    return centrifugeList
end

local function distributeItemsTask(inputInventory, centrifuge, slot)
    local itemDetail = inputInventory.getItemDetail(slot)
    if itemDetail then
        inputInventory.pushItems(centrifuge.name, slot)
    end
end

local function distributeItems(inputInventory, centrifuges)
    local centrifugeCount = #centrifuges
    local currentSlot = 1
    while true do
        local tasks = {}
        for _, centrifuge in ipairs(centrifuges) do
            table.insert(tasks, function()
                distributeItemsTask(inputInventory, centrifuge, currentSlot)
            end)
        end

        parallel.waitForAll(table.unpack(tasks))
        currentSlot = (currentSlot % 36) + 1
    end
end

local function dumpItemsTask(centrifuge, output)
    local items = centrifuge.obj.list()
    for slot, _ in pairs(items) do
        centrifuge.obj.pushItems(output.name, slot)
    end
end

local function dumpItems(centrifuges, output)
    while true do
        local tasks = {}
        for _, centrifuge in ipairs(centrifuges) do
            table.insert(tasks, function()
                dumpItemsTask(centrifuge, output)
            end)
        end

        parallel.waitForAll(table.unpack(tasks))
    end
end

local function dumpFluidsTask(centrifuge, output)
    local tanks = centrifuge.obj.tanks()
    if tanks and #tanks > 0 then
        centrifuge.obj.pushFluid(output.name)
    end
end

local function dumpFluids(centrifuges, output)
    while true do
        local tasks = {}
        for _, centrifuge in ipairs(centrifuges) do
            table.insert(tasks, function()
                dumpFluidsTask(centrifuge, output)
            end)
        end
        parallel.waitForAll(table.unpack(tasks))
    end
end

local function main()
    local centrifuges = getCentrifugePeripherals()
    local input = peripheral.wrap("expatternprovider:oversize_interface_0")
    local output = {name = "expatternprovider:oversize_interface_1", obj = peripheral.wrap("expatternprovider:oversize_interface_1")}
    parallel.waitForAll(
        function() distributeItems(input, centrifuges) end,
        function() dumpItems(centrifuges, output) end,
        function() dumpFluids(centrifuges, output) end
    )
end

main()
