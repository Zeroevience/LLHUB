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

local TARGET_NAME = "_PrimaryPart"
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
    Maximum = 120,
    DisplayMethod = "Value",
    Precision = 0,
    Callback = function(value)
        SPEED = value
    end,
    onInputComplete = function(value)
        SPEED = value
    end
}, "SpeedSlider")

-- Auto Egg Loop
task.spawn(function()
    while true do
        if RUNNING then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            local target = nil
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == TARGET_NAME and obj:IsA("BasePart") then
                    target = obj
                    break
                end
            end

            if target and root then
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

        task.wait(0.1)
    end
end)
