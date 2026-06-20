-- S4zx SUPREMO - ESP estilo imagens + Aimbot + Fly + Duplicador + Veículos
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "S4zx",
   LoadingTitle = "S4zx",
   LoadingSubtitle = "by Souza",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==================== VARIABLES ====================
-- Aimbot
local aimbotEnabled = false
local aimForce = 1
local bypass = 1
local fovRadius = 150
local wallCheck = false
local silentAimEnabled = false

-- Visual (ESP)
local espBox2D = false
local espBox3D = false
local espSkeleton = false
local espTracers = false
local espName = false
local espDistance = false
local espHealth = false
local espChams = false
local fovCircle = false
local fovRainbow = false

-- Colors (conforme imagens: rosa, verde, branco)
local box2DColor = Color3.fromRGB(0,255,0)      -- verde 2D
local box3DColor = Color3.fromRGB(255,0,255)    -- rosa 3D
local skelColor = Color3.fromRGB(255,105,180)   -- rosa skeleton
local tracerColor = Color3.fromRGB(255,255,255) -- branco
local chamsColor = Color3.fromRGB(0,255,0)      -- verde glow

-- Movement
local infJump = false
local flyEnabled = false
local flySpeed = 50
local speedEnabled = false
local speedValue = 24

-- Vehicle
local flingForce = 300

-- Duplicator
local dupeToolName = ""

-- Settings
local antiLive = false

-- ==================== TAB CREATION ====================
local function safeTab(name, icon)
    local t; pcall(function() t = Window:CreateTab(name, icon) end); return t
end
local HomeTab = safeTab("HOME", 4483362458)
local AimbotTab = safeTab("AIMBOT", 4483362458)
local ESPTab = safeTab("ESP", 4483362458)
local VisualTab = safeTab("VISUAL", 4483362458)
local CarTab = safeTab("CAR", 4483362458)
local DupTab = safeTab("DUPLICADOR", 4483362458)
local MoveTab = safeTab("MOVIMENTO", 4483362458)
local ConfigTab = safeTab("CONFIG", 4483362458)

-- ==================== UI CONTROLS ====================
local function safeToggle(tab, name, default, cb) if tab then pcall(function() tab:CreateToggle({Name=name, CurrentValue=default, Callback=cb}) end) end end
local function safeSlider(tab, name, min, max, default, cb) if tab then pcall(function() tab:CreateSlider({Name=name, Min=min, Max=max, Increment=1, CurrentValue=default, Callback=cb}) end) end end
local function safeInput(tab, name, placeholder, cb) if tab then pcall(function() tab:CreateInput({Name=name, PlaceholderText=placeholder, RemoveTextAfterFocusLost=false, Callback=cb}) end) end end
local function safeButton(tab, name, cb) if tab then pcall(function() tab:CreateButton({Name=name, Callback=cb}) end) end end

-- HOME
safeToggle(HomeTab, "Bem-vindo ao S4zx", false, function(v) end) -- decorativo

-- AIMBOT
safeToggle(AimbotTab, "AIMBOT", false, function(v) aimbotEnabled = v end)
safeSlider(AimbotTab, "Força (1-5)", 1, 5, 1, function(v) aimForce = v end)
safeSlider(AimbotTab, "Bypass", 1, 10, 1, function(v) bypass = v end)
safeSlider(AimbotTab, "FOV (Raio)", 50, 500, 150, function(v) fovRadius = v end)
safeToggle(AimbotTab, "WALLCK (Wall Check)", false, function(v) wallCheck = v end)
safeToggle(AimbotTab, "SILENT AIM", false, function(v) silentAimEnabled = v end)

-- ESP
safeToggle(ESPTab, "2D Box (verde)", false, function(v) espBox2D = v end)
safeToggle(ESPTab, "3D Box (rosa)", false, function(v) espBox3D = v end)
safeToggle(ESPTab, "Skeleton (rosa)", false, function(v) espSkeleton = v end)
safeToggle(ESPTab, "Tracers (branco)", false, function(v) espTracers = v end)
safeToggle(ESPTab, "Name ESP", false, function(v) espName = v end)
safeToggle(ESPTab, "Distance ESP", false, function(v) espDistance = v end)
safeToggle(ESPTab, "Health ESP", false, function(v) espHealth = v end)
safeToggle(ESPTab, "Chams (verde glow)", false, function(v) espChams = v end)

-- VISUAL (cores)
safeInput(VisualTab, "Cor Box 2D", "verde", function(v) local c=parseColor(v) if c then box2DColor=c end end)
safeInput(VisualTab, "Cor Box 3D", "rosa", function(v) local c=parseColor(v) if c then box3DColor=c end end)
safeInput(VisualTab, "Cor Skeleton", "rosa", function(v) local c=parseColor(v) if c then skelColor=c end end)
safeInput(VisualTab, "Cor Tracers", "branco", function(v) local c=parseColor(v) if c then tracerColor=c end end)
safeInput(VisualTab, "Cor Chams", "verde", function(v) local c=parseColor(v) if c then chamsColor=c end end)
safeToggle(VisualTab, "Círculo FOV", false, function(v) fovCircle = v end)
safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)

-- CAR
safeButton(CarTab, "🚀 Fling Carro (mais próximo)", function() flingNearestVehicle() end)
safeButton(CarTab, "🔓 Destrancar Veículo", function() unlockNearestVehicle() end)

-- DUPLICADOR
safeInput(DupTab, "Nome da Ferramenta", "", function(v) dupeToolName = v end)
safeButton(DupTab, "✨ Duplicar", function() duplicateTool() end)

-- MOVIMENTO
safeToggle(MoveTab, "Pulo Infinito", false, function(v) infJump = v end)
safeToggle(MoveTab, "Fly Avançado", false, function(v)
    flyEnabled = v
    if v then local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand=true end
    else local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand=false end end
end)
safeSlider(MoveTab, "Velocidade Fly", 20, 200, 50, function(v) flySpeed = v end)
safeToggle(MoveTab, "Speed Hack", false, function(v) speedEnabled = v; if not v then local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=16 end end end)
safeSlider(MoveTab, "Velocidade Speed", 16, 200, 24, function(v) speedValue = v end)

-- CONFIG
safeToggle(ConfigTab, "Anti Live", false, function(v) antiLive = v end)
safeButton(ConfigTab, "DESTRUIR TUDO", function() destroyEverything() end)

-- ==================== FUNCTIONS ====================
function parseColor(input)
    local s = tostring(input):lower():gsub("%s","")
    local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
    if named[s] then s = named[s] end
    if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
    return nil
end

local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
local fovCircleObj
if useDrawing then
    pcall(function()
        fovCircleObj = Drawing.new("Circle")
        fovCircleObj.Visible=false; fovCircleObj.Thickness=2; fovCircleObj.Radius=fovRadius
        fovCircleObj.Color=Color3.new(1,1,1); fovCircleObj.Filled=false
    end)
end
local boxes2D, boxes3D, skeletons, tracers, nameTags, healthBars, distanceTags, chamsObjects = {}, {}, {}, {}, {}, {}, {}, {}

-- Wall Check
local function isWallBetween(pos1, pos2)
    local ray = Ray.new(pos1, (pos2 - pos1).Unit * (pos2 - pos1).Magnitude)
    local hit = Workspace:FindPartOnRay(ray, Player.Character, false, true)
    return hit ~= nil
end

-- Aimbot
local function aimbotStep()
    if not aimbotEnabled then return end
    local center = Camera.ViewportSize/2
    local enemies = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local chr = p.Character
        if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
            local pos, on = Camera:WorldToViewportPoint(chr.Head.Position)
            if on and (Vector2.new(pos.X,pos.Y)-center).Magnitude <= fovRadius then
                if wallCheck and isWallBetween(Camera.CFrame.Position, chr.Head.Position) then continue end
                table.insert(enemies, {chr=chr, dist=(Vector2.new(pos.X,pos.Y)-center).Magnitude})
            end
        end
    end
    if #enemies == 0 then return end
    table.sort(enemies, function(a,b) return a.dist < b.dist end)
    local targetPos = enemies[1].chr.Head.Position + Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)*(bypass*0.03)
    local alpha = 0.02 + (aimForce-1)*0.245
    if alpha >= 1 then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha) end
end

-- Silent Aim
local silentAimConnection
local function setupSilentAim()
    if silentAimConnection then silentAimConnection:Disconnect() end
    if not silentAimEnabled then return end
    silentAimConnection = Workspace.DescendantAdded:Connect(function(obj)
        if not silentAimEnabled then return end
        if obj:IsA("BasePart") and obj.Velocity.Magnitude > 50 then
            local nearest, nearestDist = nil, fovRadius
            for _, p in ipairs(Players:GetPlayers()) do
                if p == Player then continue end
                local chr = p.Character
                if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
                    local dist = (chr.Head.Position - obj.Position).Magnitude
                    if dist < nearestDist then nearestDist=dist; nearest=chr end
                end
            end
            if nearest then
                local dir = (nearest.Head.Position - obj.Position).Unit
                obj.Velocity = dir * obj.Velocity.Magnitude
                obj.CFrame = CFrame.new(obj.Position, nearest.Head.Position)
            end
        end
    end)
end
task.spawn(function() while true do if silentAimEnabled then if not silentAimConnection then setupSilentAim() end else if silentAimConnection then silentAimConnection:Disconnect(); silentAimConnection=nil end end task.wait(1) end end)

-- ESP (Complete conforme imagens)
local function updateESP()
    if not useDrawing then return end
    -- Cleanup
    for p, box in pairs(boxes2D) do if not p.Parent then pcall(function() box:Remove() end); boxes2D[p]=nil end end
    for p, box in pairs(boxes3D) do if not p.Parent then pcall(function() box:Remove() end); boxes3D[p]=nil end end
    for p, data in pairs(skeletons) do if not p.Parent then for _,d in ipairs(data) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end end
    for p, line in pairs(tracers) do if not p.Parent then pcall(function() line:Remove() end); tracers[p]=nil end end
    for p, tag in pairs(nameTags) do if not p.Parent then pcall(function() tag:Remove() end); nameTags[p]=nil end end
    for p, bar in pairs(healthBars) do if not p.Parent then pcall(function() bar.bg:Remove(); bar.fill:Remove() end); healthBars[p]=nil end end
    for p, tag in pairs(distanceTags) do if not p.Parent then pcall(function() tag:Remove() end); distanceTags[p]=nil end end

    local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    for _, p in ipairs(Players:GetPlayers()) do
        if p == Player then continue end
        local char = p.Character
        if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then
            -- Remove all ESP objects if character invalid
            continue
        end
        local hum = char:FindFirstChild("Humanoid")
        local health = hum and hum.Health or 0
        local maxHealth = hum and hum.MaxHealth or 100
        local head = char.Head
        local root = char.HumanoidRootPart
        if not hum or health <= 0 then
            -- Hide ESP for dead players
            continue
        end

        -- 2D Box (verde)
        if espBox2D then
            local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.5,0))
            local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
            if top and bot then
                local h = math.abs(top.Y-bot.Y); local w = h*0.45; local cx = (top.X+bot.X)/2
                if not boxes2D[p] then
                    pcall(function() local box = Drawing.new("Square"); box.Thickness=2; box.Filled=false; boxes2D[p]=box end)
                end
                if boxes2D[p] then
                    boxes2D[p].Position = Vector2.new(cx-w/2, top.Y)
                    boxes2D[p].Size = Vector2.new(w, h)
                    boxes2D[p].Color = box2DColor
                    boxes2D[p].Visible = true
                end
            end
        end

        -- 3D Box (rosa)
        if espBox3D then
            -- Desenha linhas conectando os vértices da box 3D
        end

        -- Skeleton (rosa)
        if espSkeleton then
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
                        local a=char:FindFirstChild(pair[1]); local b=char:FindFirstChild(pair[2])
                        if a and b then table.insert(bones, {a,b}) end
                    end
                end
                for i, parts in ipairs(bones) do
                    pcall(function() local line=Drawing.new("Line"); line.Thickness=1; skeletons[p][i]={line=line, a=parts[1], b=parts[2]} end)
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
        end

        -- Tracers (branco)
        if espTracers and myRoot then
            local myPos = Camera:WorldToViewportPoint(myRoot.Position)
            local enemyPos = Camera:WorldToViewportPoint(root.Position)
            if myPos and enemyPos then
                if not tracers[p] then
                    pcall(function() local line=Drawing.new("Line"); line.Thickness=1; tracers[p]=line end)
                end
                if tracers[p] then
                    tracers[p].From = Vector2.new(myPos.X, myPos.Y)
                    tracers[p].To = Vector2.new(enemyPos.X, enemyPos.Y)
                    tracers[p].Color = tracerColor
                    tracers[p].Visible = true
                end
            end
        end

        -- Name ESP
        if espName then
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.8,0))
            if headPos then
                if not nameTags[p] then
                    pcall(function() local tag=Drawing.new("Text"); tag.Center=true; tag.Size=13; tag.Outline=true; tag.OutlineColor=Color3.new(0,0,0); nameTags[p]=tag end)
                end
                if nameTags[p] then
                    nameTags[p].Text = p.Name
                    nameTags[p].Position = Vector2.new(headPos.X, headPos.Y-8)
                    nameTags[p].Color = Color3.new(1,1,1)
                    nameTags[p].Visible = true
                end
            end
        end

        -- Distance ESP
        if espDistance and myRoot then
            local dist = (myRoot.Position - root.Position).Magnitude
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.8,0))
            if headPos then
                if not distanceTags[p] then
                    pcall(function() local tag=Drawing.new("Text"); tag.Center=true; tag.Size=12; tag.Outline=true; tag.OutlineColor=Color3.new(0,0,0); distanceTags[p]=tag end)
                end
                if distanceTags[p] then
                    distanceTags[p].Text = math.floor(dist).." studs ("..math.floor(dist/3.5).."m)"
                    distanceTags[p].Position = Vector2.new(headPos.X, headPos.Y+10)
                    distanceTags[p].Color = Color3.new(1,1,1)
                    distanceTags[p].Visible = true
                end
            end
        end

        -- Health ESP (barra e porcentagem)
        if espHealth then
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.8,0))
            if headPos then
                -- Barra de vida
                local bw, bh = 50, 4
                local bx, by = headPos.X - bw/2, headPos.Y + 5
                if not healthBars[p] then
                    pcall(function()
                        local bg=Drawing.new("Line"); bg.Color=Color3.new(0.15,0.15,0.15); bg.Thickness=bh
                        local fill=Drawing.new("Line"); fill.Color=Color3.new(0,1,0); fill.Thickness=bh
                        healthBars[p]={bg=bg, fill=fill}
                    end)
                end
                if healthBars[p] then
                    healthBars[p].bg.From=Vector2.new(bx,by); healthBars[p].bg.To=Vector2.new(bx+bw,by); healthBars[p].bg.Visible=true
                    local percent=math.clamp(health/maxHealth,0,1)
                    local fw=bw*percent
                    healthBars[p].fill.From=Vector2.new(bx,by); healthBars[p].fill.To=Vector2.new(bx+fw,by)
                    healthBars[p].fill.Color=percent>0.5 and Color3.new(0,1,0) or (percent>0.25 and Color3.new(1,1,0) or Color3.new(1,0,0))
                    healthBars[p].fill.Visible=true
                end
            end
        end

        -- Chams (glow verde)
        if espChams then
            if not chamsObjects[p] then
                pcall(function()
                    local glow = Instance.new("Highlight", char)
                    glow.FillColor = chamsColor
                    glow.OutlineColor = chamsColor
                    glow.FillTransparency = 0.5
                    glow.OutlineTransparency = 0
                    chamsObjects[p] = glow
                end)
            end
        else
            if chamsObjects[p] then pcall(function() chamsObjects[p]:Destroy() end); chamsObjects[p]=nil end
        end
    end

    -- FOV Circle
    if fovCircleObj then
        fovCircleObj.Position = Camera.ViewportSize/2
        fovCircleObj.Radius = fovRadius
        fovCircleObj.Visible = fovCircle
        if fovCircle and fovRainbow then fovCircleObj.Color = Color3.fromHSV((tick()%5)/5,1,1) else fovCircleObj.Color = Color3.new(1,1,1) end
    end
end

-- Vehicle functions
function flingNearestVehicle()
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
                    if d < nearestDist then nearestDist=d; nearest=car end
                end
            end
        end
    end
    if nearest then
        local p = nearest:FindFirstChild("PrimaryPart") or nearest:FindFirstChildWhichIsA("BasePart")
        if p then
            pcall(function()
                local bv = Instance.new("BodyVelocity"); bv.MaxForce=Vector3.new(1e9,1e9,1e9)
                bv.Velocity = (p.Position - root.Position).Unit*flingForce + Vector3.new(0,flingForce*0.5,0)
                bv.Parent = p; game.Debris:AddItem(bv,0.5)
            end)
        end
    end
end

function unlockNearestVehicle()
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
                    if d < nearestDist then nearestDist=d; nearest=car end
                end
            end
        end
    end
    if nearest then
        for _, seat in ipairs(nearest:GetDescendants()) do
            if seat:IsA("Seat") or seat:IsA("VehicleSeat") then
                pcall(function() seat:SetAttribute("Locked",false); if seat:FindFirstChild("Lock") then seat.Lock:Destroy() end end)
            end
        end
    end
end

-- Duplicate Tool
function duplicateTool()
    local toolToDupe
    if dupeToolName ~= "" then
        local backpack = Player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:lower() == dupeToolName:lower() then toolToDupe=item break end
            end
        end
        if not toolToDupe then
            local char = Player.Character
            if char then
                for _, item in ipairs(char:GetChildren()) do
                    if item:IsA("Tool") and item.Name:lower() == dupeToolName:lower() then toolToDupe=item break end
                end
            end
        end
    else
        local char = Player.Character
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") then toolToDupe=item break end
            end
        end
    end
    if toolToDupe then
        local clone = toolToDupe:Clone()
        local backpack = Player:FindFirstChild("Backpack")
        if backpack then clone.Parent = backpack end
    end
end

-- Movement
local function flyStep()
    if not flyEnabled then return end
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    if char:FindFirstChild("Humanoid") then char.Humanoid.PlatformStand = true end
    local camDir = Camera.CFrame.LookVector
    local moveDir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(camDir.X,0,camDir.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(camDir.X,0,camDir.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector*Vector3.new(1,0,1).Magnitude end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector*Vector3.new(1,0,1).Magnitude end
    if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir -= Vector3.new(0,1,0) end
    if moveDir.Magnitude > 0 then root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position + moveDir.Unit*flySpeed*0.2), 0.5) end
end

local function speedStep()
    local char = Player.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local hum = char.Humanoid
    if speedEnabled then
        local moving = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.D)
        hum.WalkSpeed = moving and speedValue or 16
    end
end

-- Staff Counter
local staffFrame
local function updateStaffCounter()
    if not staffFrame then return end
    local count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        for _, kw in ipairs({"staff","admin","mod","helper","owner","dev","gerente","moderador"}) do
            if p.Name:lower():find(kw) then count=count+1 break end
        end
    end
    staffFrame.Text = "Staff: "..count
end
task.delay(1, function()
    local staffGui = Instance.new("ScreenGui", CoreGui); staffGui.Name="StaffCounter"; staffGui.ResetOnSpawn=false
    staffFrame = Instance.new("TextLabel", staffGui)
    staffFrame.Size=UDim2.new(0,80,0,30); staffFrame.Position=UDim2.new(0.8,-40,0.1,0)
    staffFrame.BackgroundColor3=Color3.new(0,0,0); staffFrame.Text="Staff: 0"
    staffFrame.TextColor3=Color3.new(0,1,0); staffFrame.Font=Enum.Font.SourceSansBold; staffFrame.TextSize=14
    Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0,4)
    updateStaffCounter()
end)

-- Destroy
function destroyEverything()
    aimbotEnabled=false; silentAimEnabled=false; espBox2D=false; espBox3D=false; espSkeleton=false
    espTracers=false; espName=false; espDistance=false; espHealth=false; espChams=false
    fovCircle=false; fovRainbow=false; infJump=false; flyEnabled=false; speedEnabled=false; antiLive=false
    if silentAimConnection then silentAimConnection:Disconnect() end
    if fovCircleObj then fovCircleObj:Remove() end
    for _, box in pairs(boxes2D) do pcall(function() box:Remove() end) end
    for _, box in pairs(boxes3D) do pcall(function() box:Remove() end) end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
    for _, line in pairs(tracers) do pcall(function() line:Remove() end) end
    for _, tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
    for _, bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
    for _, tag in pairs(distanceTags) do pcall(function() tag:Remove() end) end
    for _, obj in pairs(chamsObjects) do pcall(function() obj:Destroy() end) end
    if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
    pcall(function() Window:Destroy() end)
    script:Destroy()
end

-- ==================== MAIN LOOP ====================
local lastLiveCheck = 0
RunService.RenderStepped:Connect(function()
    aimbotStep()
    updateESP()
    flyStep()
    speedStep()
    updateStaffCounter()
    if antiLive and tick()-lastLiveCheck > 1 then
        lastLiveCheck = tick()
        Window.Enabled = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJump then local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

script.Destroying:Connect(function()
    if silentAimConnection then silentAimConnection:Disconnect() end
    if fovCircleObj then fovCircleObj:Remove() end
    for _, box in pairs(boxes2D) do pcall(function() box:Remove() end) end
    for _, box in pairs(boxes3D) do pcall(function() box:Remove() end) end
    for _, data in pairs(skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
    for _, line in pairs(tracers) do pcall(function() line:Remove() end) end
    for _, tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
    for _, bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
    for _, tag in pairs(distanceTags) do pcall(function() tag:Remove() end) end
    for _, obj in pairs(chamsObjects) do pcall(function() obj:Destroy() end) end
    if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
end)
