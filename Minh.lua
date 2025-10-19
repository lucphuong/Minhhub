-- RED HUB (Fixed UI Issue)
pcall(function()
    if not game:IsLoaded() then game.Loaded:Wait() end

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local VirtualUser = game:GetService("VirtualUser")
    local LocalPlayer = Players.LocalPlayer

    -- Clean previous
    pcall(function()
        if game.CoreGui:FindFirstChild("RedHub_Toggle") then 
            game.CoreGui.RedHub_Toggle:Destroy() 
        end
    end)

    -- Handles and cleanup system
    local handles = {}
    local function tryCleanup(key)
        local h = handles[key]
        if not h then return end
        if type(h) == "function" then
            pcall(h)
        elseif typeof(h) == "Instance" and h.Destroy then
            pcall(function() h:Destroy() end)
        end
        handles[key] = nil
    end

    local function safeLoadFromUrl(key, url)
        if not url or url == "" then return end
        local ok, res = pcall(function() return game:HttpGet(url, true) end)
        if not ok then return end
        local ok2, ret = pcall(function()
            local f = loadstring(res)
            if f then return f() end
        end)
        if ok2 then
            handles[key] = ret
        end
    end

    -- Hooks functions (giữ nguyên)
    local hooks = {}

    -- FLY V3
    hooks.FlyV3 = function(enable)
        if enable then
            if handles.FlyV3 then return end
            
            local player = game.Players.LocalPlayer
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            
            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
            bodyGyro.P = 1000
            
            local flyConnection
            local flySpeed = 50
            
            local function startFlying()
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                local humanoidRootPart = character.HumanoidRootPart
                bodyVelocity.Parent = humanoidRootPart
                bodyGyro.Parent = humanoidRootPart
                
                flyConnection = RunService.Heartbeat:Connect(function()
                    if not character or not humanoidRootPart then return end
                    
                    local camera = workspace.CurrentCamera
                    bodyGyro.CFrame = camera.CFrame
                    
                    local velocity = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        velocity = velocity + camera.CFrame.LookVector * flySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        velocity = velocity - camera.CFrame.LookVector * flySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        velocity = velocity - camera.CFrame.RightVector * flySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        velocity = velocity + camera.CFrame.RightVector * flySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        velocity = velocity + Vector3.new(0, flySpeed, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                        velocity = velocity - Vector3.new(0, flySpeed, 0)
                    end
                    
                    bodyVelocity.Velocity = velocity
                end)
            end
            
            startFlying()
            
            handles.FlyV3 = function()
                if flyConnection then flyConnection:Disconnect() end
                bodyVelocity:Destroy()
                bodyGyro:Destroy()
            end
            
        else
            tryCleanup("FlyV3")
        end
    end

    -- INFINITE JUMP
    hooks.InfJump = function(enable)
        if enable then
            if handles.InfJump then return end
            local conn = UserInputService.JumpRequest:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:ChangeState("Jumping") end) end
                end
            end)
            handles.InfJump = function() 
                if conn then 
                    conn:Disconnect() 
                    conn = nil 
                end 
            end
        else
            tryCleanup("InfJump")
        end
    end

    -- SPEED
    hooks.Speed = function(enable)
        if enable then
            if handles.Speed then return end
            local conn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local cam = workspace.CurrentCamera
                    local moveDir = Vector3.new(0, 0, 0)
                    local speed = 30
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDir = moveDir + cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDir = moveDir - cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDir = moveDir - cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDir = moveDir + cam.CFrame.RightVector
                    end
                    
                    moveDir = moveDir.Unit
                    hrp.Velocity = Vector3.new(moveDir.X * speed, hrp.Velocity.Y, moveDir.Z * speed)
                end
            end)
            handles.Speed = function() 
                if conn then 
                    conn:Disconnect() 
                    conn = nil 
                end 
            end
        else
            tryCleanup("Speed")
        end
    end

    -- NOCLIP
    hooks.Noclip = function(enable)
        if enable then
            if handles.Noclip then return end
            local conn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            pcall(function() part.CanCollide = false end)
                        end
                    end
                end
            end)
            handles.Noclip = function() 
                if conn then 
                    conn:Disconnect() 
                    conn = nil 
                end 
            end
        else
            tryCleanup("Noclip")
        end
    end

    -- WALL WALK
    hooks.WallWalk = function(enable)
        if enable then
            safeLoadFromUrl("WallWalk", "https://pastebin.com/raw/5T7KsEWy")
        else
            tryCleanup("WallWalk")
        end
    end

    -- BAT TU (IMMORTAL)
    hooks.BatTu = function(enable)
        if enable then 
            workspace.FallenPartsDestroyHeight = 9e9
        else 
            workspace.FallenPartsDestroyHeight = -500 
        end
    end

    -- TAN HINH (INVISIBLE)
    hooks.TanHinh = function(enable)
        if enable then
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then
                        pcall(function() part.Transparency = 1 end)
                    end
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.Transparency = 0 end)
                    elseif part:IsA("Decal") then
                        pcall(function() part.Transparency = 0 end)
                    end
                end
            end
        end
    end

    -- ANTI-AFK
    hooks.AntiAFK = function(enable)
        if enable then
            if handles.AntiAFK then return end
            local conn = LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            handles.AntiAFK = function() 
                if conn then 
                    conn:Disconnect() 
                    conn = nil 
                end 
            end
        else
            tryCleanup("AntiAFK")
        end
    end

    -- LOW LAG
    hooks.LowLag = function(enable)
        if enable then
            safeLoadFromUrl("LowLag", "https://pastebin.com/raw/KiSYpej6")
        else
            tryCleanup("LowLag")
        end
    end

    -- ESP
    hooks.ESP = function(enable)
        if enable then
            if handles.ESP then return end
            local folder = Instance.new("Folder")
            folder.Name = "ESP_HOLDER"
            if syn and syn.protect_gui then
                syn.protect_gui(folder)
            end
            folder.Parent = game.CoreGui
            
            local function applyESP(player)
                if player == LocalPlayer then return end
                
                local function addHighlight(char)
                    if char and not char:FindFirstChild("RedHub_Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "RedHub_Highlight"
                        highlight.Adornee = char
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = folder
                    end
                end
                
                if player.Character then
                    addHighlight(player.Character)
                end
                
                player.CharacterAdded:Connect(function(char)
                    addHighlight(char)
                end)
            end
            
            for _, player in pairs(Players:GetPlayers()) do
                applyESP(player)
            end
            
            Players.PlayerAdded:Connect(applyESP)
            
            handles.ESP = function()
                folder:Destroy()
            end
        else
            tryCleanup("ESP")
        end
    end

    -- TELEPORT GUI
    hooks.TeleportGUI = function(enable)
        if enable then
            safeLoadFromUrl("TeleportGUI", "https://cdn.wearedevs.net/scripts/Click%20Teleport.txt")
        else
            tryCleanup("TeleportGUI")
        end
    end

    -- KILL AURA
    hooks.KillAura = function(enable)
        if enable then
            if handles.KillAura then return end
            local conn = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                        if targetHrp and targetHum and (targetHrp.Position - hrp.Position).Magnitude <= 10 then
                            pcall(function() targetHum:TakeDamage(25) end)
                        end
                    end
                end
            end)
            handles.KillAura = function() 
                if conn then 
                    conn:Disconnect() 
                    conn = nil 
                end 
            end
        else
            tryCleanup("KillAura")
        end
    end

    -- SWORD
    hooks.Sword = function(enable)
        if enable then
            if handles.Sword then return end
            local tool = Instance.new("Tool")
            tool.Name = "RedHub_Sword"
            tool.RequiresHandle = false
            local damage = 35
            
            tool.Activated:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                        local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                        if targetHrp and targetHum and (targetHrp.Position - hrp.Position).Magnitude <= 8 then
                            pcall(function() targetHum:TakeDamage(damage) end)
                        end
                    end
                end
            end)
            
            tool.Parent = LocalPlayer.Backpack
            handles.Sword = function() tool:Destroy() end
        else
            tryCleanup("Sword")
        end
    end

    -- GUN
    hooks.Gun = function(enable)
        if enable then
            safeLoadFromUrl("Gun", "https://pastebin.com/raw/0hn40Zbc")
        else
            tryCleanup("Gun")
        end
    end

    -- FIGHTING
    hooks.Fighting = function(enable)
        if enable then
            safeLoadFromUrl("Fighting", "https://pastefy.app/cAQICuXo/raw")
        else
            tryCleanup("Fighting")
        end
    end

    -- FE FLIP
    hooks.FeFlip = function(enable)
        if enable then
            safeLoadFromUrl("FeFlip", "https://pastebin.com/raw/KiSYpej6")
        else
            tryCleanup("FeFlip")
        end
    end

    -- SHADER
    hooks.Shader = function(enable)
        if enable then
            safeLoadFromUrl("Shader", "https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua")
        else
            tryCleanup("Shader")
        end
    end

    -- BE A CAR
    hooks.BeACar = function(enable)
        if enable then
            safeLoadFromUrl("BeACar", "https://raw.githubusercontent.com/gumanba/Scripts/main/BeaCar")
        else
            tryCleanup("BeACar")
        end
    end

    -- BANG
    hooks.Bang = function(enable)
        if enable then
            safeLoadFromUrl("Bang", "https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua")
        else
            tryCleanup("Bang")
        end
    end

    -- JERK OFF
    hooks.JerkOff = function(enable)
        if enable then
            safeLoadFromUrl("JerkOff", "https://pastefy.app/lawnvcTT/raw")
        else
            tryCleanup("JerkOff")
        end
    end

    -- TELEPORT TO MOUSE
    hooks.TeleportToMouse = function()
        pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and mouse and mouse.Hit then
                char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
            end
        end)
    end

    -- Load Rayfield với nhiều nguồn dự phòng
    local Rayfield = nil
    pcall(function()
        -- Thử các nguồn Rayfield khác nhau
        local rayfieldSources = {
            "https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua",
            "https://sirius.menu/rayfield",
            "https://raw.githubusercontent.com/dawid-scripts/UI-Libraries/main/Rayfield.lua",
            "https://api.irisapp.ca/Libraries/Rayfield.lua"
        }
        
        for _, source in ipairs(rayfieldSources) do
            local success, result = pcall(function()
                local response = game:HttpGet(source)
                return loadstring(response)()
            end)
            
            if success and result then
                Rayfield = result
                break
            end
        end
    end)

    if not Rayfield then
        -- Fallback: Simple UI nếu Rayfield không load được
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "RedHub_SimpleUI"
        screenGui.Parent = game.CoreGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 400)
        frame.Position = UDim2.new(0.5, -150, 0.5, -200)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.Parent = screenGui
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Text = "🔴 RED HUB (Simple UI)"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.Parent = frame
        
        warn("Rayfield không load được, sử dụng Simple UI")
        return
    end

    -- Tạo Window với tabs mới
    local Window = Rayfield:CreateWindow({
        Name = "🔴 RED HUB | Premium",
        LoadingTitle = "Red Hub đang tải...",
        LoadingSubtitle = "By You",
        ConfigurationSaving = { Enabled = false },
        Discord = { Enabled = false },
        KeySystem = false
    })

    -- TABS MỚI
    local PlayerTab = Window:CreateTab("👤 Người Chơi")
    local ServerTab = Window:CreateTab("🌐 Server")
    local CombatTab = Window:CreateTab("⚔️ Chiến Đấu")
    local VisualTab = Window:CreateTab("👁️ Đồ Họa")
    local FunTab = Window:CreateTab("🎉 Vui Vẻ")

    -- State management
    local States = {}

    -- TAB NGƯỜI CHƠI
    local MovementSection = PlayerTab:CreateSection("Di Chuyển")
    
    MovementSection:CreateToggle({
        Name = "🏃‍♂️ Tốc Độ",
        CurrentValue = false,
        Callback = function(Value)
            States.Speed = Value
            hooks.Speed(Value)
        end,
    })

    MovementSection:CreateToggle({
        Name = "🪽 Bay V3", 
        CurrentValue = false,
        Callback = function(Value)
            States.FlyV3 = Value
            hooks.FlyV3(Value)
        end,
    })

    MovementSection:CreateToggle({
        Name = "🎯 Infinite Jump",
        CurrentValue = false,
        Callback = function(Value)
            States.InfJump = Value
            hooks.InfJump(Value)
        end,
    })

    MovementSection:CreateToggle({
        Name = "👻 NoClip",
        CurrentValue = false,
        Callback = function(Value)
            States.Noclip = Value
            hooks.Noclip(Value)
        end,
    })

    MovementSection:CreateToggle({
        Name = "🕷️ Đi Trên Tường",
        CurrentValue = false,
        Callback = function(Value)
            States.WallWalk = Value
            hooks.WallWalk(Value)
        end,
    })

    local ImmortalSection = PlayerTab:CreateSection("Bất Tử & Ẩn Thân")

    ImmortalSection:CreateToggle({
        Name = "💀 Bất Tử",
        CurrentValue = false,
        Callback = function(Value)
            States.BatTu = Value
            hooks.BatTu(Value)
        end,
    })

    ImmortalSection:CreateToggle({
        Name = "🔮 Tàng Hình", 
        CurrentValue = false,
        Callback = function(Value)
            States.TanHinh = Value
            hooks.TanHinh(Value)
        end,
    })

    local UtilitySection = PlayerTab:CreateSection("Tiện Ích")

    UtilitySection:CreateToggle({
        Name = "🛡️ Anti-AFK",
        CurrentValue = false,
        Callback = function(Value)
            States.AntiAFK = Value
            hooks.AntiAFK(Value)
        end,
    })

    UtilitySection:CreateToggle({
        Name = "⚡ Giảm Lag",
        CurrentValue = false,
        Callback = function(Value)
            States.LowLag = Value
            hooks.LowLag(Value)
        end,
    })

    -- TAB SERVER
    local ESPsection = ServerTab:CreateSection("ESP & Highlight")

    ESPsection:CreateToggle({
        Name = "👁️ ESP Người Chơi",
        CurrentValue = false,
        Callback = function(Value)
            States.ESP = Value
            hooks.ESP(Value)
        end,
    })

    local TeleportSection = ServerTab:CreateSection("Teleport")

    TeleportSection:CreateButton({
        Name = "📦 Teleport GUI",
        Callback = function()
            hooks.TeleportGUI(true)
            Rayfield:Notify({
                Title = "Teleport GUI",
                Content = "Đã tải Teleport GUI!",
                Duration = 3,
            })
        end,
    })

    TeleportSection:CreateButton({
        Name = "📍 Teleport To Mouse",
        Callback = function()
            hooks.TeleportToMouse()
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Đã teleport đến vị trí chuột!",
                Duration = 2,
            })
        end,
    })

    -- TAB CHIẾN ĐẤU
    local CombatSection = CombatTab:CreateSection("Chiến Đấu Cơ Bản")

    CombatSection:CreateToggle({
        Name = "⚡ Kill Aura",
        CurrentValue = false,
        Callback = function(Value)
            States.KillAura = Value
            hooks.KillAura(Value)
        end,
    })

    CombatSection:CreateToggle({
        Name = "🗡️ Sword (Local)",
        CurrentValue = false,
        Callback = function(Value)
            States.Sword = Value
            hooks.Sword(Value)
        end,
    })

    CombatSection:CreateButton({
        Name = "🔫 Tải Gun Script",
        Callback = function()
            hooks.Gun(true)
            Rayfield:Notify({
                Title = "Gun Script",
                Content = "Đã tải gun script thành công!",
                Duration = 3,
            })
        end,
    })

    CombatSection:CreateButton({
        Name = "🥊 Tải Fighting Script",
        Callback = function()
            hooks.Fighting(true)
            Rayfield:Notify({
                Title = "Fighting Script",
                Content = "Đã tải fighting script!",
                Duration = 3,
            })
        end,
    })

    CombatSection:CreateToggle({
        Name = "🤸 Lăn (FeFlip)",
        CurrentValue = false,
        Callback = function(Value)
            States.FeFlip = Value
            hooks.FeFlip(Value)
        end,
    })

    -- TAB ĐỒ HỌA
    local VisualSection = VisualTab:CreateSection("Hiệu Ứng Đồ Họa")

    VisualSection:CreateToggle({
        Name = "🎨 Shader Effects",
        CurrentValue = false,
        Callback = function(Value)
            States.Shader = Value
            hooks.Shader(Value)
        end,
    })

    -- TAB VUI VẺ
    local FunSection = FunTab:CreateSection("Tính Năng Vui")

    FunSection:CreateToggle({
        Name = "🚗 Biến Thành Xe",
        CurrentValue = false,
        Callback = function(Value)
            States.BeACar = Value
            hooks.BeACar(Value)
        end,
    })

    FunSection:CreateToggle({
        Name = "💥 Bang Script",
        CurrentValue = false,
        Callback = function(Value)
            States.Bang = Value
            hooks.Bang(Value)
        end,
    })

    FunSection:CreateToggle({
        Name = "🍆 Jerk Off",
        CurrentValue = false,
        Callback = function(Value)
            States.JerkOff = Value
            hooks.JerkOff(Value)
        end,
    })

    -- Notify khi load xong
    Rayfield:Notify({
        Title = "Red Hub",
        Content = "Menu đã tải thành công!",
        Duration = 6,
    })

    print("✅ Red Hub loaded thành công!")
end)
