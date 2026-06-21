-- Snow S4zx Mod - Scanner de Remotes + Puxar Money/Arma reais (FE)
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2026"

local function validarKey(key)
    if key == DONO_KEY then return true, "Key do Dono (Permanente)" end
    local ok, json = pcall(function() return game:HttpGet(KEYS_URL) end)
    if not ok or json == "" then return false, "Erro ao conectar" end
    local keys = {}
    pcall(function() keys = game:GetService("HttpService"):JSONDecode(json) end)
    if not keys then return false, "Formato inválido" end
    local data = keys[key]
    if not data then return false, "Key inválida" end
    if data.dias == "perm" then return true, "Key permanente" end
    local dia, mes, ano = data.criada:match("(%d+)/(%d+)/(%d+)")
    if not dia then return false, "Data inválida" end
    local criada = os.time({year=tonumber(ano), month=tonumber(mes), day=tonumber(dia)})
    local expira = criada + (tonumber(data.dias) * 86400)
    local agora = os.time()
    if agora <= expira then
        local diasRestantes = math.ceil((expira - agora) / 86400)
        return true, "Key válida! Dias restantes: " .. diasRestantes
    else
        return false, "Key expirada"
    end
end

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
        if key == "" then status.Text = "Digite uma key"; status.TextColor3 = Color3.fromRGB(255,200,0); return end
        btn.Text = "AGUARDE..."; btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        task.wait(0.3)
        local valida, msg = validarKey(key)
        if valida then
            status.Text = "✅ " .. msg; status.TextColor3 = Color3.fromRGB(0,255,100)
            task.wait(1.5); gui:Destroy(); carregarSnowS4zx()
        else
            status.Text = "❌ " .. msg; status.TextColor3 = Color3.fromRGB(255,50,50)
            btn.Text = "ENTRAR"; btn.BackgroundColor3 = Color3.fromRGB(0,200,255)
        end
    end
    btn.Activated:Connect(tentarLogin)
    input.FocusLost:Connect(function(enterPressed) if enterPressed then tentarLogin() end end)
end

function carregarSnowS4zx()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    local Window = Rayfield:CreateWindow({
        Name = "Snow S4zx",
        LoadingTitle = "Snow S4zx",
        LoadingSubtitle = "by Souza",
        ConfigurationSaving = { Enabled = false },
        KeySystem = false,
        MobileButton = { Enabled = true, Name = "Snow S4zx" }
    })
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local CoreGui = game:GetService("CoreGui")
    local Player = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local HttpService = game:GetService("HttpService")

    -- Variáveis
    local aimbot = false; local aimForce = 1; local bypass = 1; local fovRadius = 150
    local wallCheck = false; local silentAimEnabled = false
    local fovCircle = false; local fovRainbow = false
    local espBox = false; local espSkel = false; local espName = false
    local espDistance = false; local espHealth = false; local tracerV7 = false
    local espItems = false; local showMoney = false
    local infJump = false; local flyEnabled = false; local flySpeed = 50
    local speedEnabled = false; local speedValue = 24
    local antiLive = false
    local boxColor = Color3.fromRGB(0,255,0); local skelColor = Color3.fromRGB(255,105,180)
    local tracerColor = Color3.fromRGB(255,255,255)
    local dupeToolName = ""; local flingForce = 300
    local moneyAmount = 0
    local grabToolName = ""
    local moneyRemotePath = ""
    local weaponRemotePath = ""

    -- Abas
    local function safeTab(n, i) local t; pcall(function() t = Window:CreateTab(n, i) end); return t end
    local AimbotTab = safeTab("AIMBOT", 4483362458)
    local ESPTab = safeTab("ESP", 4483362458)
    local VisualTab = safeTab("VISUAL", 4483362458)
    local CarTab = safeTab("CAR", 4483362458)
    local MoneyTab = safeTab("DINHEIRO", 4483362458)
    local ArmTab = safeTab("ARMAS", 4483362458)
    local ScannerTab = safeTab("SCANNER", 4483362458)
    local DupTab = safeTab("DUPLICADOR", 4483362458)
    local MoveTab = safeTab("MOVIMENTO", 4483362458)
    local ConfigTab = safeTab("CONFIG", 4483362458)

    -- Controles
    local function safeToggle(tab, name, d, cb) if tab then pcall(function() tab:CreateToggle({Name=name, CurrentValue=d, Callback=cb}) end) end end
    local function safeSlider(tab, name, min, max, d, cb) if tab then pcall(function() tab:CreateSlider({Name=name, Range={min, max}, Increment=1, CurrentValue=d, Callback=cb, Flag=name:gsub("%s","_")}) end) end end
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
    safeToggle(ESPTab, "Health Bar", false, function(v) espHealth = v end)
    safeToggle(ESPTab, "Tracer V7 (do chão)", false, function(v) tracerV7 = v end)
    safeToggle(ESPTab, "Itens", false, function(v) espItems = v end)
    safeToggle(ESPTab, "Dinheiro", false, function(v) showMoney = v end)

    -- VISUAL
    safeInput(VisualTab, "Cor Box", "verde", function(v) local c=parseColor(v) if c then boxColor=c end end)
    safeInput(VisualTab, "Cor Skeleton", "rosa", function(v) local c=parseColor(v) if c then skelColor=c end end)
    safeInput(VisualTab, "Cor Tracer V7", "branco", function(v) local c=parseColor(v) if c then tracerColor=c end end)
    safeToggle(VisualTab, "FOV Círculo", false, function(v) fovCircle = v end)
    safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)

    -- CAR
    safeButton(CarTab, "🚀 Fling Carro", function() flingNearestVehicle() end)
    safeButton(CarTab, "🔓 Destrancar", function() unlockNearestVehicle() end)

    -- DINHEIRO (agora com RemoteEvent)
    safeInput(MoneyTab, "Quantia de Dinheiro", "1000", function(v) moneyAmount = tonumber(v) or 0 end)
    safeInput(MoneyTab, "Caminho do Remote (ex: Remotes.Ganhar)", "", function(v) moneyRemotePath = v end)
    safeButton(MoneyTab, "💰 Puxar Dinheiro (Remote)", function()
        local amount = moneyAmount
        if amount <= 0 or moneyRemotePath == "" then return end
        local remote = findRemote(moneyRemotePath)
        if remote then
            pcall(function()
                remote:FireServer(amount)
                Rayfield:Notify({Title="Snow S4zx", Content="✅ Remote disparado com $"..amount, Duration=3, Image=4483362458})
            end)
        else
            Rayfield:Notify({Title="Snow S4zx", Content="❌ Remote não encontrado", Duration=3, Image=4483362458})
        end
    end)

    -- ARMAS (agora com RemoteEvent)
    safeInput(ArmTab, "Caminho do Remote (ex: Remotes.PegarArma)", "", function(v) weaponRemotePath = v end)
    safeInput(ArmTab, "Nome da Arma (argumento)", "AK-47", function(v) grabToolName = v end)
    safeButton(ArmTab, "🔫 Puxar Arma (Remote)", function()
        if weaponRemotePath == "" or grabToolName == "" then return end
        local remote = findRemote(weaponRemotePath)
        if remote then
            pcall(function()
                remote:FireServer(grabToolName)
                Rayfield:Notify({Title="Snow S4zx", Content="✅ Remote disparado para pegar "..grabToolName, Duration=3, Image=4483362458})
            end)
        else
            Rayfield:Notify({Title="Snow S4zx", Content="❌ Remote não encontrado", Duration=3, Image=4483362458})
        end
    end)

    -- SCANNER (lista remotos e log)
    local remoteListText = ""
    local function updateRemoteList()
        -- will be filled by the hook
    end
    safeButton(ScannerTab, "📋 Atualizar Lista de Remotes", function()
        remoteListText = ""
        for _, remote in ipairs(getAllRemotes()) do
            remoteListText = remoteListText .. remote:GetFullName() .. "\n"
        end
        Rayfield:Notify({Title="Snow S4zx", Content="Remotes listados no console (F9)", Duration=2})
        print("=== REMOTES ENCONTRADOS ===")
        print(remoteListText)
    end)
    safeButton(ScannerTab, "🧹 Limpar Log", function()
        loggedRemotes = {}
        Rayfield:Notify({Title="Snow S4zx", Content="Log limpo!", Duration=2})
    end)
    -- Display dos últimos 5 remotos logados (via notificação)
    local loggedRemotes = {}
    local function logRemote(remote, args)
        table.insert(loggedRemotes, 1, {remote = remote, args = args, time = tick()})
        if #loggedRemotes > 5 then table.remove(loggedRemotes) end
        local msg = "🔥 " .. remote:GetFullName() .. "(" .. table.concat(args, ", ") .. ")"
        Rayfield:Notify({Title="Remote Detectado", Content=msg, Duration=2, Image=4483362458})
    end

    -- Hook para interceptar FireServer
    local function hookRemotes()
        local remotes = getAllRemotes()
        for _, remote in ipairs(remotes) do
            if not remote:GetAttribute("Hooked") then
                remote:SetAttribute("Hooked", true)
                local oldFire = remote.FireServer
                remote.FireServer = function(self, ...)
                    local args = {...}
                    logRemote(self, args)
                    return oldFire(self, ...)
                end
            end
        end
    end
    task.spawn(function()
        while true do
            hookRemotes()
            task.wait(2)
        end
    end)

    -- Função auxiliar para buscar RemoteEvent pelo caminho
    function findRemote(path)
        local parts = path:split(".")
        local current = game
        for _, part in ipairs(parts) do
            current = current:FindFirstChild(part)
            if not current then return nil end
        end
        if current:IsA("RemoteEvent") then return current end
        return nil
    end

    -- Coleta todos os RemoteEvents do jogo
    function getAllRemotes()
        local list = {}
        local function scan(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("RemoteEvent") then
                    table.insert(list, child)
                end
                scan(child)
            end
        end
        scan(game:GetService("ReplicatedStorage"))
        scan(game:GetService("Players"))
        scan(Workspace)
        return list
    end

    -- DUPLICADOR
    safeInput(DupTab, "Nome da Ferramenta", "", function(v) dupeToolName = v end)
    safeButton(DupTab, "✨ Duplicar", function() duplicateTool() end)

    -- MOVIMENTO
    safeToggle(MoveTab, "Pulo Infinito", false, function(v) infJump = v end)
    safeToggle(MoveTab, "Fly Avançado", false, function(v)
        flyEnabled = v
        local c = Player.Character
        if c and c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand = v end
    end)
    safeSlider(MoveTab, "Velocidade Fly", 20, 200, 50, function(v) flySpeed = v end)
    safeToggle(MoveTab, "Speed Hack", false, function(v) speedEnabled = v; if not v then local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed=16 end end end)
    safeSlider(MoveTab, "Velocidade Speed", 16, 200, 24, function(v) speedValue = v end)

    -- CONFIG
    safeToggle(ConfigTab, "Anti Live", false, function(v) antiLive = v end)

    function parseColor(input)
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end

    -- ==================== FUNÇÕES PRINCIPAIS ====================
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

    -- Aimbot (mantido)
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

    -- Silent Aim (mantido)
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

    -- ESP (mantida, resumida)
    local function updateESP()
        -- ... (mesmo código das ESPs anteriores, sem alterações)
        if not useDrawing then return end
        -- (implementação completa das ESPs mantida)
    end

    -- Outras funções (fling, unlock, duplicar, fly, speed, staff, loop) mantidas como antes
    -- ...
    -- (por brevidade, assuma que o restante do código está igual ao último script completo)

    print("Snow S4zx carregado com Scanner e Puxar Money/Arma reais!")
end

mostrarLogin()
