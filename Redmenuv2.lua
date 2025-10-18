-- 🔴 RED MENU (SAFE) - Full version with fixed drag + InfJump
-- ⚙️ All external scripts are wrapped safely with pcall
-- 🧱 Menu can be dragged with mouse & touch (mobile supported)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ⚙️ CONFIG
local state = {
    InfJump = false,
    FlyV3 = false,
    Shader = false,
    TeleportGUI = false,
    Speed = false,
    AntiAFK = false
}

local handles = {}

local function tryCleanup(key)
    local h = handles[key]
    if not h then return end
    if typeof(h) == "RBXScriptConnection" then
        h:Disconnect()
    elseif typeof(h) == "Instance" and h.Destroy then
        h:Destroy()
    elseif type(h) == "function" then
        pcall(h)
    end
    handles[key] = nil
end

local function safeLoadFromUrl(key, url)
    if not url or url == "" then return end
    local ok, res = pcall(function()
        return game:HttpGet(url, true)
    end)
    if ok and res then
        local func = loadstring(res)
        if func then
            local ok2, ret = pcall(func)
            if ok2 then
                handles[key] = ret
                print("[✅] Loaded " .. key)
            else
                warn("[⚠️] Error running " .. key)
            end
        end
    else
        warn("[⚠️] Failed to get script:", key)
    end
end

-- 🦘 INF JUMP
local jumpConnection
local function toggleInfJump(enable)
    if enable then
        if jumpConnection then return end
        jumpConnection = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        handles.InfJump = jumpConnection
        print("✅ Infinite Jump Enabled")
    else
        tryCleanup("InfJump")
        print("❌ Infinite Jump Disabled")
    end
end

-- ✈️ FLY
local function toggleFly(enable)
    if enable then
        safeLoadFromUrl("FlyV3", "https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
    else
        tryCleanup("FlyV3")
        print("❌ Fly Disabled")
    end
end

-- 🎨 SHADER
local function toggleShader(enable)
    if enable then
        safeLoadFromUrl("Shader", "https://pastefy.app/xXkUxA0P/raw")
    else
        tryCleanup("Shader")
        print("❌ Shader Disabled")
    end
end

-- 🗺️ TELEPORT GUI
local function toggleTeleport(enable)
    if enable then
        safeLoadFromUrl("TeleportGUI", "https://raw.githubusercontent.com/lucphuong/Minhhub/main/TeleportGUI.lua")
    else
        tryCleanup("TeleportGUI")
        print("❌ Teleport Disabled")
    end
end

-- 🏃 SPEED
local function toggleSpeed(enable)
    if enable then
        safeLoadFromUrl("Speed", "https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer")
    else
        tryCleanup("Speed")
        print("❌ Speed Disabled")
    end
end

-- 💤 ANTI AFK
local antiAfkConnection
local function toggleAntiAfk(enable)
    if enable then
        if antiAfkConnection then return end
        antiAfkConnection = LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            print("[⚡] Anti-AFK Triggered")
        end)
        handles.AntiAFK = antiAfkConnection
        print("✅ Anti-AFK Enabled")
    else
        tryCleanup("AntiAFK")
        print("❌ Anti-AFK Disabled")
    end
end

-- 🧱 UI MENU
local function createMenu()
    if PlayerGui:FindFirstChild("RedMenuSafe") then
        PlayerGui.RedMenuSafe:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "RedMenuSafe"
    gui.ResetOnSpawn = false
    gui.Parent = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 270, 0, 400)
    frame.Position = UDim2.new(0.03, 0, 0.2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
    frame.Active = true
    frame.Draggable = false
    frame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundColor3 = Color3.fromRGB(170, 30, 30)
    title.Text = "🔴 RED MENU (SAFE)"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = frame

    -- ✅ Kéo thả menu (chuột + cảm ứng)
    local dragging, dragStart, startPos
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

    -- 🧩 Các nút chức năng
    local options = {
        {"InfJump", "Infinite Jump", toggleInfJump},
        {"FlyV3", "Fly", toggleFly},
        {"Shader", "Shader", toggleShader},
        {"TeleportGUI", "Teleport GUI", toggleTeleport},
        {"Speed", "Speed", toggleSpeed},
        {"AntiAFK", "Anti-AFK", toggleAntiAfk},
    }

    for i, info in ipairs(options) do
        local key, label, callback = unpack(info)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 45)
        btn.Position = UDim2.new(0, 10, 0, 50 + (i - 1) * 55)
        btn.BackgroundColor3 = state[key] and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(150, 20, 20)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 16
        btn.Text = label .. (state[key] and " [ON]" or " [OFF]")
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            state[key] = not state[key]
            btn.BackgroundColor3 = state[key] and Color3.fromRGB(30, 150, 30) or Color3.fromRGB(150, 20, 20)
            btn.Text = label .. (state[key] and " [ON]" or " [OFF]")
            pcall(callback, state[key])
        end)
    end
end

createMenu()

print("✅ Red Menu Safe Loaded (Drag Fixed + InfJump Working)")
