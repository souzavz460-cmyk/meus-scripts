-- Snow S4zx Mod – Sistema PEGAR/TACAR veículo + todas as funções anteriores
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2026"

-- Tela de Login
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
            status.Text = "✅ Key do Dono (Permanente)"
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
                            local diasRestantes = math.ceil((expira - os.time()) / 86400)
                            status.Text = "✅ Key válida! Dias: " .. diasRestantes
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

-- Função principal da interface
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
    local CoreGui = game:GetService("CoreGui")
    local Player = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Lighting = game:GetService("Lighting")
    
    -- Variáveis de estado
    local aimbot = false; local aimForce = 1; local bypass = 1; local fovRadius = 150
    local wallCheck = false; local silentAimEnabled = false
    local fovCircle = false; local fovRainbow = false
    local espBox = false; local espSkel = false; local espName = false
    local espDistance = false; local espHealth = false; local tracerV7 = false
    local espItems = false; local showMoney = false; local showTeamESP = false; local espPlayerWeapon = false
    local infJump = false; local flyEnabled = false; local flySpeed = 50
    local speedEnabled = false; local speedValue = 24
    local s4zxFarm = false; local farmSpeed = 50
    local antiLive = false
    local boxColor = Color3.fromRGB(0,255,0); local skelColor = Color3.fromRGB(255,105,180)
    local tracerColor = Color3.fromRGB(255,255,255)
    local invisibility = false; local ghostMode = false
    local antiAfk = false; local antiStun = false; local antiFire = false; local autoRespawn = false
    local reach = false; local reachDistance = 15
    local infiniteAmmo = false; local autoReload = false
    local noRecoil = false; local rapidFire = false; local rapidFireDelay = 0.1
    local rainbowChar = false; local rainbowSpeed = 0.5
    local rainbowBox = false; local rainbowSkel = false; local rainbowTracer = false
    local flyCarEnabled = false; local flyCarSpeed = 50
    local streamerMode = false
    local customCrosshair = false; local crosshairSize = 20; local crosshairColor = Color3.fromRGB(255,0,0)
    
    -- Novas Automações Sintonia
    local autoLockpick = false
    local autoEssencia = false

    local grabbedVehicle = nil
    local vehicleAlign = nil
    local vehicleVel = nil
    local vehicleGyro = nil
    
    -- Bypass Variables
    local lastCleanup = 0
    local CLEANUP_INTERVAL = 1.5
    
    -- Abas
    local function safeTab(n, i) local t; pcall(function() t = Window:CreateTab(n, i) end); return t end
    local AimbotTab = safeTab("AIMBOT", 4483362458)
    local ESPTab = safeTab("ESP", 4483362458)
    local VisualTab = safeTab("VISUAL", 4483362458)
    local MoveTab = safeTab("MOVIMENTO", 4483362458)
    local SintoniaTab = safeTab("SINTONIA RP", 4483362458) -- Nova Aba Unificada
    local FarmTab = safeTab("FARM", 4483362458)
    local WeaponTab = safeTab("ARMAS", 4483362458)
    local CarTab = safeTab("CAR", 4483362458)
    local ExtrasTab = safeTab("EXTRAS", 4483362458)
    local StreamTab = safeTab("STREAM", 4483362458)
    local GrabTab = safeTab("PEGAR/TACAR", 4483362458)
    local ConfigTab = safeTab("CONFIG", 4483362458)
    
    local function safeToggle(tab, name, d, cb) if tab then pcall(function() tab:CreateToggle({Name=name, CurrentValue=d, Callback=cb}) end) end end
    local function safeSlider(tab, name, min, max, d, cb) if tab then pcall(function() tab:CreateSlider({Name=name, Range={min, max}, Increment=1, CurrentValue=d, Callback=cb, Flag=name:gsub("%s","_")}) end) end end
    local function safeInput(tab, name, ph, cb) if tab then pcall(function() tab:CreateInput({Name=name, PlaceholderText=ph, RemoveTextAfterFocusLost=false, Callback=cb}) end) end end
    local function safeButton(tab, name, cb) if tab then pcall(function() tab:CreateButton({Name=name, Callback=cb}) end) end end
    
    -- AIMBOT
    safeToggle(AimbotTab, "AIMBOT", false, function(v) aimbot = v end)
    safeSlider(AimbotTab, "Força (1-5)", 1, 5, 1, function(v) aimForce = v end)
    safeSlider(AimbotTab, "Bypass", 1, 10, 1, function(v) bypass = v end)
    safeSlider(AimbotTab, "FOV (Raio)", 50, 500, 150, function(v) fovRadius = v end)
    safeToggle(AimbotTab, "WALLCK (Parede)", false, function(v) wallCheck = v end)
    safeToggle(AimbotTab, "SILENT AIM", false, function(v) silentAimEnabled = v end)
    
    -- ESP
    safeToggle(ESPTab, "2D Box", false, function(v) espBox = v end)
    safeToggle(ESPTab, "Skeleton", false, function(v) espSkel = v end)
    safeToggle(ESPTab, "Name", false, function(v) espName = v end)
    safeToggle(ESPTab, "Distance", false, function(v) espDistance = v end)
    safeToggle(ESPTab, "Health Bar", false, function(v) espHealth = v end)
    safeToggle(ESPTab, "Tracer V7 (do chão)", false, function(v) tracerV7 = v end)
    safeToggle(ESPTab, "Itens (Moedas/Armas)", false, function(v) espItems = v end)
    safeToggle(ESPTab, "Dinheiro", false, function(v) showMoney = v end)
    safeToggle(ESPTab, "Mostrar Time", false, function(v) showTeamESP = v end)
    safeToggle(ESPTab, "Arma Equipada", false, function(v) espPlayerWeapon = v end)
    
    -- VISUAL
    safeInput(VisualTab, "Cor Box", "verde", function(v) local c=parseColor(v) if c then boxColor=c end end)
    safeInput(VisualTab, "Cor Skeleton", "rosa", function(v) local c=parseColor(v) if c then skelColor=c end end)
    safeInput(VisualTab, "Cor Tracer V7", "branco", function(v) local c=parseColor(v) if c then tracerColor=c end end)
    safeToggle(VisualTab, "FOV Círculo", false, function(v) fovCircle = v end)
    safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)
    
    -- MOVIMENTO (Fly Otimizado "Estilo Andando" integrado)
    safeToggle(MoveTab, "Pulo Infinito", false, function(v) infJump = v end)
    safeToggle(MoveTab, "Fly Avançado (Estilo Andando)", false, function(v) flyEnabled = v end)
    safeSlider(MoveTab, "Velocidade Fly", 20, 200, 50, function(v) flySpeed = v end)
    safeToggle(MoveTab, "Speed Hack", false, function(v) speedEnabled = v end)
    safeSlider(MoveTab, "Velocidade Speed", 16, 200, 24, function(v) speedValue = v end)
    safeToggle(MoveTab, "Ghost Mode (Invisível)", false, function(v) ghostMode = v; invisibility = v end)
    
    -- SINTONIA RP AUTOMATIONS
    safeToggle(SintoniaTab, "Auto Lockpick Perfeito", false, function(v) autoLockpick = v end)
    safeToggle(SintoniaTab, "Auto Coletar Essência", false, function(v) autoEssencia = v end)

    -- FARM
    safeToggle(FarmTab, "S4zx Farm", false, function(v) s4zxFarm = v end)
    safeSlider(FarmTab, "Velocidade Farm", 30, 100, 50, function(v) farmSpeed = v end)
    
    -- ARMAS
    safeToggle(WeaponTab, "Reach (Alcance)", false, function(v) reach = v end)
    safeSlider(WeaponTab, "Distância", 10, 50, 15, function(v) reachDistance = v end)
    safeToggle(WeaponTab, "Infinite Ammo", false, function(v) infiniteAmmo = v end)
    safeToggle(WeaponTab, "Auto Reload", false, function(v) autoReload = v end)
    safeToggle(WeaponTab, "No Recoil", false, function(v) noRecoil = v end)
    safeToggle(WeaponTab, "Rapid Fire", false, function(v) rapidFire = v end)
    safeSlider(WeaponTab, "Rapid Fire Delay", 0.05, 0.5, 0.1, function(v) rapidFireDelay = v end)
    
    -- CAR
    safeToggle(CarTab, "Fly Car", false, function(v) flyCarEnabled = v end)
    safeSlider(CarTab, "Velocidade Fly Car", 20, 200, 50, function(v) flyCarSpeed = v end)
    
    -- EXTRAS
    safeToggle(ExtrasTab, "Anti AFK", false, function(v) antiAfk = v end)
    safeToggle(ExtrasTab, "Anti Stun", false, function(v) antiStun = v end)
    safeToggle(ExtrasTab, "Anti Fire", false, function(v) antiFire = v end)
    safeToggle(ExtrasTab, "Auto Respawn", false, function(v) autoRespawn = v end)
    
    -- PEGAR/TACAR
    safeButton(GrabTab, "🖐️ PEGAR (Raycast)", function()
        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 100)
        local hit, pos = Workspace:FindPartOnRay(ray, Player.Character, false, true)
        if hit then
            local car = hit:FindFirstAncestorOfClass("Model")
            if car and (car:FindFirstChildWhichIsA("VehicleSeat") or car:FindFirstChildWhichIsA("Seat")) then
                if grabbedVehicle then
                    pcall(function()
                        if vehicleAlign then vehicleAlign:Destroy() end
                        if vehicleVel then vehicleVel:Destroy() end
                        if vehicleGyro then vehicleGyro:Destroy() end
                    end)
                    grabbedVehicle = nil
                end
                grabbedVehicle = car
                local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                if primary then
                    vehicleAlign = Instance.new("AlignPosition")
                    vehicleAlign.MaxForce = 9999999
                    vehicleAlign.Responsiveness = 200
                    vehicleAlign.Attachment0 = primary:FindFirstChild("AlignAttachment") or Instance.new("Attachment", primary)
                    local char = Player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        local attach = root:FindFirstChild("GrabAttach") or Instance.new("Attachment", root)
                        attach.Name = "GrabAttach"
                        vehicleAlign.Attachment1 = attach
                    end
                    vehicleAlign.Parent = primary
                    
                    vehicleVel = Instance.new("LinearVelocity")
                    vehicleVel.MaxForce = 9999999
                    vehicleVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
                    vehicleVel.Attachment0 = primary:FindFirstChild("VelAttachment") or Instance.new("Attachment", primary)
                    vehicleVel.Parent = primary
                    
                    vehicleGyro = Instance.new("AngularVelocity")
                    vehicleGyro.MaxTorque = 9999999
                    vehicleGyro.AngularVelocity = Vector3.new(0,0,0)
                    vehicleGyro.Attachment0 = primary:FindFirstChild("GyroAttachment") or Instance.new("Attachment", primary)
                    vehicleGyro.Parent = primary
                end
            end
        end
    end)
    
    safeButton(GrabTab, "💥 TACAR", function()
        if not grabbedVehicle then return end
        local primary = grabbedVehicle:FindFirstChild("PrimaryPart") or grabbedVehicle:FindFirstChildWhichIsA("BasePart")
        if primary then
            pcall(function()
                if vehicleAlign then vehicleAlign:Destroy() end
                if vehicleVel then vehicleVel:Destroy() end
                if vehicleGyro then vehicleGyro:Destroy() end
            end)
            local throwDir = Camera.CFrame.LookVector * 400 + Vector3.new(0, 50, 0)
            pcall(function()
                primary.AssemblyLinearVelocity = throwDir
                local randomTorque = Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
                primary.AssemblyAngularVelocity = randomTorque
            end)
        end
        grabbedVehicle = nil
    end)
    
    -- STREAM
    safeToggle(StreamTab, "Modo Streamer", false, function(v)
        streamerMode = v
        Window.Enabled = not v
    end)
    
    -- CONFIG
    safeToggle(ConfigTab, "Anti Live", false, function(v) antiLive = v end)
    
    function parseColor(input)
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end
    
    -- ==================== FUNÇÕES INTERNAS E LOOPS ====================
    task.spawn(function()
        local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
        local fovCircleObj
        if useDrawing then
            pcall(function()
                fovCircleObj = Drawing.new("Circle")
                fovCircleObj.Visible=false; fovCircleObj.Thickness=2; fovCircleObj.Radius=fovRadius
                fovCircleObj.Color=Color3.new(1,1,1); fovCircleObj.Filled=false
            end)
        end
        local boxes2D, skeletons, nameTags, healthBars, distanceTags, tracerLines = {}, {}, {}, {}, {}, {}
        local itemESP = {}
        local crosshairObj
        local silentAimConnection
        
        -- OTIMIZAÇÃO FLY: ESTILO ANDANDO COM BYPASS MÁXIMO
        local function flyStep()
            local char = Player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            if not root or not hum then return end
            
            if not flyEnabled then 
                if hum.PlatformStand then hum.PlatformStand = false end
                return 
            end
            
            -- Bypass ativo mudando estados de queda para simular solo estável
            hum:ChangeState(Enum.HumanoidStateType.Running)
            
            local camCFrame = Camera.CFrame
            local velocityDir = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocityDir = velocityDir + camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocityDir = velocityDir - camCFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocityDir = velocityDir - camCFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocityDir = velocityDir + camCFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocityDir = velocityDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then velocityDir = velocityDir - Vector3.new(0, 1, 0) end
            
            if velocityDir.Magnitude > 0 then
                root.AssemblyLinearVelocity = velocityDir.Unit * flySpeed
            else
                root.AssemblyLinearVelocity = Vector3.new(0, 0.1, 0) -- Mantém flutuando estático sem cair
            end
        end

        -- AUTO LOCKPICK PERFEITO (SINTONIA RP)
        local function lockpickStep()
            if not autoLockpick then return end
            local playerGui = Player:FindFirstChildOfClass("PlayerGui")
            if not playerGui then return end
            
            -- Estrutura genérica de minigame de UI usada nos scripts do Sintonia RP
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and (gui.Name:lower():find("lockpick") or gui.Name:lower():find("minigame") or gui.Name:lower():find("roubo")) then
                    local pino = gui:FindFirstChild("Pino", true) or gui:FindFirstChild("Bar", true) or gui:FindFirstChild("Target", true)
                    local zona = gui:FindFirstChild("Zona", true) or gui:FindFirstChild("Check", true) or gui:FindFirstChild("Safe", true)
                    
                    if pino and zona then
                        -- Se a agulha/pino interceptar matematicamente a zona de sucesso, ele simula a tecla
                        local pinoPos = pino.AbsolutePosition.X
                        local zonaMin = zona.AbsolutePosition.X
                        local zonaMax = zonaMin + zona.AbsoluteSize.X
                        
                        if pinoPos >= zonaMin and pinoPos <= zonaMax then
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                task.wait(0.05)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                            end)
                            task.wait(0.1)
                        end
                    end
                end
            end
        end

        -- AUTO ESSÊNCIA (SINTONIA RP)
        local function essenciaStep()
            if not autoEssencia then return end
            local char = Player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("essencia") or obj.Name:lower():find("essence")) then
                    local dist = (obj.Position - root.Position).Magnitude
                    if dist <= 15 then -- Raio seguro de coleta
                        pcall(function()
                            -- Dispara proximidade ativa nativa do jogo
                            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj.Parent:FindFirstChildOfClass("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                        end)
                    end
                end
            end
        end

        -- Silent Aim Setup
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
                        local headPos = nearest.Head.Position
                        obj.Velocity = (headPos - obj.Position).Unit * obj.Velocity.Magnitude
                        obj.CFrame = CFrame.new(obj.Position, headPos)
                    end
                end
            end)
        end
        
        -- Aimbot Loop Logic
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
                            local ray = Ray.new(Camera.CFrame.Position, (chr.Head.Position - Camera.CFrame.Position).Unit * 1000)
                            local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {Player.Character}, false, true)
                            if hit and not hit:IsDescendantOf(chr) then continue end
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
        
        -- ESP Engine Rendering
        local function updateESP()
            if not useDrawing then return end
            for p, box in pairs(boxes2D) do if not p or not p.Parent then pcall(function() box:Remove() end); boxes2D[p]=nil end end
            for p, data in pairs(skeletons) do if not p or not p.Parent then for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end end
            for p, tag in pairs(nameTags) do if not p or not p.Parent then pcall(function() tag:Remove() end); nameTags[p]=nil end end
            for p, bar in pairs(healthBars) do if not p or not p.Parent then pcall(function() bar.bg:Remove(); bar.fill:Remove() end); healthBars[p]=nil end end
            for p, tag in pairs(distanceTags) do if not p or not p.Parent then pcall(function() tag:Remove() end); distanceTags[p]=nil end end
            for p, line in pairs(tracerLines) do if not p or not p.Parent then pcall(function() line:Remove() end); tracerLines[p]=nil end end
            
            local screenSize = Camera.ViewportSize
            local tracerOrigin = Vector2.new(screenSize.X / 2, screenSize.Y - 5)
            local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            local hue = (tick() * rainbowSpeed) % 1
            local rainbowColor = Color3.fromHSV(hue, 1, 1)

            for _, p in ipairs(Players:GetPlayers()) do
                if p == Player then continue end
                local char = p.Character
                if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then continue end
                local hum = char:FindFirstChild("Humanoid")
                if not hum or hum.Health <= 0 then continue end
                
                local headScreenPos, headVisible = Camera:WorldToViewportPoint(char.Head.Position + Vector3.new(0, 1.8, 0))
                local rootScreenPos, rootVisible = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                local feetScreenPos, feetVisible = Camera:WorldToViewportPoint(char.HumanoidRootPart.Position - Vector3.new(0, 3, 0))

                if tracerV7 and rootVisible then
                    if not tracerLines[p] then tracerLines[p] = Drawing.new("Line") end
                    tracerLines[p].From = tracerOrigin; tracerLines[p].To = Vector2.new(rootScreenPos.X, rootScreenPos.Y)
                    tracerLines[p].Color = rainbowTracer and rainbowColor or tracerColor
                    tracerLines[p].Thickness = 1; tracerLines[p].Visible = true
                end

                if espBox and headVisible and feetVisible then
                    local bodyHeight = math.abs(headScreenPos.Y - feetScreenPos.Y)
                    local bodyWidth = bodyHeight * 0.45
                    if not boxes2D[p] then boxes2D[p] = Drawing.new("Square") end
                    boxes2D[p].Position = Vector2.new(((headScreenPos.X + feetScreenPos.X)/2) - bodyWidth/2, headScreenPos.Y)
                    boxes2D[p].Size = Vector2.new(bodyWidth, bodyHeight)
                    boxes2D[p].Color = rainbowBox and rainbowColor or boxColor
                    boxes2D[p].Filled = false; boxes2D[p].Visible = true
                end
            end
            
            if fovCircleObj then
                fovCircleObj.Position = screenSize / 2
                fovCircleObj.Radius = fovRadius
                fovCircleObj.Visible = fovCircle
            end
        end
        
        -- Speed Hack funcional
        local function speedStep()
            if not speedEnabled or flyEnabled then return end
            local char = Player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            if root and hum and hum.MoveDirection.Magnitude > 0 then
                root.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * speedValue, root.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * speedValue)
            end
        end

        -- Bypass Geral e Anticheat Spoofing
        local function bypassCleanup()
            local now = tick()
            if now - lastCleanup < CLEANUP_INTERVAL then return end
            pcall(function()
                Player:SetAttribute("FlyHack", nil)
                Player:SetAttribute("SpeedHack", nil)
            end)
            lastCleanup = now
        end

        -- Main Connection Loop
        RunService.RenderStepped:Connect(function()
            pcall(aimbotStep)
            pcall(updateESP)
            pcall(speedStep)
            pcall(flyStep)
            pcall(lockpickStep)
            pcall(essenciaStep)
            pcall(bypassCleanup)
            
            if grabbedVehicle and vehicleAlign then
                local char = Player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    vehicleAlign.Position = char.HumanoidRootPart.Position + char.HumanoidRootPart.CFrame.LookVector * 12 + Vector3.new(0, 2, 0)
                end
            end
            
            if silentAimEnabled and not silentAimConnection then pcall(setupSilentAim) end
        end)
    end)
end

mostrarLogin()
