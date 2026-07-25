-- ============================================================
-- S4ZX HUB v2.9 - COMPLETO COM NOVA INTERFACE E TODAS FUNÇÕES
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

-- ========== HUB PRINCIPAL (INTERFACE + TODOS MÓDULOS) ==========
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
    -- ESTADO GLOBAL
    -- ============================================================
    local state = {
        aimbot = false, aimForce = 3, bypass = 5, fovRadius = 150, wallCheck = false,
        silentAim = false, magicBullet = false, aimPart = "Head", aimPriority = "Distance",
        aimLead = false, aimLeadMultiplier = 1, aimTargetName = "",
        espEnabled = false, espBox = false, espNames = false, espWeapons = false,
        espTalking = false, espSkeleton = false, espAdmin = false, espAdminList = false,
        espLines = false, espDistance = false, espInfiniteDist = false, espNPCs = false,
        espVisible = false, espEnemyAim = false, textSize = 14,
        skeletonColor = Color3.fromRGB(255,105,180), boxColor = Color3.fromRGB(0,255,0),
        talkColor = Color3.fromRGB(255,255,255),
        waypoint = nil, superCarSpeed = false, superCarSpeedValue = 200,
        fovCircle = false, fovRainbow = false, linhaDeMira = false,
        infJump = false, fly = false, flySpeed = 50, speedHack = false,
        speedValue = 60, ghostMode = false,
        autoFarm = false, farmSpeed = 50, autoEssencia = false, autoMicha = false,
        reach = false, reachDist = 25, infiniteAmmo = false, autoReload = false,
        noRecoil = false, rapidFire = false, rapidFireDelay = 0.1,
        oneShot = false, armaColorida = false, rgbSpeed = 2, armaSize = 1,
        flyCar = false, flyCarSpeed = 70,
        antiAfk = false, antiStun = false, antiFire = false, autoRespawn = false,
        godMode = false, micGlobal = false, moneyHack = false, moneyValue = 999999,
        streamerMode = false, antiLive = false,
        grabbedVehicle = nil, vehicleAlign = nil, vehicleVel = nil, vehicleGyro = nil,
        spectateTarget = nil, flyStartY = nil,
        lastFarmAction = 0, lastEssencePick = 0,
        flyCarBV = nil, flyCarBG = nil, flyCarTarget = nil,
        rapidFireTimer = 0, lastAfkTime = 0, lastLiveCheck = 0,
        armasDetectadas = {}, micConnection = nil, enemyVelocities = {},
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

    local function getAimPart(char)
        if not char then return nil end
        local part
        if state.aimPart == "Head" then
            part = char:FindFirstChild("Head")
        elseif state.aimPart == "Chest" then
            part = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        elseif state.aimPart == "Leg" then
            part = char:FindFirstChild("RightLeg") or char:FindFirstChild("LeftLeg") or char:FindFirstChild("LowerTorso")
        elseif state.aimPart == "Arm" then
            part = char:FindFirstChild("RightArm") or char:FindFirstChild("LeftArm")
        end
        return part
    end

    -- ============================================================
    -- INTERFACE PRINCIPAL
    -- ============================================================
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 740, 0, 470)
    MainFrame.Position = UDim2.new(0.5, -370, 0.5, -235)
    MainFrame.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(220, 30, 30)
    Instance.new("UIStroke", MainFrame).Thickness = 1.5

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

    Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", OpenButton).Color = Color3.fromRGB(220, 30, 30)
    Instance.new("UIStroke", OpenButton).Thickness = 2

    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenButton.Visible = false
    end)

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

    -- Logo
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Size = UDim2.new(1, 0, 0, 75)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Parent = Sidebar

    local LogoImage = Instance.new("ImageLabel")
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
    VersionText.Text = "VERSION 2.9 OFFICIAL"
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

    -- Tab container
    local TabContainer = Instance.new("ScrollingFrame")
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

    -- Header
    local HeaderBar = Instance.new("Frame")
    HeaderBar.Size = UDim2.new(1, -180, 0, 40)
    HeaderBar.Position = UDim2.new(0, 180, 0, 0)
    HeaderBar.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    HeaderBar.BorderSizePixel = 0
    HeaderBar.Parent = MainFrame

    Instance.new("UICorner", HeaderBar).CornerRadius = UDim.new(0, 10)

    local HeaderTitle = Instance.new("TextLabel")
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
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -40, 0.5, -15)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = HeaderBar

    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)
    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenButton.Visible = true
    end)

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -190, 1, -50)
    ContentArea.Position = UDim2.new(0, 185, 0, 45)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    -- ============================================================
    -- COMPONENTES DA INTERFACE
    -- ============================================================
    local Tabs = {}
    local FirstTab = true

    local function CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 34)
        TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Color3.fromRGB(160, 160, 165)
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("ScrollingFrame")
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
                t.Button.TextColor3 = Color3.fromRGB(160, 160, 165)
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
        Frame.BorderSizePixel = 0
        Frame.Parent = page
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(230, 230, 235)
        Label.TextSize = 12
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 42, 0, 20)
        Switch.Position = UDim2.new(1, -50, 0.5, -10)
        Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        Switch.Text = ""
        Switch.BorderSizePixel = 0
        Switch.Parent = Frame
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 16, 0, 16)
        Indicator.Position = UDim2.new(0, 2, 0.5, -8)
        Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Indicator.BorderSizePixel = 0
        Indicator.Parent = Switch
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        local enabled = false
        local function updateVisual()
            if enabled then
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 30, 30)}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1)}):Play()
            else
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 48)}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(200,200,200)}):Play()
            end
        end

        Switch.MouseButton1Click:Connect(function()
            enabled = not enabled
            updateVisual()
            pcall(callback, enabled)
        end)
    end

    local function AddSlider(page, text, min, max, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 50)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        Frame.BorderSizePixel = 0
        Frame.Parent = page
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

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
        SliderBar.Position = UDim2.new(0, 12, 0, 32)
        SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        SliderBar.BorderSizePixel = 0
        SliderBar.Parent = Frame
        Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

        local SliderFill = Instance.new("Frame")
        local startPct = (default - min) / (max - min)
        SliderFill.Size = UDim2.new(startPct, 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBar
        Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

        local dragging = false
        local function update(input)
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            pcall(callback, value)
        end

        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end
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
        Button.Size = UDim2.new(1, 0, 0, 34)
        Button.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(240, 240, 245)
        Button.TextSize = 12
        Button.Font = Enum.Font.GothamMedium
        Button.BorderSizePixel = 0
        Button.Parent = page
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)

        Button.MouseButton1Click:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 30, 30)}):Play()
            task.wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 25, 32)}):Play()
            pcall(callback)
        end)
    end

    -- ============================================================
    -- CRIAÇÃO DAS ABAS (COMPLETAS)
    -- ============================================================

    -- AIMBOT
    local AimbotPage = CreateTab("🎯 Aimbot")
    AddToggle(AimbotPage, "AIMBOT (Mira Automática)", function(v) state.aimbot = v end)
    AddSlider(AimbotPage, "Força da Mira", 1, 5, 3, function(v) state.aimForce = v end)
    AddSlider(AimbotPage, "Bypass (Anticheat)", 1, 10, 5, function(v) state.bypass = v end)
    AddSlider(AimbotPage, "FOV Raio", 50, 500, 150, function(v) state.fovRadius = v end)
    AddToggle(AimbotPage, "WALLCK (Checar Parede)", function(v) state.wallCheck = v end)
    AddToggle(AimbotPage, "SILENT AIM", function(v) state.silentAim = v end)
    AddToggle(AimbotPage, "Magic Bullet", function(v) state.magicBullet = v end)
    AddToggle(AimbotPage, "Aimbot com Lead (Predição)", function(v) state.aimLead = v end)
    AddSlider(AimbotPage, "Multiplicador de Lead", 0.5, 3, 1, function(v) state.aimLeadMultiplier = v end)

    local bodyPartLabel = Instance.new("TextLabel")
    bodyPartLabel.Size = UDim2.new(1, 0, 0, 20)
    bodyPartLabel.BackgroundTransparency = 1
    bodyPartLabel.Text = "Parte do Corpo: " .. state.aimPart
    bodyPartLabel.TextColor3 = Color3.fromRGB(220, 30, 30)
    bodyPartLabel.TextSize = 12
    bodyPartLabel.Font = Enum.Font.GothamBold
    bodyPartLabel.Parent = AimbotPage

    local function updateBodyPartLabel()
        bodyPartLabel.Text = "Parte do Corpo: " .. state.aimPart
    end

    AddButton(AimbotPage, "Cabeça", function() state.aimPart = "Head"; updateBodyPartLabel() end)
    AddButton(AimbotPage, "Peito", function() state.aimPart = "Chest"; updateBodyPartLabel() end)
    AddButton(AimbotPage, "Perna", function() state.aimPart = "Leg"; updateBodyPartLabel() end)
    AddButton(AimbotPage, "Braço", function() state.aimPart = "Arm"; updateBodyPartLabel() end)

    local priorityLabel = Instance.new("TextLabel")
    priorityLabel.Size = UDim2.new(1, 0, 0, 20)
    priorityLabel.BackgroundTransparency = 1
    priorityLabel.Text = "Prioridade: " .. state.aimPriority
    priorityLabel.TextColor3 = Color3.fromRGB(220, 30, 30)
    priorityLabel.TextSize = 12
    priorityLabel.Font = Enum.Font.GothamBold
    priorityLabel.Parent = AimbotPage

    local function updatePriorityLabel()
        priorityLabel.Text = "Prioridade: " .. state.aimPriority
    end

    AddButton(AimbotPage, "Distância", function() state.aimPriority = "Distance"; updatePriorityLabel() end)
    AddButton(AimbotPage, "Saúde", function() state.aimPriority = "Health"; updatePriorityLabel() end)
    AddButton(AimbotPage, "Visibilidade", function() state.aimPriority = "Visibility"; updatePriorityLabel() end)
    AddButton(AimbotPage, "Nome Específico", function() state.aimPriority = "Name"; updatePriorityLabel() end)

    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1, 0, 0, 30)
    nameBox.PlaceholderText = "Nome do alvo prioritário"
    nameBox.Text = ""
    nameBox.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    nameBox.TextColor3 = Color3.fromRGB(255,255,255)
    nameBox.Font = Enum.Font.Gotham
    nameBox.TextSize = 12
    nameBox.Parent = AimbotPage
    nameBox.FocusLost:Connect(function(enter)
        if enter then state.aimTargetName = nameBox.Text end
    end)

    -- VISUAL
    local VisualPage = CreateTab("🎨 Visual")
    AddToggle(VisualPage, "FOV Círculo", function(v) state.fovCircle = v end)
    AddToggle(VisualPage, "FOV Arco-Íris", function(v) state.fovRainbow = v end)
    AddToggle(VisualPage, "🔦 Laser (Linha de Tiro)", function(v) state.linhaDeMira = v end)
    AddButton(VisualPage, "Cor Box (Verde Padrão)", function() state.boxColor = Color3.fromRGB(0,255,0) end)
    AddButton(VisualPage, "Cor Esqueleto (Rosa)", function() state.skeletonColor = Color3.fromRGB(255,105,180) end)

    -- ESP
    local EspPage = CreateTab("👁️ ESP")
    AddToggle(EspPage, "Ativar ESP (Geral)", function(v) state.espEnabled = v end)
    AddToggle(EspPage, "Box (Caixas)", function(v) state.espBox = v end)
    AddToggle(EspPage, "Names (Nomes)", function(v) state.espNames = v end)
    AddToggle(EspPage, "Weapons (Arma Equipada)", function(v) state.espWeapons = v end)
    AddToggle(EspPage, "Talking Icon (Ícone de Fala)", function(v) state.espTalking = v end)
    AddToggle(EspPage, "Skeleton (Esqueleto)", function(v) state.espSkeleton = v end)
    AddToggle(EspPage, "Admin ESP", function(v) state.espAdmin = v end)
    AddToggle(EspPage, "Admin List (Painel)", function(v) state.espAdminList = v end)
    AddToggle(EspPage, "Lines (Tracer)", function(v) state.espLines = v end)
    AddToggle(EspPage, "Distance (Distância)", function(v) state.espDistance = v end)
    AddToggle(EspPage, "Infinite Distance", function(v) state.espInfiniteDist = v end)
    AddToggle(EspPage, "Target NPCs", function(v) state.espNPCs = v end)
    AddToggle(EspPage, "Visible Check", function(v) state.espVisible = v end)
    AddToggle(EspPage, "ESP de Mira do Inimigo", function(v) state.espEnemyAim = v end)
    AddSlider(EspPage, "Tamanho do Texto", 12, 20, 14, function(v) state.textSize = v end)
    AddButton(EspPage, "Cor Esqueleto (Aleatória)", function() state.skeletonColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
    AddButton(EspPage, "Cor Box (Aleatória)", function() state.boxColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
    AddButton(EspPage, "Cor Ícone de Fala (Aleatória)", function() state.talkColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)

    -- Player List (mantida)
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

    local PlayerRows = {}
    local function AddPlayerRow(page, player)
        local rowFrame = Instance.new("Frame")
        rowFrame.Size = UDim2.new(1, 0, 0, 36)
        rowFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        rowFrame.BorderSizePixel = 0
        rowFrame.Parent = page
        Instance.new("UICorner", rowFrame).CornerRadius = UDim.new(0, 6)

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
            Btn.BorderSizePixel = 0
            Btn.Parent = rowFrame
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
            Btn.MouseButton1Click:Connect(callback)
            return Btn
        end

        createSmallBtn("🔄 Puxar", -70, 60, function()
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

        createSmallBtn("🚀 TP", -125, 50, function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local myChar = LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    myChar.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                end
            end
        end)

        createSmallBtn("👁️ Spectate", -210, 80, function()
            state.spectateTarget = player
            if player.Character then Camera.CameraSubject = player.Character end
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

    -- VEÍCULOS
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
        if nearest then root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0)) end
    end)
    AddButton(VeiculosPage, "Destrancar Veículo", function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") then v:SetAttribute("Locked", false); v.Locked = false end
        end
    end)
    AddButton(VeiculosPage, "Trancar Veículo", function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") then v:SetAttribute("Locked", true); v.Locked = true end
        end
    end)
    AddButton(VeiculosPage, "Marcar Waypoint", function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            state.waypoint = char.HumanoidRootPart.Position
        end
    end)
    AddButton(VeiculosPage, "Teleportar Waypoint", function()
        if state.waypoint then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(state.waypoint + Vector3.new(0, 2, 0))
            end
        end
    end)
    AddToggle(VeiculosPage, "Super Velocidade no Carro", function(v) state.superCarSpeed = v end)
    AddSlider(VeiculosPage, "Velocidade Super Carro", 50, 500, 200, function(v) state.superCarSpeedValue = v end)

    -- MOVIMENTO
    local MovPage = CreateTab("🏃 Movimento")
    AddToggle(MovPage, "Pulo Infinito", function(v) state.infJump = v end)
    AddToggle(MovPage, "Fly Avançado (WASD/E/Q)", function(v) state.fly = v; if not v then state.flyStartY = nil end end)
    AddSlider(MovPage, "Velocidade Fly", 20, 200, 50, function(v) state.flySpeed = v end)
    AddToggle(MovPage, "Speed Hack", function(v) state.speedHack = v end)
    AddSlider(MovPage, "Velocidade Speed", 16, 200, 60, function(v) state.speedValue = v end)
    AddToggle(MovPage, "Ghost Mode (Invisível)", function(v) state.ghostMode = v end)

    -- FARM
    local FarmPage = CreateTab("🌾 Farm")
    AddToggle(FarmPage, "Auto Farm Lixo", function(v) state.autoFarm = v end)
    AddSlider(FarmPage, "Velocidade Farm", 30, 100, 50, function(v) state.farmSpeed = v end)
    AddToggle(FarmPage, "Auto Essência", function(v) state.autoEssencia = v end)
    AddToggle(FarmPage, "Auto Micha (Sintonia RP)", function(v) state.autoMicha = v end)

    -- ARMAS
    local ArmasPage = CreateTab("🔪 Armas")
    AddToggle(ArmasPage, "Reach (Alcance de Ataque)", function(v) state.reach = v end)
    AddSlider(ArmasPage, "Distância Reach (Studs)", 10, 50, 25, function(v) state.reachDist = v end)
    AddToggle(ArmasPage, "Infinite Ammo", function(v) state.infiniteAmmo = v end)
    AddToggle(ArmasPage, "Auto Reload", function(v) state.autoReload = v end)
    AddToggle(ArmasPage, "No Recoil", function(v) state.noRecoil = v end)
    AddToggle(ArmasPage, "Rapid Fire", function(v) state.rapidFire = v end)
    AddSlider(ArmasPage, "Rapid Fire Delay", 0.05, 0.5, 0.1, function(v) state.rapidFireDelay = v end)
    AddToggle(ArmasPage, "Matar com 1 Tiro", function(v) state.oneShot = v end)
    AddToggle(ArmasPage, "Arma Colorida (RGB)", function(v) state.armaColorida = v end)
    AddSlider(ArmasPage, "Velocidade RGB", 0.5, 5, 2, function(v) state.rgbSpeed = v end)
    AddSlider(ArmasPage, "Tamanho da Arma", 0.5, 5, 1, function(v) state.armaSize = v end)

    -- Armas dinâmicas
    local dynamicWeaponsHeader = Instance.new("TextLabel")
    dynamicWeaponsHeader.Size = UDim2.new(1, 0, 0, 25)
    dynamicWeaponsHeader.BackgroundTransparency = 1
    dynamicWeaponsHeader.Text = "--- ARMAS DETECTADAS ---"
    dynamicWeaponsHeader.TextColor3 = Color3.fromRGB(220, 30, 30)
    dynamicWeaponsHeader.TextSize = 12
    dynamicWeaponsHeader.Font = Enum.Font.GothamBold
    dynamicWeaponsHeader.Parent = ArmasPage

    local dynamicWeaponsContainer = Instance.new("Frame")
    dynamicWeaponsContainer.Size = UDim2.new(1, 0, 0, 0)
    dynamicWeaponsContainer.BackgroundTransparency = 1
    dynamicWeaponsContainer.AutomaticSize = Enum.AutomaticSize.Y
    dynamicWeaponsContainer.Parent = ArmasPage
    Instance.new("UIListLayout", dynamicWeaponsContainer).Padding = UDim.new(0, 2)

    local function detectWeapons()
        local weapons = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name ~= "" then table.insert(weapons, obj.Name) end
        end
        for _, container in ipairs({LocalPlayer.Backpack, LocalPlayer.Character}) do
            if container then
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("Tool") and child.Name ~= "" then table.insert(weapons, child.Name) end
                end
            end
        end
        local unique, result = {}, {}
        for _, name in ipairs(weapons) do
            if not unique[name] then unique[name] = true; table.insert(result, name) end
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
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
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
                    handle.Transparency = 0.2
                    handle.Parent = tool
                    tool.Parent = LocalPlayer.Character
                end)
            end
        end
    end

    local updateWeaponsBtn = Instance.new("TextButton")
    updateWeaponsBtn.Size = UDim2.new(1, 0, 0, 32)
    updateWeaponsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    updateWeaponsBtn.Text = "🔄 ATUALIZAR ARMAS"
    updateWeaponsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    updateWeaponsBtn.TextSize = 12
    updateWeaponsBtn.Font = Enum.Font.GothamBold
    updateWeaponsBtn.Parent = ArmasPage
    Instance.new("UICorner", updateWeaponsBtn).CornerRadius = UDim.new(0, 6)
    updateWeaponsBtn.MouseButton1Click:Connect(rebuildDynamicWeapons)
    task.wait(0.5)
    rebuildDynamicWeapons()

    -- CARRO
    local CarroPage = CreateTab("🏎️ Carro")
    AddToggle(CarroPage, "Fly Car (Carro Voador)", function(v) state.flyCar = v end)
    AddSlider(CarroPage, "Velocidade Fly Car", 20, 200, 70, function(v) state.flyCarSpeed = v end)

    -- EXTRAS
    local ExtrasPage = CreateTab("🛠️ Extras")
    AddToggle(ExtrasPage, "Anti AFK", function(v) state.antiAfk = v end)
    AddToggle(ExtrasPage, "Anti Stun", function(v) state.antiStun = v end)
    AddToggle(ExtrasPage, "Anti Fire", function(v) state.antiFire = v end)
    AddToggle(ExtrasPage, "Auto Respawn", function(v) state.autoRespawn = v end)
    AddToggle(ExtrasPage, "God Mode (Vida Infinita)", function(v) state.godMode = v end)
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
    AddToggle(ExtrasPage, "💰 Money Hack (Auto)", function(v) state.moneyHack = v end)
    AddSlider(ExtrasPage, "Valor do Dinheiro", 1000, 9999999, 999999, function(v) state.moneyValue = v end)
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
                end
                state.grabbedVehicle = car
                local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                if primary then
                    state.vehicleAlign = Instance.new("AlignPosition")
                    state.vehicleAlign.MaxForce = 9999999
                    state.vehicleAlign.Responsiveness = 200
                    state.vehicleAlign.Attachment0 = primary:FindFirstChild("AlignAttachment") or Instance.new("Attachment", primary)
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local attach = root:FindFirstChild("GrabAttach") or Instance.new("Attachment", root)
                        attach.Name = "GrabAttach"
                        state.vehicleAlign.Attachment1 = attach
                    end
                    state.vehicleAlign.Parent = primary
                    state.vehicleVel = Instance.new("LinearVelocity")
                    state.vehicleVel.MaxForce = 9999999
                    state.vehicleVel.Attachment0 = primary:FindFirstChild("VelAttachment") or Instance.new("Attachment", primary)
                    state.vehicleVel.Parent = primary
                    state.vehicleGyro = Instance.new("AngularVelocity")
                    state.vehicleGyro.MaxTorque = 9999999
                    state.vehicleGyro.Attachment0 = primary:FindFirstChild("GyroAttachment") or Instance.new("Attachment", primary)
                    state.vehicleGyro.Parent = primary
                end
            end
        end
    end)
    AddButton(ExtrasPage, "💥 TACAR Veículo", function()
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
                primary:ApplyAngularImpulse(Vector3.new(math.random(-5000,5000), math.random(-5000,5000), math.random(-5000,5000)) * primary:GetMass() * 0.1)
            end)
        end
        state.grabbedVehicle = nil
    end)

    -- CONFIG
    local ConfigPage = CreateTab("⚙️ Config")
    AddToggle(ConfigPage, "Modo Streamer", function(v) state.streamerMode = v; MainFrame.Visible = not v; OpenButton.Visible = v end)
    AddToggle(ConfigPage, "Anti Live", function(v) state.antiLive = v end)

    local MenuKeybind = Enum.KeyCode.RightShift
    local IsBindingKey = false
    local BindButtonUI = nil

    local function AddKeybind(page, text)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 36)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        Frame.Parent = page
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

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
        Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)

        BindBtn.MouseButton1Click:Connect(function()
            BindBtn.Text = "[ Pressione a Tecla ]"
            BindBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
            IsBindingKey = true
            BindButtonUI = BindBtn
        end)
    end
    AddKeybind(ConfigPage, "Atalho de Ocultar Menu:")

    -- SEGURANÇA
    local SegPage = CreateTab("🔒 Segurança")
    AddButton(SegPage, "🔑 Status Key: AUTENTICADO", function() end)
    AddButton(SegPage, "🚫 Blacklist: LIMPO", function() end)
    AddButton(SegPage, "💻 HWID Verificado: OK", function() end)
    AddButton(SegPage, "🛡️ Anti-Adulteração: ATIVO", function() end)
    AddButton(SegPage, "🔄 Checagem Remota: ONLINE (5m)", function() end)

    -- STAFF COUNTER
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
        while true do task.wait(1); pcall(updateStaffCounter) end
    end)

    -- KEYBIND
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

    -- ============================================================
    -- MÓDULO ESP (CORRIGIDO)
    -- ============================================================
    local useDrawing = pcall(function() return Drawing.new end)
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
            if useDrawing then pcall(function() obj:Remove() end) else pcall(function() obj:Destroy() end) end
        end
        espObjects = {}
    end

    local function createESPObject(kind, props)
        local obj
        if useDrawing then
            obj = Drawing.new(kind)
            obj.Visible = true
            for k, v in pairs(props) do obj[k] = v end
            table.insert(espObjects, obj)
            return obj
        else
            if kind == "Square" then
                obj = Instance.new("Frame")
                obj.BackgroundTransparency = 0.7
                obj.BorderSizePixel = 1
                obj.BorderColor3 = props.Color or Color3.new(1,1,1)
                obj.Size = UDim2.new(0, props.Size.X, 0, props.Size.Y)
                obj.Position = UDim2.new(0, props.Position.X, 0, props.Position.Y)
            elseif kind == "Line" then
                obj = Instance.new("Frame")
                obj.BackgroundColor3 = props.Color or Color3.new(1,1,1)
                obj.BackgroundTransparency = 0.5
                local from, to = props.From, props.To
                local dx, dy = to.X - from.X, to.Y - from.Y
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

    -- Loop ESP (sem "continue", usando if)
    task.spawn(function()
        while true do
            task.wait(0.05)
            if not state.espEnabled then
                clearESPObjects()
                if fovCircleObj then fovCircleObj.Visible = false end
            else
                clearESPObjects()
                local screenSize = Camera.ViewportSize
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targets = {}

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer then
                        local chr = p.Character
                        if chr and chr:FindFirstChild("HumanoidRootPart") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
                            table.insert(targets, {player = p, char = chr})
                        end
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
                        if not t.isNPC and isAdmin(t.player) then table.insert(adminNames, t.player.Name) end
                    end
                    if #adminNames > 0 then
                        createESPObject("Text", {
                            Position = Vector2.new(10, 10),
                            Text = "Admins: " .. table.concat(adminNames, ", "),
                            Color = Color3.new(1,0,0),
                            Size = 16
                        })
                    end
                end

                for _, target in ipairs(targets) do
                    local char = target.char
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local head = char:FindFirstChild("Head")
                    local hum = char:FindFirstChild("Humanoid")
                    if root and head and hum and hum.Health > 0 then
                        local isAdminTarget = (not target.isNPC and state.espAdmin and isAdmin(target.player))
                        local headPos2D, headOn = worldToScreen(head.Position + Vector3.new(0, 1.5, 0))
                        local rootPos2D, rootOn = worldToScreen(root.Position)
                        local feetPos2D, feetOn = worldToScreen(root.Position - Vector3.new(0, 3, 0))

                        local canDraw = headOn or state.espInfiniteDist
                        if canDraw then
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
                                if tool then weaponName = tool.Name end
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
                                    Color = color, Thickness = 2
                                })
                            end

                            if state.espSkeleton then
                                local bonePairs = {
                                    {"Head","UpperTorso"}, {"UpperTorso","LowerTorso"},
                                    {"LowerTorso","LeftUpperLeg"}, {"LeftUpperLeg","LeftLowerLeg"}, {"LeftLowerLeg","LeftFoot"},
                                    {"LowerTorso","RightUpperLeg"}, {"RightUpperLeg","RightLowerLeg"}, {"RightLowerLeg","RightFoot"},
                                    {"UpperTorso","LeftUpperArm"}, {"LeftUpperArm","LeftLowerArm"}, {"LeftLowerArm","LeftHand"},
                                    {"UpperTorso","RightUpperArm"}, {"RightUpperArm","RightLowerArm"}, {"RightLowerArm","RightHand"}
                                }
                                for _, pair in ipairs(bonePairs) do
                                    local a, b = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
                                    if a and b then
                                        local aPos, aOn = worldToScreen(a.Position)
                                        local bPos, bOn = worldToScreen(b.Position)
                                        if aOn and bOn then
                                            createESPObject("Line", { From = aPos, To = bPos, Color = state.skeletonColor, Thickness = 2 })
                                        end
                                    end
                                end
                            end

                            if state.espNames and headOn then
                                createESPObject("Text", {
                                    Position = Vector2.new(headPos2D.X - 50, headPos2D.Y - 22),
                                    Text = target.player.Name or "NPC",
                                    Color = color, Size = state.textSize
                                })
                            end

                            if state.espWeapons and weaponName ~= "" and headOn then
                                createESPObject("Text", {
                                    Position = Vector2.new(headPos2D.X - 50, headPos2D.Y + 30),
                                    Text = weaponName, Color = Color3.new(1,1,0), Size = 12
                                })
                            end

                            if state.espDistance and myRoot and headOn then
                                createESPObject("Text", {
                                    Position = Vector2.new(headPos2D.X - 50, headPos2D.Y + 15),
                                    Text = math.floor(dist) .. "m", Color = Color3.new(1,1,1), Size = 12
                                })
                            end

                            if state.espLines and rootOn then
                                createESPObject("Line", {
                                    From = Vector2.new(screenSize.X / 2, screenSize.Y), To = rootPos2D, Color = color, Thickness = 1
                                })
                            end

                            if state.espTalking and headOn then
                                createESPObject("Text", {
                                    Position = Vector2.new(headPos2D.X + 15, headPos2D.Y - 10), Text = "🗣️", Color = state.talkColor, Size = 12
                                })
                            end

                            if state.espEnemyAim then
                                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                                if torso and torso:IsA("BasePart") then
                                    local aimDir = torso.CFrame.LookVector * 30
                                    local aimEnd = torso.Position + aimDir
                                    local startS, startOn = worldToScreen(torso.Position)
                                    local endS, endOn = worldToScreen(aimEnd)
                                    if startOn and endOn then
                                        createESPObject("Line", { From = startS, To = endS, Color = Color3.fromRGB(255,0,0), Thickness = 2 })
                                        createESPObject("Circle", { Position = endS, Radius = 3, Color = Color3.fromRGB(255,0,0), Thickness = 2 })
                                    end
                                end
                            end
                        end
                    end
                end

                -- FOV circle
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
                    fovCircleObj.Color = state.fovRainbow and Color3.fromHSV(tick() % 1, 1, 1) or Color3.new(1,1,1)
                elseif fovCircleObj then
                    fovCircleObj.Visible = false
                end
            end
        end
    end)

    -- LASER
    local laserLine = nil
    task.spawn(function()
        while true do
            task.wait(0.03)
            if state.linhaDeMira then
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool then
                        local handle = tool:FindFirstChild("Handle")
                        if handle then
                            local origin = handle.Position
                            local dir = Camera.CFrame.LookVector * 500
                            local params = RaycastParams.new()
                            params.FilterDescendantsInstances = {char}
                            params.FilterType = Enum.RaycastFilterType.Blacklist
                            local result = Workspace:Raycast(origin, dir, params)
                            local targetPos = result and result.Position or (origin + dir)
                            if useDrawing then
                                if not laserLine then
                                    laserLine = Drawing.new("Line")
                                    laserLine.Thickness = 2
                                    laserLine.Color = Color3.fromRGB(255,255,255)
                                    laserLine.Transparency = 0.8
                                    laserLine.Visible = true
                                end
                                local oS, oOn = worldToScreen(origin)
                                local tS, tOn = worldToScreen(targetPos)
                                if oOn and tOn then
                                    laserLine.From = oS; laserLine.To = tS; laserLine.Visible = true
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
                                local oS, oOn = worldToScreen(origin)
                                local tS, tOn = worldToScreen(targetPos)
                                if oOn and tOn then
                                    local dx = tS.X - oS.X; local dy = tS.Y - oS.Y
                                    local length = math.sqrt(dx*dx+dy*dy)
                                    laserLine.Position = UDim2.new(0, oS.X, 0, oS.Y)
                                    laserLine.Size = UDim2.new(0, length, 0, 2)
                                    laserLine.Rotation = math.deg(math.atan2(dy, dx))
                                    laserLine.Visible = true
                                else
                                    laserLine.Visible = false
                                end
                            end
                        end
                    end
                end
            else
                if laserLine then
                    if useDrawing then laserLine:Remove() else laserLine:Destroy() end
                    laserLine = nil
                end
            end
        end
    end)

    -- ============================================================
    -- AIMBOT (COM LEAD E PRIORIDADE)
    -- ============================================================
    local function getTarget()
        if not state.aimbot and not state.silentAim then return nil end
        local center = Camera.ViewportSize / 2
        local targets = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local chr = p.Character
                if chr then
                    local part = getAimPart(chr) or chr:FindFirstChild("Head")
                    if part then
                        local hum = chr:FindFirstChild("Humanoid")
                        if hum and hum.Health > 0 then
                            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                            if onScreen then
                                local dist2d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                                if dist2d <= state.fovRadius then
                                    local visible = true
                                    if state.wallCheck or state.espVisible then
                                        local params = RaycastParams.new()
                                        params.FilterDescendantsInstances = {LocalPlayer.Character}
                                        params.FilterType = Enum.RaycastFilterType.Blacklist
                                        local result = Workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000, params)
                                        if result and not result.Instance:IsDescendantOf(chr) then visible = false end
                                    end
                                    if visible then
                                        table.insert(targets, {
                                            player = p, chr = chr, part = part,
                                            dist = (part.Position - Camera.CFrame.Position).Magnitude,
                                            health = hum.Health, visible = visible
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        -- Prioridade
        if state.aimPriority == "Distance" then
            table.sort(targets, function(a,b) return a.dist < b.dist end)
        elseif state.aimPriority == "Health" then
            table.sort(targets, function(a,b) return a.health < b.health end)
        elseif state.aimPriority == "Visibility" then
            table.sort(targets, function(a,b) return (a.visible and not b.visible) end)
        elseif state.aimPriority == "Name" and state.aimTargetName ~= "" then
            table.sort(targets, function(a,b)
                if a.player.Name:lower() == state.aimTargetName:lower() then return true
                elseif b.player.Name:lower() == state.aimTargetName:lower() then return false
                else return a.dist < b.dist end
            end)
        end
        return targets[1]
    end

    local function getPredictedPosition(target)
        if not target or not target.chr then return nil end
        local part = target.part
        if not part then return nil end
        local root = target.chr:FindFirstChild("HumanoidRootPart")
        if not root then return part.Position end
        local velocity = root.Velocity or Vector3.zero
        local timeToHit = (part.Position - Camera.CFrame.Position).Magnitude / 1000
        return part.Position + velocity * timeToHit * state.aimLeadMultiplier
    end

    task.spawn(function()
        while true do
            task.wait()
            local target = getTarget()
            if target then
                local targetPos = target.part.Position
                if state.aimLead then
                    local predicted = getPredictedPosition(target)
                    if predicted then targetPos = predicted end
                end
                targetPos = targetPos + Vector3.new(
                    (math.random()-0.5)*state.bypass*0.03,
                    (math.random()-0.5)*state.bypass*0.03,
                    (math.random()-0.5)*state.bypass*0.03
                )
                local alpha = 0.02 + (state.aimForce-1)*0.245
                if state.aimbot then
                    local newCF = CFrame.new(Camera.CFrame.Position, targetPos)
                    if alpha >= 1 then Camera.CFrame = newCF else Camera.CFrame = Camera.CFrame:Lerp(newCF, alpha) end
                end
                if state.silentAim then
                    local newCF = CFrame.new(Camera.CFrame.Position, targetPos)
                    Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.05)
                    if state.magicBullet then Camera.CFrame = newCF end
                end
            end
        end
    end)

    -- ============================================================
    -- LOOPS DE GAMEPLAY
    -- ============================================================
    -- Super carro
    task.spawn(function()
        while true do
            task.wait(0.1)
            if state.superCarSpeed then
                local vehicle = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("VehicleSeat")
                if vehicle then
                    local car = vehicle.Parent
                    if car and car:IsA("Model") then
                        local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                        if primary and primary.Velocity.Magnitude > 0 then
                            primary.Velocity = primary.Velocity.Unit * state.superCarSpeedValue
                        end
                    end
                end
            end
        end
    end)

    -- Money Hack
    task.spawn(function()
        local searchTerms = {"Cash","Money","Gold","Coins","Currency","Dollar","Wallet","Bank","Balance"}
        while true do
            task.wait(0.5)
            if state.moneyHack then
                local success = false
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("IntValue") or obj:IsA("NumberValue") then
                        for _, term in ipairs(searchTerms) do
                            if obj.Name:lower():find(term:lower()) then
                                obj.Value = state.moneyValue; success = true
                            end
                        end
                    elseif obj:IsA("StringValue") and tonumber(obj.Value) then
                        for _, term in ipairs(searchTerms) do
                            if obj.Name:lower():find(term:lower()) then
                                obj.Value = tostring(state.moneyValue); success = true
                            end
                        end
                    end
                end
                for _, child in ipairs(LocalPlayer:GetChildren()) do
                    if (child:IsA("IntValue") or child:IsA("NumberValue")) then
                        for _, term in ipairs(searchTerms) do
                            if child.Name:lower():find(term:lower()) then
                                child.Value = state.moneyValue; success = true
                            end
                        end
                    end
                end
                if success then print("💰 Money Hack aplicado!") end
            end
        end
    end)

    -- Pulo infinito
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
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then hum.PlatformStand = true end
                    if not state.flyStartY then state.flyStartY = root.Position.Y end
                    local camDir = Camera.CFrame.LookVector
                    local moveDir = Vector3.zero
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(camDir.X,0,camDir.Z).Unit end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(camDir.X,0,camDir.Z).Unit end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then state.flyStartY = state.flyStartY + state.flySpeed * 0.15 end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then state.flyStartY = state.flyStartY - state.flySpeed * 0.15 end
                    local newPos = root.Position
                    if moveDir.Magnitude > 0 then newPos = root.Position + moveDir.Unit * (state.flySpeed * 0.2) end
                    newPos = Vector3.new(newPos.X, state.flyStartY, newPos.Z)
                    root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.5)
                end
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
                            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame:Lerp(
                                CFrame.new(char.HumanoidRootPart.Position + moveDir.Unit * (state.speedValue/60)), 0.8)
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
                        if part:IsA("BasePart") then part.Transparency = 0.85 end
                    end
                end
            end
        end
    end)

    -- Auto Farm Lixo
    task.spawn(function()
        local keywords = {"lixo","trash","saco","papel","garrafa","lata","entulho","resto","garbage","waste","bag","bottle","can","paper"}
        while true do
            task.wait(0.1)
            if state.autoFarm then
                local char = LocalPlayer.Character
                if char then
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local trash, nearestDist = nil, 50
                        for _, part in ipairs(Workspace:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "" and part.Transparency < 0.9 and part.Parent then
                                local name = part.Name:lower()
                                local isTrash = false
                                for _, kw in ipairs(keywords) do if name:find(kw) then isTrash = true; break end end
                                if isTrash then
                                    local dist = (part.Position - root.Position).Magnitude
                                    if dist < nearestDist then nearestDist = dist; trash = part end
                                end
                            end
                        end
                        if trash then
                            local distance = (trash.Position - root.Position).Magnitude
                            if distance > 4 then
                                root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position + (trash.Position - root.Position).Unit * (state.farmSpeed*0.05)), 0.5)
                            else
                                local tool = char:FindFirstChildWhichIsA("Tool")
                                if tool then pcall(function() tool:Activate() end) end
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Auto Essência
    task.spawn(function()
        while true do
            task.wait(0.5)
            if state.autoEssencia then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("essencia") or obj.Name:lower():find("essence")) then
                            if tick() - state.lastEssencePick > 1.5 then
                                char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                                state.lastEssencePick = tick()
                                local tool = char:FindFirstChildWhichIsA("Tool")
                                if tool then pcall(function() tool:Activate() end) end
                                break
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Auto Micha
    task.spawn(function()
        while true do
            task.wait(0.5)
            if state.autoMicha then
                local char = LocalPlayer.Character
                if char then
                    local tool = char:FindFirstChild("Micha") or LocalPlayer.Backpack:FindFirstChild("Micha")
                    if tool and tool:IsA("Tool") then
                        if tool.Parent ~= char then tool.Parent = char end
                        pcall(function() tool:Activate() end)
                    end
                    for _, prompt in ipairs(Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            local text = (prompt.ObjectText..prompt.ActionText):lower()
                            if text:find("micha") or text:find("roubar") then
                                if LocalPlayer:DistanceFromCharacter(prompt.Parent.Position) <= prompt.MaxActivationDistance then
                                    pcall(function() fireproximityprompt(prompt) end)
                                end
                            end
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
            else
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
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
                    local car = state.flyCarTarget
                    if car then
                        local primary = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                        if primary then
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
                                state.flyCarBV.Velocity = Vector3.zero
                            end
                            state.flyCarBG.CFrame = CFrame.new(primary.Position, primary.Position + Camera.CFrame.LookVector)
                        end
                    end
                end
            end
        end
    end)

    -- Armas: reach, ammo, etc.
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
                    for _, v in ipairs(tool:GetChildren()) do
                        if v:IsA("IntValue") and (v.Name == "Ammo" or v.Name == "Bullets" or v.Name == "Magazine") then v.Value = 999 end
                    end
                end
            end
            if state.autoReload then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets")
                    if ammo and ammo:IsA("IntValue") and ammo.Value == 0 then pcall(function() tool:Reload() end) end
                end
            end
            if state.noRecoil then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    for _, obj in ipairs(tool:GetDescendants()) do
                        if obj:IsA("SpringConstraint") or obj:IsA("RocketPropulsion") then obj.Enabled = false end
                    end
                end
            end
            if state.oneShot then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    for _, v in ipairs(tool:GetDescendants()) do
                        if v.Name == "Damage" and v:IsA("NumberValue") then v.Value = 9999 end
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

    -- Arma colorida
    task.spawn(function()
        while true do
            task.wait(0.05)
            if state.armaColorida then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool and tool:FindFirstChild("Handle") then
                    tool.Handle.Color = Color3.fromHSV((tick() * state.rgbSpeed) % 1, 1, 1)
                end
            end
        end
    end)

    -- Tamanho da arma
    task.spawn(function()
        while true do
            task.wait(0.5)
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
            if tool then pcall(function() tool:ScaleTo(state.armaSize) end) end
        end
    end)

    -- God Mode, Anti Stun, etc.
    task.spawn(function()
        while true do
            task.wait(0.5)
            if state.godMode then
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then hum.MaxHealth = 1e9; hum.Health = 1e9 end
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
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
                end
            end
        end
    end)

    -- Anti Live
    task.spawn(function()
        while true do
            task.wait(1)
            if state.antiLive then MainFrame.Visible = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil) end
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
        if laserLine then if useDrawing then laserLine:Remove() else laserLine:Destroy() end end
        clearESPObjects()
        if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
        if VoiceChatService then
            pcall(function() VoiceChatService:SetVoiceEnabled(false); VoiceChatService:SetSpatialVoiceEnabled(true) end)
        end
        local c = LocalPlayer.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.PlatformStand = false; c.Humanoid.WalkSpeed = 16
        end
        Camera.FieldOfView = 70
    end)

    print("[S4ZX HUB v2.9] Carregado com sucesso - Nova interface e todos os módulos ativos!")
end

mostrarLogin()
