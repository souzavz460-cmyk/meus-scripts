-- [[ SZ MODS V4 – Edição Avançada & Correção Global de ESP ]] --
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
    topLines = false, -- Nova função da Imagem
    infJump = false,
    antiLive = false,
    stealthSpeed = false,
    stealthSpeedValue = 25,
    advancedFly = false, -- Novo Fly Avançado
    flySpeed = 30,
    boxColor = Color3.fromRGB(255, 0, 0),
    skelColor = Color3.fromRGB(255, 255, 255)
}

-- // Armazenamento de Objetos de Renderização (ESP)
local drawingCache = {
    boxes = {},
    skeletons = {},
    nameTags = {},
    itemESP = {},
    itemsToESP = {},
    topTracers = {},
    topTextObj = nil,
    fovCircleObj = nil
}

-- // Utilitários de Cor
local function parseColor(input)
    local s = tostring(input):lower():gsub("%s", "")
    local namedColors = {
        vermelho = "ff0000", red = "ff0000", verde = "00ff00", green = "00ff00",
        azul = "0000ff", blue = "0000ff", amarelo = "ffff00", yellow = "ffff00",
        roxo = "800080", purple = "800080", laranja = "ff8800", orange = "ff8800",
        preto = "000000", black = "000000", branco = "ffffff", white = "ffffff"
    }
    s = namedColors[s] or s
    if #s == 6 and s:match("^%x+$") then
        return Color3.fromRGB(tonumber(s:sub(1, 2), 16), tonumber(s:sub(3, 4), 16), tonumber(s:sub(5, 6), 16))
    end
    return nil
end

-- // Inicialização da Janela UI
local Window = Rayfield:CreateWindow({
    Name = "SZ MODS V4", 
    LoadingTitle = "SZ SYSTEM OTIMIZADO",
    LoadingSubtitle = "by Souza",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local CombatTab = Window:CreateTab("Combate", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local CoresTab = Window:CreateTab("Cores ESP", 4483362458)
local MovementTab = Window:CreateTab("Movimento", 4483362458)
local ConfigTab = Window:CreateTab("Config", 4483362458)

-- ==================== GERENCIAMENTO DA INTERFACE ====================

-- Aba Combate
CombatTab:CreateToggle({ Name = "Aimbot", CurrentValue = false, Callback = function(v) config.aimbot = v end })
CombatTab:CreateSlider({ Name = "Força (1-Suave, 5-Máxima)", Range = {1, 5}, Increment = 1, CurrentValue = 1, Suffix = " / 5", Flag = "Forca_V4", Callback = function(v) config.aimForce = v end })
CombatTab:CreateSlider({ Name = "Bypass Anti-Cheat", Range = {1, 10}, Increment = 1, CurrentValue = 1, Suffix = " / 10", Flag = "Bypass_V4", Callback = function(v) config.bypass = v end })

-- Aba Visual (Com correções e nova função da foto)
VisualTab:CreateToggle({ Name = "ESP Box (Universal)", CurrentValue = false, Callback = function(v) config.espBox = v end })
VisualTab:CreateToggle({ Name = "ESP Esqueleto (R6 / R15)", CurrentValue = false, Callback = function(v) config.espSkel = v end })
VisualTab:CreateToggle({ Name = "Tracers do Topo (Estilo Imagem)", CurrentValue = false, Callback = function(v) config.topLines = v end })
VisualTab:CreateToggle({ Name = "Nome / Vida / Dinheiro", CurrentValue = false, Callback = function(v) config.showNameHealth = v end })
VisualTab:CreateToggle({ Name = "Mostrar Dinheiro", CurrentValue = false, Callback = function(v) config.showMoney = v end })
VisualTab:CreateToggle({ Name = "ESP Itens Valiosos", CurrentValue = false, Callback = function(v) config.espItems = v end })
VisualTab:CreateToggle({ Name = "Círculo FOV", CurrentValue = false, Callback = function(v) config.fovCircle = v end })
VisualTab:CreateToggle({ Name = "FOV Arco-íris", CurrentValue = false, Callback = function(v) config.fovRainbow = v end })
VisualTab:CreateSlider({ Name = "Raio FOV", Range = {1, 360}, Increment = 1, CurrentValue = 150, Suffix = " px", Flag = "Fov_V4", Callback = function(v) config.fovRadius = v end })

-- Aba Cores
CoresTab:CreateInput({ Name = "Cor da Box", PlaceholderText = "vermelho", RemoveTextAfterFocusLost = false, Callback = function(v) local c = parseColor(v) if c then config.boxColor = c end end })
CoresTab:CreateInput({ Name = "Cor do Esqueleto", PlaceholderText = "branco", RemoveTextAfterFocusLost = false, Callback = function(v) local c = parseColor(v) if c then config.skelColor = c end end })

-- Aba Movimento (Com o novo Fly Avançado Stealth)
MovementTab:CreateToggle({ Name = "Fly Avançado (Simula Caminhada)", CurrentValue = false, Callback = function(v) config.advancedFly = v end })
MovementTab:CreateSlider({ Name = "Velocidade do Fly", Range = {10, 150}, Increment = 1, CurrentValue = 30, Suffix = " studs", Flag = "FlySpeed_V4", Callback = function(v) config.flySpeed = v end })
MovementTab:CreateToggle({ Name = "Velocidade Disfarçada (CFrame)", CurrentValue = false, Callback = function(v) config.stealthSpeed = v end })
MovementTab:CreateSlider({ Name = "Intensidade do Passo", Range = {10, 100}, Increment = 1, CurrentValue = 25, Suffix = " extra", Flag = "Stealth_V4", Callback = function(v) config.stealthSpeedValue = v end })
MovementTab:CreateToggle({ Name = "Pulo Infinito", CurrentValue = false, Callback = function(v) config.infJump = v end })

-- Aba Configuração
ConfigTab:CreateToggle({ Name = "Anti Live", CurrentValue = false, Callback = function(v) config.antiLive = v end })

-- // Limpeza Total de Recursos
local function cleanupAllResources()
    if drawingCache.fovCircleObj then pcall(function() drawingCache.fovCircleObj:Remove() end) end
    if drawingCache.topTextObj then pcall(function() drawingCache.topTextObj:Remove() end) end
    for _, box in pairs(drawingCache.boxes) do pcall(function() box:Remove() end) end
    for _, data in pairs(drawingCache.skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
    for _, tag in pairs(drawingCache.nameTags) do pcall(function() tag:Remove() end) end
    for _, line in pairs(drawingCache.topTracers) do pcall(function() line:Remove() end) end
    for _, obj in pairs(drawingCache.itemESP) do pcall(function() obj:Remove() end) end
    pcall(function() Window:Destroy() end)
end
ConfigTab:CreateButton({ Name = "DESTRUIR TUDO", Callback = cleanupAllResources })

-- // Inicialização do Mecanismo Base Drawing
local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
if useDrawing then
    pcall(function()
        drawingCache.fovCircleObj = Drawing.new("Circle")
        drawingCache.fovCircleObj.Visible = false
        drawingCache.fovCircleObj.Thickness = 2
        drawingCache.fovCircleObj.Radius = config.fovRadius
        drawingCache.fovCircleObj.Color = Color3.new(1, 1, 1)
        
        -- Configuração da Banner Superior da foto
        drawingCache.topTextObj = Drawing.new("Text")
        drawingCache.topTextObj.Text = "SZ SYSTEM"
        drawingCache.topTextObj.Size = 22
        drawingCache.topTextObj.Center = true
        drawingCache.topTextObj.Outline = true
        drawingCache.topTextObj.Color = Color3.fromRGB(255, 0, 128)
        drawingCache.topTextObj.Visible = false
    end)
end

-- // Scan de Dinheiro Dinâmico
local function getPlayerMoney(plr)
    local ls = plr:FindFirstChild("leaderstats") or plr:FindFirstChild("Data")
    if not ls then return nil end
    for _, stat in ipairs(ls:GetChildren()) do
        if stat:IsA("IntValue") or stat:IsA("NumberValue") then
            local n = stat.Name:lower()
            if n:find("cash") or n:find("money") or n:find("gold") or n:find("coins") or n:find("dinheiro") then
                return stat.Value
            end
        end
    end
    return nil
end

-- // Thread de Coleta Otimizada de Itens
task.spawn(function()
    local itemsKws = {"coin","gold","diamond","gem","money","cash","loot","chest","weapon","sword","gun"}
    while task.wait(2) do
        if config.espItems then
            local temp = {}
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "" then
                    local name = part.Name:lower()
                    for _, kw in ipairs(itemsKws) do
                        if name:find(kw) then table.insert(temp, part) break end
                    end
                end
            end
            drawingCache.itemsToESP = temp
        else
            drawingCache.itemsToESP = {}
        end
    end
end)

-- // Mecanismo Suave do Aimbot
local function runAimbotEngine()
    if not config.aimbot then return end
    local center = Camera.ViewportSize / 2
    local closest, closestDist = nil, config.fovRadius
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local chr = p.Character
        if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(chr.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = chr.Head.Position
                end
            end
        end
    end
    
    if not closest then return end
    local alphaValues = { [1] = 0.02, [2] = 0.14, [3] = 0.45, [4] = 0.75, [5] = 1.0 }
    local alpha = alphaValues[config.aimForce] or 0.02
    
    if config.bypass > 1 then
        if config.bypass == 10 then
            closest = closest + Vector3.new(math.sin(tick()*20)*0.04, math.cos(tick()*20)*0.04, 0)
        else
            closest = closest + Vector3.new(math.random()-0.5, math.random()-0.5, math.random()-0.5) * ((11 - config.bypass) * 0.02)
        end
    end
    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest), alpha)
end

-- // Pipeline Robusta de ESP (Universal R6 e R15)
local function renderESPPipeline()
    if not useDrawing then return end
    
    -- Limpeza de lixo de memória de instâncias antigas
    for p, box in pairs(drawingCache.boxes) do if not p.Parent then box:Remove(); drawingCache.boxes[p] = nil end end
    for p, tag in pairs(drawingCache.nameTags) do if not p.Parent then tag:Remove(); drawingCache.nameTags[p] = nil end end
    for p, line in pairs(drawingCache.topTracers) do if not p.Parent then line:Remove(); drawingCache.topTracers[p] = nil end end
    for p, data in pairs(drawingCache.skeletons) do 
        if not p.Parent then 
            for _, d in ipairs(data) do d.line:Remove() end; drawingCache.skeletons[p] = nil 
        end 
    end
    
    -- Gerenciamento do Texto Superior (Referência da Foto)
    if config.topLines and drawingCache.topTextObj then
        drawingCache.topTextObj.Position = Vector2.new(Camera.ViewportSize.X / 2, 60)
        drawingCache.topTextObj.Visible = true
    elseif drawingCache.topTextObj then
        drawingCache.topTextObj.Visible = false
    end

    -- Loop de Renderização dos Alvos
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer then continue end
        local char = p.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if not char or not root or not head or not hum or hum.Health <= 0 then
            if drawingCache.boxes[p] then drawingCache.boxes[p].Visible = false end
            if drawingCache.nameTags[p] then drawingCache.nameTags[p].Visible = false end
            if drawingCache.topTracers[p] then drawingCache.topTracers[p].Visible = false end
            if drawingCache.skeletons[p] then for _, d in ipairs(drawingCache.skeletons[p]) do d.line.Visible = false end end
            continue
        end

        local headPos, onScreen = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
        local botPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
        
        if onScreen and headPos and botPos then
            local h = math.abs(headPos.Y - botPos.Y)
            local w = h * 0.50
            local cx = (headPos.X + botPos.X) / 2

            -- 1. Desenho da Box Universal
            if config.espBox then
                if not drawingCache.boxes[p] then
                    drawingCache.boxes[p] = Drawing.new("Square")
                    drawingCache.boxes[p].Thickness = 1.5
                    drawingCache.boxes[p].Filled = false
                end
                drawingCache.boxes[p].Position = Vector2.new(cx - w/2, headPos.Y)
                drawingCache.boxes[p].Size = Vector2.new(w, h)
                drawingCache.boxes[p].Color = config.boxColor
                drawingCache.boxes[p].Visible = true
            else
                if drawingCache.boxes[p] then drawingCache.boxes[p].Visible = false end
            end

            -- 2. Desenho do Tracers do Topo (Estilo Exato da Imagem Enviada)
            if config.topLines then
                if not drawingCache.topTracers[p] then
                    drawingCache.topTracers[p] = Drawing.new("Line")
                    drawingCache.topTracers[p].Thickness = 1.2
                end
                drawingCache.topTracers[p].From = Vector2.new(Camera.ViewportSize.X / 2, 75)
                drawingCache.topTracers[p].To = Vector2.new(cx, headPos.Y)
                drawingCache.topTracers[p].Color = Color3.fromRGB(255, 0, 150)
                drawingCache.topTracers[p].Visible = true
            else
                if drawingCache.topTracers[p] then drawingCache.topTracers[p].Visible = false end
            end

            -- 3. Nome, Vida e Dinheiro
            if config.showNameHealth then
                if not drawingCache.nameTags[p] then
                    drawingCache.nameTags[p] = Drawing.new("Text")
                    drawingCache.nameTags[p].Center = true
                    drawingCache.nameTags[p].Size = 13
                    drawingCache.nameTags[p].Outline = true
                    drawingCache.nameTags[p].OutlineColor = Color3.new(0,0,0)
                end
                local mStr = config.showMoney and getPlayerMoney(p) and (" | $"..getPlayerMoney(p)) or ""
                drawingCache.nameTags[p].Text = string.format("%s [%d]%s", p.Name, math.floor(hum.Health), mStr)
                drawingCache.nameTags[p].Position = Vector2.new(cx, headPos.Y - 15)
                drawingCache.nameTags[p].Color = Color3.new(1, 1, 1)
                drawingCache.nameTags[p].Visible = true
            else
                if drawingCache.nameTags[p] then drawingCache.nameTags[p].Visible = false end
            end

            -- 4. Esqueleto Inteligente (Autodetecta R6 e R15 de Verdade)
            if config.espSkel then
                if not drawingCache.skeletons[p] then
                    drawingCache.skeletons[p] = {}
                    -- Tabela condicional de juntas
                    local isR15 = char:FindFirstChild("UpperTorso") ~= nil
                    local bones = isR15 and {
                        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
                        {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
                        {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},
                        {"LeftUpperArm","LeftLowerArm"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"}
                    } or {
                        {"Head","Torso"},{"Torso","Left Leg"},{"Torso","Right Leg"},{"Torso","Left Arm"},{"Torso","Right Arm"}
                    }
                    for i, pair in ipairs(bones) do
                        local line = Drawing.new("Line")
                        line.Thickness = 1
                        table.insert(drawingCache.skeletons[p], {line = line, aName = pair[1], bName = pair[2]})
                    end
                end
                
                for _, data in ipairs(drawingCache.skeletons[p]) do
                    local jA, jB = char:FindFirstChild(data.aName), char:FindFirstChild(data.bName)
                    if jA and jB then
                        local pA, vA = Camera:WorldToViewportPoint(jA.Position)
                        local pB, vB = Camera:WorldToViewportPoint(jB.Position)
                        if vA and vB then
                            data.line.From = Vector2.new(pA.X, pA.Y)
                            data.line.To = Vector2.new(pB.X, pB.Y)
                            data.line.Color = config.skelColor
                            data.line.Visible = true
                        else data.line.Visible = false end
                    else data.line.Visible = false end
                end
            else
                if drawingCache.skeletons[p] then
                    for _, d in ipairs(drawingCache.skeletons[p]) do d.line.Visible = false end
                end
            end
        else
            -- Fora da tela, oculta tudo do player atual
            if drawingCache.boxes[p] then drawingCache.boxes[p].Visible = false end
            if drawingCache.nameTags[p] then drawingCache.nameTags[p].Visible = false end
            if drawingCache.topTracers[p] then drawingCache.topTracers[p].Visible = false end
            if drawingCache.skeletons[p] then for _, d in ipairs(drawingCache.skeletons[p]) do d.line.Visible = false end end
        end
    end

    -- Desenho do Círculo do FOV
    if drawingCache.fovCircleObj then
        drawingCache.fovCircleObj.Position = Camera.ViewportSize / 2
        drawingCache.fovCircleObj.Radius = config.fovRadius
        drawingCache.fovCircleObj.Visible = config.fovCircle
        drawingCache.fovCircleObj.Color = config.fovRainbow and Color3.fromHSV((tick() % 5)/5, 1, 1) or Color3.new(1,1,1)
    end
end

-- // Evento de Pulo Infinito
UserInputService.JumpRequest:Connect(function()
    if config.infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- // Loop Unificado de Alta Velocidade (RenderStepped)
local lastLiveCheck = 0
RunService.RenderStepped:Connect(function(deltaTime)
    runAimbotEngine()
    renderESPPipeline()
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if not char or not hrp or not hum then return end

    -- 1. NOVO MÓDULO: Fly Avançado Indetectável (Simula Caminhada)
    if config.advancedFly then
        hum.PlatformStand = false -- Garante que as pernas continuem se mexendo
        local flyDir = Vector3.new(0,0,0)
        
        if not UserInputService:GetFocusedTextBox() then
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then flyDir = flyDir + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then flyDir = flyDir - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then flyDir = flyDir - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then flyDir = flyDir + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then flyDir = flyDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then flyDir = flyDir - Vector3.new(0, 1, 0) end
        end
        
        if flyDir.Magnitude > 0 then
            hrp.Velocity = Vector3.new(0, 0, 0) -- Força estabilidade estática nas físicas para anular quedas
            hrp.CFrame = hrp.CFrame + (flyDir.Unit * config.flySpeed * deltaTime)
        else
            hrp.Velocity = Vector3.new(0, 0.1, 0) -- Pequena flutuação constante anti-queda
        end
    end

    -- 2. Velocidade Disfarçada por CFrame
    if config.stealthSpeed and not config.advancedFly and hum.MoveDirection.Magnitude > 0 then
        local factor = (config.stealthSpeedValue / 10)
        hrp.CFrame = hrp.CFrame + (hum.MoveDirection * factor * deltaTime * 35)
    end

    -- 3. Segurança Anti Live
    if config.antiLive and (tick() - lastLiveCheck > 1) then
        lastLiveCheck = tick()
        Window.Enabled = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
    end
end)

script.Destroying:Connect(cleanupAllResources)
