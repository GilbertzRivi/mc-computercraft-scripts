local function getCentrifugePeripherals()
    local centrifugeList = {}
    for _, name in ipairs(peripheral.getNames()) do
        if name:lower():find("centrifuge") then
            table.insert(centrifugeList, { name = name, obj = peripheral.wrap(name) })
        end
    end
    return centrifugeList
end

local function centrifugeWorker(inputInventory, centrifugeName)
    while true do
        local items = inputInventory.list() 
        local eligibleSlots = {}
        for slot, item in pairs(items) do
            if item and item.count >= 64 then
                table.insert(eligibleSlots, slot)
            end
        end

        if #eligibleSlots > 0 then
            local idx = math.random(1, #eligibleSlots)
            local chosenSlot = eligibleSlots[idx]
            inputInventory.pushItems(centrifugeName, chosenSlot, 64)
        end
    end
end

local function main()
    local inputName = "functionalstorage:storage_controller_0"
    local input = peripheral.wrap(inputName)
    local tasks = {}
    local centrifuges = getCentrifugePeripherals()
    for _, centrifuge in ipairs(centrifuges) do
        table.insert(tasks, function()
            centrifugeWorker(input, centrifuge.name)
        end)
    end
    parallel.waitForAll(table.unpack(tasks))
end

main()
