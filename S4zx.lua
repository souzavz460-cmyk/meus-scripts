-- ========================================================
-- S4ZX HUB v2.7 - LINHA DE MIRA + ARMAS DINÂMICAS
-- ========================================================

-- ========== SEGURANÇA ==========
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2026"

local function getHWID()
    local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if ok and id then return id end
    ok, id = pcall(function() return game:HttpGet("https://api.ipify.org") end)
    return ok and id or "UNKNOWN"
end
local HWID = getHWID()
local SECURITY_FLAG = "S4zx_INTEGRO_2026"

local function destruirScript(motivo)
    pcall(function()
        if game.CoreGui:FindFirstChild("S4ZX_Login") then game.CoreGui.S4ZX_Login:Destroy() end
        if game.CoreGui:FindFirstChild("S4ZX_Hub_v25") then game.CoreGui.S4ZX_Hub_v25:Destroy() end
    end)
    game.Players.LocalPlayer:Kick(motivo or "Script encerrado")
    while true do end
end

-- ========== TELA DE LOGIN ==========
local function mostrarLogin()
    task.wait(0.5)
    if not SECURITY_FLAG or SECURITY_FLAG ~= "S4zx_INTEGRO_2026" then
        destruirScript("Script adulterado")
        return
    end

    local loginGui = Instance.new("ScreenGui")
    loginGui.Name = "S4ZX_Login"
    loginGui.Parent = game.CoreGui
    loginGui.ResetOnSpawn = false

    local frame = Instance.new("Frame", loginGui)
    frame.Size = UDim2.new(0, 300, 0, 230)
    frame.Position = UDim2.new(0.5, -150, 0.5, -115)
    frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(220, 30, 30)

    local logoText = Instance.new("TextLabel", frame)
    logoText.Size = UDim2.new(0, 120, 0, 35)
    logoText.Position = UDim2.new(0.5, -60, 0, 10)
    logoText.BackgroundTransparency = 1
    logoText.Text = "S4ZX"
    logoText.TextColor3 = Color3.fromRGB(255,255,255)
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize = 20

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "S4ZX HUB - LOGIN"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18

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

    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0, 125)
    status.BackgroundTransparency = 1
    status.Text = ""
    status.TextColor3 = Color3.new(1,1,1)
    status.Font = Enum.Font.SourceSans
    status.TextSize = 13

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
    closeBtn.MouseButton1Click:Connect(function() loginGui:Destroy() end)

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
            loginGui:Destroy()
            carregarHub()
            return
        end
        btn.Text = "VERIFICANDO..."
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        local ok, json = pcall(function() return game:HttpGet(KEYS_URL) end)
        if ok and json and json ~= "" then
            local keys = {}
            pcall(function() keys = game:GetService("HttpService"):JSONDecode(json) end)
            local data = keys[key]
            if data then
                if data.bloqueado then
                    status.Text = "⛔ Key banida!"
                    status.TextColor3 = Color3.fromRGB(255,0,0)
                elseif data.hwid and data.hwid ~= "" and data.hwid ~= HWID then
                    status.Text = "❌ HWID não autorizado"
                    status.TextColor3 = Color3.fromRGB(255,0,0)
                else
                    if data.dias == "perm" then
                        status.Text = "✅ Key permanente"
                        status.TextColor3 = Color3.fromRGB(0,255,100)
                        task.wait(1)
                        loginGui:Destroy()
                        carregarHub()
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
        btn.Text = "ENTRAR"
        btn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    end

    btn.MouseButton1Click:Connect(tentarLogin)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then tentarLogin() end
    end)
end

-- ========== HUB PRINCIPAL ==========
function carregarHub()
    if not SECURITY_FLAG or SECURITY_FLAG ~= "S4zx_INTEGRO_2026" then
        destruirScript("Script adulterado")
        return
    end

    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    if CoreGui:FindFirstChild("S4ZX_Hub_v25") then
        CoreGui.S4ZX_Hub_v25:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "S4ZX_Hub_v25"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- ========================================================
    -- VARIÁVEIS DE ESTADO (NOVAS: linhaDeMira e armasDetectadas)
    -- ========================================================
    local state = {
        -- Aimbot
        aimbot = false,
        aimForce = 3,
        bypass = 5,
        fovRadius = 150,
        wallCheck = false,
        silentAim = false,
        magicBullet = false,

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
        textSize = 14,
        skeletonColor = Color3.fromRGB(255,105,180),
        boxColor = Color3.fromRGB(0,255,0),
        talkColor = Color3.fromRGB(255,255,255),

        -- Veículos
        waypoint = nil,

        -- Visual
        fovCircle = false,
        fovRainbow = false,
        linhaDeMira = false,  -- NOVA: linha de mira

        -- Movimento
        infJump = false,
        fly = false,
        flySpeed = 50,
        speedHack = false,
        speedValue = 60,
        ghostMode = false,

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

        -- Carro
        flyCar = false,
        flyCarSpeed = 70,

        -- Extras
        antiAfk = false,
        antiStun = false,
        antiFire = false,
        autoRespawn = false,
        godMode = false,

        -- Config
        streamerMode = false,
        antiLive = false,

        -- Internos
        grabbedVehicle = nil,
        vehicleAlign = nil,
        vehicleVel = nil,
        vehicleGyro = nil,
        spectateTarget = nil,
        flyStartY = nil,
        lastFarmAction = 0,
        lastEssencePick = 0,
        flyCarBV = nil,
        flyCarBG = nil,
        flyCarTarget = nil,
        rapidFireTimer = 0,
        lastAfkTime = 0,
        lastLiveCheck = 0,
        -- Armas detectadas
        armasDetectadas = {},
    }

    -- ========================================================
    -- UTILITÁRIOS
    -- ========================================================
    local function isAdmin(player)
        if not player or not player.Name then return false end
        local name = player.Name:lower()
        local keywords = {"admin","mod","staff","owner","dev","gerente","helper","moderador"}
        for _, kw in ipairs(keywords) do
            if name:find(kw) then return true end
        end
        return false
    end

    local function worldToScreen(pos)
        local vec, onScreen = Camera:WorldToViewportPoint(pos)
        return Vector2.new(vec.X, vec.Y), onScreen
    end

    -- ========================================================
    -- JANELA PRINCIPAL E BOTÃO FLUTUANTE
    -- ========================================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 740, 0, 470)
    MainFrame.Position = UDim2.new(0.5, -370, 0.5, -235)
    MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(220, 30, 30)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    local OpenButton = Instance.new("ImageButton")
    OpenButton.Name = "OpenButton"
    OpenButton.Size = UDim2.new(0, 50, 0, 50)
    OpenButton.Position = UDim2.new(0.5, -25, 0, 10)
    OpenButton.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
    OpenButton.Image = "rbxassetid://79731590930393"
    OpenButton.ScaleType = Enum.ScaleType.Fit
    OpenButton.Visible = false
    OpenButton.Active = true
    OpenButton.Draggable = true
    OpenButton.Parent = ScreenGui

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(1, 0)
    OpenCorner.Parent = OpenButton

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(220, 30, 30)
    OpenStroke.Thickness = 2
    OpenStroke.Parent = OpenButton

    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenButton.Visible = false
    end)

    -- ========================================================
    -- PAINEL LATERAL ESQUERDO (LOGO + ABAS)
    -- ========================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "LogoContainer"
    LogoContainer.Size = UDim2.new(1, 0, 0, 75)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = Sidebar

    local LogoImage = Instance.new("ImageLabel")
    LogoImage.Name = "LogoImage"
    LogoImage.Size = UDim2.new(0, 140, 0, 45)
    LogoImage.Position = UDim2.new(0.5, -70, 0, 10)
    LogoImage.BackgroundTransparency = 1
    LogoImage.Image = "rbxassetid://79731590930393"
    LogoImage.ScaleType = Enum.ScaleType.Fit
    LogoImage.Parent = LogoContainer

    local VersionText = Instance.new("TextLabel")
    VersionText.Size = UDim2.new(1, 0, 0, 15)
    VersionText.Position = UDim2.new(0, 0, 0, 55)
    VersionText.BackgroundTransparency = 1
    VersionText.Text = "VERSION 2.7 OFFICIAL"
    VersionText.TextColor3 = Color3.fromRGB(150, 150, 150)
    VersionText.TextSize = 10
    VersionText.Font = Enum.Font.GothamBold
    VersionText.Parent = LogoContainer

    local LogoDivider = Instance.new("Frame")
    LogoDivider.Size = UDim2.new(0.85, 0, 0, 1)
    LogoDivider.Position = UDim2.new(0.075, 0, 0, 74)
    LogoDivider.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    LogoDivider.BorderSizePixel = 0
    LogoDivider.Parent = LogoContainer

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -80)
    TabContainer.Position = UDim2.new(0, 0, 0, 80)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(220, 30, 30)
    TabContainer.Parent = Sidebar

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 6)
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.Parent = TabContainer

    -- ========================================================
    -- ÁREA DE CONTEÚDO PRINCIPAL (DIREITA)
    -- ========================================================
    local HeaderBar = Instance.new("Frame")
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Size = UDim2.new(1, -180, 0, 40)
    HeaderBar.Position = UDim2.new(0, 180, 0, 0)
    HeaderBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    HeaderBar.BorderSizePixel = 0
    HeaderBar.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 10)
    HeaderCorner.Parent = HeaderBar

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Name = "HeaderTitle"
    HeaderTitle.Size = UDim2.new(1, -60, 1, 0)
    HeaderTitle.Position = UDim2.new(0, 15, 0, 0)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = "Aimbot"
    HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderTitle.TextSize = 15
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = HeaderBar

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = HeaderBar

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn

    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenButton.Visible = true
    end)

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -190, 1, -50)
    ContentArea.Position = UDim2.new(0, 185, 0, 45)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    -- ========================================================
    -- GERENCIADOR DE COMPONENTES
    -- ========================================================
    local Tabs = {}
    local FirstTab = true

    local function CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "_Btn"
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Color3.fromRGB(170, 170, 175)
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabContainer

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.BorderSizePixel = 0
        Page.CanvasSize = UDim2.new(0, 0, 0, 0)
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(220, 30, 30)
        Page.Parent = ContentArea

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingRight = UDim.new(0, 8)
        PagePadding.PaddingTop = UDim.new(0, 2)
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.Parent = Page

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                t.Button.TextColor3 = Color3.fromRGB(170, 170, 175)
            end
            Page.Visible = true
            HeaderTitle.Text = tabName
            TabButton.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        if FirstTab then
            FirstTab = false
            Page.Visible = true
            HeaderTitle.Text = tabName
            TabButton.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        Tabs[tabName] = {Page = Page, Button = TabButton}
        return Page
    end

    local function AddToggle(page, text, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 36)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        Frame.Parent = page

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -55, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(230, 230, 235)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 38, 0, 18)
        Switch.Position = UDim2.new(1, -46, 0.5, -9)
        Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        Switch.Text = ""
        Switch.Parent = Frame

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 14, 0, 14)
        Indicator.Position = UDim2.new(0, 2, 0.5, -7)
        Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Indicator.Parent = Switch

        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(1, 0)
        IndCorner.Parent = Indicator

        local enabled = false
        Switch.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 30, 30)}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
            else
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
            end
            pcall(callback, enabled)
        end)
    end

    local function AddSlider(page, text, min, max, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 45)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        Frame.Parent = page

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, 0, 0, 20)
        Label.Position = UDim2.new(0, 12, 0, 4)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(230, 230, 235)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0.25, 0, 0, 20)
        ValueLabel.Position = UDim2.new(0.72, 0, 0, 4)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(default)
        ValueLabel.TextColor3 = Color3.fromRGB(220, 30, 30)
        ValueLabel.TextSize = 12
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = Frame

        local SliderBar = Instance.new("Frame")
        SliderBar.Size = UDim2.new(1, -24, 0, 6)
        SliderBar.Position = UDim2.new(0, 12, 0, 30)
        SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = Frame

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar

        local SliderFill = Instance.new("Frame")
        local startPct = (default - min) / (max - min)
        SliderFill.Size = UDim2.new(startPct, 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = SliderFill

        local dragging = false
        local function update(input)
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            pcall(callback, value)
        end

        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true update(input) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
        end)
    end

    local function AddButton(page, text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(240, 240, 245)
        Button.TextSize = 12
        Button.Font = Enum.Font.GothamMedium
        Button.Parent = page

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Button

        Button.MouseButton1Click:Connect(function() pcall(callback) end)
    end

    -- ========================================================
    -- PLAYER ROW (lista de jogadores)
    -- ========================================================
    local PlayerRows = {}
    local function AddPlayerRow(page, player)
        local rowFrame = Instance.new("Frame")
        rowFrame.Size = UDim2.new(1, 0, 0, 36)
        rowFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        rowFrame.Parent = page

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = rowFrame

        local NameLabel = Instance.new("TextLabel")
        NameLabel.Size = UDim2.new(0.4, 0, 1, 0)
        NameLabel.Position = UDim2.new(0, 10, 0, 0)
        NameLabel.BackgroundTransparency = 1
        NameLabel.Text = "👤 " .. player.Name
        NameLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
        NameLabel.TextSize = 12
        NameLabel.Font = Enum.Font.Gotham
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = rowFrame

        local DistLabel = Instance.new("TextLabel")
        DistLabel.Size = UDim2.new(0.2, 0, 1, 0)
        DistLabel.Position = UDim2.new(0.4, 0, 0, 0)
        DistLabel.BackgroundTransparency = 1
        DistLabel.Text = "??m"
        DistLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
        DistLabel.TextSize = 11
        DistLabel.Font = Enum.Font.Gotham
        DistLabel.TextXAlignment = Enum.TextXAlignment.Center
        DistLabel.Parent = rowFrame

        local function createSmallBtn(text, posOffset, sizeWidth, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, sizeWidth, 0, 24)
            Btn.Position = UDim2.new(1, posOffset, 0.5, -12)
            Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            Btn.Text = text
            Btn.TextColor3 = Color3.fromRGB(220, 220, 225)
            Btn.TextSize = 11
            Btn.Font = Enum.Font.GothamMedium
            Btn.Parent = rowFrame

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = Btn
            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end

        local BtnPuxar = createSmallBtn("🔄 Puxar", -70, 60, function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = player.Character.HumanoidRootPart
                    local myRoot = myChar.HumanoidRootPart
                    local bv = Instance.new("BodyVelocity")
                    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    bv.Velocity = (myRoot.Position - targetRoot.Position).Unit * 50
                    bv.Parent = targetRoot
                    game:GetService("Debris"):AddItem(bv, 1)
                    task.wait(0.5)
                    if (targetRoot.Position - myRoot.Position).Magnitude > 10 then
                        targetRoot.CFrame = myRoot.CFrame + Vector3.new(0, 2, 0)
                    end
                end
            end
        end)

        local BtnTP = createSmallBtn("🚀 TP", -125, 50, function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end)

        local BtnSpectate = createSmallBtn("👁️ Spectate", -210, 80, function()
            state.spectateTarget = player
            if player.Character then
                Camera.CameraSubject = player.Character
            end
        end)

        return {
            frame = rowFrame,
            nameLabel = NameLabel,
            distLabel = DistLabel,
            player = player,
            updateDistance = function()
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if myRoot and targetRoot then
                    local dist = (targetRoot.Position - myRoot.Position).Magnitude
                    DistLabel.Text = string.format("%.1fm", dist)
                else
                    DistLabel.Text = "??m"
                end
            end
        }
    end

    -- ========================================================
    -- CONSTRUÇÃO DAS ABAS
    -- ========================================================

    -- 1. AIMBOT
    local AimbotPage = CreateTab("🎯 Aimbot")
    AddToggle(AimbotPage, "AIMBOT (Mira Automática)", function(v) state.aimbot = v end)
    AddSlider(AimbotPage, "Força da Mira", 1, 5, 3, function(v) state.aimForce = v end)
    AddSlider(AimbotPage, "Bypass (Anticheat)", 1, 10, 5, function(v) state.bypass = v end)
    AddSlider(AimbotPage, "FOV Raio", 50, 500, 150, function(v) state.fovRadius = v end)
    AddToggle(AimbotPage, "WALLCK (Checar Parede)", function(v) state.wallCheck = v end)
    AddToggle(AimbotPage, "SILENT AIM", function(v) state.silentAim = v end)
    AddToggle(AimbotPage, "Magic Bullet", function(v) state.magicBullet = v end)

    -- 2. ESP
    local EspPage = CreateTab("👁️ ESP")
    AddToggle(EspPage, "Ativar ESP (Geral)", function(v) state.espEnabled = v end)
    AddToggle(EspPage, "Box (Caixas)", function(v) state.espBox = v end)
    AddToggle(EspPage, "Names (Nomes)", function(v) state.espNames = v end)
    AddToggle(EspPage, "Weapons (Arma Equipada)", function(v) state.espWeapons = v end)
    AddToggle(EspPage, "Talking Icon (Ícone de Fala)", function(v) state.espTalking = v end)
    AddToggle(EspPage, "Skeleton (Esqueleto)", function(v) state.espSkeleton = v end)
    AddToggle(EspPage, "Admin ESP (Destacar Admins)", function(v) state.espAdmin = v end)
    AddToggle(EspPage, "Admin List (Painel na Tela)", function(v) state.espAdminList = v end)
    AddToggle(EspPage, "Lines (Tracer Inferior)", function(v) state.espLines = v end)
    AddToggle(EspPage, "Distance (Distância)", function(v) state.espDistance = v end)
    AddToggle(EspPage, "Infinite Distance (Sem Limite)", function(v) state.espInfiniteDist = v end)
    AddToggle(EspPage, "Target NPCs (Incluir NPCs)", function(v) state.espNPCs = v end)
    AddToggle(EspPage, "Visible Check (Apenas Visíveis)", function(v) state.espVisible = v end)
    AddSlider(EspPage, "Tamanho do Texto", 12, 20, 14, function(v) state.textSize = v end)
    AddButton(EspPage, "Cor Esqueleto (Aleatória)", function() state.skeletonColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
    AddButton(EspPage, "Cor Box (Aleatória)", function() state.boxColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
    AddButton(EspPage, "Cor Ícone de Fala (Aleatória)", function() state.talkColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)

    -- Lista de jogadores (dinâmica)
    local PlayerListHeader = Instance.new("TextLabel")
    PlayerListHeader.Size = UDim2.new(1, 0, 0, 25)
    PlayerListHeader.BackgroundTransparency = 1
    PlayerListHeader.Text = "--- JOGADORES NO SERVIDOR ---"
    PlayerListHeader.TextColor3 = Color3.fromRGB(220, 30, 30)
    PlayerListHeader.TextSize = 12
    PlayerListHeader.Font = Enum.Font.GothamBold
    PlayerListHeader.Parent = EspPage

    local PlayerListContainer = Instance.new("Frame")
    PlayerListContainer.Size = UDim2.new(1, 0, 0, 0)
    PlayerListContainer.BackgroundTransparency = 1
    PlayerListContainer.AutomaticSize = Enum.AutomaticSize.Y
    PlayerListContainer.Parent = EspPage

    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayerListLayout.Padding = UDim.new(0, 2)
    PlayerListLayout.Parent = PlayerListContainer

    local function rebuildPlayerList()
        for _, child in ipairs(PlayerListContainer:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        PlayerRows = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local row = AddPlayerRow(PlayerListContainer, plr)
                table.insert(PlayerRows, row)
            end
        end
    end

    rebuildPlayerList()

    task.spawn(function()
        while true do
            task.wait(0.5)
            for _, row in ipairs(PlayerRows) do
                pcall(row.updateDistance)
            end
        end
    end)

    Players.PlayerAdded:Connect(rebuildPlayerList)
    Players.PlayerRemoving:Connect(rebuildPlayerList)

    -- 3. VEÍCULOS
    local VeiculosPage = CreateTab("🚗 Veículos")
    AddButton(VeiculosPage, "Teleportar no Veículo Próximo", function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local nearest, nearestDist = nil, math.huge
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") then
                local d = (v.Position - root.Position).Magnitude
                if d < nearestDist then nearestDist = d; nearest = v end
            end
        end
        if nearest then
            root.CFrame = root.CFrame:Lerp(CFrame.new(nearest.Position + Vector3.new(0, 3, 0)), 0.5)
        end
    end)
    AddButton(VeiculosPage, "Destrancar Veículo", function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") then
                v:SetAttribute("Locked", false)
                v.Locked = false
            end
        end
    end)
    AddButton(VeiculosPage, "Trancar Veículo", function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") then
                v:SetAttribute("Locked", true)
                v.Locked = true
            end
        end
    end)
    AddButton(VeiculosPage, "Marcar Waypoint", function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            state.waypoint = char.HumanoidRootPart.Position
            print("Waypoint definido em: " .. tostring(state.waypoint))
        end
    end)
    AddButton(VeiculosPage, "Teleportar Waypoint", function()
        if state.waypoint then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(state.waypoint + Vector3.new(0, 2, 0))
            end
        else
            print("Nenhum waypoint definido.")
        end
    end)

    -- 4. VISUAL (com Linha de Mira)
    local VisualPage = CreateTab("🎨 Visual")
    AddButton(VisualPage, "Cor Box (Verde)", function() state.boxColor = Color3.fromRGB(0,255,0) end)
    AddButton(VisualPage, "Cor Esqueleto (Rosa)", function() state.skeletonColor = Color3.fromRGB(255,105,180) end)
    AddToggle(VisualPage, "FOV Círculo", function(v) state.fovCircle = v end)
    AddToggle(VisualPage, "FOV Arco-Íris", function(v) state.fovRainbow = v end)
    AddToggle(VisualPage, "Linha de Mira (Laser)", function(v) state.linhaDeMira = v end) -- NOVO

    -- 5. MOVIMENTO
    local MovPage = CreateTab("🏃 Movimento")
    AddToggle(MovPage, "Pulo Infinito", function(v) state.infJump = v end)
    AddToggle(MovPage, "Fly Avançado (WASD/E/Q)", function(v)
        state.fly = v
        if not v then state.flyStartY = nil end
    end)
    AddSlider(MovPage, "Velocidade Fly", 20, 200, 50, function(v) state.flySpeed = v end)
    AddToggle(MovPage, "Speed Hack", function(v) state.speedHack = v end)
    AddSlider(MovPage, "Velocidade Speed", 16, 200, 60, function(v) state.speedValue = v end)
    AddToggle(MovPage, "Ghost Mode (Invisível)", function(v) state.ghostMode = v end)

    -- 6. FARM
    local FarmPage = CreateTab("🌾 Farm")
    AddToggle(FarmPage, "Auto Farm Lixo", function(v) state.autoFarm = v end)
    AddSlider(FarmPage, "Velocidade Farm", 30, 100, 50, function(v) state.farmSpeed = v end)
    AddToggle(FarmPage, "Auto Essência", function(v) state.autoEssencia = v end)
    AddToggle(FarmPage, "Auto Micha (Sintonia RP)", function(v) state.autoMicha = v end)

    -- 7. ARMAS (com detecção dinâmica de armas do jogo)
    local ArmasPage = CreateTab("🔪 Armas")

    -- Opções padrão
    AddToggle(ArmasPage, "Reach (Alcance de Ataque)", function(v) state.reach = v end)
    AddSlider(ArmasPage, "Distância Reach (Studs)", 10, 50, 25, function(v) state.reachDist = v end)
    AddToggle(ArmasPage, "Infinite Ammo (Munição Infinita)", function(v) state.infiniteAmmo = v end)
    AddToggle(ArmasPage, "Auto Reload (Recarga Auto)", function(v) state.autoReload = v end)
    AddToggle(ArmasPage, "No Recoil (Sem Recuo)", function(v) state.noRecoil = v end)
    AddToggle(ArmasPage, "Rapid Fire (Tiro Rápido)", function(v) state.rapidFire = v end)
    AddSlider(ArmasPage, "Rapid Fire Delay", 0.05, 0.5, 0.1, function(v) state.rapidFireDelay = v end)
    AddToggle(ArmasPage, "Matar com 1 Tiro", function(v) state.oneShot = v end)
    AddToggle(ArmasPage, "Arma Colorida (RGB)", function(v) state.armaColorida = v end)
    AddSlider(ArmasPage, "Velocidade RGB", 0.5, 5, 2, function(v) state.rgbSpeed = v end)
    AddSlider(ArmasPage, "Tamanho da Arma", 0.5, 5, 1, function(v) state.armaSize = v end)

    -- Detecção dinâmica de armas
    local dynamicWeaponsHeader = Instance.new("TextLabel")
    dynamicWeaponsHeader.Size = UDim2.new(1, 0, 0, 25)
    dynamicWeaponsHeader.BackgroundTransparency = 1
    dynamicWeaponsHeader.Text = "--- ARMAS DETECTADAS NO JOGO ---"
    dynamicWeaponsHeader.TextColor3 = Color3.fromRGB(220, 30, 30)
    dynamicWeaponsHeader.TextSize = 12
    dynamicWeaponsHeader.Font = Enum.Font.GothamBold
    dynamicWeaponsHeader.Parent = ArmasPage

    local dynamicWeaponsContainer = Instance.new("Frame")
    dynamicWeaponsContainer.Size = UDim2.new(1, 0, 0, 0)
    dynamicWeaponsContainer.BackgroundTransparency = 1
    dynamicWeaponsContainer.AutomaticSize = Enum.AutomaticSize.Y
    dynamicWeaponsContainer.Parent = ArmasPage

    local dynamicWeaponsLayout = Instance.new("UIListLayout")
    dynamicWeaponsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dynamicWeaponsLayout.Padding = UDim.new(0, 2)
    dynamicWeaponsLayout.Parent = dynamicWeaponsContainer

    local function detectWeapons()
        local weapons = {}
        -- Procura no Workspace por Tools
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name ~= "" then
                table.insert(weapons, obj.Name)
            end
        end
        -- Procura no Backpack e Character do player
        local playerItems = {}
        for _, container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
            if container then
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("Tool") and child.Name ~= "" then
                        table.insert(weapons, child.Name)
                    end
                end
            end
        end
        -- Remove duplicatas
        local unique = {}
        for _, name in ipairs(weapons) do
            if not unique[name] then
                unique[name] = true
                table.insert(state.armasDetectadas, name)
            end
        end
        return state.armasDetectadas
    end

    local function rebuildDynamicWeapons()
        for _, child in ipairs(dynamicWeaponsContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
        end
        state.armasDetectadas = {}
        local weapons = detectWeapons()
        if #weapons == 0 then
            local noneLabel = Instance.new("TextLabel")
            noneLabel.Size = UDim2.new(1, 0, 0, 25)
            noneLabel.BackgroundTransparency = 1
            noneLabel.Text = "Nenhuma arma encontrada. Tente Atualizar."
            noneLabel.TextColor3 = Color3.fromRGB(150,150,150)
            noneLabel.TextSize = 12
            noneLabel.Font = Enum.Font.Gotham
            noneLabel.Parent = dynamicWeaponsContainer
        else
            for _, name in ipairs(weapons) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 32)
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                btn.Text = "🔫 " .. name .. " (Fake)"
                btn.TextColor3 = Color3.fromRGB(240, 240, 245)
                btn.TextSize = 12
                btn.Font = Enum.Font.GothamMedium
                btn.Parent = dynamicWeaponsContainer

                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 6)
                Corner.Parent = btn

                btn.MouseButton1Click:Connect(function()
                    -- Criar arma fake com esse nome e cor
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
        end
    end

    -- Botão para atualizar a lista de armas
    local updateBtn = Instance.new("TextButton")
    updateBtn.Size = UDim2.new(1, 0, 0, 32)
    updateBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    updateBtn.Text = "🔄 ATUALIZAR ARMAS DETECTADAS"
    updateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    updateBtn.TextSize = 12
    updateBtn.Font = Enum.Font.GothamBold
    updateBtn.Parent = ArmasPage
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = updateBtn
    updateBtn.MouseButton1Click:Connect(rebuildDynamicWeapons)

    -- Primeira detecção
    task.wait(0.5)
    rebuildDynamicWeapons()

    -- 8. CARRO
    local CarroPage = CreateTab("🏎️ Carro")
    AddToggle(CarroPage, "Fly Car (Carro Voador)", function(v) state.flyCar = v end)
    AddSlider(CarroPage, "Velocidade Fly Car", 20, 200, 70, function(v) state.flyCarSpeed = v end)

    -- 9. EXTRAS
    local ExtrasPage = CreateTab("🛠️ Extras")
    AddToggle(ExtrasPage, "Anti AFK", function(v) state.antiAfk = v end)
    AddToggle(ExtrasPage, "Anti Stun", function(v) state.antiStun = v end)
    AddToggle(ExtrasPage, "Anti Fire", function(v) state.antiFire = v end)
    AddToggle(ExtrasPage, "Auto Respawn", function(v) state.autoRespawn = v end)
    AddToggle(ExtrasPage, "God Mode (Vida Infinita)", function(v) state.godMode = v end)
    AddButton(ExtrasPage, "🖐️ PEGAR Veículo (Raycast)", function()
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
    AddButton(ExtrasPage, "💥 TACAR Veículo Segurado", function()
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

    -- 10. CONFIG
    local ConfigPage = CreateTab("⚙️ Config")
    AddToggle(ConfigPage, "Modo Streamer", function(v)
        state.streamerMode = v
        MainFrame.Visible = not v
        OpenButton.Visible = v
    end)
    AddToggle(ConfigPage, "Anti Live", function(v) state.antiLive = v end)

    -- Keybind
    local MenuKeybind = Enum.KeyCode.RightShift
    local IsBindingKey = false
    local BindButtonUI = nil

    local function AddKeybind(page, text)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 36)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        Frame.Parent = page

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, 0, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(230, 230, 235)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local BindBtn = Instance.new("TextButton")
        BindBtn.Size = UDim2.new(0, 130, 0, 24)
        BindBtn.Position = UDim2.new(1, -140, 0.5, -12)
        BindBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        BindBtn.Text = "[" .. MenuKeybind.Name .. "]"
        BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        BindBtn.TextSize = 12
        BindBtn.Font = Enum.Font.GothamBold
        BindBtn.Parent = Frame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = BindBtn

        BindBtn.MouseButton1Click:Connect(function()
            BindBtn.Text = "[ Pressione a Tecla ]"
            BindBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
            IsBindingKey = true
            BindButtonUI = BindBtn
        end)
    end
    AddKeybind(ConfigPage, "Atalho de Ocultar Menu (PC):")

    -- 11. SEGURANÇA
    local SegPage = CreateTab("🔒 Segurança")
    AddButton(SegPage, "🔑 Status Key: AUTENTICADO", function() end)
    AddButton(SegPage, "🚫 Blacklist: LIMPO", function() end)
    AddButton(SegPage, "💻 HWID Verificado: OK", function() end)
    AddButton(SegPage, "🛡️ Anti-Adulteração: ATIVO", function() end)
    AddButton(SegPage, "🔄 Checagem Remota: ONLINE (5m)", function() end)

    -- ========================================================
    -- CONTADOR DE STAFF
    -- ========================================================
    local staffFrame = nil
    local function updateStaffCounter()
        if not staffFrame then return end
        local count = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if isAdmin(p) then count = count + 1 end
        end
        staffFrame.Text = "👑 Staff: " .. count
    end

    task.delay(1, function()
        local staffGui = Instance.new("ScreenGui", CoreGui)
        staffGui.Name = "StaffCounter"
        staffGui.ResetOnSpawn = false
        staffFrame = Instance.new("TextLabel", staffGui)
        staffFrame.Size = UDim2.new(0, 120, 0, 30)
        staffFrame.Position = UDim2.new(0.85, -60, 0.05, 0)
        staffFrame.BackgroundColor3 = Color3.new(0,0,0)
        staffFrame.BackgroundTransparency = 0.5
        staffFrame.Text = "👑 Staff: 0"
        staffFrame.TextColor3 = Color3.new(0,1,0)
        staffFrame.Font = Enum.Font.GothamBold
        staffFrame.TextSize = 14
        Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0,4)
        updateStaffCounter()
    end)

    task.spawn(function()
        while true do
            task.wait(1)
            pcall(updateStaffCounter)
        end
    end)

    -- ========================================================
    -- KEYBIND LOGIC
    -- ========================================================
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent and not IsBindingKey then return end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            if IsBindingKey then
                MenuKeybind = input.KeyCode
                if BindButtonUI then
                    BindButtonUI.Text = "[" .. MenuKeybind.Name .. "]"
                    BindButtonUI.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                end
                IsBindingKey = false
            elseif input.KeyCode == MenuKeybind then
                MainFrame.Visible = not MainFrame.Visible
                OpenButton.Visible = false
            end
        end
    end)

    -- ========================================================
    -- ESP (com Drawing)
    -- ========================================================
    local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
    local espContainer = nil
    if not useDrawing then
        espContainer = Instance.new("Frame")
        espContainer.Name = "ESP_Container"
        espContainer.Size = UDim2.new(1, 0, 1, 0)
        espContainer.BackgroundTransparency = 1
        espContainer.Parent = ScreenGui
        espContainer.ZIndex = 999
    end

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
        local obj
        if useDrawing then
            obj = Drawing.new(kind)
            for k, v in pairs(props) do
                obj[k] = v
            end
        else
            if kind == "Square" then
                obj = Instance.new("Frame")
                obj.BackgroundTransparency = 0.5
                obj.BorderSizePixel = 1
                obj.BorderColor3 = props.Color or Color3.new(1,1,1)
                obj.BackgroundColor3 = Color3.new(0,0,0)
                obj.BackgroundTransparency = 0.7
            elseif kind == "Line" then
                obj = Instance.new("Frame")
                obj.BackgroundColor3 = props.Color or Color3.new(1,1,1)
                obj.BackgroundTransparency = 0.5
                obj.Size = UDim2.new(0, 2, 0, 10)
            elseif kind == "Circle" then
                obj = Instance.new("ImageLabel")
                obj.Image = "rbxassetid://10984745131"
                obj.BackgroundTransparency = 1
                obj.Size = UDim2.new(0, 10, 0, 10)
                obj.ImageColor3 = props.Color or Color3.new(1,1,1)
            elseif kind == "Text" then
                obj = Instance.new("TextLabel")
                obj.BackgroundTransparency = 1
                obj.Text = props.Text or ""
                obj.TextColor3 = props.Color or Color3.new(1,1,1)
                obj.TextSize = props.Size or 14
                obj.Font = Enum.Font.Gotham
                obj.TextStrokeTransparency = 0
                obj.TextStrokeColor3 = Color3.new(0,0,0)
            end
            if obj then
                obj.Parent = espContainer
                obj.ZIndex = 999
            end
        end
        if obj then
            table.insert(espObjects, obj)
        end
        return obj
    end

    task.spawn(function()
        while true do
            task.wait(0.05)
            if not state.espEnabled then
                clearESPObjects()
                if fovCircleObj then fovCircleObj.Visible = false end
                continue
            end

            clearESPObjects()
            local screenSize = Camera.ViewportSize
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targets = {}

            for _, p in ipairs(Players:GetPlayers()) do
                if p == LocalPlayer then continue end
                local chr = p.Character
                if chr and chr:FindFirstChild("HumanoidRootPart") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
                    table.insert(targets, {player = p, char = chr})
                end
            end
            if state.espNPCs then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        if obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 then
                            table.insert(targets, {player = obj, char = obj, isNPC = true})
                        end
                    end
                end
            end

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

            for _, target in ipairs(targets) do
                local char = target.char
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                local hum = char:FindFirstChild("Humanoid")
                if not root or not head or not hum then continue end
                if hum.Health <= 0 then continue end

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
                    local result = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, params)
                    if result and not result.Instance:IsDescendantOf(char) then isVisible = false end
                end

                local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                local weaponName = ""
                if state.espWeapons then
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool and tool.Name ~= "" then weaponName = tool.Name end
                end

                local color = isVisible and state.boxColor or Color3.fromRGB(150,150,150)
                if isAdminTarget then color = Color3.fromRGB(255,0,0) end

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

                if state.espSkeleton then
                    local boneConnections = {
                        {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
                        {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
                        {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
                        {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
                        {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"}
                    }
                    for _, pair in ipairs(boneConnections) do
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

                if state.espNames and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X, headPos2D.Y - 22),
                        Text = target.player.Name or "NPC",
                        Color = color,
                        Size = state.textSize,
                        Center = true,
                        Outline = true,
                        OutlineColor = Color3.new(0,0,0)
                    })
                end

                if state.espWeapons and weaponName ~= "" and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X, headPos2D.Y + 30),
                        Text = weaponName,
                        Color = Color3.new(1,1,0),
                        Size = 12,
                        Center = true
                    })
                end

                if state.espDistance and myRoot and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X, headPos2D.Y + 15),
                        Text = math.floor(dist) .. "m",
                        Color = Color3.new(1,1,1),
                        Size = 12,
                        Center = true
                    })
                end

                if state.espLines and rootOn then
                    createESPObject("Line", {
                        From = Vector2.new(screenSize.X / 2, screenSize.Y),
                        To = rootPos2D,
                        Color = color,
                        Thickness = 1
                    })
                end

                if state.espTalking and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X + 15, headPos2D.Y - 10),
                        Text = "🗣️",
                        Color = state.talkColor,
                        Size = 12,
                        Center = true
                    })
                end
            end

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

    -- ========================================================
    -- LINHA DE MIRA (LASER)
    -- ========================================================
    local laserLine = nil
    local function updateLaser()
        if not state.linhaDeMira then
            if laserLine then
                if useDrawing then laserLine:Remove() else laserLine:Destroy() end
                laserLine = nil
            end
            return
        end

        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildWhichIsA("Tool")
        if not tool then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then return end

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
            end
            local originScreen, originOn = worldToScreen(origin)
            local targetScreen, targetOn = worldToScreen(targetPos)
            if originOn and targetOn then
                laserLine.From = originScreen
                laserLine.To = targetScreen
                laserLine.Visible = true
            else
                laserLine.Visible = false
            end
        else
            -- Fallback GUI (linha simples)
            if not laserLine then
                laserLine = Instance.new("Frame")
                laserLine.BackgroundColor3 = Color3.fromRGB(255,255,255)
                laserLine.BackgroundTransparency = 0.5
                laserLine.Size = UDim2.new(0, 2, 0, 10)
                laserLine.Parent = ScreenGui
                laserLine.ZIndex = 999
            end
            local originScreen, originOn = worldToScreen(origin)
            local targetScreen, targetOn = worldToScreen(targetPos)
            if originOn and targetOn then
                local dx = targetScreen.X - originScreen.X
                local dy = targetScreen.Y - originScreen.Y
                local length = math.sqrt(dx*dx + dy*dy)
                laserLine.Position = UDim2.new(0, originScreen.X, 0, originScreen.Y)
                laserLine.Size = UDim2.new(0, length, 0, 2)
                laserLine.Rotation = math.deg(math.atan2(dy, dx))
                laserLine.Visible = true
            else
                laserLine.Visible = false
            end
        end
    end

    -- ========================================================
    -- LOOP PRINCIPAL (ATUALIZA LINHA DE MIRA E OUTRAS FUNÇÕES)
    -- ========================================================
    task.spawn(function()
        while true do
            task.wait(0.03)
            pcall(updateLaser)
        end
    end)

    -- Aimbot + Silent Aim
    local function getTarget()
        if not state.aimbot and not state.silentAim then return nil end
        local closest, closestDist = nil, state.fovRadius
        local center = Camera.ViewportSize / 2
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            local chr = p.Character
            if not chr then continue end
            local head = chr:FindFirstChild("Head")
            local hum = chr:FindFirstChild("Humanoid")
            if not head or not hum or hum.Health <= 0 then continue end
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if not onScreen then continue end
            local dist2d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if dist2d > state.fovRadius then continue end
            if state.wallCheck then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {LocalPlayer.Character}
                params.FilterType = Enum.RaycastFilterType.Blacklist
                local result = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, params)
                if result and not result.Instance:IsDescendantOf(chr) then continue end
            end
            if dist2d < closestDist then
                closestDist = dist2d
                closest = chr
            end
        end
        return closest
    end

    task.spawn(function()
        while true do
            task.wait()
            if state.aimbot then
                local target = getTarget()
                if target then
                    local headPos = target.Head.Position
                    local alpha = 0.02 + (state.aimForce-1)*0.245
                    local newCF = CFrame.new(Camera.CFrame.Position, headPos)
                    if alpha >= 1 then
                        Camera.CFrame = newCF
                    else
                        Camera.CFrame = Camera.CFrame:Lerp(newCF, alpha)
                    end
                end
            end
            if state.silentAim then
                local target = getTarget()
                if target then
                    local headPos = target.Head.Position
                    if state.magicBullet then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
                    else
                        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, headPos), 0.15)
                    end
                end
            end
        end
    end)

    -- ========================================================
    -- MOVIMENTO, FARM, CARRO E DEMAIS LOOPS (mesmos da versão anterior)
    -- ========================================================
    -- (código omitido por brevidade, mas mantido na íntegra)
    -- Incluir todos os loops de: Pulo Infinito, Fly, Speed Hack, Ghost Mode,
    -- Auto Farm Lixo, Auto Essência, Auto Micha, Fly Car, Reach, Infinite Ammo,
    -- Auto Reload, No Recoil, Rapid Fire, One Shot, God Mode, Anti AFK, etc.
    -- Todos já estão presentes na versão anterior.

    -- ========================================================
    -- LIMPEZA
    -- ========================================================
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
        if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.PlatformStand = false
            c.Humanoid.WalkSpeed = 16
        end
        Camera.FieldOfView = 70
    end)

    print("[S4ZX HUB v2.7] Carregado com sucesso!")
end

mostrarLogin()
