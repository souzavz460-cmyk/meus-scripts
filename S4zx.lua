-- ============================================================
-- S4ZX HUB v2.9 COMPLETO - INTERFACE CORRIGIDA
-- ============================================================

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
    local VoiceChatService = game:GetService("VoiceChatService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    if CoreGui:FindFirstChild("S4ZX_Hub_v25") then
        CoreGui.S4ZX_Hub_v25:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "S4ZX_Hub_v25"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- ============================================================
    -- VARIÁVEIS DE ESTADO (COMPLETO COM TODAS AS NOVAS)
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
        aimPart = "Head",
        aimPriority = "Distance",
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
        saFovColor = Color3.fromRGB(54, 57, 241),
        saTargetColor = Color3.fromRGB(54, 57, 241),

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
        armasDetectadas = {},
        micConnection = nil,
        carClone = nil,
        moneyLoop = nil,
        jobLoop = nil,
    }

    -- ============================================================
    -- UTILITÁRIOS
    -- ============================================================
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

    -- ============================================================
    -- INTERFACE PRINCIPAL
    -- ============================================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 820, 0, 490)
    MainFrame.Position = UDim2.new(0.5, -410, 0.5, -245)
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

    -- ============================================================
    -- PAINEL LATERAL
    -- ============================================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 200, 1, 0)
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
    VersionText.Text = "VERSION 2.9 COMPLETA"
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

    -- ============================================================
    -- HEADER E ÁREA DE CONTEÚDO
    -- ============================================================
    local HeaderBar = Instance.new("Frame")
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Size = UDim2.new(1, -200, 0, 40)
    HeaderBar.Position = UDim2.new(0, 200, 0, 0)
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
    ContentArea.Size = UDim2.new(1, -210, 1, -50)
    ContentArea.Position = UDim2.new(0, 205, 0, 45)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    -- ============================================================
    -- COMPONENTES DA INTERFACE
    -- ============================================================
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

    local function AddCycle(page, text, options, defaultIndex, callback)
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

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 130, 0, 24)
        Btn.Position = UDim2.new(1, -140, 0.5, -12)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        Btn.Text = options[defaultIndex]
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.TextSize = 12
        Btn.Font = Enum.Font.GothamBold
        Btn.Parent = Frame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = Btn

        local currentIdx = defaultIndex
        Btn.MouseButton1Click:Connect(function()
            currentIdx = currentIdx % #options + 1
            Btn.Text = options[currentIdx]
            pcall(callback, options[currentIdx])
        end)
        return Btn
    end

    local function AddInput(page, text, placeholder, callback)
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

        local InputBox = Instance.new("TextBox")
        InputBox.Size = UDim2.new(0, 150, 0, 24)
        InputBox.Position = UDim2.new(1, -160, 0.5, -12)
        InputBox.PlaceholderText = placeholder or ""
        InputBox.Text = ""
        InputBox.TextColor3 = Color3.fromRGB(255,255,255)
        InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        InputBox.Font = Enum.Font.Gotham
        InputBox.TextSize = 12
        InputBox.ClearTextOnFocus = false
        InputBox.Parent = Frame

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = InputBox

        InputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                pcall(callback, InputBox.Text)
            end
        end)
    end

    -- ============================================================
    -- PLAYER ROW
    -- ============================================================
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

    -- ============================================================
    -- CONSTRUÇÃO DAS ABAS
    -- ============================================================
    local AimbotPage = CreateTab("🎯 Aimbot")

    AddToggle(AimbotPage, "AIMBOT", function(v) state.aimbot = v end)
    AddSlider(AimbotPage, "Força da Mira", 1, 5, 3, function(v) state.aimForce = v end)
    AddSlider(AimbotPage, "Bypass", 1, 10, 5, function(v) state.bypass = v end)
    AddSlider(AimbotPage, "FOV Raio", 50, 500, 150, function(v) state.fovRadius = v end)
    AddToggle(AimbotPage, "WALLCK", function(v) state.wallCheck = v end)

    AddToggle(AimbotPage, "Aimbot com Lead", function(v) state.aimbotLead = v end)
    AddSlider(AimbotPage, "Multiplicador de Lead", 1, 5, 1, function(v) state.leadMultiplier = v end)

    AddCycle(AimbotPage, "Parte do Corpo", {"Cabeça", "Peito", "Perna", "Braço"}, 1, function(v) state.aimPart = v end)
    AddCycle(AimbotPage, "Prioridade", {"Distância", "Saúde", "Visibilidade", "Nome Específico"}, 1, function(v) state.aimPriority = v end)
    AddInput(AimbotPage, "Nome Alvo Prioritário", "Digite o nome", function(v) state.priorityName = v end)

    -- SILENT AIM
    AddToggle(AimbotPage, "SILENT AIM", function(v) state.silentAim = v end)
    AddToggle(AimbotPage, "Magic Bullet", function(v) state.magicBullet = v end)
    AddToggle(AimbotPage, "Team Check (Silent)", function(v) state.saTeamCheck = v end)
    AddToggle(AimbotPage, "Visible Check (Silent)", function(v) state.saVisibleCheck = v end)
    AddSlider(AimbotPage, "Hit Chance (%)", 0, 100, 100, function(v) state.saHitChance = v end)
    AddToggle(AimbotPage, "Predição (Silent)", function(v) state.saMousePrediction = v end)
    AddSlider(AimbotPage, "Predição Amount", 0.165, 1, 0.165, function(v) state.saPredictionAmount = v end)
    AddCycle(AimbotPage, "Método Silent", {"Raycast","FindPartOnRay","FindPartOnRayWithWhitelist","FindPartOnRayWithIgnoreList","Mouse.Hit/Target"}, 1, function(v) state.saMethod = v end)
    AddCycle(AimbotPage, "Parte Alvo (Silent)", {"Head", "HumanoidRootPart", "Random"}, 2, function(v) state.saTargetPart = v end)
    AddToggle(AimbotPage, "Mostrar FOV Circle (Silent)", function(v) state.saFovVisible = v end)
    AddSlider(AimbotPage, "FOV Radius (Silent)", 50, 360, 130, function(v) state.saFovRadius = v end)
    AddToggle(AimbotPage, "Mostrar Alvo (Silent)", function(v) state.saShowTarget = v end)

    -- =================== ESP ===================
    local EspPage = CreateTab("👁️ ESP")
    AddToggle(EspPage, "Ativar ESP (Geral)", function(v) state.espEnabled = v end)
    AddToggle(EspPage, "Box", function(v) state.espBox = v end)
    AddToggle(EspPage, "Names", function(v) state.espNames = v end)
    AddToggle(EspPage, "Weapons", function(v) state.espWeapons = v end)
    AddToggle(EspPage, "Talking Icon", function(v) state.espTalking = v end)
    AddToggle(EspPage, "Skeleton", function(v) state.espSkeleton = v end)
    AddToggle(EspPage, "Admin ESP", function(v) state.espAdmin = v end)
    AddToggle(EspPage, "Admin List", function(v) state.espAdminList = v end)
    AddToggle(EspPage, "Lines", function(v) state.espLines = v end)
    AddToggle(EspPage, "Distance", function(v) state.espDistance = v end)
    AddToggle(EspPage, "Infinite Distance", function(v) state.espInfiniteDist = v end)
    AddToggle(EspPage, "Target NPCs", function(v) state.espNPCs = v end)
    AddToggle(EspPage, "Visible Check", function(v) state.espVisible = v end)
    AddToggle(EspPage, "ESP de Mira do Inimigo", function(v) state.espEnemyAim = v end)
    AddSlider(EspPage, "Tamanho do Texto", 12, 20, 14, function(v) state.textSize = v end)
    AddButton(EspPage, "Cor Esqueleto (Aleatória)", function() state.skeletonColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
    AddButton(EspPage, "Cor Box (Aleatória)", function() state.boxColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
    AddButton(EspPage, "Cor Ícone de Fala (Aleatória)", function() state.talkColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)

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

    -- =================== Veículos ===================
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
    AddToggle(VeiculosPage, "Super Velocidade no Carro", function(v) state.superCarSpeed = v end)
    AddSlider(VeiculosPage, "Velocidade Super Carro", 50, 500, 100, function(v) state.superCarSpeedValue = v end)
    AddToggle(VeiculosPage, "Clonar Carro", function(v)
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

    -- =================== Visual ===================
    local VisualPage = CreateTab("🎨 Visual")
    AddButton(VisualPage, "Cor Box (Verde)", function() state.boxColor = Color3.fromRGB(0,255,0) end)
    AddButton(VisualPage, "Cor Esqueleto (Rosa)", function() state.skeletonColor = Color3.fromRGB(255,105,180) end)
    AddToggle(VisualPage, "FOV Círculo", function(v) state.fovCircle = v end)
    AddToggle(VisualPage, "FOV Arco-Íris", function(v) state.fovRainbow = v end)
    AddToggle(VisualPage, "🔦 Laser (Linha de Tiro)", function(v) state.linhaDeMira = v end)

    -- =================== Movimento ===================
    local MovPage = CreateTab("🏃 Movimento")
    AddToggle(MovPage, "Pulo Infinito", function(v) state.infJump = v end)
    AddToggle(MovPage, "Fly Avançado (WASD/E/Q)", function(v)
        state.fly = v
        if not v then state.flyStartY = nil end
    end)
    AddSlider(MovPage, "Velocidade Fly", 20, 200, 50, function(v) state.flySpeed = v end)
    AddToggle(MovPage, "Speed Hack", function(v) state.speedHack = v end)
    AddSlider(MovPage, "Velocidade Speed", 16, 200, 60, function(v) state.speedValue = v end)
    AddToggle(MovPage, "Ghost Mode", function(v) state.ghostMode = v end)
    AddToggle(MovPage, "Derrubar Player", function(v) state.derrubarPlayer = v end)

    -- =================== Farm ===================
    local FarmPage = CreateTab("🌾 Farm")
    AddToggle(FarmPage, "Auto Farm Lixo", function(v) state.autoFarm = v end)
    AddSlider(FarmPage, "Velocidade Farm", 30, 100, 50, function(v) state.farmSpeed = v end)
    AddToggle(FarmPage, "Auto Essência", function(v) state.autoEssencia = v end)
    AddToggle(FarmPage, "Auto Micha", function(v) state.autoMicha = v end)

    -- =================== Armas ===================
    local ArmasPage = CreateTab("🔪 Armas")
    AddToggle(ArmasPage, "Reach", function(v) state.reach = v end)
    AddSlider(ArmasPage, "Distância Reach", 10, 50, 25, function(v) state.reachDist = v end)
    AddToggle(ArmasPage, "Infinite Ammo", function(v) state.infiniteAmmo = v end)
    AddToggle(ArmasPage, "Auto Reload", function(v) state.autoReload = v end)
    AddToggle(ArmasPage, "No Recoil", function(v) state.noRecoil = v end)
    AddToggle(ArmasPage, "Rapid Fire", function(v) state.rapidFire = v end)
    AddSlider(ArmasPage, "Rapid Fire Delay", 0.05, 0.5, 0.1, function(v) state.rapidFireDelay = v end)
    AddToggle(ArmasPage, "Matar com 1 Tiro", function(v) state.oneShot = v end)
    AddToggle(ArmasPage, "Arma Colorida (RGB)", function(v) state.armaColorida = v end)
    AddSlider(ArmasPage, "Velocidade RGB", 0.5, 5, 2, function(v) state.rgbSpeed = v end)
    AddSlider(ArmasPage, "Tamanho da Arma", 0.5, 5, 1, function(v) state.armaSize = v end)
    AddToggle(ArmasPage, "Roubar P1", function(v) state.roubarP1 = v end)
    AddToggle(ArmasPage, "Roubar P2", function(v) state.roubarP2 = v end)

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
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name ~= "" then
                table.insert(weapons, obj.Name)
            end
        end
        for _, container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
            if container then
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("Tool") and child.Name ~= "" then
                        table.insert(weapons, child.Name)
                    end
                end
            end
        end
        local unique = {}
        local result = {}
        for _, name in ipairs(weapons) do
            if not unique[name] then
                unique[name] = true
                table.insert(result, name)
            end
        end
        return result
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
            noneLabel.Text = "Nenhuma arma encontrada."
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

    task.wait(0.5)
    rebuildDynamicWeapons()

    -- =================== Carro ===================
    local CarroPage = CreateTab("🏎️ Carro")
    AddToggle(CarroPage, "Fly Car", function(v) state.flyCar = v end)
    AddSlider(CarroPage, "Velocidade Fly Car", 20, 200, 70, function(v) state.flyCarSpeed = v end)

    -- =================== Extras ===================
    local ExtrasPage = CreateTab("🛠️ Extras")
    AddToggle(ExtrasPage, "Anti AFK", function(v) state.antiAfk = v end)
    AddToggle(ExtrasPage, "Anti Stun", function(v) state.antiStun = v end)
    AddToggle(ExtrasPage, "Anti Fire", function(v) state.antiFire = v end)
    AddToggle(ExtrasPage, "Auto Respawn", function(v) state.autoRespawn = v end)
    AddToggle(ExtrasPage, "God Mode", function(v) state.godMode = v end)
    AddToggle(ExtrasPage, "🎙️ Microfone Global", function(v)
        state.micGlobal = v
        if v then
            if VoiceChatService and VoiceChatService:IsEnabled() then
                VoiceChatService:SetVoiceEnabled(true)
                VoiceChatService:SetOutputVolume(100)
                VoiceChatService:SetInputVolume(100)
                pcall(function() VoiceChatService:SetSpatialVoiceEnabled(false) end)
            end
        else
            if VoiceChatService then
                VoiceChatService:SetVoiceEnabled(false)
                pcall(function() VoiceChatService:SetSpatialVoiceEnabled(true) end)
            end
        end
    end)

    -- Money Hack
    AddToggle(ExtrasPage, "Money Hack (Auto)", function(v)
        state.moneyHack = v
        if v then
            state.moneyLoop = task.spawn(function()
                while state.moneyHack do
                    task.wait(0.5)
                    local args = {
                        [1] = "GiveCash",
                        [2] = state.moneyValue
                    }
                    pcall(function()
                        game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FireServer(unpack(args))
                    end)
                end
            end)
        else
            if state.moneyLoop then task.cancel(state.moneyLoop) end
        end
    end)
    AddSlider(ExtrasPage, "Valor do Dinheiro", 1000, 9999999, 100000, function(v) state.moneyValue = v end)

    -- Pegar Emprego
    local jobsHeader = Instance.new("TextLabel")
    jobsHeader.Size = UDim2.new(1, 0, 0, 25)
    jobsHeader.BackgroundTransparency = 1
    jobsHeader.Text = "--- EMPREGOS DETECTADOS ---"
    jobsHeader.TextColor3 = Color3.fromRGB(220, 30, 30)
    jobsHeader.TextSize = 12
    jobsHeader.Font = Enum.Font.GothamBold
    jobsHeader.Parent = ExtrasPage

    local jobsContainer = Instance.new("Frame")
    jobsContainer.Size = UDim2.new(1, 0, 0, 0)
    jobsContainer.BackgroundTransparency = 1
    jobsContainer.AutomaticSize = Enum.AutomaticSize.Y
    jobsContainer.Parent = ExtrasPage
    local jobsLayout = Instance.new("UIListLayout", jobsContainer)
    jobsLayout.Padding = UDim.new(0, 2)

    local function detectJobs()
        local jobs = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled then
                local name = obj.Parent and obj.Parent.Name
                if name and name ~= "" then
                    table.insert(jobs, name)
                end
            end
        end
        local unique = {}
        local result = {}
        for _, n in ipairs(jobs) do
            if not unique[n] then
                unique[n] = true
                table.insert(result, n)
            end
        end
        return result
    end

    local function rebuildJobsUI()
        for _, child in ipairs(jobsContainer:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
        end
        local jobs = detectJobs()
        if #jobs == 0 then
            local none = Instance.new("TextLabel")
            none.Size = UDim2.new(1,0,0,25)
            none.BackgroundTransparency = 1
            none.Text = "Nenhum emprego encontrado."
            none.TextColor3 = Color3.fromRGB(150,150,150)
            none.Font = Enum.Font.Gotham
            none.TextSize = 12
            none.Parent = jobsContainer
        else
            for _, name in ipairs(jobs) do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,0,0,32)
                btn.BackgroundColor3 = Color3.fromRGB(25,25,32)
                btn.Text = "💼 " .. name
                btn.TextColor3 = Color3.fromRGB(240,240,245)
                btn.TextSize = 12
                btn.Font = Enum.Font.GothamMedium
                btn.Parent = jobsContainer
                local Corner = Instance.new("UICorner", btn)
                Corner.CornerRadius = UDim.new(0,6)

                btn.MouseButton1Click:Connect(function()
                    state.autoJob = true
                    state.selectedJob = name
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
                                    root.CFrame = CFrame.new(pos + Vector3.new(0,2,0))
                                    task.wait(0.2)
                                    pcall(function() fireproximityprompt(obj) end)
                                    break
                                end
                            end
                        end
                    end)
                end)
            end
        end
    end

    local refreshJobsBtn = Instance.new("TextButton")
    refreshJobsBtn.Size = UDim2.new(1,0,0,32)
    refreshJobsBtn.BackgroundColor3 = Color3.fromRGB(40,40,48)
    refreshJobsBtn.Text = "🔄 ATUALIZAR EMPREGOS"
    refreshJobsBtn.TextColor3 = Color3.fromRGB(255,255,255)
    refreshJobsBtn.Font = Enum.Font.GothamBold
    refreshJobsBtn.TextSize = 12
    refreshJobsBtn.Parent = ExtrasPage
    Instance.new("UICorner", refreshJobsBtn).CornerRadius = UDim.new(0,6)
    refreshJobsBtn.MouseButton1Click:Connect(rebuildJobsUI)

    task.wait(1)
    rebuildJobsUI()

    -- Pegar e Tacar veículo
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

    -- =================== Config ===================
    local ConfigPage = CreateTab("⚙️ Config")
    AddToggle(ConfigPage, "Modo Streamer", function(v)
        state.streamerMode = v
        MainFrame.Visible = not v
        OpenButton.Visible = v
    end)
    AddToggle(ConfigPage, "Anti Live", function(v) state.antiLive = v end)
    AddToggle(ConfigPage, "Atalhos Rápidos (CTRL+1 a 0)", function(v) state.shortcutsEnabled = v end)

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

    local SegPage = CreateTab("🔒 Segurança")
    AddButton(SegPage, "🔑 Status Key: AUTENTICADO", function() end)
    AddButton(SegPage, "🚫 Blacklist: LIMPO", function() end)
    AddButton(SegPage, "💻 HWID Verificado: OK", function() end)
    AddButton(SegPage, "🛡️ Anti-Adulteração: ATIVO", function() end)
    AddButton(SegPage, "🔄 Checagem Remota: ONLINE (5m)", function() end)

    -- ============================================================
    -- CONTADOR DE STAFF
    -- ============================================================
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

    -- ============================================================
    -- KEYBIND E ATALHOS
    -- ============================================================
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

            -- Atalhos CTRL+1..0
            if state.shortcutsEnabled and input.KeyCode >= Enum.KeyCode.One and input.KeyCode <= Enum.KeyCode.Zero then
                if input.KeyCode == Enum.KeyCode.One and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.aimbot = not state.aimbot end
                if input.KeyCode == Enum.KeyCode.Two and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.silentAim = not state.silentAim end
                if input.KeyCode == Enum.KeyCode.Three and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.espEnabled = not state.espEnabled end
                if input.KeyCode == Enum.KeyCode.Four and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.fly = not state.fly end
                if input.KeyCode == Enum.KeyCode.Five and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.speedHack = not state.speedHack end
                if input.KeyCode == Enum.KeyCode.Six and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.godMode = not state.godMode end
                if input.KeyCode == Enum.KeyCode.Seven and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.reach = not state.reach end
                if input.KeyCode == Enum.KeyCode.Eight and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.rapidFire = not state.rapidFire end
                if input.KeyCode == Enum.KeyCode.Nine and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.autoFarm = not state.autoFarm end
                if input.KeyCode == Enum.KeyCode.Zero and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then state.antiAfk = not state.antiAfk end
            end
        end
    end)

    -- ============================================================
    -- ESP COMPLETO (COM "MIRA DO INIMIGO")
    -- ============================================================
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
            obj.Visible = true
            for k, v in pairs(props) do
                obj[k] = v
            end
            table.insert(espObjects, obj)
            return obj
        else
            if kind == "Square" then
                obj = Instance.new("Frame")
                obj.BackgroundTransparency = 0.5
                obj.BorderSizePixel = 1
                obj.BorderColor3 = props.Color or Color3.new(1,1,1)
                obj.BackgroundColor3 = Color3.new(0,0,0)
                obj.BackgroundTransparency = 0.7
                obj.Size = UDim2.new(0, props.Size.X, 0, props.Size.Y)
                obj.Position = UDim2.new(0, props.Position.X, 0, props.Position.Y)
            elseif kind == "Line" then
                obj = Instance.new("Frame")
                obj.BackgroundColor3 = props.Color or Color3.new(1,1,1)
                obj.BackgroundTransparency = 0.5
                local from = props.From
                local to = props.To
                local dx = to.X - from.X
                local dy = to.Y - from.Y
                local length = math.sqrt(dx*dx + dy*dy)
                obj.Size = UDim2.new(0, length, 0, 2)
                obj.Position = UDim2.new(0, from.X, 0, from.Y)
                obj.Rotation = math.deg(math.atan2(dy, dx))
            elseif kind == "Circle" then
                obj = Instance.new("ImageLabel")
                obj.Image = "rbxassetid://10984745131"
                obj.BackgroundTransparency = 1
                obj.Size = UDim2.new(0, props.Radius*2, 0, props.Radius*2)
                obj.Position = UDim2.new(0, props.Position.X - props.Radius, 0, props.Position.Y - props.Radius)
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
                obj.Position = UDim2.new(0, props.Position.X, 0, props.Position.Y)
                obj.Size = UDim2.new(0, 200, 0, 20)
            end

            if obj then
                obj.Parent = espContainer
                obj.ZIndex = 999
                table.insert(espObjects, obj)
            end
            return obj
        end
    end

    -- Loop principal do ESP
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
                        Position = Vector2.new(headPos2D.X - 50, headPos2D.Y - 22),
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
                        Position = Vector2.new(headPos2D.X - 50, headPos2D.Y + 30),
                        Text = weaponName,
                        Color = Color3.new(1,1,0),
                        Size = 12,
                        Center = true
                    })
                end

                if state.espDistance and myRoot and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X - 50, headPos2D.Y + 15),
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

                -- ESP de Mira do Inimigo
                if state.espEnemyAim and not target.isNPC then
                    local playerHead = char:FindFirstChild("Head")
                    if playerHead then
                        local lookVector = playerHead.CFrame.LookVector
                        local enemyAimEnd = playerHead.Position + lookVector * 50
                        local aimEnd2D, onScreen = worldToScreen(enemyAimEnd)
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
    -- LASER
    -- ============================================================
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
                laserLine.Visible = true
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

    task.spawn(function()
        while true do
            task.wait(0.03)
            pcall(updateLaser)
        end
    end)

    -- ============================================================
    -- AIMBOT TRADICIONAL + LEAD
    -- ============================================================
    local function getAimPart(char, partName)
        local mapping = {
            Cabeça = "Head",
            Peito = "UpperTorso",
            Perna = "LeftLowerLeg",
            Braço = "RightLowerArm"
        }
        local realPart = mapping[partName] or "Head"
        return char:FindFirstChild(realPart)
    end

    local function getTargetAimbot()
        if not state.aimbot then return nil end
        local closest, bestScore = nil, math.huge
        local center = Camera.ViewportSize / 2
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer then continue end
            local chr = p.Character
            if not chr then continue end
            local hum = chr:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then continue end
            if state.wallCheck then
                local head = chr:FindFirstChild("Head")
                if head then
                    local params = RaycastParams.new()
                    params.FilterDescendantsInstances = {LocalPlayer.Character}
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, params)
                    if result and not result.Instance:IsDescendantOf(chr) then continue end
                end
            end

            local aimPart = getAimPart(chr, state.aimPart)
            if not aimPart then continue end
            local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
            if not onScreen then continue end

            local score = 0
            if state.aimPriority == "Distance" then
                score = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            elseif state.aimPriority == "Health" then
                score = hum.Health
            elseif state.aimPriority == "Visibility" then
                local visible = true
                local head = chr:FindFirstChild("Head")
                if head then
                    local params = RaycastParams.new()
                    params.FilterDescendantsInstances = {LocalPlayer.Character}
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, params)
                    if result and not result.Instance:IsDescendantOf(chr) then visible = false end
                end
                score = visible and 0 or 1
            elseif state.aimPriority == "SpecificName" and state.priorityName ~= "" then
                if p.Name:lower():find(state.priorityName:lower()) then
                    score = 0
                else
                    score = 1
                end
            else
                score = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            end

            if score < bestScore then
                bestScore = score
                closest = chr
            end
        end
        return closest
    end

    task.spawn(function()
        while true do
            task.wait()
            if state.aimbot then
                local target = getTargetAimbot()
                if target then
                    local aimPart = getAimPart(target, state.aimPart)
                    if not aimPart then continue end
                    local targetPos = aimPart.Position
                    if state.aimbotLead and aimPart.Velocity then
                        targetPos = targetPos + aimPart.Velocity * state.leadMultiplier * 0.05
                    end
                    local alpha = 0.02 + (state.aimForce-1)*0.245
                    local newCF = CFrame.new(Camera.CFrame.Position, targetPos)
                    if alpha >= 1 then
                        Camera.CFrame = newCF
                    else
                        Camera.CFrame = Camera.CFrame:Lerp(newCF, alpha)
                    end
                end
            end
        end
    end)

    -- ============================================================
    -- SILENT AIM UNIVERSAL
    -- ============================================================
    local function calculateChance(percentage)
        return math.random(1, 100) <= percentage
    end

    local function isPlayerVisibleSA(player)
        local char = player.Character
        if not char then return false end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local points = {root.Position, LocalPlayer.Character or nil, char}
        local ignore = {LocalPlayer.Character, char}
        return #Camera:GetPartsObscuringTarget(points, ignore) == 0
    end

    local function getClosestPlayerSA()
        local targetPart = state.saTargetPart
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

            local part = nil
            if targetPart == "Random" then
                part = char[ValidTargetParts[math.random(#ValidTargetParts)]]
            else
                part = char:FindFirstChild(targetPart)
            end
            if not part then continue end

            local screenPos, onScreen = worldToScreen(part.Position)
            if not onScreen then continue end

            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if dist < (closestDist or 99999) then
                closestDist = dist
                closest = part
            end
        end
        return closest
    end

    local ValidTargetParts = {"Head", "HumanoidRootPart"}

    local mouse_box = Drawing.new("Square")
    mouse_box.Visible = false
    mouse_box.ZIndex = 999
    mouse_box.Color = state.saTargetColor
    mouse_box.Thickness = 20
    mouse_box.Size = Vector2.new(20, 20)
    mouse_box.Filled = true

    local sa_fov_circle = Drawing.new("Circle")
    sa_fov_circle.Thickness = 1
    sa_fov_circle.NumSides = 100
    sa_fov_circle.Radius = state.saFovRadius
    sa_fov_circle.Filled = false
    sa_fov_circle.Visible = false
    sa_fov_circle.ZIndex = 999
    sa_fov_circle.Transparency = 1
    sa_fov_circle.Color = state.saFovColor

    task.spawn(function()
        while true do
            task.wait()
            if state.silentAim then
                if state.saFovVisible then
                    sa_fov_circle.Visible = true
                    sa_fov_circle.Radius = state.saFovRadius
                    sa_fov_circle.Color = state.saFovColor
                    sa_fov_circle.Position = UserInputService:GetMouseLocation()
                else
                    sa_fov_circle.Visible = false
                end

                if state.saShowTarget then
                    local target = getClosestPlayerSA()
                    if target then
                        local part = target.Parent and target.Parent:FindFirstChild("HumanoidRootPart") or target
                        local rootPos = (part:IsA("BasePart") and part.Position) or target.Position
                        local screenPos, onScreen = worldToScreen(rootPos)
                        if onScreen then
                            mouse_box.Visible = true
                            mouse_box.Position = Vector2.new(screenPos.X, screenPos.Y)
                            mouse_box.Color = state.saTargetColor
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

    local ExpectedArguments = {
        FindPartOnRayWithIgnoreList = {
            ArgCountRequired = 3,
            Args = {"Instance", "Ray", "table", "boolean", "boolean"}
        },
        FindPartOnRayWithWhitelist = {
            ArgCountRequired = 3,
            Args = {"Instance", "Ray", "table", "boolean"}
        },
        FindPartOnRay = {
            ArgCountRequired = 2,
            Args = {"Instance", "Ray", "Instance", "boolean", "boolean"}
        },
        Raycast = {
            ArgCountRequired = 3,
            Args = {"Instance", "Vector3", "Vector3", "RaycastParams"}
        }
    }

    local function validateArguments(args, method)
        if #args < method.ArgCountRequired then return false end
        for i, arg in ipairs(args) do
            if typeof(arg) ~= method.Args[i] then return false end
        end
        return true
    end

    local function getDirection(origin, target)
        return (target - origin).Unit * 1000
    end

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        local self = args[1]
        local chance = calculateChance(state.saHitChance)
        if state.silentAim and self == workspace and not checkcaller() and chance then
            if method == "FindPartOnRayWithIgnoreList" and state.saMethod == method then
                if validateArguments(args, ExpectedArguments.FindPartOnRayWithIgnoreList) then
                    local hitPart = getClosestPlayerSA()
                    if hitPart then
                        local ray = args[2]
                        local newRay = Ray.new(ray.Origin, getDirection(ray.Origin, hitPart.Position))
                        args[2] = newRay
                        return oldNamecall(unpack(args))
                    end
                end
            elseif method == "FindPartOnRayWithWhitelist" and state.saMethod == method then
                if validateArguments(args, ExpectedArguments.FindPartOnRayWithWhitelist) then
                    local hitPart = getClosestPlayerSA()
                    if hitPart then
                        local ray = args[2]
                        local newRay = Ray.new(ray.Origin, getDirection(ray.Origin, hitPart.Position))
                        args[2] = newRay
                        return oldNamecall(unpack(args))
                    end
                end
            elseif method == "FindPartOnRay" and state.saMethod:lower() == method:lower() then
                if validateArguments(args, ExpectedArguments.FindPartOnRay) then
                    local hitPart = getClosestPlayerSA()
                    if hitPart then
                        local ray = args[2]
                        local newRay = Ray.new(ray.Origin, getDirection(ray.Origin, hitPart.Position))
                        args[2] = newRay
                        return oldNamecall(unpack(args))
                    end
                end
            elseif method == "Raycast" and state.saMethod == method then
                if validateArguments(args, ExpectedArguments.Raycast) then
                    local hitPart = getClosestPlayerSA()
                    if hitPart then
                        args[3] = getDirection(args[2], hitPart.Position)
                        return oldNamecall(unpack(args))
                    end
                end
            end
        end
        return oldNamecall(...)
    end))

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
        if self == Mouse and not checkcaller() and state.silentAim and state.saMethod == "Mouse.Hit/Target" then
            local hitPart = getClosestPlayerSA()
            if hitPart then
                if index == "Target" or index == "target" then
                    return hitPart
                elseif index == "Hit" or index == "hit" then
                    if state.saMousePrediction then
                        return hitPart.CFrame + (hitPart.Velocity * state.saPredictionAmount)
                    else
                        return hitPart.CFrame
                    end
                elseif index == "X" or index == "x" then
                    return self.X
                elseif index == "Y" or index == "y" then
                    return self.Y
                elseif index == "UnitRay" then
                    return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
                end
            end
        end
        return oldIndex(self, index)
    end))

    -- ============================================================
    -- MOVIMENTO, FARM, CARRO, ETC (CORRIGIDOS E COMPLETOS)
    -- ============================================================
    -- Pulo Infinito
    UserInputService.JumpRequest:Connect(function()
        if state.infJump then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- Fly
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
                if moveDir.Magnitude > 0 then newPos = root.Position + moveDir.Unit * (state.flySpeed * 0.2) end
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
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.WalkSpeed = 16
                        local moveDir = hum.MoveDirection
                        if moveDir.Magnitude > 0 then
                            local delta = state.speedValue / 60
                            local newPos = char.HumanoidRootPart.Position + moveDir.Unit * delta
                            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame:Lerp(CFrame.new(newPos), 0.8)
                        end
                    end
                end
            end
        end
    end)

    -- Ghost Mode
    task.spawn(function()
        while true do
            task.wait(0.3)
            if state.ghostMode then
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Transparency = 0.85
                        end
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
                        local root = p.Character.HumanoidRootPart
                        root.Velocity = Vector3.new(0, -50, 0)
                        task.wait(0.5)
                        root.Velocity = Vector3.zero
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

            local trash = nil
            local nearestDist = 50
            local keywords = {"lixo","trash","saco","papel","garrafa","lata","entulho","resto","garbage","waste","bag","bottle","can","paper"}
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "" then
                    local name = part.Name:lower()
                    local isTrash = false
                    for _, kw in ipairs(keywords) do
                        if name:find(kw) then isTrash = true; break end
                    end
                    if isTrash and part.Transparency < 0.9 and part.Parent then
                        local dist = (part.Position - root.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
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
            local root = char.HumanoidRootPart
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("essencia") or obj.Name:lower():find("essence")) then
                    if tick() - state.lastEssencePick > 1.5 then
                        root.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
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
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
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
            if state.superCarSpeed then
                local char = LocalPlayer.Character
                if char then
                    local seat = nil
                    for _, v in ipairs(Workspace:GetDescendants()) do
                        if v:IsA("VehicleSeat") and v.Occupant == char.Humanoid then
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
        end
    end)

    -- Armas (Reach, Infinite Ammo, etc.)
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
                        if tool then
                            tool.Parent = LocalPlayer.Backpack
                        end
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

    -- RGB e tamanho da arma
    task.spawn(function()
        while true do
            task.wait(0.05)
            if state.armaColorida then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    local hue = (tick() * state.rgbSpeed) % 1
                    local color = Color3.fromHSV(hue, 1, 1)
                    local handle = tool.Handle
                    if handle:IsA("BasePart") then
                        handle.Color = color
                    end
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
            if state.godMode then
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum.MaxHealth = 1e9
                        hum.Health = 1e9
                    end
                end
            end
            if state.antiStun then
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then
                        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    end
                end
            end
            if state.antiFire then
                local char = LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Material == Enum.Material.Fire then
                            part.Material = Enum.Material.SmoothPlastic
                        end
                    end
                end
            end
            if state.autoRespawn then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then
                    pcall(function() LocalPlayer:LoadCharacter() end)
                end
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

    -- Anti Live
    task.spawn(function()
        while true do
            task.wait(1)
            if state.antiLive then
                MainFrame.Visible = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
            end
        end
    end)

    -- ============================================================
    -- LIMPEZA FINAL
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
        if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
        if VoiceChatService then
            pcall(function()
                VoiceChatService:SetVoiceEnabled(false)
                VoiceChatService:SetSpatialVoiceEnabled(true)
            end)
        end
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.PlatformStand = false
            c.Humanoid.WalkSpeed = 16
        end
        Camera.FieldOfView = 70
    end)

    print("[S4ZX HUB v2.9 COMPLETA] Carregado com todas as funções!")
end

-- ============================================================
-- INICIALIZAÇÃO DO HUB (CHAMADA CORRIGIDA)
-- ============================================================
mostrarLogin()
