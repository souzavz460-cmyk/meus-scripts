-- [[ SELENIUM HUB v6 - MODO CAOS TOTAL ]]
-- Guarde este código no seu GitHub para gerar a Loadstring

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local UICorner = Instance.new("UICorner")
local TabContainer = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.Position = UDim2.new(0.5, -200, 0.35, -100)
MainFrame.Size = UDim2.new(0, 400, 0, 260)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(235, 75, 125) -- Rosa Neon do Selenium

Title.Parent = MainFrame
Title.Position = UDim2.new(0, 15, 0, 12)
Title.Size = UDim2.new(0, 200, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "Selenium Hub - MODO CAOS"
Title.TextColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho de Alerta
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

TabContainer.Parent = MainFrame
TabContainer.Position = UDim2.new(0, 15, 0, 45)
TabContainer.Size = UDim2.new(0, 370, 0, 200)
TabContainer.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout")
Layout.Parent = TabContainer
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)

local function AddToggle(text, callback)
    local button = Instance.new("TextButton")
    local bCorner = Instance.new("UICorner")
    local active = false
    
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Text = "  [ OFF ]  " .. text
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = TabContainer
    
    bCorner.CornerRadius = UDim.new(0, 5)
    bCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        active = not active
        button.Text = active and "  [ ON ]  " .. text or "  [ OFF ]  " .. text
        button.TextColor3 = active and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(200, 200, 200)
        button.BackgroundColor3 = active and Color3.fromRGB(40, 20, 20) or Color3.fromRGB(25, 25, 30)
        callback(active)
    end)
end

-- [[ CONFIGURAÇÕES DAS FUNÇÕES LOUCAS ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local killServerActive = false
local loopTaserActive = false
local arrestAllActive = false

-- 1. KILL ALL (Mata o Servidor Inteiro Instantaneamente)
-- Transmite pacotes de soco em massa para TODOS os jogadores simultaneamente sem parar.
task.spawn(function()
    while true do
        task.wait(0.01) -- Velocidade máxima de rede tolerada antes do crash
        if killServerActive and LocalPlayer.Character then
            pcall(function()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                        if player.Character.Humanoid.Health > 0 then
                            local meleeEvent = ReplicatedStorage:FindFirstChild("meleeEvent")
                            if meleeEvent then
                                -- Dispara contra o jogador independente da distância
                                meleeEvent:FireServer(player)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 2. LOOP TASER / SPAM DE DEITAR (Sendo Policial)
-- Derruba todo mundo no chão infinitamente usando a mecânica do Taser.
task.spawn(function()
    while true do
        task.wait(0.1)
        if loopTaserActive and LocalPlayer.Character then
            pcall(function()
                local taserEvent = ReplicatedStorage:FindFirstChild("TaserEvent") -- Evento do Taser
                if taserEvent then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            -- Força o estado de choque no personagem do alvo
                            taserEvent:FireServer(player.Character.HumanoidRootPart.Position, player.Character.HumanoidRootPart)
                        end
                    end
                end
            end)
        end
    end
end)

-- 3. ARREST ALL (Prende a Prisão Inteira de Uma Vez)
-- Se você for policial, essa função puxa o remote de prisão e algema todos os criminosos/prisioneiros do mapa.
AddToggle("Arrest All (Prender o Mapa Inteiro)", function(state)
    arrestAllActive = state
    if arrestAllActive then
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Capsule") then
                    -- Invoca a função nativa de prender sem precisar chegar perto
                    local arEvent = workspace:FindFirstChild("Remote", true) -- Localiza o remote dinâmico de algema
                    if arEvent and arEvent:FindFirstChild("Armarrest") then
                        arEvent.Armarrest:FireServer(player.Character.Capsule)
                    end
                end
            end
        end)
    end
end)

-- BOTÕES ADICIONAIS NA INTERFACE DO CAOS
AddToggle("Kill All Server (Chuva de Socos)", function(state)
    killServerActive = state
end)

AddToggle("Taser Spam (Deitar Todo Mundo)", function(state)
    loopTaserActive = state
end)
