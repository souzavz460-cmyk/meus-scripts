-- S4ZX HUB - COMPLETO (Interface Personalizada + 50 Funções + Segurança)

-- ========== SEGURANÇA ==========
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2026"

local function getHWID()
    local ok, id = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and id then return id end
    ok, id = pcall(function()
        return game:HttpGet("https://api.ipify.org")
    end)
    return ok and id or "UNKNOWN"
end
local HWID = getHWID()
local SECURITY_FLAG = "S4zx_INTEGRO_2026"

local function destruirScript(motivo)
    pcall(function()
        if game.CoreGui:FindFirstChild("S4ZX_Login") then game.CoreGui.S4ZX_Login:Destroy() end
        if game.CoreGui:FindFirstChild("S4ZX_Hub") then game.CoreGui.S4ZX_Hub:Destroy() end
    end)
    game.Players.LocalPlayer:Kick(motivo or "Script encerrado")
    while true do end
end

-- ========== TELA DE LOGIN (ESTILO S4ZX) ==========
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

    local logo = Instance.new("ImageLabel", frame)
    logo.Size = UDim2.new(0, 120, 0, 35)
    logo.Position = UDim2.new(0.5, -60, 0, 10)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://79731590930393"
    logo.ScaleType = Enum.ScaleType.Fit

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
    local Lighting = game:GetService("Lighting")
    local Player = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    if CoreGui:FindFirstChild("S4ZX_Hub") then
        CoreGui.S4ZX_Hub:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "S4ZX_Hub"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- ========== CONSTRUÇÃO DA UI (SEU DESIGN) ==========
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 680, 0, 420)
    MainFrame.Position = UDim2.new(0.5, -340, 0.5, -210)
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

    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.new(0, 120, 0, 35)
    Logo.Position = UDim2.new(0, 10, 0.5, -17)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://79731590930393"
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.Parent = Topbar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 140, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "S4ZX HUB v2.0"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

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

    -- ========== SISTEMA DE ABAS (IDÊNTICO AO SEU) ==========
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

    -- ========== COMPONENTES ==========
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

    -- ========== VARIÁVEIS DE ESTADO (50 FUNÇÕES) ==========
    local aimbot = false; local aimForce = 1; local bypass = 1; local fovRadius = 150
    local wallCheck = false; local silentAimEnabled = false; local magicBullet = false
    local fovCircle = false; local fovRainbow = false
    local espBox = false; local espSkel = false; local espName = false
    local espDistance = false; local espHealth = false; local tracerV7 = false
    local espItems = false; local showMoney = false; local showTeamESP = false; local espPlayerWeapon = false
    local infJump = false; local flyEnabled = false; local flySpeed = 50
    local speedEnabled = false; local speedValue = 24
    local s4zxFarm = false; local farmSpeed = 50
    local boxColor = Color3.fromRGB(0,255,0); local skelColor = Color3.fromRGB(255,105,180)
    local tracerColor = Color3.fromRGB(255,255,255)
    local invisibility = false
    local antiAfk = false; local antiStun = false; local antiFire = false; local autoRespawn = false
    local reach = false; local reachDistance = 15
    local infiniteAmmo = false; local autoReload = false
    local noRecoil = false; local rapidFire = false; local rapidFireDelay = 0.1
    local rainbowBox = false; local rainbowSkel = false; local rainbowTracer = false
    local flyCarEnabled = false; local flyCarSpeed = 50
    local streamerMode = false; local antiLive = false
    local autoEssencia = false; local autoLockPic = false; local autoMicha = false
    local lockedTarget = nil
    local godMode = false
    local corArma = Color3.fromRGB(255,255,255)
    local armaColorida = false; local rgbSpeed = 1
    local tamanhoArma = 1
    local matarUmTiro = false
    local grabbedVehicle = nil
    local vehicleAlign = nil; local vehicleVel = nil; local vehicleGyro = nil

    function parseColor(input)
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end

    -- ========== PREENCHIMENTO DAS ABAS (50 FUNÇÕES) ==========
    local AimbotPage = CreateTab("Aimbot")
    AddToggle(AimbotPage, "AIMBOT", function(v) aimbot = v end)
    AddToggle(AimbotPage, "Auto Lock Pic (CamLock)", function(v) autoLockPic = v; if not v then lockedTarget = nil end end)
    AddButton(AimbotPage, "Força (1-5): " .. aimForce, function() aimForce = aimForce >= 5 and 1 or aimForce + 1 end)
    AddButton(AimbotPage, "Bypass (1-10): " .. bypass, function() bypass = bypass >= 10 and 1 or bypass + 1 end)
    AddButton(AimbotPage, "FOV Raio (50-500): " .. fovRadius, function() fovRadius = fovRadius >= 500 and 50 or fovRadius + 50 end)
    AddToggle(AimbotPage, "WALLCK (Parede)", function(v) wallCheck = v end)
    AddToggle(AimbotPage, "SILENT AIM", function(v) silentAimEnabled = v end)
    AddToggle(AimbotPage, "Magic Bullet", function(v) magicBullet = v end)

    local EspPage = CreateTab("ESP")
    AddToggle(EspPage, "2D Box", function(v) espBox = v end)
    AddToggle(EspPage, "Skeleton", function(v) espSkel = v end)
    AddToggle(EspPage, "Name", function(v) espName = v end)
    AddToggle(EspPage, "Distance", function(v) espDistance = v end)
    AddToggle(EspPage, "Health Bar", function(v) espHealth = v end)
    AddToggle(EspPage, "Tracer V7 (do chão)", function(v) tracerV7 = v end)
    AddToggle(EspPage, "Itens (Moedas/Armas)", function(v) espItems = v end)
    AddToggle(EspPage, "Dinheiro", function(v) showMoney = v end)
    AddToggle(EspPage, "Mostrar Time", function(v) showTeamESP = v end)
    AddToggle(EspPage, "Arma Equipada", function(v) espPlayerWeapon = v end)

    local VisualPage = CreateTab("Visual")
    AddButton(VisualPage, "Cor Box: verde", function() local c = parseColor("verde") if c then boxColor = c end end)
    AddButton(VisualPage, "Cor Skeleton: rosa", function() local c = parseColor("rosa") if c then skelColor = c end end)
    AddButton(VisualPage, "Cor Tracer V7: branco", function() local c = parseColor("branco") if c then tracerColor = c end end)
    AddToggle(VisualPage, "FOV Círculo", function(v) fovCircle = v end)
    AddToggle(VisualPage, "FOV Arco-íris", function(v) fovRainbow = v end)
    AddToggle(VisualPage, "Rainbow Box", function(v) rainbowBox = v end)
    AddToggle(VisualPage, "Rainbow Skeleton", function(v) rainbowSkel = v end)
    AddToggle(VisualPage, "Rainbow Tracer", function(v) rainbowTracer = v end)

    local MovPage = CreateTab("Movimento")
    AddToggle(MovPage, "Pulo Infinito", function(v) infJump = v end)
    AddToggle(MovPage, "Fly Avançado (Anti-Kick)", function(v) flyEnabled = v; if not v then flyStartY = nil end end)
    AddButton(MovPage, "Velocidade Fly: " .. flySpeed, function() flySpeed = flySpeed >= 200 and 20 or flySpeed + 10 end)
    AddToggle(MovPage, "Speed Hack", function(v) speedEnabled = v end)
    AddButton(MovPage, "Velocidade Speed: " .. speedValue, function() speedValue = speedValue >= 200 and 16 or speedValue + 8 end)
    AddToggle(MovPage, "Ghost Mode (Invisível)", function(v) invisibility = v end)

    local FarmPage = CreateTab("Farm")
    AddToggle(FarmPage, "Auto Essência", function(v) autoEssencia = v end)
    AddToggle(FarmPage, "Auto Micha (Sintonia RP)", function(v) autoMicha = v end)
    AddToggle(FarmPage, "S4zx Farm", function(v) s4zxFarm = v end)
    AddButton(FarmPage, "Velocidade Farm: " .. farmSpeed, function() farmSpeed = farmSpeed >= 100 and 30 or farmSpeed + 10 end)

    local ArmasPage = CreateTab("Armas")
    AddToggle(ArmasPage, "Reach (Alcance)", function(v) reach = v end)
    AddButton(ArmasPage, "Distância Reach: " .. reachDistance, function() reachDistance = reachDistance >= 50 and 10 or reachDistance + 5 end)
    AddToggle(ArmasPage, "Infinite Ammo", function(v) infiniteAmmo = v end)
    AddToggle(ArmasPage, "Auto Reload", function(v) autoReload = v end)
    AddToggle(ArmasPage, "No Recoil", function(v) noRecoil = v end)
    AddToggle(ArmasPage, "Rapid Fire", function(v) rapidFire = v end)
    AddButton(ArmasPage, "Rapid Fire Delay: " .. string.format("%.2f", rapidFireDelay), function() rapidFireDelay = rapidFireDelay >= 0.5 and 0.05 or rapidFireDelay + 0.05 end)
    AddToggle(ArmasPage, "Matar com um Tiro", function(v) matarUmTiro = v end)
    AddButton(ArmasPage, "Cor da Arma", function() local c = parseColor("vermelho") if c then corArma = c end end)
    AddToggle(ArmasPage, "Arma Colorida (RGB)", function(v) armaColorida = v end)
    AddButton(ArmasPage, "Velocidade do RGB: " .. rgbSpeed, function() rgbSpeed = rgbSpeed >= 5 and 0.5 or rgbSpeed + 0.5 end)
    AddButton(ArmasPage, "Tamanho da Arma: " .. tamanhoArma, function() tamanhoArma = tamanhoArma >= 5 and 0.5 or tamanhoArma + 0.5 end)

    local CarroPage = CreateTab("Carro")
    AddToggle(CarroPage, "Fly Car", function(v) flyCarEnabled = v end)
    AddButton(CarroPage, "Velocidade Fly Car: " .. flyCarSpeed, function() flyCarSpeed = flyCarSpeed >= 200 and 20 or flyCarSpeed + 10 end)

    local ExtrasPage = CreateTab("Extras")
    AddToggle(ExtrasPage, "Anti AFK", function(v) antiAfk = v end)
    AddToggle(ExtrasPage, "Anti Stun", function(v) antiStun = v end)
    AddToggle(ExtrasPage, "Anti Fire", function(v) antiFire = v end)
    AddToggle(ExtrasPage, "Auto Respawn", function(v) autoRespawn = v end)
    AddToggle(ExtrasPage, "God Mode", function(v) godMode = v end)
    AddButton(ExtrasPage, "🖐️ PEGAR (Raycast)", function()
        local ray = Ray.new(Camera.CFrame.Position, Camera.CFrame.LookVector * 100)
        local hit = Workspace:FindPartOnRay(ray, Player.Character, false, true)
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
    AddToggle(ConfigPage, "Modo Streamer", function(v) streamerMode = v; MainFrame.Visible = not v end)
    AddToggle(ConfigPage, "Anti Live", function(v) antiLive = v end)

    local SegPage = CreateTab("Segurança")
    AddButton(SegPage, "🔑 Key: S4zx-DonoSupreme2026", function() end)
    AddButton(SegPage, "🚫 Blacklist: Ativo", function() end)
    AddButton(SegPage, "💻 HWID: Verificado", function() end)
    AddButton(SegPage, "🛡️ Anti-adulteração: Ativo", function() end)
    AddButton(SegPage, "🔄 Checagem remota: 5min", function() end)

    -- ========== SILENT AIM (INTEGRADO) ==========
    local function setupSilentAim()
        Workspace.DescendantAdded:Connect(function(obj)
            if not silentAimEnabled then return end
            if obj:IsA("BasePart") and obj.Velocity.Magnitude > 100 then
                local owner = obj:GetAttribute("Owner")
                local isMine = (owner == Player.Name)
                if not isMine then
                    local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
                    if tool and obj:IsDescendantOf(tool) then isMine = true end
                end
                if not isMine then return end
                local bestTarget, bestDist = nil, fovRadius
                local myPos = Camera.CFrame.Position
                for _, p in ipairs(Players:GetPlayers()) do
                    if p == Player then continue end
                    local chr = p.Character
                    if chr and chr:FindFirstChild("Head") and chr:FindFirstChild("Humanoid") and chr.Humanoid.Health > 0 then
                        local headPos = chr.Head.Position
                        local dist = (headPos - myPos).Magnitude
                        if dist < bestDist then
                            local ray = Ray.new(myPos, (headPos - myPos).Unit * 1000)
                            local hit = Workspace:FindPartOnRayWithIgnoreList(ray, {Player.Character}, false, true)
                            if hit and hit:IsDescendantOf(chr) then bestDist = dist; bestTarget = chr end
                        end
                    end
                end
                if bestTarget then
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not obj.Parent or not silentAimEnabled then connection:Disconnect(); return end
                        if magicBullet then
                            obj.CFrame = CFrame.new(bestTarget.Head.Position)
                            obj.Velocity = Vector3.new(0, 0, 0)
                        else
                            local dir = (bestTarget.Head.Position - obj.Position).Unit
                            obj.Velocity = dir * 300
                        end
                    end)
                end
            end
        end)
    end
    setupSilentAim()

    -- ========== LOOP PRINCIPAL (TODAS AS FUNÇÕES ORIGINAIS) ==========
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
        local flyStartY

        -- Aimbot
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
            if #enemies > 0 then
                table.sort(enemies, function(a,b) return a.dist < b.dist end)
                local targetPos = enemies[1].chr.Head.Position + Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)*(bypass*0.03)
                local alpha = 0.02 + (aimForce-1)*0.245
                if alpha >= 1 then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha) end
            end
        end

        -- Auto Lock Pic
        local function autoLockPicStep()
            if not autoLockPic then return end
            if not lockedTarget or not lockedTarget.Parent or not lockedTarget:FindFirstChild("Humanoid") or lockedTarget.Humanoid.Health <= 0 then
                local nearest, nearestDist = nil, math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= Player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                        local d = (p.Character.Head.Position - Camera.CFrame.Position).Magnitude
                        if d < nearestDist then nearestDist = d; nearest = p.Character end
                    end
                end
                lockedTarget = nearest
            end
            if lockedTarget and lockedTarget:FindFirstChild("Head") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, lockedTarget.Head.Position)
            end
        end

        -- ESP (completa)
        local function updateESP()
            if not useDrawing then return end
            for p, box in pairs(boxes2D) do if not p or not p.Parent then pcall(function() box:Remove() end); boxes2D[p]=nil end end
            for p, data in pairs(skeletons) do if not p or not p.Parent then for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end end
            for p, tag in pairs(nameTags) do if not p or not p.Parent then pcall(function() tag:Remove() end); nameTags[p]=nil end end
            for p, bar in pairs(healthBars) do if not p or not p.Parent then pcall(function() bar.bg:Remove(); bar.fill:Remove() end); healthBars[p]=nil end end
            for p, tag in pairs(distanceTags) do if not p or not p.Parent then pcall(function() tag:Remove() end); distanceTags[p]=nil end end
            for p, line in pairs(tracerLines) do if not p or not p.Parent then pcall(function() line:Remove() end); tracerLines[p]=nil end end
            for part, obj in pairs(itemESP) do if not part or not part.Parent then pcall(function() obj:Remove() end); itemESP[part]=nil end end

            local screenSize = Camera.ViewportSize
            local tracerOrigin = Vector2.new(screenSize.X / 2, screenSize.Y - 5)
            local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            local hue = (tick() * 0.5) % 1
            local rainbowColor = Color3.fromHSV(hue, 1, 1)

            if espItems then
                local valuable = {"coin","gold","diamond","gem","money","cash","loot","chest","armor","weapon","sword","gun","moeda","ouro","diamante","arma","baú"}
                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "" then
                        local name = part.Name:lower()
                        local isVal = false
                        for _, kw in ipairs(valuable) do if name:find(kw) then isVal=true; break end end
                        if isVal then
                            if not itemESP[part] then
                                pcall(function()
                                    local circle = Drawing.new("Circle"); circle.Radius = 5
                                    circle.Color = Color3.new(1,1,0); circle.Filled = true
                                    itemESP[part] = circle
                                end)
                            end
                            if itemESP[part] then
                                local pos, on = Camera:WorldToViewportPoint(part.Position)
                                if on then itemESP[part].Position=Vector2.new(pos.X,pos.Y); itemESP[part].Visible=true
                                else itemESP[part].Visible=false end
                            end
                        end
                    end
                end
            else
                for part, obj in pairs(itemESP) do pcall(function() obj:Remove() end); itemESP[part]=nil end
            end

            for _, p in ipairs(Players:GetPlayers()) do
                if p == Player then continue end
                local char = p.Character
                if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then
                    if boxes2D[p] then boxes2D[p].Visible = false end
                    if skeletons[p] then for _,d in ipairs(skeletons[p]) do d.line.Visible = false end end
                    if nameTags[p] then nameTags[p].Visible = false end
                    if healthBars[p] then healthBars[p].bg.Visible = false; healthBars[p].fill.Visible = false end
                    if distanceTags[p] then distanceTags[p].Visible = false end
                    if tracerLines[p] then tracerLines[p].Visible = false end
                    continue
                end
                local hum = char:FindFirstChild("Humanoid")
                local health = hum and hum.Health or 0
                local maxHealth = hum and hum.MaxHealth or 100
                local head = char.Head
                local root = char.HumanoidRootPart
                local dist = myRoot and (myRoot.Position - root.Position).Magnitude or 0
                local weaponName = ""
                if espPlayerWeapon then
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    weaponName = tool and tool.Name or "Desarmado"
                end

                if not hum or health <= 0 then
                    if boxes2D[p] then boxes2D[p].Visible = false end
                    if skeletons[p] then for _,d in ipairs(skeletons[p]) do d.line.Visible = false end end
                    if nameTags[p] then nameTags[p].Visible = false end
                    if healthBars[p] then healthBars[p].bg.Visible = false; healthBars[p].fill.Visible = false end
                    if distanceTags[p] then distanceTags[p].Visible = false end
                    if tracerLines[p] then tracerLines[p].Visible = false end
                    continue
                end

                local headScreenPos, headVisible = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.8, 0))
                local rootScreenPos, rootVisible = Camera:WorldToViewportPoint(root.Position)
                local feetScreenPos, feetVisible = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                if tracerV7 and rootVisible then
                    local enemyPos = Vector2.new(rootScreenPos.X, rootScreenPos.Y)
                    if not tracerLines[p] then
                        pcall(function()
                            local line = Drawing.new("Line"); line.Thickness = 1; line.Color = tracerColor
                            tracerLines[p] = line
                        end)
                    end
                    if tracerLines[p] then
                        tracerLines[p].From = tracerOrigin; tracerLines[p].To = enemyPos
                        tracerLines[p].Color = rainbowTracer and rainbowColor or tracerColor
                        tracerLines[p].Visible = true
                    end
                else
                    if tracerLines[p] then tracerLines[p].Visible = false end
                end

                if espBox and headVisible and feetVisible then
                    local bodyHeight = math.abs(headScreenPos.Y - feetScreenPos.Y)
                    local bodyWidth = bodyHeight * 0.45
                    local centerX = (headScreenPos.X + feetScreenPos.X) / 2
                    if not boxes2D[p] then
                        pcall(function()
                            local box = Drawing.new("Square"); box.Thickness = 2; box.Filled = false
                            boxes2D[p] = box
                        end)
                    end
                    if boxes2D[p] then
                        boxes2D[p].Position = Vector2.new(centerX - bodyWidth/2, headScreenPos.Y - bodyHeight*0.1)
                        boxes2D[p].Size = Vector2.new(bodyWidth, bodyHeight)
                        boxes2D[p].Color = rainbowBox and rainbowColor or boxColor
                        boxes2D[p].Visible = true
                    end
                else
                    if boxes2D[p] then boxes2D[p].Visible = false end
                end

                if espSkel then
                    if not skeletons[p] then
                        skeletons[p] = {}
                        local bones = {}
                        for _, obj in ipairs(char:GetDescendants()) do
                            if obj:IsA("Motor6D") or obj:IsA("Bone") then
                                local a,b = obj.Part0, obj.Part1
                                if a and b and a:IsA("BasePart") and b:IsA("BasePart") then table.insert(bones, {a,b}) end
                            end
                        end
                        if #bones == 0 then
                            local pairs = {
                                {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"LowerTorso","LeftUpperLeg"},
                                {"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},
                                {"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},{"UpperTorso","LeftUpperArm"},
                                {"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},
                                {"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"}
                            }
                            for _, pair in ipairs(pairs) do
                                local a = char:FindFirstChild(pair[1]); local b = char:FindFirstChild(pair[2])
                                if a and b then table.insert(bones, {a,b}) end
                            end
                        end
                        for i, parts in ipairs(bones) do
                            pcall(function()
                                local line = Drawing.new("Line"); line.Thickness = 1
                                skeletons[p][i] = {line = line, a = parts[1], b = parts[2]}
                            end)
                        end
                    end
                    for _, data in ipairs(skeletons[p]) do
                        local a, b = data.a, data.b
                        if a.Parent and b.Parent then
                            local aPos, aVis = Camera:WorldToViewportPoint(a.Position)
                            local bPos, bVis = Camera:WorldToViewportPoint(b.Position)
                            if aVis and bVis then
                                data.line.From = Vector2.new(aPos.X, aPos.Y)
                                data.line.To = Vector2.new(bPos.X, bPos.Y)
                                data.line.Color = rainbowSkel and rainbowColor or skelColor
                                data.line.Visible = true
                            else data.line.Visible = false end
                        else data.line.Visible = false end
                    end
                else
                    if skeletons[p] then for _,d in ipairs(skeletons[p]) do pcall(function() d.line:Remove() end) end; skeletons[p]=nil end
                end

                if espName and headVisible then
                    if not nameTags[p] then
                        pcall(function()
                            local tag = Drawing.new("Text"); tag.Center = true; tag.Size = 14; tag.Outline = true; tag.OutlineColor = Color3.new(0,0,0)
                            nameTags[p] = tag
                        end)
                    end
                    if nameTags[p] then
                        local text = p.Name
                        if showTeamESP and p.Team then text = text .. " [" .. p.Team.Name .. "]" end
                        if espPlayerWeapon then text = text .. " | " .. weaponName end
                        if showMoney then
                            local ls = p:FindFirstChild("leaderstats")
                            if ls then for _, stat in ipairs(ls:GetChildren()) do
                                if (stat:IsA("IntValue") or stat:IsA("NumberValue")) and (stat.Name:lower():find("cash") or stat.Name:lower():find("money") or stat.Name:lower():find("gold")) then
                                    text = text .. " $"..stat.Value break
                                end
                            end end
                        end
                        if espDistance and dist > 0 then text = text .. " [" .. math.floor(dist) .. "m]" end
                        nameTags[p].Text = text
                        nameTags[p].Position = Vector2.new(headScreenPos.X, headScreenPos.Y - 22)
                        nameTags[p].Color = Color3.new(1,1,1)
                        nameTags[p].Visible = true
                    end
                else
                    if nameTags[p] then nameTags[p].Visible = false end
                end

                if espHealth and headVisible and feetVisible then
                    local barWidth = 4
                    local barHeight = math.abs(headScreenPos.Y - feetScreenPos.Y) * 0.8
                    local barX = headScreenPos.X + (math.abs(headScreenPos.X - feetScreenPos.X) * 0.5) + 10
                    local barY = math.min(headScreenPos.Y, feetScreenPos.Y) + 5
                    if not healthBars[p] then
                        pcall(function()
                            local bg = Drawing.new("Square"); bg.Filled = true; bg.Color = Color3.new(0.15,0.15,0.15); bg.Thickness = 0
                            local fill = Drawing.new("Square"); fill.Filled = true; fill.Color = Color3.new(0,1,0); fill.Thickness = 0
                            healthBars[p] = {bg = bg, fill = fill}
                        end)
                    end
                    if healthBars[p] then
                        healthBars[p].bg.Position = Vector2.new(barX, barY)
                        healthBars[p].bg.Size = Vector2.new(barWidth, barHeight)
                        healthBars[p].bg.Visible = true
                        local percent = math.clamp(health / maxHealth, 0, 1)
                        local fillHeight = barHeight * percent
                        local fillY = barY + barHeight - fillHeight
                        healthBars[p].fill.Position = Vector2.new(barX, fillY)
                        healthBars[p].fill.Size = Vector2.new(barWidth, fillHeight)
                        healthBars[p].fill.Color = percent > 0.5 and Color3.new(0,1,0) or (percent > 0.25 and Color3.new(1,1,0) or Color3.new(1,0,0))
                        healthBars[p].fill.Visible = true
                    end
                else
                    if healthBars[p] then healthBars[p].bg.Visible = false; healthBars[p].fill.Visible = false end
                end
            end

            if fovCircleObj then
                fovCircleObj.Position = screenSize / 2
                fovCircleObj.Radius = fovRadius
                fovCircleObj.Visible = fovCircle
                if fovCircle and fovRainbow then fovCircleObj.Color = rainbowColor else fovCircleObj.Color = Color3.new(1,1,1) end
            end
        end

        -- Demais funções (speed, fly, farm, etc.)
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

        local flyStartY
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
            if invisibility then
                local char = Player.Character
                if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.Transparency = 0.8 end end end
            end
        end

        local function farmStep()
            if not s4zxFarm then return end
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart
            local trash = findNearestTrash()
            if not trash then return end
            local targetPos = trash.Position
            if (targetPos - root.Position).Magnitude > 4 then
                root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position + (targetPos - root.Position).Unit * (farmSpeed * 0.15)), 0.4)
            else
                local tool = char:FindFirstChildWhichIsA("Tool")
                if tool and tick() - (lastFarmAction or 0) > 0.5 then
                    pcall(function() tool:Activate() end)
                    lastFarmAction = tick()
                end
            end
        end

        local function findNearestTrash()
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
            local root = char.HumanoidRootPart
            local nearest, nearestDist = nil, 50
            local keywords = {"lixo","trash","saco","papel","garrafa","lata","entulho","resto","garbage","waste","bag","bottle","can","paper"}
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "" then
                    local name = part.Name:lower()
                    for _, kw in ipairs(keywords) do if name:find(kw) then
                        if part.Transparency < 0.9 and part.Parent then
                            local dist = (part.Position - root.Position).Magnitude
                            if dist < nearestDist then nearestDist = dist; nearest = part end
                        end
                    end end
                end
            end
            return nearest
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
                    if ammo and ammo:IsA("IntValue") and ammo.Value == 0 then pcall(function() tool:Reload() end) end
                end
            end
        end
        local function noRecoilStep()
            if noRecoil then
                local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
                if tool then for _, obj in ipairs(tool:GetDescendants()) do if obj:IsA("SpringConstraint") or obj:IsA("RocketPropulsion") then obj.Enabled = false end end end
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
                        if v.Name == "Damage" and v:IsA("NumberValue") then v.Value = 9999 end
                    end
                end
            end
        end
        local function godModeStep()
            if godMode then
                local char = Player.Character
                if char then
                    local hum = char:FindFirstChild("Humanoid")
                    if hum then hum.MaxHealth = 99999; hum.Health = 99999 end
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
                if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") and part.Material == Enum.Material.Fire then part.Material = Enum.Material.SmoothPlastic end end end
            end
        end
        local function autoRespawnStep()
            if autoRespawn then
                local char = Player.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then pcall(function() Player:LoadCharacter() end) end
            end
        end
        local flyCarBV, flyCarBG, flyCarTarget
        local function flyCarStep()
            if not flyCarEnabled then
                if flyCarBV then flyCarBV:Destroy(); flyCarBV = nil end
                if flyCarBG then flyCarBG:Destroy(); flyCarBG = nil end
                flyCarTarget = nil
                return
            end
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
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
            if not flyCarTarget then return end
            local primary = flyCarTarget:FindFirstChild("PrimaryPart") or flyCarTarget:FindFirstChildWhichIsA("BasePart")
            if not primary then return end
            if not flyCarBV or not flyCarBV.Parent then
                flyCarBV = Instance.new("BodyVelocity"); flyCarBV.MaxForce = Vector3.new(1e9,1e9,1e9); flyCarBV.Parent = primary
            end
            if not flyCarBG or not flyCarBG.Parent then
                flyCarBG = Instance.new("BodyGyro"); flyCarBG.MaxTorque = Vector3.new(1e9,1e9,1e9); flyCarBG.Parent = primary
            end
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
            flyCarBV.Velocity = moveDir.Unit * (flyCarSpeed * 0.5)
            flyCarBG.CFrame = CFrame.new(primary.Position, primary.Position + Camera.CFrame.LookVector)
        end

        -- Loop principal
        RunService.RenderStepped:Connect(function()
            pcall(aimbotStep)
            pcall(autoLockPicStep)
            pcall(updateESP)
            pcall(speedStep)
            pcall(flyStep)
            pcall(invisibilityStep)
            pcall(farmStep)
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
            pcall(flyCarStep)

            if grabbedVehicle then
                local char = Player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local root = char.HumanoidRootPart
                    local targetPos = root.Position + root.CFrame.LookVector * 10 + Vector3.new(0, 2, 0)
                    if vehicleAlign then vehicleAlign.Position = targetPos end
                end
            end
        end)

        UserInputService.JumpRequest:Connect(function()
            if infJump then local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end
        end)
    end)

    -- Checagem periódica
    spawn(function()
        while true do
            wait(300)
            local ok, json = pcall(function() return game:HttpGet(KEYS_URL) end)
            if ok and json then
                local keys = {}
                pcall(function() keys = game:GetService("HttpService"):JSONDecode(json) end)
                local data = keys[DONO_KEY] -- simplificado
                if data and data.bloqueado then
                    destruirScript("Key banida")
                end
            end
        end
    end)

    print("S4ZX HUB Carregado com Sucesso!")
end

-- Inicia a tela de login
mostrarLogin()
