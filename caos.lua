-- [[ SELENIUM HUB v10 - RAYFIELD EDITION ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Selenium Hub v10 | Admin Chaos",
   LoadingTitle = "Carregando o Caos...",
   LoadingSubtitle = "by Selenium Dev",
   Theme = "Default",
   DisableRayfieldPrompts = false,
})

local Tab = Window:CreateTab("Admin Tools", nil)

-- Função: Puxar Players
Tab:CreateButton({
   Name = "Puxar Todos os Jogadores",
   Callback = function()
      local LocalPlayer = game.Players.LocalPlayer
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
         end
      end
   end,
})

-- Função: Puxar Carros
Tab:CreateButton({
   Name = "Puxar Todos os Carros",
   Callback = function()
      for _, v in pairs(workspace:GetChildren()) do
         if v.Name == "Prison_Car" or v.Name == "Sedan" then
            v:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
         end
      end
   end,
})

-- Função: Pegar Armas
Tab:CreateButton({
   Name = "Pegar Todas as Armas",
   Callback = function()
      for _, item in pairs(workspace.Prison_ITEMS.giver:GetChildren()) do
         if item:FindFirstChild("ITEMPICKUP") then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item.ITEMPICKUP, 0)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, item.ITEMPICKUP, 1)
         end
      end
   end,
})

Rayfield:LoadConfiguration()
