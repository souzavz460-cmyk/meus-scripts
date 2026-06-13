local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Configurações
local aimbot = false
local parteAlvo = "Head"
local suavidade = 0.15
local fov = 200
local autoShot = false
local timeAlvo = "Todos"
local silentAim = false
local wallShot = false
local espAtivo = false
local espNome = false
local antena = false
local flyAtivo = false
local corUI = Color3.fromRGB(150, 0, 255)
local corESP = Color3.fromRGB(150, 0, 255)

local Times = {
    ["Todos"] = nil,
    ["Criminal"] = BrickColor.new("Bright red").Color,
    ["Polícia"] = BrickColor.new("Bright blue").Color,
    ["Ladrão"] = BrickColor.new("Bright green").Color
}

-- Interface
local UI = Instance.new("ScreenGui")
UI.ResetOnSpawn = false
UI.Parent = CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 380)
main.Position = UDim2.new(0.5, -130, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
main.Parent = UI

local titulo = Instance.new("TextButton")
titulo.Size = UDim2.new(1, -40, 0, 35)
titulo.BackgroundColor3 = corUI
titulo.Text = "Apkmod SZ"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 14
titulo.BorderSizePixel = 0
Instance.new("UICorner", titulo).CornerRadius = UDim.new(0, 8)
titulo.Parent = main

-- Arrasto
local arrastando = false
local inicioToque, inicioPosicao
titulo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        arrastando = true
        inicioToque = input.Position
        inicioPosicao = main.Position
    end
end)
titulo.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        arrastando = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if arrastando and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - inicioToque
        main.Position = UDim2.new(inicioPosicao.X.Scale, inicioPosicao.X.Offset + delta.X, inicioPosicao.Y.Scale, inicioPosicao.Y.Offset + delta.Y)
    end
end)

-- Minimizar
local minimizado = false
local conteudo = Instance.new("Frame")
conteudo.Size = UDim2.new(1, 0, 1, -35)
conteudo.Position = UDim2.new(0, 0, 0, 35)
conteudo.BackgroundTransparency = 1
conteudo.Parent = main

local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0, 40, 0, 35)
btnMin.Position = UDim2.new(1, -40, 0, 0)
btnMin.BackgroundColor3 = corUI
btnMin.Text = "–"
btnMin.TextColor3 = Color3.new(1, 1, 1)
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 20
btnMin.BorderSizePixel = 0
Instance.new("UICorner", btnMin).CornerRadius = UDim.new(0, 8)
btnMin.Parent = main
btnMin.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    conteudo.Visible = not minimizado
    btnMin.Text = minimizado and "+" or "–"
    main.Size = minimizado and UDim2.new(0, 260, 0, 35) or UDim2.new(0, 260, 0, 380)
end)

-- Abas
local barraAbas = Instance.new("Frame")
barraAbas.Size = UDim2.new(1, 0, 0, 30)
barraAbas.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
barraAbas.BorderSizePixel = 0
barraAbas.Parent = conteudo

local abas = {}
local botoesAbas = {}
local abaAtual = nil

local function TrocarAba(nome)
    for _, aba in pairs(abas) do aba.Visible = false end
    if abas[nome] then
        abas[nome].Visible = true
        abaAtual = nome
    end
    for _, btn in pairs(botoesAbas) do btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
    if botoesAbas[nome] then botoesAbas[nome].BackgroundColor3 = corUI end
end

local function CriarAba(nome, posicao)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 52, 1, 0)
    btn.Position = UDim2.new(0, posicao * 52, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = nome
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = barraAbas
    botoesAbas[nome] = btn

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, -30)
    scroll.Position = UDim2.new(0, 0, 0, 30)
    scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new(0, 0, 0, 330)
    scroll.Visible = false
    scroll.Parent = conteudo
    abas[nome] = scroll

    btn.MouseButton1Click:Connect(function() TrocarAba(nome) end)
    return scroll
end

local abaAimbot = CriarAba("Aimbot", 0)
local abaSilent = CriarAba("Silent", 1)
local abaESP = CriarAba("ESP", 2)
local abaFly = CriarAba("Fly", 3)
local abaMisc = CriarAba("Misc", 4)
TrocarAba("Aimbot")

-- Controles
local function Toggle(parent, texto, y, padrao, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = texto
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 45, 0, 22)
    btn.Position = UDim2.new(0.73, 0, 0.5, -11)
    btn.BackgroundColor3 = padrao and corUI or Color3.fromRGB(80, 80, 80)
    btn.Text = padrao and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.Parent = frame

    local estado = padrao
    btn.MouseButton1Click:Connect(function()
        estado = not estado
        btn.Text = estado and "ON" or "OFF"
        btn.BackgroundColor3 = estado and corUI or Color3.fromRGB(80, 80, 80)
        callback(estado)
    end)
end

local function Dropdown(parent, texto, opcoes, padrao, y, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = texto
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.Parent = frame

    local idx = table.find(opcoes, padrao) or 1
    local atual = opcoes[idx]
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 85, 0, 22)
    btn.Position = UDim2.new(0.45, 0, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = atual
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        idx = idx % #opcoes + 1
        atual = opcoes[idx]
        btn.Text = atual
        callback(atual)
    end)
end

local function Slider(parent, texto, min, max, padrao, y, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.Position = UDim2.new(0, 5, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = texto .. ": " .. padrao
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.Parent = frame

    local menos = Instance.new("TextButton")
    menos.Size = UDim2.new(0, 28, 0, 22)
    menos.Position = UDim2.new(0.58, 0, 0.5, -11)
    menos.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    menos.Text = "-"
    menos.TextColor3 = Color3.new(1, 1, 1)
    menos.Font = Enum.Font.GothamBold
    menos.TextSize = 14
    menos.BorderSizePixel = 0
    Instance.new("UICorner", menos).CornerRadius = UDim.new(0, 4)
    menos.Parent = frame

    local mais = Instance.new("TextButton")
    mais.Size = UDim2.new(0, 28, 0, 22)
    mais.Position = UDim2.new(0.75, 0, 0.5, -11)
    mais.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    mais.Text = "+"
    mais.TextColor3 = Color3.new(1, 1, 1)
    mais.Font = Enum.Font.GothamBold
    mais.TextSize = 14
    mais.BorderSizePixel = 0
    Instance.new("UICorner", mais).CornerRadius = UDim.new(0, 4)
    mais.Parent = frame

    local valor = padrao
    menos.MouseButton1Click:Connect(function()
        valor = math.max(min, valor - 5)
        lbl.Text = texto .. ": " .. valor
        callback(valor)
    end)
    mais.MouseButton1Click:Connect(function()
        valor = math.min(max, valor + 5)
        lbl.Text = texto .. ": " .. valor
        callback(valor)
    end)
end

-- Preencher abas
Toggle(abaAimbot, "Aimbot", 10, false, function(v) aimbot = v end)
Dropdown(abaAimbot, "Alvo", {"Head", "Neck", "Chest"}, "Head", 50, function(v) parteAlvo = v end)
Slider(abaAimbot, "Suavidade", 5, 100, 15, 90, function(v) suavidade = v/100 end)
Slider(abaAimbot, "FOV", 50, 400, 200, 130, function(v) fov = v end)
Toggle(abaAimbot, "Auto Shot", 170, false, function(v) autoShot = v end)
Dropdown(abaAimbot, "Time", {"Todos", "Criminal", "Polícia", "Ladrão"}, "Todos", 210, function(v) timeAlvo = v end)

Toggle(abaSilent, "Silent Aim", 10, false, function(v)
    silentAim = v
    if v or wallShot then ConfigurarInterceptador() end
end)
Toggle(abaSilent, "WallShot", 50, false, function(v)
    wallShot = v
    if v or silentAim then ConfigurarInterceptador() end
end)

Toggle(abaESP, "ESP Player", 10, false, function(v) espAtivo = v end)
Toggle(abaESP, "ESP Name", 50, false, function(v) espNome = v end)
Toggle(abaESP, "Antena", 90, false, function(v) antena = v end)

local flyConnection
Toggle(abaFly, "Fly", 10, false, function(v)
    flyAtivo = v
    if v then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(40000, 40000, 40000)
                bv.P = 3000
                bv.Parent = hrp
                local bg = Instance.new("BodyGyro")
                bg.MaxTorque = Vector3.new(40000, 40000, 40000)
                bg.CFrame = hrp.CFrame
                bg.P = 3000
                bg.Parent = hrp
                flyConnection = RunService.RenderStepped:Connect(function()
                    if not flyAtivo then return end
                    local moveDir = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    bv.Velocity = moveDir * 50
                    bg.CFrame = Camera.CFrame
                end)
            end
        end
    else
        if flyConnection then flyConnection:Disconnect() end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in ipairs(hrp:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then obj:Destroy() end
                end
            end
        end
    end
end)

Dropdown(abaMisc, "Cor UI", {"Roxo", "Vermelho", "Verde"}, "Roxo", 10, function(v)
    if v == "Roxo" then corUI = Color3.fromRGB(150, 0, 255)
    elseif v == "Vermelho" then corUI = Color3.fromRGB(255, 0, 0)
    else corUI = Color3.fromRGB(0, 255, 0) end
    titulo.BackgroundColor3 = corUI
    btnMin.BackgroundColor3 = corUI
    if botoesAbas[abaAtual] then botoesAbas[abaAtual].BackgroundColor3 = corUI end
end)
Dropdown(abaMisc, "Cor ESP", {"Roxo", "Vermelho", "Verde"}, "Roxo", 50, function(v)
    if v == "Roxo" then corESP = Color3.fromRGB(150, 0, 255)
    elseif v == "Vermelho" then corESP = Color3.fromRGB(255, 0, 0)
    else corESP = Color3.fromRGB(0, 255, 0) end
end)

-- Lógica de mira
local function AlvoValido(plr)
    if timeAlvo == "Todos" then return true end
    return plr.Team and plr.Team.TeamColor.Color == Times[timeAlvo]
end

local function ObterAlvo()
    local centro = Camera.ViewportSize / 2
    local maisProximo = nil
    local menorDist = wallShot and 9999 or fov
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and AlvoValido(plr) then
            local cabeca = plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if cabeca and hum and hum.Health > 0 then
                local posTela, naTela = Camera:WorldToViewportPoint(cabeca.Position)
                local dist = naTela and (Vector2.new(posTela.X, posTela.Y) - centro).Magnitude or 9999
                if wallShot or dist < menorDist then
                    menorDist = dist
                    maisProximo = plr.Character
                end
            end
        end
    end
    return maisProximo
end

local function ObterParte(char, parte)
    if parte == "Head" then return char:FindFirstChild("Head")
    elseif parte == "Neck" then
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        local cabeca = char:FindFirstChild("Head")
        if torso and cabeca then return {Position = (torso.Position + cabeca.Position) / 2} end
    elseif parte == "Chest" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") end
    return char:FindFirstChild("Head")
end

-- Interceptador de tiro
local ultimoEvento, ultimoOriginal
function ConfigurarInterceptador()
    if ultimoEvento and ultimoOriginal then
        ultimoEvento.FireServer = ultimoOriginal
        ultimoEvento = nil
        ultimoOriginal = nil
    end
    if not silentAim and not wallShot then return end
    coroutine.wrap(function()
        while silentAim or wallShot do
            local ferramenta = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if ferramenta then
                local evento = ferramenta:FindFirstChild("RemoteEvent") or
                              ferramenta:FindFirstChild("Shoot") or
                              ferramenta:FindFirstChild("FireServer") or
                              ferramenta:FindFirstChild("Server")
                if evento and evento:IsA("RemoteEvent") and evento ~= ultimoEvento then
                    ultimoEvento = evento
                    ultimoOriginal = evento.FireServer
                    evento.FireServer = function(self, ...)
                        local alvo = ObterAlvo()
                        if alvo then
                            local parte = ObterParte(alvo, "Head")
                            if parte then
                                return ultimoOriginal(self, parte.Position)
                            end
                        end
                        return ultimoOriginal(self, ...)
                    end
                end
            end
            task.wait(0.1)
        end
        if ultimoEvento and ultimoOriginal then
            ultimoEvento.FireServer = ultimoOriginal
            ultimoEvento = nil
            ultimoOriginal = nil
        end
    end)()
end

-- Aimbot suave
coroutine.wrap(function()
    while true do
        if aimbot and not silentAim then
            local alvo = ObterAlvo()
            if alvo then
                local parte = ObterParte(alvo, parteAlvo)
                if parte then
                    local objetivo = CFrame.new(Camera.CFrame.Position, parte.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(objetivo, suavidade)
                    if autoShot then
                        local ferramenta = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if ferramenta then
                            ferramenta:Activate()
                            pcall(function()
                                VirtualInputManager:SendMouseButtonEvent(
                                    Camera.ViewportSize.X / 2,
                                    Camera.ViewportSize.Y / 2,
                                    0, true, nil, 0
                                )
                                task.wait(0.05)
                                VirtualInputManager:SendMouseButtonEvent(
                                    Camera.ViewportSize.X / 2,
                                    Camera.ViewportSize.Y / 2,
                                    0, false, nil, 0
                                )
                            end)
                        end
                    end
                end
            end
        end
        task.wait()
    end
end)()

-- ESP
local drawings = {}
local podeDesenhar = pcall(function() return Drawing.new end)

local function LimparESP()
    for _, d in pairs(drawings) do
        pcall(function() d:Remove() end)
    end
    drawings = {}
end

local function AtualizarESP()
    LimparESP()
    if not (espAtivo or espNome or antena) or not podeDesenhar then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and AlvoValido(plr) then
            local cabeca = plr.Character:FindFirstChild("Head")
            local raiz = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if cabeca and raiz and hum and hum.Health > 0 then
                local posCab, naTela = Camera:WorldToViewportPoint(cabeca.Position)
                if naTela then
                    if espAtivo then
                        local posRaiz = Camera:WorldToViewportPoint(raiz.Position)
                        local box = Drawing.new("Square")
                        box.Visible = true
                        box.Color = corESP
                        box.Thickness = 1.5
                        box.Filled = false
                        box.Size = Vector2.new(40, 60)
                        box.Position = Vector2.new(posRaiz.X - 20, posRaiz.Y - 60)
                        table.insert(drawings, box)
                    end
                    if espNome then
                        local txt = Drawing.new("Text")
                        txt.Visible = 
