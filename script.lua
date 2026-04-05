-- Load MacLib
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- Window
local Window = MacLib:Window({
    Title = "Lyan's Private auto egg",
    Subtitle = "Blox Fruits",
    Size = UDim2.fromOffset(650, 450),
})

-- Notify
Window:Notify({
    Title = "Salut leandre",
    Description = "Wsh leandre merci dutiliser mon script",
    Lifetime = 5
})

-- TabGroup
local TabGroup = Window:TabGroup()

local Tab = TabGroup:Tab({
    Name = "Main",
    Image = "rbxassetid://532121536"
})

-- Section
local sections = {
    MainSection1 = Tab:Section({ Side = "Left" })
}

-- Settings
local RUNNING = false
local SPEED = 45
local Y_OFFSET = 5

-- Toggle
sections.MainSection1:Toggle({
    Name = "Auto Egg",
    Default = false,
    Callback = function(value)
        RUNNING = value

        Window:Notify({
            Title = "Auto Egg",
            Description = (value and "Enabled" or "Disabled")
        })
    end,
}, "AutoEggToggle")

-- Speed Slider
sections.MainSection1:Slider({
    Name = "Speed",
    Default = 45,
    Minimum = 1,
    Maximum = 1000,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(value)
        SPEED = value
    end,
    onInputComplete = function(value)
        SPEED = value
    end
}, "SpeedSlider")

-- 🧠 Hybrid detection
local function getClosestEgg(root)
    local closest = nil
    local shortestDist = math.huge

    local function consider(pos, obj)
        local dist = (root.Position - pos).Magnitude
        if dist < shortestDist then
            shortestDist = dist
            closest = obj
        end
    end

    local function checkRootPart(rp)
        if not rp or not rp:IsA("BasePart") then return end

        for _, child in ipairs(rp:GetChildren()) do
            if string.find(child.Name, "Egg") then
                consider(rp.Position, rp)
            end
        end
    end

    -- 1. workspace.Eggs (priority)
    local eggsFolder = workspace:FindFirstChild("Eggs")
    if eggsFolder then
        for _, obj in ipairs(eggsFolder:GetDescendants()) do
            if obj:IsA("BasePart") then
                consider(obj.Position, obj)
            elseif obj:FindFirstChild("RootPart") then
                checkRootPart(obj.RootPart)
            end
        end
    end

    -- 2. OLD METHOD (_PrimaryPart)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "_PrimaryPart" and obj:IsA("BasePart") then
            consider(obj.Position, obj)
        end
    end

    -- 3. RootPart + Egg child method
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("RootPart") then
            checkRootPart(obj.RootPart)
        end
    end

    return closest
end

-- Loop
task.spawn(function()
    while true do
        if RUNNING then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if root then
                local target = getClosestEgg(root)

                if target then
                    local targetPos = target.CFrame * CFrame.new(0, Y_OFFSET, 0)
                    local dist = (root.Position - targetPos.Position).Magnitude

                    local tween = TweenService:Create(
                        root,
                        TweenInfo.new(dist / SPEED, Enum.EasingStyle.Linear),
                        {CFrame = targetPos}
                    )

                    tween:Play()

                    local arrived = false
                    local conn = tween.Completed:Connect(function()
                        arrived = true
                    end)

                    while not arrived and RUNNING do
                        task.wait(0.1)
                    end

                    conn:Disconnect()
                else
                    task.wait(1)
                end
            end
        end

        task.wait(0.1)
    end
end)
