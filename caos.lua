-- Snow S4zx Mod – Versão Ultimate Completa (TODAS as funções integradas)
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2710"

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
        if key == DONO_KEY then
            gui:Destroy(); carregarInterface(); return
        end
        
        btn.Text = "AGUARDE..."
        local ok, json = pcall(function() return game:HttpGet(KEYS_URL) end)
        if ok and json and json ~= "" then
            local keys = {}
            pcall(function() keys = game:GetService("HttpService"):JSONDecode(json) end)
            local data = keys[key]
            if data then
                status.Text = "✅ Key válida!"
                status.TextColor3 = Color3.fromRGB(0,255,100)
                task.wait(1)
                gui:Destroy(); carregarInterface(); return
            else
                status.Text = "❌ Key inválida"
                status.TextColor3 = Color3.fromRGB(255,50,50)
            end
        end
        btn.Text = "ENTRAR"
    end
    btn.Activated:Connect(tentarLogin)
end

-- ==========================================
-- INTERFACE E LÓGICA PRINCIPAL
-- ==========================================
function carregarInterface()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    local Window = Rayfield:CreateWindow({
        Name = "S4zx MODS", LoadingTitle = "S4zx MODS", LoadingSubtitle = "by Souzavz",
        Theme = "DarkBlue", KeySystem = false
    })
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local VirtualUser = game:GetService("VirtualUser")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local Player = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    
    -- ==========================================
    -- TODAS AS SUAS VARIÁVEIS EXATAMENTE AQUI
    -- ==========================================
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
    
    -- Pegar/Tacar
    local grabbedVehicle = nil; local vehicleAlign = nil; local vehicleVel = nil; local vehicleGyro = nil
    
    -- Bypass
    local lastCleanup = 0; local CLEANUP_INTERVAL = 2.0
    local flyStartY = nil
    
    -- ==========================================
    -- ABAS
    -- ==========================================
    local function safeTab(n) return Window:CreateTab(n, 4483362458) end
    local AimbotTab = safeTab("AIMBOT")
    local ESPTab = safeTab("ESP")
    local VisualTab = safeTab("VISUAL")
    local MoveTab = safeTab("MOVIMENTO")
    local SintoniaTab = safeTab("SINTONIA RP")
    local FarmTab = safeTab("FARM")
    local WeaponTab = safeTab("ARMAS")
    local CarTab = safeTab("CAR")
    local ExtrasTab = safeTab("EXTRAS")
    local StreamTab = safeTab("STREAM")
    local GrabTab = safeTab("PEGAR/TACAR")
    local ConfigTab = safeTab("CONFIG")

    local function parseColor(input)
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", verde="00ff00", azul="0000ff", branco="ffffff", rosa="ff00ff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end

    -- AIMBOT
    AimbotTab:CreateToggle({Name="AIMBOT", CurrentValue=false, Callback=function(v) aimbot = v end})
    AimbotTab:CreateSlider({Name="Força", Range={1, 5}, Increment=1, CurrentValue=1, Callback=function(v) aimForce = v end})
    AimbotTab:CreateSlider({Name="Bypass", Range={1, 10}, Increment=1, CurrentValue=1, Callback=function(v) bypass = v end})
    AimbotTab:CreateSlider({Name="FOV (Raio)", Range={50, 500}, Increment=1, CurrentValue=150, Callback=function(v) fovRadius = v end})
    AimbotTab:CreateToggle({Name="WALLCK (Parede)", CurrentValue=false, Callback=function(v) wallCheck = v end})
    AimbotTab:CreateToggle({Name="SILENT AIM", CurrentValue=false, Callback=function(v) silentAimEnabled = v end})
    
    -- ESP
    ESPTab:CreateToggle({Name="2D Box", CurrentValue=false, Callback=function(v) espBox = v end})
    ESPTab:CreateToggle({Name="Skeleton", CurrentValue=false, Callback=function(v) espSkel = v end})
    ESPTab:CreateToggle({Name="Name", CurrentValue=false, Callback=function(v) espName = v end})
    ESPTab:CreateToggle({Name="Distance", CurrentValue=false, Callback=function(v) espDistance = v end})
    ESPTab:CreateToggle({Name="Health Bar", CurrentValue=false, Callback=function(v) espHealth = v end})
    ESPTab:CreateToggle({Name="Tracer V7", CurrentValue=false, Callback=function(v) tracerV7 = v end})
    ESPTab:CreateToggle({Name="Arma Equipada", CurrentValue=false, Callback=function(v) espPlayerWeapon = v end})
    ESPTab:CreateToggle({Name="Mostrar Time", CurrentValue=false, Callback=function(v) showTeamESP = v end})
    ESPTab:CreateToggle({Name="Itens do Mapa", CurrentValue=false, Callback=function(v) espItems = v end})
    
    -- VISUAL
    VisualTab:CreateInput({Name="Cor Box", PlaceholderText="verde", Callback=function(v) local c=parseColor(v) if c then boxColor=c end end})
    VisualTab:CreateInput({Name="Cor Skeleton", PlaceholderText="rosa", Callback=function(v) local c=parseColor(v) if c then skelColor=c end end})
    VisualTab:CreateInput({Name="Cor Tracer", PlaceholderText="branco", Callback=function(v) local c=parseColor(v) if c then tracerColor=c end end})
    VisualTab:CreateToggle({Name="FOV Círculo", CurrentValue=false, Callback=function(v) fovCircle = v end})
    VisualTab:CreateToggle({Name="FOV Arco-íris", CurrentValue=false, Callback=function(v) fovRainbow = v end})
    VisualTab:CreateToggle({Name="Box Arco-íris", CurrentValue=false, Callback=function(v) rainbowBox = v end})
    VisualTab:CreateToggle({Name="Skeleton Arco-íris", CurrentValue=false, Callback=function(v) rainbowSkel = v end})
    VisualTab:CreateToggle({Name="Tracer Arco-íris", CurrentValue=false, Callback=function(v) rainbowTracer = v end})
    VisualTab:CreateToggle({Name="Personagem Arco-íris", CurrentValue=false, Callback=function(v) rainbowChar = v end})
    VisualTab:CreateSlider({Name="Velocidade Arco-íris", Range={0.1, 5}, Increment=0.1, CurrentValue=0.5, Callback=function(v) rainbowSpeed = v end})
    VisualTab:CreateToggle({Name="Custom Crosshair", CurrentValue=false, Callback=function(v) customCrosshair = v end})
    VisualTab:CreateSlider({Name="Tamanho Crosshair", Range={5, 50}, Increment=1, CurrentValue=20, Callback=function(v) crosshairSize = v end})
    
    -- MOVIMENTO
    MoveTab:CreateToggle({Name="Pulo Infinito", CurrentValue=false, Callback=function(v) infJump = v end})
    MoveTab:CreateToggle({Name="Fly Avançado", CurrentValue=false, Callback=function(v) flyEnabled = v end})
    MoveTab:CreateSlider({Name="Velocidade Fly", Range={20, 200}, Increment=1, CurrentValue=50, Callback=function(v) flySpeed = v end})
    MoveTab:CreateToggle({Name="Speed Hack", CurrentValue=false, Callback=function(v) speedEnabled = v end})
    MoveTab:CreateSlider({Name="Velocidade Speed", Range={16, 200}, Increment=1, CurrentValue=24, Callback=function(v) speedValue = v end})
    MoveTab:CreateToggle({Name="Ghost Mode (Invisível)", CurrentValue=false, Callback=function(v) ghostMode = v; invisibility = v end})

    -- SINTONIA RP
    SintoniaTab:CreateToggle({Name="Auto Lockpick Perfeito", CurrentValue=false, Callback=function(v) autoLockpick = v end})
    SintoniaTab:CreateToggle({Name="Auto Coletar Essência", CurrentValue=false, Callback=function(v) autoEssencia = v end})

    -- FARM
    FarmTab:CreateToggle({Name="S4zx Farm", CurrentValue=false, Callback=function(v) s4zxFarm = v end})
    FarmTab:CreateSlider({Name="Velocidade Farm", Range={10, 100}, Increment=1, CurrentValue=50, Callback=function(v) farmSpeed = v end})
    
    -- ARMAS
    WeaponTab:CreateToggle({Name="Reach (Alcance)", CurrentValue=false, Callback=function(v) reach = v end})
    WeaponTab:CreateSlider({Name="Distância Hitbox", Range={10, 50}, Increment=1, CurrentValue=15, Callback=function(v) reachDistance = v end})
    WeaponTab:CreateToggle({Name="Infinite Ammo", CurrentValue=false, Callback=function(v) infiniteAmmo = v end})
    WeaponTab:CreateToggle({Name="Auto Reload", CurrentValue=false, Callback=function(v) autoReload = v end})
    WeaponTab:CreateToggle({Name="No Recoil", CurrentValue=false, Callback=function(v) noRecoil = v end})
    WeaponTab:CreateToggle({Name="Rapid Fire", CurrentValue=false, Callback=function(v) rapidFire = v end})
    WeaponTab:CreateSlider({Name="Rapid Fire Delay", Range={0.01, 0.5}, Increment=0.01, CurrentValue=0.1, Callback=function(v) rapidFireDelay = v end})

    -- CAR
    CarTab:CreateToggle({Name="Fly Car", CurrentValue=false, Callback=function(v) flyCarEnabled = v end})
    CarTab:CreateSlider({Name="Velocidade Fly Car", Range={20, 300}, Increment=1, CurrentValue=50, Callback=function(v) flyCarSpeed = v end})

    -- EXTRAS
    ExtrasTab:CreateToggle({Name="Anti AFK", CurrentValue=false, Callback=function(v) antiAfk = v end})
    ExtrasTab:CreateToggle({Name="Anti Stun", CurrentValue=false, Callback=function(v) antiStun = v end})
    ExtrasTab:CreateToggle({Name="Anti Fire", CurrentValue=false, Callback=function(v) antiFire = v end})
    ExtrasTab:CreateToggle({Name="Auto Respawn", CurrentValue=false, Callback=function(v) autoRespawn = v end})

    -- STREAM
    StreamTab:CreateToggle({Name="Modo Streamer", CurrentValue=false, Callback=function(v) streamerMode = v end})

    -- CONFIG
    ConfigTab:CreateToggle({Name="Anti Live (Esconder Nome)", CurrentValue=false, Callback=function(v) antiLive = v end})

    -- PEGAR/TACAR
    GrabTab:CreateButton({Name="🖐️ PEGAR VEÍCULO", Callback=function()
        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 100)
        local hit = Workspace:FindPartOnRay(ray, Player.Character, false, true)
        if hit then
            local car = hit:FindFirstAncestorOfClass("Model")
            if car and (car:FindFirstChildWhichIsA("VehicleSeat") or car:FindFirstChildWhichIsA("Seat")) then
                grabbedVehicle = car
                local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                if primary then
                    vehicleAlign = Instance.new("AlignPosition", primary)
                    vehicleAlign.MaxForce = 9999999; vehicleAlign.Responsiveness = 200
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
    end})
    GrabTab:CreateButton({Name="💥 TACAR VEÍCULO", Callback=function()
        if grabbedVehicle then
            local primary = grabbedVehicle:FindFirstChild("PrimaryPart") or grabbedVehicle:FindFirstChildWhichIsA("BasePart")
            if primary then
                pcall(function() if vehicleAlign then vehicleAlign:Destroy() end end)
                primary.AssemblyLinearVelocity = Camera.CFrame.LookVector * 400 + Vector3.new(0, 50, 0)
            end
            grabbedVehicle = nil
        end
    end})

    -- ==========================================
    -- SISTEMAS INTERNOS E DESENHOS
    -- ==========================================
    local fovCircleObj = Drawing.new("Circle")
    fovCircleObj.Thickness = 2; fovCircleObj.Filled = false

    local crossH = Drawing.new("Line"); crossH.Thickness = 1
    local crossV = Drawing.new("Line"); crossV.Thickness = 1

    local espCache = {}
    local function criarDesenhosESP(p)
        if espCache[p] then return end
        espCache[p] = {
            box = Drawing.new("Square"), name = Drawing.new("Text"), distance = Drawing.new("Text"), tracer = Drawing.new("Line"),
            healthBg = Drawing.new("Square"), healthMain = Drawing.new("Square"), infoText = Drawing.new("Text"),
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
                espCache[p].healthBg:Remove(); espCache[p].healthMain:Remove(); espCache[p].infoText:Remove()
                for _, line in pairs(espCache[p].skelLines) do line:Remove() end
            end)
            espCache[p] = nil
        end
    end
    Players.PlayerRemoving:Connect(limparESP)

    local silentAimConnection = nil
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

    -- ==========================================
    -- MAIN RENDER LOOP (Coração do Script)
    -- ==========================================
    local lastFire = 0
    RunService.RenderStepped:Connect(function()
        local center = Camera.ViewportSize / 2
        local hue = (tick() * rainbowSpeed) % 1
        local rColor = Color3.fromHSV(hue, 1, 1)

        -- FOV e Crosshair
        fovCircleObj.Position = center; fovCircleObj.Radius = fovRadius; fovCircleObj.Visible = fovCircle
        fovCircleObj.Color = fovRainbow and rColor or Color3.new(1,1,1)

        if customCrosshair then
            crossH.From = Vector2.new(center.X - crosshairSize, center.Y)
            crossH.To = Vector2.new(center.X + crosshairSize, center.Y)
            crossV.From = Vector2.new(center.X, center.Y - crosshairSize)
            crossV.To = Vector2.new(center.X, center.Y + crosshairSize)
            crossH.Color = crosshairColor; crossV.Color = crosshairColor
            crossH.Visible = true; crossV.Visible = true
        else
            crossH.Visible = false; crossV.Visible = false
        end

        local closestPlayer = nil; local closestDist = fovRadius

        -- LOOP JOGADORES (ESP & AIMBOT)
        for _, p in ipairs(Players:GetPlayers()) do
            if p == Player then continue end
            local char = p.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if not root or not head or not hum or hum.Health <= 0 then limparESP(p); continue end
            local rootPos, rootVisible = Camera:WorldToViewportPoint(root.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.6, 0))
            
            -- Aimbot Scan
            if aimbot then
                local screenDist = (Vector2.new(headPos.X, headPos.Y) - center).Magnitude
                if screenDist <= fovRadius and screenDist < closestDist then
                    if wallCheck then
                        local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000)
                        local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {Player.Character}, false, true)
                        if hit and hit:IsDescendantOf(char) then closestPlayer = head; closestDist = screenDist end
                    else closestPlayer = head; closestDist = screenDist end
                end
            end

            -- ESP Render
            if not rootVisible then limparESP(p); continue end
            criarDesenhosESP(p)
            local cache = espCache[p]
            local feetPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
            local height = math.abs(headPos.Y - feetPos.Y)
            local width = height * 0.55

            if espBox then
                cache.box.Size = Vector2.new(width, height); cache.box.Position = Vector2.new(rootPos.X - width/2, headPos.Y)
                cache.box.Color = rainbowBox and rColor or boxColor; cache.box.Visible = true
            else cache.box.Visible = false end

            if espName then
                cache.name.Text = antiLive and "Jogador Oculto" or p.Name
                cache.name.Size = 14; cache.name.Center = true; cache.name.Outline = true
                cache.name.Position = Vector2.new(rootPos.X, headPos.Y - 16); cache.name.Color = Color3.new(1,1,1); cache.name.Visible = true
            else cache.name.Visible = false end

            if espDistance then
                local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
                cache.distance.Text = tostring(dist) .. " studs"
                cache.distance.Size = 12; cache.distance.Center = true; cache.distance.Outline = true
                cache.distance.Position = Vector2.new(rootPos.X, feetPos.Y + 2); cache.distance.Color = Color3.fromRGB(200,200,200); cache.distance.Visible = true
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
                cache.tracer.From = Vector2.new(center.X, Camera.ViewportSize.Y - 10); cache.tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                cache.tracer.Color = rainbowTracer and rColor or tracerColor; cache.tracer.Visible = true
            else cache.tracer.Visible = false end

            -- Info Adicional (Arma e Time)
            local extraInfo = ""
            if showTeamESP and p.Team then extraInfo = extraInfo .. "[" .. p.Team.Name .. "]\n" end
            if espPlayerWeapon then
                local t = char:FindFirstChildOfClass("Tool")
                if t then extraInfo = extraInfo .. t.Name end
            end
            if extraInfo ~= "" then
                cache.infoText.Text = extraInfo; cache.infoText.Size = 12; cache.infoText.Center = true; cache.infoText.Outline = true
                cache.infoText.Position = Vector2.new(rootPos.X + width/2 + 20, headPos.Y + height/2); cache.infoText.Color = Color3.new(1,1,1); cache.infoText.Visible = true
            else cache.infoText.Visible = false end

            if espSkel then
                local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                local lArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
                local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
                local lLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftUpperLeg")
                local rLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightUpperLeg")
                if torso and lArm and rArm and lLeg and rLeg then
                    local function connect(line, p1, p2)
                        local v1, o1 = Camera:WorldToViewportPoint(p1.Position); local v2, o2 = Camera:WorldToViewportPoint(p2.Position)
                        if o1 and o2 then line.From = Vector2.new(v1.X, v1.Y); line.To = Vector2.new(v2.X, v2.Y); line.Color = rainbowSkel and rColor or skelColor; line.Visible = true
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

        if silentAimEnabled and not silentAimConnection then pcall(setupSilentAim) end

        -- Local Player Logic (Movimento, Armas, Extras)
        local lChar = Player.Character
        if lChar and lChar:FindFirstChild("HumanoidRootPart") and lChar:FindFirstChild("Humanoid") then
            local root = lChar.HumanoidRootPart
            local hum = lChar.Humanoid
            
            -- Ghost / Invis / Rainbow Char
            if ghostMode or invisibility then
                for _, part in ipairs(lChar:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = 0.5 end
                end
            end
            if rainbowChar then
                for _, part in ipairs(lChar:GetDescendants()) do
                    if part:IsA("BasePart") then part.Color = rColor end
                end
            end

            -- Fly Player e Fly Car
            if flyCarEnabled and hum.SeatPart then
                local veh = hum.SeatPart:FindFirstAncestorOfClass("Model")
                if veh and veh.PrimaryPart then
                    local moveDir = Vector3.new(0,0,0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                    if moveDir.Magnitude > 0 then veh.PrimaryPart.AssemblyLinearVelocity = moveDir.Unit * flyCarSpeed
                    else veh.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0.1, 0) end
                end
            elseif flyEnabled then
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

            -- Anti Stun/Fire
            if antiStun or antiFire then
                for _, v in ipairs(lChar:GetDescendants()) do
                    if antiFire and (v:IsA("Fire") or v.Name:lower():match("fire")) then v:Destroy() end
                    if antiStun and (v.Name:lower():match("stun") or v.Name:lower():match("taze")) then v:Destroy() end
                end
            end

            -- Lógica Armas
            local tool = lChar:FindFirstChildOfClass("Tool")
            if tool then
                if reach and tool:FindFirstChild("Handle") then
                    tool.Handle.Size = Vector3.new(reachDistance, reachDistance, reachDistance); tool.Handle.Transparency = 1
                end
                if infiniteAmmo then
                    pcall(function()
                        local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip")
                        if ammo and ammo:IsA("IntValue") then ammo.Value = 999 end
                    end)
                end
                if rapidFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    if tick() - lastFire >= rapidFireDelay then
                        tool:Activate(); lastFire = tick()
                    end
                end
                if autoReload then
                    pcall(function()
                        local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Clip")
                        if ammo and ammo:IsA("IntValue") and ammo.Value == 0 then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game) end
                    end)
                end
            end
        end

        -- Streamer Mode
        if streamerMode then Window.Enabled = false else Window.Enabled = true end

        -- Automações Lockpick / Essência
        if autoLockpick then
            local pGui = Player:FindFirstChildOfClass("PlayerGui")
            if pGui then
                for _, g in ipairs(pGui:GetChildren()) do
                    if g:IsA("ScreenGui") and (g.Name:lower():find("lockpick") or g.Name:lower():find("minigame")) then
                        local pino = g:FindFirstChild("Pino", true) or g:FindFirstChild("Bar", true)
                        local zona = g:FindFirstChild("Zona", true) or g:FindFirstChild("Check", true)
                        if pino and zona then
                            local px = pino.AbsolutePosition.X; local zx = zona.AbsolutePosition.X
                            if px >= zx and px <= (zx + zona.AbsoluteSize.X) then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game); task.wait(0.02)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game); task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end
        if autoEssencia and lChar and lChar:FindFirstChild("HumanoidRootPart") then
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("BasePart") and (o.Name:lower():find("essencia") or o.Name:lower():find("essence")) then
                    if (o.Position - lChar.HumanoidRootPart.Position).Magnitude <= 15 then
                        local prompt = o:FindFirstChildOfClass("ProximityPrompt") or o.Parent:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then fireproximityprompt(prompt) end
                    end
                end
            end
        end

        -- Pulo Infinito
        if infJump and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            local hum = lChar and lChar:FindFirstChild("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end

        -- S4zx Farm (Simples Auto TP para Dinheiro)
        if s4zxFarm and lChar and lChar:FindFirstChild("HumanoidRootPart") then
            local root = lChar.HumanoidRootPart
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("BasePart") and (o.Name:lower():find("cash") or o.Name:lower():find("money")) then
                    root.CFrame = root.CFrame:Lerp(o.CFrame, farmSpeed * 0.001)
                    break
                end
            end
        end
    end)
    
    -- Anti AFK Event e Auto Respawn
    Player.Idled:Connect(function()
        if antiAfk then VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end
    end)
    Player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(function()
            if autoRespawn then task.wait(0.5); pcall(function() Player:LoadCharacter() end) end
        end)
    end)
end

mostrarLogin()
