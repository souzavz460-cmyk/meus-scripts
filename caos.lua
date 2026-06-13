--[[
    Apkmod SZ | by Souza mods — Final
    Interface Roxa, FOV sem círculo, Antena no braço
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Configurações
local AimbotEnabled = false
local AimbotTarget = "Head"
local AimbotLegit = false
local HitChestFirst = false
local AutoShot = false
local TargetTeam = "Todos"
local ESPEnabled = false
local ESPNameEnabled = false
local AntennaEnabled = false
local ModColor = Color3.fromRGB(150, 0, 255)
local ESPColor = Color3.fromRGB(150, 0, 255)
local FovDistance = 200  -- FOV em pixels (sem círculo)

local Teams = {
    ["Todos"] = nil,
    ["Criminal"] = BrickColor.new("Bright red").Color,
    ["Polícia"] = BrickColor.new("Bright blue").Color,
    ["Ladrão"] = BrickColor.new("Bright green").Color
}

-- ========== FUNÇÕES DE VALIDAÇÃO ==========
local function isValidTarget(player)
    if TargetTeam == "Todos" then return true end
    return player.Team and player.Team.TeamColor.Color == Teams[TargetTeam]
end

-- ========== INTERFACE ==========
local UI = Instance.new("ScreenGui")
UI.Name = "ApkmodSZ"
UI.ResetOnSpawn = false
UI.Parent = CoreGui

-- Animação de abertura
local intro = Instance.new("Frame")
intro.Size = UDim2.new(1, 0, 1, 0)
intro.BackgroundColor3 = Color3.new(0, 0, 0)
intro.BackgroundTransparency = 1
intro.Parent = UI

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(0, 300, 0, 50)
introText.Position = UDim2.new(0.5, -150, 0.5, -25)
introText.BackgroundTransparency = 1
introText.Text = "Apkmod SZ | by Souza mods"
introText.TextColor3 = ModColor
introText.Font = Enum.Font.GothamBold
introText.TextSize = 24
introText.Parent = intro

coroutine.wrap(function()
    for i = 1, 10 do
        intro.BackgroundTransparency = 1 - (i / 10)
        introText.TextTransparency = 1 - (i / 10)
        task.wait(0.03)
    end
    task.wait(1)
    for i = 1, 10 do
        intro.BackgroundTransparency = i / 10
        introText.TextTransparency = i / 10
        task.wait(0.03)
    end
    intro:Destroy()
end)()

-- Janela principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 330)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -165)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = UI
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Título
local titleBar = Instance.new("TextButton")
titleBar.Size = UDim2.new(1, -40, 0, 35)
titleBar.BackgroundColor3 = ModColor
titleBar.Text = "Apkmod SZ | by Souza mods"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 14
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

-- Arrasto
local dragging, dragStart, frameStart
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

-- Minimizar
local minimized = false
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 35)
minimizeBtn.Position = UDim2.new(1, -40, 0, 0)
minimizeBtn.BackgroundColor3 = ModColor
minimizeBtn.Text = "–"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = mainFrame
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    contentFrame.Visible = not minimized
    minimizeBtn.Text = minimized and "+" or "–"
    mainFrame.Size = minimized and UDim2.new(0, 250, 0, 35) or UDim2.new(0, 250, 0, 330)
end)

-- Abas
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 30)
tabBar.Position = UDim2.new(0, 0, 0, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabBar.BorderSizePixel = 0
tabBar.Parent = contentFrame

local tabs = {}
local tabButtons = {}
local currentTab = nil

local function switchTab(tabName)
    for _, tab in pairs(tabs) do
        tab.Visible = false
    end
    if tabs[tabName] then
        tabs[tabName].Visible = true
        currentTab = tabName
    end
    for _, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
    if tabButtons[tabName] then
        tabButtons[tabName].BackgroundColor3 = ModColor
    end
end

local function createTab(name, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, position * 80, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = tabBar
    tabButtons[name] = btn

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -30)
    scroll.Position = UDim2.new(0, 0, 0, 30)
    scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new(0, 0, 0, 300)
    scroll.Visible = false
    scroll.Parent = contentFrame
    tabs[name] = scroll

    btn.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
    return scroll
end

local exploitTab = createTab("Exploit", 0)
local espTab = createTab("ESP", 1)
local miscTab = createTab("Misc", 2)
switchTab("Exploit")

-- Controles genéricos
local function createToggle(parent, text, y, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 22)
    btn.Position = UDim2.new(0.75, 0, 0.5, -11)
    btn.BackgroundColor3 = default and ModColor or Color3.fromRGB(80, 80, 80)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.Parent = frame

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and ModColor or Color3.fromRGB(80, 80, 80)
        callback(state)
    end)
end

local function createDropdown(parent, name, options, default, y, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = frame

    local idx = table.find(options, default) or 1
    local currentOption = options[idx]
    local displayBtn = Instance.new("TextButton")
    displayBtn.Size = UDim2.new(0, 80, 0, 22)
    displayBtn.Position = UDim2.new(0.45, 0, 0.5, -11)
    displayBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    displayBtn.Text = currentOption
    displayBtn.TextColor3 = Color3.new(1, 1, 1)
    displayBtn.Font = Enum.Font.GothamBold
    displayBtn.TextSize = 12
    displayBtn.BorderSizePixel = 0
    Instance.new("UICorner", displayBtn).CornerRadius = UDim.new(0, 4)
    displayBtn.Parent = frame

    displayBtn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        currentOption = options[idx]
        displayBtn.Text = currentOption
        callback(currentOption)
    end)
end

local function createSlider(parent, name, min, max, default, y, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = frame

    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 30, 0, 22)
    minusBtn.Position = UDim2.new(0.6, 0, 0.5, -11)
    minusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    minusBtn.Text = "-"
    minusBtn.TextColor3 = Color3.new(1, 1, 1)
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 14
    minusBtn.BorderSizePixel = 0
    Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4)
    minusBtn.Parent = frame

    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 30, 0, 22)
    plusBtn.Position = UDim2.new(0.75, 0, 0.5, -11)
    plusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    plusBtn.Text = "+"
    plusBtn.TextColor3 = Color3.new(1, 1, 1)
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 14
    plusBtn.BorderSizePixel = 0
    Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4)
    plusBtn.Parent = frame

    local currentValue = default
    minusBtn.MouseButton1Click:Connect(function()
        currentValue = math.max(min, currentValue - 5)
        label.Text = name .. ": " .. currentValue
        callback(currentValue)
    end)
    plusBtn.MouseButton1Click:Connect(function()
        currentValue = math.min(max, currentValue + 5)
        label.Text = name .. ": " .. currentValue
        callback(currentValue)
    end)
end

-- Preencher Exploit
createToggle(exploitTab, "Aimbot", 10, false, function(v) AimbotEnabled = v end)
createDropdown(exploitTab, "Alvo", {"Head", "Neck", "Chest"}, "Head", 50, function(v) AimbotTarget = v end)
createToggle(exploitTab, "Aimbot Legit", 90, false, function(v) AimbotLegit = v end)
createToggle(exploitTab, "Hit no Peito", 130, false, function(v) HitChestFirst = v end)
createSlider(exploitTab, "FOV Distance", 50, 400, 200, 170, function(v) FovDistance = v end)
createToggle(exploitTab, "Auto Shot", 210, false, function(v) AutoShot = v end)
createDropdown(exploitTab, "Time", {"Todos", "Criminal", "Polícia", "Ladrão"}, "Todos", 250, function(v) TargetTeam = v end)

-- ESP
createToggle(espTab, "ESP Player", 10, false, function(v) ESPEnabled = v end)
createToggle(espTab, "ESP Name", 50, false, function(v) ESPNameEnabled = v end)
createToggle(espTab, "Antena (Braço)", 90, false, function(v) AntennaEnabled = v end)

-- Misc
createDropdown(miscTab, "Cor do Mod", {"Roxo", "Vermelho", "Verde"}, "Roxo", 10, function(v)
    if v == "Roxo" then ModColor = Color3.fromRGB(150, 0, 255)
    elseif v == "Vermelho" then ModColor = Color3.fromRGB(255, 0, 0)
    elseif v == "Verde" then ModColor = Color3.fromRGB(0, 255, 0) end
    titleBar.BackgroundColor3 = ModColor
    minimizeBtn.BackgroundColor3 = ModColor
    if tabButtons[currentTab] then tabButtons[currentTab].BackgroundColor3 = ModColor end
end)
createDropdown(miscTab, "Cor da ESP", {"Roxo", "Vermelho", "Verde"}, "Roxo", 50, function(v)
    if v == "Roxo" then ESPColor = Color3.fromRGB(150, 0, 255)
    elseif v == "Vermelho" then ESPColor = Color3.fromRGB(255, 0, 0)
    elseif v == "Verde" then ESPColor = Color3.fromRGB(0, 255, 0) end
end)

-- Anti-remoção
UI.Destroying:Connect(function()
    pcall(function()
        local newUI = Instance.new("ScreenGui")
        newUI.Name = "ApkmodSZ"
        newUI.Parent = CoreGui
        mainFrame.Parent = newUI
    end)
end)

-- ========== AIMBOT ==========
coroutine.wrap(function()
    while true do
        if AimbotEnabled then
            local center = Camera.ViewportSize / 2
            local nearestDist = FovDistance
            local targetChar = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and isValidTarget(player) then
                    local head = player.Character:FindFirstChild("Head")
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    if head and hum and hum.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                targetChar = player.Character
                            end
                        end
                    end
                end
            end
            if targetChar then
                local part
                if HitChestFirst then
                    part = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso")
                elseif AimbotTarget == "Head" then
                    part = targetChar:FindFirstChild("Head")
                elseif AimbotTarget == "Neck" then
                    local torso = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso")
                    local head = targetChar:FindFirstChild("Head")
                    if torso and head then
                        part = {Position = (torso.Position + head.Position) / 2}
                    end
                elseif AimbotTarget == "Chest" then
                    part = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso")
                end
                if part then
                    local lookAt = CFrame.new(Camera.CFrame.Position, part.Position)
                    Camera.CFrame = AimbotLegit and Camera.CFrame:Lerp(lookAt, 0.2) or lookAt
                    if AutoShot then
                        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then tool:Activate() end
                    end
                end
            end
        end
        task.wait()
    end
end)()

-- ========== ESP E ANTENA ==========
local drawings = {}
local useDrawing = pcall(function() return Drawing.new end)

local function clearESP()
    for _, d in pairs(drawings) do
        pcall(function() d:Remove() end)
    end
    drawings = {}
end

local function updateESP()
    clearESP()
    if not (ESPEnabled or ESPNameEnabled or AntennaEnabled) then return end
    if not useDrawing then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isValidTarget(player) then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if head and root and hum and hum.Health > 0 then
                local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    if ESPEnabled then
                        local rootPos = Camera:WorldToViewportPoint(root.Position)
                        local box = Drawing.new("Square")
                        box.Visible = true
                        box.Color = ESPColor
                        box.Thickness = 1.5
                        box.Filled = false
                        box.Size = Vector2.new(40, 60)
                        box.Position = Vector2.new(rootPos.X - 20, rootPos.Y - 60)
                        table.insert(drawings, box)
                    end
                    if ESPNameEnabled then
                        local nameText = Drawing.new("Text")
                        nameText.Visible = true
                        nameText.Color = ESPColor
                        nameText.Size = 13
                        nameText.Position = Vector2.new(headPos.X, headPos.Y - 40)
                        nameText.Text = player.Name
                        nameText.Center = true
                        table.insert(drawings, nameText)
                    end
                    if AntennaEnabled then
                        local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                        if rightArm then
                            local armPos, armOnScreen = Camera:WorldToViewportPoint(rightArm.Position)
                            if armOnScreen then
                                local line = Drawing.new("Line")
                                line.Visible = true
                                line.Color = ESPColor
                                line.Thickness = 2
                                line.From = Vector2.new(armPos.X, armPos.Y)
                                line.To = Vector2.new(armPos.X, armPos.Y - 250)
                                table.insert(drawings, line)
                            end
                        end
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

-- Respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
end)

print("Apkmod SZ | by Souza mods — Pronto! FOV interno, antena no braço.")
