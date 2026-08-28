local VirtualInputManager = game:GetService("VirtualInputManager")

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local IsAutoClicking = false
local ClickDelay = 0.1 -- Задержка по умолчанию

local StartPoint = {x = 1394, y = 32}
local TargetPoint = {x = 538, y = 377}

local Window = Rayfield:CreateWindow({
   Name = "Auto Gold Fix",
   LoadingTitle = "Загрузка...",
   LoadingSubtitle = "by Flor1x",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Главная", 4483362458)

local function sendHumanClick(x, y)
   local finalX = x + math.random(-3, 3)
   local finalY = y + math.random(-3, 3)

   VirtualInputManager:SendMouseButtonEvent(finalX, finalY, 0, true, game, 0)
   
   task.wait(0.01)
   
   VirtualInputManager:SendMouseButtonEvent(finalX, finalY, 0, false, game, 0)
end

MainTab:CreateToggle({
   Name = "Авто голда",
   CurrentValue = false,
   Flag = "AutoGoldToggle",
   Callback = function(Value)
      IsAutoClicking = Value
      
      if IsAutoClicking then
         task.spawn(function()
            sendHumanClick(StartPoint.x, StartPoint.y)
            
            task.wait(math.max(0.05, ClickDelay))

            while IsAutoClicking do
               sendHumanClick(TargetPoint.x, TargetPoint.y)
               
               local randomOffset = (math.random(-10, 10) / 1000)
               local actualDelay = math.max(0.02, ClickDelay + randomOffset)
               
               task.wait(actualDelay)
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Задержка клика (сек)",
   Range = {0.01, 10},
   Increment = 0.01,
   CurrentValue = 0.1,
   Flag = "DelaySlider",
   Callback = function(Value)
      ClickDelay = Value
   end,
})
