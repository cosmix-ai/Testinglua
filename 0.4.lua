local http_request = http_request or syn.request or request
local v = "1.5" -- Updated version with glass theme fix

-- Send information to Discord Webhook
if http_request then
    local webhook_url = "https://discord.com/api/webhooks/1381606387087573082/VTFfbEQAvQFT68VWE2NeMR9DhwCo3J4VroZah_mn6oqacFp4goal7wuN8G8OBnq5rdYO"
    local Players = game:GetService("Players")
    local MarketplaceService = game:GetService("MarketplaceService")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer

    local playerName = LocalPlayer and LocalPlayer.Name or "ไม่พบชื่อผู้เล่น"
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")

    local mapName
    do
        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(game.PlaceId)
        end)
        if ok and info and info.Name then
            mapName = info.Name
        else
            local mapFolder = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Maps")
            if mapFolder and mapFolder:IsA("Folder") and #mapFolder:GetChildren() > 0 then
                mapName = mapFolder:GetChildren()[1].Name
            end
        end
    end

    local currentCount = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers

    local inventoryItems = {}
    if LocalPlayer and LocalPlayer:FindFirstChild("Backpack") then
        for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if item.Name then
                table.insert(inventoryItems, item.Name)
            end
        end
    end
    local inventoryList = #inventoryItems > 0 and table.concat(inventoryItems, ", ") or nil

    local fields = {
        { name = "👤 ชื่อผู้เล่น", value = playerName, inline = true },
        { name = "⏰ เวลา", value = currentTime, inline = true },
        { name = "🔄 เวอร์ชัน", value = v, inline = true },
    }
    
    if mapName then
        table.insert(fields, { name = "🗺️ ชื่อแมพ", value = mapName, inline = true })
    end
    table.insert(fields, { name = "👥 ผู้เล่นในเซิร์ฟ", value = tostring(currentCount), inline = true })
    table.insert(fields, { name = "🔢 สูงสุด", value = tostring(maxPlayers), inline = true })
    if inventoryList then
        table.insert(fields, { name = "🎒 ไอเท็ม", value = inventoryList, inline = false })
    end

    local data = {
        content = "📢 **มีการรันสคริปต์**",
        embeds = {{
            title = "ข้อมูลผู้เล่น",
            color = 65280,
            fields = fields
        }}
    }

    http_request({
        Url = webhook_url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
end

print("เวอร์ชัน " .. v)
print("FB: https://www.facebook.com/share/15vVb6Ywmz/")

-- Main config
local keyUrl = "https://pastebin.com/raw/cejh6Mc5"
local showKey = "https://www.facebook.com/share/1Bzv6JwjVh/"
local bgImageId = "rbxassetid://126963373312268"
local openSoundId = "rbxassetid://114779028184284"
local closeSoundId = "rbxassetid://114779028184284"
local autoJumpPeriod = 60

-- GUI settings with glass theme
local guiSettings = {
    mainColor = Color3.fromRGB(25, 25, 35),
    accentColor = Color3.fromRGB(90, 60, 200),
    textColor = Color3.new(1, 1, 1),
    espColor = Color3.fromRGB(0, 255, 0),
    fontSize = 14,
    guiSize = UDim2.new(0, 500, 0, 450),
    minimized = false,
    glassTransparency = 0.7, -- Glass effect transparency
    blurIntensity = 10 -- Blur effect intensity
}

-- Auto chat settings
local autoChatEnabled = false
local autoChatMessage = "cosmic-main.veracal.app"
local autoChatInterval = 30 -- seconds

-- Global blur effect
local blurEffect = nil

-- Create blur effect function
local function createBlurEffect()
    if not blurEffect then
        blurEffect = Instance.new("BlurEffect")
        blurEffect.Size = guiSettings.blurIntensity
        blurEffect.Parent = game.Lighting
        blurEffect.Enabled = false
    end
    return blurEffect
end

-- Ripple effect function
local function createRippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    button.MouseButton1Down:Connect(function(x, y)
        local mouseX, mouseY = x - button.AbsolutePosition.X, y - button.AbsolutePosition.Y
        ripple.Position = UDim2.new(0, mouseX, 0, mouseY)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.BackgroundTransparency = 0.8
        
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween1 = game:GetService("TweenService"):Create(ripple, tweenInfo, {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1
        })
        
        tween1:Play()
        tween1.Completed:Connect(function()
            ripple:Destroy()
        end)
    end)
end

-- Create styled glass button function
local function createStyledButton(parent, text, size, position)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = guiSettings.accentColor
    button.BackgroundTransparency = 0.3 -- Glass effect
    button.TextColor3 = guiSettings.textColor
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(120, 120, 120)
    stroke.Thickness = 2
    stroke.Transparency = 0.5 -- Glass effect
    stroke.Parent = button
    
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            Size = size + UDim2.new(0, 5, 0, 5)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            Size = size
        }):Play()
    end)
    
    createRippleEffect(button)
    
    return button
end

-- Remove old GUI if exists
for _, name in ipairs({"FITREE_KEYUI","FITREE_HUB","FITREE_SPLASH"}) do
    local g = game.CoreGui:FindFirstChild(name)
    if g then g:Destroy() end
end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInput = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local allowedKey = "INVALID"
pcall(function() allowedKey = game:HttpGet(keyUrl) end)

-- Create key input GUI with glass theme
local keyGui = Instance.new("ScreenGui", game.CoreGui)
keyGui.Name = "FITREE_KEYUI"
keyGui.ResetOnSpawn = false
keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Create background blur
local blur = createBlurEffect()
blur.Enabled = true

local kf = Instance.new("Frame", keyGui)
kf.Size = UDim2.new(0, 400, 0, 280)
kf.Position = UDim2.new(0.5, -200, 0.5, -140)
kf.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
kf.BackgroundTransparency = guiSettings.glassTransparency -- Glass effect
kf.BorderSizePixel = 0
kf.Active = true
kf.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = kf

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundTransparency = 1
shadow.ZIndex = -1
shadow.Parent = kf

local bg = Instance.new("ImageLabel", kf)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.Image = "rbxassetid://13807788519" -- Gradient background
bg.ImageColor3 = guiSettings.accentColor
bg.BackgroundTransparency = 1
bg.ImageTransparency = 0.9
bg.ZIndex = -1

local title = Instance.new("TextLabel", kf)
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "FITREE HUB - KEY SYSTEM"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = guiSettings.textColor
title.BackgroundTransparency = 1

local txtKey = Instance.new("TextBox", kf)
txtKey.PlaceholderText = "กรุณากรอก Key ที่นี่..."
txtKey.Size = UDim2.new(1, -40, 0, 50)
txtKey.Position = UDim2.new(0, 20, 0, 70)
txtKey.TextScaled = true
txtKey.Font = Enum.Font.Gotham
txtKey.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
txtKey.BackgroundTransparency = 0.5 -- Glass effect
txtKey.TextColor3 = guiSettings.textColor
txtKey.ClearTextOnFocus = false
txtKey.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)

local txtCorner = Instance.new("UICorner")
txtCorner.CornerRadius = UDim.new(0, 8)
txtCorner.Parent = txtKey

local btnSubmit = createStyledButton(kf, "✅ ยืนยัน Key", UDim2.new(1, -40, 0, 50), UDim2.new(0, 20, 0, 130))
local btnCopy = createStyledButton(kf, "📋 คัดลอกลิงก์เพื่อรับ Key", UDim2.new(1, -40, 0, 40), UDim2.new(0, 20, 0, 190))

btnCopy.MouseButton1Click:Connect(function()
    setclipboard(showKey)
    btnCopy.Text = "✅ คัดลอกแล้ว!"
    task.wait(1.5)
    btnCopy.Text = "📋 คัดลอกลิงก์เพื่อรับ Key"
end)

-- ESP system
local espEnabled = false
local ESP_Objects = {}

local function createESP(plr)
    if plr == player or not plr.Character then return end

    local character = plr.Character
    local humanoid = character:WaitForChild("Humanoid")

    local highlight = Instance.new("Highlight")
    highlight.FillColor = guiSettings.espColor
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 1
    highlight.Parent = character

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_"..plr.Name
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = character

    local head = character:WaitForChild("Head")
    billboard.Adornee = head

    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.Text = plr.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextScaled = true
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold

    local healthLabel = Instance.new("TextLabel", billboard)
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.Text = "HP: "..math.floor(humanoid.Health).."/"..math.floor(humanoid.MaxHealth)
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.TextScaled = true
    healthLabel.BackgroundTransparency = 1
    healthLabel.Font = Enum.Font.Gotham

    local function updateHealth()
        healthLabel.Text = "HP: "..math.floor(humanoid.Health).."/"..math.floor(humanoid.MaxHealth)
    end

    humanoid.HealthChanged:Connect(updateHealth)

    ESP_Objects[plr] = {
        Highlight = highlight,
        Billboard = billboard,
        HealthConnection = humanoid.HealthChanged:Connect(updateHealth)
    }

    plr.CharacterAdded:Connect(function(newChar)
        if espEnabled then
            if ESP_Objects[plr] then
                ESP_Objects[plr].Highlight:Destroy()
                ESP_Objects[plr].Billboard:Destroy()
                ESP_Objects[plr].HealthConnection:Disconnect()
            end
            createESP(plr)
        end
    end)
end

local function removeESP(plr)
    if ESP_Objects[plr] then
        ESP_Objects[plr].Highlight:Destroy()
        ESP_Objects[plr].Billboard:Destroy()
        ESP_Objects[plr].HealthConnection:Disconnect()
        ESP_Objects[plr] = nil
    end
end

local function toggleESP()
    espEnabled = not espEnabled

    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end

        Players.PlayerAdded:Connect(function(newPlayer)
            if espEnabled then
                createESP(newPlayer)
            end
        end)
    else
        for plr, _ in pairs(ESP_Objects) do
            removeESP(plr)
        end
    end
end

-- Create control buttons function with glass theme
local function createControlButtons(parent, gui)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BackgroundTransparency = 0.3 -- Glass effect
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextScaled = true
    closeBtn.Parent = parent
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Text = "-"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    minimizeBtn.BackgroundTransparency = 0.3 -- Glass effect
    minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.TextScaled = true
    minimizeBtn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = closeBtn
    corner:Clone().Parent = minimizeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        local tween = TweenService:Create(parent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            gui:Destroy()
            if blur then
                blur.Enabled = false
            end
        end)
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        guiSettings.minimized = not guiSettings.minimized
        if guiSettings.minimized then
            local tween = TweenService:Create(parent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 150, 0, 50)
            })
            tween:Play()
            minimizeBtn.Text = "+"
        else
            local tween = TweenService:Create(parent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = guiSettings.guiSize
            })
            tween:Play()
            minimizeBtn.Text = "-"
        end
    end)
    
    return closeBtn, minimizeBtn
end

-- Create settings menu function with glass theme
local function createSettingsMenu(content, buttons, mainFrame)
    for _, c in ipairs(content:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextBox") or c:IsA("TextButton") or c:IsA("TextLabel") then
            c:Destroy()
        end
    end
    
    local guiColorLabel = Instance.new("TextLabel", content)
    guiColorLabel.Text = "สีพื้นหลัง GUI:"
    guiColorLabel.Size = UDim2.new(1, -20, 0, 30)
    guiColorLabel.Position = UDim2.new(0, 10, 0, 10)
    guiColorLabel.TextColor3 = guiSettings.textColor
    guiColorLabel.BackgroundTransparency = 1
    guiColorLabel.Font = Enum.Font.Gotham
    guiColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local guiColorBox = Instance.new("TextBox", content)
    guiColorBox.PlaceholderText = "RGB (เช่น 40,40,40)"
    guiColorBox.Text = table.concat({math.floor(guiSettings.mainColor.r*255), math.floor(guiSettings.mainColor.g*255), math.floor(guiSettings.mainColor.b*255)}, ",")
    guiColorBox.Size = UDim2.new(1, -20, 0, 30)
    guiColorBox.Position = UDim2.new(0, 10, 0, 40)
    guiColorBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    guiColorBox.BackgroundTransparency = 0.5 -- Glass effect
    guiColorBox.TextColor3 = guiSettings.textColor
    
    local espColorLabel = Instance.new("TextLabel", content)
    espColorLabel.Text = "สี ESP:"
    espColorLabel.Size = UDim2.new(1, -20, 0, 30)
    espColorLabel.Position = UDim2.new(0, 10, 0, 80)
    espColorLabel.TextColor3 = guiSettings.textColor
    espColorLabel.BackgroundTransparency = 1
    espColorLabel.Font = Enum.Font.Gotham
    espColorLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local espColorBox = Instance.new("TextBox", content)
    espColorBox.PlaceholderText = "RGB (เช่น 0,255,0)"
    espColorBox.Text = table.concat({math.floor(guiSettings.espColor.r*255), math.floor(guiSettings.espColor.g*255), math.floor(guiSettings.espColor.b*255)}, ",")
    espColorBox.Size = UDim2.new(1, -20, 0, 30)
    espColorBox.Position = UDim2.new(0, 10, 0, 110)
    espColorBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    espColorBox.BackgroundTransparency = 0.5 -- Glass effect
    espColorBox.TextColor3 = guiSettings.textColor
    
    local sizeLabel = Instance.new("TextLabel", content)
    sizeLabel.Text = "ขนาด GUI (กว้าง,สูง):"
    sizeLabel.Size = UDim2.new(1, -20, 0, 30)
    sizeLabel.Position = UDim2.new(0, 10, 0, 150)
    sizeLabel.TextColor3 = guiSettings.textColor
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Font = Enum.Font.Gotham
    sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sizeBox = Instance.new("TextBox", content)
    sizeBox.PlaceholderText = "เช่น 450,400"
    sizeBox.Text = table.concat({math.floor(guiSettings.guiSize.X.Offset), math.floor(guiSettings.guiSize.Y.Offset)}, ",")
    sizeBox.Size = UDim2.new(1, -20, 0, 30)
    sizeBox.Position = UDim2.new(0, 10, 0, 180)
    sizeBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sizeBox.BackgroundTransparency = 0.5 -- Glass effect
    sizeBox.TextColor3 = guiSettings.textColor
    
    local jumpLabel = Instance.new("TextLabel", content)
    jumpLabel.Text = "กระโดดอัตโนมัติทุก (วินาที):"
    jumpLabel.Size = UDim2.new(1, -20, 0, 30)
    jumpLabel.Position = UDim2.new(0, 10, 0, 220)
    jumpLabel.TextColor3 = guiSettings.textColor
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Font = Enum.Font.Gotham
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local jumpBox = Instance.new("TextBox", content)
    jumpBox.PlaceholderText = "เช่น 60"
    jumpBox.Text = tostring(autoJumpPeriod)
    jumpBox.Size = UDim2.new(1, -20, 0, 30)
    jumpBox.Position = UDim2.new(0, 10, 0, 250)
    jumpBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    jumpBox.BackgroundTransparency = 0.5 -- Glass effect
    jumpBox.TextColor3 = guiSettings.textColor
    
    local chatLabel = Instance.new("TextLabel", content)
    chatLabel.Text = "ข้อความแชทอัตโนมัติ:"
    chatLabel.Size = UDim2.new(1, -20, 0, 30)
    chatLabel.Position = UDim2.new(0, 10, 0, 290)
    chatLabel.TextColor3 = guiSettings.textColor
    chatLabel.BackgroundTransparency = 1
    chatLabel.Font = Enum.Font.Gotham
    chatLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local chatBox = Instance.new("TextBox", content)
    chatBox.PlaceholderText = "เช่น cosmic-main.veracal.app"
    chatBox.Text = autoChatMessage
    chatBox.Size = UDim2.new(1, -20, 0, 30)
    chatBox.Position = UDim2.new(0, 10, 0, 320)
    chatBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    chatBox.BackgroundTransparency = 0.5 -- Glass effect
    chatBox.TextColor3 = guiSettings.textColor
    
    local intervalLabel = Instance.new("TextLabel", content)
    intervalLabel.Text = "ช่วงเวลาแชทอัตโนมัติ (วินาที):"
    intervalLabel.Size = UDim2.new(1, -20, 0, 30)
    intervalLabel.Position = UDim2.new(0, 10, 0, 360)
    intervalLabel.TextColor3 = guiSettings.textColor
    intervalLabel.BackgroundTransparency = 1
    intervalLabel.Font = Enum.Font.Gotham
    intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local intervalBox = Instance.new("TextBox", content)
    intervalBox.PlaceholderText = "เช่น 30"
    intervalBox.Text = tostring(autoChatInterval)
    intervalBox.Size = UDim2.new(1, -20, 0, 30)
    intervalBox.Position = UDim2.new(0, 10, 0, 390)
    intervalBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    intervalBox.BackgroundTransparency = 0.5 -- Glass effect
    intervalBox.TextColor3 = guiSettings.textColor
    
    local saveBtn = Instance.new("TextButton", content)
    saveBtn.Text = "บันทึกการตั้งค่า"
    saveBtn.Size = UDim2.new(1, -20, 0, 40)
    saveBtn.Position = UDim2.new(0, 10, 0, 430)
    saveBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    saveBtn.BackgroundTransparency = 0.3 -- Glass effect
    saveBtn.TextColor3 = Color3.new(1, 1, 1)
    saveBtn.Font = Enum.Font.GothamBold
    
    saveBtn.MouseButton1Click:Connect(function()
        local guiColorParts = string.split(guiColorBox.Text, ",")
        if #guiColorParts == 3 then
            guiSettings.mainColor = Color3.fromRGB(
                tonumber(guiColorParts[1]) or 40,
                tonumber(guiColorParts[2]) or 40,
                tonumber(guiColorParts[3]) or 40
            )
            mainFrame.BackgroundColor3 = guiSettings.mainColor
        end
        
        local espColorParts = string.split(espColorBox.Text, ",")
        if #espColorParts == 3 then
            guiSettings.espColor = Color3.fromRGB(
                tonumber(espColorParts[1]) or 0,
                tonumber(espColorParts[2]) or 255,
                tonumber(espColorParts[3]) or 0
            )
            for _, espData in pairs(ESP_Objects) do
                if espData.Highlight then
                    espData.Highlight.FillColor = guiSettings.espColor
                end
            end
        end
        
        local sizeParts = string.split(sizeBox.Text, ",")
        if #sizeParts == 2 then
            guiSettings.guiSize = UDim2.new(
                0, tonumber(sizeParts[1]) or 450,
                0, tonumber(sizeParts[2]) or 400
            )
            if not guiSettings.minimized then
                mainFrame.Size = guiSettings.guiSize
            end
        end
        
        autoJumpPeriod = tonumber(jumpBox.Text) or 60
        autoChatMessage = chatBox.Text or "cosmic-main.veracal.app"
        autoChatInterval = tonumber(intervalBox.Text) or 30
        
        saveBtn.Text = "✅ บันทึกแล้ว!"
        task.wait(1.5)
        saveBtn.Text = "บันทึกการตั้งค่า"
    end)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    for _, obj in ipairs(content:GetChildren()) do
        if obj:IsA("TextBox") or obj:IsA("TextButton") then
            corner:Clone().Parent = obj
        end
    end
end

-- Auto chat function
local function toggleAutoChat()
    autoChatEnabled = not autoChatEnabled
    
    if autoChatEnabled then
        spawn(function()
            while autoChatEnabled do
                task.wait(autoChatInterval)
                
                if autoChatEnabled then
                    -- Send chat message
                    local chatService = game:GetService("ReplicatedStorage")
                    if chatService:FindFirstChild("DefaultChatSystemChatEvents") then
                        local sayMessage = chatService.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
                        if sayMessage then
                            sayMessage:FireServer(autoChatMessage, "All")
                        end
                    end
                end
            end
        end)
    end
end

-- Main function to load GUI with glass theme
function loadMainGUI()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "FITREE_HUB"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Enable blur effect
    if blur then
        blur.Enabled = true
    end

    local snd = Instance.new("Sound", gui)
    snd.SoundId = openSoundId
    snd.Volume = 1
    snd:Play()

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 0, 0, 0)
    main.Position = UDim2.new(0.3, 0, 0.15, 0)
    main.BackgroundColor3 = guiSettings.mainColor
    main.BackgroundTransparency = guiSettings.glassTransparency -- Glass effect
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = true

    -- Animate opening
    local openTween = TweenService:Create(main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = guiSettings.guiSize
    })
    openTween:Play()

    createControlButtons(main, gui)

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = main

    local mainShadow = Instance.new("ImageLabel")
    mainShadow.Name = "Shadow"
    mainShadow.Image = "rbxassetid://1316045217"
    mainShadow.ImageColor3 = Color3.new(0, 0, 0)
    mainShadow.ImageTransparency = 0.8
    mainShadow.ScaleType = Enum.ScaleType.Slice
    mainShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    mainShadow.Size = UDim2.new(1, 10, 1, 10)
    mainShadow.Position = UDim2.new(0, -5, 0, -5)
    mainShadow.BackgroundTransparency = 1
    mainShadow.ZIndex = -1
    mainShadow.Parent = main

    local bg = Instance.new("ImageLabel", main)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.Image = "rbxassetid://13807788519" -- Gradient background
    bg.ImageColor3 = guiSettings.accentColor
    bg.BackgroundTransparency = 1
    bg.ImageTransparency = 0.9
    bg.ZIndex = -1

    local lblTitle = Instance.new("TextLabel", main)
    lblTitle.Size = UDim2.new(1, 0, 0, 50)
    lblTitle.Position = UDim2.new(0, 0, 0, 0)
    lblTitle.Text = "FITREE HUB V" .. v
    lblTitle.TextScaled = true
    lblTitle.Font = Enum.Font.GothamBold
    lblTitle.TextColor3 = guiSettings.textColor
    lblTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    lblTitle.BackgroundTransparency = 0.5

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = lblTitle

    local featureScroll = Instance.new("ScrollingFrame", main)
    featureScroll.Size = UDim2.new(0, 150, 0, 380)
    featureScroll.Position = UDim2.new(0, 10, 0, 60)
    featureScroll.BackgroundTransparency = 1
    featureScroll.BorderSizePixel = 0
    featureScroll.ScrollBarThickness = 8
    featureScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    featureScroll.ScrollingDirection = Enum.ScrollingDirection.Y

    local listLayout = Instance.new("UIListLayout", featureScroll)
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local features = {
        {text="กันหลุดออกเกม", name="antiAFK"},
        {text="ตั้งค่าความเร็ว", name="speed"},
        {text="วาร์ปไปหาผู้เล่น", name="teleport"},
        {text="กระโดดไม่จำกัด", name="infjump"},
        {text="ESP Toggle", name="esp"},
        {text="แชทอัตโนมัติ", name="autochat"},
        {text="ตั้งค่า", name="settings"},
    }

    local buttons = {}
    for i, feat in ipairs(features) do
        local b = createStyledButton(featureScroll, feat.text, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, (i-1)*60))
        b.Name = feat.name
        b.LayoutOrder = i
        buttons[feat.name] = b
        
        -- Add animation to buttons when GUI opens
        b.Visible = false
        task.delay(i * 0.05, function()
            b.Visible = true
            local tween = TweenService:Create(b, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, b.Position.Y.Offset)
            })
            tween:Play()
        end)
    end

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        featureScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end)

    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -180, 1, -70)
    content.Position = UDim2.new(0, 170, 0, 60)
    content.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    content.BackgroundTransparency = 0.5

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = content

    local function clearContent()
        for _, c in ipairs(content:GetChildren()) do
            if c:IsA("Frame") or c:IsA("TextBox") or c:IsA("TextButton") or c:IsA("TextLabel") then
                c:Destroy()
            end
        end
    end

    buttons.esp.MouseButton1Click:Connect(function()
        toggleESP()
        buttons.esp.Text = espEnabled and "ESP (เปิด)" or "ESP (ปิด)"
        buttons.esp.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor
    end)

    local afkConn, isAFK, autoJumpConn = nil, false, nil
    buttons.antiAFK.MouseButton1Click:Connect(function()
        isAFK = not isAFK
        if isAFK then
            if not afkConn then
                afkConn = player.Idled:Connect(function()
                    VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                    task.wait(1)
                    VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
                end)
            end
            
            autoJumpConn = spawn(function()
                while isAFK and gui.Parent do
                    task.wait(autoJumpPeriod)
                    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if afkConn then
                afkConn:Disconnect()
                afkConn = nil
            end
            
            if autoJumpConn then
                coroutine.close(autoJumpConn)
                autoJumpConn = nil
            end
        end
        
        buttons.antiAFK.Text = isAFK and "กันหลุด (เปิด)" or "กันหลุด (ปิด)"
        buttons.antiAFK.BackgroundColor3 = isAFK and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor
    end)

    buttons.speed.MouseButton1Click:Connect(function()
        clearContent()
        
        local box = Instance.new("TextBox", content)
        box.PlaceholderText = "ใส่ WalkSpeed"
        box.Size = UDim2.new(1, -20, 0, 50)
        box.Position = UDim2.new(0, 10, 0, 10)
        box.TextScaled = true
        box.Font = Enum.Font.Gotham
        box.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        box.BackgroundTransparency = 0.5 -- Glass effect
        box.TextColor3 = guiSettings.textColor
        box.ClearTextOnFocus = false
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 8)
        boxCorner.Parent = box

        local setBtn = createStyledButton(content, "ตั้งค่า", UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 70))

        setBtn.MouseButton1Click:Connect(function()
            local v = tonumber(box.Text)
            if v and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = v
                setBtn.Text = "✅ ตั้งค่าแล้ว!"
                setBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                task.wait(1.5)
                setBtn.Text = "ตั้งค่า"
                setBtn.BackgroundColor3 = guiSettings.accentColor
            end
        end)
    end)

    local inf = false
    buttons.infjump.MouseButton1Click:Connect(function()
        inf = not inf
        clearContent()
        buttons.infjump.Text = inf and "กระโดดไม่จำกัด (เปิด)" or "กระโดดไม่จำกัด (ปิด)"
        buttons.infjump.BackgroundColor3 = inf and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor
    end)
    UserInput.JumpRequest:Connect(function()
        if inf and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    buttons.autochat.MouseButton1Click:Connect(function()
        toggleAutoChat()
        buttons.autochat.Text = autoChatEnabled and "แชทอัตโนมัติ (เปิด)" or "แชทอัตโนมัติ (ปิด)"
        buttons.autochat.BackgroundColor3 = autoChatEnabled and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor
    end)

    buttons.teleport.MouseButton1Click:Connect(function()
        clearContent()
        local playerScroll = Instance.new("ScrollingFrame", content)
        playerScroll.Size = UDim2.new(1, -10, 1, -10)
        playerScroll.Position = UDim2.new(0, 5, 0, 5)
        playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        playerScroll.ScrollBarThickness = 8
        playerScroll.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        playerScroll.BackgroundTransparency = 0.5

        local playerCorner = Instance.new("UICorner")
        playerCorner.CornerRadius = UDim.new(0, 8)
        playerCorner.Parent = playerScroll

        local playerLayout = Instance.new("UIListLayout", playerScroll)
        playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        playerLayout.Padding = UDim.new(0, 5)

        local function updatePlayerList()
            for _, c in ipairs(playerScroll:GetChildren()) do
                if c:IsA("TextButton") then
                    c:Destroy()
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    local b = createStyledButton(playerScroll, p.Name, UDim2.new(1, -10, 0, 40), UDim2.new(0, 5, 0, 0))
                    b.MouseButton1Click:Connect(function()
                        if player.Character and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
                            b.Text = "✅ วาร์ปแล้ว!"
                            b.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
                            task.wait(1.5)
                            b.Text = p.Name
                            b.BackgroundColor3 = guiSettings.accentColor
                        end
                    end)
                end
            end
            task.wait()
            playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerLayout.AbsoluteContentSize.Y + 10)
        end

        updatePlayerList()
        Players.PlayerAdded:Connect(updatePlayerList)
        Players.PlayerRemoving:Connect(updatePlayerList)
    end)

    buttons.settings.MouseButton1Click:Connect(function()
        createSettingsMenu(content, buttons, main)
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if ESP_Objects[plr] then
            removeESP(plr)
        end
    end)

    local toggle = Instance.new("ImageButton", gui)
    toggle.Size = UDim2.new(0, 50, 0, 50)
    toggle.Position = UDim2.new(0, 10, 0.5, -25)
    toggle.Image = "rbxassetid://135208260493361"
    toggle.BackgroundColor3 = guiSettings.mainColor
    toggle.BackgroundTransparency = 0.5
    toggle.Active = true
    toggle.Draggable = true
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = guiSettings.accentColor
    toggleStroke.Thickness = 2
    toggleStroke.Parent = toggle
    
    toggle.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 55, 0, 55)
        }):Play()
    end)
    
    toggle.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.5,
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
    end)
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        toggle.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    end
    
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = toggle.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    toggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    toggle.MouseButton1Click:Connect(function()
        if main.Visible then
            local closeTween = TweenService:Create(main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                main.Visible = false
                if blur then
                    blur.Enabled = false
                end
            end)
            
            local snd = Instance.new("Sound", gui)
            snd.SoundId = closeSoundId
            snd.Volume = 1
            snd:Play()
        else
            main.Visible = true
            local openTween = TweenService:Create(main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = guiSettings.guiSize,
                Position = UDim2.new(0.3, 0, 0.15, 0)
            })
            openTween:Play()
            
            if blur then
                blur.Enabled = true
            end
            
            local snd = Instance.new("Sound", gui)
            snd.SoundId = openSoundId
            snd.Volume = 1
            snd:Play()
        end
        
        game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.2), {
            Rotation = main.Visible and 180 or 0
        }):Play()
    end)
end

-- When submit key is clicked
btnSubmit.MouseButton1Click:Connect(function()
    if txtKey.Text == allowedKey then
        local tween = TweenService:Create(kf, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -200, -1, 0)
        })
        tween:Play()
        tween.Completed:Wait()
        keyGui:Destroy()
        loadMainGUI()
    else
        local shake = TweenService:Create(kf, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 5, true), {
            Position = UDim2.new(0.5, -200 + math.random(-10,10), 0.5, -140 + math.random(-5,5))
        })
        title.Text = "❌ Key ไม่ถูกต้อง"
        title.TextColor3 = Color3.fromRGB(255,50,50)
        shake:Play()
    end
end)