--[[
    S4ZX HUB - v2.5 (CORREÇÕES FINAIS)
    - Lista de players funcionando
    - Waypoint com marcação e TP
    - FOV Circle visível
    - Silent Aim com ajuste visual
]]

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
        if game.CoreGui:FindFirstChild("S4ZX_Hub") then game.CoreGui.S4ZX_Hub:Destroy() end
        if game.CoreGui:FindFirstChild("S4ZX_Minimized") then game.CoreGui.S4ZX_Minimized:Destroy() end
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
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local Player = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    if CoreGui:FindFirstChild("S4ZX_Hub") then CoreGui.S4ZX_Hub:Destroy() end
    if CoreGui:FindFirstChild("S4ZX_Minimized") then CoreGui.S4ZX_Minimized:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "S4ZX_Hub"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- ========== INTERFACE PRINCIPAL ==========
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 800, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(220, 30, 30)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 50)
    Topbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    TopbarCorner.Parent = Topbar

    local LogoText = Instance.new("TextLabel", Topbar)
    LogoText.Size = UDim2.new(0, 120, 0, 35)
    LogoText.Position = UDim2.new(0, 10, 0.5, -17)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "S4ZX"
    LogoText.TextColor3 = Color3.fromRGB(255,255,255)
    LogoText.Font = Enum.Font.GothamBold
    LogoText.TextSize = 20

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 140, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "S4ZX HUB v2.5"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    local minimizeBtn = Instance.new("TextButton", Topbar)
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    minimizeBtn.Text = "—"
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    minimizeBtn.TextColor3 = Color3.new(1,1,1)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextSize = 18
    minimizeBtn.BorderSizePixel = 0
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.Position = UDim2.new(0, 0, 0, 50)
    Divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Divider.BorderSizePixel = 0
    Divider.Parent = MainFrame

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 140, 1, -51)
    TabContainer.Position = UDim2.new(0, 0, 0, 51)
    TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(220, 30, 30)
    TabContainer.Parent = MainFrame

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)
    TabListLayout.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingLeft = UDim.new(0, 6)
    TabPadding.PaddingRight = UDim.new(0, 6)
    TabPadding.Parent = TabContainer

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -145, 1, -56)
    ContentArea.Position = UDim2.new(0, 143, 0, 53)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local MinimizedCircle = Instance.new("TextButton")
    MinimizedCircle.Name = "S4ZX_Minimized"
    MinimizedCircle.Size = UDim2.new(0, 50, 0, 50)
    MinimizedCircle.Position = UDim2.new(0.9, 0, 0.1, 0)
    MinimizedCircle.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
    MinimizedCircle.TextColor3 = Color3.new(1,1,1)
    MinimizedCircle.Text = "S4"
    MinimizedCircle.Font = Enum.Font.GothamBold
    MinimizedCircle.TextSize = 14
    MinimizedCircle.BorderSizePixel = 0
    MinimizedCircle.Parent = ScreenGui
    MinimizedCircle.Visible = false
    MinimizedCircle.Active = true
    MinimizedCircle.Draggable = true
    Instance.new("UICorner", MinimizedCircle).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", MinimizedCircle).Color = Color3.fromRGB(255,255,255)

    minimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedCircle.Visible = true
    end)

    MinimizedCircle.MouseButton1Click:Connect(function()
        MinimizedCircle.Visible = false
        MainFrame.Visible = true
    end)

    -- ========== SISTEMA DE ABAS ==========
    local Tabs = {}
    local FirstTab = true

    local function CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "_Btn"
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Parent = TabContainer

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 5)
        BtnCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = tabName .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Color3.fromRGB(220, 30, 30)
        Page.Parent = ContentArea

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.Parent = Page

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingRight = UDim.new(0, 8)
        PagePadding.PaddingTop = UDim.new(0, 4)
        PagePadding.Parent = Page

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        if FirstTab then
            FirstTab = false
            Page.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(220, 30, 30)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        Tabs[tabName] = {Page = Page, Button = TabButton}
        return Page
    end

    -- ========== COMPONENTES DA UI ==========
    local function AddToggle(page, text, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 35)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Frame.Parent = page

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 40, 0, 20)
        Switch.Position = UDim2.new(1, -48, 0.5, -10)
        Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Switch.Text = ""
        Switch.Parent = Frame

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 16, 0, 16)
        Indicator.Position = UDim2.new(0, 2, 0.5, -8)
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
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
            else
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            end
            pcall(callback, enabled)
        end)
    end

    local function AddSlider(page, text, min, max, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 35)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Frame.Parent = page

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0, 120, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. default
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local minusBtn = Instance.new("TextButton")
        minusBtn.Size = UDim2.new(0, 24, 0, 24)
        minusBtn.Position = UDim2.new(0, 130, 0, 5)
        minusBtn.Text = "-"
        minusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        minusBtn.TextColor3 = Color3.new(1,1,1)
        minusBtn.Font = Enum.Font.SourceSansBold
        minusBtn.TextSize = 18
        minusBtn.BorderSizePixel = 0
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4)
        minusBtn.Parent = Frame

        local valueBox = Instance.new("TextBox")
        valueBox.Size = UDim2.new(0, 50, 0, 24)
        valueBox.Position = UDim2.new(0, 158, 0, 5)
        valueBox.Text = tostring(default)
        valueBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        valueBox.TextColor3 = Color3.new(1,1,1)
        valueBox.Font = Enum.Font.SourceSans
        valueBox.TextSize = 14
        valueBox.BorderSizePixel = 0
        Instance.new("UICorner", valueBox).CornerRadius = UDim.new(0, 4)
        valueBox.Parent = Frame

        local plusBtn = Instance.new("TextButton")
        plusBtn.Size = UDim2.new(0, 24, 0, 24)
        plusBtn.Position = UDim2.new(0, 212, 0, 5)
        plusBtn.Text = "+"
        plusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        plusBtn.TextColor3 = Color3.new(1,1,1)
        plusBtn.Font = Enum.Font.SourceSansBold
        plusBtn.TextSize = 18
        plusBtn.BorderSizePixel = 0
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4)
        plusBtn.Parent = Frame

        local function setValue(val)
            val = math.clamp(tonumber(val) or default, min, max)
            valueBox.Text = tostring(val)
            Label.Text = text .. ": " .. val
            callback(val)
        end

        minusBtn.MouseButton1Click:Connect(function()
            setValue(tonumber(valueBox.Text) - 1)
        end)
        plusBtn.MouseButton1Click:Connect(function()
            setValue(tonumber(valueBox.Text) + 1)
        end)
        valueBox.FocusLost:Connect(function()
            setValue(tonumber(valueBox.Text))
        end)
    end

    local function AddButton(page, text, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Button.Text = text
        Button.TextColor3 = Color3.fromRGB(240, 240, 240)
        Button.TextSize = 13
        Button.Font = Enum.Font.GothamMedium
        Button.Parent = page

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Button

        Button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    -- ========== VARIÁVEIS DE ESTADO ==========
    local aimbot = false; local aimForce = 1; local bypass = 1; local fovRadius = 150
    local wallCheck = false; local silentAimEnabled = false; local magicBullet = false
    local fovCircle = false; local fovRainbow = false
    local espEnabled = false
    local espBox = false; local espNames = false; local espWeapons = false
    local espTalkingIcon = false; local espSkeleton = false
    local adminsESP = false; local adminsList = false; local espLines = false
    local espDistance = false; local infiniteDistance = false
    local targetNPCs = false; local visibleCheck = false
    local textSize = 14; local skeletonColor = Color3.fromRGB(255,105,180)
    local boxColor = Color3.fromRGB(0,255,0)
    local talkingIconColor = Color3.fromRGB(255,255,255)
    local spectatePlayer = nil
    local infJump = false; local flyEnabled = false; local flySpeed = 50
    local speedEnabled = false; local speedValue = 24
    local s4zxFarm = false; local farmSpeed = 50
    local invisibility = false
    local antiAfk = false; local antiStun = false; local antiFire = false; local autoRespawn = false
    local reach = false; local reachDistance = 15
    local infiniteAmmo = false; local autoReload = false
    local noRecoil = false; local rapidFire = false; local rapidFireDelay = 0.1
    local flyCarEnabled = false; local flyCarSpeed = 50
    local streamerMode = false; local antiLive = false
    local autoEssencia = false; local autoMicha = false
    local godMode = false
    local armaColorida = false; local rgbSpeed = 1
    local tamanhoArma = 1
    local matarUmTiro = false
    local grabbedVehicle = nil
    local vehicleAlign = nil; local vehicleVel = nil; local vehicleGyro = nil
    local toggleKey = nil
    local waitingForKey = false
    local waypointPosition = nil

    function parseColor(input)
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end

    -- ========== PREENCHIMENTO DAS ABAS ==========
    local AimbotPage = CreateTab("Aimbot")
    AddToggle(AimbotPage, "AIMBOT", function(v) aimbot = v end)
    AddSlider(AimbotPage, "Força", 1, 5, 1, function(v) aimForce = v end)
    AddSlider(AimbotPage, "Bypass", 1, 10, 1, function(v) bypass = v end)
    AddSlider(AimbotPage, "FOV Raio", 50, 500, 150, function(v) fovRadius = v end)
    AddToggle(AimbotPage, "WALLCK (Parede)", function(v) wallCheck = v end)
    AddToggle(AimbotPage, "SILENT AIM", function(v) silentAimEnabled = v end)
    AddToggle(AimbotPage, "Magic Bullet", function(v) magicBullet = v end)

    -- Aba ESP com lista de players
    local EspPage = CreateTab("ESP")
    local leftPanel = Instance.new("Frame")
    leftPanel.Size = UDim2.new(0.5, -10, 1, 0)
    leftPanel.BackgroundTransparency = 1
    leftPanel.Parent = EspPage

    local rightPanel = Instance.new("Frame")
    rightPanel.Size = UDim2.new(0.5, -10, 1, 0)
    rightPanel.Position = UDim2.new(0.5, 10, 0, 0)
    rightPanel.BackgroundTransparency = 1
    rightPanel.Parent = EspPage

    -- Opções do lado esquerdo
    local function AddToggleLeft(text, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 35)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Frame.Parent = leftPanel

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -50, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.TextSize = 13
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 40, 0, 20)
        Switch.Position = UDim2.new(1, -48, 0.5, -10)
        Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Switch.Text = ""
        Switch.Parent = Frame

        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(1, 0)
        SwitchCorner.Parent = Switch

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 16, 0, 16)
        Indicator.Position = UDim2.new(0, 2, 0.5, -8)
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
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
            else
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            end
            pcall(callback, enabled)
        end)
    end

    AddToggleLeft("Enable ESP", function(v) espEnabled = v end)
    AddToggleLeft("Box", function(v) espBox = v end)
    AddToggleLeft("Names", function(v) espNames = v end)
    AddToggleLeft("Weapons", function(v) espWeapons = v end)
    AddToggleLeft("Talking Icon", function(v) espTalkingIcon = v end)
    AddToggleLeft("Skeleton", function(v) espSkeleton = v end)
    AddToggleLeft("Admin ESP", function(v) adminsESP = v end)
    AddToggleLeft("Admin List", function(v) adminsList = v end)
    AddToggleLeft("Lines", function(v) espLines = v end)
    AddToggleLeft("Distance", function(v) espDistance = v end)
    AddToggleLeft("Infinite Distance", function(v) infiniteDistance = v end)
    AddToggleLeft("Target NPCs", function(v) targetNPCs = v end)
    AddToggleLeft("Visible Check", function(v) visibleCheck = v end)
    AddSlider(leftPanel, "Text Size", 12, 20, 14, function(v) textSize = v end)
    AddButton(leftPanel, "Skeleton Color", function() skeletonColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
    AddButton(leftPanel, "Box Color", function() boxColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
    AddButton(leftPanel, "Talking Icon Color", function() talkingIconColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)

    -- Lista de players (lado direito)
    local playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Size = UDim2.new(1, 0, 1, 0)
    playerListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    playerListFrame.BorderSizePixel = 0
    playerListFrame.ScrollBarThickness = 3
    playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(220, 30, 30)
    playerListFrame.Parent = rightPanel
    Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0, 5)

    local playerListLayout = Instance.new("UIListLayout")
    playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playerListLayout.Padding = UDim.new(0, 2)
    playerListLayout.Parent = playerListFrame

    -- Função para atualizar a lista de players
    local function updatePlayerList()
        -- Limpar a lista
        for _, child in ipairs(playerListFrame:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end

        local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        local players = Players:GetPlayers()
        for _, p in ipairs(players) do
            if p == Player then continue end
            local chr = p.Character
            local distance = "??"
            if myRoot and chr and chr:FindFirstChild("HumanoidRootPart") then
                distance = string.format("%.1fm", (chr.HumanoidRootPart.Position - myRoot.Position).Magnitude)
            end

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            row.Parent = playerListFrame
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 3)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 5, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = p.Name
            nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            nameLabel.TextSize = 12
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = row

            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(0.2, 0, 1, 0)
            distLabel.Position = UDim2.new(0.4, 0, 0, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = distance
            distLabel.TextColor3 = Color3.fromRGB(200,200,200)
            distLabel.TextSize = 11
            distLabel.Font = Enum.Font.Gotham
            distLabel.TextXAlignment = Enum.TextXAlignment.Center
            distLabel.Parent = row

            -- Botão Espectate
            local specBtn = Instance.new("TextButton")
            specBtn.Size = UDim2.new(0.15, 0, 1, -4)
            specBtn.Position = UDim2.new(0.6, 0, 0, 2)
            specBtn.Text = "👁️"
            specBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            specBtn.TextColor3 = Color3.new(1,1,1)
            specBtn.Font = Enum.Font.Gotham
            specBtn.TextSize = 14
            specBtn.BorderSizePixel = 0
            Instance.new("UICorner", specBtn).CornerRadius = UDim.new(0, 3)
            specBtn.Parent = row
            specBtn.MouseButton1Click:Connect(function()
                if p.Character then
                    spectatePlayer = p
                end
            end)

            -- Botão Teleportar
            local tpBtn = Instance.new("TextButton")
            tpBtn.Size = UDim2.new(0.15, 0, 1, -4)
            tpBtn.Position = UDim2.new(0.76, 0, 0, 2)
            tpBtn.Text = "🚀"
            tpBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            tpBtn.TextColor3 = Color3.new(1,1,1)
            tpBtn.Font = Enum.Font.Gotham
            tpBtn.TextSize = 14
            tpBtn.BorderSizePixel = 0
            Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 3)
            tpBtn.Parent = row
            tpBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local myChar = Player.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                    end
                end
            end)

            -- Botão Puxar
            local pullBtn = Instance.new("TextButton")
            pullBtn.Size = UDim2.new(0.1, 0, 1, -4)
            pullBtn.Position = UDim2.new(0.92, 0, 0, 2)
            pullBtn.Text = "🔄"
            pullBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            pullBtn.TextColor3 = Color3.new(1,1,1)
            pullBtn.Font = Enum.Font.Gotham
            pullBtn.TextSize = 14
            pullBtn.BorderSizePixel = 0
            Instance.new("UICorner", pullBtn).CornerRadius = UDim.new(0, 3)
            pullBtn.Parent = row
            pullBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local myChar = Player.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        local targetRoot = p.Character.HumanoidRootPart
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
        end
    end

    -- Atualizar a lista periodicamente
    task.spawn(function()
        while true do
            task.wait(1) -- atualiza a cada 1 segundo
            pcall(updatePlayerList)
        end
    end)

    -- ========== DEMAIS ABAS ==========
    local VeicPage = CreateTab("Veículos")
    AddButton(VeicPage, "Teleportar no Veículo Próximo", function()
        local char = Player.Character
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
    AddButton(VeicPage, "Destrancar Veículo", function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") then
                v:SetAttribute("Locked", false)
                v.Locked = false
            end
        end
    end)
    AddButton(VeicPage, "Trancar Veículo", function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("VehicleSeat") then
                v:SetAttribute("Locked", true)
                v.Locked = true
            end
        end
    end)
    AddButton(VeicPage, "Marcar Waypoint (posição atual)", function()
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            waypointPosition = char.HumanoidRootPart.Position
            print("Waypoint marcado em: " .. tostring(waypointPosition))
        end
    end)
    AddButton(VeicPage, "TP Waypoint", function()
        if waypointPosition then
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(waypointPosition + Vector3.new(0, 2, 0))
                print("Teleportado para waypoint")
            end
        else
            print("Nenhum waypoint definido.")
        end
    end)

    local VisualPage = CreateTab("Visual")
    AddButton(VisualPage, "Cor Box", function() local c = parseColor("verde") if c then boxColor = c end end)
    AddButton(VisualPage, "Cor Skeleton", function() local c = parseColor("rosa") if c then skeletonColor = c end end)
    AddToggle(VisualPage, "FOV Círculo", function(v) fovCircle = v end)
    AddToggle(VisualPage, "FOV Arco-íris", function(v) fovRainbow = v end)

    local MovPage = CreateTab("Movimento")
    AddToggle(MovPage, "Pulo Infinito", function(v) infJump = v end)
    AddToggle(MovPage, "Fly Avançado", function(v) flyEnabled = v; if not v then flyStartY = nil end end)
    AddSlider(MovPage, "Velocidade Fly", 20, 200, 50, function(v) flySpeed = v end)
    AddToggle(MovPage, "Speed Hack", function(v) speedEnabled = v end)
    AddSlider(MovPage, "Velocidade Speed", 16, 200, 24, function(v) speedValue = v end)
    AddToggle(MovPage, "Ghost Mode (Invisível)", function(v) invisibility = v end)

    local FarmPage = CreateTab("Farm")
    AddToggle(FarmPage, "Auto Farm Lixo", function(v) s4zxFarm = v end)
    AddSlider(FarmPage, "Velocidade Farm", 30, 100, 50, function(v) farmSpeed = v end)
    AddToggle(FarmPage, "Auto Essência", function(v) autoEssencia = v end)
    AddToggle(FarmPage, "Auto Micha (Sintonia RP)", function(v) autoMicha = v end)

    local ArmasPage = CreateTab("Armas")
    AddToggle(ArmasPage, "Reach (Alcance)", function(v) reach = v end)
    AddSlider(ArmasPage, "Distância Reach", 10, 50, 15, function(v) reachDistance = v end)
    AddToggle(ArmasPage, "Infinite Ammo", function(v) infiniteAmmo = v end)
    AddToggle(ArmasPage, "Auto Reload", function(v) autoReload = v end)
    AddToggle(ArmasPage, "No Recoil", function(v) noRecoil = v end)
    AddToggle(ArmasPage, "Rapid Fire", function(v) rapidFire = v end)
    AddSlider(ArmasPage, "Rapid Fire Delay", 0.05, 0.5, 0.1, function(v) rapidFireDelay = v end)
    AddToggle(ArmasPage, "Matar com um Tiro", function(v) matarUmTiro = v end)
    AddToggle(ArmasPage, "Arma Colorida (RGB)", function(v) armaColorida = v end)
    AddSlider(ArmasPage, "Velocidade do RGB", 0.5, 5, 1, function(v) rgbSpeed = v end)
    AddSlider(ArmasPage, "Tamanho da Arma", 0.5, 5, 1, function(v) tamanhoArma = v end)

    local CarroPage = CreateTab("Carro")
    AddToggle(CarroPage, "Fly Car", function(v) flyCarEnabled = v end)
    AddSlider(CarroPage, "Velocidade Fly Car", 20, 200, 50, function(v) flyCarSpeed = v end)

    local ExtrasPage = CreateTab("Extras")
    AddToggle(ExtrasPage, "Anti AFK", function(v) antiAfk = v end)
    AddToggle(ExtrasPage, "Anti Stun", function(v) antiStun = v end)
    AddToggle(ExtrasPage, "Anti Fire", function(v) antiFire = v end)
    AddToggle(ExtrasPage, "Auto Respawn", function(v) autoRespawn = v end)
    AddToggle(ExtrasPage, "God Mode", function(v) godMode = v end)
    AddButton(ExtrasPage, "🖐️ PEGAR (Raycast)", function()
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {Player.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        local result = Workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * 100, rayParams)
        if result then
            local hit = result.Instance
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
    AddButton(ExtrasPage, "💥 TACAR", function()
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

    local ConfigPage = CreateTab("Config")
    AddToggle(ConfigPage, "Modo Streamer", function(v) streamerMode = v; MainFrame.Visible = not v; MinimizedCircle.Visible = v end)
    AddToggle(ConfigPage, "Anti Live", function(v) antiLive = v end)
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Size = UDim2.new(1, 0, 0, 20)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Text = "Tecla Ocultar: Nenhuma"
    keybindLabel.TextColor3 = Color3.fromRGB(230,230,230)
    keybindLabel.Font = Enum.Font.Gotham
    keybindLabel.TextSize = 13
    keybindLabel.Parent = ConfigPage
    local keybindBtn = Instance.new("TextButton")
    keybindBtn.Size = UDim2.new(1, 0, 0, 35)
    keybindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    keybindBtn.Text = "Definir Tecla (Ocultar/Mostrar)"
    keybindBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    keybindBtn.TextSize = 13
    keybindBtn.Font = Enum.Font.GothamMedium
    keybindBtn.Parent = ConfigPage
    Instance.new("UICorner", keybindBtn).CornerRadius = UDim.new(0, 5)
    keybindBtn.MouseButton1Click:Connect(function()
        waitingForKey = true
        keybindBtn.Text = "Pressione uma tecla..."
    end)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if waitingForKey and input.KeyCode ~= Enum.KeyCode.Unknown then
            waitingForKey = false
            toggleKey = input.KeyCode
            keybindBtn.Text = "Definir Tecla (Ocultar/Mostrar)"
            keybindLabel.Text = "Tecla Ocultar: " .. tostring(toggleKey.Name)
        elseif toggleKey and input.KeyCode == toggleKey and not gameProcessed then
            if MainFrame.Visible then
                MainFrame.Visible = false
                MinimizedCircle.Visible = true
            else
                MinimizedCircle.Visible = false
                MainFrame.Visible = true
            end
        end
    end)

    local SegPage = CreateTab("Segurança")
    AddButton(SegPage, "🔑 Key: S4zx-DonoSupreme2026", function() end)
    AddButton(SegPage, "🚫 Blacklist: Ativo", function() end)
    AddButton(SegPage, "💻 HWID: Verificado", function() end)
    AddButton(SegPage, "🛡️ Anti-adulteração: Ativo", function() end)
    AddButton(SegPage, "🔄 Checagem remota: 5min", function() end)

    -- ========== ESP REESCRITO ==========
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

    local function worldToScreen(pos)
        local vec, onScreen = Camera:WorldToViewportPoint(pos)
        return Vector2.new(vec.X, vec.Y), onScreen
    end

    local function isAdmin(player)
        if not player or not player.Name then return false end
        local name = player.Name:lower()
        local keywords = {"admin","mod","staff","owner","dev","gerente","helper","moderador"}
        for _, kw in ipairs(keywords) do
            if name:find(kw) then return true end
        end
        return false
    end

    task.spawn(function()
        while true do
            task.wait(0.05)
            if not espEnabled then
                clearESPObjects()
                if fovCircleObj then fovCircleObj.Visible = false end
                continue
            end

            clearESPObjects()
            local screenSize = Camera.ViewportSize
            local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            local targets = {}

            for _, p in ipairs(Players:GetPlayers()) do
                if p == Player then continue end
                local chr = p.Character
                if chr and chr:FindFirstChild("HumanoidRootPart") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
                    table.insert(targets, {player = p, char = chr})
                end
            end
            if targetNPCs then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                        if obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 then
                            table.insert(targets, {player = obj, char = obj, isNPC = true})
                        end
                    end
                end
            end

            -- Admin List
            if adminsList then
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

                local isAdminTarget = (not target.isNPC and isAdmin(target.player))

                local headPos2D, headOn = worldToScreen(head.Position + Vector3.new(0, 1.5, 0))
                local rootPos2D, rootOn = worldToScreen(root.Position)
                local feetPos2D, feetOn = worldToScreen(root.Position - Vector3.new(0, 3, 0))

                if not headOn and not infiniteDistance then continue end

                local isVisible = true
                if visibleCheck then
                    local params = RaycastParams.new()
                    params.FilterDescendantsInstances = {Player.Character}
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, params)
                    if result and not result.Instance:IsDescendantOf(char) then isVisible = false end
                end

                local dist = myRoot and (root.Position - myRoot.Position).Magnitude or 0
                local weaponName = ""
                if espWeapons then
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool and tool.Name ~= "" then
                        weaponName = tool.Name
                    end
                end

                local color = isVisible and boxColor or Color3.fromRGB(150,150,150)
                if isAdminTarget and adminsESP then
                    color = Color3.fromRGB(255,0,0)
                end

                -- Box
                if espBox and headOn and feetOn then
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

                -- Skeleton
                if espSkeleton then
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
                                    Color = color,
                                    Thickness = 2
                                })
                            end
                        end
                    end
                end

                -- Name
                if espNames and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X, headPos2D.Y - 22),
                        Text = target.player.Name or "NPC",
                        Color = color,
                        Size = textSize,
                        Center = true,
                        Outline = true,
                        OutlineColor = Color3.new(0,0,0)
                    })
                end

                -- Weapon
                if espWeapons and weaponName ~= "" and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X, headPos2D.Y + 30),
                        Text = weaponName,
                        Color = Color3.new(1,1,0),
                        Size = 12,
                        Center = true
                    })
                end

                -- Distance
                if espDistance and myRoot and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X, headPos2D.Y + 15),
                        Text = math.floor(dist) .. "m",
                        Color = Color3.new(1,1,1),
                        Size = 12,
                        Center = true
                    })
                end

                -- Lines (do centro inferior da tela ao alvo)
                if espLines and rootOn then
                    createESPObject("Line", {
                        From = Vector2.new(screenSize.X / 2, screenSize.Y),
                        To = rootPos2D,
                        Color = color,
                        Thickness = 1
                    })
                end

                -- Talking Icon
                if espTalkingIcon and headOn then
                    createESPObject("Text", {
                        Position = Vector2.new(headPos2D.X + 15, headPos2D.Y - 10),
                        Text = "🗣️",
                        Color = talkingIconColor,
                        Size = 12,
                        Center = true
                    })
                end
            end

            -- FOV Circle (certificar-se de que é criado e visível)
            if fovCircle then
                if not fovCircleObj then
                    fovCircleObj = Drawing.new("Circle")
                    fovCircleObj.Visible = true
                    fovCircleObj.Thickness = 2
                    fovCircleObj.Filled = false
                    fovCircleObj.Color = Color3.new(1,1,1)
                end
                fovCircleObj.Position = screenSize / 2
                fovCircleObj.Radius = fovRadius
                fovCircleObj.Visible = true
                if fovRainbow then
                    fovCircleObj.Color = Color3.fromHSV(tick() % 1, 1, 1)
                else
                    fovCircleObj.Color = Color3.new(1,1,1)
                end
            elseif fovCircleObj then
                fovCircleObj.Visible = false
            end
        end
    end)

    -- ========== SILENT AIM ==========
    local function getSilentTarget()
        if not silentAimEnabled then return nil end
        local closest, closestDist = nil, fovRadius
        local center = Camera.ViewportSize / 2
        local myPos = Camera.CFrame.Position
        for _, p in ipairs(Players:GetPlayers()) do
            if p == Player then continue end
            local chr = p.Character
            if not chr then continue end
            local head = chr:FindFirstChild("Head")
            local hum = chr:FindFirstChild("Humanoid")
            if not head or not hum or hum.Health <= 0 then continue end
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if not onScreen then continue end
            local dist2d = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
            if dist2d > fovRadius then continue end
            if wallCheck then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {Player.Character}
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

    local function silentAimLoop()
        if not silentAimEnabled then return end
        local target = getSilentTarget()
        if target then
            local headPos = target.Head.Position
            if magicBullet then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
            else
                -- Ajuste suave na mira para dar feedback visual
                local newCF = CFrame.new(Camera.CFrame.Position, headPos)
                Camera.CFrame = Camera.CFrame:Lerp(newCF, 0.2)
            end
        end
    end

    -- ========== AUTO FARM LIXO ==========
    local farmThread = nil
    task.spawn(function()
        while true do
            task.wait(0.1)
            if not s4zxFarm then
                if farmThread then farmThread = nil end
                continue
            end
            if farmThread then continue end
            farmThread = true

            local char = Player.Character
            if not char then farmThread = false; continue end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then farmThread = false; continue end

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
                    local newPos = root.Position + direction * (farmSpeed * 0.05)
                    root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.5)
                else
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool then
                        pcall(function() tool:Activate() end)
                    end
                    task.wait(0.3)
                end
            end
            task.wait(0.05)
            farmThread = false
        end
    end)

    -- ========== AUTO ESSÊNCIA ==========
    task.spawn(function()
        local lastEssencePick = 0
        while true do
            task.wait(0.5)
            if not autoEssencia then continue end
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            local root = char.HumanoidRootPart
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("essencia") or obj.Name:lower():find("essence")) then
                    if tick() - lastEssencePick > 1.5 then
                        root.CFrame = obj.CFrame + Vector3.new(0, 2, 0)
                        lastEssencePick = tick()
                        local tool = char:FindFirstChildWhichIsA("Tool")
                        if tool then pcall(function() tool:Activate() end) end
                        break
                    end
                end
            end
        end
    end)

    -- ========== AUTO MICHA ==========
    task.spawn(function()
        while true do
            task.wait(0.5)
            if not autoMicha then continue end
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            local tool = char:FindFirstChild("Micha") or Player.Backpack:FindFirstChild("Micha")
            if tool and tool:IsA("Tool") then
                if tool.Parent ~= char then tool.Parent = char end
                pcall(function() tool:Activate() end)
            end
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    local objText = prompt.ObjectText:lower()
                    local actText = prompt.ActionText:lower()
                    if objText:find("micha") or actText:find("roubar") or actText:find("micha") or objText:find("veiculo") then
                        if Player:DistanceFromCharacter(prompt.Parent.Position) <= prompt.MaxActivationDistance then
                            pcall(function() fireproximityprompt(prompt) end)
                        end
                    end
                end
            end
        end
    end)

    -- ========== FLY CAR ==========
    local flyCarBV, flyCarBG, flyCarTarget
    task.spawn(function()
        while true do
            task.wait(0.05)
            if not flyCarEnabled then
                if flyCarBV then flyCarBV:Destroy(); flyCarBV = nil end
                if flyCarBG then flyCarBG:Destroy(); flyCarBG = nil end
                flyCarTarget = nil
                continue
            end
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            if not flyCarTarget or not flyCarTarget.Parent then
                local nearest, nearestDist = nil, math.huge
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("VehicleSeat") or (obj:IsA("Seat") and obj:FindFirstAncestorOfClass("Model")) then
                        local car = obj:FindFirstAncestorOfClass("Model")
                        if car then
                            local p = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                            if p then
                                local d = (p.Position - char.HumanoidRootPart.Position).Magnitude
                                if d < nearestDist then nearestDist = d; flyCarTarget = car end
                            end
                        end
                    end
                end
            end
            if not flyCarTarget then continue end
            local primary = flyCarTarget:FindFirstChild("PrimaryPart") or flyCarTarget:FindFirstChildWhichIsA("BasePart")
            if not primary then continue end
            if not flyCarBV or not flyCarBV.Parent then
                flyCarBV = Instance.new("BodyVelocity")
                flyCarBV.MaxForce = Vector3.new(1e9,1e9,1e9)
                flyCarBV.Parent = primary
            end
            if not flyCarBG or not flyCarBG.Parent then
                flyCarBG = Instance.new("BodyGyro")
                flyCarBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
                flyCarBG.Parent = primary
            end
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
            if moveDir.Magnitude > 0 then
                flyCarBV.Velocity = moveDir.Unit * (flyCarSpeed * 0.5)
            else
                flyCarBV.Velocity = Vector3.new(0,0,0)
            end
            flyCarBG.CFrame = CFrame.new(primary.Position, primary.Position + Camera.CFrame.LookVector)
        end
    end)

    -- ========== DEMAIS FUNÇÕES ==========
    local flyStartY

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
                        local params = RaycastParams.new()
                        params.FilterDescendantsInstances = {Player.Character}
                        params.FilterType = Enum.RaycastFilterType.Blacklist
                        local result = Workspace:Raycast(Camera.CFrame.Position, (chr.Head.Position - Camera.CFrame.Position).Unit * 1000, params)
                        if result and not result.Instance:IsDescendantOf(chr) then continue end
                    end
                    table.insert(enemies, {chr=chr, dist=(Vector2.new(pos.X,pos.Y)-center).Magnitude})
                end
            end
        end
        if #enemies > 0 then
            table.sort(enemies, function(a,b) return a.dist < b.dist end)
            local targetPos = enemies[1].chr.Head.Position + Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)*(bypass*0.03)
            local alpha = 0.02 + (aimForce-1)*0.245
            if alpha >= 1 then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha) end
        end
    end

    local function speedStep()
        if not speedEnabled then return end
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local delta = speedValue / 60
                    local newPos = char.HumanoidRootPart.Position + moveDir.Unit * delta
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame:Lerp(CFrame.new(newPos), 0.8)
                end
            end
        end
    end

    local function flyStep()
        if not flyEnabled then flyStartY = nil; return end
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local root = char.HumanoidRootPart
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = true end
        if not flyStartY then flyStartY = root.Position.Y end
        local camDir = Camera.CFrame.LookVector
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(camDir.X, 0, camDir.Z).Unit end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(camDir.X, 0, camDir.Z).Unit end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then flyStartY = flyStartY + flySpeed * 0.15 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then flyStartY = flyStartY - flySpeed * 0.15 end
        local newPos = root.Position
        if moveDir.Magnitude > 0 then newPos = root.Position + moveDir.Unit * (flySpeed * 0.2) end
        newPos = Vector3.new(newPos.X, flyStartY, newPos.Z)
        root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.5)
    end

    local function invisibilityStep()
        if not invisibility then return end
        local char = Player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.8
                end
            end
        end
    end

    local function reachStep()
        if reach then
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then tool.MaxActivationDistance = reachDistance end
        end
    end

    local function infiniteAmmoStep()
        if infiniteAmmo then
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets") or tool:FindFirstChild("Magazine")
                if ammo and ammo:IsA("IntValue") then ammo.Value = 999 end
            end
        end
    end

    local function autoReloadStep()
        if autoReload then
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets")
                if ammo and ammo:IsA("IntValue") and ammo.Value == 0 then
                    pcall(function() tool:Reload() end)
                end
            end
        end
    end

    local function noRecoilStep()
        if noRecoil then
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                for _, obj in ipairs(tool:GetDescendants()) do
                    if obj:IsA("SpringConstraint") or obj:IsA("RocketPropulsion") then
                        obj.Enabled = false
                    end
                end
            end
        end
    end

    local rapidFireTimer = 0
    local function rapidFireStep()
        if not rapidFire then return end
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool and tick() - rapidFireTimer >= rapidFireDelay then
                pcall(function() tool:Activate() end)
                rapidFireTimer = tick()
            end
        end
    end

    local function armaColoridaStep()
        if armaColorida then
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                local hue = (tick() * rgbSpeed) % 1
                local color = Color3.fromHSV(hue, 1, 1)
                for _, part in ipairs(tool:GetDescendants()) do
                    if part:IsA("BasePart") then part.Color = color end
                end
            end
        end
    end

    local function tamanhoArmaStep()
        local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
        if tool then tool:ScaleTo(tamanhoArma) end
    end

    local function matarUmTiroStep()
        if matarUmTiro then
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                for _, v in ipairs(tool:GetDescendants()) do
                    if v.Name == "Damage" and v:IsA("NumberValue") then
                        v.Value = 9999
                    end
                end
            end
        end
    end

    local function godModeStep()
        if godMode then
            local char = Player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.MaxHealth = 1e9
                    hum.Health = 1e9
                end
            end
        end
    end

    local lastAfkTime = 0
    local function antiAfkStep()
        if antiAfk and tick() - lastAfkTime > 120 then
            lastAfkTime = tick()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
            end
        end
    end

    local function antiStunStep()
        if antiStun then
            local char = Player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                end
            end
        end
    end

    local function antiFireStep()
        if antiFire then
            local char = Player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.Material == Enum.Material.Fire then
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
        end
    end

    local function autoRespawnStep()
        if autoRespawn then
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then
                pcall(function() Player:LoadCharacter() end)
            end
        end
    end

    local staffFrame
    local function updateStaffCounter()
        if not staffFrame then return end
        local count = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if isAdmin(p) then count = count + 1 end
        end
        staffFrame.Text = "Staff: " .. count
    end

    task.delay(1, function()
        local staffGui = Instance.new("ScreenGui", CoreGui)
        staffGui.Name = "StaffCounter"
        staffGui.ResetOnSpawn = false
        staffFrame = Instance.new("TextLabel", staffGui)
        staffFrame.Size = UDim2.new(0, 100, 0, 30)
        staffFrame.Position = UDim2.new(0.8, -50, 0.1, 0)
        staffFrame.BackgroundColor3 = Color3.new(0,0,0)
        staffFrame.Text = "Staff: 0"
        staffFrame.TextColor3 = Color3.new(0,1,0)
        staffFrame.Font = Enum.Font.SourceSansBold
        staffFrame.TextSize = 14
        Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0,4)
        updateStaffCounter()
    end)

    UserInputService.JumpRequest:Connect(function()
        if infJump then
            local c = Player.Character
            if c and c:FindFirstChild("Humanoid") then
                c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- ========== LOOP PRINCIPAL ==========
    local lastLiveCheck = 0
    RunService.RenderStepped:Connect(function()
        pcall(aimbotStep)
        pcall(silentAimLoop)
        pcall(speedStep)
        pcall(flyStep)
        pcall(invisibilityStep)
        pcall(reachStep)
        pcall(infiniteAmmoStep)
        pcall(autoReloadStep)
        pcall(noRecoilStep)
        pcall(rapidFireStep)
        pcall(armaColoridaStep)
        pcall(tamanhoArmaStep)
        pcall(matarUmTiroStep)
        pcall(godModeStep)
        pcall(antiAfkStep)
        pcall(antiStunStep)
        pcall(antiFireStep)
        pcall(autoRespawnStep)
        pcall(updateStaffCounter)

        if grabbedVehicle then
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local targetPos = root.Position + root.CFrame.LookVector * 10 + Vector3.new(0, 2, 0)
                if vehicleAlign then vehicleAlign.Position = targetPos end
            end
        end

        if spectatePlayer and spectatePlayer.Character then
            Camera.CameraSubject = spectatePlayer.Character
        else
            Camera.CameraSubject = Player.Character
        end

        if antiLive and tick() - lastLiveCheck > 1 then
            lastLiveCheck = tick()
            MainFrame.Visible = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
        end
    end)

    script.Destroying:Connect(function()
        if flyCarBV then flyCarBV:Destroy() end
        if flyCarBG then flyCarBG:Destroy() end
        if fovCircleObj then fovCircleObj:Remove() end
        if vehicleAlign then vehicleAlign:Destroy() end
        if vehicleVel then vehicleVel:Destroy() end
        if vehicleGyro then vehicleGyro:Destroy() end
        clearESPObjects()
        if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
        local c = Player.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.PlatformStand = false
            c.Humanoid.WalkSpeed = 16
        end
        Camera.FieldOfView = 70
    end)
end

mostrarLogin()
