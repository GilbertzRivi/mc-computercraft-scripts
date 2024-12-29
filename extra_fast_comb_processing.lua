local function getCentrifugePeripherals()
    local centrifugeList = {}
    for _, name in ipairs(peripheral.getNames()) do
        if name:lower():find("centrifuge") then
            table.insert(centrifugeList, {name = name, obj = peripheral.wrap(name)})
        end
    end
    return centrifugeList
end

local function distributeItems(inputInventory, centrifuges)
    while true do
        local tasks = {}
        for _, centrifuge in ipairs(centrifuges) do
            table.insert(tasks, function()
                inputInventory.pushItems(centrifuge.name, 1)
            end)
        end
        parallel.waitForAll(table.unpack(tasks))
    end
end

local function dumpFluids(centrifuges, output)
    while true do
        local tasks = {}
        for _, centrifuge in ipairs(centrifuges) do
            table.insert(tasks, function()
                centrifuge.obj.pushFluid(output.name)
            end)
        end
        parallel.waitForAll(table.unpack(tasks))
    end
end

local function dumpItems(centrifuges, output, limit)
    while true do
        for runs = 1, math.ceil((#centrifuges * 9) / limit) do
            local tasks = {}
            for i = 1, limit do
                table.insert(tasks, function()
                    centrifuges[((((runs - 1) * limit + i) - 1) % #centrifuges) + 1].obj.pushItems(output.name, math.ceil(((((runs - 1) * limit + i) - 1) / #centrifuges) + 1) % 10 + 1)
                end)
            end
            parallel.waitForAll(table.unpack(tasks))
        end
    end
end


local function main()
    local centrifuges = getCentrifugePeripherals()
    local input = peripheral.wrap("functionalstorage:storage_controller_0")
    local output = {name = "expatternprovider:oversize_interface_1", obj = peripheral.wrap("expatternprovider:oversize_interface_1")}
    local processLimit = math.ceil(255 - 255/10)
    local distributeProc = #centrifuges
    processLimit = processLimit - distributeProc
    local dumpFluidsProc = #centrifuges
    processLimit = processLimit - dumpFluidsProc
    local dumpItemsLimit = processLimit
    parallel.waitForAll(
        function() distributeItems(input, centrifuges) end,
        function() dumpFluids(centrifuges, output) end,
        function() dumpItems(centrifuges, output, dumpItemsLimit) end
    )
end

main()
