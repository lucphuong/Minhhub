local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local SPEED_VALUE = 1500
local ATTACK_DELAY = 0.01
local HITBOX_SIZE = Vector3.new(50, 50, 50)
local function findRemote()
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
if v:IsA("RemoteEvent") then
return v
end
end
end
local attackRemote = findRemote()
local attackOn, speedOn, hitboxOn = false, false, false
local attackThread
local screenGui = Instance.new("ScreenGui", playerGui)
local function createBtn(name, pos)
local b = Instance.new("TextButton", screenGui)
b.Size = UDim2.new(0, 120, 0, 40)
b.Position = UDim2.new(0, 10, 0, pos)
b.Text = name
return b
end
local attackBtn = createBtn("Đánh nhanh", 10)
local speedBtn = createBtn("Chạy nhanh", 60)
local hitboxBtn = createBtn("Đánh xa", 110)
attackBtn.MouseButton1Click:Connect(function()
attackOn = not attackOn
attackBtn.Text = "Đánh nhanh: " .. (attackOn and "ON" or "OFF")
if attackOn then
attackThread = task.spawn(function()
while attackOn and attackRemote do
attackRemote:FireServer()
task.wait(ATTACK_DELAY)
end
end)
end
end)
speedBtn.MouseButton1Click:Connect(function()
speedOn = not speedOn
speedBtn.Text = "Chạy nhanh: " .. (speedOn and "ON" or "OFF")
player.Character.Humanoid.WalkSpeed = speedOn and SPEED_VALUE or 16
end)
hitboxBtn.MouseButton1Click:Connect(function()
hitboxOn = not hitboxOn
hitboxBtn.Text = "Đánh xa: " .. (hitboxOn and "ON" or "OFF")
for _, v in ipairs(workspace:GetDescendants()) do
if v:IsA("Part") and v.Name == "HumanoidRootPart" and v.Parent:FindFirstChild("Humanoid") then
v.Size = hitboxOn and HITBOX_SIZE or Vector3.new(2,2,1)
v.Transparency = hitboxOn and 0.7 or 1
v.CanCollide = false
end
end
end)
