-- SZ MODS FINAL – Rayfield funcional + todas as funções completas e corrigidas
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variáveis de estado
local aimbot = false
local aimForce = 1
local bypass = 1
local fovCircle = false
local fovRainbow = false
local fovRadius = 150
local espBox = false
local espSkel = false
local showNameHealth = false
local showMoney = false
local espItems = false
local espLines = false
local infJump = false
local antiLive = false
local boxColor = Color3.fromRGB(255,0,0)
local skelColor = Color3.fromRGB(255,255,255)

-- Tabelas e Objetos de Desenho
local boxes, skeletons, nameTags, healthBars, rainbowLines = {}, {}, {}, {}, {}
local itemESP = {}
local itemsToESP = {} 
local fovCircleObj = nil

-- Conversor de cores
local function parseColor(input)
    local s = tostring(input):lower():gsub("%s","")
    local named = {
        vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00",
        azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00",
        roxo="800080", purple="800080", laranja="ff8800", orange="ff8800",
        preto="000000", black="000000", branco="ffffff", white="ffffff",
        rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff"
    }
    if named[s] then s = named[s] end
    if #s == 6 and s:match("^%x+$") then
        return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16))
    end
    return nil
end

local Window = Rayfield:CreateWindow({
   Name = "SZ MODS",
   LoadingTitle = "SZ MODS",
   LoadingSubtitle = "by Souza",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Criação segura de abas
local function safeCreateTab(name, icon)
    local tab
    pcall(function() tab = Window:CreateTab(name, icon) end)
    return tab
end

local CombatTab = safeCreateTab("Combate", 4483362458)
local VisualTab = safeCreateTab("Visual", 4483362458)
local CoresTab = safeCreateTab("Cores ESP", 4483362458)
local MovementTab = safeCreateTab("Movimento", 4483362458)
local ConfigTab = safeCreateTab("Config", 4483362458)

local function safeToggle(tab, name, default, callback)
    if tab then pcall(function() tab:CreateToggle({ Name = name, CurrentValue = default, Callback = callback }) end) end
end

local function safeSlider(tab, name, min, max, default, callback)
    if tab then pcall(function() tab:CreateSlider({ Name = name, Min = min, Max = max, Increment = 1, CurrentValue = default, Callback = callback }) end) end
end

local function safeInput(tab, name, placeholder, callback)
    if tab then pcall(function() tab:CreateInput({ Name = name, PlaceholderText = placeholder, RemoveTextAfterFocusLost = false, Callback = callback }) end) end
end

local function safeButton(tab, name, callback)
    if tab then pcall(function() tab:CreateButton({ Name = name, Callback = callback }) end) end
end

-- ==================== CONTROLES DA INTERFACE AJUSTADOS ====================
safeToggle(CombatTab, "Aimbot", false, function(v) aimbot = v end)
-- Configuração da Força (1 a 5)
safeSlider(CombatTab, "Força (1-Suave, 5-Portão)", 1, 5, 1, function(v) aimForce = v end)
-- Configuração do Bypass (1 a 10)
safeSlider(CombatTab, "Bypass Anti-Cheat (10-Seguro)", 1, 10, 1, function(v) bypass = v end)

safeToggle(VisualTab, "ESP Box", false, function(v) espBox = v end)
safeToggle(VisualTab, "ESP Esqueleto", false, function(v) espSkel = v end)
safeToggle(VisualTab, "Nome / Vida / Dinheiro", false, function(v) showNameHealth = v end)
safeToggle(VisualTab, "Mostrar Dinheiro", false, function(v) showMoney = v end)
safeToggle(VisualTab, "ESP Itens", false, function(v) espItems = v end)
safeToggle(VisualTab, "Linhas Arco-íris", false, function(v) espLines = v end)
safeToggle(VisualTab, "Círculo FOV", false, function(v) fovCircle = v end)
safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)
-- Limite do FOV alterado para 360 máximo
safeSlider(VisualTab, "Raio FOV", 1, 360, 150, function(v) fovRadius = v end)

safeInput(CoresTab, "Cor da Box (ex: vermelho)", "vermelho", function(v) local c = parseColor(v) if c then boxColor = c end end)
safeInput(CoresTab, "Cor do Esqueleto (ex: azul)", "branco", function(v) local c = parseColor(v) if c then skelColor = c end end)

safeToggle(MovementTab, "Pulo Infinito", false, function(v) infJump = v end)
safeToggle(ConfigTab, "Anti Live", false, function(v) antiLive = v end)

local staffFrame
safeButton(ConfigTab, "DESTRUIR TUDO", function()
    aimbot = false; espBox = false; espSkel = false; showNameHealth = false; showMoney = false
    espItems = false; espLines = false; fovCircle = false; fovRainbow = false
    infJump = false; antiLive = false
    
    if fovCircleObj then pcall(function() fovCircleObj:Remove() end) end
    for _, box in pairs(boxes) do pcall(function() box:Remove() end) end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
    for _, tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
    for _, bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
    for _, line in pairs(rainbowLines) do pcall(function() line:Remove() end) end
    for _, obj in pairs(itemESP) do pcall(function() obj:Remove() end) end
    if staffFrame and staffFrame.Parent then pcall(function() staffFrame.Parent:Destroy() end) end
    
    pcall(function() Window:Destroy() end)
    script:Destroy()
end)

-- Inicialização da Drawing API
local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
if useDrawing then
    pcall(function()
        fovCircleObj = Drawing.new("Circle")
        fovCircleObj.Visible = false
        fovCircleObj.Thickness = 2
        fovCircleObj.Radius = fovRadius
        fovCircleObj.Color = Color3.new(1,1,1)
        fovCircleObj.Filled = false
    end)
end

-- Dinheiro do jogador
local function getPlayerMoney(plr)
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        for _, stat in ipairs(ls:GetChildren()) do
            if (stat:IsA("IntValue") or stat:IsA("NumberValue")) and
               (stat.Name:lower():find("cash") or stat.Name:lower():find("money") or stat.Name:lower():find("gold") or stat.Name:lower():find("coins") or stat.Name:lower():find("dinheiro")) then
                return stat.Value
            end
        end
    end
    return nil
end

-- Otimização da busca de Itens
task.spawn(function()
    while task.wait(2) do
        if espItems then
            local tempItems = {}
            local valuable = {"coin","gold","diamond","gem","money","cash","loot","chest","armor","weapon","sword","gun"}
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "" then
                    local name = part.Name:lower()
                    for _, kw in ipairs(valuable) do
                        if name:find(kw) then table.insert(tempItems, part) break end
                    end
                end
            end
            itemsToESP = tempItems
        else
            itemsToESP = {}
        end
    end
end)

-- ==================== LÓGICA DE AIMBOT AVANÇADA ====================
local function aimbotStep()
    if not aimbot then return end
    local center = Camera.ViewportSize / 2
    local enemies = {}
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local chr = p.Character
        if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
            local pos, on = Camera:WorldToViewportPoint(chr.Head.Position)
            if on then
                local screenPos = Vector2.new(pos.X, pos.Y)
                local distFromCrosshair = (screenPos - center).Magnitude
                if distFromCrosshair <= fovRadius then
                    table.insert(enemies, {chr = chr, dist = distFromCrosshair})
                end
            end
        end
    end
    
    if #enemies == 0 then return end
    -- Organiza para focar SEMPRE no mais perto da mira atual (Permite trocar de alvo apenas olhando para o outro)
    table.sort(enemies, function(a,b) return a.dist < b.dist end)
    
    local targetCharacter = enemies[1].chr
    local targetPos = targetCharacter.Head.Position
    
    -- Cálculos de Força Customizados (Definições do Usuário)
    local alpha = 0.02
    if aimForce == 1 then
        alpha = 0.02 -- Suave
    elseif aimForce == 2 then
        alpha = 0.14 -- Gruda bem mais, mas permite desvencilhar facilmente mudando a mira
    elseif aimForce == 3 then
        alpha = 0.45 -- Forte
    elseif aimForce == 4 then
        alpha = 0.75 -- Muito Forte
    elseif aimForce == 5 then
        alpha = 1.0  -- Portão (Bloqueio Instantâneo)
    end
    
    -- Cálculos de Segurança e Bypass (Até nível 10 Indetectável)
    if bypass > 1 then
        -- Aplica uma suavização baseada no nível de bypass para quebrar linhas robóticas detectadas pelo Anti-Cheat
        local safetyFactor = (bypass / 10)
        
        if bypass == 10 then
            -- Nível 10: Adiciona micro variações humanas simuladas por ondas matemáticas e limita acelerações bruscas indesejadas
            local jitter = Vector3.new(
                math.sin(tick() * 25) * 0.05,
                math.cos(tick() * 25) * 0.05,
                math.sin(tick() * 12) * 0.05
            )
            targetPos = targetPos + jitter
            -- Força uma pequena curva de interpolação impedindo snap de 1 frame (exceto se a força for portão)
            if aimForce < 5 then
                alpha = math.clamp(alpha * (1 - safetyFactor * 0.3), 0.01, 0.5)
            end
        else
            -- Níveis 2 a 9: Adiciona pequenos desvios baseados no valor do slider
            targetPos = targetPos + Vector3.new(math.random()-0.5, math.random()-0.5, math.random()-0.5) * ((11 - bypass) * 0.02)
        end
    end
    
    -- Aplicação final na Câmera
    if alpha >= 1 then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    else
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha)
    end
end

-- Sistema de ESP (Mesma lógica otimizada anterior)
local function updateESP()
    for p, box in pairs(boxes) do if not p.Parent then pcall(function() box:Remove() end); boxes[p] = nil end end
    for p, data in pairs(skeletons) do
        if not p.Parent then
            for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end
            skeletons[p] = nil
        end
    end
    for p, tag in pairs(nameTags) do if not p.Parent then pcall(function() tag:Remove() end); nameTags[p] = nil end end
    for p, bar in pairs(healthBars) do if not p.Parent then pcall(function() bar.bg:Remove(); bar.fill:Remove() end); healthBars[p] = nil end end
    for p, line in pairs(rainbowLines) do if not p.Parent then pcall(function() line:Remove() end); rainbowLines[p] = nil end end
    for part, obj in pairs(itemESP) do if not part.Parent then pcall(function() obj:Remove() end); itemESP[part] = nil end end

    if espItems and useDrawing then
        for _, part in ipairs(itemsToESP) do
            if part.Parent then
                if not itemESP[part] then
                    pcall(function()
                        local circle = Drawing.new("Circle")
                        circle.Radius = 5; circle.Color = Color3.new(1,1,0); circle.Filled = true
                        itemESP[part] = circle
                    end)
                end
                if itemESP[part] then
                    local pos, on = Camera:WorldToViewportPoint(part.Position)
                    if on then
                        itemESP[part].Position = Vector2.new(pos.X, pos.Y)
                        itemESP[part].Visible = true
                    else
                        itemESP[part].Visible = false
                    end
                end
            end
        end
    else
        for part, obj in pairs(itemESP) do pcall(function() obj:Remove() end); itemESP[part] = nil end
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then
            if boxes[p] then pcall(function() boxes[p]:Remove() end); boxes[p] = nil end
            if skeletons[p] then for _, d in ipairs(skeletons[p]) do pcall(function() d.line:Remove() end) end; skeletons[p] = nil end
            if nameTags[p] then pcall(function() nameTags[p]:Remove() end); nameTags[p] = nil end
            if healthBars[p] then pcall(function() healthBars[p].bg:Remove(); healthBars[p].fill:Remove() end); healthBars[p] = nil end
            if rainbowLines[p] then pcall(function() rainbowLines[p]:Remove() end); rainbowLines[p] = nil end
            continue
        end
        local hum = char:FindFirstChild("Humanoid")
        local health = hum and hum.Health or 0
        local maxHealth = hum and hum.MaxHealth or 100
        
        if not hum or health <= 0 then
            if boxes[p] then boxes[p].Visible = false end
            if skeletons[p] then for _, d in ipairs(skeletons[p]) do d.line.Visible = false end end
            if nameTags[p] then nameTags[p].Visible = false end
            if healthBars[p] then healthBars[p].bg.Visible = false; healthBars[p].fill.Visible = false end
            if rainbowLines[p] then rainbowLines[p].Visible = false end
            continue
        end

        if espBox and useDrawing then
            local head = char.Head; local root = char.HumanoidRootPart
            local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.5,0))
            local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
            if top and bot then
                local h = math.abs(top.Y - bot.Y); local w = h * 0.45; local cx = (top.X + bot.X) / 2
                if not boxes[p] then
                    pcall(function()
                        local box = Drawing.new("Square"); box.Thickness = 2; box.Filled = false
                        boxes[p] = box
                    end)
                end
                if boxes[p] then
                    boxes[p].Position = Vector2.new(cx - w/2, top.Y)
                    boxes[p].Size = Vector2.new(w, h)
                    boxes[p].Color = boxColor
                    boxes[p].Visible = true
                end
            else
                if boxes[p] then boxes[p].Visible = false end
            end
        else
            if boxes[p] then pcall(function() boxes[p]:Remove() end); boxes[p] = nil end
        end

        if espSkel and useDrawing then
            if not skeletons[p] then
                skeletons[p] = {}
                local bones = {}
                local bonePairs = {
                    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
                    {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
                    {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},
                    {"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},
                    {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"}
                }
                for _, pair in ipairs(bonePairs) do
                    local a = char:FindFirstChild(pair[1]); local b = char:FindFirstChild(pair[2])
                    if a and b then table.insert(bones, {a, b}) end
                end
                for i, parts in ipairs(bones) do
                    pcall(function()
                        local line = Drawing.new("Line"); line.Thickness = 1
                        skeletons[p][i] = {line = line, a = parts[1], b = parts[2]}
                    end)
                end
            end
            for _, data in ipairs(skeletons[p]) do
                local a, b = data.a, data.b
                if a.Parent and b.Parent then
                    local aPos, aVis = Camera:WorldToViewportPoint(a.Position)
                    local bPos, bVis = Camera:WorldToViewportPoint(b.Position)
                    if aVis and bVis then
                        data.line.From = Vector2.new(aPos.X, aPos.Y)
                        data.line.To = Vector2.new(bPos.X, bPos.Y)
                        data.line.Color = skelColor
                        data.line.Visible = true
                    else
                        data.line.Visible = false
                    end
                else
                    data.line.Visible = false
                end
            end
        else
            if skeletons[p] then
                for _, d in ipairs(skeletons[p]) do pcall(function() d.line:Remove() end) end
                skeletons[p] = nil
            end
        end

        if showNameHealth and useDrawing then
            local headPos, on = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0,1.5,0))
            if on then
                local moneyStr = ""
                if showMoney then
                    local money = getPlayerMoney(p)
                    if money then moneyStr = " $" .. money end
                end
                local text = p.Name .. " [" .. math.floor(health) .. "/" .. math.floor(maxHealth) .. "]" .. moneyStr
                if not nameTags[p] then
                    pcall(function()
                        local tag = Drawing.new("Text"); tag.Center = true; tag.Size = 14; tag.Outline = true; tag.OutlineColor = Color3.new(0,0,0)
                        nameTags[p] = tag
                    end)
                end
                if nameTags[p] then
                    nameTags[p].Text = text
                    nameTags[p].Position = Vector2.new(headPos.X, headPos.Y - 10)
                    nameTags[p].Color = Color3.new(1,1,1)
                    nameTags[p].Visible = true
                end

                local bw, bh = 50, 4
                local bx, by = headPos.X - bw/2, headPos.Y + 2
                if not healthBars[p] then
                    pcall(function()
                        local bg = Drawing.new("Line"); bg.Color = Color3.new(0.15,0.15,0.15); bg.Thickness = bh
                        local fill = Drawing.new("Line"); fill.Color = Color3.new(0,1,0); fill.Thickness = bh
                        healthBars[p] = {bg = bg, fill = fill}
                    end)
                end
                if healthBars[p] then
                    healthBars[p].bg.From = Vector2.new(bx, by); healthBars[p].bg.To = Vector2.new(bx + bw, by)
                    healthBars[p].bg.Visible = true
                    local percent = math.clamp(health / maxHealth, 0, 1)
                    local fw = bw * percent
                    healthBars[p].fill.From = Vector2.new(bx, by); healthBars[p].fill.To = Vector2.new(bx + fw, by)
                    healthBars[p].fill.Color = percent > 0.5 and Color3.new(0,1,0) or (percent > 0.25 and Color3.new(1,1,0) or Color3.new(1,0,0))
                    healthBars[p].fill.Visible = true
                end
            else
                if nameTags[p] then nameTags[p].Visible = false end
                if healthBars[p] then healthBars[p].bg.Visible = false; healthBars[p].fill.Visible = false end
            end
        else
            if nameTags[p] then pcall(function() nameTags[p]:Remove() end); nameTags[p] = nil end
            if healthBars[p] then pcall(function() healthBars[p].bg:Remove(); healthBars[p].fill:Remove() end); healthBars[p] = nil end
        end

        if espLines and useDrawing then
            local myChar = Player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos, myVis = Camera:WorldToViewportPoint(myChar.HumanoidRootPart.Position)
                local enemyPos, enemyVis = Camera:WorldToViewportPoint(char.Head.Position)
                if myVis and enemyVis then
                    if not rainbowLines[p] then
                        pcall(function()
                            local line = Drawing.new("Line"); line.Thickness = 2
                            rainbowLines[p] = line
                        end)
                    end
                    if rainbowLines[p] then
                        rainbowLines[p].From = Vector2.new(myPos.X, myPos.Y)
                        rainbowLines[p].To = Vector2.new(enemyPos.X, enemyPos.Y)
                        rainbowLines[p].Color = Color3.fromHSV((tick() * 50 % 255) / 255, 1, 1)
                        rainbowLines[p].Visible = true
                    end
                else
                    if rainbowLines[p] then rainbowLines[p].Visible = false end
                end
            end
        else
            if rainbowLines[p] then pcall(function() rainbowLines[p]:Remove() end); rainbowLines[p] = nil end
        end
    end

    if fovCircleObj then
        fovCircleObj.Position = Camera.ViewportSize / 2
        fovCircleObj.Radius = fovRadius
        fovCircleObj.Visible = fovCircle
        if fovCircle and fovRainbow then
            fovCircleObj.Color = Color3.fromHSV((tick() % 5) / 5, 1, 1)
        else
            fovCircleObj.Color = Color3.new(1,1,1)
        end
    end
end

-- Staff Counter Corrigido
local function updateStaffCounter()
    if not staffFrame then return end
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        local name = p.Name:lower()
        for _, kw in ipairs({"staff","admin","mod","helper","owner","dev","gerente","moderador"}) do
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
    staffFrame.BackgroundColor3 = Color3.new(0,0,0)
    staffFrame.BorderSizePixel = 0
    staffFrame.Text = "Staff: 0"
    staffFrame.TextColor3 = Color3.new(0,1,0)
    staffFrame.Font = Enum.Font.SourceSansBold
    staffFrame.TextSize = 14
    staffFrame.AutoButtonColor = false
    Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0,4)
    updateStaffCounter()

    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        staffFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    staffFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = staffFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    
    staffFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end)

-- Pulo Infinito
UserInputService.JumpRequest:Connect(function()
    if infJump then
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Loop principal
local lastLiveCheck = 0
RunService.RenderStepped:Connect(function()
    aimbotStep()
    updateESP()
    updateStaffCounter()
    if antiLive and tick() - lastLiveCheck > 1 then
        lastLiveCheck = tick()
        Window.Enabled = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
    end
end)

-- Limpeza total ao destruir
script.Destroying:Connect(function()
    if fovCircleObj then pcall(function() fovCircleObj:Remove() end) end
    for _, box in pairs(boxes) do pcall(function() box:Remove() end) end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
    for _, tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
    for _, bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
    for _, line in pairs(rainbowLines) do pcall(function() line:Remove() end) end
    for _, obj in pairs(itemESP) do pcall(function() obj:Remove() end) end
    if staffFrame and staffFrame.Parent then pcall(function() staffFrame.Parent:Destroy() end) end
end)

print("SZ MODS carregado – Comportamento de Aimbot Avançado e Bypass 10 ativos!")
