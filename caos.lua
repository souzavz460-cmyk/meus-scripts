-- SZ MODS RAIZ – Aimbot suave, Wallshot seguro (sem noclip), ESP funcional
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variáveis
local aimbot = false
local aimForce = 1          -- 1 (suave) a 5 (lock)
local espBox = false
local espSkel = false
local fovShow = false
local fovRainbow = false
local fovRadius = 150
local wallshot = false

-- Desenhos
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Radius = fovRadius
fovCircle.Color = Color3.fromRGB(255,255,255)
fovCircle.Filled = false
fovCircle.Position = Camera.ViewportSize / 2

local boxes = {}
local skeletons = {}

-- ==================== WALLSHOT SEGURO (SEM NOCLIP) ====================
local function isProjectile(part)
    if not part:IsA("BasePart") then return false end
    -- Nunca mexa com partes de algum personagem (evita noclip)
    local parent = part.Parent
    while parent do
        if parent:IsA("Model") and Players:GetPlayerFromCharacter(parent) then
            return false
        end
        parent = parent.Parent
    end
    -- Verifica velocidade alta (projétil verdadeiro)
    if part.Velocity.Magnitude > 25 then return true end
    -- Verifica nome comum de projétil
    local name = part.Name:lower()
    local keywords = {"bullet","projectile","pellet","arrow","bolt","rocket","grenade","ball","shell","kunai","shuriken","missile","blast","beam"}
    for _, kw in ipairs(keywords) do
        if name:find(kw) then return true end
    end
    return false
end

local function disableCollisions(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.CanCollide = false
            obj.CanQuery = false
        end
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanCollide = false
                child.CanQuery = false
            end
        end
    end)
end

local whConnection
local function enableWallshot()
    wallshot = true
    -- Desativa colisão das ferramentas atuais do jogador (apenas ferramentas, não o corpo)
    local char = Player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                disableCollisions(tool)
            end
        end
    end
    -- Varre projéteis já existentes
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isProjectile(obj) then
            disableCollisions(obj)
        end
    end
    -- Evento para novos projéteis
    if not whConnection then
        whConnection = Workspace.DescendantAdded:Connect(function(obj)
            if wallshot and isProjectile(obj) then
                task.wait(0.05)
                disableCollisions(obj)
            end
        end)
    end
end

local function disableWallshot()
    wallshot = false
    if whConnection then
        whConnection:Disconnect()
        whConnection = nil
    end
end

-- ==================== AIMBOT SUAVE ====================
local function getEnemiesInFOV()
    local center = Camera.ViewportSize / 2
    local enemies = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Head") then continue end
        local hum = char:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local headPos, onScreen = Camera:WorldToViewportPoint(char.Head.Position)
        if not onScreen then continue end
        local screenPos = Vector2.new(headPos.X, headPos.Y)
        local dist = (center - screenPos).Magnitude
        if dist <= fovRadius then
            table.insert(enemies, {player = p, dist = dist, worldPos = char.Head.Position})
        end
    end
    table.sort(enemies, function(a,b) return a.dist < b.dist end)
    return enemies
end

local function aimbotStep()
    if not aimbot then return end
    local enemies = getEnemiesInFOV()
    if #enemies == 0 then return end
    local targetPos = enemies[1].worldPos

    -- Força: 1 = suave (0.02), 5 = lock (1.0)
    local alpha = 0.02 + (aimForce - 1) * 0.245
    if alpha > 1.0 then alpha = 1.0 end

    local newCF = CFrame.new(Camera.CFrame.Position, targetPos)
    if alpha < 1 then
        Camera.CFrame = Camera.CFrame:Lerp(newCF, alpha)
    else
        Camera.CFrame = newCF
    end
end

-- ==================== ESP BOX ====================
local function getCharBounds(char)
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not head or not root then return nil end
    local topWorld = head.Position + Vector3.new(0, 1.5, 0)
    local bottomWorld = root.Position - Vector3.new(0, 3, 0)
    local topScr, topVis = Camera:WorldToViewportPoint(topWorld)
    local botScr, botVis = Camera:WorldToViewportPoint(bottomWorld)
    if not topVis or not botVis then return nil end
    local h = math.abs(topScr.Y - botScr.Y)
    local w = h * 0.45
    local cx = (topScr.X + botScr.X) / 2
    return {
        Position = Vector2.new(cx - w/2, topScr.Y),
        Size = Vector2.new(w, h)
    }
end

-- ==================== ESP ESQUELETO ====================
local function getBones(char)
    local bones = {}
    -- Motor6D / Bone
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("Motor6D") or obj:IsA("Bone") then
            local a, b = obj.Part0, obj.Part1
            if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
                table.insert(bones, {a, b})
            end
        end
    end
    -- Fallback R6/R15
    if #bones == 0 then
        local pairs = {
            {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
            {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
            {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
            {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
            {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
            {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"},
            {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        }
        for _, pair in ipairs(pairs) do
            local a = char:FindFirstChild(pair[1])
            local b = char:FindFirstChild(pair[2])
            if a and b then table.insert(bones, {a, b}) end
        end
    end
    return bones
end

local function updateESP()
    -- Limpeza
    for p, box in pairs(boxes) do
        if not p.Parent then box:Remove(); boxes[p] = nil end
    end
    for p, data in pairs(skeletons) do
        if not p.Parent then
            for _, d in ipairs(data) do d.line:Remove() end
            skeletons[p] = nil
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Head") then
            if boxes[p] then boxes[p]:Remove(); boxes[p] = nil end
            if skeletons[p] then for _, d in ipairs(skeletons[p]) do d.line:Remove() end; skeletons[p] = nil end
            continue
        end
        local hum = char:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            if boxes[p] then boxes[p].Visible = false end
            if skeletons[p] then for _, d in ipairs(skeletons[p]) do d.line.Visible = false end end
            continue
        end

        -- Box
        if espBox then
            local bounds = getCharBounds(char)
            if bounds then
                if not boxes[p] then
                    local box = Drawing.new("Square")
                    box.Thickness = 2; box.Color = Color3.fromRGB(255,0,0); box.Filled = false
                    boxes[p] = box
                end
                boxes[p].Position = bounds.Position; boxes[p].Size = bounds.Size; boxes[p].Visible = true
            else
                if boxes[p] then boxes[p].Visible = false end
            end
        else
            if boxes[p] then boxes[p]:Remove(); boxes[p] = nil end
        end

        -- Esqueleto
        if espSkel then
            if not skeletons[p] then
                skeletons[p] = {}
                local bones = getBones(char)
                for i, parts in ipairs(bones) do
                    local line = Drawing.new("Line")
                    line.Thickness = 1; line.Color = Color3.fromRGB(255,255,255)
                    skeletons[p][i] = {line = line, a = parts[1], b = parts[2]}
                end
            end
            for _, data in ipairs(skeletons[p]) do
                local line, a, b = data.line, data.a, data.b
                if a and b and a.Parent and b.Parent then
                    local aPos, aVis = Camera:WorldToViewportPoint(a.Position)
                    local bPos, bVis = Camera:WorldToViewportPoint(b.Position)
                    if aVis and bVis then
                        line.From = Vector2.new(aPos.X, aPos.Y); line.To = Vector2.new(bPos.X, bPos.Y)
                        line.Visible = true
                    else line.Visible = false end
                else line.Visible = false end
            end
        else
            if skeletons[p] then for _, d in ipairs(skeletons[p]) do d.line:Remove() end; skeletons[p] = nil end
        end
    end
end

-- ==================== FOV ====================
local function updateFOV()
    fovCircle.Position = Camera.ViewportSize / 2
    fovCircle.Radius = fovRadius
    fovCircle.Visible = fovShow
    if fovShow and fovRainbow then
        fovCircle.Color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
    else
        fovCircle.Color = Color3.fromRGB(255,255,255)
    end
end

-- ==================== INTERFACE (BOTÃO PRETO "+") ====================
local gui = Instance.new("ScreenGui")
gui.Name = "SZ"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 50, 0, 50)
btn.Position = UDim2.new(0.8, -25, 0.5, -25)
btn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = "+"
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 30
btn.BorderSizePixel = 0
btn.Parent = gui
Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 220, 0, 380)
menu.Position = UDim2.new(0.5, -110, 0.5, -190)
menu.BackgroundColor3 = Color3.new(0.8, 0.1, 0.1)
menu.BorderSizePixel = 0
menu.Visible = false
menu.Parent = gui

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 5)
close.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
close.TextColor3 = Color3.new(1, 1, 1)
close.Text = "X"
close.Font = Enum.Font.SourceSansBold
close.TextSize = 18
close.Parent = menu
Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)

local function addToggle(y, name, default, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 120, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = menu

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 50, 0, 30)
    sw.Position = UDim2.new(0, 140, 0, y)
    sw.BackgroundColor3 = default and Color3.new(0, 0.8, 0) or Color3.new(0.8, 0, 0)
    sw.Text = default and "ON" or "OFF"
    sw.TextColor3 = Color3.new(1, 1, 1)
    sw.Font = Enum.Font.SourceSansBold
    sw.TextSize = 12
    sw.Parent = menu
    Instance.new("UICorner", sw).CornerRadius = UDim.new(0, 4)

    local state = default
    sw.Activated:Connect(function()
        state = not state
        sw.BackgroundColor3 = state and Color3.new(0, 0.8, 0) or Color3.new(0.8, 0, 0)
        sw.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function addSlider(y, name, min, max, default, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 16)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": " .. default
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = menu

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, -20, 0, 16)
    bar.Position = UDim2.new(0, 10, 0, y + 18)
    bar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    bar.Text = ""
    bar.Parent = menu
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.new(0, 0.6, 1)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)

    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        lbl.Text = name .. ": " .. val
        callback(val)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            update(input)
            local conn
            conn = UserInputService.InputChanged:Connect(function(ch)
                if ch.UserInputType == Enum.UserInputType.Touch or ch.UserInputType == Enum.UserInputType.MouseMovement then
                    update(ch)
                end
            end)
            UserInputService.InputEnded:Connect(function(ev)
                if ev.UserInputType == Enum.UserInputType.Touch or ev.UserInputType == Enum.UserInputType.MouseButton1 then
                    conn:Disconnect()
                end
            end)
        end
    end)
end

-- Preencher opções
local y = 35
addToggle(y, "Wallshot", false, function(v) if v then enableWallshot() else disableWallshot() end end)
y = y + 35
addToggle(y, "Aimbot", false, function(v) aimbot = v end)
y = y + 35
addSlider(y, "Força", 1, 5, aimForce, function(v) aimForce = v end)
y = y + 38
addToggle(y, "ESP Box", false, function(v) espBox = v end)
y = y + 35
addToggle(y, "ESP Esqueleto", false, function(v) espSkel = v end)
y = y + 35
addToggle(y, "Círculo FOV", false, function(v) fovShow = v end)
y = y + 35
addToggle(y, "FOV Arco-íris", false, function(v) fovRainbow = v end)
y = y + 35
addSlider(y, "Raio FOV", 50, 500, fovRadius, function(v) fovRadius = v end)

-- Ações dos botões
btn.Activated:Connect(function() menu.Visible = not menu.Visible end)
close.Activated:Connect(function() menu.Visible = false end)

-- Arrastar botão
local drag = false
local startPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
        startPos = input.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.Change then
                local delta = input.Position - startPos
                if delta.Magnitude > 8 then
                    drag = true
                    btn.Position = UDim2.new(0, input.Position.X - 25, 0, input.Position.Y - 25)
                end
            end
        end)
    end
end)

-- Loop principal
RunService.RenderStepped:Connect(function()
    aimbotStep()
    updateESP()
    updateFOV()
end)

-- Limpeza
gui.Destroying:Connect(function()
    disableWallshot()
    fovCircle:Remove()
    for _, box in pairs(boxes) do box:Remove() end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do d.line:Remove() end end
end)

print("SZ MODS carregado – sem noclip, aimbot suave, Wallshot seguro.")
