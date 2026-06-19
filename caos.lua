-- SZ MODS COMPLETO – Versão Sirius SUPREMA CORES & FÍSICA Fix
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Souza Mods Pro",
    Icon = 4483362458,
    LoadingTitle = "Souza Mods Elite",
    LoadingSubtitle = "by Souzavz",
    Theme = "Default",

    ConfigurationSaving = {
        Enabled = false,
        FolderName = "SouzaMods",
        FileName = "Main"
    },

    Discord = {
        Enabled = false
    },

    KeySystem = false
})

-- Serviços principais do Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ========== VARIÁVEIS DE CONFIGURAÇÃO ==========
local aimbot = false; local aimForce = 1; local bypass = 1
local fovCircle = false; local fovRainbow = false; local fovRadius = 150
local espBox = false; local espSkel = false; local showNameHealth = false
local showMoney = false; local espItems = false; local espLines = false
local infJump = false
local flyEnabled = false
local flySpeed = 50
local speedEnabled = false
local speedValue = 24
local antiLive = false
local boxColor = Color3.fromRGB(255,0,0); local skelColor = Color3.fromRGB(255,255,255)
local toolGrabName = ""

-- Controle de Veículos
local holdingCar = nil
local holdingConn = nil

-- ========== CONVERSOR DE CORES ==========
function parseColor(input)
    local s = tostring(input):lower():gsub("%s","")
    local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
    if named[s] then s = named[s] end
    if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
    return nil
end

-- ========== CRIAÇÃO DAS ABAS ==========
local CombatTab = Window:CreateTab("Combate", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local CoresTab = Window:CreateTab("Cores ESP", 4483362458)
local VeiculosTab = Window:CreateTab("Veículos", 4483362458)
local ArmasTab = Window:CreateTab("Armas", 4483362458)
local MovementTab = Window:CreateTab("Movimento", 4483362458)
local ConfigTab = Window:CreateTab("Config", 4483362458)

-- ========== ABA COMBATE ==========
CombatTab:CreateToggle({ Name = "Aimbot", CurrentValue = false, Flag = "Aimbot_Toggle", Callback = function(v) aimbot = v end })

CombatTab:CreateSlider({
    Name = "Força (1-5)",
    Range = {1, 5},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "AimForce_Slider",
    Callback = function(v) aimForce = v end
})

CombatTab:CreateSlider({
    Name = "Bypass",
    Range = {1, 10},
    Increment = 1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "Bypass_Slider",
    Callback = function(v) bypass = v end
})

-- ========== ABA VISUAL ==========
VisualTab:CreateToggle({ Name = "ESP Box", CurrentValue = false, Flag = "ESPBox_Toggle", Callback = function(v) espBox = v end })
VisualTab:CreateToggle({ Name = "ESP Esqueleto", CurrentValue = false, Flag = "ESPSkel_Toggle", Callback = function(v) espSkel = v end })
VisualTab:CreateToggle({ Name = "Nome / Vida / Dinheiro", CurrentValue = false, Flag = "ESPName_Toggle", Callback = function(v) showNameHealth = v end })
VisualTab:CreateToggle({ Name = "Mostrar Dinheiro", CurrentValue = false, Flag = "ESPMoney_Toggle", Callback = function(v) showMoney = v end })
VisualTab:CreateToggle({ Name = "ESP Itens", CurrentValue = false, Flag = "ESPItems_Toggle", Callback = function(v) espItems = v end })
VisualTab:CreateToggle({ Name = "Linhas Arco-íris", CurrentValue = false, Flag = "ESPLines_Toggle", Callback = function(v) espLines = v end })
VisualTab:CreateToggle({ Name = "Círculo FOV", CurrentValue = false, Flag = "FOVCircle_Toggle", Callback = function(v) fovCircle = v end })
VisualTab:CreateToggle({ Name = "FOV Arco-íris", CurrentValue = false, Flag = "FOVRainbow_Toggle", Callback = function(v) fovRainbow = v end })

VisualTab:CreateSlider({
    Name = "Raio FOV",
    Range = {50, 500},
    Increment = 1,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOVRadius_Slider",
    Callback = function(v) fovRadius = v end
})

-- ========== ABA CORES ==========
CoresTab:CreateInput({ Name = "Cor da Box (ex: vermelho)", PlaceholderText = "vermelho", RemoveTextAfterFocusLost = false, Callback = function(v) local c = parseColor(v) if c then boxColor = c end end })
CoresTab:CreateInput({ Name = "Cor do Esqueleto (ex: azul)", PlaceholderText = "branco", RemoveTextAfterFocusLost = false, Callback = function(v) local c = parseColor(v) if c then skelColor = c end end })

-- ========== ABA VEÍCULOS (FÍSICA DE FLING ATUALIZADA & AUTO-SIT UNLOCK) ==========
VeiculosTab:CreateButton({
    Name = "🧲 Grudar Carro Próximo na Mão",
    Callback = function()
        if holdingCar then return end
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local nearest, nearestDist = nil, math.huge
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("VehicleSeat") then
                local car = obj:FindFirstAncestorOfClass("Model")
                if car then
                    local p = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                    if p then
                        local d = (p.Position - root.Position).Magnitude
                        if d < nearestDist then nearestDist = d; nearest = car end
                    end
                end
            end
        end

        if nearest then
            holdingCar = nearest
            holdingConn = RunService.Heartbeat:Connect(function()
                if not holdingCar or not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
                    if holdingConn then holdingConn:Disconnect() end
                    holdingCar = nil
                    return
                end
                local r = Player.Character.HumanoidRootPart
                for _, part in ipairs(holdingCar:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function()
                            part.CanCollide = false
                            part.Anchored = false
                            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end)
                    end
                end
                local prim = holdingCar.PrimaryPart or holdingCar:FindFirstChildWhichIsA("BasePart")
                if prim then
                    -- Fixa rigidamente o CFrame do carro na frente do seu boneco para forçar a sincronização de rede
                    prim.CFrame = r.CFrame * CFrame.new(0, 1.5, -8)
                end
            end)
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "✅ Veículo preso na mão! Olhe para o alvo e use 'Jogar Carro'.", Duration = 3 })
        else
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "❌ Nenhum veículo por perto.", Duration = 2 })
        end
    end
})

VeiculosTab:CreateButton({
    Name = "💥 Jogar Carro (Arremesso Físico Violento)",
    Callback = function()
        if not holdingCar then 
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "❌ Você não está segurando um veículo.", Duration = 2 })
            return 
        end
        if holdingConn then holdingConn:Disconnect() end

        local targetVehicle = holdingCar
        holdingCar = nil

        local prim = targetVehicle.PrimaryPart or targetVehicle:FindFirstChildWhichIsA("BasePart")
        local dir = Camera.CFrame.LookVector

        if prim then
            -- Loop forçado para o servidor validar o deslocamento e não "travar" o carro no ar
            task.spawn(function()
                for i = 1, 40 do
                    if prim and prim.Parent then
                        pcall(function()
                            for _, part in ipairs(targetVehicle:GetDescendants()) do
                                if part:IsA("BasePart") then 
                                    part.CanCollide = true 
                                    part.Anchored = false
                                    -- Aplica força de desancoragem extrema
                                    part.AssemblyLinearVelocity = dir * 18000
                                    part.AssemblyAngularVelocity = Vector3.new(4000, 4000, 4000)
                                end
                            end
                        end)
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "🚀 Veículo arremessado!", Duration = 2 })
        end
    end
})

VeiculosTab:CreateButton({
    Name = "🔓 Destrancar e Entrar no Carro Mais Próximo",
    Callback = function()
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not root or not hum then return end
        
        local nearest, nearestDist = nil, math.huge
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("VehicleSeat") then
                local car = obj:FindFirstAncestorOfClass("Model")
                if car then
                    local p = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                    if p then
                        local d = (p.Position - root.Position).Magnitude
                        if d < nearestDist then nearestDist = d; nearest = car end
                    end
                end
            end
        end

        if nearest then
            local targetSeat = nil
            pcall(function()
                for _, obj in ipairs(nearest:GetDescendants()) do
                    if obj:IsA("VehicleSeat") or obj:IsA("Seat") then
                        obj.Disabled = false
                        obj.CanTouch = true
                        obj:SetAttribute("Locked", false)
                        obj:SetAttribute("Occupied", false)
                        obj:SetAttribute("Owner", "")
                        targetSeat = obj
                    elseif obj:IsA("ProximityPrompt") then
                        obj.Enabled = true
                        obj.MaxActivationDistance = 30
                    elseif obj:IsA("ValueBase") then
                        local n = obj.Name:lower()
                        if n:find("owner") or n:find("dono") or n:find("proprietario") then obj.Value = "" end
                        if n:find("lock") or n:find("tranca") then if obj:IsA("BoolValue") then obj.Value = false else obj.Value = 0 end end
                    end
                end
                
                -- Se encontrar o assento, força o teleporte do boneco e executa a função nativa de sentar
                if targetSeat then
                    root.CFrame = targetSeat.CFrame * CFrame.new(0, 1, 0)
                    task.wait(0.1)
                    targetSeat:Sit(hum)
                end
            end)
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "🔓 Ignorando travas e assumindo o controle!", Duration = 3 })
        else
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "❌ Nenhum veículo encontrado.", Duration = 2 })
        end
    end
})

-- ========== ABA ARMAS (PULLING FÍSICO VIA TELEPORTE DE HANDLE) ==========
ArmasTab:CreateInput({
    Name = "Nome da Arma (Completo ou Parte)",
    PlaceholderText = "Ex: Gun ou AK-47",
    RemoveTextAfterFocusLost = false,
    Callback = function(v) toolGrabName = v end
})

ArmasTab:CreateButton({
    Name = "🔫 Puxar Arma Real por Simulação de Toque",
    Callback = function()
        local name = toolGrabName
        if name == "" then 
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "❌ Digite um nome para pesquisar.", Duration = 2 })
            return 
        end
        
        local char = Player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local toolsFound = {}
        
        -- Escaneia o Workspace à procura de armas soltas
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") and string.find(obj.Name:lower(), name:lower()) then
                table.insert(toolsFound, obj)
            end
        end

        -- Escaneia outros containers permitidos
        local alternativeContainers = {game:GetService("Lighting"), game:GetService("ReplicatedStorage"), game:GetService("StarterPack")}
        for _, container in ipairs(alternativeContainers) do
            pcall(function()
                for _, obj in ipairs(container:GetDescendants()) do
                    if obj:IsA("Tool") and string.find(obj.Name:lower(), name:lower()) then
                        table.insert(toolsFound, obj)
                    end
                end
            end)
        end

        if #toolsFound == 0 then
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "❌ Nenhuma arma com esse nome foi achada.", Duration = 2 })
            return
        end

        local totalGrabbed = 0
        for _, tool in ipairs(toolsFound) do
            pcall(function()
                -- Localiza a parte física principal da arma (geralmente chamada Handle)
                local physicalPart = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
                if physicalPart then
                    -- TELEPORTE FÍSICO DO OBJETO PARA O SEU BONECO
                    -- Isso aciona o coletor automático do motor do servidor (TouchInterest)
                    local oldCFrame = physicalPart.CFrame
                    physicalPart.CanCollide = false
                    physicalPart.Anchored = false
                    physicalPart.CFrame = root.CFrame
                    
                    -- Também tenta forçar a injeção local caso o mapa permita
                    tool.Parent = Player:FindFirstChild("Backpack")
                    totalGrabbed = totalGrabbed + 1
                end
            end)
        end

        if totalGrabbed > 0 then
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "✅ " .. totalGrabbed .. " tentativa(s) de indução executada(s)!", Duration = 3 })
        else
            Rayfield:Notify({ Title = "SOUZA MODS", Content = "❌ Falha crítica: O servidor bloqueia fisicamente a arma.", Duration = 3 })
        end
    end
})

-- ========== ABA MOVIMENTO ==========
MovementTab:CreateToggle({ Name = "Pulo Infinito", CurrentValue = false, Flag = "InfJump_Toggle", Callback = function(v) infJump = v end })
MovementTab:CreateToggle({ Name = "Fly Suave (Estabilizado)", CurrentValue = false, Flag = "Fly_Toggle", Callback = function(v) flyEnabled = v end })

MovementTab:CreateSlider({
    Name = "Velocidade Fly",
    Range = {20, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 50,
    Flag = "FlySpeed_Slider",
    Callback = function(v) flySpeed = v end
})

MovementTab:CreateToggle({ Name = "Speed Hack (CFrame Stealth)", CurrentValue = false, Flag = "Speed_Toggle", Callback = function(v) speedEnabled = v end })

MovementTab:CreateSlider({
    Name = "Velocidade Speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "",
    CurrentValue = 24,
    Flag = "SpeedValue_Slider",
    Callback = function(v) speedValue = v end
})

-- ========== ABA CONFIG ==========
ConfigTab:CreateToggle({ Name = "Anti Live", CurrentValue = false, Flag = "AntiLive_Toggle", Callback = function(v) antiLive = v end })

-- ========== MOTORES DE EXECUÇÃO INTERNA INTERMEDIÁRIA ==========
local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
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

local function getPlayerMoney(plr)
    local s, res = pcall(function()
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
    end)
    return s and res or nil
end

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

local function updateESP()
    for p, box in pairs(boxes) do if not p.Parent then pcall(function() box:Remove() end); boxes[p]=nil end end
    for p, data in pairs(skeletons) do if not p.Parent then for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end end
    for p, tag in pairs(nameTags) do if not p.Parent then pcall(function() tag:Remove() end); nameTags[p]=nil end end
    for p, bar in pairs(healthBars) do if not p.Parent then pcall(function() bar.bg:Remove(); bar.fill:Remove() end); healthBars[p]=nil end end
    for p, line in pairs(rainbowLines) do if not p.Parent then pcall(function() line:Remove() end); rainbowLines[p]=nil end end
    for part, obj in pairs(itemESP) do if not part.Parent then pcall(function() obj:Remove() end); itemESP[part]=nil end end

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
            else if boxes[p] then boxes[p].Visible=false end end
        else if boxes[p] then pcall(function() boxes[p]:Remove() end); boxes[p]=nil end end

        if espSkel and useDrawing then
            if not skeletons[p] then
                skeletons[p] = {}
                local bones = {}
                for _, pair in ipairs({
                    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
                    {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
                    {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},
                    {"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},
                    {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"}
                }) do
                    local a = char:FindFirstChild(pair[1]); local b = char:FindFirstChild(pair[2])
                    if a and b then table.insert(bones, {a,b}) end
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
                    else data.line.Visible = false end
                else data.line.Visible = false end
            end
        else
            if skeletons[p] then for _, d in ipairs(skeletons[p]) do pcall(function() d.line:Remove() end) end skeletons[p] = nil end
        end

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

        if espLines and useDrawing then
            local myChar = Player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos, myVis = Camera:WorldToViewportPoint(myChar.HumanoidRootPart.Position)
                local enemyPos, enemyVis = Camera:WorldToViewportPoint(char.Head.Position)
                if myVis and enemyVis then
                    if not rainbowLines[p] then
                        pcall(function() local line = Drawing.new("Line"); line.Thickness=2 rainbowLines[p] = line end)
                    end
                    if rainbowLines[p] then
                        rainbowLines[p].From = Vector2.new(myPos.X, myPos.Y)
                        rainbowLines[p].To = Vector2.new(enemyPos.X, enemyPos.Y)
                        rainbowLines[p].Color = Color3.fromHSV((tick()*50%255)/255,1,1)
                        rainbowLines[p].Visible = true
                    end
                else if rainbowLines[p] then rainbowLines[p].Visible = false end end
            end
        else for p, line in pairs(rainbowLines) do pcall(function() line:Remove() end); rainbowLines[p]=nil end end
    end

    if fovCircleObj then
        fovCircleObj.Position = Camera.ViewportSize / 2
        fovCircleObj.Radius = fovRadius
        fovCircleObj.Visible = fovCircle
        if fovCircle and fovRainbow then fovCircleObj.Color = Color3.fromHSV((tick()%5)/5,1,1)
        else fovCircleObj.Color = Color3.new(1,1,1) end
    end
end

-- ========== ENGINE DO FLY ATUALIZADA ==========
local function flyStep()
    if not flyEnabled then return end
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    pcall(function()
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end)

    local camCFrame = Camera.CFrame
    local moveDir = Vector3.zero
    local moving = false

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector moving = true end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector moving = true end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector moving = true end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector moving = true end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) moving = true end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) moving = true end

    hum:ChangeState(Enum.HumanoidStateType.Physics)

    if moving and moveDir.Magnitude > 0 then
        root.CFrame = root.CFrame + (moveDir.Unit * (flySpeed * 0.016))
    else
        root.CFrame = CFrame.new(root.CFrame.Position) * CFrame.Angles(0, math.rad(root.Rotation.Y), 0)
    end
end

-- ========== ENGINE DO SPEED ==========
local function speedStep()
    if not speedEnabled or flyEnabled then return end
    local char = Player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and root) then return end

    if hum.MoveDirection.Magnitude > 0 then
        local extraSpeed = speedValue - 16
        if extraSpeed > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * (extraSpeed * 0.016))
        end
    end
end

local staffFrame
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
    pcall(function()
        local pGui = Player:FindFirstChildOfClass("PlayerGui")
        if pGui then
            local staffGui = Instance.new("ScreenGui", pGui)
            staffGui.Name = "StaffCounter"
            staffFrame = Instance.new("TextLabel", staffGui)
            staffFrame.Size = UDim2.new(0, 80, 0, 30)
            staffFrame.Position = UDim2.new(0.8, -40, 0.1, 0)
            staffFrame.BackgroundColor3 = Color3.new(0,0,0)
            staffFrame.Text = "Staff: 0"
            staffFrame.TextColor3 = Color3.new(0,1,0)
            staffFrame.Font = Enum.Font.SourceSansBold
            staffFrame.TextSize = 14
            Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0,4)
        end
    end)
end)

UserInputService.JumpRequest:Connect(function()
    if infJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        pcall(function()
            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

-- Loop Geral Primário
local lastLiveCheck = 0
RunService.RenderStepped:Connect(function()
    pcall(aimbotStep)
    pcall(updateESP)
    pcall(flyStep)
    pcall(speedStep)
    pcall(updateStaffCounter)
    if antiLive and tick() - lastLiveCheck > 1 then
        lastLiveCheck = tick()
        pcall(function()
            local pGui = Player:FindFirstChildOfClass("PlayerGui")
            if pGui then
                Window.Enabled = not (pGui:FindFirstChild("LiveIndicator") ~= nil)
            end
        end)
    end
end)
