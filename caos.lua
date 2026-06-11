local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Selenium Hub v11 | GOD MODE",
   LoadingTitle = "Carregando bypass...",
   Theme = "Default",
})

-- [[ ADMIN TAB ]]
local AdminTab = Window:CreateTab("Admin Chaos", nil)

AdminTab:CreateButton({
   Name = "Puxar Players (Forçado)",
   Callback = function()
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= game.Players.LocalPlayer and p.Character then
            -- Tenta setar a propriedade de rede para o seu cliente
            p.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
         end
      end
   end,
})

AdminTab:CreateButton({
   Name = "Coletar Todas as Armas",
   Callback = function()
      for _, i in pairs(workspace.Prison_ITEMS.giver:GetChildren()) do
         if i:FindFirstChild("ITEMPICKUP") then
            local p = game.Players.LocalPlayer.Character.HumanoidRootPart
            firetouchinterest(p, i.ITEMPICKUP, 0)
            firetouchinterest(p, i.ITEMPICKUP, 1)
         end
      end
   end,
})

-- [[ FÍSICA E MOVIMENTO (BYPASS) ]]
local PhysicsTab = Window:CreateTab("Física & Caos", nil)

PhysicsTab:CreateToggle({
   Name = "Ghost Walk (Atravessar)",
   Callback = function(state)
      _G.Noclip = state
      game:GetService("RunService").Stepped:Connect(function()
         if _G.Noclip then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = false end
            end
         end
      end)
   end,
})

PhysicsTab:CreateToggle({
   Name = "Speed Física (Bypass)",
   Callback = function(state)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16
   end,
})

-- [[ COMBATE E SEGURANÇA ]]
local CombatTab = Window:CreateTab("Combate", nil)

CombatTab:CreateToggle({
   Name = "Soco One-Shot (Local)",
   Callback = function(state)
      _G.OneShot = state
      game.Players.LocalPlayer:GetMouse().Button1Down:Connect(function()
         if _G.OneShot then
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Damage") then tool.Damage.Value = 9999 end
         end
      end)
   end,
})

CombatTab:CreateButton({
   Name = "Resetar Anti-Cheat (Lag Switch)",
   Callback = function()
      -- Esse botão força o jogo a recalcular sua posição
      game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
      task.wait(0.2)
      game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
   end,
})

Rayfield:LoadConfiguration()
