-- SZ MODS – Versão limpa, sem Wallshot, sem travamentos
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

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
local espLines = false
local showNameHealth = false
local silentAim = false
local infJump = false
local godmode = false
local antiLive = true

-- Desenhos
local fov = Drawing.new("Circle")
fov.Visible = false
fov.Thickness = 2
fov.Radius = fovRadius
fov.Color = Color3.new(1,1,1)
fov.Filled = false
fov.Position = Camera.ViewportSize/2

local boxes, skeletons, nameTags, healthBars, rainbowLines = {}, {}, {}, {}, {}

-- ==================== AIMBOT (COM BYPASS) ====================
local function aimbotStep()
    if not aimbot then return end
    local enemies = {}
    local center = Camera.ViewportSize/2
    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local chr = p.Character
        if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
            local pos, on = Camera:WorldToViewportPoint(chr.Head.Position)
            if on and (Vector2.new(pos.X,pos.Y)-center).Magnitude <= fovRadius then
                table.insert(enemies, {chr = chr, dist = (Vector2.new(pos.X,pos.Y)-center).Magnitude})
            end
        end
    end
    if #enemies == 0 then return end
    table.sort(enemies, function(a,b) return a.dist < b.dist end)
    local targetPos = enemies[1].chr.Head.Position + Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)*(bypass*0.05)
    local alpha = 0.02 + (aimForce-1)*0.245
    if alpha >= 1 then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    else
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha)
    end
end

-- ==================== SILENT AIM ====================
local function silentAimStep()
    if not silentAim then return end
    local enemies = {}
    local center = Camera.ViewportSize/2
    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local chr = p.Character
        if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
            local pos, on = Camera:WorldToViewportPoint(chr.Head.Position)
            if on and (Vector2.new(pos.X,pos.Y)-center).Magnitude <= fovRadius then
                table.insert(enemies, {chr = chr, dist = (Vector2.new(pos.X,pos.Y)-center).Magnitude})
            end
        end
    end
    if #enemies == 0 then return end
    table.sort(enemies, function(a,b) return a.dist < b.dist end)
    local target = enemies[1].chr.Head
    local screenPos = Camera:WorldToViewportPoint(target.Position)
    pcall(function()
        local VirtualInputManager = game:GetService("VirtualInputManager")
        VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, true, game, 0)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(screenPos.X, screenPos.Y, 0, false, game, 0)
    end)
end

-- ==================== INF JUMP ====================
local jumpConnection
local function enableInfJump()
    if jumpConnection then return end
    jumpConnection = UserInputService.JumpRequest:Connect(function()
        if infJump then
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end
local function disableInfJump()
    if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
end

-- ==================== GODMODE (REGERA VIDA) ====================
local godmodeConnection
local function enableGodmode()
    godmode = true
    if godmodeConnection then return end
    godmodeConnection = RunService.RenderStepped:Connect(function()
        if not godmode then return end
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = char.Humanoid.MaxHealth
        end
    end)
end
local function disableGodmode()
    godmode = false
    if godmodeConnection then godmodeConnection:Disconnect(); godmodeConnection = nil end
end

-- ==================== ESP (BOX, SKELETON, NAME/HEALTH, RAINBOW LINES) ====================
local function updateESP()
    -- limpeza
    for p, box in pairs(boxes) do if not p.Parent then box:Remove(); boxes[p]=nil end end
    for p, data in pairs(skeletons) do if not p.Parent then for _,d in ipairs(data) do d.line:Remove() end; skeletons[p]=nil end end
    for p, tag in pairs(nameTags) do if not p.Parent then tag:Remove(); nameTags[p]=nil end end
    for p, bar in pairs(healthBars) do if not p.Parent then bar.bg:Remove(); bar.fill:Remove(); healthBars[p]=nil end end
    for p, line in pairs(rainbowLines) do if not p.Parent then line:Remove(); rainbowLines[p]=nil end end

    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Head") then
            if boxes[p] then boxes[p]:Remove(); boxes[p]=nil end
            if skeletons[p] then for _,d in ipairs(skeletons[p]) do d.line:Remove() end; skeletons[p]=nil end
            if nameTags[p] then nameTags[p]:Remove(); nameTags[p]=nil end
            if healthBars[p] then healthBars[p].bg:Remove(); healthBars[p].fill:Remove(); healthBars[p]=nil end
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
            if healthBars[p] then healthBars[p].bg.Visible = false; healthBars[p].fill.Visible = false end
            if rainbowLines[p] then rainbowLines[p].Visible = false end
            continue
        end

        -- Box
        if espBox then
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")
            if head and root then
                local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.5,0))
                local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
                if top and bot then
                    local h = math.abs(top.Y - bot.Y); local w = h*0.45; local cx = (top.X+bot.X)/2
                    if not boxes[p] then
                        local box = Drawing.new("Square"); box.Thickness = 2; box.Color = Color3.new(1,0,0); box.Filled = false
                        boxes[p] = box
                    end
                    boxes[p].Position = Vector2.new(cx-w/2, top.Y); boxes[p].Size = Vector2.new(w,h); boxes[p].Visible = true
                else if boxes[p] then boxes[p].Visible = false end end
            end
        else if boxes[p] then boxes[p]:Remove(); boxes[p]=nil end end

        -- Esqueleto
        if espSkel then
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
                    local line = Drawing.new("Line"); line.Thickness = 1; line.Color = Color3.new(1,1,1)
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
        else if skeletons[p] then for _,d in ipairs(skeletons[p]) do d.line:Remove() end; skeletons[p]=nil end end

        -- Nome e barra de vida
        if showNameHealth then
            local headPos, on = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0,1.5,0))
            if on then
                if not nameTags[p] then
                    local tag = Drawing.new("Text"); tag.Center = true; tag.Size = 14; tag.Outline = true; tag.OutlineColor = Color3.new(0,0,0)
                    nameTags[p] = tag
                end
                nameTags[p].Text = p.Name; nameTags[p].Position = Vector2.new(headPos.X, headPos.Y-10); nameTags[p].Color = Color3.new(1,1,1); nameTags[p].Visible = true

                local bw, bh = 50, 4
                local bx, by = headPos.X - bw/2, headPos.Y + 2
                if not healthBars[p] then
                    local bg = Drawing.new("Line"); bg.Color = Color3.new(0.15,0.15,0.15); bg.Thickness = bh
                    local fill = Drawing.new("Line"); fill.Color = Color3.new(0,1,0); fill.Thickness = bh
                    healthBars[p] = {bg=bg, fill=fill}
                end
                healthBars[p].bg.From = Vector2.new(bx, by); healthBars[p].bg.To = Vector2.new(bx+bw, by); healthBars[p].bg.Visible = true
                local percent = math.clamp(health/maxHealth,0,1)
                local fw = bw * percent
                healthBars[p].fill.From = Vector2.new(bx, by); healthBars[p].fill.To = Vector2.new(bx+fw, by)
                healthBars[p].fill.Color = percent>0.5 and Color3.new(0,1,0) or (percent>0.25 and Color3.new(1,1,0) or Color3.new(1,0,0))
                healthBars[p].fill.Visible = true
            else
                if nameTags[p] then nameTags[p].Visible = false end
                if healthBars[p] then healthBars[p].bg.Visible=false; healthBars[p].fill.Visible=false end
            end
        else
            if nameTags[p] then nameTags[p]:Remove(); nameTags[p]=nil end
            if healthBars[p] then healthBars[p].bg:Remove(); healthBars[p].fill:Remove(); healthBars[p]=nil end
        end

        -- Linhas arco-íris
        if espLines then
            local myChar = Player.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local myPos, myVis = Camera:WorldToViewportPoint(myChar.HumanoidRootPart.Position)
                local enemyPos, enemyVis = Camera:WorldToViewportPoint(char.Head.Position)
                if myVis and enemyVis then
                    if not rainbowLines[p] then
                        local line = Drawing.new("Line"); line.Thickness = 2
                        rainbowLines[p] = line
                    end
                    rainbowLines[p].From = Vector2.new(myPos.X, myPos.Y); rainbowLines[p].To = Vector2.new(enemyPos.X, enemyPos.Y)
                    rainbowLines[p].Color = Color3.fromHSV((tick()*50%255)/255,1,1); rainbowLines[p].Visible = true
                else if rainbowLines[p] then rainbowLines[p].Visible = false end end
            end
        else for p, line in pairs(rainbowLines) do line:Remove(); rainbowLines[p]=nil end end
    end
end

-- FOV Circle
local function updateFOV()
    fov.Position = Camera.ViewportSize/2; fov.Radius = fovRadius; fov.Visible = fovCircle
    if fovCircle and fovRainbow then fov.Color = Color3.fromHSV((tick()%5)/5,1,1) else fov.Color = Color3.new(1,1,1) end
end

-- ==================== RAYFIELD UI ====================
local Window = Rayfield:CreateWindow({
    Name = "SZ MODS",
    LoadingTitle = "Carregando...",
    LoadingSubtitle = "por Souza",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false
})

local CombatTab = Window:CreateTab("Combate", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local MovementTab = Window:CreateTab("Movimento", 4483362458)
local ConfigTab = Window:CreateTab("Config", 4483362458)

-- Combate
CombatTab:CreateToggle({Name="Aimbot", CurrentValue=false, Callback=function(v) aimbot=v end})
CombatTab:CreateSlider({Name="Força", Range={1,5}, Increment=1, CurrentValue=1, Callback=function(v) aimForce=v end})
CombatTab:CreateSlider({Name="Bypass", Range={1,10}, Increment=1, CurrentValue=1, Callback=function(v) bypass=v end})
CombatTab:CreateToggle({Name="Silent Aim", CurrentValue=false, Callback=function(v) silentAim=v end})
CombatTab:CreateToggle({Name="Godmode (Vida)", CurrentValue=false, Callback=function(v) if v then enableGodmode() else disableGodmode() end end})

-- Visual
VisualTab:CreateToggle({Name="ESP Box", CurrentValue=false, Callback=function(v) espBox=v end})
VisualTab:CreateToggle({Name="ESP Esqueleto", CurrentValue=false, Callback=function(v) espSkel=v end})
VisualTab:CreateToggle({Name="Nome / Vida", CurrentValue=false, Callback=function(v) showNameHealth=v end})
VisualTab:CreateToggle({Name="Linhas Arco-íris", CurrentValue=false, Callback=function(v) espLines=v end})
VisualTab:CreateToggle({Name="Círculo FOV", CurrentValue=false, Callback=function(v) fovCircle=v end})
VisualTab:CreateToggle({Name="FOV Arco-íris", CurrentValue=false, Callback=function(v) fovRainbow=v end})
VisualTab:CreateSlider({Name="Raio FOV", Range={50,500}, Increment=10, CurrentValue=150, Callback=function(v) fovRadius=v end})

-- Movimento
MovementTab:CreateToggle({Name="Pulo Infinito", CurrentValue=false, Callback=function(v) infJump=v; if v then enableInfJump() else disableInfJump() end end})

-- Config
ConfigTab:CreateToggle({Name="Anti Live", CurrentValue=true, Callback=function(v) antiLive=v end})

-- ==================== LOOPS ====================
local lastLive = 0
RunService.RenderStepped:Connect(function()
    aimbotStep()
    silentAimStep()
    updateESP()
    updateFOV()

    if antiLive and tick()-lastLive > 1 then
        lastLive = tick()
        Window.Enabled = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
    end
end)

-- Limpeza
script.Destroying:Connect(function()
    disableInfJump()
    disableGodmode()
    fov:Remove()
    for _, box in pairs(boxes) do box:Remove() end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do d.line:Remove() end end
    for _, tag in pairs(nameTags) do tag:Remove() end
    for _, bar in pairs(healthBars) do bar.bg:Remove(); bar.fill:Remove() end
    for _, line in pairs(rainbowLines) do line:Remove() end
end)

print("SZ MODS limpo carregado – sem Wallshot, sem travamentos")
