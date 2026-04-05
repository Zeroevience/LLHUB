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

-- NOTIFICATION (your message)
Window:Notify({
    Title = "Salut leandre",
    Description = "Wsh leandre merci dutiliser mon script",
    Lifetime = 5
})

-- TabGroup (THIS WAS MISSING)
local TabGroup = Window:TabGroup()

-- Tab
local Tab = TabGroup:Tab({
    Name = "Main",
    Image = "rbxassetid://532121536"
})

-- Section
local Section = Tab:Section({
    Side = "Left"
})

-- Settings
local RUNNING = false
local TARGET_NAME = "_PrimaryPart"
local SPEED = 45
local Y_OFFSET = 5

-- Slider (Speed)
Section:Slider({
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
})

-- Toggle (using button since your version shows Button API)
Section:Button({
    Name = "Toggle Auto Egg",
    Callback = function()
        RUNNING = not RUNNING
    end
})

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

                if not RUNNING then
                    tween:Cancel()
                end

                conn:Disconnect()
            else
                task.wait(1)
            end
        end

        task.wait(0.1)
    end
end)
