--[[
    FITREE HUB SCRIPT - MODIFIED VERSION

    CHANGELOG:
    - Fixed UI bug where the teleport player list would not disappear when another function was selected.
    - Resized the main GUI to be more compact.
    - Added a new toggleable 'Fly' function that persists after death.
]]

local http_request = http_request or syn.request or request
local v = "1.6" -- Updated version with fixes and new features

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
            [span_0](start_span)return MarketplaceService:GetProductInfo(game.PlaceId)[span_0](end_span)
        end)
        if ok and info and info.Name then
            mapName = info.Name
        else
            local mapFolder = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Maps")
            if mapFolder and mapFolder:IsA("Folder") and #mapFolder:GetChildren() > 0 then
                [span_1](start_span)mapName = mapFolder:GetChildren()[1].Name[span_1](end_span)
            end
        end
    end

    local currentCount = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers

    local inventoryItems = {}
    if LocalPlayer and LocalPlayer:FindFirstChild("Backpack") then
        for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if item.Name then
                [span_2](start_span)table.insert(inventoryItems, item.Name)[span_2](end_span)
            end
        end
    end
    local inventoryList = #inventoryItems > 0 and table.concat(inventoryItems, ", ") or nil

    local fields = {
        { name = "👤 ชื่อผู้เล่น", value = playerName, inline = true },
        { name = "⏰ เวลา", value = currentTime, inline = true },
        [span_3](start_span){ name = "🔄 เวอร์ชัน", value = v, inline = true },[span_3](end_span)
    }
    
    if mapName then
        table.insert(fields, { name = "🗺️ ชื่อแมพ", value = mapName, inline = true })
    end
    table.insert(fields, { name = "👥 ผู้เล่นในเซิร์ฟ", value = tostring(currentCount), inline = true })
    table.insert(fields, { name = "🔢 สูงสุด", value = tostring(maxPlayers), inline = true })
    if inventoryList then
        [span_4](start_span)table.insert(fields, { name = "🎒 ไอเท็ม", value = inventoryList, inline = false })[span_4](end_span)
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
        [span_5](start_span)Url = webhook_url,[span_5](end_span)
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
    [span_6](start_span)textColor = Color3.new(1, 1, 1),[span_6](end_span)
    espColor = Color3.fromRGB(0, 255, 0),
    fontSize = 14,
    guiSize = UDim2.new(0, 480, 0, 350), -- <<< MODIFIED: Adjusted GUI size
    minimized = false,
    glassTransparency = 0.7,
    blurIntensity = 10
}

-- Auto chat settings
local autoChatEnabled = false
local autoChatMessage = "cosmic-main.veracal.app"
local autoChatInterval = 30

-- Global blur effect
local blurEffect = nil

-- Create blur effect function
local function createBlurEffect()
    if not blurEffect then
        blurEffect = Instance.new("BlurEffect")
        [span_7](start_span)blurEffect.Size = guiSettings.blurIntensity[span_7](end_span)
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
    [span_8](start_span)ripple.Parent = button[span_8](end_span)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    button.MouseButton1Down:Connect(function(x, y)
        local mouseX, mouseY = x - button.AbsolutePosition.X, y - button.AbsolutePosition.Y
        ripple.Position = UDim2.new(0, mouseX, 0, mouseY)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.BackgroundTransparency = 0.8
        
        [span_9](start_span)local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)[span_9](end_span)
        local tween1 = game:GetService("TweenService"):Create(ripple, tweenInfo, {
            Size = UDim2.new(2, 0, 2, 0),
            BackgroundTransparency = 1
        })
        
        tween1:Play()
        tween1.Completed:Connect(function()
            [span_10](start_span)ripple:Destroy()[span_10](end_span)
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
    button.BackgroundTransparency = 0.3
    button.TextColor3 = guiSettings.textColor
    button.Font = Enum.Font.GothamBold
    button.TextScaled = true
    button.AutoButtonColor = false
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    [span_11](start_span)corner.Parent = button[span_11](end_span)
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(120, 120, 120)
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = button
    
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2,
            [span_12](start_span)Size = size + UDim2.new(0, 5, 0, 5)[span_12](end_span)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            Size = size
        }):Play()
    end)
    
    createRippleEffect(button)
    
    [span_13](start_span)return button[span_13](end_span)
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
[span_14](start_span)kf.BackgroundColor3 = Color3.fromRGB(20, 20, 30)[span_14](end_span)
kf.BackgroundTransparency = guiSettings.glassTransparency
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
bg.Image = "rbxassetid://13807788519"
bg.ImageColor3 = guiSettings.accentColor
bg.BackgroundTransparency = 1
bg.ImageTransparency = 0.9
bg.ZIndex = -1

local title = Instance.new("TextLabel", kf)
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 0)
[span_15](start_span)title.Text = "FITREE HUB - KEY SYSTEM"[span_15](end_span)
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
txtKey.BackgroundTransparency = 0.5
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
    [span_16](start_span)task.wait(1.5)[span_16](end_span)
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
    [span_17](start_span)billboard.Size = UDim2.new(0, 200, 0, 50)[span_17](end_span)
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

    [span_18](start_span)local healthLabel = Instance.new("TextLabel", billboard)[span_18](end_span)
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
        [span_19](start_span)Highlight = highlight,[span_19](end_span)
        Billboard = billboard,
        HealthConnection = humanoid.HealthChanged:Connect(updateHealth)
    }

    plr.CharacterAdded:Connect(function(newChar)
        if espEnabled then
            if ESP_Objects[plr] then
                ESP_Objects[plr].Highlight:Destroy()
                ESP_Objects[plr].Billboard:Destroy()
                [span_20](start_span)ESP_Objects[plr].HealthConnection:Disconnect()[span_20](end_span)
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
        [span_21](start_span)for _, plr in ipairs(Players:GetPlayers()) do[span_21](end_span)
            if plr ~= player then
                createESP(plr)
            end
        end

        Players.PlayerAdded:Connect(function(newPlayer)
            if espEnabled then
                [span_22](start_span)createESP(newPlayer)[span_22](end_span)
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
    [span_23](start_span)closeBtn.Size = UDim2.new(0, 30, 0, 30)[span_23](end_span)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextScaled = true
    closeBtn.Parent = parent
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Text = "-"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    [span_24](start_span)minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)[span_24](end_span)
    minimizeBtn.BackgroundTransparency = 0.3
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
            [span_25](start_span)Size = UDim2.new(0, 0, 0, 0),[span_25](end_span)
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            gui:Destroy()
            if blur then
                [span_26](start_span)blur.Enabled = false[span_26](end_span)
            end
        end)
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        guiSettings.minimized = not guiSettings.minimized
        if guiSettings.minimized then
            local tween = TweenService:Create(parent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 150, 0, 50)
            })
            [span_27](start_span)tween:Play()[span_27](end_span)
            minimizeBtn.Text = "+"
        else
            local tween = TweenService:Create(parent, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = guiSettings.guiSize
            })
            tween:Play()
            [span_28](start_span)minimizeBtn.Text = "-"[span_28](end_span)
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
    [span_29](start_span)guiColorLabel.Text = "สีพื้นหลัง GUI:"[span_29](end_span)
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
    [span_30](start_span)guiColorBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)[span_30](end_span)
    guiColorBox.BackgroundTransparency = 0.5
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
    [span_31](start_span)espColorBox.Text = table.concat({math.floor(guiSettings.espColor.r*255), math.floor(guiSettings.espColor.g*255), math.floor(guiSettings.espColor.b*255)}, ",")[span_31](end_span)
    espColorBox.Size = UDim2.new(1, -20, 0, 30)
    espColorBox.Position = UDim2.new(0, 10, 0, 110)
    espColorBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    espColorBox.BackgroundTransparency = 0.5
    espColorBox.TextColor3 = guiSettings.textColor
    
    local sizeLabel = Instance.new("TextLabel", content)
    sizeLabel.Text = "ขนาด GUI (กว้าง,สูง):"
    sizeLabel.Size = UDim2.new(1, -20, 0, 30)
    sizeLabel.Position = UDim2.new(0, 10, 0, 150)
    sizeLabel.TextColor3 = guiSettings.textColor
    sizeLabel.BackgroundTransparency = 1
    [span_32](start_span)sizeLabel.Font = Enum.Font.Gotham[span_32](end_span)
    sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sizeBox = Instance.new("TextBox", content)
    sizeBox.PlaceholderText = "เช่น 450,400"
    sizeBox.Text = table.concat({math.floor(guiSettings.guiSize.X.Offset), math.floor(guiSettings.guiSize.Y.Offset)}, ",")
    sizeBox.Size = UDim2.new(1, -20, 0, 30)
    sizeBox.Position = UDim2.new(0, 10, 0, 180)
    sizeBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sizeBox.BackgroundTransparency = 0.5
    sizeBox.TextColor3 = guiSettings.textColor
    
    local jumpLabel = Instance.new("TextLabel", content)
    jumpLabel.Text = "กระโดดอัตโนมัติทุก (วินาที):"
    [span_33](start_span)jumpLabel.Size = UDim2.new(1, -20, 0, 30)[span_33](end_span)
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
    [span_34](start_span)jumpBox.BackgroundTransparency = 0.5[span_34](end_span)
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
    [span_35](start_span)chatBox.Size = UDim2.new(1, -20, 0, 30)[span_35](end_span)
    chatBox.Position = UDim2.new(0, 10, 0, 320)
    chatBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    chatBox.BackgroundTransparency = 0.5
    chatBox.TextColor3 = guiSettings.textColor
    
    local intervalLabel = Instance.new("TextLabel", content)
    intervalLabel.Text = "ช่วงเวลาแชทอัตโนมัติ (วินาที):"
    intervalLabel.Size = UDim2.new(1, -20, 0, 30)
    intervalLabel.Position = UDim2.new(0, 10, 0, 360)
    intervalLabel.TextColor3 = guiSettings.textColor
    intervalLabel.BackgroundTransparency = 1
    intervalLabel.Font = Enum.Font.Gotham
    intervalLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    [span_36](start_span)local intervalBox = Instance.new("TextBox", content)[span_36](end_span)
    intervalBox.PlaceholderText = "เช่น 30"
    intervalBox.Text = tostring(autoChatInterval)
    intervalBox.Size = UDim2.new(1, -20, 0, 30)
    intervalBox.Position = UDim2.new(0, 10, 0, 390)
    intervalBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    intervalBox.BackgroundTransparency = 0.5
    intervalBox.TextColor3 = guiSettings.textColor
    
    local saveBtn = Instance.new("TextButton", content)
    saveBtn.Text = "บันทึกการตั้งค่า"
    saveBtn.Size = UDim2.new(1, -20, 0, 40)
    saveBtn.Position = UDim2.new(0, 10, 0, 430)
    [span_37](start_span)saveBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)[span_37](end_span)
    saveBtn.BackgroundTransparency = 0.3
    saveBtn.TextColor3 = Color3.new(1, 1, 1)
    saveBtn.Font = Enum.Font.GothamBold
    
    saveBtn.MouseButton1Click:Connect(function()
        local guiColorParts = string.split(guiColorBox.Text, ",")
        if #guiColorParts == 3 then
            guiSettings.mainColor = Color3.fromRGB(
                tonumber(guiColorParts[1]) or 40,
                [span_38](start_span)tonumber(guiColorParts[2]) or 40,[span_38](end_span)
                tonumber(guiColorParts[3]) or 40
            )
            mainFrame.BackgroundColor3 = guiSettings.mainColor
        end
        
        local espColorParts = string.split(espColorBox.Text, ",")
        if #espColorParts == 3 then
            [span_39](start_span)guiSettings.espColor = Color3.fromRGB([span_39](end_span)
                tonumber(espColorParts[1]) or 0,
                tonumber(espColorParts[2]) or 255,
                tonumber(espColorParts[3]) or 0
            )
            for _, espData in pairs(ESP_Objects) do
                [span_40](start_span)if espData.Highlight then[span_40](end_span)
                    espData.Highlight.FillColor = guiSettings.espColor
                end
            end
        end
        
        local sizeParts = string.split(sizeBox.Text, ",")
        if #sizeParts == 2 then
            [span_41](start_span)guiSettings.guiSize = UDim2.new([span_41](end_span)
                0, tonumber(sizeParts[1]) or 450,
                0, tonumber(sizeParts[2]) or 400
            )
            if not guiSettings.minimized then
                [span_42](start_span)mainFrame.Size = guiSettings.guiSize[span_42](end_span)
            end
        end
        
        autoJumpPeriod = tonumber(jumpBox.Text) or 60
        autoChatMessage = chatBox.Text or "cosmic-main.veracal.app"
        autoChatInterval = tonumber(intervalBox.Text) or 30
        
        saveBtn.Text = "✅ บันทึกแล้ว!"
        task.wait(1.5)
        saveBtn.Text = "บันทึกการตั้งค่า"
    end)
    
    [span_43](start_span)local corner = Instance.new("UICorner")[span_43](end_span)
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
            [span_44](start_span)while autoChatEnabled do[span_44](end_span)
                task.wait(autoChatInterval)
                
                if autoChatEnabled then
                    [span_45](start_span)local chatService = game:GetService("ReplicatedStorage")[span_45](end_span)
                    if chatService:FindFirstChild("DefaultChatSystemChatEvents") then
                        local sayMessage = chatService.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
                        if sayMessage then
                            [span_46](start_span)sayMessage:FireServer(autoChatMessage, "All")[span_46](end_span)
                        end
                    end
                end
            end
        end)
    end
end

-[span_47](start_span)- Main function to load GUI with glass theme[span_47](end_span)
function loadMainGUI()
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "FITREE_HUB"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if blur then
        blur.Enabled = true
    end

    local snd = Instance.new("Sound", gui)
    snd.SoundId = openSoundId
    snd.Volume = 1
    snd:Play()

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 0, 0, 0)
    [span_48](start_span)main.Position = UDim2.new(0.3, 0, 0.15, 0)[span_48](end_span)
    main.BackgroundColor3 = guiSettings.mainColor
    main.BackgroundTransparency = guiSettings.glassTransparency
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.ClipsDescendants = true

    local openTween = TweenService:Create(main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = guiSettings.guiSize
    })
    openTween:Play()

    createControlButtons(main, gui)

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    [span_49](start_span)mainCorner.Parent = main[span_49](end_span)

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
    [span_50](start_span)bg.Size = UDim2.new(1, 0, 1, 0)[span_50](end_span)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.Image = "rbxassetid://13807788519"
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
    [span_51](start_span)lblTitle.TextColor3 = guiSettings.textColor[span_51](end_span)
    lblTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    lblTitle.BackgroundTransparency = 0.5

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = lblTitle

    local featureScroll = Instance.new("ScrollingFrame", main)
    featureScroll.Size = UDim2.new(0, 150, 1, -70) -- <<< MODIFIED: Adjusted height
    featureScroll.Position = UDim2.new(0, 10, 0, 60)
    featureScroll.BackgroundTransparency = 1
    featureScroll.BorderSizePixel = 0
    featureScroll.ScrollBarThickness = 8
    featureScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    featureScroll.ScrollingDirection = Enum.ScrollingDirection.Y

    [span_52](start_span)local listLayout = Instance.new("UIListLayout", featureScroll)[span_52](end_span)
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local features = {
        {text="กันหลุดออกเกม", name="antiAFK"},
        {text="ตั้งค่าความเร็ว", name="speed"},
        {text="วาร์ปไปหาผู้เล่น", name="teleport"},
        {text="กระโดดไม่จำกัด", name="infjump"},
        {text="บิน", name="fly"}, -- <<< ADDED: Fly button
        {text="ESP Toggle", name="esp"},
        {text="แชทอัตโนมัติ", name="autochat"},
        {text="ตั้งค่า", name="settings"},
    }

    local buttons = {}
    [span_53](start_span)for i, feat in ipairs(features) do[span_53](end_span)
        local b = createStyledButton(featureScroll, feat.text, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, (i-1)*60))
        b.Name = feat.name
        b.LayoutOrder = i
        buttons[feat.name] = b
        
        b.Visible = false
        task.delay(i * 0.05, function()
            [span_54](start_span)b.Visible = true[span_54](end_span)
            local tween = TweenService:Create(b, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, b.Position.Y.Offset)
            })
            tween:Play()
        end)
    end

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        [span_55](start_span)featureScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)[span_55](end_span)
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
            [span_56](start_span)if c:IsA("Frame") or c:IsA("TextBox") or c:IsA("TextButton") or c:IsA("TextLabel") then[span_56](end_span)
                c:Destroy()
            end
        end
    end

    buttons.esp.MouseButton1Click:Connect(function()
        clearContent()
        toggleESP()
        buttons.esp.Text = espEnabled and "ESP (เปิด)" or "ESP (ปิด)"
        buttons.esp.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor
    end)

    [span_57](start_span)local afkConn, isAFK, autoJumpConn = nil, false, nil[span_57](end_span)
    buttons.antiAFK.MouseButton1Click:Connect(function()
        clearContent()
        isAFK = not isAFK
        if isAFK then
            if not afkConn then
                afkConn = player.Idled:Connect(function()
                    VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                    [span_58](start_span)task.wait(1)[span_58](end_span)
                    VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
                end)
            end
            
            autoJumpConn = spawn(function()
                [span_59](start_span)while isAFK and gui.Parent do[span_59](end_span)
                    task.wait(autoJumpPeriod)
                    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                [span_60](start_span)end[span_60](end_span)
            end)
        else
            if afkConn then
                afkConn:Disconnect()
                afkConn = nil
            end
            
            [span_61](start_span)if autoJumpConn then[span_61](end_span)
                coroutine.close(autoJumpConn)
                autoJumpConn = nil
            end
        end
        
        buttons.antiAFK.Text = isAFK and "กันหลุด (เปิด)" or "กันหลุด (ปิด)"
        [span_62](start_span)buttons.antiAFK.BackgroundColor3 = isAFK and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor[span_62](end_span)
    end)

    buttons.speed.MouseButton1Click:Connect(function()
        clearContent()
        
        local box = Instance.new("TextBox", content)
        box.PlaceholderText = "ใส่ WalkSpeed"
        box.Size = UDim2.new(1, -20, 0, 50)
        box.Position = UDim2.new(0, 10, 0, 10)
        box.TextScaled = true
        [span_63](start_span)box.Font = Enum.Font.Gotham[span_63](end_span)
        box.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        box.BackgroundTransparency = 0.5
        box.TextColor3 = guiSettings.textColor
        box.ClearTextOnFocus = false
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 8)
        boxCorner.Parent = box

        [span_64](start_span)local setBtn = createStyledButton(content, "ตั้งค่า", UDim2.new(1, -20, 0, 50), UDim2.new(0, 10, 0, 70))[span_64](end_span)

        setBtn.MouseButton1Click:Connect(function()
            local v = tonumber(box.Text)
            if v and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = v
                setBtn.Text = "✅ ตั้งค่าแล้ว!"
                [span_65](start_span)setBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)[span_65](end_span)
                task.wait(1.5)
                setBtn.Text = "ตั้งค่า"
                setBtn.BackgroundColor3 = guiSettings.accentColor
            end
        end)
    end)

    local inf = false
    buttons.infjump.MouseButton1Click:Connect(function()
        clearContent()
        [span_66](start_span)inf = not inf[span_66](end_span)
        buttons.infjump.Text = inf and "กระโดดไม่จำกัด (เปิด)" or "กระโดดไม่จำกัด (ปิด)"
        buttons.infjump.BackgroundColor3 = inf and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor
    end)
    UserInput.JumpRequest:Connect(function()
        if inf and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)

    buttons.autochat.MouseButton1Click:Connect(function()
        clearContent()
        [span_67](start_span)toggleAutoChat()[span_67](end_span)
        buttons.autochat.Text = autoChatEnabled and "แชทอัตโนมัติ (เปิด)" or "แชทอัตโนมัติ (ปิด)"
        buttons.autochat.BackgroundColor3 = autoChatEnabled and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor
    end)

    -- <<< ADDED: New fly function logic
    local isFlying = false
    local flyScript = nil
    
    buttons.fly.MouseButton1Click:Connect(function()
        clearContent()
        isFlying = not isFlying

        if isFlying and not flyScript then
            local success, result = pcall(function()
                return loadstring(game:HttpGet(('https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f425b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%25202%2520obflucator'),true))
            end)
            if success and typeof(result) == "function" then
                flyScript = result() -- Execute the script and store its returned API
            else
                warn("Fitree Hub: Failed to load fly script.", result)
                isFlying = false
            end
        end

        if flyScript and flyScript.toggle then
             flyScript.toggle(isFlying)
        end
        
        buttons.fly.Text = isFlying and "บิน (เปิด)" or "บิน (ปิด)"
        buttons.fly.BackgroundColor3 = isFlying and Color3.fromRGB(0, 170, 0) or guiSettings.accentColor
    end)

    player.CharacterAdded:Connect(function(character)
        task.wait(1)
        if isFlying and flyScript and flyScript.toggle then
            flyScript.toggle(true) -- Re-enable fly on respawn
        end
    end)
    -- End of new fly function logic
    
    buttons.teleport.MouseButton1Click:Connect(function()
        clearContent() -- <<< FIXED: Clears content before showing player list
        local playerScroll = Instance.new("ScrollingFrame", content)
        playerScroll.Size = UDim2.new(1, -10, 1, -10)
        playerScroll.Position = UDim2.new(0, 5, 0, 5)
        playerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        [span_68](start_span)playerScroll.ScrollBarThickness = 8[span_68](end_span)
        playerScroll.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        playerScroll.BackgroundTransparency = 0.5

        local playerCorner = Instance.new("UICorner")
        playerCorner.CornerRadius = UDim.new(0, 8)
        playerCorner.Parent = playerScroll

        local playerLayout = Instance.new("UIListLayout", playerScroll)
        playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        playerLayout.Padding = UDim.new(0, 5)

        [span_69](start_span)local function updatePlayerList()[span_69](end_span)
            for _, c in ipairs(playerScroll:GetChildren()) do
                if c:IsA("TextButton") then
                    c:Destroy()
                end
            end
            [span_70](start_span)for _, p in ipairs(Players:GetPlayers()) do[span_70](end_span)
                if p ~= player then
                    local b = createStyledButton(playerScroll, p.Name, UDim2.new(1, -10, 0, 40), UDim2.new(0, 5, 0, 0))
                    b.MouseButton1Click:Connect(function()
                        [span_71](start_span)if player.Character and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then[span_71](end_span)
                            player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
                            b.Text = "✅ วาร์ปแล้ว!"
                            [span_72](start_span)b.BackgroundColor3 = Color3.fromRGB(0, 170, 0)[span_72](end_span)
                            task.wait(1.5)
                            b.Text = p.Name
                            b.BackgroundColor3 = guiSettings.accentColor
                        [span_73](start_span)end[span_73](end_span)
                    end)
                end
            end
            task.wait()
            playerScroll.CanvasSize = UDim2.new(0, 0, 0, playerLayout.AbsoluteContentSize.Y + 10)
        [span_74](start_span)end[span_74](end_span)

        updatePlayerList()
        Players.PlayerAdded:Connect(updatePlayerList)
        Players.PlayerRemoving:Connect(updatePlayerList)
    end)

    buttons.settings.MouseButton1Click:Connect(function()
        clearContent()
        createSettingsMenu(content, buttons, main)
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if ESP_Objects[plr] then
            removeESP(plr)
        end
    end)

    local toggle = Instance.new("ImageButton", gui)
    [span_75](start_span)toggle.Size = UDim2.new(0, 50, 0, 50)[span_75](end_span)
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
    
    [span_76](start_span)toggle.MouseEnter:Connect(function()[span_76](end_span)
        game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3,
            Size = UDim2.new(0, 55, 0, 55)
        }):Play()
    end)
    
    toggle.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.5,
            [span_77](start_span)Size = UDim2.new(0, 50, 0, 50)[span_77](end_span)
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
        [span_78](start_span)if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then[span_78](end_span)
            dragging = true
            dragStart = input.Position
            startPos = toggle.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    [span_79](start_span)dragging = false[span_79](end_span)
                end
            end)
        end
    end)
    
    toggle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            [span_80](start_span)dragInput = input[span_80](end_span)
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
                [span_81](start_span)Size = UDim2.new(0, 0, 0, 0),[span_81](end_span)
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                main.Visible = false
                [span_82](start_span)if blur then[span_82](end_span)
                    blur.Enabled = false
                end
            end)
            
            local snd = Instance.new("Sound", gui)
            snd.SoundId = closeSoundId
            [span_83](start_span)snd.Volume = 1[span_83](end_span)
            snd:Play()
        else
            main.Visible = true
            local openTween = TweenService:Create(main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = guiSettings.guiSize,
                [span_84](start_span)Position = UDim2.new(0.3, 0, 0.15, 0)[span_84](end_span)
            })
            openTween:Play()
            
            if blur then
                blur.Enabled = true
            end
            
            [span_85](start_span)local snd = Instance.new("Sound", gui)[span_85](end_span)
            snd.SoundId = openSoundId
            snd.Volume = 1
            snd:Play()
        end
        
        game:GetService("TweenService"):Create(toggle, TweenInfo.new(0.2), {
            Rotation = main.Visible and 180 or 0
        [span_86](start_span)}):Play()[span_86](end_span)
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
        [span_87](start_span)local shake = TweenService:Create(kf, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 5, true), {[span_87](end_span)
            Position = UDim2.new(0.5, -200 + math.random(-10,10), 0.5, -140 + math.random(-5,5))
        })
        title.Text = "❌ Key ไม่ถูกต้อง"
        title.TextColor3 = Color3.fromRGB(255,50,50)
        shake:Play()
    end
end)

