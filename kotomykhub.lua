-- [[ PROJECT DIAMOND X: SERVER STRESSER EDITION ]]

local players = game:GetService("Players")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = players.LocalPlayer
local coreGui = game:GetService("CoreGui")

-- Видаляємо стару версію, якщо вона була
if coreGui:FindFirstChild("DiamondX_Final") then coreGui.DiamondX_Final:Destroy() end

local screenGui = Instance.new("ScreenGui", coreGui)
screenGui.Name = "DiamondX_Final"

-- === СУЧАСНИЙ GUI ===
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.new(0, 240, 0, 300)
main.Position = UDim2.new(0.5, -120, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "DIAMOND X CORE"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

-- Сяючий ефект
local uiGradient = Instance.new("UIGradient", title)
uiGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
})

-- === ФУНКЦІЯ АГРЕСИВНОГО СПАМУ ===
local function startLag()
    -- Шукаємо всі активні RemoteEvents
    local remotes = {}
    for _, v in pairs(replicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            table.insert(remotes, v)
        end
    end

    -- Запускаємо нескінченний потік запитів
    runService.Stepped:Connect(function()
        for _, remote in pairs(remotes) do
            -- Відправляємо важкі пакети (великі таблиці)
            for i = 1, 100 do
                remote:FireServer({["DiamondX"] = string.rep("💎", 500)})
            end
        end
    end)
end

-- Кнопка активації
local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0.8, 0, 0, 45)
btn.Position = UDim2.new(0.1, 0, 0.4, 0)
btn.Text = "LAUNCH STRESSER"
btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.GothamBold
Instance.new("UICorner", btn)

btn.MouseButton1Click:Connect(function()
    btn.Text = "STRESSING..."
    btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    startLag()
end)

-- Додаткова кнопка на Wall Breaker (як ти хотів)
local wallBtn = Instance.new("TextButton", main)
wallBtn.Size = UDim2.new(0.8, 0, 0, 45)
wallBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
wallBtn.Text = "GET BREAKER"
wallBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
wallBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", wallBtn)

wallBtn.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool", localPlayer.Backpack)
    tool.Name = "💎 BREAKER"; tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local m = localPlayer:GetMouse()
        if m.Target and not players:GetPlayerFromCharacter(m.Target.Parent) then m.Target:Destroy() end
    end)
    wallBtn.Text = "READY"
end)
