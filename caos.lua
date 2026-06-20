-- S4zx - Script Completo com Sistema de Key
-- Cole este script inteiro no seu executor

-- ==================== CONFIGURAÇÃO DA API ====================
local API_KEY_URL = "https://script.google.com/macros/s/SEU_ID_AQUI/exec?key="
local DONO_KEY = "S4zx-DonoSupreme2025"

-- ==================== FUNÇÃO DE VALIDAÇÃO ====================
local function validarKey(key)
    if key == DONO_KEY then
        return true, "Key do Dono (Permanente)"
    end
    
    local ok, resposta = pcall(function()
        return game:HttpGet(API_KEY_URL .. key)
    end)
    
    if ok and resposta and resposta ~= "" then
        local dados = game:GetService("HttpService"):JSONDecode(resposta)
        if dados.valido then
            return true, dados.msg
        else
            return false, dados.msg
        end
    end
    
    return false, "Erro ao conectar com o servidor de keys"
end

-- ==================== INTERFACE DE LOGIN ====================
local function loginScreen()
    local gui = Instance.new("ScreenGui")
    gui.Name = "S4zxLogin"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 300, 0, 220)
    bg.Position = UDim2.new(0.5, -150, 0.5, -110)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    bg.BorderSizePixel = 0
    bg.Parent = gui
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "S4zx - Login"
    title.TextColor3 = Color3.fromRGB(255, 0, 85)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = bg

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -40, 0, 40)
    input.Position = UDim2.new(0, 20, 0, 60)
    input.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = "Cole sua key aqui..."
    input.Font = Enum.Font.SourceSans
    input.TextSize = 16
    input.ClearTextOnFocus = false
    input.Parent = bg
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0, 110)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.Font = Enum.Font.SourceSans
    status.TextSize = 13
    status.Parent = bg

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 140)
    btn.BackgroundColor3 = Color3.fromRGB(255, 0, 85)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = "ENTRAR"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BorderSizePixel = 0
    btn.Parent = bg
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = bg
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
    closeBtn.Activated:Connect(function() gui:Destroy() end)

    -- Função de login
    local function tentarLogin()
        local key = input.Text:gsub("%s+", "") -- remove espaços
        if key == "" then
            status.Text = "Digite uma key!"
            status.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end
        
        status.Text = "Validando..."
        status.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = "AGUARDE..."
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        -- Delay para dar feedback visual
        task.wait(0.5)
        
        local valida, msg = validarKey(key)
        
        if valida then
            status.Text = "✅ " .. msg
            status.TextColor3 = Color3.fromRGB(0, 255, 100)
            task.wait(1)
            gui:Destroy()
            -- Carrega o S4zx completo
            carregarS4zx()
        else
            status.Text = "❌ " .. msg
            status.TextColor3 = Color3.fromRGB(255, 50, 50)
            btn.Text = "ENTRAR"
            btn.BackgroundColor3 = Color3.fromRGB(255, 0, 85)
        end
    end

    btn.Activated:Connect(tentarLogin)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then tentarLogin() end
    end)
end

-- ==================== CARREGAR S4ZX COMPLETO ====================
function carregarS4zx()
    -- Aqui você cola TODO o código do S4zx (Aimbot, ESP, Fly, Duplicador, etc.)
    -- Por ser muito extenso, vou colocar a estrutura básica com Rayfield
    
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    
    local Window = Rayfield:CreateWindow({
        Name = "S4zx",
        LoadingTitle = "S4zx",
        LoadingSubtitle = "by Souza",
        ConfigurationSaving = { Enabled = false },
        KeySystem = false
    })

    -- ==================== SERVIÇOS ====================
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local CoreGui = game:GetService("CoreGui")
    local Player = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    -- ==================== VARIÁVEIS ====================
    local aimbot = false; local aimForce = 1; local bypass = 1; local fovRadius = 150
    local fovCircle = false; local fovRainbow = false
    local espBox = false; local espSkel = false; local espName = false
    local espDistance = false; local espHealth = false; local espTracers = false
    local espChams = false; local espItems = false; local espLines = false
    local showMoney = false
    local infJump = false; local flyEnabled = false; local flySpeed = 50
    local speedEnabled = false; local speedValue = 24
    local antiLive = false
    local boxColor = Color3.fromRGB(0,255,0); local skelColor = Color3.fromRGB(255,105,180)
    local tracerColor = Color3.fromRGB(255,255,255); local chamsColor = Color3.fromRGB(0,255,0)
    local silentAimEnabled = false
    local wallCheck = false
    local dupeToolName = ""
    local flingForce = 300

    -- ==================== ABAS ====================
    local function safeTab(n, i) local t; pcall(function() t = Window:CreateTab(n, i) end); return t end
    local HomeTab = safeTab("HOME", 4483362458)
    local AimbotTab = safeTab("AIMBOT", 4483362458)
    local ESPTab = safeTab("ESP", 4483362458)
    local VisualTab = safeTab("VISUAL", 4483362458)
    local CarTab = safeTab("CAR", 4483362458)
    local DupTab = safeTab("DUPLICADOR", 4483362458)
    local MoveTab = safeTab("MOVIMENTO", 4483362458)
    local ConfigTab = safeTab("CONFIG", 4483362458)

    -- ==================== CONTROLES ====================
    local function safeToggle(tab, name, d, cb) if tab then pcall(function() tab:CreateToggle({Name=name, CurrentValue=d, Callback=cb}) end) end end
    local function safeSlider(tab, name, min, max, d, cb) if tab then pcall(function() tab:CreateSlider({Name=name, Min=min, Max=max, Increment=1, CurrentValue=d, Callback=cb}) end) end end
    local function safeInput(tab, name, ph, cb) if tab then pcall(function() tab:CreateInput({Name=name, PlaceholderText=ph, RemoveTextAfterFocusLost=false, Callback=cb}) end) end end
    local function safeButton(tab, name, cb) if tab then pcall(function() tab:CreateButton({Name=name, Callback=cb}) end) end end

    -- AIMBOT
    safeToggle(AimbotTab, "AIMBOT", false, function(v) aimbot = v end)
    safeSlider(AimbotTab, "Força (1-5)", 1, 5, 1, function(v) aimForce = v end)
    safeSlider(AimbotTab, "Bypass", 1, 10, 1, function(v) bypass = v end)
    safeSlider(AimbotTab, "FOV (Raio)", 50, 500, 150, function(v) fovRadius = v end)
    safeToggle(AimbotTab, "WALLCK", false, function(v) wallCheck = v end)
    safeToggle(AimbotTab, "SILENT AIM", false, function(v) silentAimEnabled = v end)

    -- ESP
    safeToggle(ESPTab, "2D Box", false, function(v) espBox = v end)
    safeToggle(ESPTab, "Skeleton", false, function(v) espSkel = v end)
    safeToggle(ESPTab, "Name", false, function(v) espName = v end)
    safeToggle(ESPTab, "Distance", false, function(v) espDistance = v end)
    safeToggle(ESPTab, "Health", false, function(v) espHealth = v end)
    safeToggle(ESPTab, "Tracers", false, function(v) espTracers = v end)
    safeToggle(ESPTab, "Chams (Glow)", false, function(v) espChams = v end)
    safeToggle(ESPTab, "Itens", false, function(v) espItems = v end)
    safeToggle(ESPTab, "Linhas Arco-íris", false, function(v) espLines = v end)
    safeToggle(ESPTab, "Dinheiro", false, function(v) showMoney = v end)

    -- VISUAL
    safeInput(VisualTab, "Cor Box", "verde", function(v) local c=parseColor(v) if c then boxColor=c end end)
    safeInput(VisualTab, "Cor Skeleton", "rosa", function(v) local c=parseColor(v) if c then skelColor=c end end)
    safeInput(VisualTab, "Cor Tracers", "branco", function(v) local c=parseColor(v) if c then tracerColor=c end end)
    safeInput(VisualTab, "Cor Chams", "verde", function(v) local c=parseColor(v) if c then chamsColor=c end end)
    safeToggle(VisualTab, "FOV Círculo", false, function(v) fovCircle = v end)
    safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)

    -- CAR
    safeButton(CarTab, "🚀 Fling Carro", function() flingNearestVehicle() end)
    safeButton(CarTab, "🔓 Destrancar", function() unlockNearestVehicle() end)

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
    safeButton(ConfigTab, "DESTRUIR TUDO", function()
        aimbot=false; silentAimEnabled=false; espBox=false; espSkel=false; espName=false
        espDistance=false; espHealth=false; espTracers=false; espChams=false
        espItems=false; espLines=false; fovCircle=false; fovRainbow=false
        infJump=false; flyEnabled=false; speedEnabled=false; antiLive=false
        local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand=false; c.Humanoid.WalkSpeed=16 end
        if fovCircleObj then fovCircleObj:Remove() end
        for _,box in pairs(boxes2D) do pcall(function() box:Remove() end) end
        for _,data in pairs(skeletons) do for _,d in ipairs(data) do pcall(function() d.line:Remove() end) end end
        for _,tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
        for _,bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
        for _,line in pairs(tracers) do pcall(function() line:Remove() end) end
        for _,tag in pairs(distanceTags) do pcall(function() tag:Remove() end) end
        for _,obj in pairs(chamsObjects) do pcall(function() obj:Destroy() end) end
        for _,obj in pairs(itemESP) do pcall(function() obj:Remove() end) end
        pcall(function() Window:Destroy() end)
        script:Destroy()
    end)

    -- ==================== FUNÇÕES AUXILIARES ====================
    function parseColor(input)
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end

    -- ==================== FUNÇÕES PRINCIPAIS (resumidas para caber) ====================
    local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
    local fovCircleObj
    if useDrawing then
        pcall(function()
            fovCircleObj = Drawing.new("Circle")
            fovCircleObj.Visible=false; fovCircleObj.Thickness=2; fovCircleObj.Radius=fovRadius
            fovCircleObj.Color=Color3.new(1,1,1); fovCircleObj.Filled=false
        end)
    end
    local boxes2D, skeletons, tracers, nameTags, healthBars, distanceTags, chamsObjects, rainbowLines = {}, {}, {}, {}, {}, {}, {}, {}
    local itemESP = {}

    -- Aimbot
    local function aimbotStep()
        if not aimbot then return end
        local center = Camera.ViewportSize/2
        local enemies = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p == Player then continue end
            local chr = p.Character
            if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
                local pos, on = Camera:WorldToViewportPoint(chr.Head.Position)
                if on and (Vector2.new(pos.X,pos.Y)-center).Magnitude <= fovRadius then
                    if wallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (chr.Head.Position - Camera.CFrame.Position).Unit * 500)
                        if Workspace:FindPartOnRay(ray, Player.Character, false, true) then continue end
                    end
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

    -- ESP atualizada (completa como antes)
    local function updateESP()
        if not useDrawing then return end
        -- Cleanup
        for p, box in pairs(boxes2D) do if not p.Parent then pcall(function() box:Remove() end); boxes2D[p]=nil end end
        for p, data in pairs(skeletons) do if not p.Parent then for _,d in ipairs(data) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end end
        for p, tag in pairs(nameTags) do if not p.Parent then pcall(function() tag:Remove() end); nameTags[p]=nil end end
        for p, bar in pairs(healthBars) do if not p.Parent then pcall(function() bar.bg:Remove(); bar.fill:Remove() end); healthBars[p]=nil end end
        for p, line in pairs(tracers) do if not p.Parent then pcall(function() line:Remove() end); tracers[p]=nil end end
        for p, tag in pairs(distanceTags) do if not p.Parent then pcall(function() tag:Remove() end); distanceTags[p]=nil end end
        for p, line in pairs(rainbowLines) do if not p.Parent then pcall(function() line:Remove() end); rainbowLines[p]=nil end end
        for part, obj in pairs(itemESP) do if not part.Parent then pcall(function() obj:Remove() end); itemESP[part]=nil end end

        local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")

        -- Itens
        if espItems then
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
                    end
                end
            end
        end

        -- Players
        for _, p in ipairs(Players:GetPlayers()) do
            if p == Player then continue end
            local char = p.Character
            if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then continue end
            local hum = char:FindFirstChild("Humanoid")
            local health = hum and hum.Health or 0
            local maxHealth = hum and hum.MaxHealth or 100
            local head = char.Head
            local root = char.HumanoidRootPart
            local dist = myRoot and (myRoot.Position - root.Position).Magnitude or 0

            if not hum or health <= 0 then
                if boxes2D[p] then boxes2D[p].Visible=false end
                if skeletons[p] then for _,d in ipairs(skeletons[p]) do d.line.Visible=false end end
                if nameTags[p] then nameTags[p].Visible=false end
                if healthBars[p] then healthBars[p].bg.Visible=false; healthBars[p].fill.Visible=false end
                if tracers[p] then tracers[p].Visible=false end
                if distanceTags[p] then distanceTags[p].Visible=false end
                if rainbowLines[p] then rainbowLines[p].Visible=false end
                continue
            end

            -- 2D Box
            if espBox then
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
                        boxes2D[p].Color = boxColor
                        boxes2D[p].Visible = true
                    end
                end
            else
                if boxes2D[p] then pcall(function() boxes2D[p]:Remove() end); boxes2D[p]=nil end
            end

            -- Skeleton
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
            else
                if skeletons[p] then for _,d in ipairs(skeletons[p]) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end
            end

            -- Tracers
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
            else
                if tracers[p] then pcall(function() tracers[p]:Remove() end); tracers[p]=nil end
            end

            -- Name
            if espName then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.8,0))
                if headPos then
                    if not nameTags[p] then
                        pcall(function() local tag=Drawing.new("Text"); tag.Center=true; tag.Size=13; tag.Outline=true; tag.OutlineColor=Color3.new(0,0,0); nameTags[p]=tag end)
                    end
                    if nameTags[p] then
                        local text = p.Name
                        if showMoney then
                            local ls = p:FindFirstChild("leaderstats")
                            if ls then for _, stat in ipairs(ls:GetChildren()) do
                                if (stat:IsA("IntValue") or stat:IsA("NumberValue")) and (stat.Name:lower():find("cash") or stat.Name:lower():find("money") or stat.Name:lower():find("gold")) then
                                    text = text .. " $"..stat.Value break
                                end
                            end end
                        end
                        nameTags[p].Text = text
                        nameTags[p].Position = Vector2.new(headPos.X, headPos.Y-8)
                        nameTags[p].Color = Color3.new(1,1,1)
                        nameTags[p].Visible = true
                    end
                end
            else
                if nameTags[p] then pcall(function() nameTags[p]:Remove() end); nameTags[p]=nil end
            end

            -- Health
            if espHealth then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1.8,0))
                if headPos then
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
            else
                if healthBars[p] then pcall(function() healthBars[p].bg:Remove(); healthBars[p].fill:Remove() end); healthBars[p]=nil end
            end

            -- Distance
            if espDistance and dist > 0 then
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
            else
                if distanceTags[p] then pcall(function() distanceTags[p]:Remove() end); distanceTags[p]=nil end
            end

            -- Chams
            if espChams then
                if not chamsObjects[p] then
                    pcall(function()
                        local glow = Instance.new("Highlight", char)
                        glow.FillColor = chamsColor; glow.OutlineColor = chamsColor
                        glow.FillTransparency = 0.5; glow.OutlineTransparency = 0
                        chamsObjects[p] = glow
                    end)
                end
            else
                if chamsObjects[p] then pcall(function() chamsObjects[p]:Destroy() end); chamsObjects[p]=nil end
            end

            -- Rainbow lines
            if espLines and myRoot then
                local myPos = Camera:WorldToViewportPoint(myRoot.Position)
                local enemyPos = Camera:WorldToViewportPoint(head.Position)
                if myPos and enemyPos then
                    if not rainbowLines[p] then
                        pcall(function() local line=Drawing.new("Line"); line.Thickness=2; rainbowLines[p]=line end)
                    end
                    if rainbowLines[p] then
                        rainbowLines[p].From = Vector2.new(myPos.X, myPos.Y)
                        rainbowLines[p].To = Vector2.new(enemyPos.X, enemyPos.Y)
                        rainbowLines[p].Color = Color3.fromHSV((tick()*50%255)/255,1,1)
                        rainbowLines[p].Visible = true
                    end
                end
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

    -- Funções de veículo
    function flingNearestVehicle()
        local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
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
        local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
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

    function duplicateTool()
        local toolToDupe
        if dupeToolName ~= "" then
            local backpack = Player:FindFirstChild("Backpack")
            if backpack then for _, item in ipairs(backpack:GetChildren()) do if item:IsA("Tool") and item.Name:lower() == dupeToolName:lower() then toolToDupe=item break end end end
            if not toolToDupe and Player.Character then for _, item in ipairs(Player.Character:GetChildren()) do if item:IsA("Tool") and item.Name:lower() == dupeToolName:lower() then toolToDupe=item break end end end
        else
            if Player.Character then for _, item in ipairs(Player.Character:GetChildren()) do if item:IsA("Tool") then toolToDupe=item break end end end
        end
        if toolToDupe then
            local clone = toolToDupe:Clone()
            local backpack = Player:FindFirstChild("Backpack")
            if backpack then clone.Parent = backpack end
        end
    end

    -- Fly
    local function flyStep()
        if not flyEnabled then return end
        local char = Player.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
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
        local char = Player.Character; if not char or not char:FindFirstChild("Humanoid") then return end
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

    -- Pulo Infinito
    UserInputService.JumpRequest:Connect(function()
        if infJump then local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end
    end)

    -- Loop principal
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

    -- Limpeza
    script.Destroying:Connect(function()
        if silentAimConnection then silentAimConnection:Disconnect() end
        if fovCircleObj then fovCircleObj:Remove() end
        for _, box in pairs(boxes2D) do pcall(function() box:Remove() end) end
        for _, data in pairs(skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
        for _, tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
        for _, bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
        for _, line in pairs(tracers) do pcall(function() line:Remove() end) end
        for _, tag in pairs(distanceTags) do pcall(function() tag:Remove() end) end
        for _, obj in pairs(chamsObjects) do pcall(function() obj:Destroy() end) end
        for _, line in pairs(rainbowLines) do pcall(function() line:Remove() end) end
        for _, obj in pairs(itemESP) do pcall(function() obj:Remove() end) end
        if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
    end)

    print("S4zx carregado com sucesso!")
end

-- Iniciar tela de login
loginScreen()
