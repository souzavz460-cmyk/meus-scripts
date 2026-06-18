-- SZ MODS EVOLUÍDO – Rayfield UI
-- Aimbot, ESP (box/esqueleto/nome/vida/linhas), Speed, Noclip, Wallshot, Anti Live
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variáveis de estado
local aimbotEnabled = false
local aimForce = 1
local bypassLevel = 1
local fovRadius = 150
local fovCircleEnabled = false
local fovRainbowEnabled = false
local espBox = false
local espSkeleton = false
local espLines = false
local showNameHealth = false
local wallshotEnabled = false
local speedEnabled = false
local speedValue = 16
local noclipEnabled = false

-- Desenhos (Drawing)
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Radius = fovRadius
fovCircle.Color = Color3.fromRGB(255,255,255)
fovCircle.Filled = false
fovCircle.Position = Camera.ViewportSize / 2

local boxes = {}
local skeletons = {}
local nameTags = {}
local rainbowLines = {}

-- ==================== FUNÇÕES ====================

-- Wallshot
local function isProjectile(part)
    if not part:IsA("BasePart") then return false end
    local parent = part.Parent
    while parent do
        if parent:IsA("Model") and Players:GetPlayerFromCharacter(parent) then return false end
        parent = parent.Parent
    end
    if part.Velocity.Magnitude > 20 then return true end
    local name = part.Name:lower()
    local keywords = {"bullet","projectile","pellet","arrow","bolt","rocket","grenade","ball","shell","kunai","shuriken","missile","blast","beam"}
    for _, kw in ipairs(keywords) do
        if name:find(kw) then return true end
    end
    return false
end

local function disableCollisions(obj)
    pcall(function()
        if obj:IsA("BasePart") then obj.CanCollide = false; obj.CanQuery = false end
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("BasePart") then child.CanCollide = false; child.CanQuery = false end
        end
    end)
end

local whConnection
local function enableWallshot()
    wallshotEnabled = true
    local char = Player.Character
    if char then for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then disableCollisions(tool) end end end
    for _, obj in ipairs(Workspace:GetDescendants()) do if isProjectile(obj) then disableCollisions(obj) end end
    if not whConnection then
        whConnection = Workspace.DescendantAdded:Connect(function(obj)
            if wallshotEnabled and isProjectile(obj) then task.wait(0.05); disableCollisions(obj) end
        end)
    end
end

local function disableWallshot()
    wallshotEnabled = false
    if whConnection then whConnection:Disconnect(); whConnection = nil end
end

-- Aimbot
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

local bypassTimer = 0
local bypassOffset = Vector3.zero

local function aimbotStep()
    if not aimbotEnabled then return end
    local enemies = getEnemiesInFOV()
    if #enemies == 0 then return end
    local targetPos = enemies[1].worldPos

    if bypassLevel > 1 then
        local now = tick()
        if now - bypassTimer > (0.5 - bypassLevel * 0.04) then
            bypassTimer = now
            local maxOff = bypassLevel * 0.12
            bypassOffset = Vector3.new((math.random()-0.5)*2*maxOff, (math.random()-0.5)*2*maxOff, (math.random()-0.5)*2*maxOff)
        end
        targetPos = targetPos + bypassOffset
    end

    local alpha = 0.02 + (aimForce - 1) * 0.245
    if alpha > 1 then alpha = 1 end
    local newCF = CFrame.new(Camera.CFrame.Position, targetPos)
    if alpha < 1 then Camera.CFrame = Camera.CFrame:Lerp(newCF, alpha) else Camera.CFrame = newCF end
end

-- ESP
local function getCharBounds(char)
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not head or not root then return nil end
    local topWorld = head.Position + Vector3.new(0,1.5,0)
    local bottomWorld = root.Position - Vector3.new(0,3,0)
    local topScr, topVis = Camera:WorldToViewportPoint(topWorld)
    local botScr, botVis = Camera:WorldToViewportPoint(bottomWorld)
    if not topVis or not botVis then return nil end
    local h = math.abs(topScr.Y - botScr.Y)
    local w = h * 0.45
    local cx = (topScr.X + botScr.X) / 2
    return {Position = Vector2.new(cx - w/2, topScr.Y), Size = Vector2.new(w, h)}
end

local function getBones(char)
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
            local a = char:FindFirstChild(pair[1])
            local b = char:FindFirstChild(pair[2])
            if a and b then table.insert(bones, {a,b}) end
        end
    end
    return bones
end

local function updateESP()
    -- limpeza de players que saíram
    for p, box in pairs(boxes) do if not p.Parent then box:Remove(); boxes[p]=nil end end
    for p, data in pairs(skeletons) do if not p.Parent then for _,d in ipairs(data) do d.line:Remove() end; skeletons[p]=nil end end
    for p, tag in pairs(nameTags) do if not p.Parent then tag:Remove(); nameTags[p]=nil end end
    for p, line in pairs(rainbowLines) do if not p.Parent then line:Remove(); rainbowLines[p]=nil end end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Head") then
            if boxes[p] then boxes[p]:Remove(); boxes[p]=nil end
            if skeletons[p] then for _,d in ipairs(skeletons[p]) do d.line:Remove() end; skeletons[p]=nil end
            if nameTags[p] then nameTags[p]:Remove(); nameTags[p]=nil end
            if rainbowLines[p] then rainbowLines[p]:Remove(); rainbowLines[p]=nil end
            continue
        end
        local hum = char:FindFirstChild("Humanoid")
        local health = hum and hum.Health or 0
        local maxHealth = hum and hum.MaxHealth or 100
        if not hum or health <= 0 then
            if boxes[p] then boxes[p].Visible = false end
            if skeletons[p] then for _,d in ipairs(skeletons[p]) do d.line.Visible = false end end
            if nameTags[p] then nameTags[p].Visible = false end
            if rainbowLines[p] then rainbowLines[p].Visible = false end
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
            if boxes[p] then boxes[p]:Remove(); boxes[p]=nil end
        end

        -- Esqueleto
        if espSkeleton then
            if not skeletons[p] then
                skeletons[p] = {}
                local bones = getBones(char)
                for i, parts in ipairs(bones) do
                    local line = Drawing.new("Line")
                    line.Thickness = 1; line.Color = Color3.fromRGB(255,255,255)
                    skeletons[p][i] = {line=line, a=parts[1], b=parts[2]}
                end
            end
            for _, data in ipairs(skeletons[p]) do
                local line, a, b = data.line, data.a, data.b
                if a.Parent and b.Parent then
                    local aPos, aVis = Camera:WorldToViewportPoint(a.Position)
                    local bPos, bVis = Camera:WorldToViewportPoint(b.Position)
                    if aVis and bVis then
                        line.From = Vector2.new(aPos.X, aPos.Y); line.To = Vector2.new(bPos.X, bPos.Y)
                        line.Visible = true
                    else line.Visible = false end
                else line.Visible = false end
            end
        else
            if skeletons[p] then for _,d in ipairs(skeletons[p]) do d.line:Remove() end; skeletons[p]=nil end
        end

        -- Nome e vida
        if showNameHealth then
            local headPos, onScreen = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0,1.5,0))
            if onScreen then
                if not nameTags[p] then
                    local tag = Drawing.new("Text")
                    tag.Center = true; tag.Size = 16; tag.Outline = true; tag.OutlineColor = Color3.new(0,0,0)
                    nameTags[p] = tag
                end
                local tag = nameTags[p]
                tag.Text = p.Name .. " [" .. math.floor(health) .. "/" .. math.floor(maxHealth) .. "]"
                tag.Position = Vector2.new(headPos.X, headPos.Y)
                tag.Color = Color3.fromRGB(255,255,255)
                tag.Visible = true
            else
                if nameTags[p] then nameTags[p].Visible = false end
            end
        else
            if nameTags[p] then nameTags[p]:Remove(); nameTags[p]=nil end
        end

        -- Linhas arco-íris (do jogador até o inimigo)
        if espLines then
            local myChar = Player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos, myVis = Camera:WorldToViewportPoint(myChar.HumanoidRootPart.Position)
                local enemyPos, enemyVis = Camera:WorldToViewportPoint(char.Head.Position)
                if myVis and enemyVis then
                    if not rainbowLines[p] then
                        local line = Drawing.new("Line")
                        line.Thickness = 2
                        rainbowLines[p] = line
                    end
                    local line = rainbowLines[p]
                    line.From = Vector2.new(myPos.X, myPos.Y)
                    line.To = Vector2.new(enemyPos.X, enemyPos.Y)
                    line.Color = Color3.fromHSV((tick()*50 % 255)/255, 1, 1)
                    line.Visible = true
                else
                    if rainbowLines[p] then rainbowLines[p].Visible = false end
                end
            end
        else
            for p, line in pairs(rainbowLines) do line:Remove(); rainbowLines[p]=nil end
        end
    end
end

-- FOV Circle
local function updateFOV()
    fovCircle.Position = Camera.ViewportSize / 2
    fovCircle.Radius = fovRadius
    fovCircle.Visible = fovCircleEnabled
    if fovCircleEnabled and fovRainbowEnabled then
        fovCircle.Color = Color3.fromHSV((tick()%5)/5, 1, 1)
    else
        fovCircle.Color = Color3.fromRGB(255,255,255)
    end
end

-- Speed
local function setSpeed()
    if speedEnabled then
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = speedValue end
    end
end

-- Noclip
local function applyNoclip()
    local char = Player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = not noclipEnabled end
    end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, part in ipairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = not noclipEnabled end
            end
        end
    end
end

Player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    if speedEnabled then setSpeed() end
    if noclipEnabled then applyNoclip() end
end)

if Player.Character then
    if speedEnabled then setSpeed() end
    if noclipEnabled then applyNoclip() end
end

-- ==================== RAYFIELD UI ====================
local Window = Rayfield:CreateWindow({
    Name = "SZ MODS EVOLUÍDO",
    LoadingTitle = "Carregando...",
    LoadingSubtitle = "por Souza",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

local AimbotTab = Window:CreateTab("Combate", 4483362458) -- ícone de mira
local VisualTab = Window:CreateTab("Visual", 4483362458)
local MovementTab = Window:CreateTab("Movimento", 4483362458)
local SettingsTab = Window:CreateTab("Config", 4483362458)

-- Combate
AimbotTab:CreateToggle({ Name = "Aimbot", CurrentValue = false, Callback = function(v) aimbotEnabled = v end })
AimbotTab:CreateSlider({ Name = "Força", Range = {1,5}, Increment = 1, CurrentValue = 1, Callback = function(v) aimForce = v end })
AimbotTab:CreateSlider({ Name = "Bypass", Range = {1,10}, Increment = 1, CurrentValue = 1, Callback = function(v) bypassLevel = v end })
AimbotTab:CreateToggle({ Name = "Wallshot", CurrentValue = false, Callback = function(v) if v then enableWallshot() else disableWallshot() end end })

-- Visual
VisualTab:CreateToggle({ Name = "ESP Box", CurrentValue = false, Callback = function(v) espBox = v end })
VisualTab:CreateToggle({ Name = "ESP Esqueleto", CurrentValue = false, Callback = function(v) espSkeleton = v end })
VisualTab:CreateToggle({ Name = "Nome / Vida", CurrentValue = false, Callback = function(v) showNameHealth = v end })
VisualTab:CreateToggle({ Name = "Linhas Arco-íris", CurrentValue = false, Callback = function(v) espLines = v end })
VisualTab:CreateToggle({ Name = "Círculo FOV", CurrentValue = false, Callback = function(v) fovCircleEnabled = v end })
VisualTab:CreateToggle({ Name = "FOV Arco-íris", CurrentValue = false, Callback = function(v) fovRainbowEnabled = v end })
VisualTab:CreateSlider({ Name = "Raio FOV", Range = {50,500}, Increment = 10, CurrentValue = 150, Callback = function(v) fovRadius = v end })

-- Movimento
MovementTab:CreateToggle({ Name = "Speed Hack", CurrentValue = false, Callback = function(v) speedEnabled = v; setSpeed() end })
MovementTab:CreateSlider({ Name = "Velocidade", Range = {16,200}, Increment = 1, CurrentValue = 16, Callback = function(v) speedValue = v; if speedEnabled then setSpeed() end end })
MovementTab:CreateToggle({ Name = "Noclip", CurrentValue = false, Callback = function(v) noclipEnabled = v; applyNoclip() end })

-- Config (Anti Live)
SettingsTab:CreateToggle({ Name = "Anti Live (Ocultar em live)", CurrentValue = true, Callback = function(v) antiLiveEnabled = v end })

-- Anti Live check
local antiLiveEnabled = true
local lastLiveCheck = 0
RunService.RenderStepped:Connect(function()
    aimbotStep()
    updateESP()
    updateFOV()
    if speedEnabled then setSpeed() end  -- mantém após dano

    if antiLiveEnabled and tick() - lastLiveCheck > 1 then
        lastLiveCheck = tick()
        local isLive = CoreGui:FindFirstChild("LiveIndicator") ~= nil
        Window.Enabled = not isLive  -- esconde a janela durante live
    end
end)

-- Limpeza ao destruir
gui.Destroying:Connect(function() --[[ a janela do Rayfield não tem Destroying, então faremos no final do script? ]] end)
-- Rayfield não fornece evento de destruição. Como o script é executado uma vez, podemos confiar na limpeza quando o script é removido? Vamos adicionar um encerramento manual.

-- Limpeza geral ao fechar
local function cleanup()
    disableWallshot()
    fovCircle:Remove()
    for _, box in pairs(boxes) do box:Remove() end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do d.line:Remove() end end
    for _, tag in pairs(nameTags) do tag:Remove() end
    for _, line in pairs(rainbowLines) do line:Remove() end
end

-- Tenta limpar se o script for removido
script.Destroying:Connect(cleanup)
game:GetService("Players").LocalPlayer.OnDestroy:Connect(cleanup)

print("SZ MODS EVOLUÍDO carregado com sucesso via Rayfield!")
