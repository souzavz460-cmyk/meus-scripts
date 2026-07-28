-- ============================================================
-- S4ZX HUB v2.9 FINAL - KAVO UI + LOGIN (3000 LINHAS)
-- ============================================================
-- Script desenvolvido para Roblox
-- Utilize a key de dono: S4zx-DonoSupreme2026
-- ============================================================

-- Inicialização
print("[S4ZX] Iniciando script...")
task.wait()

-- ========== SEGURANÇA ==========
-- URLs e constantes do sistema de licenciamento
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2026"

-- Função para obter o HWID (identificador da máquina)
local function getHWID()
    -- Tenta obter pelo AnalyticsService (mais confiável)
    local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if ok and id then return id end
    
    -- Fallback para o IP externo
    ok, id = pcall(function() return game:HttpGet("https://api.ipify.org") end)
    return ok and id or "UNKNOWN"
end

-- HWID do jogador atual
local HWID = getHWID()

-- Flag de segurança para evitar adulteração do script
local SECURITY_FLAG = "S4zx_INTEGRO_2026"

-- Função de destruição do script (kick e loop infinito)
local function destruirScript(motivo)
    pcall(function()
        if game.CoreGui:FindFirstChild("S4ZX_Login") then
            game.CoreGui.S4ZX_Login:Destroy()
        end
        if game.CoreGui:FindFirstChild("S4ZX_Hub_v25") then
            game.CoreGui.S4ZX_Hub_v25:Destroy()
        end
    end)
    game.Players.LocalPlayer:Kick(motivo or "Script encerrado")
    while true do end -- trava o script
end

-- ============================================================
-- TELA DE LOGIN
-- ============================================================
local function mostrarLogin()
    -- Pequena pausa para garantir que o CoreGui esteja pronto
    task.wait(0.5)
    
    -- Verificação de integridade
    if not SECURITY_FLAG or SECURITY_FLAG ~= "S4zx_INTEGRO_2026" then
        destruirScript("Script adulterado")
        return
    end

    -- Criação da ScreenGui para o login
    local loginGui = Instance.new("ScreenGui")
    loginGui.Name = "S4ZX_Login"
    loginGui.Parent = game.CoreGui
    loginGui.ResetOnSpawn = false

    -- Frame principal da tela de login
    local frame = Instance.new("Frame", loginGui)
    frame.Size = UDim2.new(0, 300, 0, 230)
    frame.Position = UDim2.new(0.5, -150, 0.5, -115)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(220, 30, 30)

    -- Logo "S4ZX"
    local logoText = Instance.new("TextLabel", frame)
    logoText.Size = UDim2.new(0, 120, 0, 35)
    logoText.Position = UDim2.new(0.5, -60, 0, 10)
    logoText.BackgroundTransparency = 1
    logoText.Text = "S4ZX"
    logoText.TextColor3 = Color3.fromRGB(255,255,255)
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize = 20

    -- Título "S4ZX HUB - LOGIN"
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "S4ZX HUB - LOGIN"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18

    -- Caixa de texto para a key
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(1, -40, 0, 35)
    input.Position = UDim2.new(0, 20, 0, 80)
    input.PlaceholderText = "Cole sua key aqui..."
    input.TextColor3 = Color3.new(1,1,1)
    input.BackgroundColor3 = Color3.fromRGB(25,25,25)
    input.Font = Enum.Font.SourceSans
    input.TextSize = 14
    input.ClearTextOnFocus = false
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 5)

    -- Label de status (feedback)
    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0, 125)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.new(1,1,1)
    status.Font = Enum.Font.SourceSans
    status.TextSize = 13

    -- Botão "ENTRAR"
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -40, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, 150)
    btn.Text = "ENTRAR"
    btn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    -- Botão de fechar (X)
    local closeBtn = Instance.new("TextButton", frame)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)
    closeBtn.MouseButton1Click:Connect(function()
        loginGui:Destroy()
    end)

    -- Função de tentativa de login
    local function tentarLogin()
        local key = input.Text:gsub("%s+", "") -- remove espaços extras
        if key == "" then
            status.Text = "Digite uma key"
            status.TextColor3 = Color3.fromRGB(255,200,0)
            return
        end
        
        -- Verificação da key do dono (master key)
        if key == DONO_KEY then
            status.Text = "✅ Key do Dono"
            status.TextColor3 = Color3.fromRGB(0,255,100)
            task.wait(1)
            loginGui:Destroy()
            carregarHub()
            return
        end
        
        -- Atualiza botão para "VERIFICANDO..."
        btn.Text = "VERIFICANDO..."
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        
        -- Tenta carregar a lista de keys do servidor
        local ok, json = pcall(function() return game:HttpGet(KEYS_URL) end)
        if ok and json and json ~= "" then
            local keys = {}
            pcall(function() keys = game:GetService("HttpService"):JSONDecode(json) end)
            local data = keys[key]
            
            if data then
                -- Key banida?
                if data.bloqueado then
                    status.Text = "⛔ Key banida!"
                    status.TextColor3 = Color3.fromRGB(255,0,0)
                -- HWID não autorizado?
                elseif data.hwid and data.hwid ~= "" and data.hwid ~= HWID then
                    status.Text = "❌ HWID não autorizado"
                    status.TextColor3 = Color3.fromRGB(255,0,0)
                else
                    -- Key vitalícia
                    if data.dias == "perm" then
                        status.Text = "✅ Key permanente"
                        status.TextColor3 = Color3.fromRGB(0,255,100)
                        task.wait(1)
                        loginGui:Destroy()
                        carregarHub()
                        return
                    else
                        -- Key com validade (dias)
                        local dia, mes, ano = data.criada:match("(%d+)/(%d+)/(%d+)")
                        if dia then
                            local criada = os.time({year=tonumber(ano), month=tonumber(mes), day=tonumber(dia)})
                            local expira = criada + (tonumber(data.dias) * 86400)
                            if os.time() <= expira then
                                local diasRestantes = math.ceil((expira - os.time()) / 86400)
                                status.Text = "✅ Key válida! Dias: " .. diasRestantes
                                status.TextColor3 = Color3.fromRGB(0,255,100)
                                task.wait(1)
                                loginGui:Destroy()
                                carregarHub()
                                return
                            else
                                status.Text = "❌ Key expirada"
                                status.TextColor3 = Color3.fromRGB(255,50,50)
                            end
                        end
                    end
                end
            else
                status.Text = "❌ Key inválida"
                status.TextColor3 = Color3.fromRGB(255,50,50)
            end
        else
            status.Text = "❌ Erro de conexão"
            status.TextColor3 = Color3.fromRGB(255,50,50)
        end
        
        -- Restaura o botão
        btn.Text = "ENTRAR"
        btn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    end

    -- Conexões dos botões
    btn.MouseButton1Click:Connect(tentarLogin)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            tentarLogin()
        end
    end)
end

-- ============================================================
-- HUB PRINCIPAL COM KAVO UI
-- ============================================================
function carregarHub()
    -- Verificação de segurança novamente
    if not SECURITY_FLAG or SECURITY_FLAG ~= "S4zx_INTEGRO_2026" then
        destruirScript("Script adulterado")
        return
    end

    -- Serviços utilizados
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local VoiceChatService = game:GetService("VoiceChatService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    -- ============================================================
    -- VARIÁVEIS DE ESTADO
    -- Todas as configurações e flags do script ficam aqui
    -- ============================================================
    local state = {
        -- Aimbot
        aimbot = false,
        aimForce = 3,
        bypass = 5,
        fovRadius = 150,
        wallCheck = false,
        silentAim = false,
        magicBullet = false,
        aimbotLead = false,
        leadMultiplier = 1,
        aimPart = "Cabeça",
        aimPriority = "Distância",
        priorityName = "",

        -- Silent Aim Universal
        saTeamCheck = false,
        saVisibleCheck = false,
        saTargetPart = "HumanoidRootPart",
        saMethod = "Raycast",
        saHitChance = 100,
        saMousePrediction = false,
        saPredictionAmount = 0.165,
        saShowTarget = false,
        saFovVisible = false,
        saFovRadius = 130,

        -- ESP
        espEnabled = false,
        espBox = false,
        espNames = false,
        espWeapons = false,
        espTalking = false,
        espSkeleton = false,
        espAdmin = false,
        espAdminList = false,
        espLines = false,
        espDistance = false,
        espInfiniteDist = false,
        espNPCs = false,
        espVisible = false,
        espEnemyAim = false,
        textSize = 14,
        skeletonColor = Color3.fromRGB(255,105,180),
        boxColor = Color3.fromRGB(0,255,0),
        talkColor = Color3.fromRGB(255,255,255),

        -- Veículos
        waypoint = nil,
        superCarSpeed = false,
        superCarSpeedValue = 100,
        cloneCar = false,

        -- Visual
        fovCircle = false,
        fovRainbow = false,
        linhaDeMira = false,

        -- Movimento
        infJump = false,
        fly = false,
        flySpeed = 50,
        speedHack = false,
        speedValue = 60,
        ghostMode = false,
        derrubarPlayer = false,

        -- Farm
        autoFarm = false,
        farmSpeed = 50,
        autoEssencia = false,
        autoMicha = false,

        -- Armas
        reach = false,
        reachDist = 25,
        infiniteAmmo = false,
        autoReload = false,
        noRecoil = false,
        rapidFire = false,
        rapidFireDelay = 0.1,
        oneShot = false,
        armaColorida = false,
        rgbSpeed = 2,
        armaSize = 1,
        roubarP1 = false,
        roubarP2 = false,

        -- Carro
        flyCar = false,
        flyCarSpeed = 70,

        -- Extras
        antiAfk = false,
        antiStun = false,
        antiFire = false,
        autoRespawn = false,
        godMode = false,
        micGlobal = false,
        moneyHack = false,
        moneyValue = 100000,
        autoJob = false,
        selectedJob = nil,

        -- Config
        streamerMode = false,
        antiLive = false,
        shortcutsEnabled = true,
        menuKey = Enum.KeyCode.RightShift,

        -- Internos (controles de estado não visíveis)
        grabbedVehicle = nil,
        vehicleAlign = nil,
        vehicleVel = nil,
        vehicleGyro = nil,
        spectateTarget = nil,
        flyStartY = nil,
        flyCarBV = nil,
        flyCarBG = nil,
        flyCarTarget = nil,
        rapidFireTimer = 0,
        lastAfkTime = 0,
        lastEssencePick = 0,
        armasDetectadas = {},
        carClone = nil,
        moneyLoop = nil,
        jobLoop = nil,
    }

    -- Função auxiliar: verifica se um player é admin (pelo nome)
    local function isAdmin(player)
        if not player or not player.Name then return false end
        local name = player.Name:lower()
        local keywords = {"admin","mod","staff","owner","dev","gerente","helper","moderador"}
        for _, kw in ipairs(keywords) do
            if name:find(kw) then
                return true
            end
        end
        return false
    end

    -- Função auxiliar: converte posição 3D para 2D (viewport)
    local function worldToScreen(pos)
        local vec, onScreen = Camera:WorldToViewportPoint(pos)
        return Vector2.new(vec.X, vec.Y), onScreen
    end

    -- ============================================================
    -- INICIALIZAÇÃO DA INTERFACE KAVO
    -- ============================================================
    local Library = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"
    ))()
    
    -- Tema roxo personalizado
    local PurpleTheme = {
        SchemeColor = Color3.fromRGB(145, 70, 255),
        Background = Color3.fromRGB(16, 13, 22),
        Header = Color3.fromRGB(23, 18, 31),
        TextColor = Color3.fromRGB(245, 242, 255),
        ElementColor = Color3.fromRGB(31, 24, 43)
    }
    
    -- Criação da janela principal
    local Window = Library.CreateLib("S4zx Mod", PurpleTheme)

    -- ============================================================
    -- CRIAÇÃO DAS ABAS E PREENCHIMENTO DOS CALLBACKS
    -- Cada aba contém seções e elementos com as funções reais
    -- ============================================================

    -- ===================
    -- 🎯 AIMBOT
    -- ===================
    do
        local Tab = Window:NewTab("🎯 Aimbot")
        
        -- Seção Aimbot Principal
        local Aim = Tab:NewSection("Aimbot")
        Aim:NewToggle("AIMBOT", "", function(v) state.aimbot = v end)
        Aim:NewSlider("Força da Mira", "", 5, 1, 3, function(v) state.aimForce = v end)
        Aim:NewSlider("Bypass", "", 10, 1, 5, function(v) state.bypass = v end)
        Aim:NewSlider("FOV Raio", "", 500, 50, 150, function(v) state.fovRadius = v end)
        Aim:NewToggle("WALLCK", "", function(v) state.wallCheck = v end)
        Aim:NewToggle("Aimbot com Lead", "", function(v) state.aimbotLead = v end)
        Aim:NewSlider("Multiplicador de Lead", "", 5, 1, 1, function(v) state.leadMultiplier = v end)
        
        -- Dropdowns
        local aimPartDd = Aim:NewDropdown("Parte do Corpo", "",
            {"Cabeça", "Peito", "Perna", "Braço"},
            function(v) state.aimPart = v end
        )
        aimPartDd:Set("Cabeça")
        
        local aimPriorityDd = Aim:NewDropdown("Prioridade", "",
            {"Distância", "Saúde", "Visibilidade", "Nome Específico"},
            function(v) state.aimPriority = v end
        )
        aimPriorityDd:Set("Distância")
        
        -- Caixa de texto para nome prioritário
        Aim:NewTextBox("Nome Alvo Prioritário", "Digite o nome",
            function(text) state.priorityName = text end
        )

        -- Seção Silent Aim Universal
        local Silent = Tab:NewSection("Silent Aim")
        Silent:NewToggle("SILENT AIM", "", function(v) state.silentAim = v end)
        Silent:NewToggle("Magic Bullet", "", function(v) state.magicBullet = v end)
        Silent:NewToggle("Team Check (Silent)", "", function(v) state.saTeamCheck = v end)
        Silent:NewToggle("Visible Check (Silent)", "", function(v) state.saVisibleCheck = v end)
        Silent:NewSlider("Hit Chance (%)", "", 100, 0, 100, function(v) state.saHitChance = v end)
        Silent:NewToggle("Predição (Silent)", "", function(v) state.saMousePrediction = v end)
        Silent:NewSlider("Predição Amount x0.001", "", 1000, 165, 165,
            function(v) state.saPredictionAmount = v/1000 end
        )
        Silent:NewDropdown("Método Silent", "",
            {"Raycast", "FindPartOnRay", "FindPartOnRayWithWhitelist",
             "FindPartOnRayWithIgnoreList", "Mouse.Hit/Target"},
            function(v) state.saMethod = v end
        )
        Silent:NewDropdown("Parte Alvo (Silent)", "",
            {"Head", "HumanoidRootPart", "Random"},
            function(v) state.saTargetPart = v end
        )
        Silent:NewToggle("Mostrar FOV Circle (Silent)", "", function(v) state.saFovVisible = v end)
        Silent:NewSlider("FOV Radius (Silent)", "", 360, 50, 130, function(v) state.saFovRadius = v end)
        Silent:NewToggle("Mostrar Alvo (Silent)", "", function(v) state.saShowTarget = v end)
    end

    -- ===================
    -- 👁️ ESP
    -- ===================
    do
        local Tab = Window:NewTab("👁️ ESP")
        local ESP = Tab:NewSection("ESP")
        
        -- Toggles do ESP
        ESP:NewToggle("Ativar ESP (Geral)", "", function(v) state.espEnabled = v end)
        ESP:NewToggle("Box", "", function(v) state.espBox = v end)
        ESP:NewToggle("Names", "", function(v) state.espNames = v end)
        ESP:NewToggle("Weapons", "", function(v) state.espWeapons = v end)
        ESP:NewToggle("Talking Icon", "", function(v) state.espTalking = v end)
        ESP:NewToggle("Skeleton", "", function(v) state.espSkeleton = v end)
        ESP:NewToggle("Admin ESP", "", function(v) state.espAdmin = v end)
        ESP:NewToggle("Admin List", "", function(v) state.espAdminList = v end)
        ESP:NewToggle("Lines", "", function(v) state.espLines = v end)
        ESP:NewToggle("Distance", "", function(v) state.espDistance = v end)
        ESP:NewToggle("Infinite Distance", "", function(v) state.espInfiniteDist = v end)
        ESP:NewToggle("Target NPCs", "", function(v) state.espNPCs = v end)
        ESP:NewToggle("Visible Check", "", function(v) state.espVisible = v end)
        ESP:NewToggle("ESP de Mira do Inimigo", "", function(v) state.espEnemyAim = v end)
        
        -- Slider do tamanho do texto
        ESP:NewSlider("Tamanho do Texto", "", 20, 12, 14, function(v) state.textSize = v end)
        
        -- Botões para cores aleatórias
        ESP:NewButton("Cor Esqueleto (Aleatória)", "", function()
            state.skeletonColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255))
        end)
        ESP:NewButton("Cor Box (Aleatória)", "", function()
            state.boxColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255))
        end)
        ESP:NewButton("Cor Ícone de Fala (Aleatória)", "", function()
            state.talkColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255))
        end)

        -- Seção de Jogadores (com dropdown dinâmico)
        local PlayersList = Tab:NewSection("Jogadores no Servidor")
        local playerDd = PlayersList:NewDropdown("Jogador", "", {}, function() end)
        
        -- Função para atualizar a lista de jogadores no dropdown
        local function updatePlayerDropdown()
            local names = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    table.insert(names, p.Name)
                end
            end
            playerDd:Refresh(names)
            if #names > 0 then
                playerDd:Set(names[1])
            end
        end
        
        -- Atualiza a lista ao abrir e ao entrar/sair jogadores
        updatePlayerDropdown()
        Players.PlayerAdded:Connect(updatePlayerDropdown)
        Players.PlayerRemoving:Connect(updatePlayerDropdown)

        -- Botões de ação para o jogador selecionado
        PlayersList:NewButton("🔄 Puxar", "", function()
            local name = playerDd:Get()
            if not name then return end
            local target = Players:FindFirstChild(name)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target.Character.HumanoidRootPart
                    local myRoot = myChar.HumanoidRootPart
                    -- Usa BodyVelocity para puxar o jogador
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bv.Velocity = (myRoot.Position - targetRoot.Position).Unit * 50
                    bv.Parent = targetRoot
                    game:GetService("Debris"):AddItem(bv, 1)
                    -- Se não estiver perto o suficiente, teleporta
                    task.wait(0.5)
                    if (targetRoot.Position - myRoot.Position).Magnitude > 10 then
                        targetRoot.CFrame = myRoot.CFrame + Vector3.new(0, 2, 0)
                    end
                end
            end
        end)
        
        PlayersList:NewButton("🚀 TP", "", function()
            local name = playerDd:Get()
            if not name then return end
            local target = Players:FindFirstChild(name)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end)
        
        PlayersList:NewButton("👁️ Spectate", "", function()
            local name = playerDd:Get()
            if not name then return end
            local target = Players:FindFirstChild(name)
            if target and target.Character then
                Camera.CameraSubject = target.Character
            end
        end)
    end

    -- ===================
    -- 🚗 VEÍCULOS
    -- ===================
    do
        local Tab = Window:NewTab("🚗 Veículos")
        local Vehicles = Tab:NewSection("Veículos")
        
        Vehicles:NewButton("Teleportar no Veículo Próximo", "", function()
            local char = LocalPlayer.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local nearest, nearestDist = nil, math.huge
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") then
                    local d = (v.Position - root.Position).Magnitude
                    if d < nearestDist then
                        nearestDist = d
                        nearest = v
                    end
                end
            end
            if nearest then
                root.CFrame = root.CFrame:Lerp(CFrame.new(nearest.Position + Vector3.new(0, 3, 0)), 0.5)
            end
        end)
        
        Vehicles:NewButton("Destrancar Veículo", "", function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") then
                    v:SetAttribute("Locked", false)
                    v.Locked = false
                end
            end
        end)
        
        Vehicles:NewButton("Trancar Veículo", "", function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") then
                    v:SetAttribute("Locked", true)
                    v.Locked = true
                end
            end
        end)
        
        Vehicles:NewButton("Marcar Waypoint", "", function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                state.waypoint = char.HumanoidRootPart.Position
            end
        end)
        
        Vehicles:NewButton("Teleportar Waypoint", "", function()
            if state.waypoint then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(state.waypoint + Vector3.new(0, 2, 0))
                end
            end
        end)
        
        Vehicles:NewToggle("Super Velocidade no Carro", "", function(v)
            state.superCarSpeed = v
        end)
        
        Vehicles:NewSlider("Velocidade Super Carro", "", 500, 50, 100, function(v)
            state.superCarSpeedValue = v
        end)
        
        Vehicles:NewToggle("Clonar Carro", "", function(v)
            state.cloneCar = v
            if v then
                local char = LocalPlayer.Character
                if not char then return end
                local seat = nil
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("VehicleSeat") and obj.Occupant == char.Humanoid then
                        seat = obj
                        break
                    end
                end
                if seat then
                    local carModel = seat:FindFirstAncestorOfClass("Model")
                    if carModel then
                        state.carClone = carModel:Clone()
                        state.carClone:SetPrimaryPartCFrame(carModel:GetPrimaryPartCFrame() + Vector3.new(5, 0, 0))
                        state.carClone.Parent = Workspace
                    end
                end
            end
        end)
    end

    -- ===================
    -- 🎨 VISUAL
    -- ===================
    do
        local Tab = Window:NewTab("🎨 Visual")
        local Visual = Tab:NewSection("Visual")
        
        Visual:NewButton("Cor Box (Verde)", "", function()
            state.boxColor = Color3.fromRGB(0,255,0)
        end)
        Visual:NewButton("Cor Esqueleto (Rosa)", "", function()
            state.skeletonColor = Color3.fromRGB(255,105,180)
        end)
        Visual:NewToggle("FOV Círculo", "", function(v) state.fovCircle = v end)
        Visual:NewToggle("FOV Arco-Íris", "", function(v) state.fovRainbow = v end)
        Visual:NewToggle("Rastro Bala (Linha de Tiro)", "", function(v) state.linhaDeMira = v end)
    end

    -- ===================
    -- 🏃 MOVIMENTO
    -- ===================
    do
        local Tab = Window:NewTab("🏃 Movimento")
        local Movement = Tab:NewSection("Movimento")
        
        Movement:NewToggle("Pulo Infinito", "", function(v) state.infJump = v end)
        Movement:NewToggle("Fly Avançado (WASD/E/Q)", "", function(v)
            state.fly = v
            if not v then state.flyStartY = nil end
        end)
        Movement:NewSlider("Velocidade Fly", "", 200, 20, 50, function(v) state.flySpeed = v end)
        Movement:NewToggle("Speed Hack", "", function(v) state.speedHack = v end)
        Movement:NewSlider("Velocidade Speed", "", 200, 16, 60, function(v) state.speedValue = v end)
        Movement:NewToggle("Ghost Mode", "", function(v) state.ghostMode = v end)
        Movement:NewToggle("Derrubar Player", "", function(v) state.derrubarPlayer = v end)
    end

    -- ===================
    -- 🌾 FARM
    -- ===================
    do
        local Tab = Window:NewTab("🌾 Farm")
        local Farm = Tab:NewSection("Farm")
        
        Farm:NewToggle("Auto Farm Lixo", "", function(v) state.autoFarm = v end)
        Farm:NewSlider("Velocidade Farm", "", 100, 30, 50, function(v) state.farmSpeed = v end)
        Farm:NewToggle("Auto Essência", "", function(v) state.autoEssencia = v end)
        Farm:NewToggle("Auto Micha", "", function(v) state.autoMicha = v end)
    end

    -- ===================
    -- 🔪 ARMAS
    -- ===================
    do
        local Tab = Window:NewTab("🔪 Armas")
        local Weapons = Tab:NewSection("Armas")
        
        Weapons:NewToggle("Reach", "", function(v) state.reach = v end)
        Weapons:NewSlider("Distância Reach", "", 50, 10, 25, function(v) state.reachDist = v end)
        Weapons:NewToggle("Infinite Ammo", "", function(v) state.infiniteAmmo = v end)
        Weapons:NewToggle("Auto Reload", "", function(v) state.autoReload = v end)
        Weapons:NewToggle("No Recoil", "", function(v) state.noRecoil = v end)
        Weapons:NewToggle("Rapid Fire", "", function(v) state.rapidFire = v end)
        Weapons:NewSlider("Rapid Fire Delay x0.01", "", 50, 5, 10, function(v) state.rapidFireDelay = v/100 end)
        Weapons:NewToggle("Matar com 1 Tiro", "", function(v) state.oneShot = v end)
        Weapons:NewToggle("Arma Colorida (RGB)", "", function(v) state.armaColorida = v end)
        Weapons:NewSlider("Velocidade RGB x0.1", "", 50, 5, 20, function(v) state.rgbSpeed = v/10 end)
        Weapons:NewSlider("Tamanho da Arma x0.1", "", 50, 5, 10, function(v) state.armaSize = v/10 end)
        Weapons:NewToggle("Roubar P1", "", function(v) state.roubarP1 = v end)
        Weapons:NewToggle("Roubar P2", "", function(v) state.roubarP2 = v end)
        
        Weapons:NewButton("🔄 Atualizar Armas Detectadas", "", function()
            updateFakeWeapons()
        end)

        -- Seção de Armas Falsas (dinâmica)
        local FakeWeapons = Tab:NewSection("Armas Falsas")
        local fakeWeaponDd = FakeWeapons:NewDropdown("Arma Falsa", "", {}, function() end)
        
        -- Função para detectar armas no jogo
        local function detectWeapons()
            local list = {}
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Tool") and obj.Name ~= "" then
                    table.insert(list, obj.Name)
                end
            end
            for _, c in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
                if c then
                    for _, obj in ipairs(c:GetChildren()) do
                        if obj:IsA("Tool") then
                            table.insert(list, obj.Name)
                        end
                    end
                end
            end
            -- Remove duplicatas
            local unique = {}
            local result = {}
            for _, n in ipairs(list) do
                if not unique[n] then
                    unique[n] = true
                    table.insert(result, n)
                end
            end
            return result
        end
        
        -- Atualiza dropdown de armas falsas
        function updateFakeWeapons()
            local weps = detectWeapons()
            fakeWeaponDd:Refresh(weps)
            if #weps > 0 then
                fakeWeaponDd:Set(weps[1])
            end
        end
        updateFakeWeapons()
        
        -- Botão para criar arma fake
        FakeWeapons:NewButton("Criar Fake", "", function()
            local name = fakeWeaponDd:Get()
            if not name then return end
            
            local tool = Instance.new("Tool")
            tool.Name = name .. "_Fake"
            tool.RequiresHandle = true
            tool.CanBeDropped = false
            tool.Parent = LocalPlayer.Backpack
            
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(0.5, 0.1, 0.2)
            handle.Color = Color3.fromRGB(200,200,200)
            handle.Material = Enum.Material.SmoothPlastic
            handle.Anchored = false
            handle.CanCollide = false
            handle.Locked = true
            handle.Transparency = 0.2
            handle.Parent = tool
            
            local glow = Instance.new("SelectionBox")
            glow.Adornee = handle
            glow.Color3 = Color3.fromRGB(0,255,255)
            glow.LineThickness = 0.1
            glow.Transparency = 0.5
            glow.Parent = handle
            
            tool.Parent = LocalPlayer.Character
        end)
    end

    -- ===================
    -- 🏎️ CARRO
    -- ===================
    do
        local Tab = Window:NewTab("🏎️ Carro")
        local Car = Tab:NewSection("Carro")
        
        Car:NewToggle("Fly Car", "", function(v) state.flyCar = v end)
        Car:NewSlider("Velocidade Fly Car", "", 200, 20, 70, function(v) state.flyCarSpeed = v end)
    end

    -- ===================
    -- 🛠️ EXTRAS
    -- ===================
    do
        local Tab = Window:NewTab("🛠️ Extras")
        local Extras = Tab:NewSection("Extras")
        
        Extras:NewToggle("Anti AFK", "", function(v) state.antiAfk = v end)
        Extras:NewToggle("Anti Stun", "", function(v) state.antiStun = v end)
        Extras:NewToggle("Anti Fire", "", function(v) state.antiFire = v end)
        Extras:NewToggle("Auto Respawn", "", function(v) state.autoRespawn = v end)
        Extras:NewToggle("God Mode", "", function(v) state.godMode = v end)
        
        Extras:NewToggle("🎙️ Microfone Global", "", function(v)
            state.micGlobal = v
            if v then
                if VoiceChatService and VoiceChatService:IsEnabled() then
                    VoiceChatService:SetVoiceEnabled(true)
                    VoiceChatService:SetOutputVolume(100)
                    VoiceChatService:SetInputVolume(100)
                    pcall(function()
                        VoiceChatService:SetSpatialVoiceEnabled(false)
                    end)
                end
            else
                if VoiceChatService then
                    VoiceChatService:SetVoiceEnabled(false)
                    pcall(function()
                        VoiceChatService:SetSpatialVoiceEnabled(true)
                    end)
                end
            end
        end)
        
        -- Money Hack
        Extras:NewToggle("Money Hack (Auto)", "", function(v)
            state.moneyHack = v
            if v then
                state.moneyLoop = task.spawn(function()
                    while state.moneyHack do
                        task.wait(0.5)
                        local args = {[1] = "GiveCash", [2] = state.moneyValue}
                        pcall(function()
                            game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FireServer(unpack(args))
                        end)
                    end
                end)
            else
                if state.moneyLoop then
                    task.cancel(state.moneyLoop)
                end
            end
        end)
        
        Extras:NewSlider("Valor do Dinheiro", "", 9999999, 1000, 100000, function(v)
            state.moneyValue = v
        end)

        -- Empregos Detectados (dinâmico)
        local Jobs = Tab:NewSection("💼 Empregos Detectados")
        local jobsDd = Jobs:NewDropdown("Emprego", "", {}, function() end)
        
        local function detectJobs()
            local list = {}
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    local name = obj.Parent and obj.Parent.Name
                    if name and name ~= "" then
                        table.insert(list, name)
                    end
                end
            end
            local unique = {}
            local result = {}
            for _, n in ipairs(list) do
                if not unique[n] then
                    unique[n] = true
                    table.insert(result, n)
                end
            end
            return result
        end
        
        local function updateJobs()
            local j = detectJobs()
            jobsDd:Refresh(j)
            if #j > 0 then jobsDd:Set(j[1]) end
        end
        updateJobs()
        
        Jobs:NewButton("🔄 Atualizar Empregos", "", updateJobs)
        Jobs:NewButton("Pegar Emprego", "", function()
            local nome = jobsDd:Get()
            if not nome then return end
            state.autoJob = true
            state.selectedJob = nome
            if state.jobLoop then task.cancel(state.jobLoop) end
            state.jobLoop = task.spawn(function()
                while state.autoJob do
                    task.wait(0.1)
                    local char = LocalPlayer.Character
                    if not char then break end
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if not root then break end
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and obj.Enabled and obj.Parent and obj.Parent.Name == state.selectedJob then
                            local pos = obj.Parent:GetPivot().Position
                            root.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
                            task.wait(0.2)
                            pcall(function() fireproximityprompt(obj) end)
                            break
                        end
                    end
                end
            end)
        end)

        -- Seção de ações com veículo (Raycast)
        local VehicleActions = Tab:NewSection("Veículo")
        VehicleActions:NewButton("🖐️ PEGAR Veículo (Raycast)", "", function()
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            local result = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 100, rayParams)
            if result then
                local hit = result.Instance
                local car = hit:FindFirstAncestorOfClass("Model")
                if car and (car:FindFirstChildWhichIsA("VehicleSeat") or car:FindFirstChildWhichIsA("Seat")) then
                    if state.grabbedVehicle then
                        pcall(function()
                            if state.vehicleAlign then state.vehicleAlign:Destroy() end
                            if state.vehicleVel then state.vehicleVel:Destroy() end
                            if state.vehicleGyro then state.vehicleGyro:Destroy() end
                        end)
                        state.grabbedVehicle = nil
                    end
                    state.grabbedVehicle = car
                    local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                    if primary then
                        state.vehicleAlign = Instance.new("AlignPosition")
                        state.vehicleAlign.MaxForce = 9999999
                        state.vehicleAlign.Responsiveness = 200
                        state.vehicleAlign.Attachment0 = primary:FindFirstChild("AlignAttachment") or Instance.new("Attachment", primary)
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local root = char.HumanoidRootPart
                            local attach = root:FindFirstChild("GrabAttach") or Instance.new("Attachment", root)
                            attach.Name = "GrabAttach"
                            state.vehicleAlign.Attachment1 = attach
                        end
                        state.vehicleAlign.Parent = primary
                        state.vehicleVel = Instance.new("LinearVelocity")
                        state.vehicleVel.MaxForce = 9999999
                        state.vehicleVel.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
                        state.vehicleVel.Attachment0 = primary:FindFirstChild("VelAttachment") or Instance.new("Attachment", primary)
                        state.vehicleVel.Parent = primary
                        state.vehicleGyro = Instance.new("AngularVelocity")
                        state.vehicleGyro.MaxTorque = 9999999
                        state.vehicleGyro.AngularVelocity = Vector3.new(0,0,0)
                        state.vehicleGyro.Attachment0 = primary:FindFirstChild("GyroAttachment") or Instance.new("Attachment", primary)
                        state.vehicleGyro.Parent = primary
                    end
                end
            end
        end)
        
        VehicleActions:NewButton("💥 TACAR Veículo Segurado", "", function()
            if not state.grabbedVehicle then return end
            local primary = state.grabbedVehicle:FindFirstChild("PrimaryPart") or state.grabbedVehicle:FindFirstChildWhichIsA("BasePart")
            if primary then
                pcall(function()
                    if state.vehicleAlign then state.vehicleAlign:Destroy() end
                    if state.vehicleVel then state.vehicleVel:Destroy() end
                    if state.vehicleGyro then state.vehicleGyro:Destroy() end
                end)
                local throwDir = Camera.CFrame.LookVector * 300 + Vector3.new(0, 50, 0)
                pcall(function()
                    primary:ApplyImpulse(throwDir * primary:GetMass())
                    local randomTorque = Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000))
                    primary:ApplyAngularImpulse(randomTorque * primary:GetMass() * 0.1)
                end)
            end
            state.grabbedVehicle = nil
        end)
    end

    -- ===================
    -- ⚙️ CONFIG
    -- ===================
    do
        local Tab = Window:NewTab("⚙️ Config")
        local Config = Tab:NewSection("Configurações")
        
        Config:NewToggle("Modo Streamer", "", function(v)
            state.streamerMode = v
            if v then
                Library:ToggleUI()
            end
        end)
        Config:NewToggle("Anti Live", "", function(v) state.antiLive = v end)
        Config:NewToggle("Atalhos Rápidos (CTRL+1 a 0)", "", function(v)
            state.shortcutsEnabled = v
        end)
        
        Config:NewKeybind("Atalho de Ocultar Menu (PC)", "RightShift",
            Enum.KeyCode.RightShift,
            function()
                Library:ToggleUI()
            end
        )
    end

    -- ===================
    -- 🔒 SEGURANÇA
    -- ===================
    do
        local Tab = Window:NewTab("🔒 Segurança")
        local Security = Tab:NewSection("Status")
        
        Security:NewLabel("🔑 Status Key: AUTENTICADO")
        Security:NewLabel("🚫 Blacklist: LIMPO")
        Security:NewLabel("💻 HWID Verificado: OK")
        Security:NewLabel("🛡️ Anti-Adulteração: ATIVO")
        Security:NewLabel("🔄 Checagem Remota: ONLINE (5m)")
    end

    -- ============================================================
    -- CONTADOR DE STAFF (flutuante na tela)
    -- ============================================================
    task.delay(1, function()
        local staffGui = Instance.new("ScreenGui", game.CoreGui)
        staffGui.Name = "StaffCounter"
        staffGui.ResetOnSpawn = false
        
        local staffFrame = Instance.new("TextLabel", staffGui)
        staffFrame.Size = UDim2.new(0, 120, 0, 30)
        staffFrame.Position = UDim2.new(0.85, -60, 0.05, 0)
        staffFrame.BackgroundColor3 = Color3.new(0,0,0)
        staffFrame.BackgroundTransparency = 0.5
        staffFrame.Text = "👑 Staff: 0"
        staffFrame.TextColor3 = Color3.new(0,1,0)
        staffFrame.Font = Enum.Font.GothamBold
        staffFrame.TextSize = 14
        Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0,4)
        
        -- Atualiza contagem periodicamente
        task.spawn(function()
            while true do
                task.wait(1)
                local count = 0
                for _, p in ipairs(Players:GetPlayers()) do
                    if isAdmin(p) then
                        count = count + 1
                    end
                end
                staffFrame.Text = "👑 Staff: " .. count
            end
        end)
    end)

    -- ============================================================
    -- ATALHOS RÁPIDOS (CTRL+1 a 0)
    -- ============================================================
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if state.shortcutsEnabled and input.KeyCode >= Enum.KeyCode.One and input.KeyCode <= Enum.KeyCode.Zero then
                local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                if ctrl then
                    local map = {
                        [Enum.KeyCode.One]   = function() state.aimbot = not state.aimbot end,
                        [Enum.KeyCode.Two]   = function() state.silentAim = not state.silentAim end,
                        [Enum.KeyCode.Three] = function() state.espEnabled = not state.espEnabled end,
                        [Enum.KeyCode.Four]  = function() state.fly = not state.fly end,
                        [Enum.KeyCode.Five]  = function() state.speedHack = not state.speedHack end,
                        [Enum.KeyCode.Six]   = function() state.godMode = not state.godMode end,
                        [Enum.KeyCode.Seven] = function() state.reach = not state.reach end,
                        [Enum.KeyCode.Eight] = function() state.rapidFire = not state.rapidFire end,
                        [Enum.KeyCode.Nine]  = function() state.autoFarm = not state.autoFarm end,
                        [Enum.KeyCode.Zero]  = function() state.antiAfk = not state.antiAfk end,
                    }
                    if map[input.KeyCode] then
                        map[input.KeyCode]()
                    end
                end
            end
        end
    end)

    -- ============================================================
    -- ESP (DESENHO COM DRAWING)
    -- ============================================================
    local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
    local espObjects = {}
    local fovCircleObj = nil

    local function clearESPObjects()
        for _, obj in ipairs(espObjects) do
            if useDrawing then
                pcall(function() obj:Remove() end)
            else
                pcall(function() obj:Destroy() end)
            end
        end
        espObjects = {}
    end

    local function createESPObject(kind, props)
        if useDrawing then
            local obj = Drawing.new(kind)
            obj.Visible = true
            for k, v in pairs(props) do
                obj[k] = v
            end
            table.insert(espObjects, obj)
            return obj
        end
        return nil
    end

    -- Loop principal do ESP
    task.spawn(function()
        while true do
            task.wait(0.05)
            if not state.espEnabled then
                clearESPObjects()
                if fovCircleObj then
                    fovCircleObj.Visible = false
                end
                continue
            end

            clearESPObjects()
            local screenSize = Camera.ViewportSize
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targets = {}

            -- Adiciona jogadores
            for _, p in ipairs(Players:GetPlayers()) do
                if p == LocalPlayer then continue end
                local chr = p.Character
                if chr and chr:FindFirstChild("HumanoidRootPart") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
                    table.insert(targets, {player = p, char = chr})
                end
            end

            -- Adiciona NPCs se ativado
            if state.espNPCs then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        if obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 then
                            table.insert(targets, {player = obj, char = obj, isNPC = true})
                        end
                    end
                end
            end

            -- Lista de admins (se ativado)
            if state.espAdminList then
                local adminNames = {}
                for _, t in ipairs(targets) do
                    if not t.isNPC and isAdmin(t.player) then
                        table.insert(adminNames, t.player.Name)
                    end
                end
                if #adminNames > 0 then
                    createESPObject("Text", {
                        Position = Vector2.new(10, 10),
                        Text = "Admins: " .. table.concat(adminNames, ", "),
                        Color = Color3.new(1,0,0),
                        Size = 16,
                        Center = false
                    })
                end
            end

            -- Desenha cada alvo
            for _, target in ipairs(targets) do
                local char = target.char
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChild("Humanoid")
                if not root or not head or not hum or hum.Health <= 0 then continue end

                local isAdminTarget = (not target.isNPC and state.espAdmin and isAdmin(target.player))
                local headPos2D, headOn = worldToScreen(head.Position + Vector3.new(0, 1.5, 0))
                local rootPos2D, rootOn = worldToScreen(root.Position)
                local feetPos2D, feetOn = worldToScreen(root.Position - Vector3.new(0, 3, 0))

                if not headOn and not state.espInfiniteDist then continue end

                local isVisible = true
                if state.espVisible then
                    local params = RaycastParams.new()
                    params.FilterDescendantsInstances = {LocalPlayer.Character}
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = Workspace:Raycast(
                        Camera.CFrame.Position,
                        (head.Position - Camera.CFrame.Position).Unit * 1000,
                        params
                    )
                    if result and not result.Instance:IsDescendantOf(char) then
                        isVisible = false
                    end
                end

                local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                local weaponName = ""
                if state.espWeapons then
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool and tool.Name ~= "" then
                        weaponName = tool.Name
                    end
                end

                local color = isVisible and state.boxColor or Color3.fromRGB(150,150,150)
                if isAdminTarget then
                    color = Color3.fromRGB(255,0,0)
                end

                -- Desenha box
                if state.espBox and headOn and feetOn then
                    local bodyHeight = math.abs(headPos2D.Y - feetPos2D.Y)
                    local bodyWidth = bodyHeight * 0.45
                    local centerX = (headPos2D.X + feetPos2D.X) / 2
                    createESPObject("Square", {
                        Position = Vector2.new(centerX - bodyWidth/2, headPos2D.Y - bodyHeight*0.1),
                        Size = Vector2.new(bodyWidth, bodyHeight),
                        Color = color,
                        Thickness = 2,
                        Filled = false
                    })
                end

                -- Desenha esqueleto
                if state.espSkeleton then
                    local bones = {
                        {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
                        {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
                        {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
                        {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
                        {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"}
                    }
                    for _, pair in ipairs(bones) do
                        local a = char:FindFirstChild(pair[1])
                        local b = char:FindFirstChild(pair[2])
                        if a and b then
                            local aPos, aOn = worldToScreen(a.Position)
                            local bPos, bOn = worldToScreen(b.Position)
                            if aOn and bOn then
                                createESPObject("Line", {
                                    From = aPos,
                                    To = bPos,
                                    Color = state.skeletonColor,
                                    Thickness = 2
                                })
                            end
                        end
                    end
                end

                -- Nome
                if state.espNames and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X - 50, headPos2D.Y - 22),
                        Text = target.player.Name or "NPC",
                        Color = color,
                        Size = state.textSize,
                        Center = true
                    })
                end

                -- Arma
                if state.espWeapons and weaponName ~= "" and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X - 50, headPos2D.Y + 30),
                        Text = weaponName,
                        Color = Color3.new(1,1,0),
                        Size = 12,
                        Center = true
                    })
                end

                -- Distância
                if state.espDistance and myRoot and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X - 50, headPos2D.Y + 15),
                        Text = math.floor(dist) .. "m",
                        Color = Color3.new(1,1,1),
                        Size = 12,
                        Center = true
                    })
                end

                -- Tracer (linhas)
                if state.espLines and rootOn then
                    createESPObject("Line", {
                        From = Vector2.new(screenSize.X / 2, screenSize.Y),
                        To = rootPos2D,
                        Color = color,
                        Thickness = 1
                    })
                end

                -- Ícone de fala
                if state.espTalking and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X + 15, headPos2D.Y - 10),
                        Text = "🗣️",
                        Color = state.talkColor,
                        Size = 12,
                        Center = true
                    })
                end

                -- Mira do inimigo
                if state.espEnemyAim and not target.isNPC then
                    local playerHead = char:FindFirstChild("Head")
                    if playerHead then
                        local aimEnd = playerHead.Position + playerHead.CFrame.LookVector * 50
                        local aimEnd2D, onScreen = worldToScreen(aimEnd)
                        if onScreen then
                            local head2D, _ = worldToScreen(playerHead.Position)
                            createESPObject("Line", {
                                From = head2D,
                                To = aimEnd2D,
                                Color = Color3.fromRGB(255, 100, 100),
                                Thickness = 1
                            })
                        end
                    end
                end
            end

            -- Círculo FOV
            if state.fovCircle then
                if not fovCircleObj then
                    fovCircleObj = Drawing.new("Circle")
                    fovCircleObj.Visible = true
                    fovCircleObj.Thickness = 2
                    fovCircleObj.Filled = false
                end
                fovCircleObj.Position = screenSize / 2
                fovCircleObj.Radius = state.fovRadius
                fovCircleObj.Visible = true
                if state.fovRainbow then
                    fovCircleObj.Color = Color3.fromHSV(tick() % 1, 1, 1)
                else
                    fovCircleObj.Color = Color3.new(1,1,1)
                end
            elseif fovCircleObj then
                fovCircleObj.Visible = false
            end
        end
    end)

    -- ============================================================
    -- LASER (LINHA DE TIRO)
    -- ============================================================
    local laserLine = nil
    task.spawn(function()
        while true do
            task.wait(0.03)
            if not state.linhaDeMira then
                if laserLine then
                    if useDrawing then laserLine:Remove() else laserLine:Destroy() end
                    laserLine = nil
                end
                continue
            end

            local char = LocalPlayer.Character
            if not char then continue end
            local tool = char:FindFirstChildWhichIsA("Tool")
            if not tool then continue end
            local handle = tool:FindFirstChild("Handle")
            if not handle then continue end

            local origin = handle.Position
            local direction = Camera.CFrame.LookVector * 500
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {char}
            params.FilterType = Enum.RaycastFilterType.Blacklist
            local result = Workspace:Raycast(origin, direction, params)
            local targetPos = result and result.Position or (origin + direction)

            if useDrawing then
                if not laserLine then
                    laserLine = Drawing.new("Line")
                    laserLine.Thickness = 2
                    laserLine.Color = Color3.fromRGB(255,255,255)
                    laserLine.Transparency = 0.8
                    laserLine.Visible = true
                end
                local oS, oO = worldToScreen(origin)
                local tS, tO = worldToScreen(targetPos)
                if oO and tO then
                    laserLine.From = oS
                    laserLine.To = tS
                    laserLine.Visible = true
                else
                    laserLine.Visible = false
                end
            end
        end
    end)

    -- ============================================================
    -- AIMBOT TRADICIONAL + LEAD
    -- ============================================================
    local function getAimPart(char, partName)
        local map = {
            Cabeça = "Head",
            Peito = "UpperTorso",
            Perna = "LeftLowerLeg",
            Braço = "RightLowerArm"
        }
        return char:FindFirstChild(map[partName] or "Head")
    end

    task.spawn(function()
        while true do
            task.wait()
            if state.aimbot then
                local best, bestScore = nil, math.huge
                local center = Camera.ViewportSize / 2

                for _, p in ipairs(Players:GetPlayers()) do
                    if p == LocalPlayer then continue end
                    local chr = p.Character
                    if not chr then continue end
                    local hum = chr:FindFirstChild("Humanoid")
                    if not hum or hum.Health <= 0 then continue end

                    -- Verificação de parede
                    if state.wallCheck then
                        local head = chr:FindFirstChild("Head")
                        if head then
                            local params = RaycastParams.new()
                            params.FilterDescendantsInstances = {LocalPlayer.Character}
                            params.FilterType = Enum.RaycastFilterType.Blacklist
                            local rayResult = Workspace:Raycast(
                                Camera.CFrame.Position,
                                (head.Position - Camera.CFrame.Position).Unit * 1000,
                                params
                            )
                            if rayResult and not rayResult.Instance:IsDescendantOf(chr) then
                                continue
                            end
                        end
                    end

                    local aimPart = getAimPart(chr, state.aimPart)
                    if not aimPart then continue end
                    local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                    if not onScreen then continue end

                    -- Cálculo de prioridade
                    local score = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if state.aimPriority == "Saúde" then
                        score = hum.Health
                    elseif state.aimPriority == "Visibilidade" then
                        local head = chr:FindFirstChild("Head")
                        if head then
                            local visible = #Camera:GetPartsObscuringTarget(
                                {head.Position, LocalPlayer.Character},
                                {LocalPlayer.Character}
                            ) == 0
                            score = visible and 0 or 1
                        end
                    elseif state.aimPriority == "Nome Específico" and state.priorityName ~= "" then
                        score = p.Name:lower():find(state.priorityName:lower()) and 0 or 1
                    end

                    if score < bestScore then
                        bestScore = score
                        best = chr
                    end
                end

                if best then
                    local aimPart = getAimPart(best, state.aimPart)
                    if aimPart then
                        local targetPos = aimPart.Position
                        if state.aimbotLead and aimPart.Velocity then
                            targetPos = targetPos + aimPart.Velocity * state.leadMultiplier * 0.05
                        end
                        local alpha = 0.02 + (state.aimForce - 1) * 0.245
                        local newCF = CFrame.new(Camera.CFrame.Position, targetPos)
                        Camera.CFrame = alpha >= 1 and newCF or Camera.CFrame:Lerp(newCF, alpha)
                    end
                end
            end
        end
    end)

    -- ============================================================
    -- SILENT AIM UNIVERSAL (HOOK)
    -- ============================================================
    local ValidTargetParts = {"Head", "HumanoidRootPart"}

    local function isPlayerVisibleSA(player)
        local char = player.Character
        if not char then return false end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        return #Camera:GetPartsObscuringTarget(
            {root.Position, LocalPlayer.Character, char},
            {LocalPlayer.Character, char}
        ) == 0
    end

    local function getClosestPlayerSA()
        local closest, closestDist = nil, state.saFovRadius
        local mousePos = UserInputService:GetMouseLocation()

        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if state.saTeamCheck and player.Team == LocalPlayer.Team then continue end
            local char = player.Character
            if not char then continue end
            local hum = char:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then continue end
            if state.saVisibleCheck and not isPlayerVisibleSA(player) then continue end

            local part
            if state.saTargetPart == "Random" then
                part = char[ValidTargetParts[math.random(#ValidTargetParts)]]
            else
                part = char:FindFirstChild(state.saTargetPart)
            end
            if not part then continue end

            local screenPos, onScreen = worldToScreen(part.Position)
            if not onScreen then continue end

            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = part
            end
        end
        return closest
    end

    -- Indicadores visuais do Silent Aim
    if useDrawing then
        local mouse_box = Drawing.new("Square")
        mouse_box.Visible = false
        mouse_box.ZIndex = 999
        mouse_box.Thickness = 20
        mouse_box.Size = Vector2.new(20,20)
        mouse_box.Filled = true

        local sa_fov_circle = Drawing.new("Circle")
        sa_fov_circle.Thickness = 1
        sa_fov_circle.NumSides = 100
        sa_fov_circle.Filled = false
        sa_fov_circle.Visible = false
        sa_fov_circle.ZIndex = 999

        task.spawn(function()
            while true do
                task.wait()
                if state.silentAim then
                    sa_fov_circle.Visible = state.saFovVisible
                    sa_fov_circle.Radius = state.saFovRadius
                    sa_fov_circle.Position = UserInputService:GetMouseLocation()

                    if state.saShowTarget then
                        local target = getClosestPlayerSA()
                        if target then
                            local screenPos, onScreen = worldToScreen(target.Position)
                            if onScreen then
                                mouse_box.Visible = true
                                mouse_box.Position = Vector2.new(screenPos.X, screenPos.Y)
                            else
                                mouse_box.Visible = false
                            end
                        else
                            mouse_box.Visible = false
                        end
                    else
                        mouse_box.Visible = false
                    end
                else
                    sa_fov_circle.Visible = false
                    mouse_box.Visible = false
                end
            end
        end)
    end

    -- Hook __namecall para Silent Aim
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        local self = args[1]

        if state.silentAim and self == workspace and not checkcaller() and math.random(1,100) <= state.saHitChance then
            local hitPart = getClosestPlayerSA()
            if hitPart then
                if method == "FindPartOnRayWithIgnoreList" and state.saMethod == method then
                    args[2] = Ray.new(args[2].Origin, (hitPart.Position - args[2].Origin).Unit * 1000)
                    return oldNamecall(unpack(args))
                elseif method == "FindPartOnRayWithWhitelist" and state.saMethod == method then
                    args[2] = Ray.new(args[2].Origin, (hitPart.Position - args[2].Origin).Unit * 1000)
                    return oldNamecall(unpack(args))
                elseif method == "FindPartOnRay" and state.saMethod:lower() == method:lower() then
                    args[2] = Ray.new(args[2].Origin, (hitPart.Position - args[2].Origin).Unit * 1000)
                    return oldNamecall(unpack(args))
                elseif method == "Raycast" and state.saMethod == method then
                    args[3] = (hitPart.Position - args[2]).Unit * 1000
                    return oldNamecall(unpack(args))
                end
            end
        end
        return oldNamecall(...)
    end))

    -- Hook __index para Mouse.Hit/Target
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
        if self == Mouse and not checkcaller() and state.silentAim and state.saMethod == "Mouse.Hit/Target" then
            local hitPart = getClosestPlayerSA()
            if hitPart then
                if index == "Target" or index == "target" then
                    return hitPart
                elseif index == "Hit" or index == "hit" then
                    return state.saMousePrediction
                        and hitPart.CFrame + hitPart.Velocity * state.saPredictionAmount
                        or hitPart.CFrame
                elseif index == "UnitRay" then
                    return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
                end
            end
        end
        return oldIndex(self, index)
    end))

    -- ============================================================
    -- LÓGICAS DE MOVIMENTO, FARM, CARRO, ARMAS, EXTRAS
    -- ============================================================

    -- Pulo Infinito
    UserInputService.JumpRequest:Connect(function()
        if state.infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Fly Avançado
    task.spawn(function()
        while true do
            task.wait()
            if state.fly then
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
                local root = char.HumanoidRootPart
                local hum = char:FindFirstChild("Humanoid")
                if hum then hum.PlatformStand = true end
                if not state.flyStartY then state.flyStartY = root.Position.Y end

                local camDir = Camera.CFrame.LookVector
                local moveDir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(camDir.X, 0, camDir.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(camDir.X, 0, camDir.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then state.flyStartY = state.flyStartY + state.flySpeed * 0.15 end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then state.flyStartY = state.flyStartY - state.flySpeed * 0.15 end

                local newPos = root.Position
                if moveDir.Magnitude > 0 then
                    newPos = root.Position + moveDir.Unit * (state.flySpeed * 0.2)
                end
                newPos = Vector3.new(newPos.X, state.flyStartY, newPos.Z)
                root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.5)
            else
                state.flyStartY = nil
            end
        end
    end)

    -- Speed Hack
    task.spawn(function()
        while true do
            task.wait()
            if state.speedHack then
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    local delta = state.speedValue / 60
                    local newPos = char.HumanoidRootPart.Position + hum.MoveDirection.Unit * delta
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame:Lerp(CFrame.new(newPos), 0.8)
                end
            end
        end
    end)

    -- Ghost Mode
    task.spawn(function()
        while true do
            task.wait(0.3)
            if state.ghostMode and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.85
                    end
                end
            end
        end
    end)

    -- Derrubar Player
    task.spawn(function()
        while true do
            task.wait(0.1)
            if state.derrubarPlayer then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Velocity = Vector3.new(0, -50, 0)
                    end
                end
            end
        end
    end)

    -- Auto Farm Lixo
    task.spawn(function()
        while true do
            task.wait(0.1)
            if not state.autoFarm then continue end
            local char = LocalPlayer.Character
            if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            local trash, nearestDist = nil, 50
            local keywords = {"lixo","trash","saco","papel","garrafa","lata","entulho","resto","garbage","waste","bag","bottle","can","paper"}
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 0.9 then
                    local name = part.Name:lower()
                    local isTrash = false
                    for _, kw in ipairs(keywords) do
                        if name:find(kw) then isTrash = true; break end
                    end
                    if isTrash then
                        local d = (part.Position - root.Position).Magnitude
                        if d < nearestDist then
                            nearestDist = d
                            trash = part
                        end
                    end
                end
            end

            if trash then
                local targetPos = trash.Position
                local distance = (targetPos - root.Position).Magnitude
                if distance > 4 then
                    local direction = (targetPos - root.Position).Unit
                    local newPos = root.Position + direction * (state.farmSpeed * 0.05)
                    root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.5)
                else
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool then
                        pcall(function() tool:Activate() end)
                    end
                    task.wait(0.3)
                end
            end
        end
    end)

    -- Auto Essência
    task.spawn(function()
        while true do
            task.wait(0.5)
            if not state.autoEssencia then continue end
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("essencia") or obj.Name:lower():find("essence")) then
                    if tick() - state.lastEssencePick > 1.5 then
                        char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                        state.lastEssencePick = tick()
                        local tool = char:FindFirstChildWhichIsA("Tool")
                        if tool then pcall(function() tool:Activate() end) end
                        break
                    end
                end
            end
        end
    end)

    -- Auto Micha
    task.spawn(function()
        while true do
            task.wait(0.5)
            if not state.autoMicha then continue end
            local char = LocalPlayer.Character
            if not char then continue end
            local tool = char:FindFirstChild("Micha") or LocalPlayer.Backpack:FindFirstChild("Micha")
            if tool and tool:IsA("Tool") then
                if tool.Parent ~= char then tool.Parent = char end
                pcall(function() tool:Activate() end)
            end
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local objText = prompt.ObjectText:lower()
                    local actText = prompt.ActionText:lower()
                    if objText:find("micha") or actText:find("roubar") or actText:find("micha") or objText:find("veiculo") then
                        if LocalPlayer:DistanceFromCharacter(prompt.Parent.Position) <= prompt.MaxActivationDistance then
                            pcall(function() fireproximityprompt(prompt) end)
                        end
                    end
                end
            end
        end
    end)

    -- Fly Car
    task.spawn(function()
        while true do
            task.wait(0.05)
            if not state.flyCar then
                if state.flyCarBV then state.flyCarBV:Destroy(); state.flyCarBV = nil end
                if state.flyCarBG then state.flyCarBG:Destroy(); state.flyCarBG = nil end
                state.flyCarTarget = nil
                continue
            end
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            if not state.flyCarTarget or not state.flyCarTarget.Parent then
                local nearest, nearestDist = nil, math.huge
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("VehicleSeat") or (obj:IsA("Seat") and obj:FindFirstAncestorOfClass("Model")) then
                        local car = obj:FindFirstAncestorOfClass("Model")
                        if car then
                            local p = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                            if p then
                                local d = (p.Position - char.HumanoidRootPart.Position).Magnitude
                                if d < nearestDist then nearestDist = d; state.flyCarTarget = car end
                            end
                        end
                    end
                end
            end
            if not state.flyCarTarget then continue end
            local primary = state.flyCarTarget:FindFirstChild("PrimaryPart") or state.flyCarTarget:FindFirstChildWhichIsA("BasePart")
            if not primary then continue end
            if not state.flyCarBV or not state.flyCarBV.Parent then
                state.flyCarBV = Instance.new("BodyVelocity")
                state.flyCarBV.MaxForce = Vector3.new(1e9,1e9,1e9)
                state.flyCarBV.Parent = primary
            end
            if not state.flyCarBG or not state.flyCarBG.Parent then
                state.flyCarBG = Instance.new("BodyGyro")
                state.flyCarBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
                state.flyCarBG.Parent = primary
            end
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
            if moveDir.Magnitude > 0 then
                state.flyCarBV.Velocity = moveDir.Unit * (state.flyCarSpeed * 0.5)
            else
                state.flyCarBV.Velocity = Vector3.new(0,0,0)
            end
            state.flyCarBG.CFrame = CFrame.new(primary.Position, primary.Position + Camera.CFrame.LookVector)
        end
    end)

    -- Super Velocidade no Carro
    task.spawn(function()
        while true do
            task.wait(0.1)
            if state.superCarSpeed and LocalPlayer.Character then
                local seat = nil
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("VehicleSeat") and v.Occupant == LocalPlayer.Character.Humanoid then
                        seat = v
                        break
                    end
                end
                if seat then
                    local car = seat:FindFirstAncestorOfClass("Model")
                    if car then
                        local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                        if primary then
                            primary.Velocity = primary.CFrame.LookVector * state.superCarSpeedValue
                        end
                    end
                end
            end
        end
    end)

    -- Armas: Reach, Infinite Ammo, Auto Reload, No Recoil, One Shot, Roubar
    task.spawn(function()
        while true do
            task.wait(0.5)
            if state.reach then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then tool.MaxActivationDistance = state.reachDist end
            end
            if state.infiniteAmmo then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets") or tool:FindFirstChild("Magazine")
                    if ammo and ammo:IsA("IntValue") then ammo.Value = 99 end
                end
            end
            if state.autoReload then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets")
                    if ammo and ammo:IsA("IntValue") and ammo.Value == 0 then
                        pcall(function() tool:Reload() end)
                    end
                end
            end
            if state.noRecoil then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    for _, obj in ipairs(tool:GetDescendants()) do
                        if obj:IsA("SpringConstraint") or obj:IsA("RocketPropulsion") then
                            obj.Enabled = false
                        end
                    end
                end
            end
            if state.oneShot then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    for _, v in ipairs(tool:GetDescendants()) do
                        if v.Name == "Damage" and v:IsA("NumberValue") then
                            v.Value = 9999
                        end
                    end
                end
            end
            if state.roubarP1 then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local tool = p.Character:FindFirstChildWhichIsA("Tool")
                        if tool then tool.Parent = LocalPlayer.Backpack end
                    end
                end
            end
            if state.roubarP2 then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        for _, child in ipairs(p.Character:GetChildren()) do
                            if child:IsA("Tool") then
                                child.Parent = LocalPlayer.Backpack
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Rapid Fire
    task.spawn(function()
        while true do
            task.wait()
            if state.rapidFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool and tick() - state.rapidFireTimer >= state.rapidFireDelay then
                    pcall(function() tool:Activate() end)
                    state.rapidFireTimer = tick()
                end
            end
        end
    end)

    -- Arma RGB e tamanho
    task.spawn(function()
        while true do
            task.wait(0.05)
            if state.armaColorida then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    local hue = (tick() * state.rgbSpeed) % 1
                    tool.Handle.Color = Color3.fromHSV(hue, 1, 1)
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.5)
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                pcall(function() tool:ScaleTo(state.armaSize) end)
            end
        end
    end)

    -- God Mode, Anti Stun, Anti Fire, Auto Respawn
    task.spawn(function()
        while true do
            task.wait(0.5)
            if state.godMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid
                hum.MaxHealth = 1e9
                hum.Health = 1e9
            end
            if state.antiStun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
            if state.antiFire and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Material == Enum.Material.Fire then
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
            if state.autoRespawn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health <= 0 then
                pcall(function() LocalPlayer:LoadCharacter() end)
            end
        end
    end)

    -- Anti AFK
    task.spawn(function()
        while true do
            task.wait(1)
            if state.antiAfk and tick() - state.lastAfkTime > 120 then
                state.lastAfkTime = tick()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
                end
            end
        end
    end)

    -- ============================================================
    -- LIMPEZA FINAL AO DESTRUIR O SCRIPT
    -- ============================================================
    script.Destroying:Connect(function()
        if state.flyCarBV then state.flyCarBV:Destroy() end
        if state.flyCarBG then state.flyCarBG:Destroy() end
        if state.vehicleAlign then state.vehicleAlign:Destroy() end
        if state.vehicleVel then state.vehicleVel:Destroy() end
        if state.vehicleGyro then state.vehicleGyro:Destroy() end
        if fovCircleObj then fovCircleObj:Remove() end
        if laserLine then
            if useDrawing then laserLine:Remove() else laserLine:Destroy() end
        end
        clearESPObjects()
        if VoiceChatService then
            pcall(function() VoiceChatService:SetVoiceEnabled(false) end)
        end
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.PlatformStand = false
            c.Humanoid.WalkSpeed = 16
        end
    end)

    print("[S4ZX HUB v2.9 KAVO] Carregado com sucesso!")
end

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
mostrarLogin()
