-- RED MENU Hubs BloxFruit (Update 27) - TO DÀI (OMG hub added)
-- Loads are wrapped in pcall to avoid crashing if remote fails.
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- state
local state = {AntiAFK=false}
local loaded = {}

-- safe load hub (pcall around HttpGet + loadstring)
local function safeLoad(key, url, preFunc)
    if loaded[key] then
        warn(("[RedMenu] %s was already loaded, skipping."):format(key))
        return
    end
    if not url or url == "" then
        warn(("[RedMenu] %s has no URL configured."):format(key))
        return
    end

    local ok, err = pcall(function()
        if preFunc then
            pcall(preFunc)
        end
        local resp = game:HttpGet(url, true)
        local fn, lerr = loadstring(resp)
        if not fn then error(lerr or "loadstring failed") end
        fn()
    end)
    if not ok then
        warn(("[RedMenu] %s load error: %s"):format(key, tostring(err)))
        return
    end
    loaded[key] = true
    print(("[RedMenu] %s loaded successfully."):format(key))
end

-- AntiAFK (safe)
local afkConn
local function toggleAntiAFK(enable)
    if enable then
        if afkConn then return end
        afkConn = LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end)
        print("[RedMenu] AntiAFK ENABLED")
    else
        if afkConn then
            pcall(function() afkConn:Disconnect() end)
            afkConn = nil
        end
        print("[RedMenu] AntiAFK DISABLED")
    end
end

-- ---------- UI ----------
if PlayerGui:FindFirstChild("RedMenuHubs") then
    PlayerGui.RedMenuHubs:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name="RedMenuHubs"
screenGui.ResetOnSpawn=false
screenGui.Parent=PlayerGui

local frame = Instance.new("Frame")
frame.Size=UDim2.new(0,950,0,60) -- dài hơn
frame.Position=UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3=Color3.fromRGB(145,20,20)
frame.BorderSizePixel=2
frame.Parent=screenGui

-- drag
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=frame.Position
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        dragInput=input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input==dragInput and dragging then
        local delta=input.Position - dragStart
        frame.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

-- hub buttons
local hubs={
    {name="Hiru Hub", url="https://raw.githubusercontent.com/kiddohiru/Source/main/BloxFruits.lua", pre=function() getgenv().Settings={JoinTeam=true,Team="Marines"} end},
    {name="Xeter V3", url="https://raw.githubusercontent.com/TlDinhKhoi/Xeter/refs/heads/main/Main.lua", pre=function() getgenv().Version="V3"; getgenv().Team="Marines" end},
    {name="Soul Hub", url="https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/soulhub"},
    {name="Quantum Hub", url="https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"},
    {name="Txz Hub", url="https://raw.githubusercontent.com/DrTxZ/Mercure-Hub/refs/heads/main/Mercure%20Hub.lua"},
    -- OMG hub added as requested:
    {name="OMG Hub", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"}
}

local xOffset=10
for i,hub in ipairs(hubs) do
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0,150,0,50) -- rộng hơn, dễ bấm
    btn.Position=UDim2.new(0,xOffset,0,5)
    btn.BackgroundColor3=Color3.fromRGB(20,140,20)
    btn.TextColor3=Color3.new(1,1,1)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=16
    btn.Text=hub.name
    btn.BorderSizePixel=1
    btn.Parent=frame

    btn.MouseButton1Click:Connect(function()
        safeLoad(hub.name, hub.url, hub.pre)
    end)

    xOffset=xOffset+155
end

-- AntiAFK button
local afkBtn=Instance.new("TextButton")
afkBtn.Size=UDim2.new(0,140,0,50)
afkBtn.Position=UDim2.new(0,xOffset,0,5)
afkBtn.BackgroundColor3=Color3.fromRGB(200,100,20)
afkBtn.TextColor3=Color3.new(1,1,1)
afkBtn.Font=Enum.Font.GothamBold
afkBtn.TextSize=16
afkBtn.Text="AntiAFK [OFF]"
afkBtn.BorderSizePixel=1
afkBtn.Parent=frame
afkBtn.MouseButton1Click:Connect(function()
    state.AntiAFK = not state.AntiAFK
    afkBtn.Text = "AntiAFK ["..(state.AntiAFK and "ON" or "OFF").."]"
    toggleAntiAFK(state.AntiAFK)
end)

-- small visibility toggle
local vis = Instance.new("TextButton")
vis.Size = UDim2.new(0,34,0,34)
vis.Position = UDim2.new(1,-44,0,12)
vis.Text = "—"
vis.Font = Enum.Font.GothamBold
vis.TextSize = 20
vis.BackgroundColor3 = Color3.fromRGB(100,0,0)
vis.TextColor3 = Color3.new(1,1,1)
vis.Parent = frame
vis.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    vis.Text = frame.Visible and "—" or "≡"
end)

print("RedMenu (long) with OMG added loaded. Click buttons to load hubs (each loads once).")
