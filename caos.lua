-- [[ SELENIUM HUB v7 - LEGENDARY CAOS EDITION ]]
-- BYPASS NO TALO - SISTEMA DE CAMUFLAGEM DE REDE ACTIVED

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
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainFrame.Position = UDim2.new(0.5, -200, 0.35, -100)
MainFrame.Size = UDim2.new(0, 400, 0, 310) -- Aumentado para caber tudo
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(235, 75, 125) -- Rosa Neon Selenium

Title.Parent = MainFrame
Title.Position = UDim2.new(0, 15, 0, 12)
Title.Size = UDim2.new(0, 250, 0, 20)
Title.BackgroundTransparency = 1
Title.Text = "Selenium Hub v7 - GOD MODE CAOS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left

TabContainer.Parent = MainFrame
TabContainer.Position = UDim2.new(0, 15, 0, 45)
TabContainer.Size = UDim2.new(0, 370, 0, 250)
TabContainer.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout")
Layout.Parent = TabContainer
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 5)

local function AddToggle(text, callback)
    local button = Instance.new("TextButton")
    local bCorner = Instance.new("UICorner")
    local active = false
    
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    button.TextColor3 = Color3.fromRGB(180, 180, 180)
    button.Text = "  [ OFF ]  " .. text
    button.TextSize = 13
    button.Font = Enum.Font.SourceSansBold
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = TabContainer
    
    bCorner.CornerRadius = UDim.new(0, 5)
    bCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        active = not active
        button.Text = active and "  [ ON ]  " .. text or "  [ OFF ]  " .. text
        button.TextColor3 = active and Color3.fromRGB(255, 75, 125) or Color3.fromRGB(180, 180, 180)
        button.BackgroundColor3 = active and Color3.fromRGB(32, 22, 30) or Color3.fromRGB(22, 22, 26)
        callback(active)
    end)
end

-- [[ VARIÁVEIS DO MOTOR DO CHEAT ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local carKillActive = false
local teamSpamActive = false
local gunFloodActive = false
local nexusTrapActive = false
local oneShotActive = false

-- 1. LOOP CAR KILL (Atropelamento por Teleporte Securo)
task.spawn(function()
    while true do
        task.wait(0.1)
        if carKillActive then
            pcall(function()
                -- Encontra um carro no mapa
                local car = Workspace:FindFirstChild("Prison_Car", true) or Workspace:FindFirstChild("Sedan", true)
                if car and car:FindFirstChild("Body") then
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            if player.Character.Humanoid.Health > 0 then
                                -- Teleporta o carro amassando o cara e zera a velocidade em seguida (Bypass)
                                car.Body.CFrame = player.Character.HumanoidRootPart.CFrame
                                car.Body.Velocity = Vector3.new(0,0,0)
                                task.wait(0.02)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 2. SPAM DE MODIFICAR O TIME (Invisibilidade de Hitbox)
task.spawn(function()
    while true do
        task.wait(0.15) -- Delay calculado para não dar kick por spam
        if teamSpamActive then
            pcall(function()
                -- Fica alternando o evento de time instantaneamente para bugar os guardas
                local event = Workspace:FindFirstChild("Remote", true)
                if event and event:FindFirstChild("TeamEvent") then
                    event.TeamEvent:FireServer("Neutral")
                end
            end)
        end
    end
end)

-- 3. LOOP GIVE GUNS SERVER (Inundar o mapa de Armas)
task.spawn(function()
    while true do
        task.wait(0.4) -- Drop seguro para a rede não cair
        if gunFloodActive then
            pcall(function()
                local itemEvent = Workspace:FindFirstChild("Remote", true)
                if itemEvent and itemEvent:FindFirstChild("ItemHandler") then
                    -- Invoca o evento de pegar a Remington legítima e joga no chão
                    itemEvent.ItemHandler:FireServer(Workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
                    if LocalPlayer.Backpack:FindFirstChild("Remington 870") then
                        LocalPlayer.Backpack["Remington 870"].Parent = Workspace
                    end
                end
            end)
        end
    end
end)

-- 4. NEXUS TRAP (Trancar portões do Spawn dos Guardas)
task.spawn(function()
    while true do
        task.wait(0.5)
        if nexusTrapActive then
            pcall(function()
                -- Cria blocos invisíveis locais na porta do spawn dos guardas
                local spawnDoor = Workspace.Cafeteria -- Referência de área do Nexus
                if not Workspace:FindFirstChild("SeleniumTrap") then
                    local wall = Instance.new("Part", Workspace)
                    wall.Name = "SeleniumTrap"
                    wall.Size = Vector3.new(30, 20, 2)
                    wall.CFrame = CFrame.new(882, 100, 2310) -- Coordenadas da saída dos guardas
                    wall.Transparency = 0.7
                    wall.Color = Color3.fromRGB(235, 75, 125)
                    wall.Anchored = true
                end
            end)
        else
            if Workspace:FindFirstChild("SeleniumTrap") then
                Workspace.SeleniumTrap:Destroy()
            end
        end
    end
end)

-- 5. INVISIBLE ONE-SHOT MELEE (Soco Fantasma Fatal)
local Mouse = LocalPlayer:GetMouse()
Mouse.Button1Down:Connect(function()
    if oneShotActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Melee") then
        pcall(function()
            -- Torna invisível localmente por milissegundos na hora do impacto
            LocalPlayer.Character.Head.Transparency = 1
            for i = 1, 5 do -- Dispara 5 vezes o soco no mesmo frame = Instakill legítimo
                local melee = ReplicatedStorage:FindFirstChild("meleeEvent")
                if melee then
                    -- Procura alvo próximo
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.Head.Position).Magnitude
                            if dist <= 12 then
                                melee:FireServer(player)
                            end
                        end
                    end
                end
            end
            task.wait(0.1)
            LocalPlayer.Character.Head.Transparency = 0
        end)
    end
end)

-- [[ ADICIONANDO NA INTERFACE ]]
AddToggle("Car Kill Atropelador (Caos de Física)", function(state) carKillActive = state end)
AddToggle("Time Spam Bug (Anti-Golpes/Prender)", function(state) teamSpamActive = state end)
AddToggle("Chuva de Armas (Guerra no Pátio)", function(state) gunFloodActive = state end)
AddToggle("Nexus Trap (Prender Guardas no Spawn)", function(state) nexusTrapActive = state end)
AddToggle("Soco One-Shot Fantasma (Discretíssimo)", function(state) oneShotActive = state end)
