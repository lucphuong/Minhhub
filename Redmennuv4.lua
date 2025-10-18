-- RedMenuV4.lua
-- Horizontal Red Menu (SAFE) - includes FlyV3, Immortal, Invisible, InfJump, Speed, JumpPower, TeleportGUI, AntiAFK, Master
-- External loads run inside pcall; cleanup attempted when possible.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- STATE
local state = {
    Master = true,
    FlyV3 = false,
    Immortal = false,
    Invisible = false,
    InfJump = false,
    Speed = false,
    JumpPower = false,
    TeleportGUI = false,
    AntiAFK = true,
}

local handles = {}

-- UTIL: cleanup
local function tryCleanup(key)
    local h = handles[key]
    if not h then return end
    local ok
    if typeof(h) == "RBXScriptConnection" then
        pcall(function() h:Disconnect() end)
    elseif typeof(h) == "Instance" and h.Destroy then
        pcall(function() h:Destroy() end)
    elseif type(h) == "function" then
        pcall(h)
    end
    handles[key] = nil
end

-- UTIL: safe load and run (inline loadstring)
local function safeLoadFromUrlInline(key, url)
    if not url or url == "" then
        warn("Missing URL for", key); return
    end
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if not ok then
        warn(("HttpGet failed for %s: %s"):format(key, tostring(res)))
        return
    end
    local ok2, ret = pcall(function()
        local f, err = loadstring(res)
        if not f then error(err or "loadstring failed") end
        return f()
    end)
    if not ok2 then
        warn(("Execution failed for %s: %s"):format(key, tostring(ret)))
        return
    end
    handles[key] = ret
    return true
end

-- HOOKS

-- FlyV3
hooks = {}
hooks.FlyV3 = function(enable)
    if not state.Master then
        print("Master OFF — Fly change ignored.")
        return
    end
    if enable then
        -- Fly script URL
        safeLoadFromUrlInline("FlyV3", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
        print("FlyV3 executed (may not return cleanup handle).")
    else
        tryCleanup("FlyV3")
        print("FlyV3 disabled (cleanup attempted).")
    end
end

-- Immortal (Bất tử)
hooks.Immortal = function(enable)
    if not state.Master then
        print("Master OFF — Immortal change ignored.")
        return
    end
    if enable then
        safeLoadFromUrlInline("Immortal", "https://raw.githubusercontent.com/Dan41/Scripts/main/Imortal.txt")
        print("Immortal executed.")
    else
        tryCleanup("Immortal")
        print("Immortal disabled.")
    end
end

-- Invisible (Tàn hình)
hooks.Invisible = function(enable)
    if not state.Master then
        print("Master OFF — Invisible change ignored.")
        return
    end
    if enable then
        safeLoadFromUrlInline("Invisible", "https://abre.ai/invisible-v2")
        print("Invisible executed.")
    else
        tryCleanup("Invisible")
        print("Invisible disabled.")
    end
end

-- Inf Jump (local)
do
    local conn
    hooks.InfJump = function(enable)
        if not state.Master then
            print("Master OFF — InfJump change ignored.")
            return
        end
        if enable then
            if conn then return end
            conn = UserInputService.JumpRequest:Connect(function()
                pcall(function()
                    local c = LocalPlayer.Character
                    if c then
                        local h = c:FindFirstChildOfClass("Humanoid")
                        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                    end
                end)
            end)
            handles.InfJump = conn
            print("InfJump enabled.")
        else
            tryCleanup("InfJump")
            print("InfJump disabled.")
        end
    end
end

-- Speed (simple local speed changer)
do
    local originalWalkSpeed = nil
    local speedVal = 100 -- default when ON
    hooks.Speed = function(enable)
        if not state.Master then
            print("Master OFF — Speed change ignored.")
            return
        end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if enable then
            if hum then
                if not originalWalkSpeed then originalWalkSpeed = hum.WalkSpeed end
                pcall(function() hum.WalkSpeed = speedVal end)
                handles.Speed = function() if hum then pcall(function() hum.WalkSpeed = originalWalkSpeed end) end end
                print("Speed set to", speedVal)
            else
                print("Speed: humanoid not found")
            end
        else
            tryCleanup("Speed")
            originalWalkSpeed = nil
            print("Speed disabled.")
        end
    end
end

-- JumpPower (set JumpPower on HumanoidRootPart?) -> implement as Humanoid.JumpPower if available
do
    local origJumpPower = nil
    local jpVal = 100 -- default JP when ON
    hooks.JumpPower = function(enable)
        if not state.Master then
            print("Master OFF — JumpPower change ignored.")
            return
        end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if enable then
            if hum then
                if origJumpPower == nil and hum.JumpPower then origJumpPower = hum.JumpPower end
                pcall(function() if hum.JumpPower then hum.JumpPower = jpVal end end)
                handles.JumpPower = function() if hum and origJumpPower then pcall(function() hum.JumpPower = origJumpPower end) end end
                print("JumpPower set to", jpVal)
            else
                print("JumpPower: humanoid not found")
            end
        else
            tryCleanup("JumpPower")
            origJumpPower = nil
            print("JumpPower disabled.")
        end
    end
end

-- Teleport GUI (inline, cleanupable)
hooks.TeleportGUI = function(enable)
    if not state.Master then
        print("Master OFF — Teleport change ignored.")
        return
    end
    if enable then
        if handles.TeleportGUI then return end
        local Players = Players
        local UIS = UserInputService
        local LocalP = LocalPlayer
        local teleportTarget = nil

        local sg = Instance.new("ScreenGui")
        sg.Name = "RedMenu_TeleportGUI"
        sg.ResetOnSpawn = false
        sg.Parent = PlayerGui

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0,220,0,260)
        frame.Position = UDim2.new(0.5,-110,0.3,0)
        frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        frame.Parent = sg

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1,0,0,26)
        title.BackgroundTransparency = 0.3
        title.Text = "Teleport GUI"
        title.TextColor3 = Color3.new(1,1,1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = frame

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1,-10,1,-60)
        scroll.Position = UDim2.new(0,5,0,30)
        scroll.CanvasSize = UDim2.new(0,0,2,0)
        scroll.BackgroundColor3 = Color3.fromRGB(20,20,20)
        scroll.Parent = frame

        local layout = Instance.new("UIListLayout", scroll)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(1,-10,0,28)
        tpBtn.Position = UDim2.new(0,5,1,-34)
        tpBtn.Text = "Teleport"
        tpBtn.Parent = frame

        local function updateList()
            for _,c in pairs(scroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            for _,pl in pairs(Players:GetPlayers()) do
                if pl ~= LocalP then
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1,0,0,24)
                    b.Text = pl.Name
                    b.Parent = scroll
                    b.MouseButton1Click:Connect(function()
                        teleportTarget = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                        tpBtn.Text = "Teleport to: "..pl.Name
                    end)
                end
            end
        end

        tpBtn.MouseButton1Click:Connect(function()
            if teleportTarget and LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function() LocalP.Character:FindFirstChild("HumanoidRootPart").CFrame = teleportTarget.CFrame + Vector3.new(0,3,0) end)
            end
        end)

        local added = Players.PlayerAdded:Connect(updateList)
        local rem = Players.PlayerRemoving:Connect(updateList)
        updateList()

        -- draggable small
        local draggingTG=false; local ds, sp
        title.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                draggingTG=true; ds=input.Position; sp=frame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingTG and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta = input.Position - ds
                frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset+delta.X, sp.Y.Scale, sp.Y.Offset+delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then draggingTG=false end
        end)

        handles.TeleportGUI = function()
            pcall(function() added:Disconnect() end)
            pcall(function() rem:Disconnect() end)
            pcall(function() if sg and sg.Parent then sg:Destroy() end end)
        end

        print("Teleport GUI enabled.")
    else
        tryCleanup("TeleportGUI")
        print("Teleport GUI disabled.")
    end
end

-- AntiAFK (local safe)
hooks.AntiAFK = function(enable)
    if not state.Master then
        print("Master OFF — AntiAFK change ignored.")
        return
    end
    if enable then
        if handles._antiafk then return end
        local conn = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end)
        handles._antiafk = conn
        print("AntiAFK enabled.")
    else
        tryCleanup("_antiafk")
        print("AntiAFK disabled.")
    end
end

-- UI: horizontal toolbar
local function createMenu()
    if PlayerGui:FindFirstChild("RedMenuSafeH") then PlayerGui.RedMenuSafeH:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "RedMenuSafeH"
    sg.ResetOnSpawn = false
    sg.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 520, 0, 48)
    frame.Position = UDim2.new(0.02,0,0.02,0)
    frame.BackgroundColor3 = Color3.fromRGB(145,20,20)
    frame.AnchorPoint = Vector2.new(0,0)
    frame.Parent = sg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0,160,1,0)
    title.Position = UDim2.new(0,8,0,0)
    title.BackgroundTransparency = 1
    title.Text = "🔴 RED MENU"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame

    -- Buttons list (icons + keys)
    local buttons = {
        {key="FlyV3", label="Fly"},
        {key="Immortal", label="Bất tử"},
        {key="Invisible", label="Tàng hình"},
        {key="InfJump", label="InfJump"},
        {key="Speed", label="Speed"},
        {key="JumpPower", label="JumpP"},
        {key="TeleportGUI", label="Teleport"},
        {key="AntiAFK", label="AntiAFK"},
    }

    local btnObjs = {}

    for i,info in ipairs(buttons) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,60,0,36)
        btn.Position = UDim2.new(0, 176 + (i-1)*64, 0, 6)
        btn.BackgroundColor3 = state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
        btn.Text = info.label .. (state[info.key] and " [ON]" or " [OFF]")
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            state[info.key] = not state[info.key]
            btn.BackgroundColor3 = state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
            btn.Text = info.label .. (state[info.key] and " [ON]" or " [OFF]")
            -- call hook if exists
            pcall(function()
                local h = hooks[info.key]
                if type(h) == "function" then h(state[info.key]) end
            end)
        end)

        btnObjs[info.key] = btn
    end

    -- Master toggle small
    local masterBtn = Instance.new("TextButton")
    masterBtn.Size = UDim2.new(0,80,0,36)
    masterBtn.Position = UDim2.new(0, 176 + #buttons*64, 0, 6)
    masterBtn.BackgroundColor3 = state.Master and Color3.fromRGB(20,140,20) or Color3.fromRGB(80,80,80)
    masterBtn.Text = state.Master and "Master ON" or "Master OFF"
    masterBtn.Font = Enum.Font.GothamBold
    masterBtn.TextSize = 14
    masterBtn.TextColor3 = Color3.new(1,1,1)
    masterBtn.Parent = frame

    masterBtn.MouseButton1Click:Connect(function()
        state.Master = not state.Master
        masterBtn.BackgroundColor3 = state.Master and Color3.fromRGB(20,140,20) or Color3.fromRGB(80,80,80)
        masterBtn.Text = state.Master and "Master ON" or "Master OFF"
        if not state.Master then
            -- attempt to disable active features but keep UI states
            for k,_ in pairs(state) do
                if k ~= "Master" and state[k] then
                    pcall(function()
                        if hooks[k] then hooks[k](false) end
                    end)
                end
            end
        else
            print("Master ON: toggles work again.")
        end
    end)

    -- drag whole toolbar by title or frame area
    local dragging=false; local ds, sp
    local dragTarget = frame -- drag anywhere on the frame
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; ds=input.Position; sp=frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local delta = input.Position - ds
            frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset+delta.X, sp.Y.Scale, sp.Y.Offset+delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)

    -- small visibility toggle (corner)
    local vis = Instance.new("TextButton")
    vis.Size = UDim2.new(0,28,0,28)
    vis.Position = UDim2.new(1,-36,0,8)
    vis.Text = "—"
    vis.Font = Enum.Font.GothamBold
    vis.TextSize = 18
    vis.BackgroundColor3 = Color3.fromRGB(100,0,0)
    vis.TextColor3 = Color3.new(1,1,1)
    vis.Parent = frame
    vis.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
        vis.Text = frame.Visible and "—" or "≡"
    end)
end

-- CREATE
createMenu()

-- INIT: run any hooks that were true by default
for k,v in pairs(state) do
    if k~="Master" and v and hooks[k] then
        pcall(function() hooks[k](true) end)
    end
end

print("RedMenuV4 loaded (Fly included).")
