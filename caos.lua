--// Souza Mods UI
--// Somente interface. Coloque suas funções nos callbacks.
--// Use apenas em experiências/jogos onde você tem permissão.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local UI_NAME = "SouzaModsUI"

pcall(function()
	if CoreGui:FindFirstChild(UI_NAME) then
		CoreGui[UI_NAME]:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local function Corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = obj
	return c
end

local function Stroke(obj, color, size, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(0, 170, 255)
	s.Thickness = size or 1
	s.Transparency = transparency or 0.2
	s.Parent = obj
	return s
end

local function Tween(obj, time, data)
	TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), data):Play()
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(640, 410)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
Main.BackgroundTransparency = 0.04
Main.Parent = ScreenGui

Corner(Main, 18)
Stroke(Main, Color3.fromRGB(0, 200, 255), 1.4, 0.15)

local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 60, 1, 60)
Shadow.Position = UDim2.fromOffset(-30, -30)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 180, 255)
Shadow.ImageTransparency = 0.45
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.ZIndex = -1
Shadow.Parent = Main

local Top = Instance.new("Frame")
Top.Name = "Top"
Top.Size = UDim2.new(1, 0, 0, 58)
Top.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Top.Parent = Main

Corner(Top, 18)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -130, 1, 0)
Title.Position = UDim2.fromOffset(22, 0)
Title.BackgroundTransparency = 1
Title.Text = "SOUZA MODS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 23
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.fromOffset(260, 20)
SubTitle.Position = UDim2.fromOffset(24, 36)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "premium interface"
SubTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Top

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Size = UDim2.fromOffset(35, 30)
Close.Position = UDim2.new(1, -48, 0, 14)
Close.BackgroundColor3 = Color3.fromRGB(255, 50, 75)
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 14
Close.Font = Enum.Font.GothamBlack
Close.Parent = Top

Corner(Close, 9)

local Minimize = Instance.new("TextButton")
Minimize.Name = "Minimize"
Minimize.Size = UDim2.fromOffset(35, 30)
Minimize.Position = UDim2.new(1, -88, 0, 14)
Minimize.BackgroundColor3 = Color3.fromRGB(255, 190, 40)
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(20, 20, 20)
Minimize.TextSize = 20
Minimize.Font = Enum.Font.GothamBlack
Minimize.Parent = Top

Corner(Minimize, 9)

local NeonLine = Instance.new("Frame")
NeonLine.Name = "NeonLine"
NeonLine.Size = UDim2.new(1, -40, 0, 2)
NeonLine.Position = UDim2.fromOffset(20, 58)
NeonLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
NeonLine.BorderSizePixel = 0
NeonLine.Parent = Main

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -82)
Sidebar.Position = UDim2.fromOffset(18, 74)
Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
Sidebar.Parent = Main

Corner(Sidebar, 14)
Stroke(Sidebar, Color3.fromRGB(0, 180, 255), 1, 0.55)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 9)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = Sidebar

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 12)
SidePadding.PaddingLeft = UDim.new(0, 10)
SidePadding.PaddingRight = UDim.new(0, 10)
SidePadding.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -205, 1, -82)
Content.Position = UDim2.fromOffset(190, 74)
Content.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
Content.Parent = Main

Corner(Content, 14)
Stroke(Content, Color3.fromRGB(0, 180, 255), 1, 0.55)

local Pages = {}
local CurrentPage = nil

local Library = {}

function Library:CreateTab(name)
	local Button = Instance.new("TextButton")
	Button.Name = name .. "_Tab"
	Button.Size = UDim2.new(1, 0, 0, 40)
	Button.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
	Button.Text = name
	Button.TextColor3 = Color3.fromRGB(210, 210, 220)
	Button.TextSize = 13
	Button.Font = Enum.Font.GothamBold
	Button.AutoButtonColor = false
	Button.Parent = Sidebar

	Corner(Button, 10)

	local Page = Instance.new("ScrollingFrame")
	Page.Name = name .. "_Page"
	Page.Size = UDim2.new(1, -20, 1, -20)
	Page.Position = UDim2.fromOffset(10, 10)
	Page.BackgroundTransparency = 1
	Page.ScrollBarThickness = 3
	Page.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
	Page.CanvasSize = UDim2.new(0, 0, 0, 0)
	Page.Visible = false
	Page.Parent = Content

	local Layout = Instance.new("UIListLayout")
	Layout.Padding = UDim.new(0, 10)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder
	Layout.Parent = Page

	Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 15)
	end)

	local Tab = {}

	function Tab:Show()
		for _, data in pairs(Pages) do
			data.Page.Visible = false
			Tween(data.Button, 0.2, {
				BackgroundColor3 = Color3.fromRGB(20, 20, 32),
				TextColor3 = Color3.fromRGB(210, 210, 220)
			})
		end

		Page.Visible = true
		CurrentPage = Page

		Tween(Button, 0.2, {
			BackgroundColor3 = Color3.fromRGB(0, 170, 255),
			TextColor3 = Color3.fromRGB(255, 255, 255)
		})
	end

	Button.MouseButton1Click:Connect(function()
		Tab:Show()
	end)

	Button.MouseEnter:Connect(function()
		if CurrentPage ~= Page then
			Tween(Button, 0.15, {
				BackgroundColor3 = Color3.fromRGB(28, 28, 44)
			})
		end
	end)

	Button.MouseLeave:Connect(function()
		if CurrentPage ~= Page then
			Tween(Button, 0.15, {
				BackgroundColor3 = Color3.fromRGB(20, 20, 32)
			})
		end
	end)

	function Tab:AddButton(text, callback)
		local Btn = Instance.new("TextButton")
		Btn.Name = text
		Btn.Size = UDim2.new(1, 0, 0, 43)
		Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
		Btn.Text = text
		Btn.TextColor3 = Color3.fromRGB(240, 240, 245)
		Btn.TextSize = 13
		Btn.Font = Enum.Font.GothamBold
		Btn.AutoButtonColor = false
		Btn.Parent = Page

		Corner(Btn, 10)
		Stroke(Btn, Color3.fromRGB(0, 180, 255), 1, 0.75)

		Btn.MouseEnter:Connect(function()
			Tween(Btn, 0.16, {
				BackgroundColor3 = Color3.fromRGB(0, 145, 220)
			})
		end)

		Btn.MouseLeave:Connect(function()
			Tween(Btn, 0.16, {
				BackgroundColor3 = Color3.fromRGB(20, 20, 32)
			})
		end)

		Btn.MouseButton1Click:Connect(function()
			Tween(Btn, 0.08, {Size = UDim2.new(1, -8, 0, 39)})
			task.wait(0.08)
			Tween(Btn, 0.12, {Size = UDim2.new(1, 0, 0, 43)})

			if callback then
				callback()
			end
		end)
	end

	function Tab:AddToggle(text, default, callback)
		local Enabled = default or false

		local Holder = Instance.new("Frame")
		Holder.Name = text
		Holder.Size = UDim2.new(1, 0, 0, 48)
		Holder.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
		Holder.Parent = Page

		Corner(Holder, 10)
		Stroke(Holder, Color3.fromRGB(0, 180, 255), 1, 0.75)

		local Label = Instance.new("TextLabel")
		Label.Size = UDim2.new(1, -75, 1, 0)
		Label.Position = UDim2.fromOffset(14, 0)
		Label.BackgroundTransparency = 1
		Label.Text = text
		Label.TextColor3 = Color3.fromRGB(240, 240, 245)
		Label.TextSize = 13
		Label.Font = Enum.Font.GothamBold
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Parent = Holder

		local Switch = Instance.new("TextButton")
		Switch.Size = UDim2.fromOffset(50, 25)
		Switch.Position = UDim2.new(1, -63, 0.5, -12)
		Switch.BackgroundColor3 = Enabled and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(55, 55, 70)
		Switch.Text = ""
		Switch.AutoButtonColor = false
		Switch.Parent = Holder

		Corner(Switch, 99)

		local Dot = Instance.new("Frame")
		Dot.Size = UDim2.fromOffset(19, 19)
		Dot.Position = Enabled and UDim2.fromOffset(27, 3) or UDim2.fromOffset(4, 3)
		Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Dot.Parent = Switch

		Corner(Dot, 99)

		local function Set(value)
			Enabled = value

			Tween(Switch, 0.18, {
				BackgroundColor3 = Enabled and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(55, 55, 70)
			})

			Tween(Dot, 0.18, {
				Position = Enabled and UDim2.fromOffset(27, 3) or UDim2.fromOffset(4, 3)
			})

			if callback then
				callback(Enabled)
			end
		end

		Switch.MouseButton1Click:Connect(function()
			Set(not Enabled)
		end)

		Holder.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Set(not Enabled)
			end
		end)

		if callback then
			callback(Enabled)
		end
	end

	function Tab:AddSlider(text, min, max, default, callback)
		local Value = default or min
		local Dragging = false

		local Holder = Instance.new("Frame")
		Holder.Name = text
		Holder.Size = UDim2.new(1, 0, 0, 65)
		Holder.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
		Holder.Parent = Page

		Corner(Holder, 10)
		Stroke(Holder, Color3.fromRGB(0, 180, 255), 1, 0.75)

		local Label = Instance.new("TextLabel")
		Label.Size = UDim2.new(1, -20, 0, 28)
		Label.Position = UDim2.fromOffset(14, 3)
		Label.BackgroundTransparency = 1
		Label.Text = text .. ": " .. tostring(Value)
		Label.TextColor3 = Color3.fromRGB(240, 240, 245)
		Label.TextSize = 13
		Label.Font = Enum.Font.GothamBold
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Parent = Holder

		local Bar = Instance.new("Frame")
		Bar.Size = UDim2.new(1, -28, 0, 8)
		Bar.Position = UDim2.fromOffset(14, 44)
		Bar.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
		Bar.Parent = Holder

		Corner(Bar, 99)

		local Fill = Instance.new("Frame")
		Fill.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
		Fill.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
		Fill.Parent = Bar

		Corner(Fill, 99)

		local Ball = Instance.new("Frame")
		Ball.Size = UDim2.fromOffset(18, 18)
		Ball.Position = UDim2.new((Value - min) / (max - min), -9, 0.5, -9)
		Ball.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Ball.Parent = Bar

		Corner(Ball, 99)

		local function Update(inputX)
			local percent = math.clamp((inputX - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
			Value = math.floor(min + (max - min) * percent)

			Label.Text = text .. ": " .. tostring(Value)

			Fill.Size = UDim2.new(percent, 0, 1, 0)
			Ball.Position = UDim2.new(percent, -9, 0.5, -9)

			if callback then
				callback(Value)
			end
		end

		Bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = true
				Update(input.Position.X)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				Dragging = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				Update(input.Position.X)
			end
		end)

		if callback then
			callback(Value)
		end
	end

	function Tab:AddLabel(text)
		local Label = Instance.new("TextLabel")
		Label.Name = text
		Label.Size = UDim2.new(1, 0, 0, 32)
		Label.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
		Label.Text = text
		Label.TextColor3 = Color3.fromRGB(0, 200, 255)
		Label.TextSize = 13
		Label.Font = Enum.Font.GothamBlack
		Label.Parent = Page

		Corner(Label, 10)
		Stroke(Label, Color3.fromRGB(0, 180, 255), 1, 0.8)
	end

	Pages[name] = {
		Button = Button,
		Page = Page
	}

	if not CurrentPage then
		Tab:Show()
	end

	return Tab
end

--// Arrastar janela
local Dragging = false
local DragStart
local StartPosition

Top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Dragging = true
		DragStart = input.Position
		StartPosition = Main.Position
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local Delta = input.Position - DragStart

		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end
end)

--// Fechar e minimizar
Close.MouseButton1Click:Connect(function()
	Tween(Main, 0.25, {
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1
	})

	task.wait(0.25)
	ScreenGui:Destroy()
end)

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized

	if Minimized then
		Tween(Main, 0.25, {
			Size = UDim2.fromOffset(640, 58)
		})

		Sidebar.Visible = false
		Content.Visible = false
	else
		Tween(Main, 0.25, {
			Size = UDim2.fromOffset(640, 410)
		})

		task.wait(0.12)
		Sidebar.Visible = true
		Content.Visible = true
	end
end)

--// Animação de entrada
Main.Size = UDim2.fromOffset(0, 0)
Tween(Main, 0.45, {
	Size = UDim2.fromOffset(640, 410)
})

--// Efeito neon vivo
task.spawn(function()
	while ScreenGui.Parent do
		local t = tick()

		local r = math.floor(0 + math.sin(t * 2) * 15)
		local g = math.floor(170 + math.sin(t * 2.4) * 45)
		local b = 255

		local color = Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 120, 255), b)

		NeonLine.BackgroundColor3 = color
		Shadow.ImageColor3 = color

		task.wait(0.03)
	end
end)

-- ==================== CONFIGURAÇÕES DAS FUNÇÕES ====================
-- Variáveis globais
local aimbotEnabled = false
local aimStrength = 5          -- 1-5
local bypassLevel = 10         -- 1-10
local espBoxEnabled = false
local espSkeletonEnabled = false
local fovCircleEnabled = false
local fovRainbowEnabled = false
local fovRadius = 180
local wallshotEnabled = false  -- Novo: WallShot

-- Desenhos
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Radius = fovRadius
fovCircle.Color = Color3.fromRGB(255,255,255)
fovCircle.Filled = false
fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2

local boxes = {}
local skeletons = {}

-- Serviços
local Camera = workspace.CurrentCamera

-- ==================== FUNÇÕES DOS SISTEMAS ====================

-- Aimbot
local function getEnemiesInFOV()
	local center = Camera.ViewportSize / 2
	local enemies = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player == Player then continue end
		local char = player.Character
		if not char or not char:FindFirstChild("Head") then continue end
		local hum = char:FindFirstChild("Humanoid")
		if not hum or hum.Health <= 0 then continue end
		local headPos, onScreen = Camera:WorldToViewportPoint(char.Head.Position)
		if not onScreen then continue end
		local screenPos = Vector2.new(headPos.X, headPos.Y)
		local dist = (center - screenPos).Magnitude
		if dist <= fovRadius then
			table.insert(enemies, {player = player, distance = dist})
		end
	end
	table.sort(enemies, function(a,b) return a.distance < b.distance end)
	return enemies
end

local function aimbotStep()
	if not aimbotEnabled then return end
	local enemies = getEnemiesInFOV()
	if #enemies == 0 then return end
	local target = enemies[1]
	local head = target.player.Character and target.player.Character:FindFirstChild("Head")
	if not head then return end
	
	-- Bypass lógica: nível 10 = lock total, outros níveis podem ter suavização
	if bypassLevel >= 10 then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
	else
		-- Aplica suavização baseada na força e bypass
		local smoothFactor = math.clamp(1 - (aimStrength * 0.2), 0.05, 1)  -- força 5 -> smoothFactor = 0, mas como bypass <10, mantemos um mínimo de suavidade
		local targetCF = CFrame.new(Camera.CFrame.Position, head.Position)
		Camera.CFrame = Camera.CFrame:Lerp(targetCF, 1 - smoothFactor + (bypassLevel * 0.02))
	end
end

-- ESP Box
local function getCharacterBounds(char)
	local head = char:FindFirstChild("Head")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not head or not root then return nil end
	local topWorld = head.Position + Vector3.new(0, 1.5, 0)
	local bottomWorld = root.Position - Vector3.new(0, 3, 0)
	local topScreen, topVis = Camera:WorldToViewportPoint(topWorld)
	local bottomScreen, bottomVis = Camera:WorldToViewportPoint(bottomWorld)
	if not topVis or not bottomVis then return nil end
	local height = math.abs(topScreen.Y - bottomScreen.Y)
	local width = height * 0.45
	local centerX = (topScreen.X + bottomScreen.X) / 2
	return {
		Position = Vector2.new(centerX - width/2, topScreen.Y),
		Size = Vector2.new(width, height)
	}
end

local function updateESPBox(char, player)
	if not espBoxEnabled then
		if boxes[player] then boxes[player]:Remove(); boxes[player] = nil end
		return
	end
	local bounds = getCharacterBounds(char)
	if not bounds then
		if boxes[player] then boxes[player].Visible = false end
		return
	end
	if not boxes[player] then
		local box = Drawing.new("Square")
		box.Thickness = 2
		box.Color = Color3.fromRGB(255, 0, 0)
		box.Filled = false
		boxes[player] = box
	end
	boxes[player].Position = bounds.Position
	boxes[player].Size = bounds.Size
	boxes[player].Visible = true
end

-- ESP Esqueleto
local function buildSkeletonLines(char)
	local connections = {}
	for _, obj in ipairs(char:GetDescendants()) do
		if obj:IsA("Motor6D") or obj:IsA("Bone") then
			local p0, p1 = obj.Part0, obj.Part1
			if p0 and p1 and p0:IsA("BasePart") and p1:IsA("BasePart") then
				local pair = {p0, p1}
				table.sort(pair, function(a,b) return a.Name < b.Name end)
				local key = pair[1].Name .. "_" .. pair[2].Name
				if not connections[key] then connections[key] = pair end
			end
		end
	end
	local lines = {}
	for _, parts in pairs(connections) do table.insert(lines, parts) end
	return lines
end

local function updateESPSkeleton(char, player)
	if not espSkeletonEnabled then
		if skeletons[player] then
			for _, d in ipairs(skeletons[player]) do d.line:Remove() end
			skeletons[player] = nil
		end
		return
	end
	if not skeletons[player] then
		skeletons[player] = {}
		local connections = buildSkeletonLines(char)
		for i, parts in ipairs(connections) do
			local line = Drawing.new("Line")
			line.Thickness = 1
			line.Color = Color3.fromRGB(255, 255, 255)
			skeletons[player][i] = {line = line, partA = parts[1], partB = parts[2]}
		end
	end
	for _, data in ipairs(skeletons[player]) do
		local line, a, b = data.line, data.partA, data.partB
		if a.Parent and b.Parent then
			local aPos, aVis = Camera:WorldToViewportPoint(a.Position)
			local bPos, bVis = Camera:WorldToViewportPoint(b.Position)
			if aVis and bVis then
				line.From = Vector2.ne
