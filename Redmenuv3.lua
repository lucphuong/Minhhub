-- RED MENU (SAFE) with master toggle + user-provided scripts integrated
-- NOTE: Anti-Ban code is NOT included (disallowed). Everything else is wrapped safely.
-- External HTTP loads are wrapped in pcall. Cleanup is attempted when possible but not guaranteed.

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Config (simple, non-persistent)
local state = {
    Master = true,      -- master switch: if false, individual toggles won't run hooks (but UI shows their ON/OFF)
    InfJump = false,
    FlyV3 = false,
    Shader = false,
    TeleportGUI = false,
    Speed = false,
    AntiAFK = false,
    Immortal = false,   -- Bất tử
    Invisible = false   -- Tàn hình
}

-- store handles returned by scripts so we can try cleanup when disabled
local handles = {}

-- helper: attempt to call/destroy a handle when disabling
local function tryCleanup(key)
    local h = handles[key]
    if not h then return end
    local ok, err
    if type(h) == "function" then
        ok, err = pcall(h) -- call cleanup function
        if not ok then warn("Cleanup function for", key, "errored:", err) end
    elseif typeof(h) == "RBXScriptConnection" then
        pcall(function() h:Disconnect() end)
    elseif typeof(h) == "Instance" and h.Destroy then
        ok, err = pcall(function() h:Destroy() end)
        if not ok then warn("Destroy for", key, "errored:", err) end
    else
        -- unknown handle type
        print(("No standard cleanup available for %s (type: %s)"):format(key, type(h)))
    end
    handles[key] = nil
end

-- helper: safely load external URL content and execute (loadstring) inline, storing returned handle
local function safeLoadFromUrlInline(key, url)
    if not url or url == "" then
        warn("safeLoadFromUrlInline: missing url for", key); return
    end
    local ok, res = pcall(function()
        return game:HttpGet(url, true)
    end)
    if not ok then
        warn(("HttpGet failed for %s: %s"):format(key, tostring(res)))
        return
    end
    local ok2, ret = pcall(function()
        local f, errmsg = loadstring(res)
        if not f then error(("loadstring error: %s"):format(tostring(errmsg))) end
        return f()
    end)
    if not ok2 then
        warn(("Execution error for %s: %s"):format(key, tostring(ret)))
        return
    end
    -- store returned handle (could be nil, an Instance, or a cleanup function)
    handles[key] = ret
    print(("Loaded and executed external script for %s"):format(key))
end

-- HOOKS: integrate user-provided scripts here
local hooks = {}

-- INFJUMP
do
    local conn
    hooks.InfJump = function(enable)
        if not state.Master then
            print("Master is OFF — InfJump change ignored (UI updated only).")
            return
        end
        if enable then
            if conn then return end
            conn = game:GetService("UserInputService").JumpRequest:Connect(function()
                pcall(function()
                    local plr = game:GetService("Players").LocalPlayer
                    local char = plr and plr.Character
                    if char then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end)
            end)
            handles.InfJump = conn
            print("InfJump ENABLED")
        else
            tryCleanup("InfJump")
            print("InfJump DISABLED")
        end
    end
end

-- FLY V3 (external)
hooks.FlyV3 = function(enable)
    if not state.Master then
        print("Master is OFF — FlyV3 change ignored (UI updated only).")
        return
    end
    if enable then
        safeLoadFromUrlInline("FlyV3", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
        if not handles.FlyV3 then
            print("FlyV3 executed (no cleanup handle returned).")
        end
    else
        tryCleanup("FlyV3")
        print("FlyV3 DISABLED (cleanup attempted)")
    end
end

-- SHADER (external)
hooks.Shader = function(enable)
    if not state.Master then
        print("Master is OFF — Shader change ignored (UI updated only).")
        return
    end
    if enable then
        safeLoadFromUrlInline("Shader", "https://pastefy.app/xXkUxA0P/raw")
    else
        tryCleanup("Shader")
        print("Shader DISABLED (cleanup attempted)")
    end
end

-- TELEPORT GUI (inline in earlier code but we'll load from the repo or create inline)
hooks.TeleportGUI = function(enable)
    if not state.Master then
        print("Master is OFF — TeleportGUI change ignored (UI updated only).")
        return
    end
    if enable then
        -- create small inline teleport GUI (safe), or try to load from repo if you prefer
        -- We'll create inline so we can cleanup reliably
        if handles.TeleportGUI then return end
        local Players = game:GetService("Players")
        local UIS = game:GetService("UserInputService")
        local LocalP = Players.LocalPlayer
        local teleportTarget = nil

        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "RedMenu_TeleportGUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = PlayerGui

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 250, 0, 300)
        Frame.Position = UDim2.new(0.5, -125, 0.4, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Frame.BorderSizePixel = 2
        Frame.Parent = ScreenGui

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Title.Text = "Player Teleport GUI"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 14
        Title.Parent = Frame

        local ScrollingFrame = Instance.new("ScrollingFrame")
        ScrollingFrame.Name = "PlayerList"
        ScrollingFrame.Size = UDim2.new(1, -10, 1, -70)
        ScrollingFrame.Position = UDim2.new(0, 5, 0, 35)
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
        ScrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        ScrollingFrame.Parent = Frame

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = ScrollingFrame
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local TPButton = Instance.new("TextButton")
        TPButton.Size = UDim2.new(1, -10, 0, 30)
        TPButton.Position = UDim2.new(0, 5, 1, -35)
        TPButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        TPButton.Text = "Teleport"
        TPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TPButton.Font = Enum.Font.GothamBold
        TPButton.TextSize = 14
        TPButton.Parent = Frame

        local function updatePlayerList()
            for _, child in pairs(ScrollingFrame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            for _, pl in pairs(Players:GetPlayers()) do
                if pl ~= LocalP then
                    local PlayerButton = Instance.new("TextButton")
                    PlayerButton.Size = UDim2.new(1, 0, 0, 25)
                    PlayerButton.Text = pl.Name
                    PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    PlayerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    PlayerButton.Font = Enum.Font.Gotham
                    PlayerButton.TextSize = 12
                    PlayerButton.Parent = ScrollingFrame

                    PlayerButton.MouseButton1Click:Connect(function()
                        teleportTarget = pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                        TPButton.Text = "Teleport to: " .. pl.Name
                    end)
                end
            end
        end

        TPButton.MouseButton1Click:Connect(function()
            if teleportTarget and LocalP.Character and LocalP.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    LocalP.Character:FindFirstChild("HumanoidRootPart").CFrame = teleportTarget.CFrame + Vector3.new(0, 3, 0)
                end)
            end
        end)

        local addedConn = Players.PlayerAdded:Connect(updatePlayerList)
        local remConn = Players.PlayerRemoving:Connect(updatePlayerList)
        updatePlayerList()

        -- draggable for tele frame
        local draggingTG, dragStartTG, startPosTG
        Title.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingTG = true
                dragStartTG = input.Position
                startPosTG = Frame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingTG and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStartTG
                Frame.Position = UDim2.new(startPosTG.X.Scale, startPosTG.X.Offset + delta.X, startPosTG.Y.Scale, startPosTG.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingTG = false
            end
        end)

        -- store cleanup handle
        handles.TeleportGUI = function()
            pcall(function() addedConn:Disconnect() end)
            pcall(function() remConn:Disconnect() end)
            pcall(function() if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end end)
        end

        print("Teleport GUI ENABLED")
    else
        tryCleanup("TeleportGUI")
        print("Teleport GUI DISABLED")
    end
end

-- SPEED
hooks.Speed = function(enable)
    if not state.Master then
        print("Master is OFF — Speed change ignored (UI updated only).")
        return
    end
    if enable then
        safeLoadFromUrlInline("Speed", "https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer")
    else
        tryCleanup("Speed")
        print("Speed DISABLED")
    end
end

-- ANTI-AFK (local VirtualUser fallback)
hooks.AntiAFK = function(enable)
    if not state.Master then
        print("Master is OFF — AntiAFK change ignored (UI updated only).")
        return
    end
    if enable then
        if handles._localAntiAfkConn then return end
        local conn = Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
            pcall(function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.Jump = true; wait(0.1); humanoid.Jump = false end
            end)
            warn("Anti-AFK: simulated input")
        end)
        handles._localAntiAfkConn = conn
        handles.AntiAFK_cleanup = function() if handles._localAntiAfkConn then pcall(function() handles._localAntiAfkConn:Disconnect() end); handles._localAntiAfkConn = nil end end
        print("AntiAFK ENABLED")
    else
        tryCleanup("AntiAFK_cleanup")
        tryCleanup("_localAntiAfkConn")
        print("AntiAFK DISABLED")
    end
end

-- NEW: Immortal (Bất tử) - user-provided loadstring
hooks.Immortal = function(enable)
    if not state.Master then
        print("Master is OFF — Immortal change ignored (UI updated only).")
        return
    end
    if enable then
        safeLoadFromUrlInline("Immortal", "https://raw.githubusercontent.com/Dan41/Scripts/main/Imortal.txt")
        if not handles.Immortal then
            print("Immortal executed (no cleanup handle returned).")
        end
    else
        tryCleanup("Immortal")
        print("Immortal DISABLED (cleanup attempted)")
    end
end

-- NEW: Invisible / Tàn hình - user-provided loadstring
hooks.Invisible = function(enable)
    if not state.Master then
        print("Master is OFF — Invisible change ignored (UI updated only).")
        return
    end
    if enable then
        safeLoadFromUrlInline("Invisible", "https://abre.ai/invisible-v2")
        if not handles.Invisible then
            print("Invisible executed (no cleanup handle returned).")
        end
    else
        tryCleanup("Invisible")
        print("Invisible DISABLED (cleanup attempted)")
    end
end

-- ---------- UI ----------
local function createMenu()
    if PlayerGui:FindFirstChild("RedMenuSafe") then
        PlayerGui.RedMenuSafe:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RedMenuSafe"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 520)
    frame.Position = UDim2.new(0.02,0,0.08,0)
    frame.BackgroundColor3 = Color3.fromRGB(145,20,20)
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,48)
    title.BackgroundColor3 = Color3.fromRGB(190,30,30)
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Text = "🔴 RED MENU (SAFE)"
    title.Parent = frame

    -- Master toggle button
    local masterBtn = Instance.new("TextButton")
    masterBtn.Size = UDim2.new(0, 120, 0, 30)
    masterBtn.Position = UDim2.new(1, -140, 0, 8)
    masterBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    masterBtn.TextColor3 = Color3.new(1,1,1)
    masterBtn.Font = Enum.Font.GothamBold
    masterBtn.TextSize = 14
    masterBtn.Text = state.Master and "Master: ON" or "Master: OFF"
    masterBtn.Parent = frame

    masterBtn.MouseButton1Click:Connect(function()
        state.Master = not state.Master
        masterBtn.Text = state.Master and "Master: ON" or "Master: OFF"
        -- When master toggled OFF, we will **NOT** force-turn-off individual UI states,
        -- but we can optionally call hooks(false) to disable running features.
        if not state.Master then
            -- disable running features (attempt cleanup)
            for k, v in pairs(state) do
                if k ~= "Master" and v then
                    -- attempt to disable running features but keep UI state
                    pcall(function()
                        if type(hooks[k]) == "function" then
                            hooks[k](false)
                        end
                    end)
                end
            end
            print("Master OFF: attempted to disable active features (UI still shows previous ON/OFF).")
        else
            print("Master ON: individual toggles are active again.")
        end
    end)

    local items = {
        {key="InfJump", label="Infinite Jump"},
        {key="FlyV3", label="Fly V3"},
        {key="Shader", label="Shader"},
        {key="TeleportGUI", label="Teleport GUI"},
        {key="Speed", label="Speed Changer"},
        {key="AntiAFK", label="Anti-AFK"},
        {key="Immortal", label="Bất tử"},
        {key="Invisible", label="Tàn hình"},
    }

    local uiButtons = {}

    for i, info in ipairs(items) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 44)
        btn.Position = UDim2.new(0, 10, 0, 64 + (i-1)*56)
        btn.BackgroundColor3 = state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Text = info.label .. (state[info.key] and " [ON]" or " [OFF]")
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            -- AntiBan not present here; if you add, block it
            state[info.key] = not state[info.key]
            btn.BackgroundColor3 = state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
            btn.Text = info.label .. (state[info.key] and " [ON]" or " [OFF]")

            -- Only call hook if Master is ON
            if state.Master then
                pcall(function()
                    if type(hooks[info.key]) == "function" then
                        hooks[info.key](state[info.key])
                    end
                end)
            else
                print(("Master OFF: %s changed to %s (hook not called)").format(info.key, tostring(state[info.key])))
            end
        end)

        uiButtons[info.key] = btn
    end

    -- info label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 80)
    infoLabel.Position = UDim2.new(0, 10, 0, 64 + #items*56)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.new(1,1,1)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 14
    infoLabel.Text = "Note: External scripts loaded via HTTP are executed in pcall. Anti-Ban is disabled. Cleanup may be incomplete for some scripts.\nMaster: when OFF, hooks won't run (but UI shows toggles)."
    infoLabel.TextWrapped = true
    infoLabel.Parent = frame

    -- visibility toggle
    local vis = Instance.new("TextButton")
    vis.Size = UDim2.new(0, 36, 0, 28)
    vis.Position = UDim2.new(1, -46, 0, 8)
    vis.Text = "—"
    vis.Font = Enum.Font.GothamBold
    vis.TextSize = 20
    vis.BackgroundColor3 = Color3.fromRGB(100,0,0)
    vis.TextColor3 = Color3.new(1,1,1)
    vis.Parent = frame

    vis.MouseButton1Click:Connect(function()
        state.Visible = not state.Visible
        frame.Visible = state.Visible
        vis.Text = state.Visible and "—" or "≡"
    end)

    -- drag support (fixed version)
    local dragging = false
    local dragStart, startPos
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- keybind M to toggle
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.M then
            state.Visible = not state.Visible
            frame.Visible = state.Visible
            vis.Text = state.Visible and "—" or "≡"
        end
    end)
end

createMenu()

-- INIT: call hooks for state true by default (none are true by default)
for k,v in pairs(state) do
    if v and k ~= "Master" and type(hooks[k]) == "function" then
        pcall(function() hooks[k](true) end)
    end
end

print("RedMenuSafe loaded. Master switch added. Note: Anti-Ban features are disallowed and were NOT added.")
