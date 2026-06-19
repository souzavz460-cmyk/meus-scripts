-- [[ SZ MODS V3 – Edição Profissional Otimizada ]] --
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- // Serviços do Sistema
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

-- // Referências Locais
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- // Configurações de Estado (Toggles & Valores)
local config = {
    aimbot = false,
    aimForce = 1,
    bypass = 1,
    fovCircle = false,
    fovRainbow = false,
    fovRadius = 150,
    espBox = false,
    espSkel = false,
    showNameHealth = false,
    showMoney = false,
    espItems = false,
    espLines = false,
    infJump = false,
    antiLive = false,
    stealthSpeed = false,
    stealthSpeedValue = 25,
    boxColor = Color3.fromRGB(255, 0, 0),
    skelColor = Color3.fromRGB(255, 255, 255)
}

-- // Armazenamento de Objetos de Renderização (ESP)
local drawingCache = {
    boxes = {},
    skeletons = {},
    nameTags = {},
    healthBars = {},
    rainbowLines = {},
    itemESP = {},
    itemsToESP = {},
    fovCircleObj = nil
}

-- // Utilitários
local function parseColor(input)
    local s = tostring(input):lower():gsub("%s", "")
    local namedColors = {
        vermelho = "ff0000", red = "ff0000", verde = "00ff00", green = "00ff00",
        azul = "0000ff", blue = "0000ff", amarelo = "ffff00", yellow = "ffff00",
        roxo = "800080", purple = "800080", laranja = "ff8800", orange = "ff8800",
        preto = "000000", black = "000000", branco = "ffffff", white = "ffffff",
        rosa = "ff00ff", pink = "ff00ff", ciano = "00ffff", cyan = "00ffff"
    }
    
    s = namedColors[s] or s
    if #s == 6 and s:match("^%x+$") then
        return Color3.fromRGB(
            tonumber(s:sub(1, 2), 16), 
            tonumber(s:sub(3, 4), 16), 
            tonumber(s:sub(5, 6), 16)
        )
    end
    return nil
end

-- // Inicialização da Janela UI
local Window = Rayfield:CreateWindow({
    Name = "SZ MODS V3", 
    LoadingTitle = "SZ MODS",
    LoadingSubtitle = "by Souza",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

-- // Criação Segura de Componentes UI
local function safeCreateTab(name, icon)
    local success, tab = pcall(function() return Window:CreateTab(name, icon) end)
    return success and tab or nil
end

local CombatTab = safeCreateTab("Combate", 4483362458)
local VisualTab = safeCreateTab("Visual", 4483362458)
local CoresTab = safeCreateTab("Cores ESP", 4483362458)
local MovementTab = safeCreateTab("Movimento", 4483362458)
local ConfigTab = safeCreateTab("Config", 4483362458)

local function safeToggle(tab, name, default, callback)
    if not tab then return end
    pcall(function() tab:CreateToggle({ Name = name, CurrentValue = default, Callback = callback }) end)
end

local function safeSlider(tab, name, min, max, default, suffix, flagKey, callback)
    if not tab then return end
    pcall(function() 
        tab:CreateSlider({ 
            Name = name, 
            Range = {min, max}, 
            Increment = 1, 
            CurrentValue = default, 
            Suffix = suffix,
            Flag = flagKey, 
            Callback = callback 
        }) 
    end)
end

local function safeInput(tab, name, placeholder, callback)
    if not tab then return end
    pcall(function() tab:CreateInput({ Name = name, PlaceholderText = placeholder, RemoveTextAfterFocusLost = false, Callback = callback }) end)
end

local function safeButton(tab, name, callback)
    if not tab then return end
    pcall(function() tab:CreateButton({ Name = name, Callback = callback }) end)
end

-- ==================== GERENCIAMENTO DA INTERFACE ====================

-- Aba Combate
safeToggle(CombatTab, "Aimbot", false, function(v) config.aimbot = v end)
safeSlider(CombatTab, "Força (1-Suave, 5-Máxima)", 1, 5, 1, " / 5", "Forca_Ajuste_V3", function(v) config.aimForce = v end)
safeSlider(CombatTab, "Bypass Anti-Cheat (10-Seguro)", 1, 10, 1, " / 10", "Bypass_Ajuste_V3", function(v) config.bypass = v end)

-- Aba Visual
safeToggle(VisualTab, "ESP Box", false, function(v) config.espBox = v end)
safeToggle(VisualTab, "ESP Esqueleto", false, function(v) config.espSkel = v end)
safeToggle(VisualTab, "Nome / Vida / Dinheiro", false, function(v) config.showNameHealth = v end)
safeToggle(VisualTab, "Mostrar Dinheiro", false, function(v) config.showMoney = v end)
safeToggle(VisualTab, "ESP Itens", false, function(v) config.espItems = v end)
safeToggle(VisualTab, "Linhas Arco-íris", false, function(v) config.espLines = v end)
safeToggle(VisualTab, "Círculo FOV", false, function(v) config.fovCircle = v end)
safeToggle(VisualTab, "FOV Arco-íris", false, function(v) config.fovRainbow = v end)
safeSlider(VisualTab, "Raio FOV", 1, 360, 150, " px", "FovRadius_Ajuste_V3", function(v) config.fovRadius = v end)

-- Aba Cores
safeInput(CoresTab, "Cor da Box (ex: vermelho)", "vermelho", function(v) local c = parseColor(v) if c then config.boxColor = c end end)
safeInput(CoresTab, "Cor do Esqueleto (ex: azul)", "branco", function(v) local c = parseColor(v) if c then config.skelColor = c end end)

-- Aba Movimento
safeToggle(MovementTab, "Pulo Infinito", false, function(v) config.infJump = v end)
safeToggle(MovementTab, "Velocidade Disfarçada", false, function(v) config.stealthSpeed = v end)
safeSlider(MovementTab, "Intensidade do Passo", 10, 100, 25, " extra", "StealthSpeed_Ajuste_V3", function(v) config.stealthSpeedValue = v end)

-- Aba Configuração
safeToggle(ConfigTab, "Anti Live", false, function(v) config.antiLive = v end)

-- Limpeza Absoluta de Recursos
local staffFrame
local function cleanupAllResources()
    -- Resetar estados
    for k, _ in pairs(config) do
        if type(config[k]) == "boolean" then config[k] = false end
    end
    
    -- Remover objetos Drawing
    if drawingCache.fovCircleObj then pcall(function() drawingCache.fovCircleObj:Remove() end) end
    for _, box in pairs(drawingCache.boxes) do pcall(function() box:Remove() end) end
    for _, data in pairs(drawingCache.skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
    for _, tag in pairs(drawingCache.nameTags) do pcall(function() tag:Remove() end) end
    for _, bar in pairs(drawingCache.healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
    for _, line in pairs(drawingCache.rainbowLines) do pcall(function() line:Remove() end) end
    for _, obj in pairs(drawingCache.itemESP) do pcall(function() obj:Remove() end) end
    
    -- UI e Janela
    if staffFrame and staffFrame.Parent then pcall(function() staffFrame.Parent:Destroy() end) end
    pcall(function() Window:Destroy() end)
end

safeButton(ConfigTab, "DESTRUIR TUDO", cleanupAllResources)

-- // Inicialização do Mecanismo de Desenho (Drawing API)
local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
if useDrawing then
    pcall(function()
        drawingCache.fovCircleObj = Drawing.new("Circle")
        drawingCache.fovCircleObj.Visible = false
        drawingCache.fovCircleObj.Thickness = 2
        drawingCache.fovCircleObj.Radius = config.fovRadius
        drawingCache.fovCircleObj.Color = Color3.new(1, 1, 1)
        drawingCache.fovCircleObj.Filled = false
    end)
end

-- // Sistema de Scan e Dinheiro
local function getPlayerMoney(plr)
    local ls = plr:FindFirstChild("leaderstats")
    if not ls then return nil end
    
    for _, stat in ipairs(ls:GetChildren()) do
        if (stat:IsA("IntValue") or stat:IsA("NumberValue")) then
            local name = stat.Name:lower()
            if name:find("cash") or name:find("money") or name:find("gold") or name:find("coins") or name:find("dinheiro") then
                return stat.Value
            end
        end
    end
    return nil
end

task.spawn(function()
    local valuableKeywords = {"coin","gold","diamond","gem","money","cash","loot","chest","armor","weapon","sword","gun"}
    while task.wait(2) do
        if config.espItems then
            local tempItems = {}
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "" then
                    local name = part.Name:lower()
                    for _, kw in ipairs(valuableKeywords) do
                        if name:find(kw) then 
                            table.insert(tempItems, part) 
                            break 
                        end
                    end
                end
            end
            drawingCache.itemsToESP = tempItems
        else
            drawingCache.itemsToESP = {}
        end
    end
end)

-- // Algoritmo do Aimbot
local function runAimbotEngine()
    if not config.aimbot then return end
    local center = Camera.ViewportSize / 2
    local enemies = {}
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local chr = p.Character
        if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(chr.Head.Position)
            if onScreen then
                local distFromCrosshair = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if distFromCrosshair <= config.fovRadius then
                    table.insert(enemies, {chr = chr, dist = distFromCrosshair})
                end
            end
        end
    end
    
    if #enemies == 0 then return end
    table.sort(enemies, function(a, b) return a.dist < b.dist end)
    
    local targetCharacter = enemies[1].chr
    local targetPos = targetCharacter.Head.Position
    
    -- Escalonamento da suavidade
    local alphaValues = { [1] = 0.02, [2] = 0.14, [3] = 0.45, [4] = 0.75, [5] = 1.0 }
    local alpha = alphaValues[config.aimForce] or 0.02
    
    if config.bypass > 1 then
        local safetyFactor = (config.bypass / 10)
        if config.bypass == 10 then
            local jitter = Vector3.new(math.sin(tick() * 25) * 0.05, math.cos(tick() * 25) * 0.05, math.sin(tick() * 12) * 0.05)
            targetPos = targetPos + jitter
            if config.aimForce < 5 then 
                alpha = math.clamp(alpha * (1 - safetyFactor * 0.3), 0.01, 0.5) 
            end
        else
            targetPos = targetPos + Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * ((11 - config.bypass) * 0.02)
        end
    end
    
    if alpha >= 1 then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    else
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha)
    end
end

-- // Pipeline de Atualização do ESP
local function renderESPPipeline()
    -- Limpeza preventiva de objetos órfãos
    for p, box in pairs(drawingCache.boxes) do if not p.Parent then pcall(function() box:Remove() end); drawingCache.boxes[p] = nil end end
    for p, data in pairs(drawingCache.skeletons) do if not p.Parent then for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end; drawingCache.skeletons[p] = nil end end
    for p, tag in pairs(drawingCache.nameTags) do if not p.Parent then pcall(function() tag:Remove() end); drawingCache.nameTags[p] = nil end end
    for p, bar in pairs(drawingCache.healthBars) do if not p.Parent then pcall(function() bar.bg:Remove(); bar.fill:Remove() end); drawingCache.healthBars[p] = nil end end
    for p, line in pairs(drawingCache.rainbowLines) do if not p.Parent then pcall(function() line:Remove() end); drawingCache.rainbowLines[p] = nil end end
    for part, obj in pairs(drawingCache.itemESP) do if not part.Parent then pcall(function() obj:Remove() end); drawingCache.itemESP[part] = nil end end

    if config.espItems and useDrawing then
        for _, part in ipairs(drawingCache.itemsToESP) do
            if part.Parent then
                if not drawingCache.itemESP[part] then
                    pcall(function()
                        local circle = Drawing.new("Circle")
                        circle.Radius = 5; circle.Color = Color3.new(1, 1, 0); circle.Filled = true
                        drawingCache.itemESP[part] = circle
                    end)
                end
                if drawingCache.itemESP[part] then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then 
                        drawingCache.itemESP[part].Position = Vector2.new(pos.X, pos.Y)
                        drawingCache.itemESP[part].Visible = true
                    else 
                        drawingCache.itemESP[part].Visible = false 
                    end
                end
            end
        end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then continue end
        
        local hum = char:FindFirstChild("Humanoid")
        local health = hum and hum.Health or 0
        local maxHealth = hum and hum.MaxHealth or 100
        if not hum or health <= 0 then continue end

        -- Renderizar Box ESP
        if config.espBox and useDrawing then
            local top = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 1.5, 0))
            local bot = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
            if top and bot then
                local h = math.abs(top.Y - bot.Y)
                local w = h * 0.45
                local cx = (top.X + bot.X) / 2
                
                if not drawingCache.boxes[p] then 
                    pcall(function() drawingCache.boxes[p] = Drawing.new("Square"); drawingCache.boxes[p].Thickness = 2; drawingCache.boxes[p].Filled = false end) 
                end
                if drawingCache.boxes[p] then 
                    drawingCache.boxes[p].Position = Vector2.new(cx - w/2, top.Y)
                    drawingCache.boxes[p].Size = Vector2.new(w, h)
                    drawingCache.boxes[p].Color = config.boxColor
                    drawingCache.boxes[p].Visible = true 
                end
            end
        end

        -- Renderizar Esqueleto ESP
        if config.espSkel and useDrawing then
            if not drawingCache.skeletons[p] then
                drawingCache.skeletons[p] = {}
                local bonePairs = {
                    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
                    {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
                    {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},
                    {"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},
                    {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"}
                }
                for i, pair in ipairs(bonePairs) do
                    local a, b = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
                    if a and b then 
                        pcall(function() 
                            local line = Drawing.new("Line")
                            line.Thickness = 1
                            drawingCache.skeletons[p][i] = {line = line, a = a, b = b} 
                        end) 
                    end
                end
            end
            for _, data in ipairs(drawingCache.skeletons[p]) do
                local aPos, aVis = Camera:WorldToViewportPoint(data.a.Position)
                local bPos, bVis = Camera:WorldToViewportPoint(data.b.Position)
                if aVis and bVis then 
                    data.line.From = Vector2.new(aPos.X, aPos.Y)
                    data.line.To = Vector2.new(bPos.X, bPos.Y)
                    data.line.Color = config.skelColor
                    data.line.Visible = true
                else 
                    data.line.Visible = false 
                end
            end
        end

        -- Renderizar Textos/Tags
        if config.showNameHealth and useDrawing then
            local headPos, onScreen = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 1.5, 0))
            if onScreen then
                local moneyStr = ""
                if config.showMoney then 
                    local money = getPlayerMoney(p) 
                    if money then moneyStr = " $" .. money end 
                end
                
                local textStr = string.format("%s [%d/%d]%s", p.Name, math.floor(health), math.floor(maxHealth), moneyStr)
                if not drawingCache.nameTags[p] then 
                    pcall(function() 
                        drawingCache.nameTags[p] = Drawing.new("Text")
                        drawingCache.nameTags[p].Center = true
                        drawingCache.nameTags[p].Size = 14
                        drawingCache.nameTags[p].Outline = true
                        drawingCache.nameTags[p].OutlineColor = Color3.new(0,0,0) 
                    end) 
                end
                if drawingCache.nameTags[p] then 
                    drawingCache.nameTags[p].Text = textStr
                    drawingCache.nameTags[p].Position = Vector2.new(headPos.X, headPos.Y - 10)
                    drawingCache.nameTags[p].Color = Color3.new(1,1,1)
                    drawingCache.nameTags[p].Visible = true 
                end
            end
        end
    end

    -- Atualização do Círculo do FOV
    if drawingCache.fovCircleObj then
        drawingCache.fovCircleObj.Position = Camera.ViewportSize / 2
        drawingCache.fovCircleObj.Radius = config.fovRadius
        drawingCache.fovCircleObj.Visible = config.fovCircle
        if config.fovCircle and config.fovRainbow then 
            drawingCache.fovCircleObj.Color = Color3.fromHSV((tick() % 5) / 5, 1, 1) 
        else 
            drawingCache.fovCircleObj.Color = Color3.new(1, 1, 1) 
        end
    end
end

-- // Contador de Staff Movel
local function updateStaffCounter()
    if not staffFrame then return end
    local count = 0
    local staffKeywords = {"staff","admin","mod","helper","owner","dev","gerente","moderador"}
    
    for _, p in ipairs(Players:GetPlayers()) do
        local name = p.Name:lower()
        for _, kw in ipairs(staffKeywords) do
            if name:find(kw) then count = count + 1 break end
        end
    end
    staffFrame.Text = "Staff: " .. count
end

task.delay(1, function()
    local staffGui = Instance.new("ScreenGui", CoreGui)
    staffGui.Name = "StaffCounter"
    staffGui.ResetOnSpawn = false
    
    staffFrame = Instance.new("TextButton", staffGui)
    staffFrame.Size = UDim2.new(0, 80, 0, 30)
    staffFrame.Position = UDim2.new(0.8, -40, 0.1, 0)
    staffFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    staffFrame.BorderSizePixel = 0
    staffFrame.Text = "Staff: 0"
    staffFrame.TextColor3 = Color3.new(0, 1, 0)
    staffFrame.Font = Enum.Font.SourceSansBold
    staffFrame.TextSize = 14
    staffFrame.AutoButtonColor = false
    Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0, 4)
    updateStaffCounter()

    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        staffFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    staffFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = staffFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    
    staffFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end)

-- // Evento de Pulo Infinito
UserInputService.JumpRequest:Connect(function()
    if config.infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- // Loop Principal Unificado (RenderStepped)
local lastLiveCheck = 0
RunService.RenderStepped:Connect(function(deltaTime)
    runAimbotEngine()
    renderESPPipeline()
    updateStaffCounter()
    
    -- Sistema de Movimentação Stealth
    if config.stealthSpeed and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and hrp and humanoid.MoveDirection.Magnitude > 0 then
            local factor = (config.stealthSpeedValue / 10)
            hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * factor * deltaTime * 35)
        end
    end

    -- Sistema de Segurança Anti-Live
    if config.antiLive and (tick() - lastLiveCheck > 1) then
        lastLiveCheck = tick()
        Window.Enabled = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
    end
end)

-- // Hook de Destruição do Script
script.Destroying:Connect(cleanupAllResources)
