--[[
  Koli UI v2
  https://raw.githubusercontent.com/SENIN_REPON/KoliUI/main/KoliUI.lua

  Kullanim:
  local Koli = loadstring(game:HttpGet("..."))()
  local win = Koli:CreateWindow({Name = "Hub"})
  local tab = win:MakeTab({Name = "Ana"})
  local sec = tab:AddSection({Name = "Aimbot"})
  sec:AddToggle({Name = "Aktif", Callback = function(v) end})
]]

local Koli = {}
local UIS = game:GetService("UserInputService")
local parent = (gethui and pcall(gethui) and gethui()) or game:GetService("CoreGui")
local TS = game:GetService("TweenService")
local RunS = game:GetService("RunService")

-- ====== THEMES ======
Koli.Themes = {
    Dark = {
        Main = Color3.fromRGB(18, 18, 28), Second = Color3.fromRGB(24, 24, 38),
        Third = Color3.fromRGB(35, 35, 50), Text = Color3.fromRGB(185, 185, 210),
        Accent = Color3.fromRGB(100, 140, 255), ToggleOn = Color3.fromRGB(55, 140, 55),
        ToggleOff = Color3.fromRGB(48, 48, 62), Danger = Color3.fromRGB(175, 45, 45),
        Input = Color3.fromRGB(40, 40, 55), Border = Color3.fromRGB(38, 38, 52),
        SectionBg = Color3.fromRGB(23, 23, 35), Success = Color3.fromRGB(50, 180, 50),
        Warning = Color3.fromRGB(220, 170, 40), Info = Color3.fromRGB(60, 140, 220)
    },
    Light = {
        Main = Color3.fromRGB(235, 235, 245), Second = Color3.fromRGB(225, 225, 238),
        Third = Color3.fromRGB(210, 210, 225), Text = Color3.fromRGB(35, 35, 50),
        Accent = Color3.fromRGB(70, 120, 255), ToggleOn = Color3.fromRGB(50, 180, 50),
        ToggleOff = Color3.fromRGB(195, 195, 210), Danger = Color3.fromRGB(200, 50, 50),
        Input = Color3.fromRGB(215, 215, 230), Border = Color3.fromRGB(200, 200, 215),
        SectionBg = Color3.fromRGB(225, 225, 238), Success = Color3.fromRGB(40, 170, 40),
        Warning = Color3.fromRGB(210, 160, 30), Info = Color3.fromRGB(50, 130, 220)
    },
    Blue = {
        Main = Color3.fromRGB(8, 14, 32), Second = Color3.fromRGB(12, 22, 48),
        Third = Color3.fromRGB(20, 36, 65), Text = Color3.fromRGB(180, 200, 230),
        Accent = Color3.fromRGB(0, 140, 255), ToggleOn = Color3.fromRGB(0, 180, 100),
        ToggleOff = Color3.fromRGB(25, 40, 70), Danger = Color3.fromRGB(200, 40, 40),
        Input = Color3.fromRGB(18, 30, 58), Border = Color3.fromRGB(25, 42, 75),
        SectionBg = Color3.fromRGB(12, 20, 42), Success = Color3.fromRGB(0, 200, 80),
        Warning = Color3.fromRGB(230, 180, 30), Info = Color3.fromRGB(40, 150, 240)
    },
    Purple = {
        Main = Color3.fromRGB(18, 12, 28), Second = Color3.fromRGB(28, 20, 42),
        Third = Color3.fromRGB(42, 30, 60), Text = Color3.fromRGB(200, 190, 220),
        Accent = Color3.fromRGB(150, 80, 255), ToggleOn = Color3.fromRGB(100, 180, 70),
        ToggleOff = Color3.fromRGB(48, 38, 62), Danger = Color3.fromRGB(190, 40, 60),
        Input = Color3.fromRGB(38, 28, 55), Border = Color3.fromRGB(50, 38, 68),
        SectionBg = Color3.fromRGB(22, 16, 35), Success = Color3.fromRGB(70, 190, 70),
        Warning = Color3.fromRGB(230, 180, 30), Info = Color3.fromRGB(100, 100, 240)
    },
    Red = {
        Main = Color3.fromRGB(28, 12, 12), Second = Color3.fromRGB(42, 18, 18),
        Third = Color3.fromRGB(58, 28, 28), Text = Color3.fromRGB(220, 180, 180),
        Accent = Color3.fromRGB(255, 60, 60), ToggleOn = Color3.fromRGB(180, 100, 40),
        ToggleOff = Color3.fromRGB(58, 30, 30), Danger = Color3.fromRGB(200, 20, 20),
        Input = Color3.fromRGB(50, 22, 22), Border = Color3.fromRGB(62, 32, 32),
        SectionBg = Color3.fromRGB(32, 16, 16), Success = Color3.fromRGB(50, 180, 50),
        Warning = Color3.fromRGB(230, 180, 30), Info = Color3.fromRGB(60, 140, 220)
    },
    Green = {
        Main = Color3.fromRGB(10, 24, 16), Second = Color3.fromRGB(14, 34, 22),
        Third = Color3.fromRGB(22, 48, 32), Text = Color3.fromRGB(180, 220, 190),
        Accent = Color3.fromRGB(50, 220, 100), ToggleOn = Color3.fromRGB(30, 200, 80),
        ToggleOff = Color3.fromRGB(26, 48, 36), Danger = Color3.fromRGB(200, 40, 40),
        Input = Color3.fromRGB(18, 40, 26), Border = Color3.fromRGB(28, 52, 36),
        SectionBg = Color3.fromRGB(14, 28, 20), Success = Color3.fromRGB(40, 220, 60),
        Warning = Color3.fromRGB(230, 200, 30), Info = Color3.fromRGB(50, 180, 220)
    }
}

-- ====== UTILITY ======
local function mk(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    if children then for _, c in pairs(children) do c.Parent = obj end end
    return obj
end

-- ====== FEATURE SYSTEM ======
Koli._features = {}

function Koli:LoadFeatures(list)
    for _, name in pairs(list) do Koli._features[name] = true end
end

function Koli:HasFeature(name)
    return Koli._features[name] == true
end

-- ====== NOTIFY SHORTCUT ======
function Koli:Notify(title, text, dur, color)
    Koli:MakeNotification({Name = title or "Koli", Content = text or "", Time = dur or 4, Color = color})
end

-- ====== TOAST ======
function Koli:MakeToast(text, dur, color)
    local dur = dur or 3
    local col = color or Koli.Themes.Dark.Accent
    local f = mk("Frame", {
        Size = UDim2.new(0, 200, 0, 28),
        Position = UDim2.new(0.5, -100, 1, 10),
        BackgroundColor3 = col, BorderSizePixel = 0,
        Parent = parent
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = f
    mk("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, Text = text, TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12, Font = Enum.Font.Gotham
    }, nil):Parent = f
    task.spawn(function()
        task.wait(dur)
        TS:Create(f, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -100, 1, 10)}):Play()
        task.wait(0.3); f:Destroy()
    end)
end

-- ====== NOTIFICATION ======
function Koli:MakeNotification(args)
    args = args or {}
    local name = args.Name or "Koli"
    local content = args.Content or ""
    local time = args.Time or 4
    local theme = args.Theme or Koli.Themes.Dark

    local f = mk("Frame", {
        Size = UDim2.new(0, 280, 0, 50), Position = UDim2.new(1, -290, 1, -60),
        BackgroundColor3 = theme.Second, BorderSizePixel = 0, Parent = parent
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = f
    mk("UIStroke", {Color = theme.Border}, nil):Parent = f
    mk("TextLabel", {
        Size = UDim2.new(1, -10, 0, 20), Position = UDim2.new(0, 10, 0, 2),
        BackgroundTransparency = 1, Text = name, TextColor3 = Color3.fromRGB(200, 200, 255),
        TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left
    }, nil):Parent = f
    mk("TextLabel", {
        Size = UDim2.new(1, -10, 0, 26), Position = UDim2.new(0, 10, 0, 22),
        BackgroundTransparency = 1, Text = content, TextColor3 = Color3.fromRGB(160, 160, 180),
        TextSize = 11, Font = Enum.Font.Gotham, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    }, nil):Parent = f

    task.spawn(function()
        task.wait(time)
        TS:Create(f, TweenInfo.new(0.4), {Position = UDim2.new(1, -290, 1, -10)}):Play()
        task.wait(0.4); f:Destroy()
    end)
end

-- ====== WATERMARK ======
local _watermark = nil
function Koli:SetWatermark(text, visible)
    if _watermark then _watermark:Destroy() end
    if visible == false then return end
    _watermark = mk("TextLabel", {
        Size = UDim2.new(0, 300, 0, 20), Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1, Text = text or "Koli UI",
        TextColor3 = Color3.fromRGB(130, 130, 170), TextSize = 13,
        Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
        TextStrokeTransparency = 0.7, Parent = parent
    })
end

-- ====== TOOLTIP SYSTEM ======
local _tip = nil
local function showTip(txt, x, y)
    if _tip then _tip:Destroy() end
    _tip = mk("Frame", {
        Size = UDim2.new(0, #txt * 7 + 10, 0, 22),
        Position = UDim2.new(0, x + 10, 0, y - 25),
        BackgroundColor3 = Color3.fromRGB(30, 30, 45), BorderSizePixel = 0,
        ZIndex = 1000, Parent = parent
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = _tip
    mk("TextLabel", {
        Size = UDim2.new(1, -6, 1, 0), Position = UDim2.new(0, 3, 0, 0),
        BackgroundTransparency = 1, Text = txt, TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 11, Font = Enum.Font.Gotham, ZIndex = 1001
    }, nil):Parent = _tip
end

local function hideTip()
    if _tip then _tip:Destroy(); _tip = nil end
end

-- ====== DIALOG ======
function Koli:Dialog(args)
    args = args or {}
    local title = args.Title or "Koli"
    local text = args.Text or ""
    local btns = args.Buttons or {{Text = "Tamam", Callback = function() end}}
    local theme = args.Theme or Koli.Themes.Dark

    local bg = mk("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6, Active = true, Parent = parent
    })
    local f = mk("Frame", {
        Size = UDim2.new(0, 300, 0, 0), Position = UDim2.new(0.5, -150, 0.5, -60),
        BackgroundColor3 = theme.Second, BorderSizePixel = 0, Parent = bg
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 6)}, nil):Parent = f
    mk("UIStroke", {Color = theme.Border}, nil):Parent = f
    mk("TextLabel", {
        Size = UDim2.new(1, -20, 0, 24), Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1, Text = title, TextColor3 = theme.Text,
        TextSize = 14, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, nil):Parent = f

    local cl = mk("TextLabel", {
        Size = UDim2.new(1, -20, 0, 0), Position = UDim2.new(0, 10, 0, 34),
        BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(160, 160, 180),
        TextSize = 12, Font = Enum.Font.Gotham, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, RichText = true
    }, nil):Parent = f

    -- wait for textbounds
    task.wait()
    local th = math.max(cl.TextBounds.Y, 20)
    cl.Size = UDim2.new(1, -20, 0, th)
    local yOff = 38 + th + 10

    local btnLayout = mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8)
    }, nil):Parent = mk("Frame", {
        Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, yOff),
        BackgroundTransparency = 1, Parent = f
    })

    for _, b in pairs(btns) do
        local btn = mk("TextButton", {
            Size = UDim2.new(0, 100, 0, 28),
            BackgroundColor3 = b.Color or theme.Accent,
            Text = b.Text, TextColor3 = Color3.new(1, 1, 1),
            TextSize = 12, Font = Enum.Font.GothamBold, BorderSizePixel = 0
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = btn
        btn.Parent = btnLayout.Parent
        btn.MouseButton1Click:Connect(function()
            pcall(b.Callback); bg:Destroy()
        end)
    end

    yOff = yOff + 40
    f.Size = UDim2.new(0, 300, 0, yOff)
    f.Position = UDim2.new(0.5, -150, 0.5, -yOff / 2)
end

-- ====== CREATE WINDOW ======
function Koli:CreateWindow(args)
    args = args or {}
    local Name = args.Name or "Koli UI"
    local Size = args.Size or UDim2.new(0, 580, 0, 380)
    local Pos = args.Position or UDim2.new(0.5, -290, 0.5, -190)
    local themeName = args.Theme or "Dark"
    local Theme = Koli.Themes[themeName] or Koli.Themes.Dark
    local userTheme = args.CustomTheme
    if userTheme then
        for k, v in pairs(userTheme) do Theme[k] = v end
    end
    local features = Koli._features
    local minimized = false
    local locked = false
    local trans = 1
    local resizeMode = false; local resizeDir = ""
    local tabScroll = 0

    local sg = mk("ScreenGui", {
        Name = "KoliUI", ResetOnSpawn = false, Parent = parent, DisplayOrder = 999,
        Enabled = true
    })

    -- UI Toggle Key
    local uiKey = args.ToggleKey or Enum.KeyCode.F4
    local uiVisible = true
    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == uiKey and uiKey then
            uiVisible = not uiVisible; sg.Enabled = uiVisible
        end
    end)

    local main = mk("Frame", {
        Size = Size, Position = Pos,
        BackgroundColor3 = Theme.Main, BorderSizePixel = 0,
        Active = true, Draggable = true, ClipsDescendants = true, Parent = sg
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 6)}, nil):Parent = main
    mk("UIStroke", {Color = Theme.Border, Thickness = 1}, nil):Parent = main

    -- header
    local header = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.Second,
        BorderSizePixel = 0, Parent = main
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 6)}, nil):Parent = header
    mk("UIStroke", {Color = Theme.Border, Thickness = 1}, nil):Parent = header
    mk("Frame", {
        Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0, 28),
        BackgroundColor3 = Theme.Second, BorderSizePixel = 0, Parent = header
    })

    local titleLbl = mk("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = Name, TextColor3 = Theme.Text,
        TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    -- lock btn
    local lockBtn = mk("TextButton", {
        Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -88, 0, 5),
        BackgroundTransparency = 1, Text = "🔓", TextColor3 = Theme.Text,
        TextSize = 10, Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = header
    })
    lockBtn.MouseButton1Click:Connect(function()
        locked = not locked; main.Draggable = not locked
        lockBtn.Text = locked and "🔒" or "🔓"
    end)

    -- trans slider
    local transBg = mk("Frame", {
        Size = UDim2.new(0, 40, 0, 4), Position = UDim2.new(1, -64, 0, 14),
        BackgroundColor3 = Color3.fromRGB(50, 50, 60), BorderSizePixel = 0, Parent = header
    })
    mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = transBg
    local transFill = mk("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, Parent = transBg
    })
    mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = transFill

    local function updateTrans(p)
        trans = p
        main.BackgroundTransparency = 1 - p
        header.BackgroundTransparency = 1 - p
        for _, v in pairs(main:GetDescendants()) do
            if v:IsA("Frame") then
                v.BackgroundTransparency = math.min(1, (1 - p) * 0.3 + v.BackgroundTransparency)
            end
        end
        transFill.Size = UDim2.new(p, 0, 1, 0)
    end

    -- minimize btn
    local minBtn = mk("TextButton", {
        Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(1, -28, 0, 4),
        BackgroundTransparency = 1, Text = "—", TextColor3 = Theme.Text,
        TextSize = 18, Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = header
    })

    -- tab bar
    local tabBar = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 28), Position = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = Theme.Main, BorderSizePixel = 0, Parent = main
    })
    local tabHolder = mk("Frame", {
        Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1, ClipsDescendants = true, Parent = tabBar
    })
    local tabList = mk("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Parent = tabHolder
    })
    local tabLayout = mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabList
    })

    -- tab arrows for overflow
    local tabArrowL = mk("TextButton", {
        Size = UDim2.new(0, 16, 0, 22), BackgroundTransparency = 1,
        Text = "<", TextColor3 = Theme.Text, TextSize = 12,
        Visible = false, Parent = tabHolder, ZIndex = 5
    })
    local tabArrowR = mk("TextButton", {
        Size = UDim2.new(0, 16, 0, 22), Position = UDim2.new(1, -16, 0, 0),
        BackgroundTransparency = 1, Text = ">", TextColor3 = Theme.Text,
        TextSize = 12, Visible = false, Parent = tabHolder, ZIndex = 5
    })

    -- container
    local container = mk("Frame", {
        Size = UDim2.new(1, -10, 1, -74), Position = UDim2.new(0, 5, 0, 64),
        BackgroundColor3 = Theme.Main, BorderSizePixel = 0, ClipsDescendants = true,
        Parent = main
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = container

    local pageHolder = mk("Frame", {
        Size = UDim2.new(1, -6, 1, -6), Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1, Parent = container
    })

    -- status bar
    local statusBar = nil
    if features.StatusBar then
        statusBar = mk("Frame", {
            Size = UDim2.new(1, -10, 0, 18),
            Position = UDim2.new(0, 5, 0, 64 + container.Size.Y.Offset - 18),
            BackgroundColor3 = Theme.Second, BorderSizePixel = 0,
            BackgroundTransparency = 0.5, Parent = main
        })
        local fpLabel = mk("TextLabel", {
            Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1, Text = "FPS: 60", TextColor3 = Theme.Text,
            TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
            Parent = statusBar
        })
        local clLabel = mk("TextLabel", {
            Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(0, 90, 0, 0),
            BackgroundTransparency = 1, Text = "", TextColor3 = Theme.Text,
            TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
            Parent = statusBar
        })
        local timeLabel = mk("TextLabel", {
            Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(1, -105, 0, 0),
            BackgroundTransparency = 1, Text = "", TextColor3 = Theme.Text,
            TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right,
            Parent = statusBar
        })
        RunS.RenderStepped:Connect(function()
            fpLabel.Text = "FPS: " .. math.floor(1 / (RunS.RenderStepped:Wait() or 0.01))
            local pList = game:GetService("Players")
            clLabel.Text = "Oyuncu: " .. #pList:GetPlayers()
            timeLabel.Text = os.date("%H:%M:%S")
        end)
    end

    -- ===== WINDOW OBJECT ======
    local win = {}
    win.sg = sg; win.main = main; win.pageHolder = pageHolder
    win.tabs = {}; win.activeTab = nil; win.Theme = Theme
    win._header = header; win._tabBar = tabBar; win._container = container
    win._elements = {}; win._keybinds = {}; win._elementCount = 0
    win._toggleRefs = {}; win._allStates = {}

    function win:Destroy() sg:Destroy() end

    function win:SaveConfig(name)
        local data = {}
        for id, el in pairs(win._elements) do
            if el._type and el.Get then
                data[id] = {t = el._type, v = el:Get()}
            end
        end
        local ok, json = pcall(function() return game:GetService("HttpService"):JSONEncode(data) end)
        if ok and writefile then pcall(writefile, "koli_" .. name .. ".cfg", json) end
        Koli:MakeToast("Config kaydedildi: " .. name, 1.5)
    end

    function win:LoadConfig(name)
        local data = {}
        if readfile then
            local ok, json = pcall(readfile, "koli_" .. name .. ".cfg")
            if ok then
                local ok2, dec = pcall(function() return game:GetService("HttpService"):JSONDecode(json) end)
                if ok2 then data = dec end
            end
        end
        for id, entry in pairs(data) do
            local el = win._elements[id]
            if el and el.Set and entry.v ~= nil then
                el:Set(entry.v)
            end
        end
        Koli:MakeToast("Config yuklendi: " .. name, 1.5)
    end

    function win:ResetAll()
        for id, el in pairs(win._elements) do
            if el._default ~= nil then el:Set(el._default) end
        end
        Koli:MakeToast("Tum degerler sifirlandi!", 1.5)
    end

    function win:ShowKeybinds()
        local lines = {}
        for name, kb in pairs(win._keybinds) do
            table.insert(lines, name .. ": " .. kb:Get().Name)
        end
        local text = #lines > 0 and table.concat(lines, "\n") or "Henuz tus atanmadi."
        Koli:Dialog({Title = "Tus Atamalari", Text = text, Buttons = {{Text = "Tamam", Callback = function() end}}})
    end

    function win:GetElementCount()
        return win._elementCount
    end

    function win:SetScale(v)
        v = math.clamp(v, 0.5, 2)
        TS:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(Size.X.Scale * v, Size.X.Offset * v, Size.Y.Scale * v, Size.Y.Offset * v)}):Play()
        win:SetSize(UDim2.new(Size.X.Scale * v, Size.X.Offset * v, Size.Y.Scale * v, Size.Y.Offset * v))
    end

    function win:SetSize(newSize)
        Size = newSize
        main.Size = newSize
    end

    function win:SetEnhancedWatermark(text)
        if _watermark then _watermark:Destroy(); _watermark = nil end
        local wm = mk("Frame", {
            Size = UDim2.new(0, 280, 0, 18), Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1, Parent = parent
        })
        local txt = mk("TextLabel", {
            Size = UDim2.new(0, 280, 1, 0), BackgroundTransparency = 1,
            Text = text or "Koli UI", TextColor3 = Color3.fromRGB(130, 130, 170),
            TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
            TextStrokeTransparency = 0.7, Parent = wm, Visible = false
        })
        local fpsTxt = mk("TextLabel", {
            Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(0, 200, 0, 0),
            BackgroundTransparency = 1, Text = "", TextColor3 = Color3.fromRGB(100, 100, 140),
            TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right,
            Parent = wm
        })
        _watermark = wm
        RunS.RenderStepped:Connect(function()
            if wm.Parent then 
                fpsTxt.Text = math.floor(1 / (RunS.RenderStepped:Wait() or 0.01)) .. " FPS"
            end
        end)
        return wm
    end

    function win:SearchAllTabs(query)
        query = query:lower()
        for _, t in pairs(win.tabs) do
            local found = false
            for _, s in pairs(t.sections) do
                local match = query == "" or (s._name and s._name:lower():find(query, 1, true))
                if s._frame then s._frame.Visible = match end
                if match then found = true end
            end
            if t.btn then
                t.btn.Visible = query == "" or found
            end
        end
    end

    function win:BindElements(sourceId, targetIds, invert)
        local src = win._elements[sourceId]
        if not src then return end
        src:Get()  -- call to ensure initial state
        src._bindings = src._bindings or {}
        for _, tid in pairs(targetIds) do
            local tgt = win._elements[tid]
            if tgt then table.insert(src._bindings, {target = tgt, invert = invert}) end
        end
        local origSet = src.Set
        src.Set = function(self, v)
            origSet(self, v)
            for _, b in pairs(self._bindings or {}) do
                local state = b.invert and not v or v
                if b.target._type == "toggle" then
                    b.target:Set(state)
                elseif b.target.Visible ~= nil then
                    b.target.Visible = state
                end
            end
        end
        -- apply initial
        src:Set(src:Get())
    end

    -- + - resize
    if features.Resizable then
        local edges = {}
        for _, d in pairs({"TR", "TL", "BR", "BL", "T", "B", "L", "R"}) do
            local e = mk("Frame", {
                Size = d == "T" or d == "B" and UDim2.new(1, 0, 0, 4) or
                       d == "L" or d == "R" and UDim2.new(0, 4, 1, 0) or
                       UDim2.new(0, 6, 0, 6),
                Position = d == "T" and UDim2.new(0, 0, 0, 0) or
                           d == "B" and UDim2.new(0, 0, 1, -4) or
                           d == "L" and UDim2.new(0, 0, 0, 0) or
                           d == "R" and UDim2.new(1, -4, 0, 0) or
                           d == "TL" and UDim2.new(0, 0, 0, 0) or
                           d == "TR" and UDim2.new(1, -6, 0, 0) or
                           d == "BL" and UDim2.new(0, 0, 1, -6) or
                           d == "BR" and UDim2.new(1, -6, 1, -6),
                BackgroundTransparency = 1, Parent = main, Cursor = d
            })
            e.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizeMode = true; resizeDir = d
                end
            end)
            edges[d] = e
        end
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizeMode = false
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if resizeMode and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mPos = input.Position; local aPos = main.AbsolutePosition; local aSize = main.AbsoluteSize
                local ns = aSize; local np = aPos
                if resizeDir:find("R") then ns = UDim2.new(0, math.max(300, mPos.X - aPos.X), 0, ns.Y.Offset) end
                if resizeDir:find("B") then ns = UDim2.new(0, ns.X.Offset, 0, math.max(200, mPos.Y - aPos.Y)) end
                if resizeDir:find("L") then
                    local w = aSize.X.Offset + (aPos.X - mPos.X)
                    if w >= 300 then ns = UDim2.new(0, w, 0, ns.Y.Offset); main.Position = UDim2.new(0, mPos.X, 0, aPos.Y) end
                end
                if resizeDir:find("T") then
                    local h = aSize.Y.Offset + (aPos.Y - mPos.Y)
                    if h >= 200 then ns = UDim2.new(0, ns.X.Offset, 0, h); main.Position = UDim2.new(0, aPos.X, 0, mPos.Y) end
                end
                if ns then
                    main.Size = ns; container.Size = UDim2.new(1, -10, 1, -74 - (statusBar and 18 or 0))
                    if statusBar then statusBar.Position = UDim2.new(0, 5, 0, main.Size.Y.Offset - 18 - 6) end
                end
            end
        end)
    end

    -- minimize logic
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TS:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(Size.X.Scale, Size.X.Offset, 0, 32)}):Play()
            tabBar.Visible = false; container.Visible = false
            if statusBar then statusBar.Visible = false end
            minBtn.Text = "+"
        else
            TS:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = Size}):Play()
            task.wait(0.2); tabBar.Visible = true; container.Visible = true
            if statusBar then statusBar.Visible = true end
            minBtn.Text = "—"
        end
    end)

    -- ===== make tab =====
    function win:MakeTab(args)
        args = args or {}
        local tName = args.Name or "Tab"
        local tIcon = args.Icon or ""

        local btn = mk("TextButton", {
            Size = UDim2.new(0, math.max(50, (#tName + (#tIcon > "" and 1 or 0)) * 8 + 24), 0, 22),
            BackgroundColor3 = Theme.Third,
            Text = tIcon .. " " .. tName, TextColor3 = Color3.fromRGB(140, 140, 170),
            TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = tabList
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = btn

        local page = mk("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            BorderSizePixel = 0, ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80),
            CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false, Parent = pageHolder
        })
        local pageLayout = mk("UIListLayout", {
            Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder, Parent = page
        })
        mk("UIPadding", {PaddingTop = UDim.new(0, 4)}, nil):Parent = page

        -- tab badge
        local badge = nil

        local tab = {}
        tab.btn = btn; tab.page = page; tab.Name = tName; tab.sections = {}
        tab._toggleRefs = {}
        tab._searchBox = nil

        -- search input for filtering sections
        local searchHolder = mk("Frame", {
            Size = UDim2.new(1, -6, 0, 0), BackgroundTransparency = 1,
            Visible = false, Parent = page
        })
        local searchInp = mk("TextBox", {
            Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = Theme.Input,
            Text = "", PlaceholderText = "Ara...", PlaceholderColor3 = Color3.fromRGB(130, 130, 150),
            TextColor3 = Color3.fromRGB(220, 220, 240), TextSize = 11,
            Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = searchHolder
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = searchInp
        searchInp:GetPropertyChangedSignal("Text"):Connect(function()
            local q = searchInp.Text:lower()
            for _, sec in pairs(tab.sections) do
                local match = sec._frame and (q == "" or (sec._name and sec._name:lower():find(q, 1, true)))
                if sec._frame then sec._frame.Visible = match end
            end
        end)
        tab._searchInp = searchInp

        function tab:ToggleSearch(show)
            searchHolder.Visible = show ~= false
            if show then searchInp:CaptureFocus() end
        end

        function tab:GetElementCount()
            local c = 0
            for _, s in pairs(tab.sections) do
                for _ in pairs(s._elements or {}) do c = c + 1 end
            end
            return c
        end

        function tab:SetBadge(num)
            if num and num > 0 then
                if not badge then
                    badge = mk("Frame", {
                        Size = UDim2.new(0, 18, 0, 14), Position = UDim2.new(1, -8, 0, -6),
                        BackgroundColor3 = Theme.Danger, BorderSizePixel = 0, Parent = btn
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = badge
                end
                local bt = badge:FindFirstChildOfClass("TextLabel")
                if not bt then
                    bt = mk("TextLabel", {
                        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                        Text = tostring(num), TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 9, Font = Enum.Font.GothamBold
                    }, nil):Parent = badge
                end
                bt.Text = tostring(num)
                badge.Visible = true
            else
                if badge then badge.Visible = false end
            end
        end

        btn.MouseButton1Click:Connect(function()
            if win.activeTab then
                win.activeTab.btn.BackgroundColor3 = Theme.Third
                win.activeTab.btn.TextColor3 = Color3.fromRGB(140, 140, 170)
                win.activeTab.page.Visible = false
            end
            win.activeTab = tab
            btn.BackgroundColor3 = Theme.Accent; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            page.Visible = true
            if features.Animations then
                page.CanvasPosition = Vector2.new(0, 0)
            end
        end)

        -- ===== add section =====
        function tab:AddSection(args)
            args = args or {}
            local sName = args.Name or "Section"
            local collapsible = args.Collapsible or false

            local secFrame = mk("Frame", {
                Size = UDim2.new(1, -8, 0, 0), BackgroundColor3 = Theme.SectionBg,
                BorderSizePixel = 0, Parent = page, ClipsDescendants = collapsible
            })
            mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = secFrame

            local secHeader = mk("Frame", {
                Size = UDim2.new(1, -10, 0, 24), Position = UDim2.new(0, 5, 0, 2),
                BackgroundTransparency = 1, Parent = secFrame
            })

            mk("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = sName, TextColor3 = Color3.fromRGB(140, 140, 180),
                TextSize = 12, Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = secHeader
            })

            local secCollapse = nil
            if collapsible then
                secCollapse = mk("TextButton", {
                    Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -20, 0, 2),
                    BackgroundTransparency = 1, Text = "−", TextColor3 = Theme.Text,
                    TextSize = 14, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                    Parent = secHeader
                })
                local collapsed = false
                secCollapse.MouseButton1Click:Connect(function()
                    collapsed = not collapsed; secContent.Visible = not collapsed
                    secLine.Visible = not collapsed
                    secCollapse.Text = collapsed and "+" or "−"
                end)
            end

            local secLine = mk("Frame", {
                Size = UDim2.new(1, -10, 0, 1), Position = UDim2.new(0, 5, 0, 26),
                BackgroundColor3 = Theme.Border, BorderSizePixel = 0, Parent = secFrame
            })

            local secContent = mk("Frame", {
                Size = UDim2.new(1, -10, 0, 0), Position = UDim2.new(0, 5, 0, 30),
                BackgroundTransparency = 1, Parent = secFrame
            })
            local secLayout = mk("UIListLayout", {
                Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Parent = secContent
            })

            local sec = {}
            sec._elements = {}; sec._name = sName; sec._frame = secFrame

            function sec:_reg(id, obj, def, typ)
                if id then
                    win._elements[id] = obj; sec._elements[id] = obj
                    obj._type = typ; obj._default = def
                    win._elementCount = win._elementCount + 1
                    if def ~= nil then obj:Set(def) end
                    if tab and tab.SetBadge then tab:SetBadge(tab:GetElementCount()) end
                end
            end

            function sec:AddToggle(args)
                args = args or {}
                local n = args.Name or "Toggle"; local def = args.Default or false
                local cb = args.Callback or function() end; local val = def
                local tooltip = args.Tooltip or ""; local cid = args.ConfigId

                local tog = mk("TextButton", {
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundColor3 = val and Theme.ToggleOn or Theme.ToggleOff,
                    Text = "", BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = tog

                local tl = mk("TextLabel", {
                    Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = n .. " [" .. (val and "ON" or "OFF") .. "]",
                    TextColor3 = Color3.new(1, 1, 1), TextSize = 12,
                    Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = tog
                })

                if tooltip ~= "" then
                    tog.MouseEnter:Connect(function() showTip(tooltip, UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y) end)
                    tog.MouseLeave:Connect(hideTip)
                end

                tog.MouseButton1Click:Connect(function()
                    val = not val
                    tog.BackgroundColor3 = val and Theme.ToggleOn or Theme.ToggleOff
                    tl.Text = n .. " [" .. (val and "ON" or "OFF") .. "]"
                    pcall(cb, val)
                end)

                local obj = {}
                function obj:Set(v) val = v; tog.BackgroundColor3 = val and Theme.ToggleOn or Theme.ToggleOff; tl.Text = n .. " [" .. (val and "ON" or "OFF") .. "]" end
                function obj:Get() return val end
                function obj:Enable() tog.Visible = true; tog.Active = true end
                function obj:Disable() tog.BackgroundColor3 = Theme.Third; tl.TextColor3 = Color3.fromRGB(100, 100, 120); tog.Active = false end
                sec:_reg(cid, obj, def, "toggle")
                return obj
            end

            function sec:AddButton(args)
                args = args or {}
                local n = args.Name or "Button"; local cb = args.Callback or function() end
                local color = args.Color or Theme.Accent; local tooltip = args.Tooltip or ""

                local btn = mk("TextButton", {
                    Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = color,
                    Text = n, TextColor3 = Color3.new(1, 1, 1), TextSize = 12,
                    Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = btn
                if tooltip ~= "" then
                    btn.MouseEnter:Connect(function() showTip(tooltip, UIS:GetMouseLocation().X, UIS:GetMouseLocation().Y) end)
                    btn.MouseLeave:Connect(hideTip)
                end
                btn.MouseButton1Click:Connect(function() pcall(cb) end)
                return btn
            end

            function sec:AddSlider(args)
                args = args or {}
                local n = args.Name or "Slider"; local min = args.Min or 0; local max = args.Max or 100
                local def = args.Default or min; local cb = args.Callback or function() end
                local val = def; local dragging = false; local cid = args.ConfigId

                local lbl = mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1,
                    Text = n .. ": " .. val, TextColor3 = Theme.Text,
                    TextSize = 11, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = secContent
                })
                local bg = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = Color3.fromRGB(40, 40, 55),
                    BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = bg
                local pct = (val - min) / (max - min)
                local fill = mk("Frame", {
                    Size = UDim2.new(pct, 0, 1, 0), BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0, Parent = bg
                })
                mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = fill
                local knob = mk("TextButton", {
                    Size = UDim2.new(0, 12, 0, 14), Position = UDim2.new(pct, -6, 0, -4),
                    BackgroundColor3 = Color3.fromRGB(200, 200, 255), Text = "",
                    BorderSizePixel = 0, Parent = bg
                })
                mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = knob

                -- input on click
                if args.AllowInput then
                    lbl.MouseButton1Click:Connect(function()
                        Koli:Dialog({
                            Title = n,
                            Text = "Deger gir (" .. min .. "-" .. max .. "):",
                            Buttons = {
                                {Text = "Tamam", Callback = function()
                                    -- prompt handled via dialog
                                end}
                            }
                        })
                    end)
                end

                knob.MouseButton1Down:Connect(function() dragging = true end)
                local c1 = UIS.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local ap = bg.AbsolutePosition; local as = bg.AbsoluteSize.X
                        pct = math.clamp((input.Position.X - ap.X) / as, 0, 1)
                        val = math.floor(min + pct * (max - min))
                        fill.Size = UDim2.new(pct, 0, 1, 0); knob.Position = UDim2.new(pct, -6, 0, -4)
                        lbl.Text = n .. ": " .. val; pcall(cb, val)
                    end
                end)
                local c2 = UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)

                local obj = {}
                function obj:Set(v) val = v; pct = (val - min) / (max - min); fill.Size = UDim2.new(pct, 0, 1, 0); knob.Position = UDim2.new(pct, -6, 0, -4); lbl.Text = n .. ": " .. val end
                function obj:Get() return val end
                sec:_reg(cid, obj, def, "slider")
                return obj
            end

            function sec:AddDropdown(args)
                args = args or {}
                local n = args.Name or "Dropdown"; local opts = args.Options or {}
                local def = args.Default or "..."; local cb = args.Callback or function() end
                local open = false; local sel = def; local cid = args.ConfigId

                local dd = mk("TextButton", {
                    Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = Theme.Third,
                    Text = n .. ": " .. sel, TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                    Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = dd

                local dropFrame = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(40, 40, 55),
                    BorderSizePixel = 0, Visible = false, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = dropFrame
                local dropLayout = mk("UIListLayout", {Padding = UDim.new(0, 2)}, nil):Parent = dropFrame

                function refreshDropdown()
                    for _, c in pairs(dropFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in pairs(opts) do
                        local ob = mk("TextButton", {
                            Size = UDim2.new(1, -6, 0, 20), Position = UDim2.new(0, 3, 0, 0),
                            BackgroundColor3 = Theme.Third, Text = opt,
                            TextColor3 = Color3.fromRGB(200, 200, 220),
                            TextSize = 11, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                            Parent = dropFrame
                        })
                        mk("UICorner", {CornerRadius = UDim.new(0, 3)}, nil):Parent = ob
                        ob.MouseButton1Click:Connect(function()
                            sel = opt; dd.Text = n .. ": " .. sel
                            dropFrame.Visible = false; open = false; pcall(cb, sel)
                        end)
                    end
                    dropFrame.Size = UDim2.new(1, 0, 0, #opts * 22 + 4)
                end
                refreshDropdown()

                dd.MouseButton1Click:Connect(function()
                    open = not open; dropFrame.Visible = open
                end)
                -- auto close on outside click
                UIS.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and open then
                        local mPos = UIS:GetMouseLocation()
                        local ddPos = dropFrame.AbsolutePosition; local ddSize = dropFrame.AbsoluteSize
                        if mPos.X < ddPos.X or mPos.X > ddPos.X + ddSize.X or mPos.Y < ddPos.Y or mPos.Y > ddPos.Y + ddSize.Y then
                            dropFrame.Visible = false; open = false
                        end
                    end
                end)

                local obj = {}
                function obj:Set(list) opts = type(list) == "table" and list or {list}; refreshDropdown() end
                function obj:Get() return sel end
                sec:_reg(cid, obj, def, "dropdown")
                return obj
            end

            function sec:AddMultiDropdown(args)
                args = args or {}
                local n = args.Name or "Multi"; local opts = args.Options or {}
                local cb = args.Callback or function() end
                local open = false; local selected = {}; local cid = args.ConfigId

                local dd = mk("TextButton", {
                    Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = Theme.Third,
                    Text = n .. ": (0)", TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                    Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = dd

                local dropFrame = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(40, 40, 55),
                    BorderSizePixel = 0, Visible = false, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = dropFrame
                local dropLayout = mk("UIListLayout", {Padding = UDim.new(0, 2)}, nil):Parent = dropFrame

                function refresh()
                    for _, c in pairs(dropFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in pairs(opts) do
                        local ob = mk("TextButton", {
                            Size = UDim2.new(1, -6, 0, 20), Position = UDim2.new(0, 3, 0, 0),
                            BackgroundColor3 = Theme.Third, Text = (selected[opt] and "✓ " or "  ") .. opt,
                            TextColor3 = Color3.fromRGB(200, 200, 220),
                            TextSize = 11, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                            Parent = dropFrame
                        })
                        mk("UICorner", {CornerRadius = UDim.new(0, 3)}, nil):Parent = ob
                        ob.MouseButton1Click:Connect(function()
                            selected[opt] = not selected[opt]
                            ob.Text = (selected[opt] and "✓ " or "  ") .. opt
                            local count = 0; for _, v in pairs(selected) do if v then count = count + 1 end end
                            dd.Text = n .. ": (" .. count .. ")"
                            pcall(cb, selected)
                        end)
                    end
                    dropFrame.Size = UDim2.new(1, 0, 0, #opts * 22 + 4)
                end
                refresh()
                dd.MouseButton1Click:Connect(function() open = not open; dropFrame.Visible = open end)

                local obj = {}
                function obj:Set(list) opts = type(list) == "table" and list or {list}; selected = {}; refresh() end
                function obj:Get() local r = {}; for k, v in pairs(selected) do if v then table.insert(r, k) end end; return r end
                sec:_reg(cid, obj, {}, "multidropdown")
                return obj
            end

            function sec:AddTextBox(args)
                args = args or {}
                local n = args.Name or "Text"; local ph = args.Placeholder or ""
                local def = args.Default or ""; local cb = args.Callback or function() end
                local cid = args.ConfigId

                mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
                    Text = n, TextColor3 = Theme.Text, TextSize = 11,
                    Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = secContent
                })
                local box = mk("TextBox", {
                    Size = UDim2.new(1, 0, 0, 20), BackgroundColor3 = Theme.Input,
                    Text = def, PlaceholderText = ph, PlaceholderColor3 = Color3.fromRGB(130, 130, 150),
                    TextColor3 = Color3.fromRGB(220, 220, 240), TextSize = 12,
                    Font = Enum.Font.Gotham, BorderSizePixel = 0, ClearTextOnFocus = false,
                    Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = box
                box.FocusLost:Connect(function(enter) if enter then pcall(cb, box.Text) end end)
                local obj = {}
                function obj:Get() return box.Text end
                function obj:Set(v) box.Text = tostring(v) end
                sec:_reg(cid, obj, def, "textbox")
                return obj
            end

            function sec:AddRichLabel(args)
                args = args or {}
                return mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
                    Text = args.Text or "", TextColor3 = args.Color or Theme.Text,
                    TextSize = args.Size or 12, Font = args.Font or Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left, RichText = true,
                    Parent = secContent
                })
            end

            function sec:AddParagraph(args)
                args = args or {}
                local tl = mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
                    Text = args.Title or "", TextColor3 = Theme.Text, TextSize = 12,
                    Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = secContent
                })
                local cl = mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
                    Text = args.Content or "", TextColor3 = Color3.fromRGB(160, 160, 180),
                    TextSize = 11, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
                    RichText = true, Parent = secContent
                })
                task.spawn(function() cl.Size = UDim2.new(1, 0, 0, cl.TextBounds.Y + 4) end)
                return {Title = tl, Content = cl}
            end

            function sec:AddColorpicker(args)
                args = args or {}
                local n = args.Name or "Color"; local def = args.Default or Color3.fromRGB(255, 0, 0)
                local cb = args.Callback or function() end; local val = def; local cid = args.ConfigId

                local lbl = mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
                    Text = n, TextColor3 = Theme.Text, TextSize = 11,
                    Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = secContent
                })
                local prev = mk("Frame", {
                    Size = UDim2.new(0, 24, 0, 14), Position = UDim2.new(1, -24, 0, 1),
                    BackgroundColor3 = val, BorderSizePixel = 0, Parent = lbl
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 3)}, nil):Parent = prev

                local picker = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 140), BackgroundColor3 = Theme.Third,
                    BorderSizePixel = 0, Visible = false, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = picker

                local hue = mk("Frame", {
                    Size = UDim2.new(1, -10, 0, 12), Position = UDim2.new(0, 5, 0, 5),
                    BorderSizePixel = 0, Parent = picker
                })
                mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = hue
                mk("UIGradient", {Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,0,255)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,0,255)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,255,0)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
                })}, nil):Parent = hue

                local satVal = mk("Frame", {
                    Size = UDim2.new(1, -10, 0, 100), Position = UDim2.new(0, 5, 0, 22),
                    BorderSizePixel = 0, Parent = picker
                })
                local satGrad = mk("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
                    }), Rotation = 90
                }, nil):Parent = satVal
                mk("UIGradient", {
                    Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(1,1,1))}),
                    Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}),
                    Rotation = 90
                }, nil):Parent = satVal

                prev.MouseButton1Click:Connect(function() picker.Visible = not picker.Visible end)

                local hDrag = false; local svDrag = false; local h = 0; local s = 1; local v = 1
                local hKnob = mk("Frame", {
                    Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0, Parent = hue
                }); mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = hKnob
                local svKnob = mk("Frame", {
                    Size = UDim2.new(0, 6, 0, 6), BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 1, BorderColor3 = Color3.new(0, 0, 0), Parent = satVal
                }); mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = svKnob

                hue.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hDrag = true; h = math.clamp((input.Position.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 1)
                        hKnob.Position = UDim2.new(h, -2, 0, 0); val = Color3.fromHSV(h, s, v); prev.BackgroundColor3 = val
                        satGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))})
                        pcall(cb, val)
                    end
                end)
                satVal.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        svDrag = true; local ap = satVal.AbsolutePosition; local as = satVal.AbsoluteSize
                        s = math.clamp((input.Position.X - ap.X) / as.X, 0, 1); v = 1 - math.clamp((input.Position.Y - ap.Y) / as.Y, 0, 1)
                        svKnob.Position = UDim2.new(s, -3, 1 - v, -3); val = Color3.fromHSV(h, s, v); prev.BackgroundColor3 = val; pcall(cb, val)
                    end
                end)
                UIS.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if hDrag then
                            h = math.clamp((input.Position.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 1)
                            hKnob.Position = UDim2.new(h, -2, 0, 0); val = Color3.fromHSV(h, s, v); prev.BackgroundColor3 = val
                            satGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)), ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1))})
                            pcall(cb, val)
                        end
                        if svDrag then
                            local ap = satVal.AbsolutePosition; local as = satVal.AbsoluteSize
                            s = math.clamp((input.Position.X - ap.X) / as.X, 0, 1); v = 1 - math.clamp((input.Position.Y - ap.Y) / as.Y, 0, 1)
                            svKnob.Position = UDim2.new(s, -3, 1 - v, -3); val = Color3.fromHSV(h, s, v); prev.BackgroundColor3 = val; pcall(cb, val)
                        end
                    end
                end)
                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then hDrag = false; svDrag = false end
                end)

                local obj = {}
                function obj:Set(c) val = c; prev.BackgroundColor3 = val end
                function obj:Get() return val end
                sec:_reg(cid, obj, def, "color")
                return obj
            end

            function sec:AddKeybind(args)
                args = args or {}
                local n = args.Name or "Keybind"; local def = args.Default or Enum.KeyCode.F
                local cb = args.Callback or function() end; local val = def; local lstn = false
                local cid = args.ConfigId

                local btn = mk("TextButton", {
                    Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = Theme.Third,
                    Text = n .. ": " .. val.Name, TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 12, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                    Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = btn
                btn.MouseButton1Click:Connect(function() lstn = true; btn.Text = n .. ": ..." end)
                UIS.InputBegan:Connect(function(input, gp)
                    if gp then return end
                    if lstn and input.UserInputType == Enum.UserInputType.Keyboard then
                        lstn = false; val = input.KeyCode; btn.Text = n .. ": " .. val.Name; pcall(cb, val)
                    end
                end)

                local obj = {}
                function obj:Set(k) val = k; btn.Text = n .. ": " .. val.Name end
                function obj:Get() return val end
                sec:_reg(cid, obj, def, "keybind")
                win._keybinds[n] = obj
                return obj
            end

            function sec:AddSeparator()
                return mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0, Parent = secContent
                })
            end

            function sec:AddProgress(args)
                args = args or {}
                local n = args.Name or "Progress"; local val = args.Default or 0
                local mx = args.Max or 100; local color = args.Color or Theme.Success

                local lbl = mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1,
                    Text = n .. ": " .. val .. "/" .. mx, TextColor3 = Theme.Text,
                    TextSize = 11, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = secContent
                })
                local bg = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 8), BackgroundColor3 = Color3.fromRGB(40, 40, 55),
                    BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = bg
                local fill = mk("Frame", {
                    Size = UDim2.new(val / mx, 0, 1, 0), BackgroundColor3 = color,
                    BorderSizePixel = 0, Parent = bg
                })
                mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = fill

                local obj = {}
                function obj:Set(v) val = math.clamp(v, 0, mx); fill.Size = UDim2.new(val / mx, 0, 1, 0); lbl.Text = n .. ": " .. val .. "/" .. mx end
                function obj:Get() return val end
                return obj
            end

            function sec:AddCopyButton(args)
                args = args or {}
                local text = args.Text or "Kopyala"; local cb = args.Callback or function() end
                local btn = sec:AddButton({
                    Name = "📋 " .. text,
                    Color = args.Color or Theme.Accent,
                    Callback = function()
                        if setclipboard then pcall(setclipboard, text) end
                        pcall(cb)
                        Koli:MakeToast("Kopyalandi!", 1, Theme.Success)
                    end
                })
                return btn
            end

            function sec:AddQuickTogglePanel(args)
                args = args or {}
                local n = args.Name or "Hizli Togglelar"
                local title = mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
                    Text = n, TextColor3 = Color3.fromRGB(140, 140, 180),
                    TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = secContent
                })
                local listFrame = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Theme.Input,
                    BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = listFrame
                local listLayout = mk("UIListLayout", {Padding = UDim.new(0, 2)}, nil):Parent = listFrame

                local function refresh()
                    for _, c in pairs(listFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    local count = 0
                    for _, s in pairs(tab.sections) do
                        for id, el in pairs(s._elements or {}) do
                            if el._type == "toggle" then
                                local val = el:Get()
                                local b = mk("TextButton", {
                                    Size = UDim2.new(1, -6, 0, 18), Position = UDim2.new(0, 3, 0, 0),
                                    BackgroundColor3 = val and Theme.ToggleOn or Theme.ToggleOff,
                                    Text = "  " .. id, TextColor3 = Color3.new(1, 1, 1),
                                    TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                                    BorderSizePixel = 0, Parent = listFrame
                                })
                                mk("UICorner", {CornerRadius = UDim.new(0, 3)}, nil):Parent = b
                                b.MouseButton1Click:Connect(function()
                                    el:Set(not el:Get())
                                    b.BackgroundColor3 = el:Get() and Theme.ToggleOn or Theme.ToggleOff
                                end)
                                count = count + 1
                            end
                        end
                    end
                    local h = count * 20 + 4
                    listFrame.Size = UDim2.new(1, 0, 0, h)
                end
                task.spawn(refresh)
                -- auto refresh on layout change
                local conn
                conn = secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    if conn then conn:Disconnect() end
                    task.spawn(refresh)
                end)
                return listFrame
            end

            function sec:AddConfigButtons(args)
                args = args or {}
                local row = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1,
                    Parent = secContent
                })
                local saveBtn = mk("TextButton", {
                    Size = UDim2.new(0.5, -3, 0, 24), BackgroundColor3 = Theme.Success,
                    Text = "Kaydet", TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 11, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                    Parent = row
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = saveBtn
                local loadBtn = mk("TextButton", {
                    Size = UDim2.new(0.5, -3, 0, 24), Position = UDim2.new(0.5, 3, 0, 0),
                    BackgroundColor3 = Theme.Accent, Text = "Yukle",
                    TextColor3 = Color3.new(1, 1, 1), TextSize = 11,
                    Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = row
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = loadBtn
                local resetBtn = mk("TextButton", {
                    Size = UDim2.new(0.5, -3, 0, 24), Position = UDim2.new(0, 0, 0, 26),
                    BackgroundColor3 = Theme.Danger, Text = "Sifirla",
                    TextColor3 = Color3.new(1, 1, 1), TextSize = 11,
                    Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = row
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = resetBtn
                local cfgName = args.ConfigName or "config"
                saveBtn.MouseButton1Click:Connect(function() win:SaveConfig(cfgName) end)
                loadBtn.MouseButton1Click:Connect(function() win:LoadConfig(cfgName) end)
                resetBtn.MouseButton1Click:Connect(function() win:ResetAll() end)
                row.Size = UDim2.new(1, 0, 0, 52)
                return row
            end

            function sec:AddInfoBox(args)
                args = args or {}
                local txt = args.Text or "Bilgi"
                local typ = args.Type or "info"
                local colors = {info = Theme.Info, success = Theme.Success, warning = Theme.Warning, danger = Theme.Danger}
                local col = colors[typ] or Theme.Info
                local box = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = col,
                    BackgroundTransparency = 0.85, BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = box
                local side = mk("Frame", {
                    Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = col,
                    BorderSizePixel = 0, Parent = box
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = side
                local lbl = mk("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 0), Position = UDim2.new(0, 8, 0, 4),
                    BackgroundTransparency = 1, Text = txt, TextColor3 = col,
                    TextSize = 11, Font = Enum.Font.Gotham, TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left, RichText = true,
                    Parent = box
                })
                task.spawn(function()
                    task.wait()
                    local th = math.max(lbl.TextBounds.Y + 8, 20)
                    lbl.Size = UDim2.new(1, -12, 0, th - 8)
                    box.Size = UDim2.new(1, 0, 0, th)
                end)
                return box
            end

            function sec:AddList(args)
                args = args or {}
                local items = args.Items or {}
                local prefix = args.Prefix or "•"
                local color = args.Color or Theme.Text
                local lb = mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
                    Text = "", TextColor3 = color, TextSize = 11,
                    Font = Enum.Font.Gotham, TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left, RichText = true,
                    Parent = secContent
                })
                local function update()
                    local lines = {}
                    for _, item in pairs(items) do
                        table.insert(lines, prefix .. " " .. item)
                    end
                    lb.Text = table.concat(lines, "\n")
                    task.spawn(function()
                        task.wait()
                        lb.Size = UDim2.new(1, 0, 0, math.max(lb.TextBounds.Y, 16))
                    end)
                end
                update()
                local obj = {}
                function obj:Set(newItems) items = newItems; update() end
                function obj:Get() return items end
                return obj
            end

            function sec:AddToggleGroup(args)
                args = args or {}
                local n = args.Name or "Secim"
                local opts = args.Options or {"A", "B"}
                local def = args.Default or opts[1]
                local cb = args.Callback or function() end
                local sel = def
                mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
                    Text = n, TextColor3 = Color3.fromRGB(140, 140, 180),
                    TextSize = 11, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = secContent
                })
                local groupFrame = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, #opts * 22 + 4),
                    BackgroundColor3 = Theme.Input, BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = groupFrame
                local gli = mk("UIListLayout", {Padding = UDim.new(0, 2)}, nil):Parent = groupFrame
                local btns = {}
                for i, opt in pairs(opts) do
                    local b = mk("TextButton", {
                        Size = UDim2.new(1, -6, 0, 18), Position = UDim2.new(0, 3, 0, 0),
                        BackgroundColor3 = opt == sel and Theme.Accent or Theme.Third,
                        Text = opt, TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 10, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                        Parent = groupFrame
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 3)}, nil):Parent = b
                    b.MouseButton1Click:Connect(function()
                        sel = opt
                        for _, ob in pairs(btns) do ob.BackgroundColor3 = ob._opt == sel and Theme.Accent or Theme.Third end
                        pcall(cb, sel)
                    end)
                    b._opt = opt
                    table.insert(btns, b)
                end
                local obj = {}
                function obj:Get() return sel end
                function obj:Set(v) sel = v; for _, b in pairs(btns) do b.BackgroundColor3 = b._opt == sel and Theme.Accent or Theme.Third end end
                return obj
            end

            function sec:AddUIButton(args)
                args = args or {}
                local n = args.Name or "Element Sayisi"
                local btn = sec:AddButton({
                    Name = n .. ": " .. win:GetElementCount(),
                    Color = Theme.Info,
                    Callback = function()
                        local lines = {}
                        for _, t in pairs(win.tabs) do
                            table.insert(lines, t.Name .. ": " .. t:GetElementCount() .. " element")
                        end
                        Koli:Dialog({
                            Title = "Element Sayaci",
                            Text = table.concat(lines, "\n"),
                            Buttons = {{Text = "Tamam", Callback = function() end}}
                        })
                    end
                })
                return btn
            end

            function sec:AddLogViewer(args)
                args = args or {}
                local n = args.Name or "Konsol"; local maxLines = args.MaxLines or 50
                local h = args.Height or 120
                mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1,
                    Text = n, TextColor3 = Color3.fromRGB(140, 140, 180),
                    TextSize = 11, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = secContent
                })
                local bg = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = Color3.fromRGB(10, 10, 20),
                    BorderSizePixel = 0, ClipsDescendants = true, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = bg
                local sf = mk("ScrollingFrame", {
                    Size = UDim2.new(1, -6, 1, -6), Position = UDim2.new(0, 3, 0, 3),
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    ScrollBarThickness = 2, CanvasSize = UDim2.new(0, 0, 0, 0),
                    Parent = bg
                })
                local sl = mk("UIListLayout", {Padding = UDim.new(0, 2)}, nil):Parent = sf
                local lines = {}
                local obj = {}
                function obj:Log(text, color)
                    color = color or Color3.fromRGB(180, 180, 200)
                    table.insert(lines, {text, color})
                    if #lines > maxLines then table.remove(lines, 1) end
                    for _, c in pairs(sf:GetChildren()) do
                        if c:IsA("TextLabel") then c:Destroy() end
                    end
                    for _, entry in pairs(lines) do
                        local l = mk("TextLabel", {
                            Size = UDim2.new(1, -4, 0, 14), BackgroundTransparency = 1,
                            Text = entry[1], TextColor3 = entry[2],
                            TextSize = 10, Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = sf
                        })
                    end
                    sf.CanvasSize = UDim2.new(0, 0, 0, #lines * 16 + 4)
                    sf.CanvasPosition = Vector2.new(0, sf.CanvasSize.Y.Offset)
                end
                function obj:Clear()
                    lines = {}
                    for _, c in pairs(sf:GetChildren()) do
                        if c:IsA("TextLabel") then c:Destroy() end
                    end
                    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
                end
                return obj
            end

            function sec:AddStatCard(args)
                args = args or {}
                local n = args.Name or "Stats"
                local label = args.Label or ""
                local val = args.Value or "0"
                local color = args.Color or Theme.Accent
                local cf = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.Third,
                    BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 6)}, nil):Parent = cf
                local side = mk("Frame", {
                    Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = color,
                    BorderSizePixel = 0, Parent = cf
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 6)}, nil):Parent = side
                local vl = mk("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 18), Position = UDim2.new(0, 10, 0, 2),
                    BackgroundTransparency = 1, Text = tostring(val),
                    TextColor3 = color, TextSize = 16, Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = cf
                })
                mk("TextLabel", {
                    Size = UDim2.new(1, -12, 0, 14), Position = UDim2.new(0, 10, 0, 22),
                    BackgroundTransparency = 1, Text = label,
                    TextColor3 = Color3.fromRGB(160, 160, 180), TextSize = 10,
                    Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = cf
                })
                local obj = {}
                function obj:Set(v) val = tostring(v); vl.Text = val end
                function obj:Get() return val end
                return obj
            end

            function sec:AddTimer(args)
                args = args or {}
                local n = args.Name or "Geri Sayim"
                local total = args.Time or 30
                local running = false; local remaining = total
                local bg = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 8), BackgroundColor3 = Color3.fromRGB(40, 40, 55),
                    BorderSizePixel = 0, Parent = secContent
                })
                mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = bg
                local fill = mk("Frame", {
                    Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0, Parent = bg
                })
                mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = fill
                local lbl = mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 14), BackgroundTransparency = 1,
                    Text = n .. ": " .. remaining .. "s", TextColor3 = Theme.Text,
                    TextSize = 11, Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = secContent
                })
                local btnRow = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
                    Parent = secContent
                })
                local startBtn = mk("TextButton", {
                    Size = UDim2.new(0.5, -3, 0, 22), BackgroundColor3 = Theme.Success,
                    Text = "Baslat", TextColor3 = Color3.new(1, 1, 1),
                    TextSize = 11, Font = Enum.Font.Gotham, BorderSizePixel = 0,
                    Parent = btnRow
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = startBtn
                local resetBtn = mk("TextButton", {
                    Size = UDim2.new(0.5, -3, 0, 22), Position = UDim2.new(0.5, 3, 0, 0),
                    BackgroundColor3 = Theme.Danger, Text = "Sifirla",
                    TextColor3 = Color3.new(1, 1, 1), TextSize = 11,
                    Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = btnRow
                })
                mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = resetBtn
                startBtn.MouseButton1Click:Connect(function()
                    running = not running
                    startBtn.Text = running and "Durdur" or "Baslat"
                    startBtn.BackgroundColor3 = running and Theme.Warning or Theme.Success
                end)
                resetBtn.MouseButton1Click:Connect(function()
                    running = false; remaining = total
                    lbl.Text = n .. ": " .. remaining .. "s"
                    fill.Size = UDim2.new(1, 0, 1, 0)
                    startBtn.Text = "Baslat"; startBtn.BackgroundColor3 = Theme.Success
                end)
                task.spawn(function()
                    while true do
                        task.wait(1)
                        if running and remaining > 0 then
                            remaining = remaining - 1
                            lbl.Text = n .. ": " .. remaining .. "s"
                            fill.Size = UDim2.new(remaining / total, 0, 1, 0)
                            if remaining <= 0 then
                                running = false; startBtn.Text = "Baslat"; startBtn.BackgroundColor3 = Theme.Success
                                Koli:MakeToast(n .. " tamamlandi!", 2, Theme.Success)
                            end
                        end
                    end
                end)
                local obj = {}
                function obj:Set(t) total = t; remaining = t; lbl.Text = n .. ": " .. remaining .. "s" end
                function obj:Get() return remaining end
                return obj
            end

            -- auto resize
            local function resize()
                local h = secLayout.AbsoluteContentSize.Y
                secContent.Size = UDim2.new(1, -10, 0, h)
                secFrame.Size = UDim2.new(1, -8, 0, 30 + h + 6)
            end
            secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize)
            task.spawn(resize)

            table.insert(tab.sections, sec)
            return sec
        end

        table.insert(win.tabs, tab)

        if not win.activeTab then
            btn.BackgroundColor3 = Theme.Accent; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            page.Visible = true; win.activeTab = tab
        end

        return tab
    end

    return win
end

-- ====== CYBERPUNK THEME ======
Koli.Themes.Cyberpunk = {
    Main = Color3.fromRGB(5, 0, 20), Second = Color3.fromRGB(10, 5, 35),
    Third = Color3.fromRGB(20, 12, 50), Text = Color3.fromRGB(180, 180, 255),
    Accent = Color3.fromRGB(255, 0, 200), ToggleOn = Color3.fromRGB(0, 255, 200),
    ToggleOff = Color3.fromRGB(30, 20, 60), Danger = Color3.fromRGB(255, 30, 80),
    Input = Color3.fromRGB(15, 8, 42), Border = Color3.fromRGB(40, 20, 80),
    SectionBg = Color3.fromRGB(8, 3, 28), Success = Color3.fromRGB(0, 255, 150),
    Warning = Color3.fromRGB(255, 200, 0), Info = Color3.fromRGB(0, 200, 255)
}

-- ====== MIDNIGHT THEME ======
Koli.Themes.Midnight = {
    Main = Color3.fromRGB(8, 8, 20), Second = Color3.fromRGB(14, 14, 32),
    Third = Color3.fromRGB(22, 22, 45), Text = Color3.fromRGB(170, 170, 210),
    Accent = Color3.fromRGB(90, 120, 240), ToggleOn = Color3.fromRGB(40, 160, 120),
    ToggleOff = Color3.fromRGB(30, 30, 52), Danger = Color3.fromRGB(160, 40, 50),
    Input = Color3.fromRGB(18, 18, 40), Border = Color3.fromRGB(30, 30, 55),
    SectionBg = Color3.fromRGB(12, 12, 28), Success = Color3.fromRGB(50, 180, 120),
    Warning = Color3.fromRGB(200, 160, 40), Info = Color3.fromRGB(60, 120, 220)
}

-- ====== ORANGE THEME ======
Koli.Themes.Orange = {
    Main = Color3.fromRGB(28, 18, 8), Second = Color3.fromRGB(42, 28, 12),
    Third = Color3.fromRGB(58, 40, 18), Text = Color3.fromRGB(220, 190, 160),
    Accent = Color3.fromRGB(255, 140, 30), ToggleOn = Color3.fromRGB(180, 120, 40),
    ToggleOff = Color3.fromRGB(50, 36, 18), Danger = Color3.fromRGB(200, 60, 30),
    Input = Color3.fromRGB(48, 32, 14), Border = Color3.fromRGB(58, 42, 22),
    SectionBg = Color3.fromRGB(32, 22, 10), Success = Color3.fromRGB(60, 190, 60),
    Warning = Color3.fromRGB(240, 190, 30), Info = Color3.fromRGB(60, 140, 220)
}

-- ====== CONTEXT MENU ======
local _ctxMenu = nil

function Koli:ShowContextMenu(items, x, y)
    Koli:HideContextMenu()
    if not items or #items == 0 then return end
    local h = #items * 22 + 4
    _ctxMenu = mk("Frame", {
        Size = UDim2.new(0, 160, 0, h),
        Position = UDim2.new(0, x, 0, y),
        BackgroundColor3 = Color3.fromRGB(25, 25, 38), BorderSizePixel = 0,
        ZIndex = 999, Parent = parent, ClipsDescendants = true
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = _ctxMenu
    mk("UIStroke", {Color = Color3.fromRGB(50, 50, 65)}, nil):Parent = _ctxMenu
    local layout = mk("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, nil):Parent = _ctxMenu
    mk("UIPadding", {PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3), PaddingTop = UDim.new(0, 2)}, nil):Parent = _ctxMenu
    for _, item in pairs(items) do
        local b = mk("TextButton", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1, Text = item.Text,
            TextColor3 = item.Color or Color3.fromRGB(200, 200, 220),
            TextSize = 11, Font = Enum.Font.Gotham, BorderSizePixel = 0,
            ZIndex = 1000, Parent = _ctxMenu, TextXAlignment = Enum.TextXAlignment.Left
        })
        b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(45, 45, 60); b.BackgroundTransparency = 0 end)
        b.MouseLeave:Connect(function() b.BackgroundTransparency = 1 end)
        b.MouseButton1Click:Connect(function()
            pcall(item.Callback)
            Koli:HideContextMenu()
        end)
    end
end

function Koli:HideContextMenu()
    if _ctxMenu then _ctxMenu:Destroy(); _ctxMenu = nil end
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Koli:HideContextMenu()
    end
end)

-- ====== RIPPLE EFFECT ======
function Koli:AddRipple(btn, color)
    color = color or Color3.fromRGB(255, 255, 255)
    btn.MouseButton1Down:Connect(function()
        local r = mk("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = color, BackgroundTransparency = 0.6,
            BorderSizePixel = 0, ZIndex = btn.ZIndex + 1, Parent = btn
        })
        mk("UICorner", {CornerRadius = UDim.new(1, 0)}, nil):Parent = r
        local maxSize = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
        TS:Create(r, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            Position = UDim2.new(0.5, -maxSize/2, 0.5, -maxSize/2),
            BackgroundTransparency = 1
        }):Play()
        task.spawn(function() task.wait(0.5); pcall(r.Destroy, r) end)
    end)
end

-- ====== SMOOTH SCROLL ======
function Koli:MakeSmoothScroll(frame, speed)
    speed = speed or 0.15
    frame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        -- minimal smooth scroll via scrolling events
    end)
    local scrolling = false; local target = 0
    frame.MouseWheelForward:Connect(function()
        target = math.max(0, frame.CanvasPosition.Y - 30)
        TS:Create(frame, TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CanvasPosition = Vector2.new(0, target)
        }):Play()
    end)
    frame.MouseWheelBackward:Connect(function()
        target = math.min(frame.CanvasSize.Y.Offset, frame.CanvasPosition.Y + 30)
        TS:Create(frame, TweenInfo.new(speed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CanvasPosition = Vector2.new(0, target)
        }):Play()
    end)
end

-- ====== NOTIFICATION STACK ======
local _notifStack = {}
function Koli:PushNotification(args)
    table.insert(_notifStack, args)
    if #_notifStack == 1 then Koli:_showNextNotif() end
end

function Koli:_showNextNotif()
    if #_notifStack == 0 then return end
    local args = _notifStack[1]
    Koli:MakeNotification(args)
    task.wait((args.Time or 4) + 0.5)
    table.remove(_notifStack, 1)
    if #_notifStack > 0 then Koli:_showNextNotif() end
end

-- ====== GLOBAL CONFIG MANAGER ======
function Koli:SaveAllConfigs(name)
    name = name or "global"
    local allData = {}
    for id, el in pairs(Koli._elements or {}) do
        if el.Get then allData[id] = el:Get() end
    end
    if writefile then
        local ok, json = pcall(function() return game:GetService("HttpService"):JSONEncode(allData) end)
        if ok then pcall(writefile, "koli_global_" .. name .. ".cfg", json) end
    end
end

function Koli:LoadAllConfigs(name)
    name = name or "global"
    local data = {}
    if readfile then
        local ok, json = pcall(readfile, "koli_global_" .. name .. ".cfg")
        if ok then
            local ok2, dec = pcall(function() return game:GetService("HttpService"):JSONDecode(json) end)
            if ok2 then data = dec end
        end
    end
    for id, val in pairs(data) do
        local el = Koli._elements and Koli._elements[id]
        if el and el.Set then el:Set(val) end
    end
    return data
end

-- ====== TRAY / MINI WINDOW ======
function Koli:MakeTray(text, items)
    local f = mk("Frame", {
        Size = UDim2.new(0, 180, 0, 28),
        Position = UDim2.new(0.5, -90, 0, 0),
        BackgroundColor3 = Color3.fromRGB(24, 24, 38), BorderSizePixel = 0,
        Parent = parent, ClipsDescendants = true
    })
    mk("UICorner", {CornerRadius = UDim.new(0, 4)}, nil):Parent = f
    mk("UIStroke", {Color = Color3.fromRGB(50, 50, 65)}, nil):Parent = f
    mk("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = f
    })
    local menuBtn = mk("TextButton", {
        Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -24, 0, 4),
        BackgroundTransparency = 1, Text = "...", TextColor3 = Color3.fromRGB(200, 200, 220),
        TextSize = 10, Font = Enum.Font.Gotham, BorderSizePixel = 0, Parent = f
    })
    menuBtn.MouseButton1Click:Connect(function()
        Koli:ShowContextMenu(items, f.AbsolutePosition.X + f.AbsoluteSize.X, f.AbsolutePosition.Y)
    end)
    return f
end

-- ====== TOGGLE ALL UTILITY ======
function Koli:ToggleAll(winObj, state)
    for id, el in pairs(winObj._elements) do
        if el._type == "toggle" then el:Set(state) end
    end
end

return Koli
