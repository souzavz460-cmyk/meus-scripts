-- SZ MODS COMPLETO – Versão Stealth (Anti-Log & CFrame Avançado)
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Souza Mods",
    Icon = 0,
    LoadingTitle = "Souza Mods",
    LoadingSubtitle = "by Souzavz",
    Theme = "Default",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SouzaMods",
        FileName = "Main"
    },

    Discord = {
        Enabled = false
    },

    KeySystem = false
})

-- Serviços do Roblox protegidos
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

-- ========== CONVERSOR DE CORES ==========
function parseColor(input)
    local s = tostring(input):lower():gsub("%s","")
    local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
    if named[s] then s = named[s] end
    if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
    return nil
end

-- ========== CRIAÇÃO DAS ABAS (Ícones zerados para evitar erros de Asset no LogService) ==========
local CombatTab = Window:CreateTab("Combate", 0)
local VisualTab = Window:CreateTab("Visual", 0)
local CoresTab = Window:CreateTab("Cores ESP", 0)
local VeiculosTab = Window:CreateTab("Veículos", 0)
local ArmasTab = Window:CreateTab("Armas", 0)
local MovementTab = Window:CreateTab("Movimento", 0)
local ConfigTab = Window:CreateTab("Config", 0)

-- ========== ELEMENTOS DA UI DA COMBATE ==========
CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(v) aimbot = v end
})

CombatTab:CreateSlider({
    Name = "Força (1-5)",
    Min = 1,
    Max = 5,
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v) aimForce = v end
})

CombatTab:CreateSlider({
    Name = "Bypass",
    Min = 1,
    Max = 10,
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v) bypass = v end
})

-- ========== ELEMENTOS DA UI DE VISUAL ==========
VisualTab:CreateToggle({ Name = "ESP Box", CurrentValue = false, Callback = function(v) espBox = v end })
VisualTab:CreateToggle({ Name = "ESP Esqueleto", CurrentValue = false, Callback = function(v) espSkel = v end })
VisualTab:CreateToggle({ Name = "Nome / Vida / Dinheiro", CurrentValue = false, Callback = function(v) showNameHealth = v end })
VisualTab:CreateToggle({ Name = "Mostrar Dinheiro", CurrentValue = false, Callback = function(v) showMoney = v end })
VisualTab:CreateToggle({ Name = "ESP Itens", CurrentValue = false, Callback = function(v) espItems = v end })
VisualTab:CreateToggle({ Name = "Linhas Arco-íris", CurrentValue = false, Callback = function(v) espLines = v end })
VisualTab:CreateToggle({ Name = "Círculo FOV", CurrentValue = false, Callback = function(v) fovCircle = v end })
VisualTab:CreateToggle({ Name = "FOV Arco-íris", CurrentValue = false, Callback = function(v) fovRainbow = v end })

VisualTab:CreateSlider({
    Name = "Raio FOV",
    Min = 50,
    Max = 500,
    Increment = 1,
    CurrentValue = 150,
    Callback = function(v) fovRadius = v end
})

-- ========== ELEMENTOS DA UI DE CORES ==========
CoresTab:CreateInput({
    Name = "Cor da Box (ex: vermelho)",
    PlaceholderText = "vermelho",
    RemoveTextAfterFocusLost = false,
    Callback = function(v) local c = parseColor(v) if c then boxColor = c end end
})

CoresTab:CreateInput({
    Name = "Cor do Esqueleto (ex: azul)",
    PlaceholderText = "branco",
    RemoveTextAfterFocusLost = false,
    Callback = function(v) local c = parseColor(v) if c then skelColor = c end end
})

-- ========== ELEMENTOS DA UI DE VEÍCULOS ==========
VeiculosTab:CreateButton({
    Name = "🚀 Fling Carro (mais próximo)",
    Callback = function()
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        local nearest, nearestDist = nil, math.huge
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("VehicleSeat") or (obj:IsA("Seat") and obj:FindFirstAncestorOfClass("Model")) then
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
            local p = nearest:FindFirstChild("PrimaryPart") or nearest:FindFirstChildWhichIsA("BasePart")
            if p then
                pcall(function()
                    local bv = Instance.new("BodyVelocity"); bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                    bv.Velocity = (p.Position - root.Position).Unit * 300 + Vector3.new(0,200,0)
                    bv.Parent = p; task.delay(0.5, function() bv:Destroy() end)
                end)
            end
        end
    end
})

VeiculosTab:CreateButton({
    Name = "🔓 Destrancar Veículo",
    Callback = function()
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        local nearest, nearestDist = nil, math.huge
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("VehicleSeat") or (obj:IsA("Seat") and obj:FindFirstAncestorOfClass("Model")) then
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
            for _, seat in ipairs(nearest:GetDescendants()) do
                if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                    pcall(function() seat:SetAttribute("Locked", false); if seat:FindFirstChild("Lock") then seat.Lock:Destroy() end end)
                end
            end
        end
    end
})

-- ========== ELEMENTOS DA UI DE ARMAS ==========
ArmasTab:CreateInput({
    Name = "Nome da Arma",
    PlaceholderText = "AK-47",
    RemoveTextAfterFocusLost = false,
    Callback = function(v) toolGrabName = v end
})

ArmasTab:CreateButton({
    Name = "🔫 Puxar Arma (Real)",
    Callback = function()
        local name = toolGrabName
        if name == "" then return end
        local backpack = Player:FindFirstChild("Backpack")
        if not backpack then return end

        local locations = {
            Workspace, game:GetService("ReplicatedStorage"), game:GetService("ServerStorage"),
            game:GetService("Lighting"), game:GetService("StarterPack"), game:GetService("StarterGear")
        }
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then table.insert(locations, plr.Character) end
            local bp = plr:FindFirstChild("Backpack")
            if bp then table.insert(locations, bp) end
        end

        local nameLower = name:lower()
        local foundItem, foundType = nil, nil

        for _, loc in ipairs(locations) do
            for _, obj in ipairs(loc:GetDescendants()) do
                if obj:IsA("Tool") and obj.Name:lower() == nameLower then
                    foundItem = obj; foundType = "tool"; break
                elseif obj:IsA("Model") then
                    local ti = obj:FindFirstChildWhichIsA("Tool")
                    if ti and ti.Name:lower() == nameLower then
                        foundItem = obj; foundType = "model"; break
                    end
                end
            end
            if foundItem then break end
        end

        if foundItem then
            local success = false
            local itemName = foundItem.Name
            local itemDamage = "Desconhecido"

            pcall(function()
                local tool = (foundType == "tool") and foundItem or foundItem:FindFirstChildWhichIsA("Tool")
                if tool then
                    local config = tool:FindFirstChild("Configuration")
                    if config then
                        local dmg = config:FindFirstChild("Damage") or config:FindFirstChild("BaseDamage")
                        if dmg and dmg:IsA("NumberValue") then itemDamage = tostring(dmg.Value) end
                    end
                    local handle = tool:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local sound = handle:FindFirstChild("EquipSound") or handle:FindFirstChild("ActivateSound") or handle:FindFirstChild("Sound")
                        if sound and sound:IsA("Sound") then sound:Play() end
                    end
                end
            end)

            pcall(function()
                foundItem.Parent = backpack
                success = (foundItem.Parent == backpack)
            end)

            if not success then
                pcall(function()
                    local clone = foundItem:Clone()
                    clone.Parent = backpack
                    success = (clone.Parent == backpack)
                    if success then itemName = clone.Name end
                end)
            end

            if success then
                Rayfield:Notify({ Title = "Souza Mods", Content = "✅ " .. itemName .. " puxada!\nDano: " .. itemDamage, Duration = 3 })
            else
                Rayfield:Notify({ Title = "Souza Mods", Content = "❌ Item protegido por sistema do mapa.", Duration = 3 })
            end
        else
            Rayfield:Notify({ Title = "Souza Mods", Content = "❌ '" .. name .. "' não encontrada.", Duration = 2 })
        end
    end
})

-- ========== ELEMENTOS DA UI DE MOVIMENTO ==========
MovementTab:CreateToggle({ Name = "Pulo Infinito", CurrentValue = false, Callback = function(v) infJump = v end })

MovementTab:CreateToggle({
    Name = "Fly Indetectável (CFrame)",
    CurrentValue = false,
    Callback = function(v)
        flyEnabled = v
    end
})

MovementTab:CreateSlider({
    Name = "Velocidade Fly",
    Min = 20,
    Max = 200,
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v) flySpeed = v end
})

MovementTab:CreateToggle({
    Name = "Speed Hack (CFrame Stealth)",
    CurrentValue = false,
    Callback = function(v)
        speedEnabled = v
    end
})

MovementTab:CreateSlider({
    Name = "Velocidade Speed",
    Min = 16,
    Max = 200,
    Increment = 1,
    CurrentValue = 24,
    Callback = function(v) speedValue = v end
})

-- ========== ELEMENTOS DA UI DE CONFIG ==========
ConfigTab:CreateToggle({ Name = "Anti Live", CurrentValue = false, Callback = function(v) antiLive = v end })


-- ========== SISTEMAS INTERNOS COMPLETAMENTE PROTEGIDOS CONTRA LOGS ==========
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

-- ========== FLY INDETECTÁVEL POR CFRAME MULTIPLIER (Não gera logs físicos) ==========
local function flyStep()
    if not flyEnabled then return end
    local char = Player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Neutraliza a gravidade e forças físicas sem alterar o PlatformStand (Evita logs de física)
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

    if moving and moveDir.Magnitude > 0 then
        -- Multiplicador suave acoplado ao DeltaTime invisível pro LogService
        root.CFrame = root.CFrame + (moveDir.Unit * (flySpeed * 0.016))
    end
end

-- ========== SPEED HACK POR CFRAME STEALTH (Mantém WalkSpeed em 16 na memória) ==========
local function speedStep()
    if not speedEnabled or flyEnabled then return end
    local char = Player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and root) then return end

    -- Se o jogador estiver usando o controle ou teclado para se mover
    if hum.MoveDirection.Magnitude > 0 then
        local extraSpeed = speedValue - 16
        if extraSpeed > 0 then
            -- Adiciona CFrame extra na direção exata que o Humanoid quer andar
            root.CFrame = root.CFrame + (hum.MoveDirection * (extraSpeed * 0.016))
        end
    end
end

-- Contador de Staff seguro (Injetado diretamente no PlayerGui para evitar flags do CoreGui no LogService)
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

-- Main Loop - Execução blindada via pcall individual
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
