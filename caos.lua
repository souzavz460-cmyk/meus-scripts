-- Snow S4zx Mod – Versão Definitiva (TUDO FUNCIONANDO)
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2026"

-- ==========================================
-- TELA DE LOGIN
-- ==========================================
local function mostrarLogin()
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    gui.Name = "SnowLogin"
    
    local bg = Instance.new("Frame", gui)
    bg.Size = UDim2.new(0, 300, 0, 220)
    bg.Position = UDim2.new(0.5, -150, 0.5, -110)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 12)
    
    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.Text = "Snow S4zx"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.BackgroundTransparency = 1
    
    local input = Instance.new("TextBox", bg)
    input.Size = UDim2.new(1, -40, 0, 40)
    input.Position = UDim2.new(0, 20, 0, 60)
    input.PlaceholderText = "Cole sua key aqui..."
    input.TextColor3 = Color3.new(1,1,1)
    input.BackgroundColor3 = Color3.fromRGB(30,30,40)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 16
    input.ClearTextOnFocus = false
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
    
    local status = Instance.new("TextLabel", bg)
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0, 110)
    status.Text = ""
    status.TextColor3 = Color3.new(1,1,1)
    status.Font = Enum.Font.SourceSans
    status.TextSize = 13
    status.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(1, -40, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 140)
    btn.Text = "ENTRAR"
    btn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local closeBtn = Instance.new("TextButton", bg)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)
    closeBtn.Activated:Connect(function() gui:Destroy() end)
    
    local function tentarLogin()
        local key = input.Text:gsub("%s+", "")
        if key == "" then
            status.Text = "Digite uma key"
            status.TextColor3 = Color3.fromRGB(255,200,0)
            return
        end
        
        if key == DONO_KEY then
            status.Text = "✅ Key do Dono"
            status.TextColor3 = Color3.fromRGB(0,255,100)
            task.wait(1)
            gui:Destroy()
            carregarInterface()
            return
        end
        
        btn.Text = "AGUARDE..."
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        
        local ok, json = pcall(function() return game:HttpGet(KEYS_URL) end)
        if ok and json and json ~= "" then
            local keys = {}
            pcall(function() keys = game:GetService("HttpService"):JSONDecode(json) end)
            local data = keys[key]
            if data then
                if data.dias == "perm" then
                    status.Text = "✅ Key permanente"
                    status.TextColor3 = Color3.fromRGB(0,255,100)
                    task.wait(1)
                    gui:Destroy()
                    carregarInterface()
                    return
                else
                    local dia, mes, ano = data.criada:match("(%d+)/(%d+)/(%d+)")
                    if dia then
                        local criada = os.time({year=tonumber(ano), month=tonumber(mes), day=tonumber(dia)})
                        local expira = criada + (tonumber(data.dias) * 86400)
                        if os.time() <= expira then
                            status.Text = "✅ Key válida!"
                            status.TextColor3 = Color3.fromRGB(0,255,100)
                            task.wait(1)
                            gui:Destroy()
                            carregarInterface()
                            return
                        else
                            status.Text = "❌ Key expirada"
                            status.TextColor3 = Color3.fromRGB(255,50,50)
                        end
                    end
                end
            else
                status.Text = "❌ Key inválida"
                status.TextColor3 = Color3.fromRGB(255,50,50)
            end
        else
            status.Text = "❌ Erro ao verificar key"
            status.TextColor3 = Color3.fromRGB(255,50,50)
        end
        
        btn.Text = "ENTRAR"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    end
    
    btn.Activated:Connect(tentarLogin)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then tentarLogin() end
    end)
end

-- ==========================================
-- INTERFACE PRINCIPAL E LÓGICA
-- ==========================================
function carregarInterface()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    local Window = Rayfield:CreateWindow({
        Name = "S4zx MODS",
        LoadingTitle = "S4zx MODS",
        LoadingSubtitle = "by Souzavz",
        ShowText = "S4zx MODS",
        Theme = "DarkBlue",
        ConfigurationSaving = { Enabled = true, FolderName = "SnowS4zx", FileName = "Config" },
        KeySystem = false,
        MobileButton = { Enabled = true, Name = "S4zx MODS" }
    })
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local VirtualUser = game:GetService("VirtualUser")
    local Player = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    
    -- VARIÁVEIS GLOBAIS
    local aimbot = false; local aimForce = 1; local bypass = 1; local fovRadius = 150; local wallCheck = false; local silentAimEnabled = false
    local espBox = false; local espSkel = false; local espName = false; local espDistance = false; local espHealth = false; local tracerV7 = false
    local fovCircle = false; local fovRainbow = false
    local boxColor = Color3.fromRGB(0,255,0); local skelColor = Color3.fromRGB(255,105,180); local tracerColor = Color3.fromRGB(255,255,255)
    local infJump = false; local flyEnabled = false; local flySpeed = 50; local speedEnabled = false; local speedValue = 24
    local autoLockpick = false; local autoEssencia = false
    local reach = false; local reachDistance = 15; local infiniteAmmo = false; local noRecoil = false
    local antiAfk = false; local antiLive = false
    local grabbedVehicle = nil; local vehicleAlign = nil; local silentAimConnection = nil
    
    -- ABAS
    local function safeTab(n) return Window:CreateTab(n, 4483362458) end
    local AimbotTab = safeTab("AIMBOT")
    local ESPTab = safeTab("ESP")
    local VisualTab = safeTab("VISUAL")
    local MoveTab = safeTab("MOVIMENTO")
    local SintoniaTab = safeTab("SINTONIA RP")
    local WeaponTab = safeTab("ARMAS")
    local GrabTab = safeTab("PEGAR/TACAR")
    local ExtrasTab = safeTab("EXTRAS")
    
    -- FUNÇÕES DE UI
    local function safeToggle(tab, name, d, cb) pcall(function() tab:CreateToggle({Name=name, CurrentValue=d, Callback=cb}) end) end
    local function safeSlider(tab, name, min, max, d, cb) pcall(function() tab:CreateSlider({Name=name, Range={min, max}, Increment=1, CurrentValue=d, Callback=cb}) end) end
    local function safeInput(tab, name, ph, cb) pcall(function() tab:CreateInput({Name=name, PlaceholderText=ph, Callback=cb}) end) end
    local function safeButton(tab, name, cb) pcall(function() tab:CreateButton({Name=name, Callback=cb}) end) end
    
    -- ==========================================
    -- CONFIGURAÇÕES DOS MENUS
    -- ==========================================
    safeToggle(AimbotTab, "AIMBOT", false, function(v) aimbot = v end)
    safeSlider(AimbotTab, "Força (1-5)", 1, 5, 1, function(v) aimForce = v end)
    safeSlider(AimbotTab, "Bypass Aimbot", 1, 10, 1, function(v) bypass = v end)
    safeSlider(AimbotTab, "FOV (Raio)", 50, 500, 150, function(v) fovRadius = v end)
    safeToggle(AimbotTab, "WALLCK (Parede)", false, function(v) wallCheck = v end)
    safeToggle(AimbotTab, "SILENT AIM", false, function(v) silentAimEnabled = v end)
    
    safeToggle(ESPTab, "2D Box", false, function(v) espBox = v end)
    safeToggle(ESPTab, "Skeleton", false, function(v) espSkel = v end)
    safeToggle(ESPTab, "Name", false, function(v) espName = v end)
    safeToggle(ESPTab, "Distance", false, function(v) espDistance = v end)
    safeToggle(ESPTab, "Health Bar", false, function(v) espHealth = v end)
    safeToggle(ESPTab, "Tracer V7 (do chão)", false, function(v) tracerV7 = v end)
    
    local function parseColor(input)
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end

    safeInput(VisualTab, "Cor Box (Hex/Nome)", "verde", function(v) local c=parseColor(v) if c then boxColor=c end end)
    safeInput(VisualTab, "Cor Skeleton (Hex/Nome)", "rosa", function(v) local c=parseColor(v) if c then skelColor=c end end)
    safeInput(VisualTab, "Cor Tracer V7 (Hex/Nome)", "branco", function(v) local c=parseColor(v) if c then tracerColor=c end end)
    safeToggle(VisualTab, "FOV Círculo", false, function(v) fovCircle = v end)
    safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)
    
    safeToggle(MoveTab, "Pulo Infinito", false, function(v) infJump = v end)
    safeToggle(MoveTab, "Fly Avançado (Andando)", false, function(v) flyEnabled = v end)
    safeSlider(MoveTab, "Velocidade Fly", 20, 200, 50, function(v) flySpeed = v end)
    safeToggle(MoveTab, "Speed Hack", false, function(v) speedEnabled = v end)
    safeSlider(MoveTab, "Velocidade Speed", 16, 200, 24, function(v) speedValue = v end)
    
    safeToggle(SintoniaTab, "Auto Lockpick", false, function(v) autoLockpick = v end)
    safeToggle(SintoniaTab, "Auto Coletar Essência", false, function(v) autoEssencia = v end)
    
    safeToggle(WeaponTab, "Reach (Alcance Hitbox)", false, function(v) reach = v end)
    safeSlider(WeaponTab, "Distância Hitbox", 10, 50, 15, function(v) reachDistance = v end)
    safeToggle(WeaponTab, "Infinite Ammo", false, function(v) infiniteAmmo = v end)
    safeToggle(WeaponTab, "No Recoil", false, function(v) noRecoil = v end)
    
    safeButton(GrabTab, "🖐️ PEGAR VEÍCULO", function()
        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 100)
        local hit = Workspace:FindPartOnRay(ray, Player.Character, false, true)
        if hit then
            local car = hit:FindFirstAncestorOfClass("Model")
            if car and (car:FindFirstChildWhichIsA("VehicleSeat") or car:FindFirstChildWhichIsA("Seat")) then
                grabbedVehicle = car
                local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                if primary then
                    vehicleAlign = Instance.new("AlignPosition", primary)
                    vehicleAlign.MaxForce = 9999999
                    vehicleAlign.Responsiveness = 200
                    vehicleAlign.Attachment0 = Instance.new("Attachment", primary)
                    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local attach = root:FindFirstChild("GrabAttach") or Instance.new("Attachment", root)
                        attach.Name = "GrabAttach"
                        vehicleAlign.Attachment1 = attach
                    end
                end
            end
        end
    end)
    
    safeButton(GrabTab, "💥 TACAR VEÍCULO", function()
        if not grabbedVehicle then return end
        local primary = grabbedVehicle:FindFirstChild("PrimaryPart") or grabbedVehicle:FindFirstChildWhichIsA("BasePart")
        if primary then
            pcall(function() if vehicleAlign then vehicleAlign:Destroy() end end)
            primary.AssemblyLinearVelocity = Camera.CFrame.LookVector * 400 + Vector3.new(0, 50, 0)
        end
        grabbedVehicle = nil
    end)

    safeToggle(ExtrasTab, "Anti AFK", false, function(v) antiAfk = v end)

    -- ==========================================
    -- SISTEMAS INTERNOS (ESP, AIMBOT, LÓGICA)
    -- ==========================================
    
    -- 1. Anti-AFK
    Player.Idled:Connect(function()
        if antiAfk then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)

    -- 2. Setup Silent Aim
    local function setupSilentAim()
        if silentAimConnection then silentAimConnection:Disconnect() end
        if not silentAimEnabled then return end
        silentAimConnection = Workspace.DescendantAdded:Connect(function(obj)
            if not silentAimEnabled then return end
            if obj:IsA("BasePart") and (obj.Velocity.Magnitude > 50 or obj:GetAttribute("Owner") == Player.Name) then
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
                    obj.Velocity = (nearest.Head.Position - obj.Position).Unit * obj.Velocity.Magnitude
                    obj.CFrame = CFrame.new(obj.Position, nearest.Head.Position)
                end
            end
        end)
    end

    -- 3. Engine da ESP Cache
    local espCache = {}
    local function criarDesenhosESP(p)
        if espCache[p] then return end
        espCache[p] = {
            box = Drawing.new("Square"), name = Drawing.new("Text"), distance = Drawing.new("Text"), tracer = Drawing.new("Line"),
            healthBg = Drawing.new("Square"), healthMain = Drawing.new("Square"),
            skelLines = {
                hToT = Drawing.new("Line"), tToL = Drawing.new("Line"), tToRA = Drawing.new("Line"),
                tToLA = Drawing.new("Line"), tToRL = Drawing.new("Line"), tToLL = Drawing.new("Line")
            }
        }
    end

    local function limparESP(p)
        if espCache[p] then
            pcall(function()
                espCache[p].box:Remove(); espCache[p].name:Remove(); espCache[p].distance:Remove(); espCache[p].tracer:Remove()
                espCache[p].healthBg:Remove(); espCache[p].healthMain:Remove()
                for _, line in pairs(espCache[p].skelLines) do line:Remove() end
            end)
            espCache[p] = nil
        end
    end
    Players.PlayerRemoving:Connect(limparESP)

    local fovCircleObj = Drawing.new("Circle")
    fovCircleObj.Thickness = 2; fovCircleObj.Filled = false

    -- ==========================================
    -- MAIN RENDER LOOP (Coração do Script)
    -- ==========================================
    RunService.RenderStepped:Connect(function()
        local center = Camera.ViewportSize / 2
        
        -- FOV Círculo
        fovCircleObj.Position = center
        fovCircleObj.Radius = fovRadius
        fovCircleObj.Visible = fovCircle
        fovCircleObj.Color = fovRainbow and Color3.fromHSV((tick()*0.5)%1, 1, 1) or Color3.new(1,1,1)

        local closestPlayer = nil
        local closestDist = fovRadius

        -- LOOP JOGADORES (ESP & AIMBOT SCAN)
        for _, p in ipairs(Players:GetPlayers()) do
            if p == Player then continue end
            local char = p.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if not root or not head or not hum or hum.Health <= 0 then limparESP(p); continue end
            local rootPos, rootVisible = Camera:WorldToViewportPoint(root.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.6, 0))
            
            -- Lógica Aimbot Scan
            if aimbot then
                local screenDist = (Vector2.new(headPos.X, headPos.Y) - center).Magnitude
                if screenDist <= fovRadius and screenDist < closestDist then
                    if wallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000)
                        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {Player.Character}, false, true)
                        if hit and hit:IsDescendantOf(char) then closestPlayer = head; closestDist = screenDist end
                    else
                        closestPlayer = head; closestDist = screenDist
                    end
                end
            end

            -- Lógica ESP Render
            if not rootVisible then limparESP(p); continue end
            criarDesenhosESP(p)
            local cache = espCache[p]
            local feetPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
            local height = math.abs(headPos.Y - feetPos.Y)
            local width = height * 0.55

            if espBox then
                cache.box.Size = Vector2.new(width, height); cache.box.Position = Vector2.new(rootPos.X - width/2, headPos.Y)
                cache.box.Color = boxColor; cache.box.Visible = true
            else cache.box.Visible = false end

            if espName then
                cache.name.Text = p.Name; cache.name.Size = 14; cache.name.Center = true; cache.name.Outline = true
                cache.name.Position = Vector2.new(rootPos.X, headPos.Y - 16); cache.name.Color = Color3.new(1,1,1); cache.name.Visible = true
            else cache.name.Visible = false end

            if espDistance then
                local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
                cache.distance.Text = tostring(dist) .. " studs"; cache.distance.Size = 12; cache.distance.Center = true
                cache.distance.Outline = true; cache.distance.Position = Vector2.new(rootPos.X, feetPos.Y + 2)
                cache.distance.Color = Color3.fromRGB(200,200,200); cache.distance.Visible = true
            else cache.distance.Visible = false end

            if espHealth then
                local healthFactor = hum.Health / hum.MaxHealth
                cache.healthBg.Size = Vector2.new(4, height); cache.healthBg.Position = Vector2.new(rootPos.X - width/2 - 6, headPos.Y)
                cache.healthBg.Color = Color3.fromRGB(40,0,0); cache.healthBg.Filled = true; cache.healthBg.Visible = true
                cache.healthMain.Size = Vector2.new(4, height * healthFactor); cache.healthMain.Position = Vector2.new(rootPos.X - width/2 - 6, headPos.Y + (height * (1 - healthFactor)))
                cache.healthMain.Color = Color3.fromRGB(0, 255, 100):Lerp(Color3.fromRGB(255, 0, 0), 1 - healthFactor)
                cache.healthMain.Filled = true; cache.healthMain.Visible = true
            else cache.healthBg.Visible = false; cache.healthMain.Visible = false end

            if tracerV7 then
                cache.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y - 10)
                cache.tracer.To = Vector2.new(rootPos.X, rootPos.Y); cache.tracer.Color = tracerColor; cache.tracer.Visible = true
            else cache.tracer.Visible = false end

            if espSkel then
                local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                local lArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
                local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
                local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
                local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
                if torso and lArm and rArm and lLeg and rLeg then
                    local function connect(line, p1, p2)
                        local v1, o1 = Camera:WorldToViewportPoint(p1.Position)
                        local v2, o2 = Camera:WorldToViewportPoint(p2.Position)
                        if o1 and o2 then line.From = Vector2.new(v1.X, v1.Y); line.To = Vector2.new(v2.X, v2.Y); line.Color = skelColor; line.Visible = true
                        else line.Visible = false end
                    end
                    connect(cache.skelLines.hToT, head, torso); connect(cache.skelLines.tToLA, torso, lArm); connect(cache.skelLines.tToRA, torso, rArm)
                    connect(cache.skelLines.tToLL, torso, lLeg); connect(cache.skelLines.tToRL, torso, rLeg)
                end
            else for _, line in pairs(cache.skelLines) do line.Visible = false end end
        end

        -- Aplica Aimbot
        if aimbot and closestPlayer then
            local targetPos = closestPlayer.Position + Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)*(bypass*0.03)
            local alpha = 0.02 + (aimForce-1)*0.245
            if alpha >= 1 then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha) end
        end

        -- Setup Silent Aim
        if silentAimEnabled and not silentAimConnection then pcall(setupSilentAim) end

        -- Lógica de Movimento (Fly e Speed)
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("Humanoid") then
            local root = Player.Character.HumanoidRootPart
            local hum = Player.Character.Humanoid
            
            if flyEnabled then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                local moveDir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
                
                if moveDir.Magnitude > 0 then root.AssemblyLinearVelocity = moveDir.Unit * flySpeed
                else root.AssemblyLinearVelocity = Vector3.new(0, 0.05, 0) end
            elseif speedEnabled then
                if hum.MoveDirection.Magnitude > 0 then
                    root.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * speedValue, root.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * speedValue)
                end
            end
            
            -- Lógica Armas
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            if tool then
                if reach and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(reachDistance, reachDistance, reachDistance)
                    tool.Handle.Transparency = 1
                end
                if infiniteAmmo then
                    pcall(function()
                        local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip") or tool:FindFirstChild("MaxAmmo")
                        if ammo and ammo:IsA("IntValue") then ammo.Value = 999 end
                    end)
                end
            end
        end

        -- Lógica Automações (Lockpick e Essência)
        if autoLockpick then
            local pGui = Player:FindFirstChildOfClass("PlayerGui")
            if pGui then
                for _, g in ipairs(pGui:GetChildren()) do
                    if g:IsA("ScreenGui") and (g.Name:lower():find("lockpick") or g.Name:lower():find("minigame")) then
                        local pino = g:FindFirstChild("Pino", true) or g:FindFirstChild("Bar", true)
                        local zona = g:FindFirstChild("Zona", true) or g:FindFirstChild("Check", true)
                        if pino and zona then
                            local px = pino.AbsolutePosition.X
                            local zx = zona.AbsolutePosition.X
                            if px >= zx and px <= (zx + zona.AbsoluteSize.X) then
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                task.wait(0.02)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end

        if autoEssencia and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("BasePart") and (o.Name:lower():find("essencia") or o.Name:lower():find("essence")) then
                    if (o.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                        local prompt = o:FindFirstChildOfClass("ProximityPrompt") or o.Parent:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then fireproximityprompt(prompt) end
                    end
                end
            end
        end

        -- Pulo Infinito
        if infJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            local hum = Player.Character and Player.Character:FindFirstChild("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end

        -- Controle Veículo (Pegar)
        if grabbedVehicle and vehicleAlign and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            vehicleAlign.Position = Player.Character.HumanoidRootPart.Position + Camera.CFrame.LookVector * 15 + Vector3.new(0, 2, 0)
        end
    end)
end

mostrarLogin()
