-- LUI - Lightweight UI Library for Roblox
-- External Style Edition

local LUI = {}
LUI.__index = LUI

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Theme Presets
local ThemePresets = {
    Dark = {
        Background = Color3.fromRGB(12, 12, 12),
        Header = Color3.fromRGB(18, 18, 18),
        Element = Color3.fromRGB(22, 22, 22),
        ElementHover = Color3.fromRGB(30, 30, 30),
        Border = Color3.fromRGB(40, 40, 40),
        Accent = Color3.fromRGB(170, 95, 255),
        AccentDark = Color3.fromRGB(120, 60, 200),
        Text = Color3.fromRGB(220, 220, 220),
        TextDark = Color3.fromRGB(100, 100, 100),
        Toggle = Color3.fromRGB(50, 50, 50),
        ToggleEnabled = Color3.fromRGB(170, 95, 255),
        Glow = Color3.fromRGB(170, 95, 255),
        Status = Color3.fromRGB(80, 255, 120),
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Header = Color3.fromRGB(230, 230, 230),
        Element = Color3.fromRGB(255, 255, 255),
        ElementHover = Color3.fromRGB(245, 245, 245),
        Border = Color3.fromRGB(200, 200, 200),
        Accent = Color3.fromRGB(100, 50, 200),
        AccentDark = Color3.fromRGB(80, 40, 160),
        Text = Color3.fromRGB(30, 30, 30),
        TextDark = Color3.fromRGB(120, 120, 120),
        Toggle = Color3.fromRGB(220, 220, 220),
        ToggleEnabled = Color3.fromRGB(100, 50, 200),
        Glow = Color3.fromRGB(100, 50, 200),
        Status = Color3.fromRGB(50, 180, 100),
    },
    Blue = {
        Background = Color3.fromRGB(10, 15, 25),
        Header = Color3.fromRGB(15, 20, 30),
        Element = Color3.fromRGB(20, 25, 35),
        ElementHover = Color3.fromRGB(25, 35, 45),
        Border = Color3.fromRGB(30, 50, 70),
        Accent = Color3.fromRGB(60, 150, 255),
        AccentDark = Color3.fromRGB(40, 120, 200),
        Text = Color3.fromRGB(220, 230, 240),
        TextDark = Color3.fromRGB(100, 120, 140),
        Toggle = Color3.fromRGB(40, 50, 60),
        ToggleEnabled = Color3.fromRGB(60, 150, 255),
        Glow = Color3.fromRGB(60, 150, 255),
        Status = Color3.fromRGB(80, 255, 120),
    },
    Purple = {
        Background = Color3.fromRGB(15, 10, 20),
        Header = Color3.fromRGB(20, 15, 25),
        Element = Color3.fromRGB(25, 20, 30),
        ElementHover = Color3.fromRGB(35, 25, 40),
        Border = Color3.fromRGB(50, 30, 70),
        Accent = Color3.fromRGB(170, 95, 255),
        AccentDark = Color3.fromRGB(120, 60, 200),
        Text = Color3.fromRGB(230, 220, 240),
        TextDark = Color3.fromRGB(120, 100, 140),
        Toggle = Color3.fromRGB(50, 40, 60),
        ToggleEnabled = Color3.fromRGB(170, 95, 255),
        Glow = Color3.fromRGB(170, 95, 255),
        Status = Color3.fromRGB(200, 100, 255),
    },
    Red = {
        Background = Color3.fromRGB(20, 10, 10),
        Header = Color3.fromRGB(25, 15, 15),
        Element = Color3.fromRGB(30, 20, 20),
        ElementHover = Color3.fromRGB(40, 25, 25),
        Border = Color3.fromRGB(70, 30, 30),
        Accent = Color3.fromRGB(255, 80, 80),
        AccentDark = Color3.fromRGB(200, 50, 50),
        Text = Color3.fromRGB(240, 220, 220),
        TextDark = Color3.fromRGB(140, 100, 100),
        Toggle = Color3.fromRGB(60, 40, 40),
        ToggleEnabled = Color3.fromRGB(255, 80, 80),
        Glow = Color3.fromRGB(255, 80, 80),
        Status = Color3.fromRGB(255, 120, 120),
    },
}

-- Current Theme (copy of Dark, not a reference)
local Theme = {}
for key, value in pairs(ThemePresets.Dark) do
    Theme[key] = value
end

-- Utility functions
local function create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local t = TweenService:Create(instance, tweenInfo, properties)
    t:Play()
    return t
end

-- Theme application helper
local function applyTheme(themeName)
    if ThemePresets[themeName] then
        for key, value in pairs(ThemePresets[themeName]) do
            Theme[key] = value
        end
        return true
    end
    return false
end

-- Main Library
function LUI:CreateWindow(title)
    local window = {}
    local menuVisible = true
    
    -- Main GUI
    local screenGui = create("ScreenGui", {
        Name = "LUI_" .. title,
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    -- Watermark - auto-sizes to fit text
    local watermarkPosition = "left" -- "left" or "right"
    local watermark = create("Frame", {
        Name = "Watermark",
        Parent = screenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 10, 0, 10),
        AnchorPoint = Vector2.new(0, 0),
        Size = UDim2.new(0, 0, 0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 0.1
    })
    
    create("UIPadding", {
        Parent = watermark,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    create("UICorner", {
        Parent = watermark,
        CornerRadius = UDim.new(0, 4)
    })
    
    create("UIStroke", {
        Parent = watermark,
        Color = Theme.Accent,
        Thickness = 1,
        Transparency = 0.5
    })
    
    local watermarkText = create("TextLabel", {
        Parent = watermark,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Font = Enum.Font.Code,
        Text = game.Players.LocalPlayer.Name .. " | " .. string.upper(title) .. " | --ms",
        TextColor3 = Theme.Text,
        TextSize = 12
    })
    
    -- Update watermark with ping/fps
    local lastUpdate = 0
    RunService.Heartbeat:Connect(function()
        lastUpdate = lastUpdate + 1
        if lastUpdate >= 30 then -- Update every ~0.5 sec
            lastUpdate = 0
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            local fps = math.floor(1 / RunService.Heartbeat:Wait())
            watermarkText.Text = game.Players.LocalPlayer.Name .. " | " .. string.upper(title) .. " | " .. ping .. "ms | " .. fps .. "fps"
        end
    end)
    
    local mainFrame = create("Frame", {
        Name = "MainFrame",
        Parent = screenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -220, 0.5, -170),
        Size = UDim2.new(0, 440, 0, 340),
        ClipsDescendants = true
    })
    
    -- Drop shadow/glow effect
    local shadow = create("ImageLabel", {
        Name = "Shadow",
        Parent = mainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = -1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277)
    })
    
    -- Outer border with glow
    local mainStroke = create("UIStroke", {
        Parent = mainFrame,
        Color = Theme.Border,
        Thickness = 1
    })
    
    -- Top accent line with gradient animation
    local accentLine = create("Frame", {
        Name = "AccentLine",
        Parent = mainFrame,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2)
    })
    
    -- Animated glow bar that moves across
    local glowBar = create("Frame", {
        Name = "GlowBar",
        Parent = accentLine,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.new(-0.2, 0, 0, 0),
        Size = UDim2.new(0.2, 0, 1, 0)
    })
    
    create("UIGradient", {
        Parent = glowBar,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
    })
    
    -- Animate the glow bar
    task.spawn(function()
        while glowBar and glowBar.Parent do
            glowBar.Position = UDim2.new(-0.2, 0, 0, 0)
            tween(glowBar, {Position = UDim2.new(1, 0, 0, 0)}, 2)
            task.wait(3)
        end
    end)
    
    -- Title bar
    local titleBar = create("Frame", {
        Name = "TitleBar",
        Parent = mainFrame,
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 2),
        Size = UDim2.new(1, 0, 0, 28)
    })
    
    local titleLabel = create("TextLabel", {
        Name = "Title",
        Parent = titleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.Code,
        Text = string.upper(title),
        TextColor3 = Theme.Accent,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Status indicator
    local statusFrame = create("Frame", {
        Name = "Status",
        Parent = titleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0)
    })
    
    local statusDot = create("Frame", {
        Parent = statusFrame,
        BackgroundColor3 = Theme.Status,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 100, 0.5, -4),
        Size = UDim2.new(0, 8, 0, 8)
    })
    
    create("UICorner", {
        Parent = statusDot,
        CornerRadius = UDim.new(1, 0)
    })
    
    local statusLabel = create("TextLabel", {
        Parent = statusFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 115, 0, 0),
        Size = UDim2.new(1, -112, 1, 0),
        Font = Enum.Font.Code,
        Text = "UNDETECTED",
        TextColor3 = Theme.Status,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Pulse animation for status dot
    task.spawn(function()
        while statusDot and statusDot.Parent do
            tween(statusDot, {BackgroundTransparency = 0.5}, 0.8)
            task.wait(0.8)
            tween(statusDot, {BackgroundTransparency = 0}, 0.8)
            task.wait(0.8)
        end
    end)
    
    -- Version/branding
    local brandLabel = create("TextLabel", {
        Name = "Brand",
        Parent = titleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0, 0),
        Size = UDim2.new(0, 50, 1, 0),
        Font = Enum.Font.Code,
        Text = "v2.0",
        TextColor3 = Theme.TextDark,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    -- Close button (minimize to tray style)
    local closeBtn = create("TextButton", {
        Name = "Close",
        Parent = titleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -22, 0, 0),
        Size = UDim2.new(0, 22, 1, 0),
        Font = Enum.Font.Code,
        Text = "×",
        TextColor3 = Theme.TextDark,
        TextSize = 16
    })
    
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {TextColor3 = Color3.fromRGB(255, 80, 80)})
    end)
    
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {TextColor3 = Theme.TextDark})
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tab bar container
    local tabBar = create("Frame", {
        Name = "TabBar",
        Parent = mainFrame,
        BackgroundColor3 = Theme.Header,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 28)
    })
    
    create("Frame", {
        Name = "BottomBorder",
        Parent = tabBar,
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1)
    })
    
    local tabButtonContainer = create("Frame", {
        Name = "TabButtons",
        Parent = tabBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -16, 1, 0)
    })
    
    create("UIListLayout", {
        Parent = tabButtonContainer,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })
    
    -- Tab content container (holds all tab pages)
    local tabContainer = create("Frame", {
        Name = "TabContainer",
        Parent = mainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 58),
        Size = UDim2.new(1, 0, 1, -58),
        ClipsDescendants = true
    })
    
    -- UIScale for proportional scaling
    local uiScale = create("UIScale", {
        Name = "Scale",
        Parent = mainFrame,
        Scale = 1
    })
    
    -- Resize handle (bottom-right corner) - positioned outside UIScale influence
    local resizeHandle = create("Frame", {
        Name = "ResizeHandle",
        Parent = mainFrame,
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, 0),
        Size = UDim2.new(0, 18, 0, 18),
        ZIndex = 10
    })
    
    -- Resize handle visual (diagonal grip lines)
    for i = 0, 2 do
        create("Frame", {
            Parent = resizeHandle,
            BackgroundColor3 = Theme.Border,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 2 - i * 3, 0.5, -2 + i * 3),
            Size = UDim2.new(0, 10 - i * 2, 0, 2),
            Rotation = -45,
            ZIndex = 10
        })
    end
    
    -- Scale logic
    local resizing = false
    local resizeStart, scaleStart
    local baseSize = Vector2.new(440, 340) -- Original window size
    local minScale = 0.7
    local maxScale = 1.5
    local currentScale = 1
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            scaleStart = currentScale
        end
    end)
    
    resizeHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            -- Use diagonal movement for scaling (average of X and Y delta)
            local scaleDelta = (delta.X + delta.Y) / 2 / 900
            currentScale = math.clamp(scaleStart + scaleDelta, minScale, maxScale)
            
            -- Apply scale
            uiScale.Scale = currentScale
            
            -- Update mainFrame size to match scaled content
            mainFrame.Size = UDim2.new(0, baseSize.X * currentScale, 0, baseSize.Y * currentScale)
        end
    end)
    
    -- Visual feedback on hover
    resizeHandle.MouseEnter:Connect(function()
        for _, child in pairs(resizeHandle:GetChildren()) do
            if child:IsA("Frame") then
                tween(child, {BackgroundColor3 = Theme.Accent})
            end
        end
    end)
    
    resizeHandle.MouseLeave:Connect(function()
        if not resizing then
            for _, child in pairs(resizeHandle:GetChildren()) do
                if child:IsA("Frame") then
                    tween(child, {BackgroundColor3 = Theme.Border})
                end
            end
        end
    end)
    
    -- Tab management
    local tabs = {}
    local activeTab = nil
    local dropdownLists = {} -- Track all dropdown lists for theme updates
    
    -- Add Tab function
    function window:AddTab(name)
        local tab = {}
        
        -- Tab button
        local tabButton = create("TextButton", {
            Name = name .. "Tab",
            Parent = tabButtonContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 70, 1, 0),
            Font = Enum.Font.Code,
            Text = string.upper(name),
            TextColor3 = Theme.TextDark,
            TextSize = 11,
            AutoButtonColor = false
        })
        
        -- Active indicator (bottom line)
        local indicator = create("Frame", {
            Name = "Indicator",
            Parent = tabButton,
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, -2),
            Size = UDim2.new(1, 0, 0, 2),
            Visible = false
        })
        
        -- Tab content (scrollable)
        local contentFrame = create("ScrollingFrame", {
            Name = name .. "Content",
            Parent = tabContainer,
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 8, 0, 0),
            Size = UDim2.new(1, -16, 1, -8),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        })
        
        create("UIListLayout", {
            Parent = contentFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4)
        })
        
        -- Tab switching logic with animations
        local function selectTab()
            if activeTab == tab then return end
            
            local previousTab = activeTab
            local tabIndex = 0
            local previousIndex = 0
            
            -- Find indices for animation direction
            for i, t in ipairs(tabs) do
                if t == tab then tabIndex = i end
                if t == previousTab then previousIndex = i end
            end
            
            -- Determine slide direction (1 = right to left, -1 = left to right)
            local direction = (tabIndex > previousIndex) and 1 or -1
            
            -- Animate out previous tab
            if previousTab and previousTab.content then
                local outContent = previousTab.content
                tween(outContent, {Position = UDim2.new(-direction * 0.1, 8, 0, 0)}, 0.15)
                tween(outContent, {BackgroundTransparency = 1}, 0.1)
                task.delay(0.15, function()
                    if activeTab ~= previousTab then
                        outContent.Visible = false
                        outContent.Position = UDim2.new(0, 8, 0, 0)
                    end
                end)
            end
            
            -- Deselect all tab buttons
            for _, t in pairs(tabs) do
                tween(t.button, {TextColor3 = Theme.TextDark}, 0.1)
                t.indicator.Visible = false
            end
            
            -- Animate in new tab
            contentFrame.Position = UDim2.new(direction * 0.1, 8, 0, 0)
            contentFrame.Visible = true
            tween(contentFrame, {Position = UDim2.new(0, 8, 0, 0)}, 0.2)
            
            -- Select this tab
            tween(tabButton, {TextColor3 = Theme.Text}, 0.1)
            indicator.Visible = true
            
            -- Animate indicator
            indicator.Size = UDim2.new(0, 0, 0, 2)
            indicator.Position = UDim2.new(0.5, 0, 1, -2)
            tween(indicator, {Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2)}, 0.2)
            
            activeTab = tab
        end
        
        tabButton.MouseButton1Click:Connect(selectTab)
        
        tabButton.MouseEnter:Connect(function()
            if activeTab ~= tab then
                tween(tabButton, {TextColor3 = Theme.Text})
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if activeTab ~= tab then
                tween(tabButton, {TextColor3 = Theme.TextDark})
            end
        end)
        
        -- Store references
        tab.button = tabButton
        tab.indicator = indicator
        tab.content = contentFrame
        
        -- Element creation functions for this tab
        function tab:AddSection(text)
            local sectionFrame = create("Frame", {
                Name = "Section",
                Parent = contentFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 22)
            })
            
            create("Frame", {
                Parent = sectionFrame,
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0, 8, 0, 1)
            })
            
            create("TextLabel", {
                Parent = sectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -12, 1, 0),
                Font = Enum.Font.SourceSansBold,
                Text = string.upper(text),
                TextColor3 = Theme.Accent,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return sectionFrame
        end
        
        function tab:AddButton(text, callback)
            local button = create("TextButton", {
                Name = text,
                Parent = contentFrame,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 28),
                Font = Enum.Font.SourceSans,
                Text = "  " .. text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false
            })
            
            create("UIStroke", {
                Parent = button,
                Color = Theme.Border,
                Thickness = 1
            })
            
            button.MouseEnter:Connect(function()
                tween(button, {BackgroundColor3 = Theme.ElementHover})
            end)
            
            button.MouseLeave:Connect(function()
                tween(button, {BackgroundColor3 = Theme.Element})
            end)
            
            button.MouseButton1Click:Connect(function()
                button.BackgroundColor3 = Theme.Accent
                tween(button, {BackgroundColor3 = Theme.Element}, 0.3)
                if callback then callback() end
            end)
            
            return button
        end
        
        function tab:AddToggle(text, default, callback)
            local toggled = default or false
            
            local toggleFrame = create("Frame", {
                Name = text,
                Parent = contentFrame,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 28)
            })
            
            create("UIStroke", {
                Parent = toggleFrame,
                Color = Theme.Border,
                Thickness = 1
            })
            
            local checkbox = create("Frame", {
                Parent = toggleFrame,
                BackgroundColor3 = toggled and Theme.ToggleEnabled or Theme.Toggle,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 8, 0.5, -7),
                Size = UDim2.new(0, 14, 0, 14)
            })
            
            create("UIStroke", {
                Parent = checkbox,
                Color = toggled and Theme.Accent or Theme.Border,
                Thickness = 1
            })
            
            local checkmark = create("TextLabel", {
                Parent = checkbox,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.SourceSansBold,
                Text = toggled and "✓" or "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12
            })
            
            create("TextLabel", {
                Parent = toggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 30, 0, 0),
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local clickBtn = create("TextButton", {
                Parent = toggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local function updateToggle()
                tween(checkbox, {BackgroundColor3 = toggled and Theme.ToggleEnabled or Theme.Toggle})
                checkbox:FindFirstChildOfClass("UIStroke").Color = toggled and Theme.Accent or Theme.Border
                checkmark.Text = toggled and "✓" or ""
            end
            
            clickBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
                if callback then callback(toggled) end
            end)
            
            return {
                Set = function(value)
                    toggled = value
                    updateToggle()
                end,
                Get = function()
                    return toggled
                end
            }
        end
        
        function tab:AddSlider(text, min, max, default, callback)
            local value = default or min
            
            local sliderFrame = create("Frame", {
                Name = text,
                Parent = contentFrame,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 38)
            })
            
            create("UIStroke", {
                Parent = sliderFrame,
                Color = Theme.Border,
                Thickness = 1
            })
            
            create("TextLabel", {
                Parent = sliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 2),
                Size = UDim2.new(0.7, 0, 0, 16),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local valueLabel = create("TextLabel", {
                Parent = sliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.7, 0, 0, 2),
                Size = UDim2.new(0.3, -8, 0, 16),
                Font = Enum.Font.SourceSans,
                Text = tostring(value),
                TextColor3 = Theme.Accent,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local sliderBg = create("Frame", {
                Parent = sliderFrame,
                BackgroundColor3 = Theme.Toggle,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 8, 0, 22),
                Size = UDim2.new(1, -16, 0, 8)
            })
            
            local sliderFill = create("Frame", {
                Parent = sliderBg,
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            })
            
            local sliding = false
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                valueLabel.Text = tostring(value)
                tween(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                if callback then callback(value) end
            end
            
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    updateSlider(input)
                end
            end)
            
            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            return {
                Set = function(newValue)
                    value = math.clamp(newValue, min, max)
                    valueLabel.Text = tostring(value)
                    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                end,
                Get = function()
                    return value
                end
            }
        end
        
        function tab:AddTextbox(text, placeholder, callback)
            local textboxFrame = create("Frame", {
                Name = text,
                Parent = contentFrame,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 28)
            })
            
            create("UIStroke", {
                Parent = textboxFrame,
                Color = Theme.Border,
                Thickness = 1
            })
            
            create("TextLabel", {
                Parent = textboxFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local textbox = create("TextBox", {
                Parent = textboxFrame,
                BackgroundColor3 = Theme.Toggle,
                BorderSizePixel = 0,
                Position = UDim2.new(0.4, 4, 0, 4),
                Size = UDim2.new(0.6, -12, 1, -8),
                Font = Enum.Font.SourceSans,
                PlaceholderText = placeholder or "",
                Text = "",
                TextColor3 = Theme.Text,
                PlaceholderColor3 = Theme.TextDark,
                TextSize = 12,
                ClearTextOnFocus = false
            })
            
            textbox.FocusLost:Connect(function(enterPressed)
                if callback then callback(textbox.Text, enterPressed) end
            end)
            
            return textbox
        end
        
        function tab:AddLabel(text, fontSize, alignment)
            fontSize = fontSize or 12
            alignment = alignment or "left"
            
            local textAlign = Enum.TextXAlignment.Left
            local textPrefix = "  "
            if alignment == "center" then
                textAlign = Enum.TextXAlignment.Center
                textPrefix = ""
            elseif alignment == "right" then
                textAlign = Enum.TextXAlignment.Right
                textPrefix = ""
            end
            
            local label = create("TextLabel", {
                Name = "Label",
                Parent = contentFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, fontSize + 6),
                Font = Enum.Font.SourceSans,
                Text = textPrefix .. text,
                TextColor3 = Theme.TextDark,
                TextSize = fontSize,
                TextXAlignment = textAlign
            })
            
            return {
                Set = function(newText)
                    label.Text = textPrefix .. newText
                end
            }
        end
        
        function tab:AddSeparator()
            return create("Frame", {
                Name = "Separator",
                Parent = contentFrame,
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1)
            })
        end
        
        function tab:AddKeybind(text, default, callback)
            local keybind = default or Enum.KeyCode.Unknown
            local listening = false
            
            local keybindFrame = create("Frame", {
                Name = text,
                Parent = contentFrame,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 28)
            })
            
            create("UIStroke", {
                Parent = keybindFrame,
                Color = Theme.Border,
                Thickness = 1
            })
            
            create("TextLabel", {
                Parent = keybindFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local keyBtn = create("TextButton", {
                Parent = keybindFrame,
                BackgroundColor3 = Theme.Toggle,
                BorderSizePixel = 0,
                Position = UDim2.new(0.6, 4, 0, 4),
                Size = UDim2.new(0.4, -12, 1, -8),
                Font = Enum.Font.SourceSans,
                Text = keybind ~= Enum.KeyCode.Unknown and keybind.Name or "None",
                TextColor3 = Theme.Text,
                TextSize = 11,
                AutoButtonColor = false
            })
            
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
            end)
            
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    listening = false
                    keybind = input.KeyCode
                    keyBtn.Text = keybind.Name
                end
                
                if not gameProcessed and input.KeyCode == keybind and callback then
                    callback()
                end
            end)
            
            return {
                Set = function(key)
                    keybind = key
                    keyBtn.Text = keybind.Name
                end,
                Get = function()
                    return keybind
                end
            }
        end
        
        function tab:AddList(text, options, callback)
            local selected = options[1] or ""
            local expanded = false
            
            local listFrame = create("Frame", {
                Name = text,
                Parent = contentFrame,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 28),
                ZIndex = 10
            })
            
            create("UIStroke", {
                Parent = listFrame,
                Color = Theme.Border,
                Thickness = 1
            })
            
            create("TextLabel", {
                Parent = listFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(0.4, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local dropdownBtn = create("TextButton", {
                Parent = listFrame,
                BackgroundColor3 = Theme.Toggle,
                BorderSizePixel = 0,
                Position = UDim2.new(0.4, 4, 0, 4),
                Size = UDim2.new(0.6, -12, 1, -8),
                Font = Enum.Font.SourceSans,
                Text = selected .. " ▼",
                TextColor3 = Theme.Text,
                TextSize = 12,
                AutoButtonColor = false
            })
            
            -- Dropdown list parented to screenGui for proper layering
            local dropdownList = create("Frame", {
                Parent = screenGui,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 0, 0, #options * 24),
                Visible = false,
                ZIndex = 10000
            })
            
            -- Track this dropdown for theme updates
            table.insert(dropdownLists, dropdownList)
            
            create("UIStroke", {
                Parent = dropdownList,
                Color = Theme.Border,
                Thickness = 1
            })
            
            create("UIListLayout", {
                Parent = dropdownList,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 0)
            })
            
            -- Function to update dropdown position
            local function updateDropdownPosition()
                local btnPos = dropdownBtn.AbsolutePosition
                local btnSize = dropdownBtn.AbsoluteSize
                dropdownList.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + btnSize.Y + 2)
                dropdownList.Size = UDim2.new(0, btnSize.X, 0, #options * 24)
            end
            
            for _, option in ipairs(options) do
                local optionBtn = create("TextButton", {
                    Parent = dropdownList,
                    BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 24),
                    Font = Enum.Font.SourceSans,
                    Text = option,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    AutoButtonColor = false,
                    ZIndex = 10001
                })


                optionBtn.MouseEnter:Connect(function()
                    tween(optionBtn, {BackgroundColor3 = Theme.ElementHover})
                end)
                
                optionBtn.MouseLeave:Connect(function()
                    tween(optionBtn, {BackgroundColor3 = Theme.Element})
                end)
                
                optionBtn.MouseButton1Click:Connect(function()
                    selected = option
                    dropdownBtn.Text = selected .. " ▼"
                    expanded = false
                    dropdownList.Visible = false
                    if callback then callback(selected) end
                end)
            end
            
            dropdownBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    updateDropdownPosition()
                end
                dropdownList.Visible = expanded
                dropdownBtn.Text = selected .. (expanded and " ▲" or " ▼")
            end)
            
            -- Close dropdown when clicking elsewhere
            UserInputService.InputBegan:Connect(function(input)
                if expanded and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = input.Position
                    local listPos = dropdownList.AbsolutePosition
                    local listSize = dropdownList.AbsoluteSize
                    local btnPos = dropdownBtn.AbsolutePosition
                    local btnSize = dropdownBtn.AbsoluteSize
                    
                    -- Check if click is outside dropdown and button
                    local inList = mousePos.X >= listPos.X and mousePos.X <= listPos.X + listSize.X and
                                   mousePos.Y >= listPos.Y and mousePos.Y <= listPos.Y + listSize.Y
                    local inBtn = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X and
                                  mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
                    
                    if not inList and not inBtn then
                        expanded = false
                        dropdownList.Visible = false
                        dropdownBtn.Text = selected .. " ▼"
                    end
                end
            end)
            
            return {
                Set = function(value)
                    selected = value
                    dropdownBtn.Text = selected .. " ▼"
                end,
                Get = function()
                    return selected
                end
            }
        end
        
        function tab:AddColorPicker(text, default, callback, defaultAlpha)
            local currentColor = default or Color3.fromRGB(255, 255, 255)
            local initHue, initSat, initVal = currentColor:ToHSV()
            -- For achromatic colors (white/gray/black), hue is undefined - default to 0 (red)
            local currentHue = (initSat > 0.01) and initHue or 0
            local currentSat = initSat
            local currentVal = initVal
            local currentAlpha = defaultAlpha or 0 -- 0 = fully opaque, 1 = fully transparent
            local pickerOpen = false
            local copiedColor = nil -- Static variable for copied color
            
            local colorFrame = create("Frame", {
                Name = text,
                Parent = contentFrame,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 28),
                ZIndex = 5
            })
            
            create("UIStroke", {
                Parent = colorFrame,
                Color = Theme.Border,
                Thickness = 1
            })
            
            create("TextLabel", {
                Parent = colorFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 8, 0, 0),
                Size = UDim2.new(0.6, 0, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            -- Color preview button
            local colorPreview = create("TextButton", {
                Parent = colorFrame,
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
                Position = UDim2.new(1, -68, 0, 4),
                Size = UDim2.new(0, 60, 0, 20),
                Text = "",
                AutoButtonColor = false
            })
            
            create("UICorner", {
                Parent = colorPreview,
                CornerRadius = UDim.new(0, 4)
            })
            
            create("UIStroke", {
                Parent = colorPreview,
                Color = Theme.Border,
                Thickness = 1
            })
            
            -- Hex display
            local hexLabel = create("TextLabel", {
                Parent = colorPreview,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Code,
                Text = string.format("#%02X%02X%02X", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)),
                TextColor3 = Color3.new(1, 1, 1),
                TextStrokeColor3 = Color3.new(0, 0, 0),
                TextStrokeTransparency = 0.5,
                TextSize = 10
            })
            
            -- Color picker panel (parented to screenGui for proper layering)
            local pickerPanel = create("Frame", {
                Parent = screenGui,
                BackgroundColor3 = Theme.Element,
                BorderSizePixel = 0,
                Size = UDim2.new(0, 200, 0, 200),
                Visible = false,
                ZIndex = 10000
            })
            
            create("UICorner", {
                Parent = pickerPanel,
                CornerRadius = UDim.new(0, 6)
            })
            
            create("UIStroke", {
                Parent = pickerPanel,
                Color = Theme.Border,
                Thickness = 1
            })
            
            -- Shadow for picker
            local pickerShadow = create("ImageLabel", {
                Parent = pickerPanel,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, -10, 0, -10),
                Size = UDim2.new(1, 20, 1, 20),
                ZIndex = 9999,
                Image = "rbxassetid://5554236805",
                ImageColor3 = Color3.fromRGB(0, 0, 0),
                ImageTransparency = 0.6,
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(23, 23, 277, 277)
            })
            
            -- Saturation/Value picker (main color square)
            local satValPicker = create("ImageButton", {
                Parent = pickerPanel,
                BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0, 150, 0, 100),
                AutoButtonColor = false,
                ZIndex = 10001
            })
            
            create("UICorner", {
                Parent = satValPicker,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Saturation gradient (white to color)
            local satGradient = create("UIGradient", {
                Parent = satValPicker,
                Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
            
            -- Value overlay (transparent to black)
            local valOverlay = create("Frame", {
                Parent = satValPicker,
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 10002
            })
            
            create("UICorner", {
                Parent = valOverlay,
                CornerRadius = UDim.new(0, 4)
            })
            
            create("UIGradient", {
                Parent = valOverlay,
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                })
            })
            
            -- Sat/Val cursor
            local satValCursor = create("Frame", {
                Parent = satValPicker,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(math.max(0.001, currentSat), 0, math.max(0.001, 1 - currentVal), 0),
                Size = UDim2.new(0, 12, 0, 12),
                ZIndex = 10003
            })
            
            -- Inner dot for better visibility
            local cursorInner = create("Frame", {
                Parent = satValCursor,
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 6, 0, 6),
                ZIndex = 10004
            })
            
            create("UICorner", {
                Parent = cursorInner,
                CornerRadius = UDim.new(1, 0)
            })
            
            create("UICorner", {
                Parent = satValCursor,
                CornerRadius = UDim.new(1, 0)
            })
            
            create("UIStroke", {
                Parent = satValCursor,
                Color = Color3.new(0, 0, 0),
                Thickness = 2
            })
            
            -- Hue slider
            local hueSlider = create("ImageButton", {
                Parent = pickerPanel,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 170, 0, 10),
                Size = UDim2.new(0, 20, 0, 100),
                AutoButtonColor = false,
                ZIndex = 10001
            })
            
            create("UICorner", {
                Parent = hueSlider,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Rainbow gradient for hue
            create("UIGradient", {
                Parent = hueSlider,
                Rotation = 90,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
            })
            
            -- Hue cursor
            local hueCursor = create("Frame", {
                Parent = hueSlider,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, currentHue, 0),
                Size = UDim2.new(1, 4, 0, 6),
                ZIndex = 10002
            })
            
            create("UICorner", {
                Parent = hueCursor,
                CornerRadius = UDim.new(0, 2)
            })
            
            create("UIStroke", {
                Parent = hueCursor,
                Color = Color3.new(0, 0, 0),
                Thickness = 1
            })
            
            -- RGB input fields
            local rgbContainer = create("Frame", {
                Parent = pickerPanel,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 115),
                Size = UDim2.new(1, -20, 0, 20),
                ZIndex = 10001
            })
            
            local function createRGBInput(label, offsetX, getValue, setValue)
                local container = create("Frame", {
                    Parent = rgbContainer,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, offsetX, 0, 0),
                    Size = UDim2.new(0, 55, 0, 20),
                    ZIndex = 10001
                })
                
                create("TextLabel", {
                    Parent = container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 15, 1, 0),
                    Font = Enum.Font.Code,
                    Text = label,
                    TextColor3 = Theme.Text,
                    TextSize = 11,
                    ZIndex = 10001
                })
                
                local input = create("TextBox", {
                    Parent = container,
                    BackgroundColor3 = Theme.Toggle,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 18, 0, 0),
                    Size = UDim2.new(0, 35, 1, 0),
                    Font = Enum.Font.Code,
                    Text = tostring(getValue()),
                    TextColor3 = Theme.Text,
                    TextSize = 11,
                    ClearTextOnFocus = true,
                    ZIndex = 10002
                })
                
                create("UICorner", {
                    Parent = input,
                    CornerRadius = UDim.new(0, 3)
                })
                
                input.FocusLost:Connect(function()
                    local num = tonumber(input.Text)
                    if num then
                        num = math.clamp(math.floor(num), 0, 255)
                        input.Text = tostring(num)
                        setValue(num)
                    else
                        input.Text = tostring(getValue())
                    end
                end)
                
                return input
            end
            
            local rInput, gInput, bInput
            
            local function updateColorFromRGB()
                local r = tonumber(rInput.Text) or 0
                local g = tonumber(gInput.Text) or 0
                local b = tonumber(bInput.Text) or 0
                currentColor = Color3.fromRGB(r, g, b)
                local newHue, newSat, newVal = currentColor:ToHSV()
                -- Preserve hue for achromatic colors
                if newSat > 0.01 then currentHue = newHue end
                currentSat = newSat
                currentVal = newVal
                
                satValPicker.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                satValCursor.Position = UDim2.new(math.max(0.001, currentSat), 0, math.max(0.001, 1 - currentVal), 0)
                hueCursor.Position = UDim2.new(0.5, 0, currentHue, 0)
                colorPreview.BackgroundColor3 = currentColor
                cursorInner.BackgroundColor3 = currentColor
                alphaSliderFill.BackgroundColor3 = currentColor
                hexLabel.Text = string.format("#%02X%02X%02X", r, g, b)
                
                if callback then callback(currentColor, currentAlpha) end
            end
            
            rInput = createRGBInput("R", 0, function() return math.floor(currentColor.R * 255) end, function(v)
                currentColor = Color3.fromRGB(v, math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
                updateColorFromRGB()
            end)
            
            gInput = createRGBInput("G", 60, function() return math.floor(currentColor.G * 255) end, function(v)
                currentColor = Color3.fromRGB(math.floor(currentColor.R * 255), v, math.floor(currentColor.B * 255))
                updateColorFromRGB()
            end)
            
            bInput = createRGBInput("B", 120, function() return math.floor(currentColor.B * 255) end, function(v)
                currentColor = Color3.fromRGB(math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), v)
                updateColorFromRGB()
            end)
            
            -- Hex input
            local hexContainer = create("Frame", {
                Parent = pickerPanel,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 140),
                Size = UDim2.new(1, -20, 0, 20),
                ZIndex = 10001
            })
            
            create("TextLabel", {
                Parent = hexContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 25, 1, 0),
                Font = Enum.Font.Code,
                Text = "HEX",
                TextColor3 = Theme.Text,
                TextSize = 10,
                ZIndex = 10001
            })
            
            local hexInput = create("TextBox", {
                Parent = hexContainer,
                BackgroundColor3 = Theme.Toggle,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 28, 0, 0),
                Size = UDim2.new(0, 65, 1, 0),
                Font = Enum.Font.Code,
                Text = string.format("#%02X%02X%02X", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)),
                TextColor3 = Theme.Text,
                TextSize = 10,
                ClearTextOnFocus = false,
                ZIndex = 10002
            })
            
            create("UICorner", {
                Parent = hexInput,
                CornerRadius = UDim.new(0, 3)
            })
            
            hexInput.FocusLost:Connect(function()
                local hex = hexInput.Text:gsub("#", "")
                if #hex == 6 then
                    local r = tonumber(hex:sub(1, 2), 16)
                    local g = tonumber(hex:sub(3, 4), 16)
                    local b = tonumber(hex:sub(5, 6), 16)
                    if r and g and b then
                        currentColor = Color3.fromRGB(r, g, b)
                        local newHue, newSat, newVal = currentColor:ToHSV()
                        -- Preserve hue for achromatic colors
                        if newSat > 0.01 then currentHue = newHue end
                        currentSat = newSat
                        currentVal = newVal
                        
                        satValPicker.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                        satValCursor.Position = UDim2.new(math.max(0.001, currentSat), 0, math.max(0.001, 1 - currentVal), 0)
                        hueCursor.Position = UDim2.new(0.5, 0, currentHue, 0)
                        colorPreview.BackgroundColor3 = currentColor
                        cursorInner.BackgroundColor3 = currentColor
                        alphaSliderFill.BackgroundColor3 = currentColor
                        hexLabel.Text = "#" .. hex:upper()
                        rInput.Text = tostring(math.floor(currentColor.R * 255))
                        gInput.Text = tostring(math.floor(currentColor.G * 255))
                        bInput.Text = tostring(math.floor(currentColor.B * 255))
                        
                        if callback then callback(currentColor, currentAlpha) end
                        return
                    end
                end
                hexInput.Text = string.format("#%02X%02X%02X", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
            end)
            
            -- Copy/Paste buttons
            local copyBtn = create("TextButton", {
                Parent = hexContainer,
                BackgroundColor3 = Theme.Toggle,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 98, 0, 0),
                Size = UDim2.new(0, 40, 1, 0),
                Font = Enum.Font.Code,
                Text = "Copy",
                TextColor3 = Theme.Text,
                TextSize = 9,
                AutoButtonColor = false,
                ZIndex = 10002
            })
            
            create("UICorner", {
                Parent = copyBtn,
                CornerRadius = UDim.new(0, 3)
            })
            
            local pasteBtn = create("TextButton", {
                Parent = hexContainer,
                BackgroundColor3 = Theme.Toggle,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 142, 0, 0),
                Size = UDim2.new(0, 40, 1, 0),
                Font = Enum.Font.Code,
                Text = "Paste",
                TextColor3 = Theme.Text,
                TextSize = 9,
                AutoButtonColor = false,
                ZIndex = 10002
            })
            
            create("UICorner", {
                Parent = pasteBtn,
                CornerRadius = UDim.new(0, 3)
            })
            
            -- Transparency slider
            local alphaContainer = create("Frame", {
                Parent = pickerPanel,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 165),
                Size = UDim2.new(1, -20, 0, 25),
                ZIndex = 10001
            })
            
            create("TextLabel", {
                Parent = alphaContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 0),
                Size = UDim2.new(0, 55, 0, 12),
                Font = Enum.Font.Code,
                Text = "Opacity",
                TextColor3 = Theme.Text,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 10001
            })
            
            local alphaValueLabel = create("TextLabel", {
                Parent = alphaContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0, 0),
                Size = UDim2.new(0, 30, 0, 12),
                Font = Enum.Font.Code,
                Text = tostring(math.floor((1 - currentAlpha) * 100)) .. "%",
                TextColor3 = Theme.Accent,
                TextSize = 10,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 10001
            })
            
            -- Alpha slider background (checkerboard pattern simulated)
            local alphaSliderBg = create("Frame", {
                Parent = alphaContainer,
                BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 14),
                Size = UDim2.new(1, 0, 0, 10),
                ZIndex = 10001
            })
            
            create("UICorner", {
                Parent = alphaSliderBg,
                CornerRadius = UDim.new(0, 3)
            })
            
            -- Checkerboard pattern for transparency visualization
            local checkerPattern = create("Frame", {
                Parent = alphaSliderBg,
                BackgroundColor3 = Color3.fromRGB(120, 120, 120),
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 10002,
                ClipsDescendants = true
            })
            
            create("UICorner", {
                Parent = checkerPattern,
                CornerRadius = UDim.new(0, 3)
            })
            
            -- Create checkerboard effect
            for i = 0, 18 do
                local checker = create("Frame", {
                    Parent = checkerPattern,
                    BackgroundColor3 = Color3.fromRGB(180, 180, 180),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, i * 10 + (i % 2 == 0 and 0 or 5), 0, i % 2 == 0 and 0 or 5),
                    Size = UDim2.new(0, 5, 0, 5),
                    ZIndex = 10003
                })
            end
            
            -- Alpha slider fill (shows color fading to transparent)
            local alphaSliderFill = create("Frame", {
                Parent = alphaSliderBg,
                BackgroundColor3 = currentColor,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 10004
            })
            
            create("UICorner", {
                Parent = alphaSliderFill,
                CornerRadius = UDim.new(0, 3)
            })
            
            create("UIGradient", {
                Parent = alphaSliderFill,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1)
                })
            })
            
            -- Alpha slider cursor
            local alphaCursor = create("Frame", {
                Parent = alphaSliderBg,
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1 - currentAlpha, 0, 0.5, 0),
                Size = UDim2.new(0, 6, 0, 14),
                ZIndex = 10005
            })
            
            create("UICorner", {
                Parent = alphaCursor,
                CornerRadius = UDim.new(0, 2)
            })
            
            create("UIStroke", {
                Parent = alphaCursor,
                Color = Color3.new(0, 0, 0),
                Thickness = 1
            })
            
            -- Alpha slider interaction
            local draggingAlpha = false
            
            alphaSliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingAlpha = true
                    local relX = math.clamp((input.Position.X - alphaSliderBg.AbsolutePosition.X) / alphaSliderBg.AbsoluteSize.X, 0, 1)
                    currentAlpha = 1 - relX
                    alphaCursor.Position = UDim2.new(relX, 0, 0.5, 0)
                    alphaValueLabel.Text = tostring(math.floor((1 - currentAlpha) * 100)) .. "%"
                    if callback then callback(currentColor, currentAlpha) end
                end
            end)
            
            alphaSliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingAlpha = false
                end
            end)
            
            -- Shared clipboard for colors (stored in window scope)
            if not window._colorClipboard then
                window._colorClipboard = nil
            end
            
            if not window._alphaClipboard then
                window._alphaClipboard = 0
            end
            
            copyBtn.MouseEnter:Connect(function()
                tween(copyBtn, {BackgroundColor3 = Theme.ElementHover})
            end)
            copyBtn.MouseLeave:Connect(function()
                tween(copyBtn, {BackgroundColor3 = Theme.Toggle})
            end)
            
            pasteBtn.MouseEnter:Connect(function()
                tween(pasteBtn, {BackgroundColor3 = Theme.ElementHover})
            end)
            pasteBtn.MouseLeave:Connect(function()
                tween(pasteBtn, {BackgroundColor3 = Theme.Toggle})
            end)
            
            local function copyColor()
                window._colorClipboard = currentColor
                window._alphaClipboard = currentAlpha
                copyBtn.Text = "✓"
                tween(copyBtn, {BackgroundColor3 = Theme.Accent})
                task.delay(0.5, function()
                    copyBtn.Text = "Copy"
                    tween(copyBtn, {BackgroundColor3 = Theme.Toggle})
                end)
            end
            
            local function pasteColor()
                if window._colorClipboard then
                    currentColor = window._colorClipboard
                    currentAlpha = window._alphaClipboard or 0
                    local newHue, newSat, newVal = currentColor:ToHSV()
                    -- Preserve hue for achromatic colors
                    if newSat > 0.01 then currentHue = newHue end
                    currentSat = newSat
                    currentVal = newVal
                    
                    satValPicker.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                    satValCursor.Position = UDim2.new(math.max(0.001, currentSat), 0, math.max(0.001, 1 - currentVal), 0)
                    hueCursor.Position = UDim2.new(0.5, 0, currentHue, 0)
                    colorPreview.BackgroundColor3 = currentColor
                    cursorInner.BackgroundColor3 = currentColor
                    alphaSliderFill.BackgroundColor3 = currentColor
                    alphaCursor.Position = UDim2.new(1 - currentAlpha, 0, 0.5, 0)
                    alphaValueLabel.Text = tostring(math.floor((1 - currentAlpha) * 100)) .. "%"
                    
                    local r, g, b = math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)
                    hexLabel.Text = string.format("#%02X%02X%02X", r, g, b)
                    hexInput.Text = hexLabel.Text
                    rInput.Text = tostring(r)
                    gInput.Text = tostring(g)
                    bInput.Text = tostring(b)
                    
                    pasteBtn.Text = "✓"
                    tween(pasteBtn, {BackgroundColor3 = Theme.Accent})
                    task.delay(0.5, function()
                        pasteBtn.Text = "Paste"
                        tween(pasteBtn, {BackgroundColor3 = Theme.Toggle})
                    end)
                    
                    if callback then callback(currentColor, currentAlpha) end
                end
            end
            
            copyBtn.MouseButton1Click:Connect(copyColor)
            pasteBtn.MouseButton1Click:Connect(pasteColor)
            
            -- Update function for color changes
            local function updateColor()
                currentColor = Color3.fromHSV(currentHue, currentSat, currentVal)
                colorPreview.BackgroundColor3 = currentColor
                satValPicker.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                alphaSliderFill.BackgroundColor3 = currentColor
                
                -- Update cursor inner color to show selected color
                cursorInner.BackgroundColor3 = currentColor
                
                local r, g, b = math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)
                hexLabel.Text = string.format("#%02X%02X%02X", r, g, b)
                hexInput.Text = hexLabel.Text
                rInput.Text = tostring(r)
                gInput.Text = tostring(g)
                bInput.Text = tostring(b)
                
                if callback then callback(currentColor, currentAlpha) end
            end
            
            -- Sat/Val picker interaction
            local draggingSatVal = false
            
            satValPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSatVal = true
                end
            end)
            
            satValPicker.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSatVal = false
                end
            end)
            
            valOverlay.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSatVal = true
                end
            end)
            
            valOverlay.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSatVal = false
                end
            end)
            
            -- Hue slider interaction
            local draggingHue = false
            
            hueSlider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = true
                end
            end)
            
            hueSlider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if not pickerOpen then return end -- Only process when picker is open
                
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if draggingSatVal then
                        local pos = input.Position
                        local relX = math.clamp((pos.X - satValPicker.AbsolutePosition.X) / satValPicker.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((pos.Y - satValPicker.AbsolutePosition.Y) / satValPicker.AbsoluteSize.Y, 0, 1)
                        
                        currentSat = relX
                        currentVal = 1 - relY
                        satValCursor.Position = UDim2.new(relX, 0, relY, 0)
                        updateColor()
                    end
                    
                    if draggingHue then
                        local pos = input.Position
                        local relY = math.clamp((pos.Y - hueSlider.AbsolutePosition.Y) / hueSlider.AbsoluteSize.Y, 0, 1)
                        
                        currentHue = relY
                        hueCursor.Position = UDim2.new(0.5, 0, relY, 0)
                        updateColor()
                    end
                    
                    if draggingAlpha then
                        local pos = input.Position
                        local relX = math.clamp((pos.X - alphaSliderBg.AbsolutePosition.X) / alphaSliderBg.AbsoluteSize.X, 0, 1)
                        
                        currentAlpha = 1 - relX
                        alphaCursor.Position = UDim2.new(relX, 0, 0.5, 0)
                        alphaValueLabel.Text = tostring(math.floor((1 - currentAlpha) * 100)) .. "%"
                        if callback then callback(currentColor, currentAlpha) end
                    end
                end
            end)
            
            -- Position picker panel
            local function updatePickerPosition()
                local previewPos = colorPreview.AbsolutePosition
                local previewSize = colorPreview.AbsoluteSize
                pickerPanel.Position = UDim2.new(0, previewPos.X + previewSize.X - 200, 0, previewPos.Y + previewSize.Y + 5)
            end
            
            -- Refresh all visual elements to match current color
            local function refreshPickerVisuals()
                -- Use the preview color as the source of truth
                currentColor = colorPreview.BackgroundColor3
                local newHue, newSat, newVal = currentColor:ToHSV()
                
                -- For achromatic colors (white/gray/black), hue is undefined
                -- Keep the existing hue to avoid visual jumps, or default to 0 (red)
                if newSat > 0.01 then
                    currentHue = newHue
                end
                -- If saturation is very low (achromatic), keep currentHue as-is
                -- but if it's the first time, default to 0
                if currentHue == nil then currentHue = 0 end
                
                currentSat = newSat
                currentVal = newVal
                
                satValPicker.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                satValCursor.Position = UDim2.new(math.max(0.001, currentSat), 0, math.max(0.001, 1 - currentVal), 0)
                hueCursor.Position = UDim2.new(0.5, 0, currentHue, 0)
                cursorInner.BackgroundColor3 = currentColor
                alphaSliderFill.BackgroundColor3 = currentColor
                alphaCursor.Position = UDim2.new(1 - currentAlpha, 0, 0.5, 0)
                alphaValueLabel.Text = tostring(math.floor((1 - currentAlpha) * 100)) .. "%"
                
                local r, g, b = math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)
                hexLabel.Text = string.format("#%02X%02X%02X", r, g, b)
                hexInput.Text = hexLabel.Text
                rInput.Text = tostring(r)
                gInput.Text = tostring(g)
                bInput.Text = tostring(b)
            end
            
            -- Toggle picker on click
            colorPreview.MouseButton1Click:Connect(function()
                pickerOpen = not pickerOpen
                if pickerOpen then
                    updatePickerPosition()
                    refreshPickerVisuals()
                end
                pickerPanel.Visible = pickerOpen
            end)
            
            -- Right-click to copy color
            colorPreview.MouseButton2Click:Connect(function()
                if pickerOpen then
                    pasteColor()
                else
                    copyColor()
                end
            end)
            
            -- Close picker when clicking elsewhere
            UserInputService.InputBegan:Connect(function(input)
                if pickerOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = input.Position
                    local panelPos = pickerPanel.AbsolutePosition
                    local panelSize = pickerPanel.AbsoluteSize
                    local previewPos = colorPreview.AbsolutePosition
                    local previewSize = colorPreview.AbsoluteSize
                    
                    local inPanel = mousePos.X >= panelPos.X and mousePos.X <= panelPos.X + panelSize.X and
                                    mousePos.Y >= panelPos.Y and mousePos.Y <= panelPos.Y + panelSize.Y
                    local inPreview = mousePos.X >= previewPos.X and mousePos.X <= previewPos.X + previewSize.X and
                                      mousePos.Y >= previewPos.Y and mousePos.Y <= previewPos.Y + previewSize.Y
                    
                    if not inPanel and not inPreview then
                        pickerOpen = false
                        pickerPanel.Visible = false
                    end
                end
            end)
            
            -- Hover effects
            colorPreview.MouseEnter:Connect(function()
                tween(colorPreview:FindFirstChildOfClass("UIStroke"), {Color = Theme.Accent})
            end)
            
            colorPreview.MouseLeave:Connect(function()
                tween(colorPreview:FindFirstChildOfClass("UIStroke"), {Color = Theme.Border})
            end)
            
            return {
                Set = function(color, alpha)
                    currentColor = color
                    if alpha then currentAlpha = alpha end
                    local newHue, newSat, newVal = currentColor:ToHSV()
                    -- Preserve hue for achromatic colors
                    if newSat > 0.01 then currentHue = newHue end
                    currentSat = newSat
                    currentVal = newVal
                    colorPreview.BackgroundColor3 = currentColor
                    satValPicker.BackgroundColor3 = Color3.fromHSV(currentHue, 1, 1)
                    satValCursor.Position = UDim2.new(math.max(0.001, currentSat), 0, math.max(0.001, 1 - currentVal), 0)
                    hueCursor.Position = UDim2.new(0.5, 0, currentHue, 0)
                    cursorInner.BackgroundColor3 = currentColor
                    alphaSliderFill.BackgroundColor3 = currentColor
                    alphaCursor.Position = UDim2.new(1 - currentAlpha, 0, 0.5, 0)
                    alphaValueLabel.Text = tostring(math.floor((1 - currentAlpha) * 100)) .. "%"
                    
                    local r, g, b = math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255)
                    hexLabel.Text = string.format("#%02X%02X%02X", r, g, b)
                    hexInput.Text = hexLabel.Text
                    rInput.Text = tostring(r)
                    gInput.Text = tostring(g)
                    bInput.Text = tostring(b)
                end,
                Get = function()
                    return currentColor, currentAlpha
                end,
                GetAlpha = function()
                    return currentAlpha
                end,
                SetAlpha = function(alpha)
                    currentAlpha = alpha
                    alphaCursor.Position = UDim2.new(1 - currentAlpha, 0, 0.5, 0)
                    alphaValueLabel.Text = tostring(math.floor((1 - currentAlpha) * 100)) .. "%"
                end
            }
        end
        
        -- Add to tabs table
        table.insert(tabs, tab)
        
        -- Auto-select first tab
        if #tabs == 1 then
            selectTab()
        end
        
        return tab
    end

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Menu toggle keybind (Insert or RightShift to show/hide)
    local toggleKey = Enum.KeyCode.RightShift
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == toggleKey then
            menuVisible = not menuVisible
            if menuVisible then
                -- Simple fade in
                mainFrame.Visible = true
                mainFrame.BackgroundTransparency = 1
                mainStroke.Transparency = 1
                tween(mainFrame, {BackgroundTransparency = 0}, 0.2)
                tween(mainStroke, {Transparency = 0}, 0.2)
            else
                -- Fade out
                tween(mainFrame, {BackgroundTransparency = 1}, 0.15)
                tween(mainStroke, {Transparency = 1}, 0.15)
                task.delay(0.15, function()
                    if not menuVisible then
                        mainFrame.Visible = false
                    end
                end)
            end
        end
    end)
    
    -- Set toggle key function
    function window:SetToggleKey(key)
        toggleKey = key
    end
    
    -- Set watermark position ("left" or "right")
    function window:SetWatermarkPosition(position)
        position = string.lower(position)
        if position == "left" then
            watermarkPosition = "left"
            watermark.AnchorPoint = Vector2.new(0, 0)
            watermark.Position = UDim2.new(0, 10, 0, 10)
        elseif position == "right" then
            watermarkPosition = "right"
            watermark.AnchorPoint = Vector2.new(1, 0)
            watermark.Position = UDim2.new(1, -10, 0, 10)
        end
    end
    
    -- Show/hide watermark
    function window:SetWatermarkVisible(visible)
        watermark.Visible = visible
    end
    
    -- Destroy window
    function window:Destroy()
        screenGui:Destroy()
    end
    
    -- Apply theme function (updates all UI colors)
    function window:SetTheme(themeName)
        if not ThemePresets[themeName] then 
            warn("LUI: Invalid theme name: " .. tostring(themeName))
            return false 
        end
        
        -- Update theme table with new values
        local newTheme = ThemePresets[themeName]
        Theme.Background = newTheme.Background
        Theme.Header = newTheme.Header
        Theme.Element = newTheme.Element
        Theme.ElementHover = newTheme.ElementHover
        Theme.Border = newTheme.Border
        Theme.Accent = newTheme.Accent
        Theme.AccentDark = newTheme.AccentDark
        Theme.Text = newTheme.Text
        Theme.TextDark = newTheme.TextDark
        Theme.Toggle = newTheme.Toggle
        Theme.ToggleEnabled = newTheme.ToggleEnabled
        Theme.Glow = newTheme.Glow
        Theme.Status = newTheme.Status
        
        -- Update main frame colors
        mainFrame.BackgroundColor3 = Theme.Background
        mainStroke.Color = Theme.Border
        accentLine.BackgroundColor3 = Theme.Accent
        titleBar.BackgroundColor3 = Theme.Header
        titleLabel.TextColor3 = Theme.Accent
        statusDot.BackgroundColor3 = Theme.Status
        statusLabel.TextColor3 = Theme.Status
        brandLabel.TextColor3 = Theme.TextDark
        closeBtn.TextColor3 = Theme.TextDark
        tabBar.BackgroundColor3 = Theme.Header
        tabBar:FindFirstChild("BottomBorder").BackgroundColor3 = Theme.Border
        watermark.BackgroundColor3 = Theme.Background
        watermark:FindFirstChildOfClass("UIStroke").Color = Theme.Accent
        watermarkText.TextColor3 = Theme.Text
        
        -- Update resize handle
        for _, child in pairs(resizeHandle:GetChildren()) do
            if child:IsA("Frame") then
                child.BackgroundColor3 = Theme.Border
            end
        end
        
        -- Update all dropdowns (parented to screenGui)
        for _, dropdownList in pairs(dropdownLists) do
            if dropdownList and dropdownList.Parent then
                dropdownList.BackgroundColor3 = Theme.Element
                local listStroke = dropdownList:FindFirstChildOfClass("UIStroke")
                if listStroke then listStroke.Color = Theme.Border end
                -- Update option buttons inside dropdown
                for _, optionBtn in pairs(dropdownList:GetChildren()) do
                    if optionBtn:IsA("TextButton") then
                        optionBtn.BackgroundColor3 = Theme.Element
                        optionBtn.TextColor3 = Theme.Text
                    end
                end
            end
        end
        
        -- Update all tabs
        for _, tab in pairs(tabs) do
            tab.button.TextColor3 = (activeTab == tab) and Theme.Text or Theme.TextDark
            tab.indicator.BackgroundColor3 = Theme.Accent
            tab.content.BackgroundColor3 = Theme.Background
            tab.content.ScrollBarImageColor3 = Theme.Accent
            
            -- Update all elements in tab
            for _, element in pairs(tab.content:GetChildren()) do
                if element:IsA("Frame") then
                    if element.Name == "Section" then
                        for _, child in pairs(element:GetChildren()) do
                            if child:IsA("Frame") then
                                child.BackgroundColor3 = Theme.Border
                            elseif child:IsA("TextLabel") then
                                child.TextColor3 = Theme.Accent
                            end
                        end
                    elseif element.Name == "Separator" then
                        element.BackgroundColor3 = Theme.Border
                    else
                        element.BackgroundColor3 = Theme.Element
                        local stroke = element:FindFirstChildOfClass("UIStroke")
                        if stroke then stroke.Color = Theme.Border end
                        
                        for _, child in pairs(element:GetChildren()) do
                            if child:IsA("TextLabel") then
                                -- Check if this is a slider value label (right-aligned, shows number)
                                if child.TextXAlignment == Enum.TextXAlignment.Right then
                                    child.TextColor3 = Theme.Accent
                                elseif child.Name == "Label" then
                                    child.TextColor3 = Theme.TextDark
                                else
                                    child.TextColor3 = Theme.Text
                                end
                            elseif child:IsA("TextButton") then
                                child.TextColor3 = Theme.Text
                                if child.BackgroundTransparency < 1 then
                                    child.BackgroundColor3 = Theme.Toggle
                                end
                            elseif child:IsA("TextBox") then
                                child.BackgroundColor3 = Theme.Toggle
                                child.TextColor3 = Theme.Text
                                child.PlaceholderColor3 = Theme.TextDark
                            elseif child:IsA("Frame") then
                                -- Could be checkbox, slider bg, or dropdown list
                                if child.Size.Y.Offset == 14 then -- Checkbox
                                    -- Check if toggle is enabled by looking for checkmark
                                    local checkmark = child:FindFirstChildOfClass("TextLabel")
                                    local isEnabled = checkmark and checkmark.Text == "✓"
                                    child.BackgroundColor3 = isEnabled and Theme.ToggleEnabled or Theme.Toggle
                                    local checkStroke = child:FindFirstChildOfClass("UIStroke")
                                    if checkStroke then 
                                        checkStroke.Color = isEnabled and Theme.Accent or Theme.Border 
                                    end
                                elseif child.Size.Y.Offset == 8 then -- Slider bg
                                    child.BackgroundColor3 = Theme.Toggle
                                    local fill = child:FindFirstChildOfClass("Frame") or child:FindFirstChildOfClass("Frame")
                                    if fill then fill.BackgroundColor3 = Theme.Accent end
                                elseif child:FindFirstChildOfClass("UIListLayout") then -- Dropdown list
                                    child.BackgroundColor3 = Theme.Element
                                    local listStroke = child:FindFirstChildOfClass("UIStroke")
                                    if listStroke then listStroke.Color = Theme.Border end
                                    -- Update option buttons inside dropdown
                                    for _, optionBtn in pairs(child:GetChildren()) do
                                        if optionBtn:IsA("TextButton") then
                                            optionBtn.BackgroundColor3 = Theme.Element
                                            optionBtn.TextColor3 = Theme.Text
                                        end
                                    end
                                end
                            end
                        end
                    end
                elseif element:IsA("TextButton") then
                    element.BackgroundColor3 = Theme.Element
                    element.TextColor3 = Theme.Text
                    local stroke = element:FindFirstChildOfClass("UIStroke")
                    if stroke then stroke.Color = Theme.Border end
                elseif element:IsA("TextLabel") and element.Name == "Label" then
                    element.TextColor3 = Theme.TextDark
                end
            end
        end
        
        return true
    end
    
    return window
end

return LUI
