-- Snow S4zx Mod – Versão Final (AutoClick removido, AutoFarm sem clique virtual, sem interferência no céu)
local KEYS_URL = "https://raw.githubusercontent.com/souzavz460-cmyk/s4zx-keys/refs/heads/main/keys.json"
local DONO_KEY = "S4zx-DonoSupreme2026"

-- Tela de Login (ScreenGui)
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
        if key == "" then
            status.Text = "Digite uma key"
            status.TextColor3 = Color3.fromRGB(255,200,0)
            return
        end
        
        if key == DONO_KEY then
            status.Text = "✅ Key do Dono (Permanente)"
            status.TextColor3 = Color3.fromRGB(0,255,100)
            task.wait(1)
            gui:Destroy()
            carregarInterface()
            return
        end
        
        btn.Text = "AGUARDE..."
        btn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        
        local ok, json = pcall(function() return game:HttpGet(KEYS_URL) end)
        if ok and json and json ~= "" then
            local keys = {}
            pcall(function() keys = game:GetService("HttpService"):JSONDecode(json) end)
            local data = keys[key]
            if data then
                if data.dias == "perm" then
                    status.Text = "✅ Key permanente"
                    status.TextColor3 = Color3.fromRGB(0,255,100)
                    task.wait(1)
                    gui:Destroy()
                    carregarInterface()
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
                            gui:Destroy()
                            carregarInterface()
                            return
                        else
                            status.Text = "❌ Key expirada"
                            status.TextColor3 = Color3.fromRGB(255,50,50)
                        end
                    end
                end
            else
                status.Text = "❌ Key inválida"
                status.TextColor3 = Color3.fromRGB(255,50,50)
            end
        else
            status.Text = "❌ Erro ao verificar key"
            status.TextColor3 = Color3.fromRGB(255,50,50)
        end
        
        btn.Text = "ENTRAR"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    end
    
    btn.Activated:Connect(tentarLogin)
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then tentarLogin() end
    end)
end

-- Função principal da interface
function carregarInterface()
    local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
    local Window = Rayfield:CreateWindow({
        Name = "S4zx MODS",
        LoadingTitle = "S4zx MODS",
        LoadingSubtitle = "by Souzavz",
        ShowText = "S4zx MODS",
        Theme = "DarkBlue",
        ConfigurationSaving = { Enabled = true, FolderName = "SnowS4zx", FileName = "Config" },
        KeySystem = false,
        MobileButton = { Enabled = true, Name = "S4zx MODS" }
    })
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local CoreGui = game:GetService("CoreGui")
    local Player = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Lighting = game:GetService("Lighting")
    
    -- Variáveis de estado (AutoClick removido, sem clique virtual no farm)
    local aimbot = false; local aimForce = 1; local bypass = 1; local fovRadius = 150
    local wallCheck = false; local silentAimEnabled = false
    local fovCircle = false; local fovRainbow = false
    local espBox = false; local espSkel = false; local espName = false
    local espDistance = false; local espHealth = false; local tracerV7 = false
    local espItems = false; local showMoney = false; local showTeamESP = false; local espPlayerWeapon = false
    local infJump = false; local flyEnabled = false; local flySpeed = 50
    local speedEnabled = false; local speedValue = 24
    local s4zxFarm = false; local farmSpeed = 50
    local antiLive = false
    local boxColor = Color3.fromRGB(0,255,0); local skelColor = Color3.fromRGB(255,105,180)
    local tracerColor = Color3.fromRGB(255,255,255)
    local invisibility = false; local ghostMode = false
    local antiAfk = false; local antiStun = false; local antiFire = false; local autoRespawn = false
    local reach = false; local reachDistance = 15
    local infiniteAmmo = false; local autoReload = false
    local noRecoil = false; local rapidFire = false; local rapidFireDelay = 0.1
    local rainbowChar = false; local rainbowSpeed = 0.5
    local rainbowBox = false; local rainbowSkel = false; local rainbowTracer = false
    local rainbowWorld = false; local rainbowSky = false; local rainbowFog = false; local rainbowLighting = false
    local flyCarEnabled = false; local flyCarSpeed = 50
    local streamerMode = false
    local customCrosshair = false; local crosshairSize = 20; local crosshairColor = Color3.fromRGB(255,0,0)
    
    -- Bypass
    local lastCleanup = 0
    local CLEANUP_INTERVAL = 2.0
    
    -- Fly auxiliar
    local flyStartY = nil
    
    -- Abas
    local function safeTab(n, i) local t; pcall(function() t = Window:CreateTab(n, i) end); return t end
    local AimbotTab = safeTab("AIMBOT", 4483362458)
    local ESPTab = safeTab("ESP", 4483362458)
    local VisualTab = safeTab("VISUAL", 4483362458)
    local RainbowTab = safeTab("RAINBOW", 4483362458)
    local MoveTab = safeTab("MOVIMENTO", 4483362458)
    local FarmTab = safeTab("FARM", 4483362458)
    local WeaponTab = safeTab("ARMAS", 4483362458)
    local CarTab = safeTab("CAR", 4483362458)
    local ExtrasTab = safeTab("EXTRAS", 4483362458)
    local StreamTab = safeTab("STREAM", 4483362458)
    local ConfigTab = safeTab("CONFIG", 4483362458)
    
    local function safeToggle(tab, name, d, cb) if tab then pcall(function() tab:CreateToggle({Name=name, CurrentValue=d, Callback=cb}) end) end end
    local function safeSlider(tab, name, min, max, d, cb) if tab then pcall(function() tab:CreateSlider({Name=name, Range={min, max}, Increment=1, CurrentValue=d, Callback=cb, Flag=name:gsub("%s","_")}) end) end end
    local function safeInput(tab, name, ph, cb) if tab then pcall(function() tab:CreateInput({Name=name, PlaceholderText=ph, RemoveTextAfterFocusLost=false, Callback=cb}) end) end end
    
    -- AIMBOT
    safeToggle(AimbotTab, "AIMBOT", false, function(v) aimbot = v end)
    safeSlider(AimbotTab, "Força (1-5)", 1, 5, 1, function(v) aimForce = v end)
    safeSlider(AimbotTab, "Bypass", 1, 10, 1, function(v) bypass = v end)
    safeSlider(AimbotTab, "FOV (Raio)", 50, 500, 150, function(v) fovRadius = v end)
    safeToggle(AimbotTab, "WALLCK (Parede)", false, function(v) wallCheck = v end)
    safeToggle(AimbotTab, "SILENT AIM", false, function(v) silentAimEnabled = v end)
    
    -- ESP
    safeToggle(ESPTab, "2D Box", false, function(v) espBox = v end)
    safeToggle(ESPTab, "Skeleton", false, function(v) espSkel = v end)
    safeToggle(ESPTab, "Name", false, function(v) espName = v end)
    safeToggle(ESPTab, "Distance", false, function(v) espDistance = v end)
    safeToggle(ESPTab, "Health Bar", false, function(v) espHealth = v end)
    safeToggle(ESPTab, "Tracer V7 (do chão)", false, function(v) tracerV7 = v end)
    safeToggle(ESPTab, "Itens (Moedas/Armas)", false, function(v) espItems = v end)
    safeToggle(ESPTab, "Dinheiro", false, function(v) showMoney = v end)
    safeToggle(ESPTab, "Mostrar Time", false, function(v) showTeamESP = v end)
    safeToggle(ESPTab, "Arma Equipada", false, function(v) espPlayerWeapon = v end)
    
    -- VISUAL
    safeInput(VisualTab, "Cor Box", "verde", function(v) local c=parseColor(v) if c then boxColor=c end end)
    safeInput(VisualTab, "Cor Skeleton", "rosa", function(v) local c=parseColor(v) if c then skelColor=c end end)
    safeInput(VisualTab, "Cor Tracer V7", "branco", function(v) local c=parseColor(v) if c then tracerColor=c end end)
    safeToggle(VisualTab, "FOV Círculo", false, function(v) fovCircle = v end)
    safeToggle(VisualTab, "FOV Arco-íris", false, function(v) fovRainbow = v end)
    
    -- RAINBOW (mantido, mas você pode desativar qualquer um se interferir)
    safeToggle(RainbowTab, "Rainbow Box", false, function(v) rainbowBox = v end)
    safeToggle(RainbowTab, "Rainbow Skeleton", false, function(v) rainbowSkel = v end)
    safeToggle(RainbowTab, "Rainbow Tracer", false, function(v) rainbowTracer = v end)
    safeToggle(RainbowTab, "Rainbow Character", false, function(v) rainbowChar = v end)
    safeSlider(RainbowTab, "Velocidade Rainbow", 0.1, 3, 0.5, function(v) rainbowSpeed = v end)
    safeToggle(RainbowTab, "Rainbow World", false, function(v) rainbowWorld = v end)
    safeToggle(RainbowTab, "Rainbow Sky", false, function(v) rainbowSky = v end)
    safeToggle(RainbowTab, "Rainbow Fog", false, function(v) rainbowFog = v end)
    safeToggle(RainbowTab, "Rainbow Lighting", false, function(v) rainbowLighting = v end)
    
    -- MOVIMENTO
    safeToggle(MoveTab, "Pulo Infinito", false, function(v) infJump = v end)
    safeToggle(MoveTab, "Fly Avançado", false, function(v) flyEnabled = v; if not v then flyStartY = nil end end)
    safeSlider(MoveTab, "Velocidade Fly", 20, 200, 50, function(v) flySpeed = v end)
    safeToggle(MoveTab, "Speed Hack", false, function(v) speedEnabled = v end)
    safeSlider(MoveTab, "Velocidade Speed", 16, 200, 24, function(v) speedValue = v end)
    safeToggle(MoveTab, "Ghost Mode (Invisível)", false, function(v) ghostMode = v; invisibility = v end)
    
    -- FARM
    safeToggle(FarmTab, "S4zx Farm", false, function(v) s4zxFarm = v end)
    safeSlider(FarmTab, "Velocidade Farm", 30, 100, 50, function(v) farmSpeed = v end)
    
    -- ARMAS
    safeToggle(WeaponTab, "Reach (Alcance)", false, function(v) reach = v end)
    safeSlider(WeaponTab, "Distância", 10, 50, 15, function(v) reachDistance = v end)
    safeToggle(WeaponTab, "Infinite Ammo", false, function(v) infiniteAmmo = v end)
    safeToggle(WeaponTab, "Auto Reload", false, function(v) autoReload = v end)
    safeToggle(WeaponTab, "No Recoil", false, function(v) noRecoil = v end)
    safeToggle(WeaponTab, "Rapid Fire", false, function(v) rapidFire = v end)
    safeSlider(WeaponTab, "Rapid Fire Delay", 0.05, 0.5, 0.1, function(v) rapidFireDelay = v end)
    
    -- CAR
    safeToggle(CarTab, "Fly Car", false, function(v) flyCarEnabled = v end)
    safeSlider(CarTab, "Velocidade Fly Car", 20, 200, 50, function(v) flyCarSpeed = v end)
    
    -- EXTRAS (AutoClick removido)
    safeToggle(ExtrasTab, "Anti AFK", false, function(v) antiAfk = v end)
    safeToggle(ExtrasTab, "Anti Stun", false, function(v) antiStun = v end)
    safeToggle(ExtrasTab, "Anti Fire", false, function(v) antiFire = v end)
    safeToggle(ExtrasTab, "Auto Respawn", false, function(v) autoRespawn = v end)
    
    -- STREAM
    safeToggle(StreamTab, "Modo Streamer", false, function(v)
        streamerMode = v
        Window.Enabled = not v
    end)
    
    -- CONFIG
    safeToggle(ConfigTab, "Anti Live", false, function(v) antiLive = v end)
    
    function parseColor(input)
        local s = tostring(input):lower():gsub("%s","")
        local named = { vermelho="ff0000", red="ff0000", verde="00ff00", green="00ff00", azul="0000ff", blue="0000ff", amarelo="ffff00", yellow="ffff00", roxo="800080", purple="800080", laranja="ff8800", orange="ff8800", preto="000000", black="000000", branco="ffffff", white="ffffff", rosa="ff00ff", pink="ff00ff", ciano="00ffff", cyan="00ffff" }
        if named[s] then s = named[s] end
        if #s == 6 and s:match("^%x+$") then return Color3.fromRGB(tonumber(s:sub(1,2),16), tonumber(s:sub(3,4),16), tonumber(s:sub(5,6),16)) end
        return nil
    end
    
    -- ==================== FUNÇÕES ====================
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
        local crosshairObj
        
        -- Silent Aim
        local silentAimConnection
        local function setupSilentAim()
            if silentAimConnection then silentAimConnection:Disconnect() end
            if not silentAimEnabled then return end
            silentAimConnection = Workspace.DescendantAdded:Connect(function(obj)
                if not silentAimEnabled then return end
                if obj:IsA("BasePart") and (obj.Velocity.Magnitude > 50 or obj:GetAttribute("Owner") == Player.Name) then
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
                        local headPos = nearest.Head.Position
                        local dir = (headPos - obj.Position).Unit
                        obj.Velocity = dir * obj.Velocity.Magnitude
                        obj.CFrame = CFrame.new(obj.Position, headPos)
                    end
                end
            end)
        end
        
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
            if #enemies == 0 then return end
            table.sort(enemies, function(a,b) return a.dist < b.dist end)
            local targetPos = enemies[1].chr.Head.Position + Vector3.new(math.random()-0.5,math.random()-0.5,math.random()-0.5)*(bypass*0.03)
            local alpha = 0.02 + (aimForce-1)*0.245
            if alpha >= 1 then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), alpha) end
        end
        
        -- ESP
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
            local hue = (tick() * rainbowSpeed) % 1
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
            
            if customCrosshair then
                if not crosshairObj then
                    pcall(function()
                        crosshairObj = Drawing.new("Square")
                        crosshairObj.Filled = true; crosshairObj.Color = crosshairColor
                    end)
                end
                if crosshairObj then
                    crosshairObj.Size = Vector2.new(crosshairSize/2, crosshairSize/2)
                    crosshairObj.Position = screenSize/2 - Vector2.new(crosshairSize/4, crosshairSize/4)
                    crosshairObj.Visible = true
                end
            else
                if crosshairObj then crosshairObj.Visible = false end
            end
        end
        
        -- Speed
        local function speedStep()
            if not speedEnabled then return end
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hum = char:FindFirstChild("Humanoid")
            if not hum then return end
            local root = char.HumanoidRootPart
            hum.WalkSpeed = 16
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                local delta = speedValue / 60
                local newPos = root.Position + moveDir.Unit * delta
                root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.8)
            end
        end
        
        -- Fly
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
            local moving = false
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(camDir.X, 0, camDir.Z).Unit; moving = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(camDir.X, 0, camDir.Z).Unit; moving = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude; moving = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += Camera.CFrame.RightVector * Vector3.new(1,0,1).Magnitude; moving = true end
            local verticalChange = 0
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then verticalChange = 1; moving = true end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then verticalChange = -1; moving = true end
            if verticalChange ~= 0 then flyStartY = flyStartY + verticalChange * (flySpeed * 0.15) end
            local newPos = root.Position
            if moving and moveDir.Magnitude > 0 then newPos = root.Position + moveDir.Unit * (flySpeed * 0.2) end
            newPos = Vector3.new(newPos.X, flyStartY, newPos.Z)
            root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.5)
        end
        
        -- Ghost
        local function invisibilityStep()
            if not invisibility then return end
            local char = Player.Character
            if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.Transparency = 0.8 end end end
        end
        
        -- Farm (sem clique virtual)
        local function findNearestTrash()
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
            local root = char.HumanoidRootPart
            local nearest, nearestDist = nil, 50
            local keywords = {"lixo","trash","saco","papel","garrafa","lata","entulho","resto","garbage","waste","bag","bottle","can","paper"}
            for _, part in ipairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "" then
                    local name = part.Name:lower()
                    local isTrash = false
                    for _, kw in ipairs(keywords) do if name:find(kw) then isTrash = true; break end end
                    if isTrash and part.Transparency < 0.9 and part.Parent then
                        local dist = (part.Position - root.Position).Magnitude
                        if dist < nearestDist then nearestDist = dist; nearest = part end
                    end
                end
            end
            return nearest
        end
        
        local lastFarmAction = 0
        local function farmStep()
            if not s4zxFarm then return end
            local char = Player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local root = char.HumanoidRootPart
            local trash = findNearestTrash()
            if not trash then return end
            local targetPos = trash.Position
            local distance = (targetPos - root.Position).Magnitude
            if distance > 4 then
                local direction = (targetPos - root.Position).Unit
                local newPos = root.Position + direction * (farmSpeed * 0.15)
                root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), 0.4)
                return
            end
            -- Sem clique virtual: apenas tenta ativar a ferramenta
            local tool = char:FindFirstChildWhichIsA("Tool")
            if tool and tick() - lastFarmAction > 0.5 then
                pcall(function() tool:Activate() end)
                lastFarmAction = tick()
            end
        end
        
        -- Fly Car
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
                if flyCarBV then flyCarBV:Destroy() end
                flyCarBV = Instance.new("BodyVelocity"); flyCarBV.MaxForce = Vector3.new(1e9,1e9,1e9); flyCarBV.Parent = primary
            end
            if not flyCarBG or not flyCarBG.Parent then
                if flyCarBG then flyCarBG:Destroy() end
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
        
        -- Bypass
        local function bypassCleanup()
            local now = tick()
            if now - lastCleanup < CLEANUP_INTERVAL then return end
            lastCleanup = now
            local char = Player.Character
            if not char then return end
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.WalkSpeed = 16 end
            if not flyCarEnabled then
                if flyCarTarget then
                    local bv = flyCarTarget:FindFirstChild("BodyVelocity")
                    if bv then bv:Destroy() end
                    local bg = flyCarTarget:FindFirstChild("BodyGyro")
                    if bg then bg:Destroy() end
                end
            end
            if not flyEnabled and not invisibility then
                if hum and hum.PlatformStand then hum.PlatformStand = false end
            end
            pcall(function()
                Player:SetAttribute("SpeedHack", nil)
                Player:SetAttribute("FlyHack", nil)
            end)
        end
        
        -- Armas
        local function reachStep()
            if not reach then return end
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then pcall(function() tool.MaxActivationDistance = reachDistance end) end
        end
        local function infiniteAmmoStep()
            if not infiniteAmmo then return end
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets") or tool:FindFirstChild("Magazine")
                if ammo and ammo:IsA("IntValue") then ammo.Value = 999 end
            end
        end
        local function autoReloadStep()
            if not autoReload then return end
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then
                local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("Bullets")
                if ammo and ammo:IsA("IntValue") and ammo.Value == 0 then pcall(function() tool:Reload() end) end
            end
        end
        local function noRecoilStep()
            if not noRecoil then return end
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool then for _, obj in ipairs(tool:GetDescendants()) do if obj:IsA("SpringConstraint") or obj:IsA("RocketPropulsion") then obj.Enabled = false end end end
        end
        local rapidFireTimer = 0
        local function rapidFireStep()
            if not rapidFire then return end
            local tool = Player.Character and Player.Character:FindFirstChildWhichIsA("Tool")
            if tool and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                if tick() - rapidFireTimer >= rapidFireDelay then
                    pcall(function() tool:Activate() end)
                    rapidFireTimer = tick()
                end
            end
        end
        
        -- Extras
        local lastAfkTime = 0
        local function antiAfkStep()
            if not antiAfk then return end
            if tick() - lastAfkTime < 120 then return end
            lastAfkTime = tick()
            local char = Player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
            end
        end
        local function antiStunStep()
            if not antiStun then return end
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                char.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            end
        end
        local function antiFireStep()
            if not antiFire then return end
            local char = Player.Character
            if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") and part.Material == Enum.Material.Fire then part.Material = Enum.Material.SmoothPlastic end end end
        end
        local function autoRespawnStep()
            if not autoRespawn then return end
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health <= 0 then pcall(function() Player:LoadCharacter() end) end
        end
        local function rainbowWorldStep()
            if rainbowWorld then Lighting.Ambient = Color3.fromHSV((tick()*rainbowSpeed)%1, 0.8, 0.5) else Lighting.Ambient = Color3.new(0,0,0) end
        end
        local function rainbowSkyStep() if rainbowSky then Lighting.SkyColor = Color3.fromHSV((tick()*rainbowSpeed)%1, 0.6, 0.8) end end
        local function rainbowFogStep()
            if rainbowFog then Lighting.FogColor = Color3.fromHSV((tick()*rainbowSpeed)%1, 1, 0.6); Lighting.FogEnd = 100 else Lighting.FogEnd = 0 end
        end
        local function rainbowLightingStep()
            if rainbowLighting then local c = Color3.fromHSV((tick()*rainbowSpeed)%1, 1, 1); Lighting.ColorShift_Top = c; Lighting.ColorShift_Bottom = c end
        end
        local function rainbowCharStep()
            if not rainbowChar then return end
            local char = Player.Character
            if char then
                local c = Color3.fromHSV((tick()*rainbowSpeed)%1, 1, 1)
                for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.Color = c end end
            end
        end
        
        -- Staff Counter
        local staffFrame
        local function updateStaffCounter()
            if not staffFrame then return end
            local count = 0
            for _, p in ipairs(Players:GetPlayers()) do
                for _, kw in ipairs({"staff","admin","mod","helper","owner","dev","gerente","moderador"}) do
                    if p.Name:lower():find(kw) then count=count+1 break end
                end
            end
            staffFrame.Text = "Staff: "..count
        end
        task.delay(1, function()
            local staffGui = Instance.new("ScreenGui", CoreGui); staffGui.Name="StaffCounter"; staffGui.ResetOnSpawn=false
            staffFrame = Instance.new("TextLabel", staffGui)
            staffFrame.Size=UDim2.new(0,80,0,30); staffFrame.Position=UDim2.new(0.8,-40,0.1,0)
            staffFrame.BackgroundColor3=Color3.new(0,0,0); staffFrame.Text="Staff: 0"
            staffFrame.TextColor3=Color3.new(0,1,0); staffFrame.Font=Enum.Font.SourceSansBold; staffFrame.TextSize=14
            Instance.new("UICorner", staffFrame).CornerRadius = UDim.new(0,4)
            updateStaffCounter()
        end)
        
        -- Pulo Infinito
        UserInputService.JumpRequest:Connect(function()
            if infJump then local c=Player.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end
        end)
        
        -- Loop
        local lastLiveCheck = 0
        RunService.RenderStepped:Connect(function()
            pcall(aimbotStep)
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
            pcall(antiAfkStep)
            pcall(antiStunStep)
            pcall(antiFireStep)
            pcall(autoRespawnStep)
            pcall(flyCarStep)
            pcall(rainbowWorldStep)
            pcall(rainbowSkyStep)
            pcall(rainbowFogStep)
            pcall(rainbowLightingStep)
            pcall(rainbowCharStep)
            pcall(updateStaffCounter)
            pcall(bypassCleanup)
            
            if silentAimEnabled and not silentAimConnection then
                pcall(setupSilentAim)
            elseif not silentAimEnabled and silentAimConnection then
                silentAimConnection:Disconnect()
                silentAimConnection = nil
            end
            
            if antiLive and tick()-lastLiveCheck > 1 then
                lastLiveCheck = tick()
                Window.Enabled = not (CoreGui:FindFirstChild("LiveIndicator") ~= nil)
            end
        end)
        
        -- Limpeza
        script.Destroying:Connect(function()
            if flyCarBV then flyCarBV:Destroy() end
            if flyCarBG then flyCarBG:Destroy() end
            if silentAimConnection then silentAimConnection:Disconnect() end
            if fovCircleObj then fovCircleObj:Remove() end
            if crosshairObj then crosshairObj:Remove() end
            for _, box in pairs(boxes2D) do pcall(function() box:Remove() end) end
            for _, data in pairs(skeletons) do for _, d in ipairs(data) do pcall(function() d.line:Remove() end) end end
            for _, tag in pairs(nameTags) do pcall(function() tag:Remove() end) end
            for _, bar in pairs(healthBars) do pcall(function() bar.bg:Remove(); bar.fill:Remove() end) end
            for _, line in pairs(tracerLines) do pcall(function() line:Remove() end) end
            for _, obj in pairs(itemESP) do pcall(function() obj:Remove() end) end
            if staffFrame and staffFrame.Parent then staffFrame.Parent:Destroy() end
            local c = Player.Character
            if c and c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand = false; c.Humanoid.WalkSpeed = 16 end
            Camera.FieldOfView = 70
        end)
    end)
end

mostrarLogin()
