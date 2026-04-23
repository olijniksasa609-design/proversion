local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

if coreGui:FindFirstChild("KotomYkHub") then coreGui.KotomYkHub:Destroy() end
if coreGui:FindFirstChild("KotomKeySystem") then coreGui.KotomKeySystem:Destroy() end

local correctKey = "KOTOMYK2026"

-- === KEY SYSTEM ===
local keyGui = Instance.new("ScreenGui", coreGui)
keyGui.Name = "KotomKeySystem"
local keyFrame = Instance.new("Frame", keyGui)
keyFrame.Size = UDim2.new(0, 260, 0, 160)
keyFrame.Position = UDim2.new(0.5, -130, 0.4, 0)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", keyFrame)

local keyTitle = Instance.new("TextLabel", keyFrame)
keyTitle.Size = UDim2.new(1, 0, 0, 40)
keyTitle.Text = "KOTOMYK HUB PRO"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", keyTitle)

local keyInput = Instance.new("TextBox", keyFrame)
keyInput.Size = UDim2.new(0.8, 0, 0, 35)
keyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
keyInput.PlaceholderText = "Введіть ключ..."
keyInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", keyInput)

local checkBtn = Instance.new("TextButton", keyFrame)
checkBtn.Size = UDim2.new(0.8, 0, 0, 35)
checkBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
checkBtn.Text = "ACTIVATE PRO"
checkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", checkBtn)

-- === MAIN HUB FUNCTION ===
local function launchHub()
    keyGui:Destroy()
    
    local espActive = false
    local aimbotEnabled = false
    local antiAimEnabled = false
    local fovRadius = 120

    local mainGui = Instance.new("ScreenGui", coreGui)
    mainGui.Name = "KotomYkHub"
    local main = Instance.new("Frame", mainGui)
    main.Size = UDim2.new(0, 220, 0, 280) -- Збільшив для нової кнопки
    main.Position = UDim2.new(0.5, -110, 0.4, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main)

    local function createBtn(pos, text, color)
        local b = Instance.new("TextButton", main)
        b.Size = UDim2.new(0.8, 0, 0, 35)
        b.Position = pos
        b.Text = text
        b.BackgroundColor3 = color or Color3.fromRGB(120, 0, 0)
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.SourceSansBold
        Instance.new("UICorner", b)
        return b
    end

    local espBtn = createBtn(UDim2.new(0.1, 0, 0.2, 0), "ESP: OFF")
    local aimBtn = createBtn(UDim2.new(0.1, 0, 0.4, 0), "AIM: OFF")
    local aaBtn = createBtn(UDim2.new(0.1, 0, 0.6, 0), "SPINBOT: OFF")

    -- Логіка кнопок
    espBtn.MouseButton1Click:Connect(function()
        espActive = not espActive
        espBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
        espBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    end)

    aimBtn.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        aimBtn.Text = aimbotEnabled and "AIM: ON" or "AIM: OFF"
        aimBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    end)

    aaBtn.MouseButton1Click:Connect(function()
        antiAimEnabled = not antiAimEnabled
        aaBtn.Text = antiAimEnabled and "SPINBOT: ON" or "SPINBOT: OFF"
        aaBtn.BackgroundColor3 = antiAimEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    end)

    -- ЦИКЛ ОБРОБКИ (ESP, AIM, SPINBOT)
    runService.RenderStepped:Connect(function()
        local char = localPlayer.Character
        
        -- ESP Logic
        if espActive then
            for _, p in pairs(players:GetPlayers()) do
                if p ~= localPlayer and p.Character then
                    local hl = p.Character:FindFirstChild("KotomHighlight") or Instance.new("Highlight", p.Character)
                    hl.Name = "KotomHighlight"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true
                end
            end
        end

        -- SpinBot (Anti-Aim) Logic
        if antiAimEnabled and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end

        -- AimBot Logic (RMB)
        if aimbotEnabled and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target = nil
            local dist = fovRadius
            for _, v in pairs(players:GetPlayers()) do
                if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local pos, vis = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                    if vis then
                        local mDist = (Vector2.new(pos.X, pos.Y) - userInputService:GetMouseLocation()).Magnitude
                        if mDist < dist then target = v.Character.HumanoidRootPart; dist = mDist end
                    end
                end
            end
            if target then camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position) end
        end
    end)
end

checkBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == correctKey then launchHub() else checkBtn.Text = "WRONG KEY" wait(1) checkBtn.Text = "ACTIVATE PRO" end
end)
