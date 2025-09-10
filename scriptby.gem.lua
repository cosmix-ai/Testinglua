--[[
    ปรับปรุงโดย: Gemini AI
    วันที่: 9 กันยายน 2025
    การเปลี่ยนแปลงหลัก:
    1.  GUI หลักจะแสดงผลอัตโนมัติหลังจากข้อความต้อนรับหายไป
    2.  แก้ไขการลากหน้าต่างและไอคอนให้เป็นอิสระมากขึ้น ไม่ถูกจำกัดขอบเขต
    3.  แก้ไขปัญหาหน้าโหลดค้าง โดยการันตีว่าหน้าโหลดจะถูกซ่อนเสมอ
    4.  เพิ่มความเสถียรในการโหลดสคริปต์จาก URL
    5.  ปรับปรุงการตอบสนองของ UI สำหรับมือถือ
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ตรวจสอบว่าเป็นอุปกรณ์มือถือหรือไม่
local isMobile = UserInputService.TouchEnabled

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ComicHubFrostedGlass"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Utility: clamp function
local function clamp(n, min, max)
    return math.max(min, math.min(max, n))
end

-- Animation functions (ย้ายมาไว้ข้างบนเพื่อให้เรียกใช้ได้ก่อน)
local MainFrame -- ประกาศไว้ล่วงหน้า
local IconButton -- ประกาศไว้ล่วงหน้า
local mainFrameWidth, mainFrameHeight, iconSize

local function showMainWindow()
    if MainFrame and IconButton then
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

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9046892326"
    sound.Volume = 0.5
    sound.Parent = welcomeFrame
    sound:Play()

    welcomeFrame.Size = UDim2.new(0, 0, 0, 0)
    welcomeFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    
    local tweenIn = TweenService:Create(
        welcomeFrame,
        TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 350, 0, 120), Position = UDim2.new(0.5, -175, 0.3, -60)}
    )
    tweenIn:Play()

    task.delay(2.5, function()
        local tweenOut = TweenService:Create(
            welcomeFrame,
            TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.3, 0)}
        )
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            welcomeGui:Destroy()
            -- **แก้ไข:** เปิด GUI หลักอัตโนมัติหลังจากแจ้งเตือนเสร็จสิ้น
            showMainWindow()
        end)
    end)
end

-- ขนาดและตำแหน่งสำหรับมือถือ (เพิ่มขนาด GUI)
iconSize = isMobile and 70 or 55
mainFrameWidth = isMobile and 450 or 600
mainFrameHeight = isMobile and 350 or 400

-- Create icon button (ปรับขนาดสำหรับมือถือ)
IconButton = Instance.new("ImageButton")
IconButton.Name = "HubIcon"
IconButton.Size = UDim2.new(0, iconSize, 0, iconSize)
IconButton.Position = UDim2.new(0, 20, 0.5, -iconSize/2)
IconButton.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
IconButton.BackgroundTransparency = 0.1
IconButton.AutoButtonColor = false
IconButton.Image = "rbxassetid://7072718162"
IconButton.ImageColor3 = Color3.fromRGB(200, 220, 255)
IconButton.Visible = true
-- **แก้ไข:** ทำให้ไอคอนมองไม่เห็นในตอนแรก รอให้ Welcome Notification หายไปก่อน
IconButton.Visible = false
IconButton.Parent = ScreenGui

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
MainFrame = Instance.new("Frame")
MainFrame.Name = "MainWindow"
MainFrame.Size = UDim2.new(0, mainFrameWidth, 0, mainFrameHeight)
MainFrame.Position = UDim2.new(0.5, -mainFrameWidth/2, 0.5, -mainFrameHeight/2)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Draggable = true -- เปิดใช้งานคุณสมบัติ Draggable
MainFrame.Active = true
MainFrame.Parent = ScreenGui

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

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 220, 0, isMobile and 45 or 40)
TitleText.Position = UDim2.new(0.5, -110, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "COSMIC HUB BY FITREE"
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextColor3 = Color3.fromRGB(240, 245, 255)
TitleText.TextSize = isMobile and 18 or 16
TitleText.Parent = TitleBar

local RefreshButton = Instance.new("TextButton")
RefreshButton.Size = UDim2.new(0, 30, 0, 30)
RefreshButton.Position = UDim2.new(0, 10, 0.5, -15)
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

local buttonSize = isMobile and 35 or 30
local buttonFontSize = isMobile and 18 or 14

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
CloseButton.Position = UDim2.new(1, -buttonSize-5, 0.5, -buttonSize/2)
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

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, buttonSize, 0, buttonSize)
MinimizeButton.Position = UDim2.new(1, -buttonSize*2-10, 0.5, -buttonSize/2)
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
if isMobile then
    ScriptsContainer.ScrollingDirection = Enum.ScrollingDirection.XY
    ScriptsContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always
end

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScriptsContainer

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
LoadingSpinner.Position = UDim2.new(0.5, -18, 0.5, -28)
LoadingSpinner.BackgroundTransparency = 1
LoadingSpinner.Image = "rbxassetid://7072717776"
LoadingSpinner.ImageColor3 = Color3.fromRGB(200, 220, 255)
LoadingSpinner.ZIndex = 6
LoadingSpinner.Parent = LoadingFrame
task.spawn(function()
    while LoadingFrame.Visible do
        LoadingSpinner.Rotation = LoadingSpinner.Rotation + 10
        task.wait(0.03)
    end
end)

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, -20, 0, 30)
LoadingText.Position = UDim2.new(0, 10, 0.5, 10)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Loading scripts..."
LoadingText.Font = Enum.Font.Gotham
LoadingText.TextColor3 = Color3.fromRGB(220, 230, 255)
LoadingText.TextSize = 14
LoadingText.ZIndex = 6
LoadingText.Parent = LoadingFrame

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


local function hideMainWindow()
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}
    )
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        IconButton.Visible = true
    end)
end

local function minimizeToIcon()
    local iconFinalPos = IconButton.Position
    local tween = TweenService:Create(
        MainFrame,
        TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, 0, 0, 0), Position = iconFinalPos}
    )
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        IconButton.Visible = true
        IconButton.Size = UDim2.new(0, 0, 0, 0)
        
        local iconTween = TweenService:Create(
            IconButton,
            TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, iconSize, 0, iconSize)}
        )
        iconTween:Play()
    end)
end

local function showStatus(message, color)
    StatusLabel.Text = " " .. message
    StatusLabel.TextColor3 = Color3.fromRGB(255,255,255)
    StatusLabel.BackgroundColor3 = color
    StatusLabel.Visible = true
    StatusLabel.BackgroundTransparency = 0.1
    StatusLabel.TextTransparency = 0
    
    task.delay(3, function()
        if StatusLabel.Text == " " .. message then
            local tween = TweenService:Create(
                StatusLabel,
                TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {BackgroundTransparency = 1, TextTransparency = 1}
            )
            tween:Play()
            tween.Completed:Connect(function()
                StatusLabel.Visible = false
            end)
        end
    end)
end

local function buttonHover(button)
    if not isMobile then
        TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0}
        ):Play()
    end
end

local function buttonLeave(button)
    if not isMobile then
        TweenService:Create(
            button,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0.1}
        ):Play()
    end
end

local function buttonClick(button)
    button.BackgroundTransparency = 0.2
    task.wait(0.1)
    button.BackgroundTransparency = 0
end

local iconDragging = false
local iconDragStart = Vector2.new(0,0)
local iconStartPos = UDim2.new(0,0,0,0)

IconButton.MouseEnter:Connect(function()
    if not isMobile then
        TweenService:Create(IconButton, TweenInfo.new(0.18), {Size = UDim2.new(0, iconSize+6, 0, iconSize+6)}):Play()
    end
end)

IconButton.MouseLeave:Connect(function()
    if not isMobile and not iconDragging then
        TweenService:Create(IconButton, TweenInfo.new(0.18), {Size = UDim2.new(0, iconSize, 0, iconSize)}):Play()
    end
end)

IconButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if (input.Position - IconButton.AbsolutePosition).Magnitude > iconSize * 1.5 then return end -- ป้องกันการคลิกพลาด
        iconDragging = true
        iconDragStart = Vector2.new(input.Position.X, input.Position.Y)
        iconStartPos = IconButton.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                iconDragging = false
                connection:Disconnect()
            end
        end)
    end
end)

local function loadScripts()
    LoadingFrame.Visible = true
    
    for _, child in ipairs(ScriptsContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local raw_url = "https://raw.githubusercontent.com/cosmix-ai/Testinglua/main/all-scripts.lua"
    local success, response = pcall(game.HttpGet, game, raw_url)

    if not success then
        warn("Cosmic Hub: Failed to fetch scripts - ", response)
        showStatus("Error: Could not load scripts.", Color3.fromRGB(150, 40, 60))
        LoadingFrame.Visible = false -- **แก้ไข:** ซ่อนหน้าโหลดเสมอแม้จะเกิดข้อผิดพลาด
        return
    end

    local raw = response
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

    if #scripts == 0 then
        table.insert(scripts, {
            title = "Sample Script",
            code = "print('Hello from Cosmic Hub!')"
        })
        showStatus("Using sample script. Check file format.", Color3.fromRGB(200, 150, 50))
    else
        showStatus("Loaded " .. #scripts .. " script(s) successfully.", Color3.fromRGB(40, 100, 60))
    end
    
    for i, s in ipairs(scripts) do
        local scriptButton = Instance.new("Frame")
        scriptButton.Size = UDim2.new(0, isMobile and 180 or 200, 0, isMobile and 120 or 140)
        scriptButton.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
        scriptButton.BackgroundTransparency = 0.1
        scriptButton.Parent = ScriptsContainer
        
        local UICornerButton = Instance.new("UICorner")
        UICornerButton.CornerRadius = UDim.new(0, 12)
        UICornerButton.Parent = scriptButton
        
        local scriptIcon = Instance.new("ImageLabel")
        scriptIcon.Size = UDim2.new(0, 40, 0, 40)
        scriptIcon.Position = UDim2.new(0, 10, 0, 10)
        scriptIcon.BackgroundTransparency = 1
        scriptIcon.Image = "rbxassetid://7072718162"
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
        executeButton.Position = UDim2.new(0.5, -(isMobile and 45 or 50), 1, -(isMobile and 35 or 40))
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
        
        local function executeScript()
             local fn, compileErr = loadstring(s.code)
            if fn then
                local success, execErr = pcall(fn)
                if success then
                    showStatus("Executed: " .. s.title, Color3.fromRGB(40, 100, 60))
                else
                    showStatus("Error: " .. tostring(execErr), Color3.fromRGB(100, 40, 60))
                    warn("Error in script:", s.title, execErr)
                end
            else
                showStatus("Compile Error: " .. tostring(compileErr), Color3.fromRGB(100, 40, 60))
                warn("Compile error in script:", s.title, compileErr)
            end
        end

        executeButton.MouseEnter:Connect(function() buttonHover(executeButton) end)
        executeButton.MouseLeave:Connect(function() buttonLeave(executeButton) end)
        executeButton.MouseButton1Click:Connect(executeScript)
        if isMobile then
             executeButton.TouchTap:Connect(executeScript)
        end
    end
    
    ScriptsContainer.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 20, 0, 0)
    
    -- **แก้ไข:** ซ่อนหน้าโหลดเสมอเมื่อทำงานเสร็จ
    LoadingFrame.Visible = false
end

IconButton.MouseButton1Click:Connect(showMainWindow)
if isMobile then IconButton.TouchTap:Connect(showMainWindow) end

CloseButton.MouseButton1Click:Connect(hideMainWindow)
if isMobile then CloseButton.TouchTap:Connect(hideMainWindow) end

MinimizeButton.MouseButton1Click:Connect(minimizeToIcon)
if isMobile then MinimizeButton.TouchTap:Connect(minimizeToIcon) end

RefreshButton.MouseButton1Click:Connect(loadScripts)
if isMobile then RefreshButton.TouchTap:Connect(loadScripts) end

-- **แก้ไข:** ทำให้หน้าต่างและไอคอนลากได้อิสระ
local dragging = false
local dragStart = Vector2.new(0,0)
local startPos = UDim2.new(0,0,0,0)

local function startDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = MainFrame.Position
    
    local connection
    connection = input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
            connection:Disconnect()
        end
    end)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        startDrag(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        elseif iconDragging then
             local delta = input.Position - iconDragStart
            IconButton.Position = UDim2.new(
                iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X,
                iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

CloseButton.MouseEnter:Connect(function() buttonHover(CloseButton) end)
CloseButton.MouseLeave:Connect(function() buttonLeave(CloseButton) end)
CloseButton.MouseButton1Down:Connect(function() buttonClick(CloseButton) end)

MinimizeButton.MouseEnter:Connect(function() buttonHover(MinimizeButton) end)
MinimizeButton.MouseLeave:Connect(function() buttonLeave(MinimizeButton) end)
MinimizeButton.MouseButton1Down:Connect(function() buttonClick(MinimizeButton) end)

RefreshButton.MouseEnter:Connect(function() buttonHover(RefreshButton) end)
RefreshButton.MouseLeave:Connect(function() buttonLeave(RefreshButton) end)
RefreshButton.MouseButton1Down:Connect(function() buttonClick(RefreshButton) end)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScriptsContainer.CanvasSize = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 20, 0, 0)
end)

-- Initial setup
showWelcomeNotification()
task.spawn(loadScripts)

