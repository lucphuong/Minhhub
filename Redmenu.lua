-- RED MENU Blox Fruit HUBS (LOAD ONCE)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Menu Config
local menuVisible = true

-- HUBS Config
local hubs = {
    {Name="Hiru Hub", URL="https://raw.githubusercontent.com/kiddohiru/Source/main/BloxFruits.lua"},
    {Name="Xeter V3", URL="https://raw.githubusercontent.com/TlDinhKhoi/Xeter/refs/heads/main/Main.lua"},
    {Name="Soul Hub", URL="https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/soulhub"},
    {Name="Quantum Hub", URL="https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"},
    {Name="Txz Hub", URL="https://raw.githubusercontent.com/DrTxZ/Mercure-Hub/refs/heads/main/Mercure%20Hub.lua"},
    {Name="Omg Hub", URL="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"},

-- Create Menu
if PlayerGui:FindFirstChild("BloxFruitMenu") then
    PlayerGui.BloxFruitMenu:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BloxFruitMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 800, 0, 60)
frame.Position = UDim2.new(0.5, -400, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 2
frame.Parent = screenGui

-- Drag Support
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputChanged:Connect(function(input)
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
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Create Buttons Horizontally
local btnWidth = 120
local padding = 10
for i, hub in ipairs(hubs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, btnWidth, 0, 50)
    btn.Position = UDim2.new(0, padding + (btnWidth + padding)*(i-1), 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(50,100,200)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = hub.Name
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        if hub.URL and hub.URL ~= "" then
            local success, err = pcall(function()
                loadstring(game:HttpGet(hub.URL,true))()
            end)
            if not success then
                warn(hub.Name.." failed to load:", err)
            end
        else
            warn(hub.Name.." URL not set!")
        end
    end)
end

-- Toggle Menu Visibility (M Key)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.M then
        menuVisible = not menuVisible
        frame.Visible = menuVisible
    end
end)

print("Blox Fruit HUB Menu Loaded!")
