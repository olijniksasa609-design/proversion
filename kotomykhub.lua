local coreGui = game:GetService("CoreGui")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

if coreGui:FindFirstChild("KotomYkHub") then coreGui.KotomYkHub:Destroy() end
if coreGui:FindFirstChild("KotomKeySystem") then coreGui.KotomKeySystem:Destroy() end

local correctKey = "KOTOMYK2026"

-- === СИСТЕМА КЛЮЧІВ ===
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
keyTitle.Font = Enum.Font.SourceSansBold
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
checkBtn.Text = "ACTIVATE"
checkBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
checkBtn.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", checkBtn)

-- === ГОЛОВНИЙ ФУНКЦІОНАЛ ===
local function launchHub()
    keyGui:Destroy()
    
    local espActive, aimbotEnabled, antiAimEnabled = false, false, false
    local graySkyEnabled, noRecoilEnabled = false, false
    local bhopEnabled, dashEnabled = false, false
    local fovRadius = 120
    local lastDash = 0

    local mainGui = Instance.new("ScreenGui", coreGui)
    mainGui.Name = "KotomYkHub"
    local main = Instance.new("Frame", mainGui)
    main.Size = UDim2.new(0, 220, 0, 500) 
    main.Position = UDim2.new(0.5, -110, 0.15, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main)

    local function createBtn(pos, text, color)
        local b = Instance.new("TextButton", main)
        b.Size = UDim2.new(0.8, 0, 0, 30)
        b.Position = pos
        b.Text = text
        b.BackgroundColor3 = color or Color3.fromRGB(130, 0, 0)
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.SourceSansBold
        Instance.new("UICorner", b)
        return b
    end

    local espBtn = createBtn(UDim2.new(0.1, 0, 0.05, 0), "ESP: OFF")
    local aimBtn = createBtn(UDim2.new(0.1, 0, 0.13, 0), "AIM: OFF")
    local aaBtn = createBtn(UDim2.new(0.1, 0, 0.21, 0), "SPINBOT: OFF")
    local nrBtn = createBtn(UDim2.new(0.1, 0, 0.29, 0), "NO RECOIL: OFF")
    local skyBtn = createBtn(UDim2.new(0.1, 0, 0.37, 0), "GRAY SKY: OFF")
    local bhopBtn = createBtn(UDim2.new(0.1, 0, 0.45, 0), "BHOP: OFF")
    local dashBtn = createBtn(UDim2.new(0.1, 0, 0.53, 0), "DASH (E): OFF")
    local wallBtn = createBtn(UDim2.new(0.1, 0, 0.65, 0), "GET WALL BREAKER", Color3.fromRGB(0, 80, 150))

    -- Логіка перемикачів
    local function toggle(btn, var, text)
        var = not var
        btn.Text = var and text..": ON" or text..": OFF"
        btn.BackgroundColor3 = var and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(130, 0, 0)
        return var
    end

    espBtn.MouseButton1Click:Connect(function() espActive = toggle(espBtn, espActive, "ESP") end)
    aimBtn.MouseButton1Click:Connect(function() aimbotEnabled = toggle(aimBtn, aimbotEnabled, "AIM") end)
    aaBtn.MouseButton1Click:Connect(function() antiAimEnabled = toggle(aaBtn, antiAimEnabled, "SPINBOT") end)
    nrBtn.MouseButton1Click:Connect(function() noRecoilEnabled = toggle(nrBtn, noRecoilEnabled, "NO RECOIL") end)
    bhopBtn.MouseButton1Click:Connect(function() bhopEnabled = toggle(bhopBtn, bhopEnabled, "BHOP") end)
    dashBtn.MouseButton1Click:Connect(function() dashEnabled = toggle(dashBtn, dashEnabled, "DASH") end)

    -- === ФУНКЦІЯ RUIN WALLS (ШТУКА ДЛЯ СТІН) ===
    wallBtn.MouseButton1Click:Connect(function()
        local tool = Instance.new("Tool")
        tool.Name = "WallBreaker"
        tool.RequiresHandle = false
        tool.Parent = localPlayer.Backpack
        
        tool.Activated:Connect(function()
            local mouse = localPlayer:GetMouse()
            if mouse.Target and not mouse.Target:FindFirstChildOfClass("Humanoid") then
                mouse.Target:Destroy() -- Видаляє те, на що ти клікнув
            end
        end)
        wallBtn.Text = "TOOL ADDED!"
        wait(1)
        wallBtn.Text = "GET WALL BREAKER"
    end)

    -- DASH (E)
    userInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and dashEnabled and input.KeyCode == Enum.KeyCode.E then
            if tick() - lastDash > 1.5 then
                local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then root.Velocity = root.CFrame.LookVector * 150 lastDash = tick() end
            end
        end
    end)

    -- ЦИКЛ ОНОВЛЕННЯ
    runService.RenderStepped:Connect(function()
        local char = localPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        -- FIX BHOP (М'які стрейфи)
        if bhopEnabled and root and hum and userInputService:IsKeyDown(Enum.KeyCode.Space) then
            if hum.FloorMaterial ~= Enum.Material.Air then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            local strafeForce = 1.0 -- Зменшено, щоб не розносило
            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                root.Velocity = root.Velocity + (camera.CFrame.RightVector * -strafeForce)
            elseif userInputService:IsKeyDown(Enum.KeyCode.D) then
                root.Velocity = root.Velocity + (camera.CFrame.RightVector * strafeForce)
            end
            if root.Velocity.Magnitude > 65 then root.Velocity = root.Velocity.Unit * 65 end
        end

        -- ESP (Надійні коробки)
        for _, p in pairs(players:GetPlayers()) do
            if p ~= localPlayer and p.Character then
                local box = p.Character:FindFirstChild("KotomBox")
                if espActive then
                    if not box then
                        box = Instance.new("BoxHandleAdornment", p.Character)
                        box.Name = "KotomBox"; box.Size = p.Character:GetExtentsSize()
                        box.Adornee = p.Character; box.AlwaysOnTop = true
                        box.ZIndex = 5; box.Transparency = 0.6; box.Color3 = Color3.fromRGB(255, 0, 0)
                    end
                elseif box then box:Destroy() end
            end
        end

        -- NO RECOIL
        if noRecoilEnabled then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" and (rawget(v, "Recoil") or rawget(v, "Spread")) then
                    v.Recoil, v.VerticalRecoil, v.HorizontalRecoil, v.Shake, v.Spread = 0,0,0,0,0
                end
            end
        end

        -- SPINBOT
        if antiAimEnabled and root then
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end

        -- AIMBOT
        if aimbotEnabled and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            local target, dist = nil, fovRadius
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
    if keyInput.Text == correctKey then launchHub() else checkBtn.Text = "WRONG KEY" wait(1) checkBtn.Text = "ACTIVATE" end
end)
