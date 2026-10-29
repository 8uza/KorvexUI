# KorvexUI

KorvexUI is a Roblox UI library inspired by Linoria, built for script developers who want a clean, customizable interface. It provides windows, tabs, groupboxes, and common controls with a consistent theme.

## Installation

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/8uza/KorvexUI/refs/heads/main/Korvex.lua")()
```

## Creating a Window

```lua
local Window = Library:CreateWindow({
    Title = "My Hub",
    Description = "Short description",
    Author = "by author",
    Center = true,
    AutoShow = true,
    Size = UDim2.fromOffset(550, 600)
})
```

Options:
- `Title` (string): window title.
- `Description` (string): loading subtitle description.
- `Author` (string): owner line.
- `Center` (boolean): center the window.
- `AutoShow` (boolean): show on creation.
- `Size` (UDim2): window size.

## Tabs and Groupboxes

```lua
local Tabs = {
    Main = Window:AddTab("Main"),
}

local M = Tabs.Main:AddLeftGroupbox("Movement")
local K = Tabs.Main:AddRightGroupbox("Keybinds")
```

- `Window:AddTab(name)` returns a tab object.
- `tab:AddLeftGroupbox(name)` / `AddRightGroupbox(name)` return a groupbox.

## Controls

All controls are added to a groupbox.

### Toggle
```lua
M:AddToggle("Glow", { Text = "Glow", Default = true, Callback = function(v) end })
```

### Slider
```lua
M:AddSlider("WalkSpeed", { Text = "Walk Speed", Min = 16, Max = 200, Default = 16, Callback = function(v) end })
```

### Dropdown
```lua
M:AddDropdown("Mode", { Text = "Mode", Values = {"A","B","C"}, Default = "A", Callback = function(v) end })
```

### Multi-Dropdown
```lua
M:AddMultiDropdown("Tags", { Text = "Tags", Values = {"Red","Green","Blue"}, Default = {} })
```

### Input
```lua
M:AddInput("Name", { Text = "Player Name", Default = "Korvex", Callback = function(v) end })
```

### Button
```lua
M:AddButton("Click Me", function() Library:Notify({ Text = "Clicked!", Duration = 2 }) end)
```

### Label
```lua
M:AddLabel("Hello from KorvexUI")
```

### Color Picker
```lua
M:AddColorPicker("Accent", { Text = "Accent", Default = Color3.fromRGB(0,170,255), Callback = function(c) end })
```

### Key Picker
```lua
M:AddKeyPicker("MenuKey", { Text = "Menu Key", Default = "RightShift", Callback = function(k) end })
```

### Section
```lua
M:AddSection("Buttons")
```

## Notifications
```lua
Library:Notify({ Text = "Message", Duration = 3 })
```

## Watermark
```lua
Library:EnableFPSWatermark()
Library:SetWatermarkVisibility(true)
```

## Config
```lua
Library:SaveConfig("korvex_config")
Library:LoadConfig("korvex_config")
```

## Loading Screen

Loading is automatic after `CreateWindow`. It shows stacked labels for tabs, elements, and functions with fake progress.

## Notes

- Main window is created but hidden until loading completes.
- Use `Window:Unload()` to remove the UI.
