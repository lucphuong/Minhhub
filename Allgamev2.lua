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
    InfJump = false,
    FlyV3 = false,
    Shader = false,
    TeleportGUI = false,
    Speed = false,
    AntiAFK = false,
    AntiBan = false,
    Visible = true
}

local handles = {}

local function tryCleanup(key)
    local h = handles[key]
    if not h then return end
    local ok, err
    if type(h) == "function" then
        ok, err = pcall(h)
        if not ok then warn("Cleanup function for", key, "errored:", err) end
    elseif typeof(h) == "Instance" and h.Destroy then
        ok, err = pcall(function() h:Destroy() end)
        if not ok then warn("Destroy for", key, "errored:", err) end
    end
    handles[key] = nil
end

local function safeLoadFromUrl(key, url)
    if not url or url == "" then
        warn("safeLoadFromUrl: missing url for", key); return
    end
    local ok, res = pcall(function()
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
    handles[key] = ret
    print(("Loaded and executed external script for %s"):format(key))
end

local hooks = {}

-- INFJUMP
do
    local conn
    hooks.InfJump = function(enable)
        if enable then
            if conn then return end
            local InfiniteJumpEnabled = true
            conn = game:GetService("UserInputService").JumpRequest:Connect(function()
                if InfiniteJumpEnabled then
                    local plr = game:GetService("Players").LocalPlayer
                    local char = plr and plr.Character
                    if char then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            pcall(function() humanoid:ChangeState("Jumping") end)
                        end
                    end
                end
            end)
            handles.InfJump = function() if conn then conn:Disconnect(); conn = nil end end
            print("InfJump ENABLED")
        else
            tryCleanup("InfJump")
            print("InfJump DISABLED")
        end
    end
end

-- FLY
hooks.FlyV3 = function(enable)
    if enable then
        safeLoadFromUrl("FlyV3", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
    else
        tryCleanup("FlyV3")
        print("FlyV3 DISABLED")
    end
end

-- SHADER
hooks.Shader = function(enable)
    if enable then
        safeLoadFromUrl("Shader", "https://pastefy.app/xXkUxA0P/raw")
    else
        tryCleanup("Shader")
        print("Shader DISABLED")
    end
end

-- TELEPORT GUI
hooks.TeleportGUI = function(enable)
    if enable then
        safeLoadFromUrl("TeleportGUI", "https://raw.githubusercontent.com/lucphuong/Minhhub/main/TeleportGUI.lua")
    else
        tryCleanup("TeleportGUI")
        print("Teleport GUI DISABLED")
    end
end

-- SPEED
hooks.Speed = function(enable)
    if enable then
        safeLoadFromUrl("Speed", "https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer")
    else
        tryCleanup("Speed")
        print("Speed DISABLED")
    end
end

-- ANTI AFK
hooks.AntiAFK = function(enable)
    if enable then
        if handles._antiAfkConn then return end
        local conn = Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
            warn("Anti-AFK triggered")
        end)
        handles._antiAfkConn = conn
    else
        tryCleanup("_antiAfkConn")
        print("AntiAFK DISABLED")
    end
end

hooks.AntiBan = function(enable)
    warn("Anti-Ban disabled.")
end

-- UI
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
        {key="Speed", label="Speed"},
        {key="AntiAFK", label="Anti-AFK"},
        {key="AntiBan", label="Anti-Ban"},
    }

    for i, info in ipairs(items) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-20,0,44)
        btn.Position = UDim2.new(0,10,0,54+(i-1)*50)
        btn.BackgroundColor3 = state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Text = info.label .. (state[info.key] and " [ON]" or " [OFF]")
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            if info.key == "AntiBan" then
                warn("Anti-Ban not allowed")
                return
            end
            state[info.key] = not state[info.key]
            btn.BackgroundColor3 = state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
            btn.Text = info.label .. (state[info.key] and " [ON]" or " [OFF]")
            pcall(function() hooks[info.key](state[info.key]) end)
        end)
    end

    -- ✅ Drag support fixed (mouse + touch)
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
end

createMenu()

print("✅ RedMenuSafe loaded (drag fixed, safe version).")
