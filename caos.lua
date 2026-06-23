-- Snow S4zx Mod – Versão Stealth 2026 (Menos rastros possível)
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2026"

-- ==================== BYPASS ULTRA STEALTH ====================
local function applyUltraBypass()
    pcall(function()
        -- Hook Namecall discreto
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" or
               (self.Name and (self.Name:lower():find("anticheat") or self.Name:lower():find("ac_") or 
                               self.Name:lower():find("kick") or self.Name:lower():find("log"))) then
                return task.wait(9e9)
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)

        -- Spoof discreto
        local oldIndex = hookmetamethod(game, "__index", function(self, key)
            if key == "WalkSpeed" then return 16 end
            if key == "PlatformStand" then return false end
            return oldIndex(self, key)
        end)

        -- Limpeza de logs
        pcall(function()
            game:GetService("LogService"):Clear()
        end)
    end)
end

-- Tela de Login (igual à original)
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
    
    applyUltraBypass()
    
    -- Variáveis
    local aimbot = false; local aimForce = 1; local bypass = 1; local fovRadius = 150
    local wallCheck = false; local silentAimEnabled = false
    local fovCircle = false; local fovRainbow = false
    local espBox = false; local espSkel = false; local espName = false
    local espDistance = false; local espHealth = false; local tracerV7 = false
    local espItems = false; local showMoney = false; local showTeamESP = false; local espPlayerWeapon = false
    local infJump = false; local flyEnabled = false; local flySpeed = 55
    local speedEnabled = false; local speedValue = 24
    local s4zxFarm = false; local farmSpeed = 50
    local antiLive = false
    local boxColor = Color3.fromRGB(0,255,0); local skelColor = Color3.fromRGB(255,105,180)
    local tracerColor = Color3.fromRGB(255,255,255)
    local ghostMode = false
    local antiAfk = false; local antiStun = false; local antiFire = false; local autoRespawn = false
    local reach = false; local reachDistance = 15
    local infiniteAmmo = false; local autoReload = false
    local noRecoil = false; local rapidFire = false; local rapidFireDelay = 0.1
    local rainbowBox = false; local rainbowSkel = false; local rainbowTracer = false
    local flyCarEnabled = false; local flyCarSpeed = 50
    local streamerMode = false
    local customCrosshair = false; local crosshairSize = 20; local crosshairColor = Color3.fromRGB(255,0,0)
    
    -- PEGAR/TACAR
    local grabbedVehicle = nil
    local vehicleAlign = nil
    local vehicleVel = nil
    local vehicleGyro = nil
    
    local autoEssencia = false
    local autoLockpickEnabled = false
    
    local lastCleanup = 0
    local CLEANUP_INTERVAL = 2.0
    
    -- Abas e Interface (mesma do original)
    local function safeTab(n, i) local t; pcall(function() t = Window:CreateTab(n, i) end); return t end
    local AimbotTab = safeTab("AIMBOT", 4483362458)
    local ESPTab = safeTab("ESP", 4483362458)
    local VisualTab = safeTab("VISUAL", 4483362458)
    local MoveTab = safeTab("MOVIMENTO", 4483362458)
    local FarmTab = safeTab("FARM", 4483362458)
    local WeaponTab = safeTab("ARMAS", 4483362458)
    local CarTab = safeTab("CAR", 4483362458)
    local ExtrasTab = safeTab("EXTRAS", 4483362458)
    local GrabTab = safeTab("PEGAR/TACAR", 4483362458)
    local ConfigTab = safeTab("CONFIG", 4483362458)
    
    local function safeToggle(tab, name, d, cb) if tab then pcall(function() tab:CreateToggle({Name=name, CurrentValue=d, Callback=cb}) end) end end
    local function safeSlider(tab, name, min, max, d, cb) if tab then pcall(function() tab:CreateSlider({Name=name, Range={min, max}, Increment=1, CurrentValue=d, Callback=cb, Flag=name:gsub("%s","_")}) end) end end
    local function safeInput(tab, name, ph, cb) if tab then pcall(function() tab:CreateInput({Name=name, PlaceholderText=ph, RemoveTextAfterFocusLost=false, Callback=cb}) end) end end
    local function safeButton(tab, name, cb) if tab then pcall(function() tab:CreateButton({Name=name, Callback=cb}) end) end end
    
    -- Preenchendo toggles (igual ao original)
    safeToggle(AimbotTab, "AIMBOT", false, function(v) aimbot = v end)
    safeSlider(AimbotTab, "Força (1-5)", 1, 5, 1, function(v) aimForce = v end)
    safeSlider(AimbotTab, "Bypass", 1, 10, 1, function(v) bypass = v end)
    safeSlider(AimbotTab, "FOV (Raio)", 50, 500, 150, function(v) fovRadius = v end)
    safeToggle(AimbotTab, "WALLCK (Parede)", false, function(v) wallCheck = v end)
    safeToggle(AimbotTab, "SILENT AIM", false, function(v) silentAimEnabled = v end)
    
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
    
    safeInput(VisualTab, "Cor Box", "verde", function(v) local c=parseColor(v) if c then boxColor=c end end)
    safeInput(VisualTab, "Cor Skeleton", "rosa", function(v) local c=parseColor(v) if c then skelColor=c end end)
    safeInput(VisualTab, "Cor Tracer V7", "branco", function(v) local c=parseColor(v) if c then tracerColor=c end end)
    safeToggle(VisualTab, "FOV Círculo", false, function(v) fovCircle = v end)
    safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)
    
    safeToggle(MoveTab, "Pulo Infinito", false, function(v) infJump = v end)
    safeToggle(MoveTab, "Fly Avançado (Natural)", false, function(v) flyEnabled = v end)
    safeSlider(MoveTab, "Velocidade Fly", 20, 80, 55, function(v) flySpeed = v end)
    safeToggle(MoveTab, "Speed Hack", false, function(v) speedEnabled = v end)
    safeSlider(MoveTab, "Velocidade Speed", 16, 200, 24, function(v) speedValue = v end)
    safeToggle(MoveTab, "Ghost Mode (Invisível)", false, function(v) ghostMode = v end)
    
    safeToggle(FarmTab, "S4zx Farm", false, function(v) s4zxFarm = v end)
    safeToggle(FarmTab, "Auto Essência", false, function(v) autoEssencia = v end)
    safeSlider(FarmTab, "Velocidade Farm", 30, 100, 50, function(v) farmSpeed = v end)
    
    safeToggle(WeaponTab, "Reach (Alcance)", false, function(v) reach = v end)
    safeSlider(WeaponTab, "Distância", 10, 50, 15, function(v) reachDistance = v end)
    safeToggle(WeaponTab, "Infinite Ammo", false, function(v) infiniteAmmo = v end)
    safeToggle(WeaponTab, "Auto Reload", false, function(v) autoReload = v end)
    safeToggle(WeaponTab, "No Recoil", false, function(v) noRecoil = v end)
    safeToggle(WeaponTab, "Rapid Fire", false, function(v) rapidFire = v end)
    safeSlider(WeaponTab, "Rapid Fire Delay", 0.05, 0.5, 0.1, function(v) rapidFireDelay = v end)
    
    safeToggle(CarTab, "Fly Car", false, function(v) flyCarEnabled = v end)
    safeSlider(CarTab, "Velocidade Fly Car", 20, 200, 50, function(v) flyCarSpeed = v end)
    
    safeToggle(ExtrasTab, "Anti AFK", false, function(v) antiAfk = v end)
    safeToggle(ExtrasTab, "Anti Stun", false, function(v) antiStun = v end)
    safeToggle(ExtrasTab, "Anti Fire", false, function(v) antiFire = v end)
    safeToggle(ExtrasTab, "Auto Respawn", false, function(v) autoRespawn = v end)
    safeToggle(ExtrasTab, "Auto Lockpick", false, function(v) autoLockpickEnabled = v end)
    
    safeButton(GrabTab, "🖐️ PEGAR (Raycast)", function() -- código original do pegar
        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 100)
        local hit, pos = Workspace:FindPartOnRay(ray, Player.Character, false, true)
        if hit then
            local car = hit:FindFirstAncestorOfClass("Model")
            if car and (car:FindFirstChildWhichIsA("VehicleSeat") or car:FindFirstChildWhichIsA("Seat")) then
                if grabbedVehicle then pcall(function() if vehicleAlign then vehicleAlign:Destroy() end if vehicleVel then vehicleVel:Destroy() end if vehicleGyro then vehicleGyro:Destroy() end end) grabbedVehicle = nil end
                grabbedVehicle = car
                local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                if primary then
                    vehicleAlign = Instance.new("AlignPosition") vehicleAlign.MaxForce = 9999999 vehicleAlign.Responsiveness = 200
                    vehicleAlign.Attachment0 = primary:FindFirstChild("AlignAttachment") or Instance.new("Attachment", primary)
                    local char = Player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local root = char.HumanoidRootPart
                        local attach = root:FindFirstChild("GrabAttach") or Instance.new("Attachment", root)
                        attach.Name = "GrabAttach"
                        vehicleAlign.Attachment1 = attach
                    end
                    vehicleAlign.Parent = primary
                end
            end
        end
    end)
    
    safeButton(GrabTab, "💥 TACAR", function() -- código original do tacar
        if not grabbedVehicle then return end
        local primary = grabbedVehicle:FindFirstChild("PrimaryPart") or grabbedVehicle:FindFirstChildWhichIsA("BasePart")
        if primary then
            pcall(function()
                if vehicleAlign then vehicleAlign:Destroy() end
                if vehicleVel then vehicleVel:Destroy() end
                if vehicleGyro then vehicleGyro:Destroy() end
            end)
            local throwDir = Camera.CFrame.LookVector * 300 + Vector3.new(0, 50, 0)
            pcall(function()
                primary:ApplyImpulse(throwDir * primary:GetMass())
                local randomTorque = Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000))
                primary:ApplyAngularImpulse(randomTorque * primary:GetMass() * 0.1)
            end)
        end
        grabbedVehicle = nil
    end)
    
    safeToggle(ConfigTab, "Anti Live", false, function(v) antiLive = v end)
    
    function parseColor(input) -- função original
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end
    
    -- ==================== FLY NATURAL (CFrame suave) ====================
    local function flyStep()
        if not flyEnabled then return end
        local char = Player.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not root or not hum then return end
        
        hum.PlatformStand = true
        hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        
        local moveDir = Vector3.zero
        local camLook = Camera.CFrame.LookVector
        local camRight = Camera.CFrame.RightVector
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camLook * Vector3.new(1,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camLook * Vector3.new(1,0,1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir -= Vector3.new(0,1,0) end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * (flySpeed * 0.18)
            root.CFrame = root.CFrame:Lerp(root.CFrame + moveDir, 0.4)
        end
    end
    
    -- Funções adicionais (Auto Essência e Lockpick)
    local function autoEssenciaStep()
        if not autoEssencia then return end
        local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("essencia") or obj.Name:lower():find("essence") or obj.Name:lower():find("essência") then
                if (obj.Position - root.Position).Magnitude < 45 then
                    root.CFrame = CFrame.new(obj.Position + Vector3.new(0,4,0))
                    task.wait(0.35)
                    break
                end
            end
        end
    end
    
    local function autoLockpickStep()
        if not autoLockpickEnabled then return end
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v.Name:lower():find("lockpick") or v.Name:lower():find("lock") then
                pcall(function()
                    if v:FindFirstChild("Lockpick") then
                        v.Lockpick:FireServer()
                    end
                end)
            end
        end
    end
    
    -- Loop principal (tudo dentro de pcall)
    RunService.RenderStepped:Connect(function()
        pcall(function()
            -- Coloque aqui todas as funções do task.spawn original (aimbotStep, updateESP, etc.)
            -- Por brevidade, assuma que você colou elas aqui. O importante é:
            if flyEnabled then flyStep() end
            if autoEssencia then autoEssenciaStep() end
            if autoLockpickEnabled then autoLockpickStep() end
            -- speedStep, farmStep, reachStep, etc.
        end)
    end)
    
    -- Limpeza
    script.Destroying:Connect(function()
        pcall(function() game:GetService("LogService"):Clear() end)
    end)
end

mostrarLogin()
