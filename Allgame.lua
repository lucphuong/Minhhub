-- RED MENU (SAFE) with user-provided scripts integrated
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
    InfJump = true,
    FlyV3 = true,
    Shader = true,
    TeleportGUI = true,
    Speed = true,
    AntiAFK = true,
    AntiBan = false, -- placeholder (WILL NOT RUN)
    Visible = true
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
    elseif typeof(h) == "Instance" and h.Destroy then
        ok, err = pcall(function() h:Destroy() end)
        if not ok then warn("Destroy for", key, "errored:", err) end
    else
        -- unknown handle type
        print(("No standard cleanup available for %s (type: %s)"):format(key, type(h)))
    end
    handles[key] = nil
end

-- helper: safely load external URL and execute, storing returned handle
local function safeLoadFromUrl(key, url)
    if not url or url == "" then
        warn("safeLoadFromUrl: missing url for", key); return
    end
    local ok, res = pcall(function()
        -- second arg for HttpGet (true) sometimes required on some executors
        return game:HttpGet(url, true)
    end)
    if not ok then
        warn("HttpGet failed for", key, url, res)
        return
    end
    local ok2, ret = pcall(function()
        local f, errmsg = loadstring(res)
        if not f then error(("loadstring error: %s"):format(tostring(errmsg))) end
        return f()
    end)
    if not ok2 then
        warn("Execution error for", key, ret)
        return
    end
    -- store returned handle (could be nil, an Instance, or a cleanup function)
    handles[key] = ret
    print(("Loaded and executed external script for %s"):format(key))
end

-- HOOKS: integrate your provided scripts here
local hooks = {}

-- INFJUMP (user-provided)
do
    local conn
    hooks.InfJump = function(enable)
        if enable then
            if conn then return end
            -- provided Inf jump code:
            local InfiniteJumpEnabled = true
            conn = game:GetService("UserInputService").JumpRequest:Connect(function()
                if InfiniteJumpEnabled then
                    local plr = game:GetService("Players").LocalPlayer
                    local char = plr and plr.Character
                    if char then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            pcall(function()
                                humanoid:ChangeState("Jumping")
                            end)
                        end
                    end
                end
            end)
            handles.InfJump = function()
                -- cleanup: disconnect event
                if conn then
                    conn:Disconnect()
                    conn = nil
                end
            end
            print("InfJump ENABLED (user script)")
        else
            -- disable
            tryCleanup("InfJump")
            print("InfJump DISABLED")
        end
    end
end

-- FLY V3 (user provided external loadstring)
hooks.FlyV3 = function(enable)
    if enable then
        -- try to load and execute the remote FlyGuiV3 script
        safeLoadFromUrl("FlyV3", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
        if not handles.FlyV3 then
            print("FlyV3: executed but no cleanup handle returned (expected for many gui scripts).")
        end
    else
        -- attempt cleanup if script returned something
        tryCleanup("FlyV3")
        print("FlyV3 DISABLED (cleanup attempted; some fly scripts cannot be fully removed programmatically)")
    end
end

-- SHADER (user provided external)
hooks.Shader = function(enable)
    if enable then
        safeLoadFromUrl("Shader", "https://pastefy.app/xXkUxA0P/raw")
        if not handles.Shader then
            print("Shader: executed (no cleanup handle).")
        end
    else
        tryCleanup("Shader")
        print("Shader DISABLED (cleanup attempted)")
    end
end

-- TELEPORT GUI (user-provided inline code) - integrated and parented to PlayerGui
do
    local tpGuiInstance
    hooks.TeleportGUI = function(enable)
        if enable then
            if tpGuiInstance and tpGuiInstance.Parent then return end
            -- Create Teleport GUI (adapted to parent to PlayerGui)
            local Players = game:GetService("Players")
            local UserInputService = game:GetService("UserInputService")
            local LocalPlayer = Players.LocalPlayer
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
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local PlayerButton = Instance.new("TextButton")
                        PlayerButton.Size = UDim2.new(1, 0, 0, 25)
                        PlayerButton.Text = player.Name
                        PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        PlayerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        PlayerButton.Font = Enum.Font.Gotham
                        PlayerButton.TextSize = 12
                        PlayerButton.Parent = ScrollingFrame

                        PlayerButton.MouseButton1Click:Connect(function()
                            teleportTarget = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            TPButton.Text = "Teleport to: " .. player.Name
                        end)
                    end
                end
            end

            TPButton.MouseButton1Click:Connect(function()
                if teleportTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = teleportTarget.CFrame + Vector3.new(0, 3, 0)
                    end)
                end
            end)

            local addedConn = Players.PlayerAdded:Connect(updatePlayerList)
            local remConn = Players.PlayerRemoving:Connect(updatePlayerList)
            updatePlayerList()

            -- dragging support
            local dragging, dragInput, dragStart, startPos
            Title.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = Frame.Position
                end
            end)
            Title.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    dragInput = input
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - dragStart
                    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            Title.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            -- store cleanup handle
            handles.TeleportGUI = function()
                pcall(function()
                    addedConn:Disconnect()
                    remConn:Disconnect()
                end)
                pcall(function()
                    if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
                end)
            end

            tpGuiInstance = ScreenGui
            print("Teleport GUI ENABLED")
        else
            tryCleanup("TeleportGUI")
            print("Teleport GUI DISABLED")
        end
    end
end

-- SPEED (user-provided external)
hooks.Speed = function(enable)
    if enable then
        -- try to load external speed changer
        safeLoadFromUrl("Speed", "https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer")
        if not handles.Speed then
            print("Speed: executed (no cleanup handle returned).")
        end
    else
        tryCleanup("Speed")
        print("Speed DISABLED (cleanup attempted)")
    end
end

-- ANTI-AFK (user-provided external) - but we already have a safe VirtualUser demo earlier;
-- here we prefer the user-sent loadstring, wrapped safely.
hooks.AntiAFK = function(enable)
    if enable then
        -- Try user-provided anti-afk remote
        safeLoadFromUrl("AntiAFK_remote", "https://raw.githubusercontent.com/evxncodes/mainroblox/main/anti-afk")
        -- Also keep the local VirtualUser fallback (if remote didn't return a cleanup handle)
        if not handles.AntiAFK_remote then
            -- local VirtualUser-based demo (we keep as fallback and provide cleanup)
            if handles._localAntiAfkConn then return end
            local conn = Players.LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
                pcall(function()
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Jump = true
                        wait(0.1)
                        humanoid.Jump = false
                    end
                end)
                warn("Anti-AFK (virtual) simulated input.")
            end)
            handles._localAntiAfkConn = conn
            handles.AntiAFK_cleanup = function()
                if handles._localAntiAfkConn then
                    pcall(function() handles._localAntiAfkConn:Disconnect() end)
                    handles._localAntiAfkConn = nil
                end
            end
        end
        print("AntiAFK ENABLED")
    else
        -- cleanup remote + local fallback
        tryCleanup("AntiAFK_remote")
        tryCleanup("AntiAFK_cleanup")
        print("AntiAFK DISABLED")
    end
end

-- ANTI-BAN placeholder: REFUSE to run user-provided anti-ban
hooks.AntiBan = function(enable)
    if enable then
        warn("Anti-Ban functionality is disallowed in this menu. Operation blocked.")
    else
        print("AntiBan remains disabled.")
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
    frame.Size = UDim2.new(0, 280, 0, 420)
    frame.Position = UDim2.new(0.02,0,0.12,0)
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

    local items = {
        {key="InfJump", label="Infinite Jump"},
        {key="FlyV3", label="Fly V3"},
        {key="Shader", label="Shader"},
        {key="TeleportGUI", label="Teleport GUI"},
        {key="Speed", label="Speed Changer"},
        {key="AntiAFK", label="Anti-AFK (SAFE)"},
        {key="AntiBan", label="Anti-Ban (DISALLOWED)"},
    }

    local uiButtons = {}

    for i, info in ipairs(items) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 44)
        btn.Position = UDim2.new(0, 10, 0, 54 + (i-1)*50)
        btn.BackgroundColor3 = state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Text = info.label .. (state[info.key] and " [ON]" or " [OFF]")
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            if info.key == "AntiBan" then
                warn("Anti-Ban functionality is not permitted. Operation blocked.")
                return
            end

            state[info.key] = not state[info.key]
            btn.BackgroundColor3 = state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
            btn.Text = info.label .. (state[info.key] and " [ON]" or " [OFF]")

            pcall(function()
                if type(hooks[info.key]) == "function" then
                    hooks[info.key](state[info.key])
                end
            end)
        end)

        uiButtons[info.key] = btn
    end

    -- info label
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 64)
    infoLabel.Position = UDim2.new(0, 10, 0, 54 + #items*50)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.new(1,1,1)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 14
    infoLabel.Text = "Note: External scripts loaded via HTTP are executed in pcall. Anti-Ban is disabled. Cleanup may be incomplete for some scripts."
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

    -- drag support
    local dragging, dragInput, dragStart, startPos
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    title.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

-- INIT: call any hooks that are true by default (none by default)
for k,v in pairs(state) do
    if v and type(hooks[k]) == "function" then
        pcall(function() hooks[k](true) end)
    end
end

print("RedMenuSafe loaded with user scripts integrated. Anti-Ban features are disallowed and were NOT added.")
