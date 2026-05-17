-- SWILL CHEAT | ARSENAL EDITION v1.0 (Fixed)
-- Пароль: 1908 | Кастомное меню | Исправленные слайдеры

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- ========== ПАРОЛЬ ==========
local REQUIRED_PASSWORD = "1908"
local isAuthenticated = false

-- ========== НАСТРОЙКИ ==========
local Settings = {
    ESP = { enabled = true, color = Color3.fromRGB(255, 50, 50), teamColor = Color3.fromRGB(50, 255, 50), thickness = 2 },
    Fly = { enabled = false, speed = 100 },
    Aimbot = { enabled = true, fov = 120, smoothness = 0.3, hitChance = 90, aimPart = "Head" },
    BHop = { enabled = true, speed = 16 },
    Visuals = { crosshair = true, crosshairColor = Color3.fromRGB(255, 255, 255), crosshairStyle = "dot" }
}

-- ========== UI БИБЛИОТЕКА ==========
local UI = {
    colors = {
        bg = Color3.fromRGB(18, 20, 25),
        accent = Color3.fromRGB(255, 70, 70),
        card = Color3.fromRGB(28, 30, 38),
        text = Color3.fromRGB(255, 255, 255),
        textDim = Color3.fromRGB(150, 155, 165),
    }
}

-- ========== СОЗДАНИЕ GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SWILL_Arsenal"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Overlay.BackgroundTransparency = 1
Overlay.BorderSizePixel = 0
Overlay.Parent = ScreenGui

-- ========== ОКНО АВТОРИЗАЦИИ ==========
local AuthFrame = Instance.new("Frame")
AuthFrame.Size = UDim2.new(0, 380, 0, 320)
AuthFrame.Position = UDim2.new(0.5, -190, 0.5, -160)
AuthFrame.BackgroundColor3 = UI.colors.bg
AuthFrame.BorderSizePixel = 0
AuthFrame.Parent = ScreenGui

local AuthCorner = Instance.new("UICorner")
AuthCorner.CornerRadius = UDim.new(0, 20)
AuthCorner.Parent = AuthFrame

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 80)
Logo.Position = UDim2.new(0, 0, 0, 20)
Logo.Text = "SWILL"
Logo.TextColor3 = UI.colors.accent
Logo.TextSize = 42
Logo.Font = Enum.Font.GothamBold
Logo.BackgroundTransparency = 1
Logo.Parent = AuthFrame

local PasswordBox = Instance.new("TextBox")
PasswordBox.Size = UDim2.new(0, 280, 0, 50)
PasswordBox.Position = UDim2.new(0.5, -140, 0, 130)
PasswordBox.PlaceholderText = "ВВЕДИТЕ ПАРОЛЬ"
PasswordBox.Text = ""
PasswordBox.TextColor3 = UI.colors.text
PasswordBox.BackgroundColor3 = UI.colors.card
PasswordBox.Parent = AuthFrame

local AuthBtn = Instance.new("TextButton")
AuthBtn.Size = UDim2.new(0, 200, 0, 50)
AuthBtn.Position = UDim2.new(0.5, -100, 0, 200)
AuthBtn.Text = "ПРОВЕРИТЬ"
AuthBtn.BackgroundColor3 = UI.colors.accent
AuthBtn.TextColor3 = UI.colors.text
AuthBtn.Font = Enum.Font.GothamBold
AuthBtn.Parent = AuthFrame

-- ========== ОСНОВНОЕ МЕНЮ ==========
local MainMenu = Instance.new("Frame")
MainMenu.Size = UDim2.new(0, 450, 0, 600)
MainMenu.Position = UDim2.new(0.5, -225, 0.5, -300)
MainMenu.BackgroundColor3 = UI.colors.bg
MainMenu.Visible = false
MainMenu.Parent = ScreenGui

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 20)
MenuCorner.Parent = MainMenu

local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -40, 1, -120)
ContentContainer.Position = UDim2.new(0, 20, 0, 120)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ScrollBarThickness = 4
ContentContainer.Parent = MainMenu

-- ========== ФУНКЦИИ КОНТРОЛЛОВ ==========
local function createCard(parent, yPos, title)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 60)
    card.Position = UDim2.new(0, 0, 0, yPos)
    card.BackgroundColor3 = UI.colors.card
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local cardTitle = Instance.new("TextLabel")
    cardTitle.Size = UDim2.new(0, 150, 1, 0)
    cardTitle.Position = UDim2.new(0, 15, 0, 0)
    cardTitle.Text = title
    cardTitle.TextColor3 = UI.colors.text
    cardTitle.BackgroundTransparency = 1
    cardTitle.Parent = card
    
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
    return card
end

local function createSlider(card, xPos, title, minVal, maxVal, defaultVal, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 180, 0, 40)
    sliderFrame.Position = UDim2.new(0, xPos, 0, 10)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = card
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -55, 0, 0)
    valueLabel.Text = tostring(defaultVal)
    valueLabel.TextColor3 = UI.colors.accent
    valueLabel.BackgroundTransparency = 1
    valueLabel.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -60, 0, 4)
    sliderBar.Position = UDim2.new(0, 0, 0, 25)
    sliderBar.BackgroundColor3 = UI.colors.bg
    sliderBar.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = UI.colors.accent
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    
    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(0, 14, 0, 14)
    sliderBtn.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -7, 0, -5)
    sliderBtn.BackgroundColor3 = UI.colors.accent
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBar
    Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    sliderBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = sliderBar.AbsolutePosition.X
            local barWidth = sliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barWidth, 0, 1)
            local value = math.floor(minVal + percent * (maxVal - minVal))
            
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            sliderBtn.Position = UDim2.new(percent, -7, 0, -5)
            callback(value)
        end
    end)
end

-- ========== НАПОЛНЕНИЕ ВКЛАДОК ==========
local aimCard = createCard(ContentContainer, 0, "AIMBOT")
createSlider(aimCard, 200, "FOV", 30, 360, 120, function(v) Settings.Aimbot.fov = v end)

local bhopCard = createCard(ContentContainer, 70, "BHOP SPEED")
createSlider(bhopCard, 200, "Speed", 10, 50, 16, function(v) Settings.BHop.speed = v end)

-- ========== ЛОГИКА ESP ==========
local espObjects = {}
local function createESP(player)
    if player == LP then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Visible = false
    espObjects[player] = box
end

RunService.RenderStepped:Connect(function()
    if not Settings.ESP.enabled then return end
    for player, box in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                local size = math.clamp(2500 / dist, 10, 150)
                box.Size = Vector2.new(size, size * 1.5)
                box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
                box.Color = (player.Team == LP.Team) and Settings.ESP.teamColor or Settings.ESP.color
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
end)

-- ========== ЛОГИКА BHOP ==========
RunService.RenderStepped:Connect(function()
    if Settings.BHop.enabled and LP.Character and LP.Character:FindFirstChild("Humanoid") then
        local hum = LP.Character.Humanoid
        if hum.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            hum.Jump = true
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = hrp.Velocity + (hrp.CFrame.LookVector * (Settings.BHop.speed / 5))
            end
        end
    end
end)

-- ========== АВТОРИЗАЦИЯ ==========
AuthBtn.MouseButton1Click:Connect(function()
    if PasswordBox.Text == REQUIRED_PASSWORD then
        AuthFrame.Visible = false
        MainMenu.Visible = true
        for _, p in pairs(Players:GetPlayers()) do createESP(p) end
        Players.PlayerAdded:Connect(createESP)
        print("SWILL Fixed activated!")
    else
        PasswordBox.Text = "ОШИБКА"
        task.wait(1)
        PasswordBox.Text = ""
    end
end)
