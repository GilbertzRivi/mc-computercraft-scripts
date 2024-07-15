local function run1()
    shell.run("fission.lua")
end

local function run2()
    shell.run("matrix.lua")
end

parallel.waitForAny(run1, run2)