-- RedMenuV5.lua
-- Horizontal Red Menu (SAFE)
-- Buttons: Fly, Shader, Teleport, Speed, InfJump, AntiAFK, Immortal, Invisible
-- External loads wrapped in pcall. No anti-ban included.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- state
local state = {
    Fly = false,
    Shader = false,
    Teleport = false,
    Speed = false,
    InfJump = false,
    AntiAFK = false,
    Immortal = false,
    Invisible = false
}

local handles = {}

-- safe cleanup helper
local function tryCleanup(key)
    local h = handles[key]
    if not h then return end
    pcall(function()
        if typeof(h) == "RBXScriptConnection" then
            h:Disconnect()
        elseif typeof(h) == "Instance" and h.Destroy then
            h:Destroy()
        elseif type(h) == "function" then
            h()
        end
    end)
    handles[key] = nil
end

-- safe inline loadstring from URL (pcall wrapper)
local function safeLoadInline(key, url)
    if not url or url == "" then
        warn("safeLoadInline: missing url for", key); return false
    end
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if not ok then
        warn(("HttpGet failed for %s: %s"):format(key, tostring(res)))
        return false
    end
    local ok2, ret = pcall(function()
        local fn, err = loadstring(res)
        if not fn then error(err or "loadstring failed") end
        return fn()
    end)
    if not ok2 then
        warn(("Execution failed for %s: %s"):format(key, tostring(ret)))
        return false
    end
    handles[key] = ret
    return true
end

-- HOOKS / feature implementations

-- Fly (external)
local function toggleFly(on)
    if on then
        safeLoadInline("Fly", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
    else
        tryCleanup("Fly")
    end
end

-- Shader (external)
local function toggleShader(on)
    if on then
        safeLoadInline("Shader", "https://pastefy.app/xXkUxA0P/raw")
    else
        tryCleanup("Shader")
    end
end

-- Teleport GUI (inline, cleanupable)
local function toggleTeleport(on)
    if on then
        if handles.Teleport then return end
        local sg = Instance.new("ScreenGui")
        sg.Name = "RM_Teleport_GUI"
        sg.ResetOnSpawn = false
        sg.Parent = PlayerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 260, 0, 300)
        frame.Position = UDim2.new(0.5, -130, 0.3, 0)
        frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        frame.Parent = sg

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1,0,0,28)
        title.BackgroundTransparency = 0.2
        title.Text = "Teleport GUI"
        title.TextColor3 = Color3.new(1,1,1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = frame

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1,-10,1,-64)
        scroll.Position = UDim2.new(0,5,0,32)
        scroll.CanvasSize = UDim2.new(0,0,1,0)
        scroll.BackgroundColor3 = Color3.fromRGB(22,22,22)
        scroll.Parent = frame

        local layout = Instance.new("UIListLayout", scroll)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(1,-10,0,30)
        tpBtn.Position = UDim2.new(0,5,1,-34)
        tpBtn.Text = "Teleport"
        tpBtn.Parent = frame

        local target = nil
        local function refresh()
            for _,c in pairs(scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            for _,pl in pairs(Players:GetPlayers()) do
                if pl ~= LocalPlayer then
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1,0,0,24)
                    b.Text = pl.Name
                    b.Parent = scroll
                    b.MouseButton1Click:Connect(function()
                        target = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                        tpBtn.Text = "Teleport to: "..pl.Name
                    end)
                end
            end
        end
        refresh()
        local added = Players.PlayerAdded:Connect(refresh)
        local removed = Players.PlayerRemoving:Connect(refresh)

        tpBtn.MouseButton1Click:Connect(function()
            if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = target.CFrame + Vector3.new(0,3,0)
                end)
            end
        end)

        -- draggable by title or frame
        local dragging=false; local ds, sp
        frame.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true; ds=input.Position; sp=frame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta = input.Position - ds
                frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
        end)

        handles.Teleport = function()
            pcall(function() added:Disconnect() end)
            pcall(function() removed:Disconnect() end)
            pcall(function() if sg and sg.Parent then sg:Destroy() end end)
        end
    else
        tryCleanup("Teleport")
    end
end

-- Speed (local simple)
local function toggleSpeed(on)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if on then
        if hum then
            handles._origWalk = hum.WalkSpeed
            pcall(function() hum.WalkSpeed = 100 end)
        end
    else
        if hum and handles._origWalk then pcall(function() hum.WalkSpeed = handles._origWalk end) end
        handles._origWalk = nil
    end
end

-- InfJump (local)
local function toggleInfJump(on)
    if on then
        if handles._infConn then return end
        local c = UserInputService.JumpRequest:Connect(function()
            pcall(function()
                local ch = LocalPlayer.Character
                if ch then
                    local h = ch:FindFirstChildOfClass("Humanoid")
                    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end)
        end)
        handles._infConn = c
    else
        tryCleanup("_infConn")
    end
end

-- AntiAFK (local safe)
local function toggleAntiAFK(on)
    if on then
        if handles._afk then return end
        local c = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end)
        handles._afk = c
    else
        tryCleanup("_afk")
    end
end

-- Immortal (external)
local function toggleImmortal(on)
    if on then
        safeLoadInline("Immortal", "https://raw.githubusercontent.com/Dan41/Scripts/main/Imortal.txt")
    else
        tryCleanup("Immortal")
    end
end

-- Invisible (external)
local function toggleInvisible(on)
    if on then
        safeLoadInline("Invisible", "https://abre.ai/invisible-v2")
    else
        tryCleanup("Invisible")
    end
end

-- Mapping keys -> functions
local featureMap = {
    Fly = toggleFly,
    Shader = toggleShader,
    Teleport = toggleTeleport,
    Speed = toggleSpeed,
    InfJump = toggleInfJump,
    AntiAFK = toggleAntiAFK,
    Immortal = toggleImmortal,
    Invisible = toggleInvisible
}

-- UI: horizontal toolbar (big buttons, evenly spaced)
local function createMenu()
    if PlayerGui:FindFirstChild("RedMenuV5") then PlayerGui.RedMenuV5:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "RedMenuV5"
    sg.ResetOnSpawn = false
    sg.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Name = "Toolbar"
    frame.Size = UDim2.new(0, 760, 0, 56) -- wide
    frame.Position = UDim2.new(0.5, -380, 0.04, 0) -- top center
    frame.BackgroundColor3 = Color3.fromRGB(150,20,20)
    frame.BorderSizePixel = 0
    frame.Parent = sg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0,140,1,0)
    title.Position = UDim2.new(0,8,0,0)
    title.BackgroundTransparency = 1
    title.Text = "🔴 RED MENU V5"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame

    local features = {"Fly","Immortal","Invisible","InfJump","Speed","Teleport","AntiAFK","Shader"}
    local spacing = 88
    local startX = 160

    for i, key in ipairs(features) do
        local lbl = key
        local btn = Instance.new("TextButton")
        btn.Name = "BTN_"..key
        btn.Size = UDim2.new(0,80,0,40)
        btn.Position = UDim2.new(0, startX + (i-1)*spacing, 0, 8)
        btn.BackgroundColor3 = state[key] and Color3.fromRGB(25,150,25) or Color3.fromRGB(140,15,15)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Text = lbl .. (state[key] and "\n[ON]" or "\n[OFF]")
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            state[key] = not state[key]
            btn.BackgroundColor3 = state[key] and Color3.fromRGB(25,150,25) or Color3.fromRGB(140,15,15)
            btn.Text = lbl .. (state[key] and "\n[ON]" or "\n[OFF]")
            pcall(function()
                local fn = featureMap[key]
                if type(fn) == "function" then fn(state[key]) end
            end)
        end)
    end

    -- drag the whole toolbar by clicking frame
    local dragging=false; local ds, sp
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            ds = input.Position
            sp = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta = input.Position - ds
            frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging=false end
    end)
end

createMenu()

-- initialize any true states (none by default)
for k,v in pairs(state) do
    if v and featureMap[k] then
        pcall(function() featureMap[k](true) end)
    end
end

print("RedMenuV5 loaded.")
