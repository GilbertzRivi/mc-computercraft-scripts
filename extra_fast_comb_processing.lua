local function getCentrifugePeripherals()
    local centrifugeList = {}
    for _, name in ipairs(peripheral.getNames()) do
        if name:lower():find("centrifuge") then
            table.insert(centrifugeList, {name = name, obj = peripheral.wrap(name)})
        end
    end
    return centrifugeList
end

local function distributeItems(inputInventory, centrifuges, limitForASlot)
    inputSlot = 1
    foo = 1
    while true do
        while inputInventory.getItemDetail(inputSlot) ~= nil and foo <= limitForASlot do
            local tasks = {}
            for _, centrifuge in ipairs(centrifuges) do
                table.insert(tasks, function()
                    inputInventory.pushItems(centrifuge.name, inputSlot)
                end)
            end
            parallel.waitForAll(table.unpack(tasks))
            foo = foo + 1
        end
        inputSlot = (inputSlot + 1) % inputInventory.size() + 1
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
                    j = ((runs - 1) * limit + i)
                    centrifuges[((j - 1) % #centrifuges) + 1].obj.pushItems(output.name, math.ceil(((j - 1) / #centrifuges) + 1) % 11 + 1)
                end)
            end
            parallel.waitForAll(table.unpack(tasks))
        end
    end
end


local function main()
    local inputName = "functionalstorage:storage_controller_0"
    local outputName = "expatternprovider:oversize_interface_1"
    local limitForASlot = 256;
    local centrifuges = getCentrifugePeripherals()
    local input = peripheral.wrap(inputName)
    local output = {name = outputName, obj = peripheral.wrap(outputName)}
    local processLimit = math.ceil(255 - 255/10)
    local distributeProc = #centrifuges
    processLimit = processLimit - distributeProc
    local dumpFluidsProc = #centrifuges
    processLimit = processLimit - dumpFluidsProc
    local dumpItemsLimit = processLimit
    parallel.waitForAll(
        function() distributeItems(input, centrifuges, limitForASlot) end,
        function() dumpFluids(centrifuges, output) end,
        function() dumpItems(centrifuges, output, dumpItemsLimit) end
    )
end

main()
