local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local SoundService = game:GetService("SoundService")

-- ตรวจสอบว่าเป็นอุปกรณ์มือถือหรือไม่
local isMobile = UserInputService.TouchEnabled

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ComicHubFrostedGlass"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Utility: clamp
local function clamp(n, a, b)
    return math.max(a, math.min(b, n))
end

-- Welcome notification function
local function showWelcomeNotification()
    local welcomeGui = Instance.new("ScreenGui")
    welcomeGui.Name = "WelcomeNotification"
    welcomeGui.Parent = PlayerGui
    welcomeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    welcomeGui.ResetOnSpawn = false

    local welcomeFrame = Instance.new("Frame")
    welcomeFrame.Size = UDim2.new(0, 350, 0, 120)
    welcomeFrame.Position = UDim2.new(0.5, -175, 0.3, -60)
    welcomeFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
    welcomeFrame.BackgroundTransparency = 0.1
    welcomeFrame.BorderSizePixel = 0
    welcomeFrame.Parent = welcomeGui

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    gradient.Parent = welcomeFrame

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(160, 190, 230)
    stroke.Transparency = 0.1
    stroke.Thickness = 1
    stroke.Parent = welcomeFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = welcomeFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "ยินดีต้อนรับ"
    title.Font = Enum.Font.GothamBlack
    title.TextColor3 = Color3.fromRGB(240, 245, 255)
    title.TextSize = 22
    title.Parent = welcomeFrame

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -20, 0, 50)
    message.Position = UDim2.new(0, 10, 0, 45)
    message.BackgroundTransparency = 1
    message.Text = "สู่ Cosmic Hub โดย Fitree"
    message.Font = Enum.Font.Gotham
    message.TextColor3 = Color3.fromRGB(220, 230, 255)
    message.TextSize = 18
    message.Parent = welcomeFrame

    -- Play welcome sound
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9046892326" -- Example sound ID, replace with your own
    sound.Volume = 0.5
    sound.Parent = welcomeFrame
    sound:Play()

    -- Animate in
    welcomeFrame.Size = UDim2.new(0, 0, 0, 0)
    welcomeFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    
    local tweenIn = TweenService:Create(
        welcomeFrame,
        TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 350, 0, 120), Position = UDim2.new(0.5, -175, 0.3, -60)}
    )
    tweenIn:Play()

    -- Animate out after 2 seconds
    task.delay(2, function()
        local tweenOut = TweenService:Create(
            welcomeFrame,
            TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.3, 0)}
        )
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            welcomeGui:Destroy()
        end)
    end)
end

-- Show welcome notification
showWelcomeNotification()

-- ขนาดและตำแหน่งสำหรับมือถือ (เพิ่มขนาด GUI)
local iconSize = isMobile and 70 or 55
local mainFrameWidth = isMobile and 450 or 600  -- Increased width
local mainFrameHeight = isMobile and 350 or 400  -- Increased height

-- Create icon button (ปรับขนาดสำหรับมือถือ)
local IconButton = Instance.new("ImageButton")
IconButton.Name = "HubIcon"
IconButton.Size = UDim2.new(0, iconSize, 0, iconSize)
IconButton.Position = UDim2.new(0, 20, 0.5, -iconSize/2)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
IconButton.BackgroundTransparency = 0.1
IconButton.AutoButtonColor = false
IconButton.Image = "rbxassetid://123007757538660"
IconButton.ImageColor3 = Color3.fromRGB(200, 220, 255)
IconButton.Visible = true
IconButton.Parent = ScreenGui

-- Frosted glass effect for icon
local IconGradient = Instance.new("UIGradient")
IconGradient.Rotation = 90
IconGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.4),
    NumberSequenceKeypoint.new(0.5, 0.2),
    NumberSequenceKeypoint.new(1, 0.4)
})
IconGradient.Parent = IconButton

local IconStroke = Instance.new("UIStroke")
IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
IconStroke.Color = Color3.fromRGB(160, 190, 230)
IconStroke.Transparency = 0.1
IconStroke.Thickness = 1
IconStroke.Parent = IconButton

local UICornerIcon = Instance.new("UICorner")
UICornerIcon.CornerRadius = UDim.new(1, 0)
UICornerIcon.Parent = IconButton

-- Create main window (ปรับขนาดสำหรับมือถือ)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, mainFrameWidth, 0, mainFrameHeight)
MainFrame.Position = UDim2.new(0.5, -mainFrameWidth/2, 0.5, -mainFrameHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Frosted glass effect
local MainGradient = Instance.new("UIGradient")
MainGradient.Rotation = 90
MainGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.3),
    NumberSequenceKeypoint.new(0.5, 0.1),
    NumberSequenceKeypoint.new(1, 0.3)
})
MainGradient.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Color = Color3.fromRGB(160, 190, 230)
MainStroke.Transparency = 0.1
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 16)
UICornerMain.Parent = MainFrame

-- Background blur effect
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 10
BlurEffect.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, isMobile and 45 or 40)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
TitleBar.BackgroundTransparency = 0.1
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 16)
UICornerTitle.Parent = TitleBar

-- Centered title text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 220, 0, isMobile and 45 or 40)
TitleText.Position = UDim2.new(0.5, -110, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "COSMIC HUB BY FITREE"
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextColor3 = Color3.fromRGB(240, 245, 255)
TitleText.TextSize = isMobile and 18 or 16
TitleText.Parent = TitleBar

-- ปุ่มรีเฟรชสคริปต์
local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 30, 0, 30)
RefreshButton.Position = UDim2.new(0, 10, 0, 5)
RefreshButton.BackgroundColor3 = Color3.fromRGB(90, 160, 220)
RefreshButton.BackgroundTransparency = 0.1
RefreshButton.Text = "↻"
RefreshButton.Font = Enum.Font.GothamBold
RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshButton.TextSize = 16
RefreshButton.Parent = TitleBar

local UICornerRefresh = Instance.new("UICorner")
UICornerRefresh.CornerRadius = UDim.new(0, 6)
UICornerRefresh.Parent = RefreshButton

-- ปุ่มสำหรับมือถือ: เพิ่มการตอบสนองการสัมผัส
if isMobile then
    RefreshButton.TouchTap:Connect(function()
        loadScripts()
    end)
end

-- ปรับขนาดปุ่มสำหรับมือถือ
local buttonSize = isMobile and 35 or 30
local buttonFontSize = isMobile and 18 or 14

-- Close button (X) - ปรับขนาดให้ใหญ่ขึ้นสำหรับมือถือ
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
CloseButton.Position = UDim2.new(1, -buttonSize-5, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 90, 90)
CloseButton.BackgroundTransparency = 0.1
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = buttonFontSize
CloseButton.Parent = TitleBar

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 6)
UICornerClose.Parent = CloseButton

-- Minimize button (-) - ปรับขนาดให้ใหญ่ขึ้นสำหรับมือถือ
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
MinimizeButton.Position = UDim2.new(1, -buttonSize*2-10, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(90, 160, 220)
MinimizeButton.BackgroundTransparency = 0.1
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = buttonFontSize + 2
MinimizeButton.Parent = TitleBar

local UICornerMinimize = Instance.new("UICorner")
UICornerMinimize.CornerRadius = UDim.new(0, 6)
UICornerMinimize.Parent = MinimizeButton

-- Scripts container
local ScriptsContainer = Instance.new("ScrollingFrame")
ScriptsContainer.Size = UDim2.new(1, -20, 1, -(isMobile and 60 or 55))
ScriptsContainer.Position = UDim2.new(0, 10, 0, isMobile and 55 or 50)
ScriptsContainer.BackgroundTransparency = 1
ScriptsContainer.BorderSizePixel = 0
ScriptsContainer.ScrollBarThickness = isMobile and 8 or 6
ScriptsContainer.ScrollBarImageColor3 = Color3.fromRGB(160, 190, 230)
ScriptsContainer.ScrollBarImageTransparency = 0.3
ScriptsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ScriptsContainer.Parent = MainFrame

-- ปรับการเลื่อนสำหรับมือถือ
if isMobile then
    ScriptsContainer.ScrollingDirection = Enum.ScrollingDirection.XY
    ScriptsContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always
end

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Parent = ScriptsContainer

-- Loading indicator
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
LoadingFrame.BackgroundTransparency = 0.1
LoadingFrame.Visible = false
LoadingFrame.ZIndex = 5
LoadingFrame.Parent = MainFrame

local LoadingSpinner = Instance.new("ImageLabel")
LoadingSpinner.Size = UDim2.new(0, 36, 0, 36)
LoadingSpinner.Position = UDim2.new(0.5, -18, 0.5, -18)
LoadingSpinner.BackgroundTransparency = 1
LoadingSpinner.Image = "rbxassetid://7072717776"
LoadingSpinner.ImageColor3 = Color3.fromRGB(200, 220, 255)
LoadingSpinner.ZIndex = 6
LoadingSpinner.Parent = LoadingFrame

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, -20, 0, 30)
LoadingText.Position = UDim2.new(0, 10, 0, 0.6)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Loading scripts..."
LoadingText.Font = Enum.Font.Gotham
LoadingText.TextColor3 = Color3.fromRGB(220, 230, 255)
LoadingText.TextSize = 14
LoadingText.ZIndex = 6
LoadingText.Parent = LoadingFrame

-- Status notification
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -40, 0, 35)
StatusLabel.Position = UDim2.new(0, 20, 1, -45)
StatusLabel.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
StatusLabel.BackgroundTransparency = 0.1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true
StatusLabel.Visible = false
StatusLabel.ZIndex = 5
StatusLabel.Parent = MainFrame

local UICornerStatus = Instance.new("UICorner")
UICornerStatus.CornerRadius = UDim.new(0, 12)
UICornerStatus.Parent = StatusLabel

-- Animation functions
local function showMainWindow()
    MainFrame.Visible = true
    IconButton.Visible = false
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, mainFrameWidth, 0, mainFrameHeight), Position = UDim2.new(0.5, -mainFrameWidth/2, 0.5, -mainFrameHeight/2)}
    )
    tween:Play()
end

local function hideMainWindow()
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
    end)
end

local function minimizeToIcon()
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0, 20, 0.5, -iconSize/2)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        IconButton.Visible = true
        IconButton.Size = UDim2.new(0, 0, 0, 0)
        IconButton.Position = UDim2.new(0, 20, 0.5, -iconSize/2)
        
        local iconTween = TweenService:Create(
            IconButton,
            TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, iconSize, 0, iconSize)}
        )
        iconTween:Play()
    end)
end

local function showStatus(message, color)
    StatusLabel.Text = message
    StatusLabel.BackgroundColor3 = color
    StatusLabel.Visible = true
    
    task.delay(3, function()
        if StatusLabel.Text == message then
            local tween = TweenService:Create(
                StatusLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundTransparency = 1, TextTransparency = 1}
            )
            tween:Play()
            tween.Completed:Connect(function()
                StatusLabel.Visible = false
                StatusLabel.BackgroundTransparency = 0.1
                StatusLabel.TextTransparency = 0
            end)
        end
    end)
end

-- Button animations
local function buttonHover(button)
    if not isMobile then
        TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0, Size = UDim2.new(0, buttonSize+2, 0, buttonSize+2)}
        ):Play()
    end
end

local function buttonLeave(button)
    if not isMobile then
        TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.1, Size = UDim2.new(0, buttonSize, 0, buttonSize)}
        ):Play()
    end
end

local function buttonClick(button)
    TweenService:Create(
        button,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    ):Play()
end

-- Icon button animation and improved drag (uses absolute mouse position and clamps to viewport)
local iconDragging = false
local iconDragStart = Vector2.new(0,0)
local iconStartPos = UDim2.new(0,20,0,0)

IconButton.MouseEnter:Connect(function()
    if not isMobile then
        TweenService:Create(
            IconButton,
            TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, iconSize+6, 0, iconSize+6), Position = UDim2.new(0, 17, 0.5, -(iconSize+6)/2)}
        ):Play()
    end
end)

IconButton.MouseLeave:Connect(function()
    if not isMobile and not iconDragging then
        TweenService:Create(
            IconButton,
            TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, iconSize, 0, iconSize), Position = UDim2.new(0, 20, 0.5, -iconSize/2)}
        ):Play()
    end
end)

-- ฟังก์ชันสำหรับจัดการการสัมผัสบนมือถือ
local function handleTouchInput(input, callback)
    if isMobile and input.UserInputType == Enum.UserInputType.Touch then
        callback()
    end
end

IconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconDragStart = UserInputService:GetMouseLocation()
        iconStartPos = IconButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                iconDragging = false
            end
        end)
    end
end)

IconButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    -- handle icon dragging first
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local now = UserInputService:GetMouseLocation()
        local delta = now - iconDragStart

        local cam = workspace.CurrentCamera
        local vs = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)
        local iconSizeVec = Vector2.new(IconButton.AbsoluteSize.X, IconButton.AbsoluteSize.Y)
        local newX = iconStartPos.X.Offset + delta.X
        local newY = iconStartPos.Y.Offset + delta.Y

        newX = clamp(newX, 0, vs.X - iconSizeVec.X)
        newY = clamp(newY, 0, vs.Y - iconSizeVec.Y)

        IconButton.Position = UDim2.new(0, newX, 0, newY)
        return
    end
end)

-- Load scripts function
local function loadScripts()
    LoadingFrame.Visible = true
    
    -- Clear existing scripts
    for _, child in ipairs(ScriptsContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local raw_url = "https://raw.githubusercontent.com/cosmix-ai/Testinglua/main/all-scripts.lua"
    
    local success, err = pcall(function()
        local raw = game:HttpGet(raw_url)
        local scripts = {}
        local current_title, current_code = nil, ""

        for line in raw:gmatch("[^\r\n]+") do
            local title = line:match("^title=(.-),script=")
            if title then
                if current_title and current_code ~= "" then
                    table.insert(scripts, {title=current_title, code=current_code})
                end
                current_title = title
                current_code = line:sub(line:find("script=")+7)
            else
                current_code = current_code .. "\n" .. line
            end
        end
        
        if current_title and current_code ~= "" then
            table.insert(scripts, {title=current_title, code=current_code})
        end
        
        -- Create script buttons
        for i, s in ipairs(scripts) do
            local scriptButton = Instance.new("Frame")
            scriptButton.Size = UDim2.new(0, isMobile and 180 or 200, 0, isMobile and 120 or 140)  -- Increased size
            scriptButton.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
            scriptButton.BackgroundTransparency = 0.1
            scriptButton.Parent = ScriptsContainer
            
            local UICornerButton = Instance.new("UICorner")
            UICornerButton.CornerRadius = UDim.new(0, 12)
            UICornerButton.Parent = scriptButton
            
            -- Script icon/image
            local scriptIcon = Instance.new("ImageLabel")
            scriptIcon.Size = UDim2.new(0, 40, 0, 40)
            scriptIcon.Position = UDim2.new(0, 10, 0, 10)
            scriptIcon.BackgroundTransparency = 1
            scriptIcon.Image = "rbxassetid://123007757538660"  -- Default icon, you can customize per script
            scriptIcon.Parent = scriptButton
            
            local scriptName = Instance.new("TextLabel")
            scriptName.Size = UDim2.new(1, -60, 0, isMobile and 30 or 40)
            scriptName.Position = UDim2.new(0, 55, 0, 10)
            scriptName.BackgroundTransparency = 1
            scriptName.Text = s.title
            scriptName.Font = Enum.Font.GothamBold
            scriptName.TextColor3 = Color3.fromRGB(220, 230, 255)
            scriptName.TextSize = isMobile and 12 or 14
            scriptName.TextXAlignment = Enum.TextXAlignment.Left
            scriptName.TextWrapped = true
            scriptName.Parent = scriptButton
            
            local executeButton = Instance.new("TextButton")
            executeButton.Size = UDim2.new(0, isMobile and 90 or 100, 0, isMobile and 25 or 30)
            executeButton.Position = UDim2.new(0.5, -isMobile and 45 or 50, 1, isMobile and -35 or -40)
            executeButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
            executeButton.BackgroundTransparency = 0.1
            executeButton.Text = "Execute"
            executeButton.Font = Enum.Font.Gotham
            executeButton.TextColor3 = Color3.fromRGB(220, 230, 255)
            executeButton.TextSize = isMobile and 12 or 14
            executeButton.Parent = scriptButton
            
            local UICornerExecute = Instance.new("UICorner")
            UICornerExecute.CornerRadius = UDim.new(0, 8)
            UICornerExecute.Parent = executeButton
            
            -- Button interactions
            executeButton.MouseEnter:Connect(function()
                buttonHover(executeButton)
            end)
            
            executeButton.MouseLeave:Connect(function()
                buttonLeave(executeButton)
            end)
            
            executeButton.MouseButton1Down:Connect(function()
                buttonClick(executeButton)
            end)
            
            executeButton.MouseButton1Click:Connect(function()
                local success, err = pcall(function()
                    loadstring(s.code)()
                end)
                if success then
                    showStatus("Executed: " .. s.title, Color3.fromRGB(40, 100, 60))
                    -- Play success sound
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://9046892326"  -- Success sound
                    sound.Volume = 0.5
                    sound.Parent = scriptButton
                    sound:Play()
                else
                    showStatus("Error in script: " .. s.title, Color3.fromRGB(100, 40, 60))
                    warn("Error in script:", s.title, err)
                    -- Play error sound
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://9046892327"  -- Error sound
                    sound.Volume = 0.5
                    sound.Parent = scriptButton
                    sound:Play()
                end
            end)
            
            -- สำหรับมือถือ: เพิ่มการตอบสนองการสัมผัส
            if isMobile then
                executeButton.TouchTap:Connect(function()
                    buttonClick(executeButton)
                    local success, err = pcall(function()
                        loadstring(s.code)()
                    end)
                    if success then
                        showStatus("Executed: " .. s.title, Color3.fromRGB(40, 100, 60))
                    else
                        showStatus("Error in script: " .. s.title, Color3.fromRGB(100, 40, 60))
                        warn("Error in script:", s.title, err)
                    end
                end)
            end
        end
        
        -- Update container size
        ScriptsContainer.CanvasSize = UDim2.new(
            0, UIListLayout.AbsoluteContentSize.X + 10, 
            0, 0
        )
        
        LoadingFrame.Visible = false
    end)
    
    if not success then
        LoadingFrame.Visible = false
        showStatus("Failed to load scripts: " .. err, Color3.fromRGB(100, 40, 60))
    end
end

-- Connect events
IconButton.MouseButton1Click:Connect(function()
    showMainWindow()
end)

-- สำหรับมือถือ: เพิ่มการตอบสนองการสัมผัส
if isMobile then
    IconButton.TouchTap:Connect(function()
        showMainWindow()
    end)
end

CloseButton.MouseButton1Click:Connect(function()
    hideMainWindow()
end)

-- สำหรับมือถือ: เพิ่มการตอบสนองการสัมผัส
if isMobile then
    CloseButton.TouchTap:Connect(function()
        hideMainWindow()
    end)
end

MinimizeButton.MouseButton1Click:Connect(function()
    minimizeToIcon()
end)

-- สำหรับมือถือ: เพิ่มการตอบสนองการสัมผัส
if isMobile then
    MinimizeButton.TouchTap:Connect(function()
        minimizeToIcon()
    end)
end

RefreshButton.MouseButton1Click:Connect(function()
    loadScripts()
end)

-- Make window draggable (improved: uses absolute mouse position and clamps to viewport)
local dragging = false
local dragStart = Vector2.new(0,0)
local startPos = MainFrame.Position

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = UserInputService:GetMouseLocation()
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    -- nothing needed here besides maybe tracking the movement input type
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local now = UserInputService:GetMouseLocation()
        local delta = now - dragStart

        local cam = workspace.CurrentCamera
        local vs = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)
        local frameSize = Vector2.new(MainFrame.AbsoluteSize.X, MainFrame.AbsoluteSize.Y)

        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y

        -- clamp so window stays on screen (keeps scale component the same)
        newX = clamp(newX, -frameSize.X + 50, vs.X - 50) -- allow small offscreen margin
        newY = clamp(newY, 0, vs.Y - 50)

        MainFrame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
    end
end)

-- Button hover effects
CloseButton.MouseEnter:Connect(function() buttonHover(CloseButton) end)
CloseButton.MouseLeave:Connect(function() buttonLeave(CloseButton) end)
CloseButton.MouseButton1Down:Connect(function() buttonClick(CloseButton) end)

MinimizeButton.MouseEnter:Connect(function() buttonHover(MinimizeButton) end)
MinimizeButton.MouseLeave:Connect(function() buttonLeave(MinimizeButton) end)
MinimizeButton.MouseButton1Down:Connect(function() buttonClick(MinimizeButton) end)

RefreshButton.MouseEnter:Connect(function() buttonHover(RefreshButton) end)
RefreshButton.MouseLeave:Connect(function() buttonLeave(RefreshButton) end)
RefreshButton.MouseButton1Down:Connect(function() buttonClick(RefreshButton) end)

-- Initial setup
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScriptsContainer.CanvasSize = UDim2.new(
        0, UIListLayout.AbsoluteContentSize.X + 10, 
        0, 0
    )
end)

-- โหลดสคริปต์ทันทีเมื่อ GUI เปิด
loadScripts()