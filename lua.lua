-- who hacks or modifies this code is a loser!

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "tyt hub",
    Icon = "gamepad-2",
    Author = "danya",
    Folder = "MyCustomHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark"
})

local windowFrame = Window.UIElements and Window.UIElements.Main or Window.Frame

local windowBgColorFrame = Instance.new("Frame")
windowBgColorFrame.Name = "WindowBgColorFrame"
windowBgColorFrame.Size = UDim2.new(1, 0, 1, 0)
windowBgColorFrame.Position = UDim2.new(0, 0, 0, 0)
windowBgColorFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
windowBgColorFrame.BackgroundTransparency = 0.2
windowBgColorFrame.BorderSizePixel = 0
windowBgColorFrame.ZIndex = -1
windowBgColorFrame.Parent = windowFrame

local windowBgCorner = Instance.new("UICorner")
windowBgCorner.CornerRadius = UDim.new(0, 8)
windowBgCorner.Parent = windowBgColorFrame

local customBgImage = Instance.new("ImageLabel")
customBgImage.Name = "CustomBackground"
customBgImage.Size = UDim2.new(1, 0, 1, 0)
customBgImage.Position = UDim2.new(0, 0, 0, 0)
customBgImage.BackgroundTransparency = 1
customBgImage.ScaleType = Enum.ScaleType.Crop
customBgImage.ImageTransparency = 1
customBgImage.ZIndex = 0
customBgImage.Parent = windowFrame

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 8)
bgCorner.Parent = customBgImage

Window:Tag({
    Title = "1 deta",
    Color = Color3.fromRGB(0, 255, 120),
    TextColor = Color3.fromRGB(0, 0, 0)
})

local RENDER_URL = "https://script-1-sq76.onrender.com/send_report"
local SECRET_KEY = "Flor1xSuperSecretKey"

local GamesDatabase = {
    {
        Name = "Murder Mystery 2",
        PlaceId = 142823291,
        Script = "https://raw.githubusercontent.com/thunderXhub/ThunderXHUB/refs/heads/main/loader"
    },
    {
        Name = "San Diego Border Roleplay",
        PlaceId = 136020512003847,
        Script = "https://raw.githubusercontent.com/nikituir-droid/tylevo/refs/heads/main/tylevelo.lua"
    },
    {
        Name = "Build a Roller Coaster",
        PlaceId = 131032338,
        Script = "https://rawscripts.net/raw/Build-a-Roller-Coaster-Build-Roller-Coaster-134793"
    },
    {
        Name = "Skin Upgrader / Case Clicker",
        PlaceId = 131015337227568,
        Script = "https://raw.githubusercontent.com/danyachikish-boop/script2/refs/heads/main/click.lua"
    }
}

local MainTab = Window:Tab({ Title = "Game Search", Icon = "lucide-search" })

local function getAllNames()
    local names = {}
    for _, data in ipairs(GamesDatabase) do
        table.insert(names, data.Name)
    end
    return names
end

local selectedGameName = GamesDatabase[1] and GamesDatabase[1].Name or nil

local GameDropdown = MainTab:Dropdown({
    Title = "Select Game",
    Values = getAllNames(),
    Value = selectedGameName,
    Callback = function(Option)
        selectedGameName = type(Option) == "table" and Option[1] or Option
    end,
})

MainTab:Input({
    Title = "Search by Name",
    Desc = "Type the name or part of it and press Enter",
    Placeholder = "Example: Murder or Border...",
    Callback = function(Text)
        local query = string.lower(Text)
        local filteredNames = {}

        for _, data in ipairs(GamesDatabase) do
            if query == "" or string.find(string.lower(data.Name), query, 1, true) then
                table.insert(filteredNames, data.Name)
            end
        end

        if #filteredNames == 0 then
            filteredNames = { "Nothing found" }
            selectedGameName = nil
        else
            selectedGameName = filteredNames[1]
        end

        pcall(function()
            if GameDropdown.SetValues then
                GameDropdown:SetValues(filteredNames)
            elseif GameDropdown.Refresh then
                GameDropdown:Refresh(filteredNames)
            end
        end)
    end,
})

MainTab:Button({
    Title = "Execute / Teleport",
    Desc = "Load script or teleport to selected game",
    Callback = function()
        if not selectedGameName or selectedGameName == "Nothing found" then
            WindUI:Notify({ Title = "Error", Content = "Please select a valid game first!", Duration = 3, Icon = "alert-circle" })
            return
        end

        local targetData = nil
        for _, data in ipairs(GamesDatabase) do
            if data.Name == selectedGameName then
                targetData = data
                break
            end
        end

        if not targetData then return end

        if game.PlaceId == targetData.PlaceId then
            WindUI:Notify({ Title = "Notification", Content = "Loading script...", Duration = 3, Icon = "play" })
            pcall(function() loadstring(game:HttpGet(targetData.Script))() end)
        else
            WindUI:Notify({ Title = "Teleporting", Content = "Joining " .. targetData.Name .. "...", Duration = 3, Icon = "arrow-right" })

            local queueFunction = queue_on_teleport or (syn and syn.queue_on_teleport) or queueonteleport or (Fluxus and Fluxus.queue_on_teleport)
            if queueFunction then
                pcall(function()
                    queueFunction([[
                        repeat task.wait() until game:IsLoaded()
                        loadstring(game:HttpGet("]] .. targetData.Script .. [["))()
                    ]])
                end)
            end

            local TeleportService = game:GetService("TeleportService")
            local Player = game:GetService("Players").LocalPlayer
            TeleportService:Teleport(targetData.PlaceId, Player)
        end
    end,
})

MainTab:Paragraph({
    Title = "Teleportation Note",
    Desc = "If error 773 occurs during teleportation, join the game manually. The script will auto-execute upon joining."
})

local SupportTab = Window:Tab({ Title = "Support", Icon = "lucide-headphones" })

local userReportText = ""

local ReportInput = SupportTab:Input({
    Title = "Report Bug / Ideas",
    Desc = "Let us know if a script doesn't work or what to add",
    Placeholder = "Your message...",
    Callback = function(Text)
        userReportText = Text
    end,
})

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)

local function sendReportToServer(messageText)
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    if not httpRequest then
        return false, "Your executor does not support HTTP requests."
    end

    local placeName = "Unknown"
    pcall(function()
        placeName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    end)

    local payload = HttpService:JSONEncode({
        secret = SECRET_KEY,
        user_name = player.Name,
        user_id = player.UserId,
        place_name = placeName,
        place_id = game.PlaceId,
        message = messageText
    })

    local success, response = pcall(function()
        return httpRequest({
            Url = RENDER_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = payload
        })
    end)

    if success and response then
        local responseData = {}
        pcall(function()
            responseData = HttpService:JSONDecode(response.Body)
        end)
        
        if response.StatusCode == 200 then
            return true, responseData.message or "Success"
        else
            return false, responseData.message or ("Error " .. tostring(response.StatusCode))
        end
    else
        return false, "Network error: " .. tostring(response)
    end
end

SupportTab:Button({
    Title = "Send Report",
    Desc = "Sends your report to the developer on Discord",
    Callback = function()
        if userReportText == "" or userReportText:match("^%s*$") then
            WindUI:Notify({ Title = "Error", Content = "Please enter some text first!", Duration = 3, Icon = "alert-circle" })
            return
        end

        WindUI:Notify({ Title = "Sending...", Content = "Please wait...", Duration = 2, Icon = "send" })

        local success, resultMessage = sendReportToServer(userReportText)

        if success then
            WindUI:Notify({ Title = "Success!", Content = resultMessage, Duration = 4, Icon = "check" })
            userReportText = ""
            pcall(function()
                if ReportInput.SetText then
                    ReportInput:SetText("")
                elseif ReportInput.Set then
                    ReportInput:Set("")
                end
            end)
        else
            WindUI:Notify({ Title = "Error", Content = resultMessage, Duration = 5, Icon = "x-circle" })
        end
    end,
})

SupportTab:Paragraph({
    Title = "Script Author",
    Desc = "Creator: danya (coder) & Gemini (assistant)\nUI Version: WindUI"
})

-- ==================== TAB 3: SETTINGS ====================
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "lucide-settings" })

local folderName = "tyt hub"
if makefolder and not isfolder(folderName) then
    makefolder(folderName)
end

local watermarkGui = nil
local watermarkConnection = nil

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local function getHiddenUIContainer()
    local success, gui = pcall(function()
        if type(gethui) == "function" then return gethui() end
        return CoreGui
    end)
    if success and gui then return gui end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function toggleWatermark(state)
    if watermarkConnection then
        watermarkConnection:Disconnect()
        watermarkConnection = nil
    end
    if watermarkGui then
        watermarkGui:Destroy()
        watermarkGui = nil
    end

    if not state then return end 

    watermarkGui = Instance.new("ScreenGui")
    watermarkGui.Name = "TytWatermark_Pro"
    watermarkGui.ResetOnSpawn = false
    watermarkGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    watermarkGui.Parent = getHiddenUIContainer()

    local mainFrame = Instance.new("Frame")
    mainFrame.AutomaticSize = Enum.AutomaticSize.X 
    mainFrame.Size = UDim2.new(0, 0, 0, 32)
    mainFrame.Position = UDim2.new(0.5, 0, 0, 12)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = watermarkGui

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", mainFrame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local padding = Instance.new("UIPadding", mainFrame)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)

    local listLayout = Instance.new("UIListLayout", mainFrame)
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function createText(order, text, color)
        local lbl = Instance.new("TextLabel")
        lbl.LayoutOrder = order
        lbl.AutomaticSize = Enum.AutomaticSize.X
        lbl.Size = UDim2.new(0, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextSize = 13
        lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        lbl.RichText = true
        lbl.Text = text
        lbl.Parent = mainFrame
        return lbl
    end

    local function createIcon(order, id, color)
        local icon = Instance.new("ImageLabel")
        icon.LayoutOrder = order
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.BackgroundTransparency = 1
        icon.Image = id
        icon.ImageColor3 = color
        icon.Parent = mainFrame
        return icon
    end

    createText(1, "❖ <b>Tyt</b>")
    createText(2, "|", Color3.fromRGB(120, 120, 140))
    createIcon(3, "rbxassetid://10709782497", Color3.fromRGB(40, 231, 83))
    local fpsLabel = createText(4, "...")
    createText(5, "|", Color3.fromRGB(120, 120, 140))
    createIcon(6, "rbxassetid://10709783010", Color3.fromRGB(255, 204, 0))
    local pingLabel = createText(7, "...")

    local lastUpdate = tick()
    local frameCount = 0

    watermarkConnection = RunService.RenderStepped:Connect(function(deltaTime)
        frameCount = frameCount + 1
        local now = tick()
        
        if now - lastUpdate >= 0.25 then
            local currentFps = math.floor(frameCount / (now - lastUpdate))
            frameCount = 0
            lastUpdate = now
            
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            
            local fpsColor = "#28E753"
            if currentFps < 45 then fpsColor = "#FFCC00" end
            if currentFps < 25 then fpsColor = "#FF3333" end

            fpsLabel.Text = string.format("<font color=\"%s\"><b>%d</b></font> <font color=\"#AAAAAA\">FPS</font>", fpsColor, currentFps)
            
            local pingColor = "#28E753"
            if ping > 100 then pingColor = "#FFCC00" end
            if ping > 200 then pingColor = "#FF3333" end
            
            pingLabel.Text = string.format("<font color=\"%s\"><b>%d</b></font> <font color=\"#AAAAAA\">ms</font>", pingColor, ping)
        end
    end)
end

SettingsTab:Toggle({
    Title = "Show FPS / Ping Panel",
    Desc = "Displays a stylish statistics bar at the top",
    Value = false,
    Callback = function(State)
        toggleWatermark(State)
    end,
})

SettingsTab:Colorpicker({
    Title = "Window Background Color",
    Desc = "Select the background color for the main script window",
    Default = Color3.fromRGB(25, 25, 30),
    Callback = function(Color)
        windowBgColorFrame.BackgroundColor3 = Color
        pcall(function()
            if windowFrame:IsA("Frame") then
                windowFrame.BackgroundColor3 = Color
            end
        end)
    end,
})

SettingsTab:Button({
    Title = "Set Image from Folder",
    Desc = "Loads the first image from workspace/tyt hub",
    Callback = function()
        local getasset = getcustomasset or custom_asset
        local listfiles = listfiles

        if not getasset or not listfiles then
            WindUI:Notify({ Title = "Error", Content = "Executor does not support file loading!", Duration = 4, Icon = "alert-circle" })
            return
        end

        if not isfolder(folderName) then
            makefolder(folderName)
        end

        local files = listfiles(folderName)
        local targetFile = nil

        for _, filePath in ipairs(files) do
            local lowerPath = string.lower(filePath)
            if string.sub(lowerPath, -4) == ".png" or string.sub(lowerPath, -4) == ".jpg" or string.sub(lowerPath, -5) == ".jpeg" then
                targetFile = filePath
                break
            end
        end

        if not targetFile then
            WindUI:Notify({ 
                Title = "Image Not Found", 
                Content = "Place an image (.png/.jpg) in workspace/tyt hub folder", 
                Duration = 4, 
                Icon = "file-warning" 
            })
            return
        end

        local success, err = pcall(function()
            customBgImage.Image = getasset(targetFile)
            customBgImage.ImageTransparency = 0.05
        end)

        if success then
            WindUI:Notify({ Title = "Success!", Content = "Background image set from folder.", Duration = 3, Icon = "check" })
        else
            WindUI:Notify({ Title = "Error", Content = "Failed to load: " .. tostring(err), Duration = 4, Icon = "x-circle" })
        end
    end,
})

SettingsTab:Button({
    Title = "Reset Background",
    Desc = "Remove background image",
    Callback = function()
        customBgImage.ImageTransparency = 1
        customBgImage.Image = ""
        WindUI:Notify({ Title = "Reset", Content = "Background removed.", Duration = 2, Icon = "trash-2" })
    end,
})

SettingsTab:Slider({
    Title = "Background Transparency",
    Desc = "Lower values (towards 0) make the image brighter. Higher values (towards 1) make it more transparent.",
    Min = 0,
    Max = 1,
    Step = 0.05,
    Value = 0.05,
    Callback = function(Value)
        customBgImage.ImageTransparency = Value
    end,
})

pcall(function()
    if MainTab.Select then
        MainTab:Select()
    elseif Window.SelectTab then
        Window:SelectTab(1)
    end
end)
