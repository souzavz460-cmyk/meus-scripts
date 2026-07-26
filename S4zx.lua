-- ============================================================
-- S4ZX HUB v2.9 - KAVO UI COMPLETA
-- ============================================================
print("[S4ZX] Iniciando script...")

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

-- ========== HUB PRINCIPAL COM KAVO UI ==========
function carregarHub()
    if not SECURITY_FLAG or SECURITY_FLAG ~= "S4zx_INTEGRO_2026" then
        destruirScript("Script adulterado")
        return
    end

    -- Serviços
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local VoiceChatService = game:GetService("VoiceChatService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()
    local CoreGui = game:GetService("CoreGui")

    -- Remove instâncias anteriores
    if CoreGui:FindFirstChild("S4zxModUI") then CoreGui.S4zxModUI:Destroy() end

    -- ============================================================
    -- VARIÁVEIS DE ESTADO
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

        -- Internos
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
    -- INTERFACE KAVO UI (mesma estrutura fornecida)
    -- ============================================================
    local THEME = {
        Background = Color3.fromRGB(16, 13, 22),
        Panel = Color3.fromRGB(24, 19, 33),
        Panel2 = Color3.fromRGB(31, 24, 43),
        Accent = Color3.fromRGB(145, 70, 255),
        AccentDark = Color3.fromRGB(92, 38, 168),
        Text = Color3.fromRGB(245, 242, 255),
        Muted = Color3.fromRGB(170, 160, 190),
        Stroke = Color3.fromRGB(62, 49, 82),
        Success = Color3.fromRGB(80, 220, 130),
        Danger = Color3.fromRGB(235, 80, 105),
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "S4zxModUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    local function corner(parent, radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 6)
        c.Parent = parent
        return c
    end

    local function stroke(parent, color, thickness, transparency)
        local s = Instance.new("UIStroke")
        s.Color = color or THEME.Stroke
        s.Thickness = thickness or 1
        s.Transparency = transparency or 0
        s.Parent = parent
        return s
    end

    local function padding(parent, l, r, t, b)
        local p = Instance.new("UIPadding")
        p.PaddingLeft = UDim.new(0, l or 0)
        p.PaddingRight = UDim.new(0, r or 0)
        p.PaddingTop = UDim.new(0, t or 0)
        p.PaddingBottom = UDim.new(0, b or 0)
        p.Parent = parent
        return p
    end

    local function text(parent, value, size, color, bold)
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Text = value
        label.TextSize = size or 14
        label.TextColor3 = color or THEME.Text
        label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
        return label
    end

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.fromOffset(720, 455)
    main.Position = UDim2.new(0.5, -360, 0.5, -227)
    main.BackgroundColor3 = THEME.Background
    main.ClipsDescendants = true
    main.Parent = gui
    corner(main, 8)
    stroke(main, THEME.Stroke, 1)

    local topbar = Instance.new("Frame")
    topbar.Size = UDim2.new(1, 0, 0, 42)
    topbar.BackgroundColor3 = THEME.Panel
    topbar.BorderSizePixel = 0
    topbar.Parent = main

    local title = text(topbar, "S4zx Mod", 15, THEME.Text, true)
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.fromOffset(14, 0)

    local subtitle = text(topbar, "UI", 11, THEME.Muted, false)
    subtitle.Size = UDim2.fromOffset(30, 42)
    subtitle.Position = UDim2.new(1, -80, 0, 0)
    subtitle.TextXAlignment = Enum.TextXAlignment.Center

    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(42, 42)
    close.Position = UDim2.new(1, -42, 0, 0)
    close.BackgroundTransparency = 1
    close.Text = "×"
    close.TextSize = 22
    close.TextColor3 = THEME.Muted
    close.Font = Enum.Font.GothamBold
    close.Parent = topbar
    close.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 185, 1, -42)
    sidebar.Position = UDim2.fromOffset(0, 42)
    sidebar.BackgroundColor3 = THEME.Panel
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    local sideScroll = Instance.new("ScrollingFrame")
    sideScroll.Size = UDim2.new(1, 0, 1, 0)
    sideScroll.BackgroundTransparency = 1
    sideScroll.BorderSizePixel = 0
    sideScroll.ScrollBarThickness = 3
    sideScroll.ScrollBarImageColor3 = THEME.Accent
    sideScroll.CanvasSize = UDim2.fromOffset(0, 0)
    sideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sideScroll.Parent = sidebar
    padding(sideScroll, 8, 8, 8, 8)

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 5)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sideScroll

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -185, 1, -42)
    content.Position = UDim2.fromOffset(185, 42)
    content.BackgroundColor3 = THEME.Background
    content.BorderSizePixel = 0
    content.Parent = main

    local pages = {}
    local activeTabButton = nil

    local function makePage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = THEME.Accent
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.CanvasSize = UDim2.fromOffset(0, 0)
        page.Visible = false
        page.Parent = content
        padding(page, 12, 12, 12, 12)

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        pages[name] = page
        return page
    end

    local function selectTab(name, button)
        for _, page in pairs(pages) do
            page.Visible = false
        end
        pages[name].Visible = true

        if activeTabButton then
            activeTabButton.BackgroundColor3 = THEME.Panel
            activeTabButton.TextColor3 = THEME.Muted
        end

        activeTabButton = button
        button.BackgroundColor3 = THEME.Accent
        button.TextColor3 = THEME.Text
    end

    local function makeTab(name)
        local page = makePage(name)

        local button = Instance.new("TextButton")
        button.Name = name .. "Tab"
        button.Size = UDim2.new(1, 0, 0, 34)
        button.BackgroundColor3 = THEME.Panel
        button.AutoButtonColor = false
        button.Text = name
        button.TextSize = 13
        button.TextColor3 = THEME.Muted
        button.Font = Enum.Font.GothamMedium
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.Parent = sideScroll
        padding(button, 10, 8, 0, 0)
        corner(button, 5)

        button.MouseButton1Click:Connect(function()
            selectTab(name, button)
        end)

        return page, button
    end

    local function section(page, name)
        local box = Instance.new("Frame")
        box.Name = name
        box.Size = UDim2.new(1, 0, 0, 40)
        box.AutomaticSize = Enum.AutomaticSize.Y
        box.BackgroundColor3 = THEME.Panel
        box.BorderSizePixel = 0
        box.Parent = page
        corner(box, 7)
        stroke(box, THEME.Stroke, 1)
        padding(box, 10, 10, 10, 10)

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 7)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = box

        local heading = text(box, name, 13, THEME.Text, true)
        heading.Size = UDim2.new(1, 0, 0, 22)

        return box
    end

    local function row(parent, height)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, height or 34)
        f.BackgroundColor3 = THEME.Panel2
        f.BorderSizePixel = 0
        f.Parent = parent
        corner(f, 5)
        return f
    end

    local function addLabel(parent, name, color)
        local f = row(parent, 32)
        local l = text(f, name, 13, color or THEME.Muted, false)
        l.Size = UDim2.new(1, -18, 1, 0)
        l.Position = UDim2.fromOffset(9, 0)
        return l
    end

    local function addButton(parent, name, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 34)
        b.BackgroundColor3 = THEME.Panel2
        b.AutoButtonColor = false
        b.Text = name
        b.TextSize = 13
        b.TextColor3 = THEME.Text
        b.Font = Enum.Font.GothamMedium
        b.Parent = parent
        corner(b, 5)
        stroke(b, THEME.Stroke, 1)

        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = THEME.AccentDark}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = THEME.Panel2}):Play()
        end)
        b.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        return b
    end

    local function addToggle(parent, name, default, callback)
        local enabled = default == true
        local f = row(parent, 36)

        local l = text(f, name, 13, THEME.Text, false)
        l.Size = UDim2.new(1, -65, 1, 0)
        l.Position = UDim2.fromOffset(9, 0)

        local track = Instance.new("TextButton")
        track.Size = UDim2.fromOffset(42, 22)
        track.Position = UDim2.new(1, -51, 0.5, -11)
        track.BackgroundColor3 = enabled and THEME.Accent or Color3.fromRGB(62, 56, 72)
        track.Text = ""
        track.AutoButtonColor = false
        track.Parent = f
        corner(track, 11)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3)
        knob.BackgroundColor3 = THEME.Text
        knob.Parent = track
        corner(knob, 8)

        local function render()
            TweenService:Create(track, TweenInfo.new(0.14), {
                BackgroundColor3 = enabled and THEME.Accent or Color3.fromRGB(62, 56, 72)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.14), {
                Position = enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.fromOffset(3, 3)
            }):Play()
        end

        track.MouseButton1Click:Connect(function()
            enabled = not enabled
            render()
            if callback then callback(enabled) end
        end)

        return {
            Get = function() return enabled end,
            Set = function(v)
                enabled = v == true
                render()
            end
        }
    end

    local function addSlider(parent, name, minValue, maxValue, defaultValue, callback, decimals)
        local value = math.clamp(defaultValue or minValue, minValue, maxValue)
        decimals = decimals or 0

        local f = row(parent, 54)
        local l = text(f, name, 13, THEME.Text, false)
        l.Size = UDim2.new(1, -85, 0, 28)
        l.Position = UDim2.fromOffset(9, 0)

        local valueLabel = text(f, tostring(value), 12, THEME.Accent, true)
        valueLabel.Size = UDim2.fromOffset(70, 28)
        valueLabel.Position = UDim2.new(1, -78, 0, 0)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local bar = Instance.new("TextButton")
        bar.Size = UDim2.new(1, -18, 0, 7)
        bar.Position = UDim2.fromOffset(9, 37)
        bar.BackgroundColor3 = Color3.fromRGB(58, 50, 69)
        bar.Text = ""
        bar.AutoButtonColor = false
        bar.Parent = f
        corner(bar, 4)

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((value - minValue) / (maxValue - minValue), 0, 1, 0)
        fill.BackgroundColor3 = THEME.Accent
        fill.Parent = bar
        corner(fill, 4)

        local dragging = false

        local function update(inputX)
            local alpha = math.clamp((inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local raw = minValue + (maxValue - minValue) * alpha
            local multiplier = 10 ^ decimals
            value = math.floor(raw * multiplier + 0.5) / multiplier
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            valueLabel.Text = tostring(value)
            if callback then callback(value) end
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input.Position.X)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        return {
            Get = function() return value end,
            Set = function(v)
                value = math.clamp(v, minValue, maxValue)
                local alpha = (value - minValue) / (maxValue - minValue)
                fill.Size = UDim2.new(alpha, 0, 1, 0)
                valueLabel.Text = tostring(value)
            end
        }
    end

    local function addInput(parent, name, placeholder, callback)
        local f = row(parent, 42)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -18, 0, 28)
        box.Position = UDim2.fromOffset(9, 7)
        box.BackgroundColor3 = Color3.fromRGB(18, 15, 24)
        box.PlaceholderText = placeholder or name
        box.Text = ""
        box.ClearTextOnFocus = false
        box.TextSize = 13
        box.TextColor3 = THEME.Text
        box.PlaceholderColor3 = THEME.Muted
        box.Font = Enum.Font.Gotham
        box.Parent = f
        padding(box, 8, 8, 0, 0)
        corner(box, 4)
        stroke(box, THEME.Stroke, 1)

        box.FocusLost:Connect(function(enterPressed)
            if callback then callback(box.Text, enterPressed) end
        end)

        return box
    end

    local function addDropdown(parent, name, options, default, callback)
        local selected = default or options[1]
        local expanded = false

        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 36)
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.BackgroundTransparency = 1
        container.Parent = parent

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 4)
        layout.Parent = container

        local button = addButton(container, name .. ": " .. tostring(selected), nil)
        button.Size = UDim2.new(1, 0, 0, 34)

        local list = Instance.new("Frame")
        list.Size = UDim2.new(1, 0, 0, 0)
        list.AutomaticSize = Enum.AutomaticSize.Y
        list.BackgroundTransparency = 1
        list.Visible = false
        list.Parent = container

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 3)
        listLayout.Parent = list

        button.MouseButton1Click:Connect(function()
            expanded = not expanded
            list.Visible = expanded
        end)

        for _, option in ipairs(options) do
            local optionButton = addButton(list, "  " .. tostring(option), function()
                selected = option
                button.Text = name .. ": " .. tostring(selected)
                expanded = false
                list.Visible = false
                if callback then callback(selected) end
            end)
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.BackgroundColor3 = Color3.fromRGB(22, 18, 30)
        end

        return {
            Get = function() return selected end,
            Set = function(v)
                selected = v
                button.Text = name .. ": " .. tostring(selected)
            end
        }
    end

    local function addKeybind(parent, name, defaultKey, callback)
        local selectedKey = defaultKey or Enum.KeyCode.RightShift
        local waiting = false

        local button = addButton(parent, name .. ": " .. selectedKey.Name, nil)
        button.MouseButton1Click:Connect(function()
            waiting = true
            button.Text = name .. ": pressione uma tecla..."
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if waiting and input.UserInputType == Enum.UserInputType.Keyboard then
                selectedKey = input.KeyCode
                waiting = false
                button.Text = name .. ": " .. selectedKey.Name
                if callback then callback(selectedKey) end
            elseif not processed and input.KeyCode == state.menuKey then
                gui.Enabled = not gui.Enabled
            end
        end)

        return button
    end

    -- Arrastar janela
    do
        local dragging = false
        local dragStart
        local startPosition

        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPosition = main.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    -- ============================================================
    -- PREENCHIMENTO DAS ABAS COM CALLBACKS REAIS
    -- ============================================================
    local firstButton

    -- ==================== ABA AIMBOT ====================
    do
        local page, tab = makeTab("🎯 Aimbot")
        firstButton = tab

        local s1 = section(page, "Aimbot")
        addToggle(s1, "AIMBOT", false, function(v) state.aimbot = v end)
        addSlider(s1, "Força da Mira", 1, 5, 3, function(v) state.aimForce = v end)
        addSlider(s1, "Bypass", 1, 10, 5, function(v) state.bypass = v end)
        addSlider(s1, "FOV Raio", 50, 500, 150, function(v) state.fovRadius = v end)
        addToggle(s1, "WALLCK", false, function(v) state.wallCheck = v end)
        addToggle(s1, "Aimbot com Lead", false, function(v) state.aimbotLead = v end)
        addSlider(s1, "Multiplicador de Lead", 1, 5, 1, function(v) state.leadMultiplier = v end)
        addDropdown(s1, "Parte do Corpo", {"Cabeça", "Peito", "Perna", "Braço"}, "Cabeça", function(v) state.aimPart = v end)
        addDropdown(s1, "Prioridade", {"Distância", "Saúde", "Visibilidade", "Nome Específico"}, "Distância", function(v) state.aimPriority = v end)
        addInput(s1, "Nome Alvo Prioritário", "Digite um nome...", function(textValue) state.priorityName = textValue end)

        local s2 = section(page, "Silent Aim Universal")
        addToggle(s2, "SILENT AIM", false, function(v) state.silentAim = v end)
        addToggle(s2, "Magic Bullet", false, function(v) state.magicBullet = v end)
        addToggle(s2, "Team Check (Silent)", false, function(v) state.saTeamCheck = v end)
        addToggle(s2, "Visible Check (Silent)", false, function(v) state.saVisibleCheck = v end)
        addSlider(s2, "Hit Chance (%)", 0, 100, 100, function(v) state.saHitChance = v end)
        addToggle(s2, "Predição (Silent)", false, function(v) state.saMousePrediction = v end)
        addSlider(s2, "Predição Amount", 0.165, 1, 0.165, function(v) state.saPredictionAmount = v end, 3)
        addDropdown(s2, "Método Silent", {
            "Raycast", "FindPartOnRay", "FindPartOnRayWithWhitelist",
            "FindPartOnRayWithIgnoreList", "Mouse.Hit/Target"
        }, "Raycast", function(v) state.saMethod = v end)
        addDropdown(s2, "Parte Alvo (Silent)", {"Head", "HumanoidRootPart", "Random"}, "HumanoidRootPart", function(v) state.saTargetPart = v end)
        addToggle(s2, "Mostrar FOV Circle (Silent)", false, function(v) state.saFovVisible = v end)
        addSlider(s2, "FOV Radius (Silent)", 50, 360, 130, function(v) state.saFovRadius = v end)
        addToggle(s2, "Mostrar Alvo (Silent)", false, function(v) state.saShowTarget = v end)
    end

    -- ==================== ABA ESP ====================
    do
        local page = makeTab("👁️ ESP")
        local s = section(page, "ESP")
        addToggle(s, "Ativar ESP (Geral)", false, function(v) state.espEnabled = v end)
        addToggle(s, "Box", false, function(v) state.espBox = v end)
        addToggle(s, "Names", false, function(v) state.espNames = v end)
        addToggle(s, "Weapons", false, function(v) state.espWeapons = v end)
        addToggle(s, "Talking Icon", false, function(v) state.espTalking = v end)
        addToggle(s, "Skeleton", false, function(v) state.espSkeleton = v end)
        addToggle(s, "Admin ESP", false, function(v) state.espAdmin = v end)
        addToggle(s, "Admin List", false, function(v) state.espAdminList = v end)
        addToggle(s, "Lines", false, function(v) state.espLines = v end)
        addToggle(s, "Distance", false, function(v) state.espDistance = v end)
        addToggle(s, "Infinite Distance", false, function(v) state.espInfiniteDist = v end)
        addToggle(s, "Target NPCs", false, function(v) state.espNPCs = v end)
        addToggle(s, "Visible Check", false, function(v) state.espVisible = v end)
        addToggle(s, "ESP de Mira do Inimigo", false, function(v) state.espEnemyAim = v end)
        addSlider(s, "Tamanho do Texto", 12, 20, 14, function(v) state.textSize = v end)
        addButton(s, "Cor Esqueleto (Aleatória)", function() state.skeletonColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
        addButton(s, "Cor Box (Aleatória)", function() state.boxColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)
        addButton(s, "Cor Ícone de Fala (Aleatória)", function() state.talkColor = Color3.fromRGB(math.random(255), math.random(255), math.random(255)) end)

        -- Lista de jogadores dinâmica
        local list = section(page, "Jogadores no Servidor")
        local playersContainer = Instance.new("Frame")
        playersContainer.Size = UDim2.new(1, 0, 0, 0)
        playersContainer.BackgroundTransparency = 1
        playersContainer.AutomaticSize = Enum.AutomaticSize.Y
        playersContainer.Parent = list
        local playersLayout = Instance.new("UIListLayout", playersContainer)
        playersLayout.Padding = UDim.new(0, 3)

        local function rebuildPlayerList()
            for _, child in ipairs(playersContainer:GetChildren()) do
                if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    local btnPuxar = addButton(playersContainer, "🔄 Puxar " .. plr.Name, function()
                        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local myChar = LocalPlayer.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                local targetRoot = plr.Character.HumanoidRootPart
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
                    local btnTP = addButton(playersContainer, "🚀 TP " .. plr.Name, function()
                        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local myChar = LocalPlayer.Character
                            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                myChar.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                            end
                        end
                    end)
                    local btnSpectate = addButton(playersContainer, "👁️ Spectate " .. plr.Name, function()
                        state.spectateTarget = plr
                        if plr.Character then Camera.CameraSubject = plr.Character end
                    end)
                end
            end
        end

        rebuildPlayerList()
        Players.PlayerAdded:Connect(rebuildPlayerList)
        Players.PlayerRemoving:Connect(rebuildPlayerList)
    end

    -- ==================== ABA VEÍCULOS ====================
    do
        local page = makeTab("🚗 Veículos")
        local s = section(page, "Veículos")
        addButton(s, "Teleportar no Veículo Próximo", function()
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
            if nearest then root.CFrame = root.CFrame:Lerp(CFrame.new(nearest.Position + Vector3.new(0, 3, 0)), 0.5) end
        end)
        addButton(s, "Destrancar Veículo", function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") then v:SetAttribute("Locked", false); v.Locked = false end
            end
        end)
        addButton(s, "Trancar Veículo", function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("VehicleSeat") then v:SetAttribute("Locked", true); v.Locked = true end
            end
        end)
        addButton(s, "Marcar Waypoint", function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then state.waypoint = char.HumanoidRootPart.Position end
        end)
        addButton(s, "Teleportar Waypoint", function()
            if state.waypoint then
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(state.waypoint + Vector3.new(0, 2, 0))
                end
            end
        end)
        addToggle(s, "Super Velocidade no Carro", false, function(v) state.superCarSpeed = v end)
        addSlider(s, "Velocidade Super Carro", 50, 500, 100, function(v) state.superCarSpeedValue = v end)
        addToggle(s, "Clonar Carro", false, function(v)
            state.cloneCar = v
            if v then
                local char = LocalPlayer.Character
                if not char then return end
                local seat = nil
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("VehicleSeat") and obj.Occupant == char.Humanoid then seat = obj; break end
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

    -- ==================== ABA VISUAL ====================
    do
        local page = makeTab("🎨 Visual")
        local s = section(page, "Visual")
        addButton(s, "Cor Box (Verde)", function() state.boxColor = Color3.fromRGB(0,255,0) end)
        addButton(s, "Cor Esqueleto (Rosa)", function() state.skeletonColor = Color3.fromRGB(255,105,180) end)
        addToggle(s, "FOV Círculo", false, function(v) state.fovCircle = v end)
        addToggle(s, "FOV Arco-Íris", false, function(v) state.fovRainbow = v end)
        addToggle(s, "🔦 Laser (Linha de Tiro)", false, function(v) state.linhaDeMira = v end)
    end

    -- ==================== ABA MOVIMENTO ====================
    do
        local page = makeTab("🏃 Movimento")
        local s = section(page, "Movimento")
        addToggle(s, "Pulo Infinito", false, function(v) state.infJump = v end)
        addToggle(s, "Fly Avançado (WASD/E/Q)", false, function(v)
            state.fly = v
            if not v then state.flyStartY = nil end
        end)
        addSlider(s, "Velocidade Fly", 20, 200, 50, function(v) state.flySpeed = v end)
        addToggle(s, "Speed Hack", false, function(v) state.speedHack = v end)
        addSlider(s, "Velocidade Speed", 16, 200, 60, function(v) state.speedValue = v end)
        addToggle(s, "Ghost Mode", false, function(v) state.ghostMode = v end)
        addToggle(s, "Derrubar Player", false, function(v) state.derrubarPlayer = v end)
    end

    -- ==================== ABA FARM ====================
    do
        local page = makeTab("🌾 Farm")
        local s = section(page, "Farm")
        addToggle(s, "Auto Farm Lixo", false, function(v) state.autoFarm = v end)
        addSlider(s, "Velocidade Farm", 30, 100, 50, function(v) state.farmSpeed = v end)
        addToggle(s, "Auto Essência", false, function(v) state.autoEssencia = v end)
        addToggle(s, "Auto Micha", false, function(v) state.autoMicha = v end)
    end

    -- ==================== ABA ARMAS ====================
    do
        local page = makeTab("🔪 Armas")
        local s = section(page, "Armas")
        addToggle(s, "Reach", false, function(v) state.reach = v end)
        addSlider(s, "Distância Reach", 10, 50, 25, function(v) state.reachDist = v end)
        addToggle(s, "Infinite Ammo", false, function(v) state.infiniteAmmo = v end)
        addToggle(s, "Auto Reload", false, function(v) state.autoReload = v end)
        addToggle(s, "No Recoil", false, function(v) state.noRecoil = v end)
        addToggle(s, "Rapid Fire", false, function(v) state.rapidFire = v end)
        addSlider(s, "Rapid Fire Delay", 0.05, 0.5, 0.1, function(v) state.rapidFireDelay = v end, 2)
        addToggle(s, "Matar com 1 Tiro", false, function(v) state.oneShot = v end)
        addToggle(s, "Arma Colorida (RGB)", false, function(v) state.armaColorida = v end)
        addSlider(s, "Velocidade RGB", 0.5, 5, 2, function(v) state.rgbSpeed = v end, 1)
        addSlider(s, "Tamanho da Arma", 0.5, 5, 1, function(v) state.armaSize = v end, 1)
        addToggle(s, "Roubar P1", false, function(v) state.roubarP1 = v end)
        addToggle(s, "Roubar P2", false, function(v) state.roubarP2 = v end)

        -- Detecção dinâmica de armas
        local fakeSection = section(page, "Armas Falsas")
        local fakeContainer = Instance.new("Frame")
        fakeContainer.Size = UDim2.new(1, 0, 0, 0)
        fakeContainer.BackgroundTransparency = 1
        fakeContainer.AutomaticSize = Enum.AutomaticSize.Y
        fakeContainer.Parent = fakeSection
        local fakeLayout = Instance.new("UIListLayout", fakeContainer)
        fakeLayout.Padding = UDim.new(0, 3)

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
            local unique = {}
            local result = {}
            for _, name in ipairs(weapons) do
                if not unique[name] then unique[name] = true; table.insert(result, name) end
            end
            return result
        end

        local function rebuildDynamicWeapons()
            for _, child in ipairs(fakeContainer:GetChildren()) do
                if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
            end
            local weapons = detectWeapons()
            if #weapons == 0 then
                addLabel(fakeContainer, "Nenhuma arma encontrada.", THEME.Muted)
            else
                for _, name in ipairs(weapons) do
                    addButton(fakeContainer, "🔫 " .. name .. " (Fake)", function()
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

        addButton(s, "🔄 Atualizar Armas Detectadas", rebuildDynamicWeapons)
        task.wait(0.5)
        rebuildDynamicWeapons()
    end

    -- ==================== ABA CARRO ====================
    do
        local page = makeTab("🏎️ Carro")
        local s = section(page, "Carro")
        addToggle(s, "Fly Car", false, function(v) state.flyCar = v end)
        addSlider(s, "Velocidade Fly Car", 20, 200, 70, function(v) state.flyCarSpeed = v end)
    end

    -- ==================== ABA EXTRAS ====================
    do
        local page = makeTab("🛠️ Extras")
        local s = section(page, "Extras")
        addToggle(s, "Anti AFK", false, function(v) state.antiAfk = v end)
        addToggle(s, "Anti Stun", false, function(v) state.antiStun = v end)
        addToggle(s, "Anti Fire", false, function(v) state.antiFire = v end)
        addToggle(s, "Auto Respawn", false, function(v) state.autoRespawn = v end)
        addToggle(s, "God Mode", false, function(v) state.godMode = v end)
        addToggle(s, "🎙️ Microfone Global", false, function(v)
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
        addToggle(s, "Money Hack (Auto)", false, function(v)
            state.moneyHack = v
            if v then
                state.moneyLoop = task.spawn(function()
                    while state.moneyHack do
                        task.wait(0.5)
                        local args = {[1] = "GiveCash", [2] = state.moneyValue}
                        pcall(function() game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FireServer(unpack(args)) end)
                    end
                end)
            else
                if state.moneyLoop then task.cancel(state.moneyLoop) end
            end
        end)
        addSlider(s, "Valor do Dinheiro", 1000, 9999999, 100000, function(v) state.moneyValue = v end)

        -- Empregos
        local jobs = section(page, "💼 Empregos Detectados")
        local jobsContainer = Instance.new("Frame")
        jobsContainer.Size = UDim2.new(1, 0, 0, 0)
        jobsContainer.BackgroundTransparency = 1
        jobsContainer.AutomaticSize = Enum.AutomaticSize.Y
        jobsContainer.Parent = jobs
        local jobsLayout = Instance.new("UIListLayout", jobsContainer)
        jobsLayout.Padding = UDim.new(0, 3)

        local function detectJobs()
            local jList = {}
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.Enabled then
                    local name = obj.Parent and obj.Parent.Name
                    if name and name ~= "" then table.insert(jList, name) end
                end
            end
            local unique = {}
            local result = {}
            for _, n in ipairs(jList) do
                if not unique[n] then unique[n] = true; table.insert(result, n) end
            end
            return result
        end

        local function rebuildJobsUI()
            for _, child in ipairs(jobsContainer:GetChildren()) do
                if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
            end
            local jList = detectJobs()
            if #jList == 0 then
                addLabel(jobsContainer, "Nenhum emprego encontrado.", THEME.Muted)
            else
                for _, name in ipairs(jList) do
                    addButton(jobsContainer, "💼 " .. name, function()
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

        addButton(jobs, "🔄 Atualizar Empregos", rebuildJobsUI)
        task.wait(1)
        rebuildJobsUI()

        -- Pegar/Tacar veículo
        local veh = section(page, "Veículo")
        addButton(veh, "🖐️ PEGAR Veículo (Raycast)", function()
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
        addButton(veh, "💥 TACAR Veículo Segurado", function()
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

    -- ==================== ABA CONFIG ====================
    do
        local page = makeTab("⚙️ Config")
        local s = section(page, "Configurações")
        addToggle(s, "Modo Streamer", false, function(v)
            state.streamerMode = v
            gui.Enabled = not v
        end)
        addToggle(s, "Anti Live", false, function(v) state.antiLive = v end)
        addToggle(s, "Atalhos Rápidos (CTRL+1 a 0)", true, function(v) state.shortcutsEnabled = v end)
        addKeybind(s, "Atalho de Ocultar Menu (PC)", Enum.KeyCode.RightShift, function(key) state.menuKey = key end)
    end

    -- ==================== ABA SEGURANÇA ====================
    do
        local page = makeTab("🔒 Segurança")
        local s = section(page, "Status")
        addLabel(s, "🔑 Status Key: AUTENTICADO", THEME.Success)
        addLabel(s, "🚫 Blacklist: LIMPO", THEME.Success)
        addLabel(s, "💻 HWID Verificado: OK", THEME.Success)
        addLabel(s, "🛡️ Anti-Adulteração: ATIVO", THEME.Success)
        addLabel(s, "🔄 Checagem Remota: ONLINE (5m)", THEME.Success)
    end

    selectTab("🎯 Aimbot", firstButton)

    -- ============================================================
    -- CONTADOR DE STAFF
    -- ============================================================
    task.delay(1, function()
        local staffGui = Instance.new("ScreenGui", CoreGui)
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

        task.spawn(function()
            while true do
                task.wait(1)
                local count = 0
                for _, p in ipairs(Players:GetPlayers()) do
                    if isAdmin(p) then count = count + 1 end
                end
                staffFrame.Text = "👑 Staff: " .. count
            end
        end)
    end)

    -- ============================================================
    -- ATALHOS CTRL+1..0
    -- ============================================================
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == state.menuKey then
                gui.Enabled = not gui.Enabled
            end
            if state.shortcutsEnabled and input.KeyCode >= Enum.KeyCode.One and input.KeyCode <= Enum.KeyCode.Zero then
                local ctrl = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
                if ctrl then
                    local mapping = {
                        [Enum.KeyCode.One] = function() state.aimbot = not state.aimbot end,
                        [Enum.KeyCode.Two] = function() state.silentAim = not state.silentAim end,
                        [Enum.KeyCode.Three] = function() state.espEnabled = not state.espEnabled end,
                        [Enum.KeyCode.Four] = function() state.fly = not state.fly end,
                        [Enum.KeyCode.Five] = function() state.speedHack = not state.speedHack end,
                        [Enum.KeyCode.Six] = function() state.godMode = not state.godMode end,
                        [Enum.KeyCode.Seven] = function() state.reach = not state.reach end,
                        [Enum.KeyCode.Eight] = function() state.rapidFire = not state.rapidFire end,
                        [Enum.KeyCode.Nine] = function() state.autoFarm = not state.autoFarm end,
                        [Enum.KeyCode.Zero] = function() state.antiAfk = not state.antiAfk end,
                    }
                    if mapping[input.KeyCode] then mapping[input.KeyCode]() end
                end
            end
        end
    end)

    -- ============================================================
    -- ESP
    -- ============================================================
    local useDrawing = pcall(function() return Drawing.new end) and Drawing ~= nil
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
                obj.BackgroundTransparency = 0.5; obj.BorderSizePixel = 1
                obj.BorderColor3 = props.Color or Color3.new(1,1,1)
                obj.BackgroundColor3 = Color3.new(0,0,0); obj.BackgroundTransparency = 0.7
                obj.Size = UDim2.new(0, props.Size.X, 0, props.Size.Y)
                obj.Position = UDim2.new(0, props.Position.X, 0, props.Position.Y)
            elseif kind == "Line" then
                obj = Instance.new("Frame")
                obj.BackgroundColor3 = props.Color or Color3.new(1,1,1); obj.BackgroundTransparency = 0.5
                local from, to = props.From, props.To
                local dx, dy = to.X - from.X, to.Y - from.Y
                obj.Size = UDim2.new(0, math.sqrt(dx*dx+dy*dy), 0, 2)
                obj.Position = UDim2.new(0, from.X, 0, from.Y)
                obj.Rotation = math.deg(math.atan2(dy, dx))
            elseif kind == "Text" then
                obj = Instance.new("TextLabel")
                obj.BackgroundTransparency = 1; obj.Text = props.Text or ""
                obj.TextColor3 = props.Color or Color3.new(1,1,1)
                obj.TextSize = props.Size or 14; obj.Font = Enum.Font.Gotham
                obj.Position = UDim2.new(0, props.Position.X, 0, props.Position.Y)
                obj.Size = UDim2.new(0, 200, 0, 20)
            end
            if obj then
                obj.Parent = gui; obj.ZIndex = 999
                table.insert(espObjects, obj)
            end
            return obj
        end
    end

    task.spawn(function()
        while true do
            task.wait(0.05)
            if not state.espEnabled then clearESPObjects(); if fovCircleObj then fovCircleObj.Visible = false end; continue end

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
                    if not t.isNPC and isAdmin(t.player) then table.insert(adminNames, t.player.Name) end
                end
                if #adminNames > 0 then
                    createESPObject("Text", { Position = Vector2.new(10, 10), Text = "Admins: " .. table.concat(adminNames, ", "), Color = Color3.new(1,0,0), Size = 16 })
                end
            end

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
                    createESPObject("Square", { Position = Vector2.new(centerX - bodyWidth/2, headPos2D.Y - bodyHeight*0.1), Size = Vector2.new(bodyWidth, bodyHeight), Color = color, Thickness = 2, Filled = false })
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
                        local a = char:FindFirstChild(pair[1]); local b = char:FindFirstChild(pair[2])
                        if a and b then
                            local aPos, aOn = worldToScreen(a.Position); local bPos, bOn = worldToScreen(b.Position)
                            if aOn and bOn then createESPObject("Line", { From = aPos, To = bPos, Color = state.skeletonColor, Thickness = 2 }) end
                        end
                    end
                end

                if state.espNames and headOn then
                    createESPObject("Text", { Position = Vector2.new(headPos2D.X - 50, headPos2D.Y - 22), Text = target.player.Name or "NPC", Color = color, Size = state.textSize, Center = true })
                end

                if state.espWeapons and weaponName ~= "" and headOn then
                    createESPObject("Text", { Position = Vector2.new(headPos2D.X - 50, headPos2D.Y + 30), Text = weaponName, Color = Color3.new(1,1,0), Size = 12, Center = true })
                end

                if state.espDistance and myRoot and headOn then
                    createESPObject("Text", { Position = Vector2.new(headPos2D.X - 50, headPos2D.Y + 15), Text = math.floor(dist) .. "m", Color = Color3.new(1,1,1), Size = 12, Center = true })
                end

                if state.espLines and rootOn then
                    createESPObject("Line", { From = Vector2.new(screenSize.X / 2, screenSize.Y), To = rootPos2D, Color = color, Thickness = 1 })
                end

                if state.espTalking and headOn then
                    createESPObject("Text", { Position = Vector2.new(headPos2D.X + 15, headPos2D.Y - 10), Text = "🗣️", Color = state.talkColor, Size = 12, Center = true })
                end

                if state.espEnemyAim and not target.isNPC then
                    local playerHead = char:FindFirstChild("Head")
                    if playerHead then
                        local aimEnd = playerHead.Position + playerHead.CFrame.LookVector * 50
                        local aimEnd2D, onScreen = worldToScreen(aimEnd)
                        if onScreen then
                            local head2D, _ = worldToScreen(playerHead.Position)
                            createESPObject("Line", { From = head2D, To = aimEnd2D, Color = Color3.fromRGB(255, 100, 100), Thickness = 1 })
                        end
                    end
                end
            end

            if state.fovCircle then
                if not fovCircleObj then
                    fovCircleObj = Drawing.new("Circle"); fovCircleObj.Visible = true; fovCircleObj.Thickness = 2; fovCircleObj.Filled = false
                end
                fovCircleObj.Position = screenSize / 2; fovCircleObj.Radius = state.fovRadius; fovCircleObj.Visible = true
                fovCircleObj.Color = state.fovRainbow and Color3.fromHSV(tick() % 1, 1, 1) or Color3.new(1,1,1)
            elseif fovCircleObj then
                fovCircleObj.Visible = false
            end
        end
    end)

    -- ============================================================
    -- LASER
    -- ============================================================
    local laserLine = nil
    task.spawn(function()
        while true do
            task.wait(0.03)
            if not state.linhaDeMira then
                if laserLine then if useDrawing then laserLine:Remove() else laserLine:Destroy() end; laserLine = nil end
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
            params.FilterDescendantsInstances = {char}; params.FilterType = Enum.RaycastFilterType.Blacklist
            local result = Workspace:Raycast(origin, direction, params)
            local targetPos = result and result.Position or (origin + direction)

            if useDrawing then
                if not laserLine then laserLine = Drawing.new("Line"); laserLine.Thickness = 2; laserLine.Color = Color3.fromRGB(255,255,255); laserLine.Transparency = 0.8; laserLine.Visible = true end
                local oS, oO = worldToScreen(origin); local tS, tO = worldToScreen(targetPos)
                if oO and tO then laserLine.From = oS; laserLine.To = tS; laserLine.Visible = true else laserLine.Visible = false end
            end
        end
    end)

    -- ============================================================
    -- AIMBOT + LEAD
    -- ============================================================
    local function getAimPart(char, partName)
        local mapping = { Head = "Head", ["Cabeça"] = "Head", ["Peito"] = "UpperTorso", ["Perna"] = "LeftLowerLeg", ["Braço"] = "RightLowerArm" }
        return char:FindFirstChild(mapping[partName] or partName or "Head")
    end

    task.spawn(function()
        while true do
            task.wait()
            if state.aimbot then
                local best, bestScore = nil, math.huge
                local center = Camera.ViewportSize / 2
                for _, p in ipairs(Players:GetPlayers()) do
                    if p == LocalPlayer then continue end
                    local chr = p.Character; if not chr then continue end
                    local hum = chr:FindFirstChild("Humanoid"); if not hum or hum.Health <= 0 then continue end
                    if state.wallCheck then
                        local head = chr:FindFirstChild("Head")
                        if head then
                            local params = RaycastParams.new(); params.FilterDescendantsInstances = {LocalPlayer.Character}; params.FilterType = Enum.RaycastFilterType.Blacklist
                            local result = Workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, params)
                            if result and not result.Instance:IsDescendantOf(chr) then continue end
                        end
                    end
                    local aimPart = getAimPart(chr, state.aimPart); if not aimPart then continue end
                    local screenPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position); if not onScreen then continue end

                    local score = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if state.aimPriority == "Health" then score = hum.Health
                    elseif state.aimPriority == "Visibility" then
                        local head = chr:FindFirstChild("Head")
                        score = (head and #Camera:GetPartsObscuringTarget({head.Position, LocalPlayer.Character}, {LocalPlayer.Character}) > 0) and 1 or 0
                    elseif state.aimPriority == "SpecificName" and state.priorityName ~= "" then
                        score = p.Name:lower():find(state.priorityName:lower()) and 0 or 1
                    end

                    if score < bestScore then bestScore = score; best = chr end
                end
                if best then
                    local aimPart = getAimPart(best, state.aimPart)
                    if aimPart then
                        local targetPos = aimPart.Position
                        if state.aimbotLead and aimPart.Velocity then targetPos = targetPos + aimPart.Velocity * state.leadMultiplier * 0.05 end
                        local alpha = 0.02 + (state.aimForce-1)*0.245
                        local newCF = CFrame.new(Camera.CFrame.Position, targetPos)
                        Camera.CFrame = alpha >= 1 and newCF or Camera.CFrame:Lerp(newCF, alpha)
                    end
                end
            end
        end
    end)

    -- ============================================================
    -- SILENT AIM UNIVERSAL
    -- ============================================================
    local ValidTargetParts = {"Head", "HumanoidRootPart"}
    local function isPlayerVisibleSA(player)
        local char = player.Character; if not char then return false end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return false end
        return #Camera:GetPartsObscuringTarget({root.Position, LocalPlayer.Character, char}, {LocalPlayer.Character, char}) == 0
    end

    local function getClosestPlayerSA()
        local closest, closestDist = nil, state.saFovRadius
        local mousePos = UserInputService:GetMouseLocation()
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if state.saTeamCheck and player.Team == LocalPlayer.Team then continue end
            local char = player.Character; if not char then continue end
            local hum = char:FindFirstChild("Humanoid"); if not hum or hum.Health <= 0 then continue end
            if state.saVisibleCheck and not isPlayerVisibleSA(player) then continue end

            local part = state.saTargetPart == "Random" and char[ValidTargetParts[math.random(#ValidTargetParts)]] or char:FindFirstChild(state.saTargetPart)
            if not part then continue end
            local screenPos, onScreen = worldToScreen(part.Position); if not onScreen then continue end
            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if dist < closestDist then closestDist = dist; closest = part end
        end
        return closest
    end

    -- Visual SA
    if useDrawing then
        local mouse_box = Drawing.new("Square"); mouse_box.Visible = false; mouse_box.ZIndex = 999; mouse_box.Thickness = 20; mouse_box.Size = Vector2.new(20,20); mouse_box.Filled = true
        local sa_fov_circle = Drawing.new("Circle"); sa_fov_circle.Thickness = 1; sa_fov_circle.NumSides = 100; sa_fov_circle.Filled = false; sa_fov_circle.Visible = false; sa_fov_circle.ZIndex = 999
        task.spawn(function()
            while true do
                task.wait()
                if state.silentAim then
                    sa_fov_circle.Visible = state.saFovVisible; sa_fov_circle.Radius = state.saFovRadius; sa_fov_circle.Position = UserInputService:GetMouseLocation()
                    if state.saShowTarget then
                        local target = getClosestPlayerSA()
                        if target then
                            local pos = target.Position; local screenPos, onScreen = worldToScreen(pos)
                            if onScreen then mouse_box.Visible = true; mouse_box.Position = Vector2.new(screenPos.X, screenPos.Y) else mouse_box.Visible = false end
                        else mouse_box.Visible = false end
                    else mouse_box.Visible = false end
                else sa_fov_circle.Visible = false; mouse_box.Visible = false end
            end
        end)
    end

    -- Hooks
    local oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local method = getnamecallmethod(); local args = {...}; local self = args[1]
        if state.silentAim and self == workspace and not checkcaller() and math.random(1,100) <= state.saHitChance then
            local hitPart = getClosestPlayerSA()
            if hitPart then
                if method == "FindPartOnRayWithIgnoreList" and state.saMethod == method then
                    args[2] = Ray.new(args[2].Origin, (hitPart.Position - args[2].Origin).Unit * 1000); return oldNamecall(unpack(args))
                elseif method == "FindPartOnRayWithWhitelist" and state.saMethod == method then
                    args[2] = Ray.new(args[2].Origin, (hitPart.Position - args[2].Origin).Unit * 1000); return oldNamecall(unpack(args))
                elseif method == "FindPartOnRay" and state.saMethod:lower() == method:lower() then
                    args[2] = Ray.new(args[2].Origin, (hitPart.Position - args[2].Origin).Unit * 1000); return oldNamecall(unpack(args))
                elseif method == "Raycast" and state.saMethod == method then
                    args[3] = (hitPart.Position - args[2]).Unit * 1000; return oldNamecall(unpack(args))
                end
            end
        end
        return oldNamecall(...)
    end))

    local oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, index)
        if self == Mouse and not checkcaller() and state.silentAim and state.saMethod == "Mouse.Hit/Target" then
            local hitPart = getClosestPlayerSA()
            if hitPart then
                if index == "Target" or index == "target" then return hitPart
                elseif index == "Hit" or index == "hit" then return state.saMousePrediction and hitPart.CFrame + hitPart.Velocity * state.saPredictionAmount or hitPart.CFrame
                elseif index == "UnitRay" then return Ray.new(self.Origin, (self.Hit - self.Origin).Unit) end
            end
        end
        return oldIndex(self, index)
    end))

    -- ============================================================
    -- LÓGICAS DE MOVIMENTO, FARM, CARRO, ETC
    -- ============================================================
    -- Pulo Infinito
    UserInputService.JumpRequest:Connect(function()
        if state.infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    -- Fly
    task.spawn(function()
        while true do
            task.wait()
            if state.fly then
                local char = LocalPlayer.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
                local root = char.HumanoidRootPart; local hum = char:FindFirstChild("Humanoid")
                if hum then hum.PlatformStand = true end
                if not state.flyStartY then state.flyStartY = root.Position.Y end
                local camDir = Camera.CFrame.LookVector; local moveDir = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(camDir.X, 0, camDir.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(camDir.X, 0, camDir.Z).Unit end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then state.flyStartY = state.flyStartY + state.flySpeed * 0.15 end
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then state.flyStartY = state.flyStartY - state.flySpeed * 0.15 end
                local newPos = root.Position; if moveDir.Magnitude > 0 then newPos = root.Position + moveDir.Unit * (state.flySpeed * 0.2) end
                newPos = Vector3.new(newPos.X, state.flyStartY, newPos.Z); root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.5)
            else state.flyStartY = nil end
        end
    end)

    -- Speed Hack
    task.spawn(function()
        while true do
            task.wait()
            if state.speedHack then
                local char = LocalPlayer.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame:Lerp(CFrame.new(char.HumanoidRootPart.Position + hum.MoveDirection.Unit * (state.speedValue / 60)), 0.8)
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
                    if part:IsA("BasePart") then part.Transparency = 0.85 end
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

    -- Auto Farm
    task.spawn(function()
        while true do
            task.wait(0.1)
            if not state.autoFarm then continue end
            local char = LocalPlayer.Character; if not char then continue end
            local root = char:FindFirstChild("HumanoidRootPart"); if not root then continue end
            local trash, nearestDist = nil, 50
            local keywords = {"lixo","trash","saco","papel","garrafa","lata","entulho","resto"}
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 0.9 then
                    local name = part.Name:lower()
                    for _, kw in ipairs(keywords) do if name:find(kw) then
                        local d = (part.Position - root.Position).Magnitude
                        if d < nearestDist then nearestDist = d; trash = part end
                    end end
                end
            end
            if trash then
                local dist = (trash.Position - root.Position).Magnitude
                if dist > 4 then root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position + (trash.Position - root.Position).Unit * state.farmSpeed * 0.05), 0.5)
                else local tool = char:FindFirstChildWhichIsA("Tool"); if tool then pcall(function() tool:Activate() end) end end
            end
        end
    end)

    -- Auto Essência
    task.spawn(function()
        while true do
            task.wait(0.5)
            if not state.autoEssencia then continue end
            local char = LocalPlayer.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("essencia") or obj.Name:lower():find("essence")) and tick() - state.lastEssencePick > 1.5 then
                    char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0); state.lastEssencePick = tick()
                    local tool = char:FindFirstChildWhichIsA("Tool"); if tool then pcall(function() tool:Activate() end) end
                    break
                end
            end
        end
    end)

    -- Auto Micha
    task.spawn(function()
        while true do
            task.wait(0.5)
            if not state.autoMicha then continue end
            local char = LocalPlayer.Character; if not char then continue end
            local tool = char:FindFirstChild("Micha") or LocalPlayer.Backpack:FindFirstChild("Micha")
            if tool and tool:IsA("Tool") then tool.Parent = char; pcall(function() tool:Activate() end) end
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and (prompt.ObjectText:lower():find("micha") or prompt.ActionText:lower():find("roubar")) then
                    pcall(function() fireproximityprompt(prompt) end)
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
                state.flyCarTarget = nil; continue
            end
            local char = LocalPlayer.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then continue end
            if not state.flyCarTarget or not state.flyCarTarget.Parent then
                local nearest, nearestDist = nil, math.huge
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("VehicleSeat") or obj:IsA("Seat") then
                        local car = obj:FindFirstAncestorOfClass("Model")
                        if car then
                            local p = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                            if p then local d = (p.Position - char.HumanoidRootPart.Position).Magnitude; if d < nearestDist then nearestDist = d; state.flyCarTarget = car end end
                        end
                    end
                end
            end
            if not state.flyCarTarget then continue end
            local primary = state.flyCarTarget:FindFirstChild("PrimaryPart") or state.flyCarTarget:FindFirstChildWhichIsA("BasePart")
            if not primary then continue end
            if not state.flyCarBV then state.flyCarBV = Instance.new("BodyVelocity"); state.flyCarBV.MaxForce = Vector3.new(1e9,1e9,1e9); state.flyCarBV.Parent = primary end
            if not state.flyCarBG then state.flyCarBG = Instance.new("BodyGyro"); state.flyCarBG.MaxTorque = Vector3.new(1e9,1e9,1e9); state.flyCarBG.Parent = primary end
            local moveDir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Camera.CFrame.LookVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Camera.CFrame.LookVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
            state.flyCarBV.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * state.flyCarSpeed * 0.5 or Vector3.zero
            state.flyCarBG.CFrame = CFrame.new(primary.Position, primary.Position + Camera.CFrame.LookVector)
        end
    end)

    -- Super Velocidade Carro
    task.spawn(function()
        while true do
            task.wait(0.1)
            if state.superCarSpeed and LocalPlayer.Character then
                local seat = nil
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("VehicleSeat") and v.Occupant == LocalPlayer.Character.Humanoid then seat = v; break end
                end
                if seat then
                    local car = seat:FindFirstAncestorOfClass("Model")
                    if car then
                        local p = car:FindFirstChild("PrimaryPart") or car:FindFirstChildWhichIsA("BasePart")
                        if p then p.Velocity = p.CFrame.LookVector * state.superCarSpeedValue end
                    end
                end
            end
        end
    end)

    -- Armas (Reach, etc.)
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
                    if ammo and ammo:IsA("IntValue") and ammo.Value == 0 then pcall(function() tool:Reload() end) end
                end
            end
            if state.noRecoil then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then for _, obj in ipairs(tool:GetDescendants()) do if obj:IsA("SpringConstraint") or obj:IsA("RocketPropulsion") then obj.Enabled = false end end end
            end
            if state.oneShot then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool then for _, v in ipairs(tool:GetDescendants()) do if v.Name == "Damage" and v:IsA("NumberValue") then v.Value = 9999 end end end
            end
            if state.roubarP1 then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local tool = p.Character:FindFirstChildWhichIsA("Tool"); if tool then tool.Parent = LocalPlayer.Backpack end
                    end
                end
            end
            if state.roubarP2 then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        for _, child in ipairs(p.Character:GetChildren()) do if child:IsA("Tool") then child.Parent = LocalPlayer.Backpack end end
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
                    pcall(function() tool:Activate() end); state.rapidFireTimer = tick()
                end
            end
        end
    end)

    -- RGB e tamanho
    task.spawn(function()
        while true do
            task.wait(0.05)
            if state.armaColorida then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool and tool:FindFirstChild("Handle") then tool.Handle.Color = Color3.fromHSV((tick() * state.rgbSpeed) % 1, 1, 1) end
            end
        end
    end)
    task.spawn(function()
        while true do
            task.wait(0.5)
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
            if tool then pcall(function() tool:ScaleTo(state.armaSize) end) end
        end
    end)

    -- God, Stun, Fire, Respawn
    task.spawn(function()
        while true do
            task.wait(0.5)
            if state.godMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid; hum.MaxHealth = 1e9; hum.Health = 1e9
            end
            if state.antiStun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local hum = LocalPlayer.Character.Humanoid; hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false); hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
            if state.antiFire and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do if part:IsA("BasePart") and part.Material == Enum.Material.Fire then part.Material = Enum.Material.SmoothPlastic end end
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
        if VoiceChatService then pcall(function() VoiceChatService:SetVoiceEnabled(false) end) end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false; LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end)

    print("[S4ZX HUB v2.9 KAVO] Carregado com sucesso!")
end

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
mostrarLogin()
