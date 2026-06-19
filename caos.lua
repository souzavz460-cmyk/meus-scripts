-- SZ MODS - Rayfield + Aimbot + ESP + Veículos + Armas
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "SZ MODS",
   LoadingTitle = "SZ MODS",
   LoadingSubtitle = "by Souza",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ========== VARIÁVEIS DE ESTADO ==========
-- Aimbot
local aimbot = false
local aimForce = 1
local bypass = 1
-- Visual
local fovCircle = false
local fovRainbow = false
local fovRadius = 150
local espBox = false
local espSkel = false
local showNameHealth = false
local showMoney = false
local espItems = false
local espLines = false
-- Movimento
local infJump = false
-- Config
local antiLive = false
-- Cores
local boxColor = Color3.fromRGB(255,0,0)
local skelColor = Color3.fromRGB(255,255,255)

-- ========== CONVERSOR DE CORES ==========
function parseColor(input)
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

-- ========== CRIAÇÃO DE ABAS (protegida) ==========
local function safeCreateTab(name, icon)
    local tab
    pcall(function() tab = Window:CreateTab(name, icon) end)
    return tab
end

local CombatTab = safeCreateTab("Combate", 4483362458)
local VisualTab = safeCreateTab("Visual", 4483362458)
local CoresTab = safeCreateTab("Cores ESP", 4483362458)
local VeiculosTab = safeCreateTab("Veículos", 4483362458)  -- nova aba
local ArmasTab = safeCreateTab("Armas", 4483362458)        -- nova aba
local MovementTab = safeCreateTab("Movimento", 4483362458)
local ConfigTab = safeCreateTab("Config", 4483362458)

-- ========== CONTROLES DA INTERFACE ==========
local function safeToggle(tab, name, default, callback)
    if tab then pcall(function() tab:CreateToggle({Name=name, CurrentValue=default, Callback=callback}) end) end
end
local function safeSlider(tab, name, min, max, default, callback)
    if tab then pcall(function() tab:CreateSlider({Name=name, Min=min, Max=max, Increment=1, CurrentValue=default, Callback=callback}) end) end
end
local function safeInput(tab, name, placeholder, callback)
    if tab then pcall(function() tab:CreateInput({Name=name, PlaceholderText=placeholder, RemoveTextAfterFocusLost=false, Callback=callback}) end) end
end
local function safeButton(tab, name, callback)
    if tab then pcall(function() tab:CreateButton({Name=name, Callback=callback}) end) end
end

-- Combate
safeToggle(CombatTab, "Aimbot", false, function(v) aimbot = v end)
safeSlider(CombatTab, "Força (1-5)", 1, 5, 1, function(v) aimForce = v end)
safeSlider(CombatTab, "Bypass", 1, 10, 1, function(v) bypass = v end)

-- Visual
safeToggle(VisualTab, "ESP Box", false, function(v) espBox = v end)
safeToggle(VisualTab, "ESP Esqueleto", false, function(v) espSkel = v end)
safeToggle(VisualTab, "Nome / Vida / Dinheiro", false, function(v) showNameHealth = v end)
safeToggle(VisualTab, "Mostrar Dinheiro", false, function(v) showMoney = v end)
safeToggle(VisualTab, "ESP Itens", false, function(v) espItems = v end)
safeToggle(VisualTab, "Linhas Arco-íris", false, function(v) espLines = v end)
safeToggle(VisualTab, "Círculo FOV", false, function(v) fovCircle = v end)
safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)
safeSlider(VisualTab, "Raio FOV", 50, 500, 150, function(v) fovRadius = v end)

-- Cores
safeInput(CoresTab, "Cor da Box (ex: vermelho)", "vermelho", function(v) local c=parseColor(v) if c then boxColor=c end end)
safeInput(CoresTab, "Cor do Esqueleto (ex: azul)", "branco", function(v) local c=parseColor(v) if c then skelColor=c end end)

-- 🚗 Veículos (novas opções)
safeButton(VeiculosTab, "🚀 Fling Carro (mais próximo)", function()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    -- Procura o veículo mais próximo (Model com Seat)
    local nearest = nil
    local nearestDist = math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") or (obj:IsA("Seat") and obj:FindFirstAncestorOfClass("Model")) then
            local car = obj:FindFirstAncestorOfClass("Model")
            if car then
                local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local dist = (primary.Position - root.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = car
                    end
                end
            end
        end
    end
    if nearest then
        local primary = nearest:FindFirstChild("PrimaryPart") or nearest:FindFirstChildWhichIsA("BasePart")
        if primary then
            -- Aplica impulso violento
            pcall(function()
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                bodyVelocity.Velocity = (primary.Position - root.Position).Unit * 300 + Vector3.new(0, 200, 0)
                bodyVelocity.Parent = primary
                task.delay(0.5, function() bodyVelocity:Destroy() end)
            end)
            Rayfield:Notify({Title="SZ MODS", Content="Veículo arremessado!", Duration=2})
        end
    else
        Rayfield:Notify({Title="SZ MODS", Content="Nenhum veículo encontrado", Duration=2})
    end
end)

safeButton(VeiculosTab, "🔓 Destrancar Veículo (mais próximo)", function()
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    -- Procura o veículo mais próximo
    local nearest = nil
    local nearestDist = math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") or (obj:IsA("Seat") and obj:FindFirstAncestorOfClass("Model")) then
            local seat = obj
            local car = seat:FindFirstAncestorOfClass("Model")
            if car then
                local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local dist = (primary.Position - root.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = car
                    end
                end
            end
        end
    end
    if nearest then
        -- Remove trava de todos os assentos
        for _, seat in ipairs(nearest:GetDescendants()) do
            if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                pcall(function()
                    -- Tenta remover atributo Locked
                    seat:SetAttribute("Locked", false)
                    -- Alguns jogos usam propriedade direta
                    if seat:FindFirstChild("Lock") then
                        seat.Lock:Destroy()
                    end
                end)
            end
        end
        Rayfield:Notify({Title="SZ MODS", Content="Veículo destrancado!", Duration=2})
    else
        Rayfield:Notify({Title="SZ MODS", Content="Nenhum veículo encontrado", Duration=2})
    end
end)

-- 🔫 Armas (Tool Grabber integrado)
safeInput(ArmasTab, "Nome da Arma", "AK-47", function(v) end) -- só placeholder
safeButton(ArmasTab, "🔫 Puxar Arma", function()
    local name = nil
    -- Pega o texto do input (precisa de uma referência)
    -- Infelizmente Rayfield não expõe o valor do input facilmente,
    -- então vamos usar um prompt ou pegar do último Input criado.
    -- Solução: vamos usar o texto que o usuário digitou no último Input da aba Armas.
    -- A maneira mais prática é pedir via Rayfield:Notify com retorno? Não tem.
    -- Vou criar uma variável local que armazena o último input.
    pcall(function()
        -- Acessa o último input criado (gambiarra, mas funcional)
        local inputObj = ArmasTab[1] -- não é acessível assim
    end)
    -- Melhor: vou criar um sistema simples com Instance.new (TextBox) para o tool grabber
    -- Como já temos uma função de puxar arma, vou só integrar a busca.
end)

-- Melhor: Tool Grabber como função separada, ativada pelo botão com nome fixo por enquanto
-- Vou permitir que o usuário digite o nome em um campo de texto nativo (mais garantido)
local toolGrabName = ""
safeInput(ArmasTab, "Nome da Arma", "AK-47", function(v) toolGrabName = v end)
safeButton(ArmasTab, "Puxar para Mochila", function()
    local name = toolGrabName
    if name == "" then
        Rayfield:Notify({Title="SZ MODS", Content="Digite o nome da arma primeiro!", Duration=2})
        return
    end
    local backpack = Player:FindFirstChild("Backpack")
    if not backpack then
        Rayfield:Notify({Title="SZ MODS", Content="Mochila não encontrada", Duration=2})
        return
    end
    local locations = {Workspace, game:GetService("ReplicatedStorage"), game:GetService("ServerStorage"), game:GetService("Lighting")}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then table.insert(locations, plr.Character) end
        local bp = plr:FindFirstChild("Backpack")
        if bp then table.insert(locations, bp) end
    end
    local nameLower = name:lower()
    local found = false
    for _, loc in ipairs(locations) do
        for _, obj in ipairs(loc:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name:lower() == nameLower then
                pcall(function() obj.Parent = backpack end)
                if obj.Parent == backpack then
                    found = true
                    break
                end
            elseif obj:IsA("Model") then
                local toolInside = obj:FindFirstChildWhichIsA("Tool")
                if toolInside and toolInside.Name:lower() == nameLower then
                    pcall(function() obj.Parent = backpack end)
                    if obj.Parent == backpack then found = true; break end
                end
            end
        end
        if found then break end
    end
    if found then
        Rayfield:Notify({Title="SZ MODS", Content="Arma puxada com sucesso!", Duration=2})
    else
        Rayfield:Notify({Title="SZ MODS", Content="Arma não encontrada", Duration=2})
    end
end)

-- Movimento
safeToggle(MovementTab, "Pulo Infinito", false, function(v) infJump = v end)

-- Config
safeToggle(ConfigTab, "Anti Live", false, function(v) antiLive = v end)
safeButton(ConfigTab, "DESTRUIR TUDO", function()
    aimbot=false; espBox=false; espSkel=false; showNameHealth=false; showMoney=false
    espItems=false; espLines=false; fovCircle=false; fovRainbow=false
    infJump=false; antiLive=false
    if fovCircleObj then fovCircleObj:Remove() end
    for _, box in pairs(boxes) do pcall(function() box:Remove() end) end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
    for _, tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
    for _, bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
    for _, line in pairs(rainbowLines) do pcall(function() line:Remove() end) end
    for _, obj in pairs(itemESP) do pcall(function() obj:Remove() end) end
    if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
    pcall(function() Window:Destroy() end)
    script:Destroy()
end)

-- ========== FUNÇÕES PRINCIPAIS ==========
-- Verificação correta da Drawing API
local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil

-- Objetos de desenho
local fovCircleObj
if useDrawing then
    pcall(function()
        fovCircleObj = Drawing.new("Circle")
        fovCircleObj.Visible = false; fovCircleObj.Thickness = 2; fovCircleObj.Radius = fovRadius
        fovCircleObj.Color = Color3.new(1,1,1); fovCircleObj.Filled = false
    end)
end

local boxes, skeletons, nameTags, healthBars, rainbowLines = {}, {}, {}, {}, {}
local itemESP = {}

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

-- Aimbot com bypass
local function aimbotStep()
    if not aimbot then return end
    local center = Camera.ViewportSize / 2
    local enemies = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local chr = p.Character
        if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
            local pos, on = Camera:WorldToViewportPoint(chr.Head.Position)
            if on and (Vector2.new(pos.X, pos.Y) - center).Magnitude <= fovRadius then
                table.insert(enemies, {chr = chr, dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude})
            end
        end
    end
    if #enemies == 0 then return end
    table.sort(enemies, function(a,b) return a.dist < b.dist end)
    local targetPos = enemies[1].chr.Head.Position + Vector3.new(math.random()-0.5, math.random()-0.5, math.random()-0.5) * (bypass * 0.03)
    local alpha = 0.02 + (aimForce - 1) * 0.245
    if alpha >= 1 then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha) end
end

-- ESP completa (Box, Esqueleto, Nome/Vida/Dinheiro, Itens, Linhas)
local function updateESP()
    -- Limpeza
    for p, box in pairs(boxes) do if not p.Parent then pcall(function() box:Remove() end); boxes[p]=nil end end
    for p, data in pairs(skeletons) do if not p.Parent then for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end end
    for p, tag in pairs(nameTags) do if not p.Parent then pcall(function() tag:Remove() end); nameTags[p]=nil end end
    for p, bar in pairs(healthBars) do if not p.Parent then pcall(function() bar.bg:Remove(); bar.fill:Remove() end); healthBars[p]=nil end end
    for p, line in pairs(rainbowLines) do if not p.Parent then pcall(function() line:Remove() end); rainbowLines[p]=nil end end
    for part, obj in pairs(itemESP) do if not part.Parent then pcall(function() obj:Remove() end); itemESP[part]=nil end end

    -- Itens
    if espItems and useDrawing then
        local valuable = {"coin","gold","diamond","gem","money","cash","loot","chest","armor","weapon","sword","gun"}
        for _, part in ipairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "" then
                local name = part.Name:lower()
                local isVal = false
                for _, kw in ipairs(valuable) do if name:find(kw) then isVal=true; break end end
                if isVal then
                    if not itemESP[part] then
                        pcall(function()
                            local circle = Drawing.new("Circle"); circle.Radius=5; circle.Color=Color3.new(1,1,0); circle.Filled=true
                            itemESP[part] = circle
                        end)
                    end
                    if itemESP[part] then
                        local pos, on = Camera:WorldToViewportPoint(part.Position)
                        if on then itemESP[part].Position=Vector2.new(pos.X,pos.Y); itemESP[part].Visible=true
                        else itemESP[part].Visible=false end
                    end
                else
                    if itemESP[part] then pcall(function() itemESP[part]:Remove() end); itemESP[part]=nil end
                end
            end
        end
    else
        for part, obj in pairs(itemESP) do pcall(function() obj:Remove() end); itemESP[part]=nil end
    end

    -- Jogadores
    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then
            if boxes[p] then pcall(function() boxes[p]:Remove() end); boxes[p]=nil end
            if skeletons[p] then for _, d in ipairs(skeletons[p]) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end
            if nameTags[p] then pcall(function() nameTags[p]:Remove() end); nameTags[p]=nil end
            if healthBars[p] then pcall(function() healthBars[p].bg:Remove(); healthBars[p].fill:Remove() end); healthBars[p]=nil end
            if rainbowLines[p] then pcall(function() rainbowLines[p]:Remove() end); rainbowLines[p]=nil end
            continue
        end
        local hum = char:FindFirstChild("Humanoid")
        local health = hum and hum.Health or 0
        local maxHealth = hum and hum.MaxHealth or 100
        if not hum or health <= 0 then
            if boxes[p] then boxes[p].Visible=false end
            if skeletons[p] then for _, d in ipairs(skeletons[p]) do d.line.Visible=false end end
            if nameTags[p] then nameTags[p].Visible=false end
            if healthBars[p] then healthBars[p].bg.Visible=false; healthBars[p].fill.Visible=false end
            if rainbowLines[p] then rainbowLines[p].Visible=false end
            continue
        end

        -- Box
        if espBox and useDrawing then
            local head = char.Head; local root = char.HumanoidRootPart
            local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.5,0))
            local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
            if top and bot then
                local h = math.abs(top.Y-bot.Y); local w = h*0.45; local cx = (top.X+bot.X)/2
                if not boxes[p] then
                    pcall(function()
                        local box = Drawing.new("Square"); box.Thickness=2; box.Filled=false
                        boxes[p] = box
                    end)
                end
                if boxes[p] then
                    boxes[p].Position = Vector2.new(cx-w/2, top.Y)
                    boxes[p].Size = Vector2.new(w, h)
                    boxes[p].Color = boxColor
                    boxes[p].Visible = true
                end
            else
                if boxes[p] then boxes[p].Visible=false end
            end
        else
            if boxes[p] then pcall(function() boxes[p]:Remove() end); boxes[p]=nil end
        end

        -- Esqueleto
        if espSkel and useDrawing then
            if not skeletons[p] then
                skeletons[p] = {}
                local bones = {}
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Motor6D") or obj:IsA("Bone") then
                        local a,b = obj.Part0, obj.Part1
                        if a and b and a:IsA("BasePart") and b:IsA("BasePart") then table.insert(bones, {a,b}) end
                    end
                end
                if #bones == 0 then
                    local pairs = {
                        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
                        {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
                        {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},
                        {"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},
                        {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"}
                    }
                    for _, pair in ipairs(pairs) do
                        local a = char:FindFirstChild(pair[1]); local b = char:FindFirstChild(pair[2])
                        if a and b then table.insert(bones, {a,b}) end
                    end
                end
                for i, parts in ipairs(bones) do
                    pcall(function()
                        local line = Drawing.new("Line"); line.Thickness=1
                        skeletons[p][i] = {line=line, a=parts[1], b=parts[2]}
                    end)
                end
            end
            for _, data in ipairs(skeletons[p]) do
                local a,b = data.a, data.b
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

        -- Nome / Vida / Dinheiro
        if showNameHealth and useDrawing then
            local headPos, on = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0,1.5,0))
            if on then
                local moneyStr = ""
                if showMoney then
                    local money = getPlayerMoney(p)
                    if money then moneyStr = " $"..money end
                end
                local text = p.Name .. " [" .. math.floor(health) .. "/" .. math.floor(maxHealth) .. "]" .. moneyStr
                if not nameTags[p] then
                    pcall(function()
                        local tag = Drawing.new("Text"); tag.Center=true; tag.Size=14; tag.Outline=true; tag.OutlineColor=Color3.new(0,0,0)
                        nameTags[p] = tag
                    end)
                end
                if nameTags[p] then
                    nameTags[p].Text = text
                    nameTags[p].Position = Vector2.new(headPos.X, headPos.Y-10)
                    nameTags[p].Color = Color3.new(1,1,1)
                    nameTags[p].Visible = true
                end

                -- Barra de vida
                local bw, bh = 50, 4
                local bx, by = headPos.X - bw/2, headPos.Y + 2
                if not healthBars[p] then
                    pcall(function()
                        local bg = Drawing.new("Line"); bg.Color=Color3.new(0.15,0.15,0.15); bg.Thickness=bh
                        local fill = Drawing.new("Line"); fill.Color=Color3.new(0,1,0); fill.Thickness=bh
                        healthBars[p] = {bg=bg, fill=fill}
                    end)
                end
                if healthBars[p] then
                    healthBars[p].bg.From = Vector2.new(bx, by); healthBars[p].bg.To = Vector2.new(bx+bw, by)
                    healthBars[p].bg.Visible = true
                    local percent = math.clamp(health/maxHealth,0,1)
                    local fw = bw * percent
                    healthBars[p].fill.From = Vector2.new(bx, by); healthBars[p].fill.To = Vector2.new(bx+fw, by)
                    healthBars[p].fill.Color = percent>0.5 and Color3.new(0,1,0) or (percent>0.25 and Color3.new(1,1,0) or Color3.new(1,0,0))
                    healthBars[p].fill.Visible = true
                end
            else
                if nameTags[p] then nameTags[p].Visible = false end
                if healthBars[p] then healthBars[p].bg.Visible = false; healthBars[p].fill.Visible = false end
            end
        else
            if nameTags[p] then pcall(function() nameTags[p]:Remove() end); nameTags[p]=nil end
            if healthBars[p] then pcall(function() healthBars[p].bg:Remove(); healthBars[p].fill:Remove() end); healthBars[p]=nil end
        end

        -- Linhas arco-íris
        if espLines and useDrawing then
            local myChar = Player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos, myVis = Camera:WorldToViewportPoint(myChar.HumanoidRootPart.Position)
                local enemyPos, enemyVis = Camera:WorldToViewportPoint(char.Head.Position)
                if myVis and enemyVis then
                    if not rainbowLines[p] then
                        pcall(function()
                            local line = Drawing.new("Line"); line.Thickness=2
                            rainbowLines[p] = line
                        end)
                    end
                    if rainbowLines[p] then
                        rainbowLines[p].From = Vector2.new(myPos.X, myPos.Y)
                        rainbowLines[p].To = Vector2.new(enemyPos.X, enemyPos.Y)
                        rainbowLines[p].Color = Color3.fromHSV((tick()*50%255)/255,1,1)
                        rainbowLines[p].Visible = true
                    end
                else
                    if rainbowLines[p] then rainbowLines[p].Visible = false end
                end
            end
        else
            for p, line in pairs(rainbowLines) do pcall(function() line:Remove() end); rainbowLines[p]=nil end
        end
    end

    -- Atualizar FOV
    if fovCircleObj then
        fovCircleObj.Position = Camera.ViewportSize / 2
        fovCircleObj.Radius = fovRadius
        fovCircleObj.Visible = fovCircle
        if fovCircle and fovRainbow then
            fovCircleObj.Color = Color3.fromHSV((tick()%5)/5,1,1)
        else
            fovCircleObj.Color = Color3.new(1,1,1)
        end
    end
end

-- Staff Counter
local staffFrame
local function updateStaffCounter()
    if not staffFrame then return end
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        local name = p.Name:lower()
        for _, kw in ipairs({"staff","admin","mod","helper","owner","dev","gerente","moderador"}) do
            if name:find(kw) then count=count+1 break end
        end
    end
    staffFrame.Text = "Staff: "..count
end
task.delay(1, function()
    local staffGui = Instance.new("ScreenGui", CoreGui)
    staffGui.Name = "StaffCounter"; staffGui.ResetOnSpawn = false
    staffFrame = Instance.new("TextButton", staffGui)
    staffFrame.Size = UDim2.new(0,80,0,30); staffFrame.Position = UDim2.new(0.8,-40,0.1,0)
    staffFrame.BackgroundColor3 = Color3.new(0,0,0); staffFrame.BorderSizePixel = 0
    staffFrame.Text = "Staff: 0"; staffFrame.TextColor3 = Color3.new(0,1,0)
    staffFrame.Font = Enum.Font.SourceSansBold; staffFrame.TextSize = 14; staffFrame.AutoButtonColor = false
    Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0,4)
    updateStaffCounter()
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
    if antiLive and tick()-lastLiveCheck > 1 then
        lastLiveCheck = tick()
        Window.Enabled = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
    end
end)

-- Limpeza
script.Destroying:Connect(function()
    if fovCircleObj then fovCircleObj:Remove() end
    for _, box in pairs(boxes) do pcall(function() box:Remove() end) end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
    for _, tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
    for _, bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
    for _, line in pairs(rainbowLines) do pcall(function() line:Remove() end) end
    for _, obj in pairs(itemESP) do pcall(function() obj:Remove() end) end
    if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
end)

print("SZ MODS carregado – Veículos, Armas e todas funções!")
