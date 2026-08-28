local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("LanguageSelector") then
    CoreGui.LanguageSelector:Destroy()
end

-- Создание ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LanguageSelector"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Главная рамка
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = frame

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Select Language / Выберите язык"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

local function createButton(text, pos, color, url)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 50)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 0
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        screenGui:Destroy() -- Закрываем меню после выбора
        loadstring(game:HttpGet(url))()
    end)
end

-- Кнопка Русский
createButton("Русский", UDim2.new(0, 20, 0, 75), Color3.fromRGB(40, 120, 220), "https://raw.githubusercontent.com/danyachikish-boop/script2/refs/heads/main/script.lua")

-- Кнопка English
createButton("English", UDim2.new(0, 160, 0, 75), Color3.fromRGB(60, 60, 60), "https://raw.githubusercontent.com/danyachikish-boop/script2/refs/heads/main/lua.lua")
