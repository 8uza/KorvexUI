local cloneref = cloneref or clonereference or function(a)
        return a
    end
local b = cloneref(game:GetService("TweenService"))
local c = cloneref(game:GetService("UserInputService"))
local function d(e, f, g)
    b:Create(e, TweenInfo.new(g or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), f):Play()
end
local h = cloneref(game:GetService("Players"))
local i = cloneref(game:GetService("CoreGui"))
local j = h.LocalPlayer or h.PlayerAdded:Wait()
local function k(l, m)
    m = m or i
    pcall(
        function()
            l.Parent = m
        end
    )
    if not l.Parent then
        l.Parent = j:WaitForChild("PlayerGui")
    end
end
local n = Instance.new("ScreenGui")
n.Name = "KorvexUI"
n.IgnoreGuiInset = true
n.ZIndexBehavior = Enum.ZIndexBehavior.Global
n.DisplayOrder = 999
n.ResetOnSpawn = false
k(n)
local o = {
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
o.AccentElements = {}
o.Notifications = {}
o.WatermarkParts = {Name = true, FPS = true, Ping = true, Region = false}
o.WatermarkName = "KorvexUI"
o.ElementCount = 0
o.BlurEnabled = false
o.BlurStrength = 24
function o:UpdateBlur()
    local p = game:GetService("Lighting")
    local q = p:FindFirstChild("KorvexBlur")
    if self.Main and self.Main.Visible and o.BlurEnabled then
        if not q then
            q = Instance.new("BlurEffect")
            q.Name = "KorvexBlur"
            q.Size = o.BlurStrength
            q.Parent = p
        end
        q.Size = o.BlurStrength
    else
        if q then
            q:Destroy()
        end
    end
end
function o:RegisterAccent(r)
    table.insert(o.AccentElements, r)
end
function o:ApplyAccent(s)
    for t, r in ipairs(o.AccentElements) do
        if r and r.Parent then
            r.BackgroundColor3 = s
        end
    end
end
local function u(s, m)
    local a = Instance.new(s)
    if m then
        for v, w in pairs(m) do
            if v ~= "Parent" then
                a[v] = w
            end
        end
        if m.Parent then
            a.Parent = m.Parent
        end
    end
    return a
end
function o:CreateWindow(x)
    x = x or {}
    local y = x.Title or "KorvexUI"
    local z = x.Size or UDim2.fromOffset(550, 600)
    local A = x.Center
    local B = x.AutoShow
    if _G.KorvexUIInstances then
        for t, C in ipairs(_G.KorvexUIInstances) do
            pcall(
                function()
                    C:Destroy()
                end
            )
        end
    end
    _G.KorvexUIInstances = {n}
    local D =
        u(
        "Frame",
        {
            Name = "MainWindow",
            Visible = false,
            BackgroundColor3 = o.Theme.BackgroundColor,
            BackgroundTransparency = 0.15,
            BorderColor3 = o.Theme.OutlineColor,
            BorderSizePixel = 1,
            Size = z,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = A and UDim2.fromScale(0.5, 0.5) or UDim2.fromOffset(100, 100),
            Parent = n
        }
    )
    self.Main = D
    local E =
        u(
        "Frame",
        {Name = "TitleBar", BackgroundColor3 = Color3.fromRGB(30, 30, 30), Size = UDim2.new(1, 0, 0, 30), Parent = D}
    )
    local F = Instance.new("TextButton")
    F.Text = "K"
    F.Size = UDim2.fromOffset(40, 40)
    F.Position = UDim2.new(0.5, -20, 0, 10)
    F.BackgroundColor3 = o.Theme.AccentColor
    F.TextColor3 = o.Theme.FontColor
    F.BorderSizePixel = 0
    F.Visible = false
    F.Parent = n
    local G, H, I
    F.InputBegan:Connect(
        function(a)
            if a.UserInputType == Enum.UserInputType.MouseButton1 then
                G = true
                H = a.Position
                I = F.Position
            end
        end
    )
    c.InputChanged:Connect(
        function(a)
            if G and a.UserInputType == Enum.UserInputType.MouseMovement then
                local J = a.Position - H
                F.Position = UDim2.new(I.X.Scale, I.X.Offset + J.X, I.Y.Scale, I.Y.Offset + J.Y)
            end
        end
    )
    c.InputEnded:Connect(
        function(a)
            if a.UserInputType == Enum.UserInputType.MouseButton1 then
                G = false
            end
        end
    )
    o:RegisterAccent(F)
    local K = Instance.new("TextButton")
    K.Text = "-"
    K.TextScaled = true
    K.Size = UDim2.fromOffset(24, 24)
    K.Position = UDim2.new(1, -28, 0, 4)
    K.BackgroundColor3 = o.Theme.AccentColor
    K.TextColor3 = o.Theme.FontColor
    K.BorderSizePixel = 0
    K.Parent = E
    o:RegisterAccent(K)
    K.MouseButton1Click:Connect(
        function()
            d(D, {BackgroundTransparency = 1, Size = UDim2.new(D.Size.X.Scale, D.Size.X.Offset, 0, 0)}, 0.15)
            task.delay(
                0.15,
                function()
                    D.Visible = false
                    D.BackgroundTransparency = 0.15
                    D.Size = z
                    F.Visible = true
                    F.Size = UDim2.fromOffset(0, 0)
                    d(F, {Size = UDim2.fromOffset(40, 40)}, 0.2)
                    o:UpdateBlur()
                end
            )
        end
    )
    F.MouseButton1Click:Connect(
        function()
            d(F, {Size = UDim2.fromOffset(0, 0)}, 0.15)
            task.delay(
                0.15,
                function()
                    F.Visible = false
                    D.Size = UDim2.new(D.Size.X.Scale, D.Size.X.Offset, 0, 0)
                    D.Visible = true
                    d(D, {BackgroundTransparency = 0.15, Size = z}, 0.2)
                    o:UpdateBlur()
                end
            )
        end
    )
    local function L(M, N)
        local O = Instance.new("Frame")
        O.Size = N
        O.Position = M
        O.BackgroundColor3 = o.Theme.AccentColor
        O.BackgroundTransparency = 0.7
        O.BorderSizePixel = 0
        O.Parent = D
        o:RegisterAccent(O)
        return O
    end
    local P = L(UDim2.new(1, -3, 0, 30), UDim2.fromOffset(3, 0))
    P.Size = UDim2.new(0, 3, 1, -46)
    local Q = L(UDim2.new(0, 0, 1, -3), UDim2.fromOffset(0, 3))
    Q.Size = UDim2.new(1, -16, 0, 3)
    local R = L(UDim2.new(1, -10, 1, -10), UDim2.fromOffset(10, 10))
    R.BackgroundTransparency = 0.5
    local S = false
    local T
    local U
    local V = ""
    local function W(X, a)
        S = true
        V = X
        T = a.Position
        U = D.Size
    end
    P.InputBegan:Connect(
        function(a)
            if a.UserInputType == Enum.UserInputType.MouseButton1 then
                W("right", a)
            end
        end
    )
    Q.InputBegan:Connect(
        function(a)
            if a.UserInputType == Enum.UserInputType.MouseButton1 then
                W("bottom", a)
            end
        end
    )
    R.InputBegan:Connect(
        function(a)
            if a.UserInputType == Enum.UserInputType.MouseButton1 then
                W("corner", a)
            end
        end
    )
    c.InputChanged:Connect(
        function(a)
            if S and a.UserInputType == Enum.UserInputType.MouseMovement then
                local J = a.Position - T
                if V == "right" or V == "corner" then
                    D.Size = UDim2.fromOffset(math.max(300, U.X.Offset + J.X), D.Size.Y.Offset)
                end
                if V == "bottom" or V == "corner" then
                    D.Size = UDim2.fromOffset(D.Size.X.Offset, math.max(200, U.Y.Offset + J.Y))
                end
            end
        end
    )
    c.InputEnded:Connect(
        function(a)
            if a.UserInputType == Enum.UserInputType.MouseButton1 then
                S = false
            end
        end
    )
    u(
        "TextLabel",
        {
            Text = y,
            Font = o.Theme.Font,
            TextSize = 14,
            TextColor3 = o.Theme.FontColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.fromOffset(8, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = E
        }
    )
    local Y =
        u(
        "Frame",
        {
            Name = "TabHolder",
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Size = UDim2.new(0, 140, 1, -30),
            Position = UDim2.fromOffset(0, 30),
            Parent = D
        }
    )
    u("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = Y})
    local Z =
        u(
        "Frame",
        {
            Name = "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -140, 1, -30),
            Position = UDim2.fromOffset(140, 30),
            Parent = D
        }
    )
    self.Content = Z
    self.Tabs = {}
    self.ActiveTab = nil
    local _, a0, a1
    E.InputBegan:Connect(
        function(a)
            if a.UserInputType == Enum.UserInputType.MouseButton1 then
                _ = true
                a0 = a.Position
                a1 = D.Position
            end
        end
    )
    c.InputChanged:Connect(
        function(a)
            if _ and a.UserInputType == Enum.UserInputType.MouseMovement then
                local J = a.Position - a0
                D.Position = UDim2.new(a1.X.Scale, a1.X.Offset + J.X, a1.Y.Scale, a1.Y.Offset + J.Y)
            end
        end
    )
    c.InputEnded:Connect(
        function(a)
            if a.UserInputType == Enum.UserInputType.MouseButton1 then
                _ = false
            end
        end
    )
    c.InputBegan:Connect(
        function(a, a2)
            if a2 then
                return
            end
            if a.KeyCode == self.Keybind then
                if D.Visible then
                    d(D, {BackgroundTransparency = 1, Size = UDim2.new(D.Size.X.Scale, D.Size.X.Offset, 0, 0)}, 0.15)
                    task.delay(
                        0.15,
                        function()
                            D.Visible = false
                            D.BackgroundTransparency = 0.15
                            D.Size = z
                            F.Visible = true
                            F.Size = UDim2.fromOffset(0, 0)
                            d(F, {Size = UDim2.fromOffset(40, 40)}, 0.2)
                            o:UpdateBlur()
                        end
                    )
                else
                    D.Size = UDim2.new(D.Size.X.Scale, D.Size.X.Offset, 0, 0)
                    D.Visible = true
                    F.Visible = false
                    d(D, {BackgroundTransparency = 0.15, Size = z}, 0.2)
                    o:UpdateBlur()
                end
            end
        end
    )
    if not B then
        D.Visible = false
    end
    local function a3(a4, a5)
        local a6 =
            u(
            "Frame",
            {
                Name = a5,
                BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                BorderColor3 = o.Theme.OutlineColor,
                BorderSizePixel = 1,
                Size = UDim2.new(1, -12, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = a4.Frame
            }
        )
        u(
            "TextLabel",
            {
                Text = a5,
                Font = o.Theme.Font,
                TextSize = o.Theme.TextSize,
                TextColor3 = o.Theme.FontColor,
                BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                Size = UDim2.new(1, 0, 0, 20),
                Parent = a6
            }
        )
        local a7 =
            u(
            "Frame",
            {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, 20),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = a6
            }
        )
        u("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = a7})
        local a8 = {Name = a5, Frame = a6, Content = a7}
        function a8:AddToggle(a9, aa)
            aa = aa or {}
            local ab = u("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = a7})
            u(
                "TextLabel",
                {
                    Text = aa.Text or a9,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -30, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ab
                }
            )
            local ac =
                u(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.new(1, -18, 0.5, -8),
                    Parent = ab
                }
            )
            local ad =
                u(
                "Frame",
                {
                    BackgroundColor3 = o.Theme.AccentColor,
                    Size = UDim2.fromOffset(10, 10),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Visible = aa.Default or false,
                    Parent = ac
                }
            )
            o:RegisterAccent(ad)
            local ae = aa.Default or false
            local g = {Value = ae, Id = a9}
            o.Toggles[a9] = g
            local function af(w)
                ae = w
                g.Value = w
                if w then
                    ad.Visible = true
                    d(ad, {Size = UDim2.fromOffset(10, 10)}, 0.12)
                else
                    d(ad, {Size = UDim2.fromOffset(0, 0)}, 0.12)
                    task.delay(
                        0.12,
                        function()
                            if not ae then
                                ad.Visible = false
                            end
                        end
                    )
                end
                if aa.Callback then
                    aa.Callback(w)
                end
            end
            o.ElementCount = (o.ElementCount or 0) + 1
            g.SetValue = af
            g.Set = af
            ab.InputBegan:Connect(
                function(a)
                    if a.UserInputType == Enum.UserInputType.MouseButton1 then
                        af(not ae)
                    end
                end
            )
            if aa.Default then
                task.defer(
                    function()
                        if aa.Callback then
                            aa.Callback(true)
                        end
                    end
                )
            end
            return g
        end
        function a8:AddSlider(a9, aa)
            aa = aa or {}
            local ag = aa.Min or 0
            local ah = aa.Max or 100
            local ai = aa.Default or ag
            local ab = u("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Parent = a7})
            local aj =
                u(
                "TextLabel",
                {
                    Text = (aa.Text or a9) .. ": " .. ai,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ab
                }
            )
            local ak =
                u(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 12),
                    Position = UDim2.fromOffset(0, 20),
                    Parent = ab
                }
            )
            local al =
                u(
                "Frame",
                {BackgroundColor3 = o.Theme.AccentColor, Size = UDim2.new((ai - ag) / (ah - ag), 0, 1, 0), Parent = ak}
            )
            o:RegisterAccent(al)
            local am = ai
            local an = {Value = am, Id = a9}
            o.Options[a9] = an
            local function af(w)
                w = math.clamp(w, ag, ah)
                am = w
                an.Value = w
                d(al, {Size = UDim2.new((w - ag) / (ah - ag), 0, 1, 0)}, 0.2)
                aj.Text = (aa.Text or a9) .. ": " .. w
                if aa.Callback then
                    aa.Callback(w)
                end
            end
            o.ElementCount = (o.ElementCount or 0) + 1
            an.SetValue = af
            an.Set = af
            local ao = false
            ak.InputBegan:Connect(
                function(a)
                    if a.UserInputType == Enum.UserInputType.MouseButton1 then
                        ao = true
                    end
                end
            )
            c.InputEnded:Connect(
                function(a)
                    if a.UserInputType == Enum.UserInputType.MouseButton1 then
                        ao = false
                    end
                end
            )
            c.InputChanged:Connect(
                function(a)
                    if ao and a.UserInputType == Enum.UserInputType.MouseMovement then
                        local ap = (a.Position.X - ak.AbsolutePosition.X) / ak.AbsoluteSize.X
                        af(ag + (ah - ag) * math.clamp(ap, 0, 1))
                    end
                end
            )
            return an
        end
        function a8:AddDropdown(a9, aa)
            aa = aa or {}
            local aq = aa.Values or {}
            local ai = aa.Default
            local ab = u("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Parent = a7})
            u(
                "TextLabel",
                {
                    Text = aa.Text or a9,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ab
                }
            )
            local ar =
                u(
                "TextButton",
                {
                    Text = tostring(ai or aq[1] or ""),
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 20),
                    Position = UDim2.fromOffset(0, 18),
                    Parent = ab
                }
            )
            local am = ai or aq[1]
            local as = {Value = am, Id = a9, Values = aq}
            o.Options[a9] = as
            local at =
                u(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 38),
                    Visible = false,
                    ZIndex = 100,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = ab
                }
            )
            local au = u("UIListLayout", {Parent = at})
            au:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
                function()
                    at.Size = UDim2.new(1, 0, 0, au.AbsoluteContentSize.Y)
                end
            )
            for t, w in ipairs(aq) do
                local av =
                    u(
                    "TextButton",
                    {
                        Text = tostring(w),
                        Font = o.Theme.Font,
                        TextSize = o.Theme.TextSize,
                        TextColor3 = Color3.new(1, 1, 1),
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        Size = UDim2.new(1, 0, 0, 18),
                        ZIndex = 101,
                        TextScaled = true,
                        Parent = at
                    }
                )
                av.MouseButton1Click:Connect(
                    function()
                        am = w
                        as.Value = w
                        ar.Text = tostring(w)
                        at.Visible = false
                        if aa.Callback then
                            aa.Callback(w)
                        end
                    end
                )
            end
            ar.MouseButton1Click:Connect(
                function()
                    at.Visible = not at.Visible
                end
            )
            o.ElementCount = (o.ElementCount or 0) + 1
            function as:SetValue(w)
                am = w
                as.Value = w
                ar.Text = tostring(w)
                if aa.Callback then
                    aa.Callback(w)
                end
            end
            return as
        end
        function a8:AddButton(aw, ax)
            local ay =
                u(
                "TextButton",
                {
                    Text = aw,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 22),
                    Parent = a7
                }
            )
            ay.MouseButton1Click:Connect(
                function()
                    if ax then
                        ax()
                    end
                end
            )
            return ay
        end
        function a8:AddLabel(aw)
            return u(
                "TextLabel",
                {
                    Text = aw,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = a7
                }
            )
        end
        function a8:AddDivider()
            return u("Frame", {BackgroundColor3 = o.Theme.OutlineColor, Size = UDim2.new(1, 0, 0, 1), Parent = a7})
        end
        function a8:AddKeyPicker(a9, aa)
            aa = aa or {}
            local ab = u("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = a7})
            u(
                "TextLabel",
                {
                    Text = aa.Text or a9,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -60, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ab
                }
            )
            local az =
                u(
                "TextButton",
                {
                    Text = tostring(aa.Default or "None"),
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.fromOffset(56, 18),
                    Position = UDim2.new(1, -58, 0.5, -9),
                    TextScaled = true,
                    Parent = ab
                }
            )
            local aA = {Value = aa.Default, Id = a9}
            o.Options[a9] = aA
            local aB = false
            az.MouseButton1Click:Connect(
                function()
                    aB = true
                    az.Text = "..."
                end
            )
            c.InputBegan:Connect(
                function(a, a2)
                    if aB and a.UserInputType == Enum.UserInputType.Keyboard then
                        aB = false
                        aA.Value = a.KeyCode.Name
                        az.Text = a.KeyCode.Name
                        if aa.Callback then
                            aa.Callback(a.KeyCode)
                        end
                    end
                end
            )
            return aA
        end
        function a8:AddInput(a9, aa)
            aa = aa or {}
            local ab = u("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), Parent = a7})
            u(
                "TextLabel",
                {
                    Text = aa.Text or a9,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ab
                }
            )
            local ac =
                u(
                "TextBox",
                {
                    Text = aa.Default or "",
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.fromOffset(0, 16),
                    ClearTextOnFocus = false,
                    Parent = ab
                }
            )
            local aC = {Value = ac.Text, Id = a9}
            o.Options[a9] = aC
            ac.FocusLost:Connect(
                function()
                    aC.Value = ac.Text
                    if aa.Callback then
                        aa.Callback(ac.Text)
                    end
                end
            )
            function aC:SetValue(w)
                ac.Text = w
                aC.Value = w
            end
            return aC
        end
        function a8:AddColorPicker(a9, aa)
            aa = aa or {}
            local aD = aa.Default or Color3.fromRGB(255, 0, 0)
            local ab = u("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 74), Parent = a7})
            u(
                "TextLabel",
                {
                    Text = aa.Text or a9,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ab
                }
            )
            local aE =
                u(
                "Frame",
                {
                    BackgroundColor3 = aD,
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.fromOffset(24, 24),
                    Position = UDim2.fromOffset(0, 18),
                    Parent = ab
                }
            )
            local function aF(aG, aH, aI)
                local aJ =
                    u(
                    "TextLabel",
                    {
                        Text = aG .. ": " .. aI,
                        Font = o.Theme.Font,
                        TextSize = 11,
                        TextColor3 = o.Theme.FontColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -30, 0, 14),
                        Position = UDim2.fromOffset(30, aH),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = ab
                    }
                )
                local ak =
                    u(
                    "Frame",
                    {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                        BorderColor3 = o.Theme.OutlineColor,
                        Size = UDim2.new(1, -30, 0, 6),
                        Position = UDim2.fromOffset(30, aH + 14),
                        Parent = ab
                    }
                )
                local al =
                    u(
                    "Frame",
                    {BackgroundColor3 = o.Theme.AccentColor, Size = UDim2.new(aI / 255, 0, 1, 0), Parent = ak}
                )
                return aJ, ak, al
            end
            local aK, aL, aM = aF("R", 18, math.floor(aD.R * 255))
            local aN, aO, aP = aF("G", 36, math.floor(aD.G * 255))
            local aQ, aR, aS = aF("B", 54, math.floor(aD.B * 255))
            local aT, C, O = math.floor(aD.R * 255), math.floor(aD.G * 255), math.floor(aD.B * 255)
            local aU = {Value = aD, Id = a9}
            o.Options[a9] = aU
            local function aV()
                local s = Color3.fromRGB(aT, C, O)
                aE.BackgroundColor3 = s
                aU.Value = s
                if aa.Callback then
                    aa.Callback(s)
                end
            end
            local function aW(aj, ak, al, aX)
                local ao = false
                ak.InputBegan:Connect(
                    function(a)
                        if a.UserInputType == Enum.UserInputType.MouseButton1 then
                            ao = true
                        end
                    end
                )
                c.InputEnded:Connect(
                    function(a)
                        if a.UserInputType == Enum.UserInputType.MouseButton1 then
                            ao = false
                        end
                    end
                )
                c.InputChanged:Connect(
                    function(a)
                        if ao and a.UserInputType == Enum.UserInputType.MouseMovement then
                            local ap = math.clamp((a.Position.X - ak.AbsolutePosition.X) / ak.AbsoluteSize.X, 0, 1)
                            local w = math.floor(ap * 255)
                            if aX == "r" then
                                aT = w
                            elseif aX == "g" then
                                C = w
                            else
                                O = w
                            end
                            al.Size = UDim2.new(ap, 0, 1, 0)
                            aj.Text = (aX == "r" and "R" or aX == "g" and "G" or "B") .. ": " .. w
                            aV()
                        end
                    end
                )
            end
            aW(aK, aL, aM, "r")
            aW(aN, aO, aP, "g")
            aW(aQ, aR, aS, "b")
            function aU:SetValue(s)
                aT, C, O = math.floor(s.R * 255), math.floor(s.G * 255), math.floor(s.B * 255)
                aE.BackgroundColor3 = s
                aU.Value = s
            end
            return aU
        end
        function a8:AddSection(aw)
            local aY =
                u(
                "TextLabel",
                {
                    Text = aw,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.AccentColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = a7
                }
            )
            return aY
        end
        function a8:AddMultiDropdown(a9, aa)
            aa = aa or {}
            local aq = aa.Values or {}
            local aZ = {}
            local ab = u("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 44), Parent = a7})
            u(
                "TextLabel",
                {
                    Text = aa.Text or a9,
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ab
                }
            )
            local a_ =
                u(
                "TextBox",
                {
                    Text = "",
                    PlaceholderText = "Search...",
                    Font = o.Theme.Font,
                    TextSize = 11,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 16),
                    Position = UDim2.fromOffset(0, 16),
                    Parent = ab
                }
            )
            local ay =
                u(
                "TextButton",
                {
                    Text = "Select...",
                    Font = o.Theme.Font,
                    TextSize = o.Theme.TextSize,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 16),
                    Position = UDim2.fromOffset(0, 32),
                    Parent = ab
                }
            )
            local at =
                u(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BorderColor3 = o.Theme.OutlineColor,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 48),
                    Visible = false,
                    ZIndex = 100,
                    Parent = ab
                }
            )
            local au = u("UIListLayout", {Parent = at})
            au:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
                function()
                    at.Size = UDim2.new(1, 0, 0, au.AbsoluteContentSize.Y)
                end
            )
            local b0 = {Value = aZ, Id = a9}
            o.Options[a9] = b0
            local function b1()
                local b2 = {}
                for t, w in ipairs(aZ) do
                    table.insert(b2, tostring(w))
                end
                ay.Text = #b2 > 0 and table.concat(b2, ", ") or "Select..."
            end
            local function b3(b4)
                for t, s in ipairs(at:GetChildren()) do
                    if s:IsA("TextButton") then
                        s:Destroy()
                    end
                end
                for t, w in ipairs(aq) do
                    if b4 == "" or string.find(string.lower(tostring(w)), string.lower(b4), 1, true) then
                        local b5 = false
                        for t, an in ipairs(aZ) do
                            if an == w then
                                b5 = true
                            end
                        end
                        local av =
                            u(
                            "TextButton",
                            {
                                Text = (b5 and "[x] " or "[ ] ") .. tostring(w),
                                Font = o.Theme.Font,
                                TextSize = 11,
                                TextColor3 = Color3.new(1, 1, 1),
                                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                                Size = UDim2.new(1, 0, 0, 16),
                                ZIndex = 101,
                                TextScaled = true,
                                Parent = at
                            }
                        )
                        av.MouseButton1Click:Connect(
                            function()
                                if b5 then
                                    for a, an in ipairs(aZ) do
                                        if an == w then
                                            table.remove(aZ, a)
                                        end
                                    end
                                else
                                    table.insert(aZ, w)
                                end
                                b1()
                                b3(a_.Text)
                            end
                        )
                    end
                end
            end
            a_:GetPropertyChangedSignal("Text"):Connect(
                function()
                    b3(a_.Text)
                end
            )
            b3("")
            ay.MouseButton1Click:Connect(
                function()
                    at.Visible = not at.Visible
                end
            )
            function b0:SetValue(g)
                aZ = g or {}
                b1()
            end
            return b0
        end
        function a8:AddTabbox()
            local b6 =
                u(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = a7
                }
            )
            local b7 =
                u("Frame", {BackgroundColor3 = Color3.fromRGB(28, 28, 28), Size = UDim2.new(1, 0, 0, 20), Parent = b6})
            local b8 =
                u(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 20),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = b6
                }
            )
            local b9 = {}
            local ba = nil
            local bb = u("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Parent = b7})
            local function bc(bd)
                local ay =
                    u(
                    "TextButton",
                    {
                        Text = bd,
                        Font = o.Theme.Font,
                        TextSize = o.Theme.TextSize,
                        TextColor3 = o.Theme.FontColor,
                        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                        Size = UDim2.new(0, 60, 1, 0),
                        Parent = b7
                    }
                )
                local be =
                    u(
                    "Frame",
                    {
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Visible = false,
                        Parent = b8
                    }
                )
                u("UIListLayout", {Padding = UDim.new(0, 4), Parent = be})
                local g = {Name = bd, Button = ay, Frame = be, Content = be}
                function g:AddToggle(a9, aa)
                    return a8.AddToggle and nil
                end
                b9[bd] = g
                ay.MouseButton1Click:Connect(
                    function()
                        for t, bf in pairs(b9) do
                            bf.Frame.Visible = false
                            bf.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                        end
                        be.Visible = true
                        ay.BackgroundColor3 = o.Theme.AccentColor
                    end
                )
                if not ba then
                    ba = g
                    be.Visible = true
                    ay.BackgroundColor3 = o.Theme.AccentColor
                end
                return g
            end
            local ac = {Tabs = b9, AddTab = bc, Frame = b6}
            return ac
        end
        function a8:AddDependencyBox()
            local bg =
                u(
                "Frame",
                {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = a7
                }
            )
            local bh = {}
            function bg:SetupDependencies(bi)
                bh = bi or {}
            end
            bg.Visible = true
            u("UIListLayout", {Padding = UDim.new(0, 4), Parent = bg})
            return bg
        end
        return a8
    end
    function self:AddTab(bd)
        local bj =
            u(
            "TextButton",
            {
                Text = bd,
                Font = o.Theme.Font,
                TextSize = o.Theme.TextSize,
                TextColor3 = o.Theme.FontColor,
                BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                BorderColor3 = o.Theme.OutlineColor,
                BorderSizePixel = 1,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = Y
            }
        )
        local bk =
            u(
            "ScrollingFrame",
            {
                Name = bd,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 4,
                Visible = false,
                Parent = Z
            }
        )
        local bl = u("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = bk})
        bl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(
            function()
                bk.CanvasSize = UDim2.new(0, 0, 0, bl.AbsoluteContentSize.Y + 8)
            end
        )
        u(
            "UIPadding",
            {PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = bk}
        )
        local a4 = {Name = bd, Button = bj, Frame = bk, Groups = {}}
        table.insert(self.Tabs, a4)
        local bm = nil
        for a, g in ipairs(self.Tabs) do
            if g.Name == "Korvex Settings" and g ~= a4 then
                bm = g
            end
        end
        if bm then
            for a, g in ipairs(self.Tabs) do
                if g == bm then
                    table.remove(self.Tabs, a)
                    break
                end
            end
            table.insert(self.Tabs, bm)
            bm.Button.Parent = nil
            bm.Button.Parent = Y
        end
        bj.MouseButton1Click:Connect(
            function()
                for t, g in ipairs(self.Tabs) do
                    g.Frame.Visible = false
                    g.Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                end
                a4.Frame.Visible = true
                a4.Frame.Position = UDim2.fromOffset(8, 0)
                d(a4.Frame, {Position = UDim2.fromOffset(0, 0)}, 0.15)
                bj.BackgroundColor3 = o.Theme.AccentColor
            end
        )
        function a4:AddLeftGroupbox(a5)
            return a3(a4, a5)
        end
        function a4:AddRightGroupbox(a5)
            return a3(a4, a5)
        end
        function a4:AddGroupbox(a5, bn)
            return a3(a4, a5)
        end
        if not self.ActiveTab then
            self.ActiveTab = a4
            a4.Frame.Visible = true
            bj.BackgroundColor3 = o.Theme.AccentColor
        end
        return a4
    end
    function self:Notify(aw, bo)
        if typeof(aw) == "table" then
            local bp = aw
            aw = bp.Text or ""
            bo = bp.Duration or bo or 3
        end
        bo = bo or 3
        local bn = self.NotifySide or "Left"
        local bq =
            u(
            "Frame",
            {
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                BorderColor3 = o.Theme.OutlineColor,
                BorderSizePixel = 1,
                Size = UDim2.fromOffset(260, 44),
                Parent = n
            }
        )
        bq.Name = "KorvexNotify"
        table.insert(o.Notifications, bq)
        local aH = 0
        for t, s in ipairs(n:GetChildren()) do
            if s.Name == "KorvexNotify" and s ~= bq then
                aH = aH + 48
            end
        end
        if bn == "Left" then
            bq.Position = UDim2.new(0, -270, 1, -50 - aH)
            d(bq, {Position = UDim2.new(0, 10, 1, -50 - aH)}, 0.2)
        else
            bq.Position = UDim2.new(1, 10, 1, -50 - aH)
            d(bq, {Position = UDim2.new(1, -270, 1, -50 - aH)}, 0.2)
        end
        u(
            "TextLabel",
            {
                Text = aw,
                Font = o.Theme.Font,
                TextSize = o.Theme.TextSize,
                TextColor3 = o.Theme.FontColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -8, 1, 0),
                Position = UDim2.fromOffset(4, 0),
                TextWrapped = true,
                Parent = bq
            }
        )
        task.delay(
            bo,
            function()
                d(bq, {BackgroundTransparency = 1}, 0.2)
                for t, s in ipairs(bq:GetChildren()) do
                    if s:IsA("TextLabel") then
                        d(s, {TextTransparency = 1}, 0.2)
                    end
                end
                task.delay(
                    0.2,
                    function()
                        bq:Destroy()
                        local bn = o.NotifySide or "Left"
                        local aH = 0
                        for t, br in ipairs(o.Notifications) do
                            if br ~= bq and br.Parent then
                                if bn == "Left" then
                                    d(br, {Position = UDim2.new(0, 10, 1, -50 - aH)}, 0.15)
                                else
                                    d(br, {Position = UDim2.new(1, -270, 1, -50 - aH)}, 0.15)
                                end
                                aH = aH + 48
                            end
                        end
                        for a, br in ipairs(o.Notifications) do
                            if br == bq then
                                table.remove(o.Notifications, a)
                                break
                            end
                        end
                    end
                )
            end
        )
    end
    function self:SetWatermark(aw)
        if not self.Watermark then
            self.Watermark =
                u(
                "Frame",
                {
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 0.3,
                    BorderSizePixel = 0,
                    Size = UDim2.fromOffset(220, 20),
                    Position = UDim2.new(1, -230, 0, 8),
                    Parent = n
                }
            )
            self.WatermarkLabel =
                u(
                "TextLabel",
                {
                    Text = aw,
                    Font = o.Theme.Font,
                    TextSize = 12,
                    TextColor3 = o.Theme.FontColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -8, 1, 0),
                    Position = UDim2.fromOffset(4, 0),
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = self.Watermark
                }
            )
        else
            if self.WatermarkLabel then
                self.WatermarkLabel.Text = aw
                task.defer(
                    function()
                        if self.Watermark and self.WatermarkLabel then
                            local bs = math.max(20, self.WatermarkLabel.TextBounds.X + 12)
                            self.Watermark.Size = UDim2.fromOffset(bs, 20)
                            self.Watermark.Position = UDim2.new(1, -(bs + 10), 0, 8)
                            self.Watermark.Visible = aw ~= ""
                        end
                    end
                )
            end
        end
    end
    function self:EnableFPSWatermark()
        local bt, bu, bv = 60, 0, tick()
        self._fpsConn =
            game:GetService("RunService").RenderStepped:Connect(
            function()
                if self.Unloaded then
                    self._fpsConn:Disconnect()
                    return
                end
                bu = bu + 1
                if tick() - bv >= 1 then
                    bt = bu
                    bu = 0
                    bv = tick()
                end
                local bw = 0
                pcall(
                    function()
                        bw = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
                    end
                )
                local bx = {}
                if o.WatermarkParts.Name then
                    table.insert(bx, o.WatermarkName)
                end
                if o.WatermarkParts.FPS then
                    table.insert(bx, bt .. " fps")
                end
                if o.WatermarkParts.Ping then
                    table.insert(bx, bw .. " ms")
                end
                if o.WatermarkParts.Region then
                    table.insert(bx, tostring(game:GetService("LocalizationService").RobloxLocaleId))
                end
                self:SetWatermark(table.concat(bx, " | "))
            end
        )
    end
    function self:SetWatermarkVisibility(w)
        if self.Watermark then
            self.Watermark.Visible = w
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
            for a, C in ipairs(_G.KorvexUIInstances) do
                if C == n then
                    table.remove(_G.KorvexUIInstances, a)
                    break
                end
            end
        end
        n:Destroy()
    end
    local by =
        u(
        "TextLabel",
        {
            Text = "",
            Font = o.Theme.Font,
            TextSize = 14,
            TextColor3 = o.Theme.FontColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0.58, 0),
            Visible = not key,
            Parent = overlay
        }
    )
    function o:CreateLoadingScreen(x)
        x = x or {}
        local bz = x.Subtitle or "Loading..."
        local bA = x.Description or ""
        local bB = x.Owner or ""
        local key = x.Key
        local overlay =
            u(
            "Frame",
            {
                BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                BackgroundTransparency = 0,
                Size = UDim2.fromScale(1, 1),
                Parent = n
            }
        )
        local y =
            u(
            "TextLabel",
            {
                Text = "KorvexUI",
                Font = o.Theme.Font,
                TextSize = 48,
                TextColor3 = o.Theme.AccentColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 60),
                Position = UDim2.new(0, 0, 0.35, 0),
                Parent = overlay
            }
        )
        local bC =
            u(
            "TextLabel",
            {
                Text = bz,
                Font = o.Theme.Font,
                TextSize = 18,
                TextColor3 = o.Theme.FontColor,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 24),
                Position = UDim2.new(0, 0, 0.42, 0),
                Visible = not key,
                Parent = overlay
            }
        )
        local bD =
            u(
            "TextLabel",
            {
                Text = bA,
                Font = o.Theme.Font,
                TextSize = 13,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0.46, 0),
                Visible = not key,
                Parent = overlay
            }
        )
        local bE =
            u(
            "TextLabel",
            {
                Text = bB,
                Font = o.Theme.Font,
                TextSize = 12,
                TextColor3 = Color3.fromRGB(120, 120, 120),
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Visible = not key,
                Position = UDim2.fromOffset(0, 0.9),
                Parent = overlay
            }
        )
        local bF = nil
        y.TextTransparency = 1
        d(y, {TextTransparency = 0}, 0.4)
        local b9 = math.random(1, 6)
        local bG = math.random(10, 35)
        local bH = math.random(80, 150)
        local bI = {
            {name = "Loading tabs", total = b9},
            {name = "Loading elements", total = bG},
            {name = "Loading functions", total = bH}
        }
        local bJ = 0
        local bK = 0
        for t, an in ipairs(bI) do
            bK = bK + an.total
        end
        if bK == 0 then
            bK = 1
        end
        local function bL()
            task.spawn(
                function()
                    local bM =
                        u(
                        "TextLabel",
                        {
                            Text = "Tabs: 0/" .. b9,
                            Font = o.Theme.Font,
                            TextSize = 14,
                            TextColor3 = o.Theme.FontColor,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 18),
                            Position = UDim2.new(0, 0, 0.5, 0),
                            Parent = overlay
                        }
                    )
                    local bN =
                        u(
                        "TextLabel",
                        {
                            Text = "Elements: 0/" .. bG,
                            Font = o.Theme.Font,
                            TextSize = 14,
                            TextColor3 = o.Theme.FontColor,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 18),
                            Position = UDim2.new(0, 0, 0.53, 0),
                            Parent = overlay
                        }
                    )
                    local bO =
                        u(
                        "TextLabel",
                        {
                            Text = "Functions: 0/" .. bH,
                            Font = o.Theme.Font,
                            TextSize = 14,
                            TextColor3 = o.Theme.FontColor,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 18),
                            Position = UDim2.new(0, 0, 0.56, 0),
                            Parent = overlay
                        }
                    )
                    for t, an in ipairs(bI) do
                        by.Text = an.name .. " (" .. an.total .. ")"
                        local bo = math.random(80, 120) / 100
                        local bP = bJ
                        local bQ = an.total / bK
                        for g = 0, 1, 0.05 do
                            if o.Unloaded then
                                return
                            end
                            task.wait(bo / 20)
                            if by then
                                by.Text = an.name .. " (" .. an.total .. ")"
                            end
                            bJ = bP + bQ * g
                            if an.name == "Loading tabs" then
                                bM.Text = "Tabs: " .. math.floor(an.total * g) .. "/" .. an.total
                            elseif an.name == "Loading elements" then
                                bN.Text = "Elements: " .. math.floor(an.total * g) .. "/" .. an.total
                            elseif an.name == "Loading functions" then
                                bO.Text = "Functions: " .. math.floor(an.total * g) .. "/" .. an.total
                            end
                        end
                        bJ = bP + bQ
                    end
                    task.wait(0.3)
                    d(overlay, {BackgroundTransparency = 1}, 0.4)
                    task.delay(
                        0.4,
                        function()
                            overlay:Destroy()
                            if self.Main then
                                self.Main.Visible = true
                                self.Main.Size = UDim2.new(self.Main.Size.X.Scale, self.Main.Size.X.Offset, 0, 0)
                                d(self.Main, {BackgroundTransparency = 0.15, Size = z}, 0.25)
                            end
                        end
                    )
                end
            )
        end
        o._loadFn = bL
        bL()
        local bR = self.ActiveTab
        local bS = self:AddTab("Korvex Settings")
        if bR then
            self.ActiveTab = bR
            for t, g in ipairs(self.Tabs) do
                g.Frame.Visible = g == bR
                g.Button.BackgroundColor3 = g == bR and o.Theme.AccentColor or Color3.fromRGB(28, 28, 28)
            end
        end
        local bT = bS:AddLeftGroupbox("Settings")
        bT:AddColorPicker(
            "AccentColor",
            {Text = "Accent Color", Default = self.Theme.AccentColor, Callback = function(s)
                    self.Theme.AccentColor = s
                    self:ApplyAccent(s)
                end}
        )
        bT:AddKeyPicker(
            "UIKeybind",
            {Text = "Toggle UI Keybind", Default = "RightShift", Callback = function(v)
                    self.Keybind = v
                end}
        )
        bT:AddInput(
            "WatermarkName",
            {Text = "Watermark Name", Default = o.WatermarkName, Callback = function(w)
                    o.WatermarkName = w
                end}
        )
        bT:AddToggle(
            "WMName",
            {Text = "Show Name", Default = true, Callback = function(w)
                    o.WatermarkParts.Name = w
                end}
        )
        bT:AddToggle(
            "WMFPS",
            {Text = "Show FPS", Default = true, Callback = function(w)
                    o.WatermarkParts.FPS = w
                end}
        )
        bT:AddToggle(
            "WMPing",
            {Text = "Show Ping", Default = true, Callback = function(w)
                    o.WatermarkParts.Ping = w
                end}
        )
        bT:AddToggle(
            "WMRegion",
            {Text = "Show Region", Default = false, Callback = function(w)
                    o.WatermarkParts.Region = w
                end}
        )
        bT:AddButton(
            "Save Config",
            function()
                o:SaveConfig("korvex_config")
                o:Notify({Text = "Config saved", Duration = 2})
            end
        )
        bT:AddButton(
            "Load Config",
            function()
                o:LoadConfig("korvex_config")
                o:Notify({Text = "Config loaded", Duration = 2})
            end
        )
        bT:AddButton(
            "Unload",
            function()
                self:Unload()
            end
        )
        bT:AddToggle(
            "InMenuEffects",
            {
                Text = "In-Menu Effects",
                Default = true,
                Callback = function(w)
                    if w then
                        if not self._effects then
                            self._effects = {}
                            for a = 1, 24 do
                                local m =
                                    u(
                                    "Frame",
                                    {
                                        BackgroundColor3 = o.Theme.AccentColor,
                                        BackgroundTransparency = 0.7,
                                        BorderSizePixel = 0,
                                        Size = UDim2.fromOffset(6, 6),
                                        Position = UDim2.fromScale(math.random(), math.random()),
                                        Parent = n
                                    }
                                )
                                o:RegisterAccent(m)
                                table.insert(self._effects, m)
                            end
                            self._effectsConn =
                                game:GetService("RunService").RenderStepped:Connect(
                                function()
                                    if self.Unloaded then
                                        return
                                    end
                                    for t, m in ipairs(self._effects) do
                                        if m and m.Parent then
                                            m.Visible = self.Main and self.Main.Visible
                                            m.Position =
                                                UDim2.fromScale(
                                                (m.Position.X.Scale + 0.001) % 1,
                                                (m.Position.Y.Scale + 0.0007) % 1
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
                            for t, m in ipairs(self._effects) do
                                m:Destroy()
                            end
                            self._effects = nil
                        end
                    end
                end
            }
        )
    end
    self:CreateLoadingScreen(
        {Subtitle = x.Title or "Loading...", Description = x.Description or "", Owner = x.Author or ""}
    )
    return self
end
function o:UpdateBlur()
end
function o:SaveConfig(bd)
    if not writefile then
        return
    end
    local bU = {}
    for a9, bp in pairs(o.Options) do
        bU[a9] = bp.Value
    end
    for a9, g in pairs(o.Toggles) do
        bU[a9] = g.Value
    end
    writefile(bd .. ".json", game:GetService("HttpService"):JSONEncode(bU))
end
function o:LoadConfig(bd)
    if not readfile or not isfile or not isfile(bd .. ".json") then
        return
    end
    local bV, bU =
        pcall(
        function()
            return game:GetService("HttpService"):JSONDecode(readfile(bd .. ".json"))
        end
    )
    if not bV then
        return
    end
    for a9, w in pairs(bU) do
        if o.Options[a9] and o.Options[a9].SetValue then
            pcall(
                function()
                    o.Options[a9]:SetValue(w)
                end
            )
        elseif o.Toggles[a9] and o.Toggles[a9].SetValue then
            pcall(
                function()
                    o.Toggles[a9]:SetValue(w)
                end
            )
        end
    end
end
return setmetatable(
    o,
    {__call = function(t, ...)
            return o:CreateWindow(...)
        end}
)
