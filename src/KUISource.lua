--[[
                                                                                        
     ▄▄   ▄▄▄                                                    ▄▄    ▄▄   ▄▄▄▄▄▄  
     ██  ██▀                                                     ██    ██   ▀▀██▀▀  
     ██▄██      ▄████▄    ██▄████  ██▄  ▄██   ▄████▄   ▀██  ██▀  ██    ██     ██    
     █████     ██▀  ▀██   ██▀       ██  ██   ██▄▄▄▄██    ████    ██    ██     ██    
     ██  ██▄   ██    ██   ██        ▀█▄▄█▀   ██▀▀▀▀▀▀    ▄██▄    ██    ██     ██    
     ██   ██▄  ▀██▄▄██▀   ██         ████    ▀██▄▄▄▄█   ▄█▀▀█▄   ▀██▄▄██▀   ▄▄██▄▄  
     ▀▀    ▀▀    ▀▀▀▀     ▀▀          ▀▀       ▀▀▀▀▀   ▀▀▀  ▀▀▀    ▀▀▀▀     ▀▀▀▀▀▀  
                                                                                    
                                                                                    
        
    local Version = "1.0.2"
    local minified = false
    local Creator = "starstruck"
    local Discord = "n1otev" or "niotev"
    local Description = "Roblox UI library inspired by Linoria"
]]--


local cloneref = (cloneref or clonereference or function(i)
        return i
    end)
local TS = cloneref(game:GetService("TweenService"))
local UIS = cloneref(game:GetService("UserInputService"))
local function Tween(obj, props, t)
    TS:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local LP = Players.LocalPlayer or Players.PlayerAdded:Wait()
local function SafeParent(ui, p)
    p = p or CoreGui
    pcall(
        function()
            ui.Parent = p
        end
    )
    if not ui.Parent then
        ui.Parent = LP:WaitForChild("PlayerGui")
    end
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KorvexUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder = 999
ScreenGui.ResetOnSpawn = false
SafeParent(ScreenGui)
local Library = {
    Toggles = {},
    Options = {},
    Theme = {
        BackgroundColor = Color3.fromRGB(25, 25, 25),
        OutlineColor = Color3.fromRGB(60, 60, 60),
        AccentColor = Color3.fromRGB(255, 170, 255),
        FontColor = Color3.fromRGB(230, 230, 230),
        Font = Enum.Font.Code,
        TextSize = 13
    },
    Keybind = Enum.KeyCode.RightShift,
    Visible = true,
    Unloaded = false
}
Library.AccentElements = {}
Library.Notifications = {}
Library.WatermarkParts = {Name = true, FPS = true, Ping = true, Region = false}
Library.WatermarkName = "KorvexUI"
Library.ElementCount = 0
Library.BlurEnabled = false
Library.BlurStrength = 24
function Library:UpdateBlur()
    local lighting = game:GetService("Lighting")
    local blur = lighting:FindFirstChild("KorvexBlur")
    if self.Main and self.Main.Visible and Library.BlurEnabled then
        if not blur then
            blur = Instance.new("BlurEffect")
            blur.Name = "KorvexBlur"
            blur.Size = Library.BlurStrength
            blur.Parent = lighting
        end
        blur.Size = Library.BlurStrength
    else
        if blur then
            blur:Destroy()
        end
    end
end
function Library:RegisterAccent(inst)
    table.insert(Library.AccentElements, inst)
end
function Library:ApplyAccent(c)
    for _, inst in ipairs(Library.AccentElements) do
        if inst and inst.Parent then
            inst.BackgroundColor3 = c
        end
    end
end
local function Create(c, p)
    local i = Instance.new(c)
    if p then
        for k, v in pairs(p) do
            if k ~= "Parent" then
                i[k] = v
            end
        end
        if p.Parent then
            i.Parent = p.Parent
        end
    end
    return i
end
function Library:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "KorvexUI"
    local size = opts.Size or UDim2.fromOffset(550, 600)
    local center = opts.Center
    local autoShow = opts.AutoShow
    -- auto-unload previous KorvexUI instances
    if _G.KorvexUIInstances then
        for _, g in ipairs(_G.KorvexUIInstances) do
            pcall(
                function()
                    g:Destroy()
                end
            )
        end
    end
    _G.KorvexUIInstances = {ScreenGui}
    local Main =
        Create(
        "Frame",
        {
            Name = "MainWindow",
            Visible = false,
            BackgroundColor3 = Library.Theme.BackgroundColor,
            BackgroundTransparency = 0.15,
            BorderColor3 = Library.Theme.OutlineColor,
            BorderSizePixel = 1,
            Size = size,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = center and UDim2.fromScale(0.5, 0.5) or UDim2.fromOffset(100, 100),
            Parent = ScreenGui
        }
    )
    self.Main = Main
    local TitleBar =
        Create(
        "Frame",
        {Name = "TitleBar", BackgroundColor3 = Color3.fromRGB(30, 30, 30), Size = UDim2.new(1, 0, 0, 30), Parent = Main}
    )
    local ReopenBtn = Instance.new("TextButton")
    ReopenBtn.Text = "K"
    ReopenBtn.Size = UDim2.fromOffset(40, 40)
    ReopenBtn.Position = UDim2.new(0.5, -20, 0, 10)
    ReopenBtn.BackgroundColor3 = Library.Theme.AccentColor
    ReopenBtn.TextColor3 = Library.Theme.FontColor
    ReopenBtn.BorderSizePixel = 0
    ReopenBtn.Visible = false
    ReopenBtn.Parent = ScreenGui
    local reopenDragging, reopenStart, reopenPos
    ReopenBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            reopenDragging = true
            reopenStart = i.Position
            reopenPos = ReopenBtn.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if reopenDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - reopenStart
            ReopenBtn.Position = UDim2.new(reopenPos.X.Scale, reopenPos.X.Offset + d.X, reopenPos.Y.Scale, reopenPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            reopenDragging = false
        end
    end)
    Library:RegisterAccent(ReopenBtn)
    local MinBtn = Instance.new("TextButton")
    MinBtn.Text = "-"
    MinBtn.TextScaled = true
    MinBtn.Size = UDim2.fromOffset(24, 24)
    MinBtn.Position = UDim2.new(1, -28, 0, 4)
    MinBtn.BackgroundColor3 = Library.Theme.AccentColor
    MinBtn.TextColor3 = Library.Theme.FontColor
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TitleBar
    Library:RegisterAccent(MinBtn)
    MinBtn.MouseButton1Click:Connect(
        function()
            Tween(
                Main,
                {BackgroundTransparency = 1, Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 0)},
                0.15
            )
            task.delay(
                0.15,
                function()
                    Main.Visible = false
                    Main.BackgroundTransparency = 0.15
                    Main.Size = size
                    ReopenBtn.Visible = true
                    ReopenBtn.Size = UDim2.fromOffset(0, 0)
                    Tween(ReopenBtn, {Size = UDim2.fromOffset(40, 40)}, 0.2)
                    Library:UpdateBlur()
                end
            )
        end
    )
    ReopenBtn.MouseButton1Click:Connect(
        function()
            Tween(ReopenBtn, {Size = UDim2.fromOffset(0, 0)}, 0.15)
            task.delay(
                0.15,
                function()
                    ReopenBtn.Visible = false
                    Main.Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 0)
                    Main.Visible = true
                    Tween(Main, {BackgroundTransparency = 0.15, Size = size}, 0.2)
                    Library:UpdateBlur()
                end
            )
        end
    )
    local function makeBar(pos, sz)
        local b = Instance.new("Frame")
        b.Size = sz
        b.Position = pos
        b.BackgroundColor3 = Library.Theme.AccentColor
        b.BackgroundTransparency = 0.7
        b.BorderSizePixel = 0
        b.Parent = Main
        Library:RegisterAccent(b)
        return b
    end
    local rightBar = makeBar(UDim2.new(1, -3, 0, 30), UDim2.fromOffset(3, 0))
    rightBar.Size = UDim2.new(0, 3, 1, -46)
    local bottomBar = makeBar(UDim2.new(0, 0, 1, -3), UDim2.fromOffset(0, 3))
    bottomBar.Size = UDim2.new(1, -16, 0, 3)
    local cornerBar = makeBar(UDim2.new(1, -10, 1, -10), UDim2.fromOffset(10, 10))
    cornerBar.BackgroundTransparency = 0.5
    local resizing = false
    local resizeStart
    local startSize
    local resizeMode = ""
    local function startResize(mode, i)
        resizing = true
        resizeMode = mode
        resizeStart = i.Position
        startSize = Main.Size
    end
    rightBar.InputBegan:Connect(
        function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                startResize("right", i)
            end
        end
    )
    bottomBar.InputBegan:Connect(
        function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                startResize("bottom", i)
            end
        end
    )
    cornerBar.InputBegan:Connect(
        function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                startResize("corner", i)
            end
        end
    )
    UIS.InputChanged:Connect(
        function(i)
            if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - resizeStart
                if resizeMode == "right" or resizeMode == "corner" then
                    Main.Size = UDim2.fromOffset(math.max(300, startSize.X.Offset + d.X), Main.Size.Y.Offset)
                end
                if resizeMode == "bottom" or resizeMode == "corner" then
                    Main.Size = UDim2.fromOffset(Main.Size.X.Offset, math.max(200, startSize.Y.Offset + d.Y))
                end
            end
        end
    )
    UIS.InputEnded:Connect(
        function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end
    )
    -- minimize removed due to readonly table issue; use menu keybind to hide UI
    -- resize removed
    Create(
        "TextLabel",
        {
            Text = title,
            Font = Library.Theme.Font,
            TextSize = 14,
            TextColor3 = Library.Theme.FontColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.fromOffset(8, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TitleBar
        }
    )
    local TabHolder =
        Create(
        "Frame",
        {
            Name = "TabHolder",
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Size = UDim2.new(0, 140, 1, -30),
            Position = UDim2.fromOffset(0, 30),
            Parent = Main
        }
    )
    Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabHolder})
    local Content =
        Create(
        "Frame",
        {
            Name = "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -140, 1, -30),
            Position = UDim2.fromOffset(140, 30),
            Parent = Main
        }
    )
    self.Content = Content
    self.Tabs = {}
    self.ActiveTab = nil
    local dragging, ds, sp
    TitleBar.InputBegan:Connect(
        function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                ds = i.Position
                sp = Main.Position
            end
        end
    )
    UIS.InputChanged:Connect(
        function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - ds
                Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
            end
        end
    )
    UIS.InputEnded:Connect(
        function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end
    )
    UIS.InputBegan:Connect(
        function(i, gp)
            if gp then
                return
            end
            if i.KeyCode == self.Keybind then
                if Main.Visible then
                    Tween(
                        Main,
                        {BackgroundTransparency = 1, Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 0)},
                        0.15
                    )
                    task.delay(
                        0.15,
                        function()
                            Main.Visible = false
                            Main.BackgroundTransparency = 0.15
                            Main.Size = size
                            ReopenBtn.Visible = true
                            ReopenBtn.Size = UDim2.fromOffset(0, 0)
                            Tween(ReopenBtn, {Size = UDim2.fromOffset(40, 40)}, 0.2)
                            Library:UpdateBlur()
                        end
                    )
                else
                    Main.Size = UDim2.new(Main.Size.X.Scale, Main.Size.X.Offset, 0, 0)
                    Main.Visible = true
                    ReopenBtn.Visible = false
                    Tween(Main, {BackgroundTransparency = 0.15, Size = size}, 0.2)
                    Library:UpdateBlur()
                end
            end
        end
    )
    if not autoShow then
        Main.Visible = false
    end
    local function mkGroup(tab, gname)
        local gb =
            Create(
            "Frame",
            {
                Name = gname,
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                BorderColor3 = Library.Theme.OutlineColor,
                BorderSizePixel = 1,
                Size = UDim2.new(1, -12, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = tab.Frame
            }
        )
        Create(
            "TextLabel",
            {
                Text = gname,
                Font = Library.Theme.Font,
                TextSize = Library.Theme.TextSize,
                TextColor3 = Library.Theme.FontColor,
                BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                Size = UDim2.new(1, 0, 0, 20),
                Parent = gb
            }
        )
        local gc =
            Create(
            "Frame",
            {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 20),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = gb
            }
        )
        Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = gc})
        local group = {Name = gname, Frame = gb, Content = gc}
        function group:AddToggle(id, info)
            info = info or {}
            local row = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = gc})
            Create(
                "TextLabel",
                {
                    Text = info.Text or id,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -30, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                }
            )
            local box =
                Create(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.new(1, -18, 0.5, -8),
                    Parent = row
                }
            )
            local check =
                Create(
                "Frame",
                {
                    BackgroundColor3 = Library.Theme.AccentColor,
                    Size = UDim2.fromOffset(10, 10),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Visible = info.Default or false,
                    Parent = box
                }
            )
            Library:RegisterAccent(check)
            local state = info.Default or false
            local t = {Value = state, Id = id}
            Library.Toggles[id] = t
            local function set(v)
                state = v
                t.Value = v
                if v then
                    check.Visible = true
                    Tween(check, {Size = UDim2.fromOffset(10, 10)}, 0.12)
                else
                    Tween(check, {Size = UDim2.fromOffset(0, 0)}, 0.12)
                    task.delay(
                        0.12,
                        function()
                            if not state then
                                check.Visible = false
                            end
                        end
                    )
                end
                if info.Callback then
                    info.Callback(v)
                end
            end
            Library.ElementCount = (Library.ElementCount or 0) + 1
            t.SetValue = set
            t.Set = set
            row.InputBegan:Connect(
                function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        set(not state)
                    end
                end
            )
            if info.Default then
                task.defer(
                    function()
                        if info.Callback then
                            info.Callback(true)
                        end
                    end
                )
            end
            return t
        end
        function group:AddSlider(id, info)
            info = info or {}
            local mn = info.Min or 0
            local mx = info.Max or 100
            local def = info.Default or mn
            local row = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Parent = gc})
            local lbl =
                Create(
                "TextLabel",
                {
                    Text = (info.Text or id) .. ": " .. def,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                }
            )
            local bar =
                Create(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 12),
                    Position = UDim2.fromOffset(0, 20),
                    Parent = row
                }
            )
            local fill =
                Create(
                "Frame",
                {
                    BackgroundColor3 = Library.Theme.AccentColor,
                    Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0),
                    Parent = bar
                }
            )
            Library:RegisterAccent(fill)
            local val = def
            local s = {Value = val, Id = id}
            Library.Options[id] = s
            local function set(v)
                v = math.clamp(v, mn, mx)
                val = v
                s.Value = v
                Tween(fill, {Size = UDim2.new((v - mn) / (mx - mn), 0, 1, 0)}, 0.2)
                lbl.Text = (info.Text or id) .. ": " .. v
                if info.Callback then
                    info.Callback(v)
                end
            end
            Library.ElementCount = (Library.ElementCount or 0) + 1
            s.SetValue = set
            s.Set = set
            local drag = false
            bar.InputBegan:Connect(
                function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        drag = true
                    end
                end
            )
            UIS.InputEnded:Connect(
                function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        drag = false
                    end
                end
            )
            UIS.InputChanged:Connect(
                function(i)
                    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                        set(mn + (mx - mn) * math.clamp(rel, 0, 1))
                    end
                end
            )
            return s
        end

        function group:AddDropdown(id, info)
            info = info or {}
            local values = info.Values or {}
            local def = info.Default
            local row = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Parent = gc})
            Create(
                "TextLabel",
                {
                    Text = info.Text or id,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                }
            )
            local sel =
                Create(
                "TextButton",
                {
                    Text = tostring(def or values[1] or ""),
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 20),
                    Position = UDim2.fromOffset(0, 18),
                    Parent = row
                }
            )
            local val = def or values[1]
            local dd = {Value = val, Id = id, Values = values}
            Library.Options[id] = dd
            local lf =
                Create(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 38),
                    Visible = false,
                    ZIndex = 100,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = row
                }
            )
            local ll = Create("UIListLayout", {Parent = lf})
            ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
                function()
                    lf.Size = UDim2.new(1, 0, 0, ll.AbsoluteContentSize.Y)
                end
            )
            for _, v in ipairs(values) do
                local opt =
                    Create(
                    "TextButton",
                    {
                        Text = tostring(v),
                        Font = Library.Theme.Font,
                        TextSize = Library.Theme.TextSize,
                        TextColor3 = Color3.new(1, 1, 1),
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        Size = UDim2.new(1, 0, 0, 18),
                        ZIndex = 101,
                        TextScaled = true,
                        Parent = lf
                    }
                )
                opt.MouseButton1Click:Connect(
                    function()
                        val = v
                        dd.Value = v
                        sel.Text = tostring(v)
                        lf.Visible = false
                        if info.Callback then
                            info.Callback(v)
                        end
                    end
                )
            end
            sel.MouseButton1Click:Connect(
                function()
                    lf.Visible = not lf.Visible
                end
            )
            Library.ElementCount = (Library.ElementCount or 0) + 1
            function dd:SetValue(v)
                val = v
                dd.Value = v
                sel.Text = tostring(v)
                if info.Callback then
                    info.Callback(v)
                end
            end
            return dd
        end
        function group:AddButton(text, cb)
            local btn =
                Create(
                "TextButton",
                {
                    Text = text,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 22),
                    Parent = gc
                }
            )
            btn.MouseButton1Click:Connect(
                function()
                    if cb then
                        cb()
                    end
                end
            )
            return btn
        end
        function group:AddLabel(text)
            return Create(
                "TextLabel",
                {
                    Text = text,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = gc
                }
            )
        end
        function group:AddDivider()
            return Create(
                "Frame",
                {BackgroundColor3 = Library.Theme.OutlineColor, Size = UDim2.new(1, 0, 0, 1), Parent = gc}
            )
        end
        function group:AddKeyPicker(id, info)
            info = info or {}
            local row = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = gc})
            Create(
                "TextLabel",
                {
                    Text = info.Text or id,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -60, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                }
            )
            local keyBtn =
                Create(
                "TextButton",
                {
                    Text = tostring(info.Default or "None"),
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.fromOffset(56, 18),
                    Position = UDim2.new(1, -58, 0.5, -9),
                    TextScaled = true,
                    Parent = row
                }
            )
            local kp = {Value = info.Default, Id = id}
            Library.Options[id] = kp
            local listening = false
            keyBtn.MouseButton1Click:Connect(
                function()
                    listening = true
                    keyBtn.Text = "..."
                end
            )
            UIS.InputBegan:Connect(
                function(i, gp)
                    if listening and i.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        kp.Value = i.KeyCode.Name
                        keyBtn.Text = i.KeyCode.Name
                        if info.Callback then
                            info.Callback(i.KeyCode)
                        end
                    end
                end
            )
            return kp
        end
        function group:AddInput(id, info)
            info = info or {}
            local row = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), Parent = gc})
            Create(
                "TextLabel",
                {
                    Text = info.Text or id,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                }
            )
            local box =
                Create(
                "TextBox",
                {
                    Text = info.Default or "",
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.fromOffset(0, 16),
                    ClearTextOnFocus = false,
                    Parent = row
                }
            )
            local inp = {Value = box.Text, Id = id}
            Library.Options[id] = inp
            box.FocusLost:Connect(
                function()
                    inp.Value = box.Text
                    if info.Callback then
                        info.Callback(box.Text)
                    end
                end
            )
            function inp:SetValue(v)
                box.Text = v
                inp.Value = v
            end
            return inp
        end
        function group:AddColorPicker(id, info)
            info = info or {}
            local default = info.Default or Color3.fromRGB(255, 0, 0)
            local row = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 74), Parent = gc})
            Create(
                "TextLabel",
                {
                    Text = info.Text or id,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                }
            )
            local preview =
                Create(
                "Frame",
                {
                    BackgroundColor3 = default,
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.fromOffset(24, 24),
                    Position = UDim2.fromOffset(0, 18),
                    Parent = row
                }
            )
            local function makeSlider(label, y, init)
                local l =
                    Create(
                    "TextLabel",
                    {
                        Text = label .. ": " .. init,
                        Font = Library.Theme.Font,
                        TextSize = 11,
                        TextColor3 = Library.Theme.FontColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -30, 0, 14),
                        Position = UDim2.fromOffset(30, y),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = row
                    }
                )
                local bar =
                    Create(
                    "Frame",
                    {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        BorderColor3 = Library.Theme.OutlineColor,
                        Size = UDim2.new(1, -30, 0, 6),
                        Position = UDim2.fromOffset(30, y + 14),
                        Parent = row
                    }
                )
                local fill =
                    Create(
                    "Frame",
                    {BackgroundColor3 = Library.Theme.AccentColor, Size = UDim2.new(init / 255, 0, 1, 0), Parent = bar}
                )
                return l, bar, fill
            end
            local rL, rB, rF = makeSlider("R", 18, math.floor(default.R * 255))
            local gL, gB, gF = makeSlider("G", 36, math.floor(default.G * 255))
            local bL, bB, bF = makeSlider("B", 54, math.floor(default.B * 255))
            local r, g, b = math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)
            local cp = {Value = default, Id = id}
            Library.Options[id] = cp
            local function update()
                local c = Color3.fromRGB(r, g, b)
                preview.BackgroundColor3 = c
                cp.Value = c
                if info.Callback then
                    info.Callback(c)
                end
            end
            local function bind(lbl, bar, fill, channel)
                local drag = false
                bar.InputBegan:Connect(
                    function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            drag = true
                        end
                    end
                )
                UIS.InputEnded:Connect(
                    function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            drag = false
                        end
                    end
                )
                UIS.InputChanged:Connect(
                    function(i)
                        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                            local v = math.floor(rel * 255)
                            if channel == "r" then
                                r = v
                            elseif channel == "g" then
                                g = v
                            else
                                b = v
                            end
                            fill.Size = UDim2.new(rel, 0, 1, 0)
                            lbl.Text = (channel == "r" and "R" or channel == "g" and "G" or "B") .. ": " .. v
                            update()
                        end
                    end
                )
            end
            bind(rL, rB, rF, "r")
            bind(gL, gB, gF, "g")
            bind(bL, bB, bF, "b")
            function cp:SetValue(c)
                r, g, b = math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255)
                preview.BackgroundColor3 = c
                cp.Value = c
            end
            return cp
        end
        function group:AddSection(text)
            local sec =
                Create(
                "TextLabel",
                {
                    Text = text,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.AccentColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = gc
                }
            )
            return sec
        end
        function group:AddMultiDropdown(id, info)
            info = info or {}
            local values = info.Values or {}
            local selected = {}
            local row = Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44), Parent = gc})
            Create(
                "TextLabel",
                {
                    Text = info.Text or id,
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = row
                }
            )
            local search =
                Create(
                "TextBox",
                {
                    Text = "",
                    PlaceholderText = "Search...",
                    Font = Library.Theme.Font,
                    TextSize = 11,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 16),
                    Position = UDim2.fromOffset(0, 16),
                    Parent = row
                }
            )
            local btn =
                Create(
                "TextButton",
                {
                    Text = "Select...",
                    Font = Library.Theme.Font,
                    TextSize = Library.Theme.TextSize,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 16),
                    Position = UDim2.fromOffset(0, 32),
                    Parent = row
                }
            )
            local lf =
                Create(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = Library.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 48),
                    Visible = false,
                    ZIndex = 100,
                    Parent = row
                }
            )
            local ll = Create("UIListLayout", {Parent = lf})
            ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
                function()
                    lf.Size = UDim2.new(1, 0, 0, ll.AbsoluteContentSize.Y)
                end
            )
            local md = {Value = selected, Id = id}
            Library.Options[id] = md
            local function refresh()
                local names = {}
                for _, v in ipairs(selected) do
                    table.insert(names, tostring(v))
                end
                btn.Text = #names > 0 and table.concat(names, ", ") or "Select..."
            end
            local function rebuild(filter)
                for _, c in ipairs(lf:GetChildren()) do
                    if c:IsA("TextButton") then
                        c:Destroy()
                    end
                end
                for _, v in ipairs(values) do
                    if filter == "" or string.find(string.lower(tostring(v)), string.lower(filter), 1, true) then
                        local isSel = false
                        for _, s in ipairs(selected) do
                            if s == v then
                                isSel = true
                            end
                        end
                        local opt =
                            Create(
                            "TextButton",
                            {
                                Text = (isSel and "[x] " or "[ ] ") .. tostring(v),
                                Font = Library.Theme.Font,
                                TextSize = 11,
                                TextColor3 = Color3.new(1, 1, 1),
                                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                                Size = UDim2.new(1, 0, 0, 16),
                                ZIndex = 101,
                                TextScaled = true,
                                Parent = lf
                            }
                        )
                        opt.MouseButton1Click:Connect(
                            function()
                                if isSel then
                                    for i, s in ipairs(selected) do
                                        if s == v then
                                            table.remove(selected, i)
                                        end
                                    end
                                else
                                    table.insert(selected, v)
                                end
                                refresh()
                                rebuild(search.Text)
                            end
                        )
                    end
                end
            end
            search:GetPropertyChangedSignal("Text"):Connect(
                function()
                    rebuild(search.Text)
                end
            )
            rebuild("")
            btn.MouseButton1Click:Connect(
                function()
                    lf.Visible = not lf.Visible
                end
            )
            function md:SetValue(t)
                selected = t or {}
                refresh()
            end
            return md
        end
        function group:AddTabbox()
            local container =
                Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = gc
                }
            )
            local tabBar =
                Create(
                "Frame",
                {BackgroundColor3 = Color3.fromRGB(28, 28, 28), Size = UDim2.new(1, 0, 0, 20), Parent = container}
            )
            local content =
                Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 20),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = container
                }
            )
            local tabs = {}
            local active = nil
            local tb = Create("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Parent = tabBar})
            local function addTab(name)
                local btn =
                    Create(
                    "TextButton",
                    {
                        Text = name,
                        Font = Library.Theme.Font,
                        TextSize = Library.Theme.TextSize,
                        TextColor3 = Library.Theme.FontColor,
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(0, 60, 1, 0),
                        Parent = tabBar
                    }
                )
                local f =
                    Create(
                    "Frame",
                    {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Visible = false,
                        Parent = content
                    }
                )
                Create("UIListLayout", {Padding = UDim.new(0, 4), Parent = f})
                local t = {Name = name, Button = btn, Frame = f, Content = f}
                function t:AddToggle(id, info)
                    return group.AddToggle and nil
                end
                tabs[name] = t
                btn.MouseButton1Click:Connect(
                    function()
                        for _, tt in pairs(tabs) do
                            tt.Frame.Visible = false
                            tt.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                        end
                        f.Visible = true
                        btn.BackgroundColor3 = Library.Theme.AccentColor
                    end
                )
                if not active then
                    active = t
                    f.Visible = true
                    btn.BackgroundColor3 = Library.Theme.AccentColor
                end
                return t
            end
            local box = {Tabs = tabs, AddTab = addTab, Frame = container}
            return box
        end
        function group:AddDependencyBox()
            local frame =
                Create(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = gc
                }
            )
            local deps = {}
            function frame:SetupDependencies(list)
                deps = list or {}
            end
            frame.Visible = true
            Create("UIListLayout", {Padding = UDim.new(0, 4), Parent = frame})
            return frame
        end
        return group
    end
    function self:AddTab(name)
        local tabBtn =
            Create(
            "TextButton",
            {
                Text = name,
                Font = Library.Theme.Font,
                TextSize = Library.Theme.TextSize,
                TextColor3 = Library.Theme.FontColor,
                BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                BorderColor3 = Library.Theme.OutlineColor,
                BorderSizePixel = 1,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = TabHolder
            }
        )
        local tabFrame =
            Create(
            "ScrollingFrame",
            {
                Name = name,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 4,
                Visible = false,
                Parent = Content
            }
        )
        local layout =
            Create(
            "UIListLayout",
            {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabFrame}
        )
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
            function()
                tabFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
            end
        )
        Create(
            "UIPadding",
            {
                PaddingTop = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                Parent = tabFrame
            }
        )
        local tab = {Name = name, Button = tabBtn, Frame = tabFrame, Groups = {}}
        table.insert(self.Tabs, tab)
        -- keep Korvex Settings tab at the bottom
        local ks = nil
        for i, t in ipairs(self.Tabs) do
            if t.Name == "Korvex Settings" and t ~= tab then
                ks = t
            end
        end
        if ks then
            -- move ks to end
            for i, t in ipairs(self.Tabs) do
                if t == ks then
                    table.remove(self.Tabs, i)
                    break
                end
            end
            table.insert(self.Tabs, ks)
            ks.Button.Parent = nil
            ks.Button.Parent = TabHolder
        end
        tabBtn.MouseButton1Click:Connect(
            function()
                for _, t in ipairs(self.Tabs) do
                    t.Frame.Visible = false
                    t.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                end
                tab.Frame.Visible = true
                tab.Frame.Position = UDim2.fromOffset(8, 0)
                Tween(tab.Frame, {Position = UDim2.fromOffset(0, 0)}, 0.15)
                tabBtn.BackgroundColor3 = Library.Theme.AccentColor
            end
        )
        function tab:AddLeftGroupbox(gname)
            return mkGroup(tab, gname)
        end
        function tab:AddRightGroupbox(gname)
            return mkGroup(tab, gname)
        end
        function tab:AddGroupbox(gname, side)
            return mkGroup(tab, gname)
        end
        if not self.ActiveTab then
            self.ActiveTab = tab
            tab.Frame.Visible = true
            tabBtn.BackgroundColor3 = Library.Theme.AccentColor
        end
        return tab
    end
    function self:Notify(text, dur)
        if typeof(text) == "table" then
            local o = text
            text = o.Text or ""
            dur = o.Duration or dur or 3
        end
        dur = dur or 3
        local side = self.NotifySide or "Left"
        local n =
            Create(
            "Frame",
            {
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderColor3 = Library.Theme.OutlineColor,
                BorderSizePixel = 1,
                Size = UDim2.fromOffset(260, 44),
                Parent = ScreenGui
            }
        )
        n.Name = "KorvexNotify"
        table.insert(Library.Notifications, n)
        local y = 0
        for _, c in ipairs(ScreenGui:GetChildren()) do
            if c.Name == "KorvexNotify" and c ~= n then
                y = y + 48
            end
        end
        if side == "Left" then
            n.Position = UDim2.new(0, -270, 1, -50 - y)
            Tween(n, {Position = UDim2.new(0, 10, 1, -50 - y)}, 0.2)
        else
            n.Position = UDim2.new(1, 10, 1, -50 - y)
            Tween(n, {Position = UDim2.new(1, -270, 1, -50 - y)}, 0.2)
        end
        Create(
            "TextLabel",
            {
                Text = text,
                Font = Library.Theme.Font,
                TextSize = Library.Theme.TextSize,
                TextColor3 = Library.Theme.FontColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -8, 1, 0),
                Position = UDim2.fromOffset(4, 0),
                TextWrapped = true,
                Parent = n
            }
        )
        task.delay(
            dur,
            function()
                Tween(n, {BackgroundTransparency = 1}, 0.2)
                for _, c in ipairs(n:GetChildren()) do
                    if c:IsA("TextLabel") then
                        Tween(c, {TextTransparency = 1}, 0.2)
                    end
                end
                task.delay(
                    0.2,
                    function()
                        n:Destroy()
                        local side = Library.NotifySide or "Left"
                        local y = 0
                        for _, nn in ipairs(Library.Notifications) do
                            if nn ~= n and nn.Parent then
                                if side == "Left" then
                                    Tween(nn, {Position = UDim2.new(0, 10, 1, -50 - y)}, 0.15)
                                else
                                    Tween(nn, {Position = UDim2.new(1, -270, 1, -50 - y)}, 0.15)
                                end
                                y = y + 48
                            end
                        end
                        for i, nn in ipairs(Library.Notifications) do
                            if nn == n then
                                table.remove(Library.Notifications, i)
                                break
                            end
                        end
                    end
                )
            end
        )
    end
    function self:SetWatermark(text)
        if not self.Watermark then
            self.Watermark =
                Create(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 0.3,
                    BorderSizePixel = 0,
                    Size = UDim2.fromOffset(220, 20),
                    Position = UDim2.new(1, -230, 0, 8),
                    Parent = ScreenGui
                }
            )
            self.WatermarkLabel =
                Create(
                "TextLabel",
                {
                    Text = text,
                    Font = Library.Theme.Font,
                    TextSize = 12,
                    TextColor3 = Library.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -8, 1, 0),
                    Position = UDim2.fromOffset(4, 0),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = self.Watermark
                }
            )
        else
            if self.WatermarkLabel then
                self.WatermarkLabel.Text = text
                task.defer(
                    function()
                        if self.Watermark and self.WatermarkLabel then
                            local w = math.max(20, self.WatermarkLabel.TextBounds.X + 12)
                            self.Watermark.Size = UDim2.fromOffset(w, 20)
                            self.Watermark.Position = UDim2.new(1, -(w + 10), 0, 8)
                            self.Watermark.Visible = (text ~= "")
                        end
                    end
                )
            end
        end
    end
    function self:EnableFPSWatermark()
        local fps, frames, last = 60, 0, tick()
        self._fpsConn =
            game:GetService("RunService").RenderStepped:Connect(
            function()
                if self.Unloaded then
                    self._fpsConn:Disconnect()
                    return
                end
                frames = frames + 1
                if tick() - last >= 1 then
                    fps = frames
                    frames = 0
                    last = tick()
                end
                local ping = 0
                pcall(
                    function()
                        ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                    end
                )
                local parts = {}
                if Library.WatermarkParts.Name then
                    table.insert(parts, Library.WatermarkName)
                end
                if Library.WatermarkParts.FPS then
                    table.insert(parts, fps .. " fps")
                end
                if Library.WatermarkParts.Ping then
                    table.insert(parts, ping .. " ms")
                end
                if Library.WatermarkParts.Region then
                    table.insert(parts, tostring(game:GetService("LocalizationService").RobloxLocaleId))
                end
                self:SetWatermark(table.concat(parts, " | "))
            end
        )
    end
    function self:SetWatermarkVisibility(v)
        if self.Watermark then
            self.Watermark.Visible = v
        end
    end
    function self:Unload()
        self.Unloaded = true
        if self._fpsConn then
            pcall(
                function()
                    self._fpsConn:Disconnect()
                end
            )
        end
        if _G.KorvexUIInstances then
            for i, g in ipairs(_G.KorvexUIInstances) do
                if g == ScreenGui then
                    table.remove(_G.KorvexUIInstances, i)
                    break
                end
            end
        end
        ScreenGui:Destroy()
    end
    local status =
        Create(
        "TextLabel",
        {
            Text = "",
            Font = Library.Theme.Font,
            TextSize = 14,
            TextColor3 = Library.Theme.FontColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0.58, 0),
            Visible = not key,
            Parent = overlay
        }
    )
    function Library:CreateLoadingScreen(opts)
        opts = opts or {}
        local sub = opts.Subtitle or "Loading..."
        local desc = opts.Description or ""
        local owner = opts.Owner or ""
        local key = opts.Key
        local overlay =
            Create(
            "Frame",
            {
                BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                BackgroundTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Parent = ScreenGui
            }
        )
        local title =
            Create(
            "TextLabel",
            {
                Text = "KorvexUI",
                Font = Library.Theme.Font,
                TextSize = 48,
                TextColor3 = Library.Theme.AccentColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 60),
                Position = UDim2.new(0, 0, 0.35, 0),
                Parent = overlay
            }
        )
        local subtitle =
            Create(
            "TextLabel",
            {
                Text = sub,
                Font = Library.Theme.Font,
                TextSize = 18,
                TextColor3 = Library.Theme.FontColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 24),
                Position = UDim2.new(0, 0, 0.42, 0),
                Visible = not key,
                Parent = overlay
            }
        )
        local description =
            Create(
            "TextLabel",
            {
                Text = desc,
                Font = Library.Theme.Font,
                TextSize = 13,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0.46, 0),
                Visible = not key,
                Parent = overlay
            }
        )
        local ownerLabel =
            Create(
            "TextLabel",
            {
                Text = owner,
                Font = Library.Theme.Font,
                TextSize = 12,
                TextColor3 = Color3.fromRGB(120, 120, 120),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Visible = not key,
                Position = UDim2.fromOffset(0, 0.9),
                Parent = overlay
            }
        )
        local keyFrame = nil
            title.TextTransparency = 1
            Tween(title, {TextTransparency = 0}, 0.4)
            local tabs = math.random(1, 6)
            local elems = math.random(10, 35)
            local funcs = math.random(80, 150)
            local steps = {
                {name = "Loading tabs", total = tabs},
                {name = "Loading elements", total = elems},
                {name = "Loading functions", total = funcs}
            }
            local progress = 0
            local totalAll = 0
            for _, s in ipairs(steps) do
                totalAll = totalAll + s.total
            end
            if totalAll == 0 then
                totalAll = 1
            end
            local function startLoad()
                task.spawn(
                    function()
                        local l1 =
                            Create(
                            "TextLabel",
                            {
                                Text = "Tabs: 0/" .. tabs,
                                Font = Library.Theme.Font,
                                TextSize = 14,
                                TextColor3 = Library.Theme.FontColor,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 0, 18),
                                Position = UDim2.new(0, 0, 0.5, 0),
                                Parent = overlay
                            }
                        )
                        local l2 =
                            Create(
                            "TextLabel",
                            {
                                Text = "Elements: 0/" .. elems,
                                Font = Library.Theme.Font,
                                TextSize = 14,
                                TextColor3 = Library.Theme.FontColor,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 0, 18),
                                Position = UDim2.new(0, 0, 0.53, 0),
                                Parent = overlay
                            }
                        )
                        local l3 =
                            Create(
                            "TextLabel",
                            {
                                Text = "Functions: 0/" .. funcs,
                                Font = Library.Theme.Font,
                                TextSize = 14,
                                TextColor3 = Library.Theme.FontColor,
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 0, 0, 18),
                                Position = UDim2.new(0, 0, 0.56, 0),
                                Parent = overlay
                            }
                        )
                        for _, s in ipairs(steps) do
                            status.Text = s.name .. " (" .. s.total .. ")"
                            local dur = math.random(80, 120) / 100
                            local start = progress
                            local add = s.total / totalAll
                            for t = 0, 1, 0.05 do
                                if Library.Unloaded then
                                    return
                                end
                                task.wait(dur / 20)
                                if status then
                                    status.Text = s.name .. " (" .. s.total .. ")"
                                end
                                progress = start + add * t
                                if s.name == "Loading tabs" then
                                    l1.Text = "Tabs: " .. math.floor(s.total * t) .. "/" .. s.total
                                elseif s.name == "Loading elements" then
                                    l2.Text = "Elements: " .. math.floor(s.total * t) .. "/" .. s.total
                                elseif s.name == "Loading functions" then
                                    l3.Text = "Functions: " .. math.floor(s.total * t) .. "/" .. s.total
                                end
                            end
                            progress = start + add
                        end
                        task.wait(0.3)
                        Tween(overlay, {BackgroundTransparency = 1}, 0.4)
                        task.delay(
                            0.4,
                            function()
                                overlay:Destroy()
                                if self.Main then
                                    self.Main.Visible = true
                                    self.Main.Size = UDim2.new(self.Main.Size.X.Scale, self.Main.Size.X.Offset, 0, 0)
                                    Tween(self.Main, {BackgroundTransparency = 0.15, Size = size}, 0.25)
                                end
                            end
                        )
                    end
                )
            end
            Library._loadFn = startLoad
            startLoad()
        local prevActive = self.ActiveTab
        local ksTab = self:AddTab("Korvex Settings")
        if prevActive then
            self.ActiveTab = prevActive
            for _, t in ipairs(self.Tabs) do
                t.Frame.Visible = (t == prevActive)
                t.Button.BackgroundColor3 =
                    (t == prevActive) and Library.Theme.AccentColor or Color3.fromRGB(28, 28, 28)
            end
        end
        local ksGroup = ksTab:AddLeftGroupbox("Settings")
        ksGroup:AddColorPicker(
            "AccentColor",
            {Text = "Accent Color", Default = self.Theme.AccentColor, Callback = function(c)
                    self.Theme.AccentColor = c
                    self:ApplyAccent(c)
                end}
        )
        ksGroup:AddKeyPicker(
            "UIKeybind",
            {Text = "Toggle UI Keybind", Default = "RightShift", Callback = function(k)
                    self.Keybind = k
                end}
        )
        ksGroup:AddInput(
            "WatermarkName",
            {Text = "Watermark Name", Default = Library.WatermarkName, Callback = function(v)
                    Library.WatermarkName = v
                end}
        )
        ksGroup:AddToggle(
            "WMName",
            {Text = "Show Name", Default = true, Callback = function(v)
                    Library.WatermarkParts.Name = v
                end}
        )
        ksGroup:AddToggle(
            "WMFPS",
            {Text = "Show FPS", Default = true, Callback = function(v)
                    Library.WatermarkParts.FPS = v
                end}
        )
        ksGroup:AddToggle(
            "WMPing",
            {Text = "Show Ping", Default = true, Callback = function(v)
                    Library.WatermarkParts.Ping = v
                end}
        )
        ksGroup:AddToggle(
            "WMRegion",
            {Text = "Show Region", Default = false, Callback = function(v)
                    Library.WatermarkParts.Region = v
                end}
        )
        ksGroup:AddButton(
            "Save Config",
            function()
                Library:SaveConfig("korvex_config")
                Library:Notify({Text = "Config saved", Duration = 2})
            end
        )
        ksGroup:AddButton(
            "Load Config",
            function()
                Library:LoadConfig("korvex_config")
                Library:Notify({Text = "Config loaded", Duration = 2})
            end
        )
        ksGroup:AddButton(
            "Unload",
            function()
                self:Unload()
            end
        )
        ksGroup:AddToggle(
            "InMenuEffects",
            {
                Text = "In-Menu Effects",
                Default = true,
                Callback = function(v)
                    if v then
                        if not self._effects then
                            self._effects = {}
                            for i = 1, 24 do
                                local p =
                                    Create(
                                    "Frame",
                                    {
                                        BackgroundColor3 = Library.Theme.AccentColor,
                                        BackgroundTransparency = 0.7,
                                        BorderSizePixel = 0,
                                        Size = UDim2.fromOffset(6, 6),
                                        Position = UDim2.fromScale(math.random(), math.random()),
                                        Parent = ScreenGui
                                    }
                                )
                                Library:RegisterAccent(p)
                                table.insert(self._effects, p)
                            end
                            self._effectsConn =
                                game:GetService("RunService").RenderStepped:Connect(
                                function()
                                    if self.Unloaded then
                                        return
                                    end
                                    for _, p in ipairs(self._effects) do
                                        if p and p.Parent then
                                            p.Visible = (self.Main and self.Main.Visible)
                                            p.Position =
                                                UDim2.fromScale(
                                                (p.Position.X.Scale + 0.001) % 1,
                                                (p.Position.Y.Scale + 0.0007) % 1
                                            )
                                        end
                                    end
                                end
                            )
                        end
                    else
                        if self._effectsConn then
                            pcall(
                                function()
                                    self._effectsConn:Disconnect()
                                end
                            )
                            self._effectsConn = nil
                        end
                        if self._effects then
                            for _, p in ipairs(self._effects) do
                                p:Destroy()
                            end
                            self._effects = nil
                        end
                    end
                end
            }
        )
    end
    self:CreateLoadingScreen({ Subtitle = opts.Title or "Loading...", Description = opts.Description or "", Owner = opts.Author or "" })
    return self
end

function Library:UpdateBlur()
end
function Library:_SerializeValue(v)
    if typeof(v) == "Color3" then
        return {__type = "Color3", r = v.R, g = v.G, b = v.B}
    elseif typeof(v) == "EnumItem" then
        return {__type = "Enum", name = tostring(v)}
    elseif type(v) == "table" then
        local t = {}
        for k, val in pairs(v) do
            t[k] = Library:_SerializeValue(val)
        end
        return t
    else
        return v
    end
end
function Library:_DeserializeValue(v)
    if type(v) == "table" and v.__type == "Color3" then
        return Color3.new(v.r, v.g, v.b)
    elseif type(v) == "table" and v.__type == "Enum" then
        local name = tostring(v.name):match("%.([^%.]+)$") or tostring(v.name)
        local ok, e = pcall(function()
            return Enum.KeyCode[name]
        end)
        if ok and e then
            return e
        end
        return v.name
    elseif type(v) == "table" then
        local t = {}
        for k, val in pairs(v) do
            t[k] = Library:_DeserializeValue(val)
        end
        return t
    else
        return v
    end
end
function Library:SaveConfig(name)
    if not writefile then
        return
    end
    local data = {}
    for id, o in pairs(Library.Options) do
        local ok, val = pcall(function()
            return Library:_SerializeValue(o.Value)
        end)
        if ok then
            data[id] = val
        end
    end
    for id, t in pairs(Library.Toggles) do
        local ok, val = pcall(function()
            return Library:_SerializeValue(t.Value)
        end)
        if ok then
            data[id] = val
        end
    end
    local ok, encoded = pcall(function()
        return game:GetService("HttpService"):JSONEncode(data)
    end)
    if ok and encoded then
        pcall(function()
            writefile(name .. ".json", encoded)
        end)
    end
end
function Library:LoadConfig(name)
    if not readfile or not isfile or not isfile(name .. ".json") then
        return
    end
    local ok, data =
        pcall(
        function()
            return game:GetService("HttpService"):JSONDecode(readfile(name .. ".json"))
        end
    )
    if not ok or type(data) ~= "table" then
        return
    end
    for id, v in pairs(data) do
        local val = Library:_DeserializeValue(v)
        if Library.Options[id] and Library.Options[id].SetValue then
            pcall(
                function()
                    Library.Options[id]:SetValue(val)
                end
            )
        elseif Library.Toggles[id] and Library.Toggles[id].SetValue then
            pcall(
                function()
                    Library.Toggles[id]:SetValue(val)
                end
            )
        end
    end
end
return setmetatable(
    Library,
    {__call = function(_, ...)
            return Library:CreateWindow(...)
        end}
)

