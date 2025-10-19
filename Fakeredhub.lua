-- RED HUB (Full-safe) - giữ nguyên hooks + links, Rayfield if available, fallback UI
-- Bọc pcall, hỗ trợ syn/fluxus/gethui/is_sirhurt_closure, protect gui
pcall(function()
    -- wait until game loaded
    if not game:IsLoaded() then game.Loaded:Wait() end

    -- Services
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local VirtualUser = game:GetService("VirtualUser")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    -- Clean previous
    pcall(function()
        if PlayerGui:FindFirstChild("RedHub_Toggle") then PlayerGui.RedHub_Toggle:Destroy() end
        if PlayerGui:FindFirstChild("RedHub_UI") then PlayerGui.RedHub_UI:Destroy() end
        if game.CoreGui:FindFirstChild("RedHub_Toggle") then game.CoreGui.RedHub_Toggle:Destroy() end
        if game.CoreGui:FindFirstChild("RedHub_UI") then game.CoreGui.RedHub_UI:Destroy() end
    end)

    -- Executor-safe GUI protector
    local function protectGui(gui)
        pcall(function()
            if syn and syn.protect_gui then
                pcall(syn.protect_gui, gui)
                if not gui.Parent then gui.Parent = game.CoreGui end
                return
            end
            if gethui then
                local ok, parent = pcall(gethui)
                if ok and parent then
                    gui.Parent = parent
                    return
                end
            end
            -- Fluxus-like
            if (type(get_hidden_gui) == "function") then
                local ok, parent = pcall(get_hidden_gui)
                if ok and parent then
                    gui.Parent = parent
                    return
                end
            end
            -- SirHurt / older
            if (type(is_sirhurt_closure) == "function") then
                gui.Parent = game.CoreGui
                return
            end
            -- default
            gui.Parent = PlayerGui or game.CoreGui
        end)
    end

    -- Handles and cleanup helpers
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
        if not url or url == "" then warn("safeLoadFromUrl missing url for "..tostring(key)); return end
        local ok, res = pcall(function() return game:HttpGet(url, true) end)
        if not ok then
            warn(("HttpGet failed for %s : %s"):format(key, tostring(res)))
            return
        end
        local ok2, ret = pcall(function()
            local f, err = loadstring(res)
            if not f then error(err) end
            return f()
        end)
        if not ok2 then
            warn(("Execution failed for %s : %s"):format(key, tostring(ret)))
            return
        end
        handles[key] = ret
        print(("Loaded %s (handle: %s)"):format(key, tostring(ret)))
    end

    -- Hooks table (fixed - no duplicates)
    local hooks = {}

    -- INFJUMP
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
            handles.InfJump = function() if conn then conn:Disconnect(); conn=nil end end
        else
            tryCleanup("InfJump")
        end
    end

    -- SPEED
    hooks.Speed = function(enable)
        if enable then
            safeLoadFromUrl("Speed", "https://raw.githubusercontent.com/MrScripterrFr/Speed-Changer/main/Speed%20Changer")
        else
            tryCleanup("Speed")
        end
    end

    -- BAT TU (immortal) - FIXED: safer math
    hooks.BatTu = function(enable)
        if enable then 
            workspace.FallenPartsDestroyHeight = 9e9  -- Thay vì 0/0
        else 
            workspace.FallenPartsDestroyHeight = -500 
        end
    end

    -- NOCOLIP
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
            handles.Noclip = function() if conn then conn:Disconnect() end end
        else
            tryCleanup("Noclip")
        end
    end

    -- ESP
    hooks.ESP = function(enable)
        if enable then
            if handles.ESP then return end
            local folder = Instance.new("Folder")
            folder.Name = "ESP_HOLDER"
            protectGui(folder)
            handles.ESP = folder
            local function apply(p)
                if p == LocalPlayer then return end
                p.CharacterAdded:Connect(function()
                    pcall(function()
                        if p.Character and not p.Character:FindFirstChild("HighlightFromRedMenu") then
                            local h = Instance.new("Highlight")
                            h.Name = "HighlightFromRedMenu"
                            h.Adornee = p.Character
                            h.FillTransparency = 0.5
                            h.FillColor = (p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) and Color3.fromRGB(0,0,255) or Color3.fromRGB(255,0,0)
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Parent = folder
                        end
                    end)
                end)
                if p.Character and not p.Character:FindFirstChild("HighlightFromRedMenu") then
                    local h = Instance.new("Highlight")
                    h.Name = "HighlightFromRedMenu"
                    h.Adornee = p.Character
                    h.FillTransparency = 0.5
                    h.FillColor = (p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) and Color3.fromRGB(0,0,255) or Color3.fromRGB(255,0,0)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Parent = folder
                end
            end
            for _,p in pairs(Players:GetPlayers()) do pcall(apply,p) end
            Players.PlayerAdded:Connect(function(p) pcall(apply,p) end)
        else
            tryCleanup("ESP")
        end
    end

    -- ANTI-AFK - NEW: Added missing implementation
    hooks.AntiAFK = function(enable)
        if enable then
            if handles.AntiAFK then return end
            local conn
            conn = Players.LocalPlayer.Idled:Connect(function()
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

    -- FLY V3 - NEW: Added missing implementation
    hooks.FlyV3 = function(enable)
        if enable then
            safeLoadFromUrl("FlyV3", "https://raw.githubusercontent.com/XNEOFF/FlyScriptV3/main/FlyScriptV3.txt")
        else
            tryCleanup("FlyV3")
        end
    end

    -- TanHinh (invisibility)
    hooks.TanHinh = function(enable)
        if enable then
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.Transparency = 1 end)
                    elseif part:IsA("Decal") then
                        pcall(function() part.Transparency = 1 end)
                    end
                end
            end
            handles.TanHinh = function()
                -- not restoring transparencies to avoid accidental break
            end
        else
            tryCleanup("TanHinh")
        end
    end

    -- WallWalk
    hooks.WallWalk = function(enable)
        if enable then safeLoadFromUrl("WallWalk","https://pastebin.com/raw/5T7KsEWy") else tryCleanup("WallWalk") end
    end

    -- LowLag
    hooks.LowLag = function(enable)
        if enable then safeLoadFromUrl("LowLag","https://pastebin.com/raw/KiSYpej6") else tryCleanup("LowLag") end
    end

    -- FeFlip
    hooks.FeFlip = function(enable)
        if enable then safeLoadFromUrl("FeFlip","https://pastebin.com/raw/KiSYpej6") else tryCleanup("FeFlip") end
    end

    -- BeACar
    hooks.BeACar = function(enable)
        if enable then
            if handles.BeACar then return end
            local ok, err = pcall(function()
                handles.BeACar = loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/BeaCar"))()
            end)
            if not ok then warn("BeACar failed: "..tostring(err)) end
        else
            tryCleanup("BeACar")
        end
    end

    -- Bang
    hooks.Bang = function(enable)
        if enable then
            if handles.Bang then return end
            local ok, err = pcall(function()
                handles.Bang = loadstring(game:HttpGet("https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua"))()
            end)
            if not ok then warn("Bang failed: "..tostring(err)) end
        else
            tryCleanup("Bang")
        end
    end

    -- JerkOff
    hooks.JerkOff = function(enable)
        if enable then
            if handles.JerkOff then return end
            local ok, err = pcall(function()
                handles.JerkOff = loadstring(game:HttpGet("https://pastefy.app/lawnvcTT/raw", true))()
            end)
            if not ok then warn("JerkOff failed: "..tostring(err)) end
        else
            tryCleanup("JerkOff")
        end
    end

    -- Fighting
    hooks.Fighting = function(enable)
        if enable then
            if handles.Fighting then return end
            local ok, err = pcall(function()
                handles.Fighting = loadstring(game:HttpGet("https://pastefy.app/cAQICuXo/raw", true))()
            end)
            if not ok then warn("Fighting failed: "..tostring(err)) end
        else
            tryCleanup("Fighting")
        end
    end

    -- Gun
    hooks.Gun = function(enable)
        if enable then
            if handles.Gun then return end
            local ok, err = pcall(function()
                handles.Gun = loadstring(game:HttpGet("https://pastebin.com/raw/0hn40Zbc"))()
            end)
            if not ok then warn("Gun failed: "..tostring(err)) end
        else
            tryCleanup("Gun")
        end
    end

    -- Shader
    hooks.Shader = function(enable)
        if enable then
            safeLoadFromUrl("Shader", "https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua")
        else
            tryCleanup("Shader")
        end
    end

    -- Teleport GUI
    hooks.TeleportGUI = function(enable)
        if enable then
            safeLoadFromUrl("TeleportGUI", "https://cdn.wearedevs.net/scripts/Click%20Teleport.txt")
        else
            tryCleanup("TeleportGUI")
        end
    end

    -- Sword (local safe)
    hooks.Sword = function(enable)
        if enable then
            if handles.Sword then return end
            local ok, err = pcall(function()
                local plr = LocalPlayer
                if not plr then return end
                local tool = Instance.new("Tool")
                tool.Name = "ClassicSword_RedHub"
                tool.RequiresHandle = false
                tool.CanBeDropped = true
                tool.Parent = plr.Backpack

                local handle = Instance.new("Part")
                handle.Name = "Handle"
                handle.Size = Vector3.new(1,0.6,3)
                handle.CanCollide = false
                handle.Parent = tool

                local mesh = Instance.new("SpecialMesh", handle)
                mesh.MeshType = Enum.MeshType.FileMesh
                mesh.MeshId = "rbxasset://fonts/sword.mesh"
                mesh.TextureId = "rbxasset://textures/SwordTexture.png"
                mesh.Scale = Vector3.new(1,1,1)

                local swingSound = Instance.new("Sound", handle)
                swingSound.SoundId = "rbxassetid://12222216"
                swingSound.Volume = 1

                local damage = 25
                local cooldown = false

                tool.Activated:Connect(function()
                    if cooldown then return end
                    cooldown = true
                    pcall(function() swingSound:Play() end)
                    local char = plr.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        for _, part in pairs(workspace:GetDescendants()) do
                            if part:IsA("BasePart") and part.Parent and part.Parent:FindFirstChild("Humanoid") then
                                local hum = part.Parent:FindFirstChild("Humanoid")
                                local hrp = part.Parent:FindFirstChild("HumanoidRootPart")
                                if hum and hrp and char:FindFirstChild("HumanoidRootPart") then
                                    local dist = (hrp.Position - char.HumanoidRootPart.Position).Magnitude
                                    if dist <= 5 and part.Parent ~= char then
                                        pcall(function() hum:TakeDamage(damage) end)
                                    end
                                end
                            end
                        end
                    end
                    wait(0.6)
                    cooldown = false
                end)

                handles.Sword = function()
                    pcall(function()
                        if tool and tool.Parent then tool:Destroy() end
                    end)
                end
            end)
            if not ok then warn("Sword failed: "..tostring(err)) end
        else
            tryCleanup("Sword")
        end
    end

    -- KillAura (inline)
    hooks.KillAura = function(enable)
        if enable then
            if handles.KillAura then return end
            local conn
            conn = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local char = LocalPlayer.Character
                    if not char then return end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    for _,pl in pairs(Players:GetPlayers()) do
                        if pl ~= LocalPlayer and pl.Character then
                            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                            local root = pl.Character:FindFirstChild("HumanoidRootPart")
                            if hum and root and (root.Position - hrp.Position).Magnitude <= 6 then
                                pcall(function() hum:TakeDamage(10) end)
                            end
                        end
                    end
                end)
            end)
            handles.KillAura = function() if conn then conn:Disconnect(); conn=nil end end
        else
            tryCleanup("KillAura")
        end
    end

    -- Teleport to mouse helper
    handles.__teleportToMouse = function()
        pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and mouse and mouse.Hit then
                char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0,3,0))
            end
        end)
    end

    -- State table
    local state = {
        FlyV3=false, InfJump=false, Shader=false, TeleportGUI=false,
        Speed=false, AntiAFK=false, BatTu=false, TanHinh=false,
        Noclip=false, WallWalk=false, LowLag=false, FeFlip=false,
        ESP=false, KillAura=false, BeACar=false, Bang=false,
        JerkOff=false, Fighting=false, Gun=false, Sword=false
    }

    -- Attempt to load Rayfield
    local Rayfield = nil
    pcall(function()
        local srcs = {
            "https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua",
            "https://sirius.menu/rayfield",
            "https://raw.githubusercontent.com/dawid-scripts/UI-Libraries/main/Rayfield.lua"
        }
        for _,url in ipairs(srcs) do
            local ok, code = pcall(function() return game:HttpGet(url, true) end)
            if ok and code and code:find("CreateWindow") then
                local ok2, lib = pcall(function() return loadstring(code)() end)
                if ok2 and lib then
                    Rayfield = lib
                    break
                end
            end
        end
    end)

    -- If Rayfield available, use it; else fallback to instance-based GUI
    if Rayfield then
        -- protect the Rayfield GUI (best-effort)
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(PlayerGui) end end)

        local Window = Rayfield:CreateWindow({
            Name = "Red Hub",
            LoadingTitle = "Red Hub",
            LoadingSubtitle = "By You",
            ConfigurationSaving = { Enabled = false },
            Discord = { Enabled = false },
            KeySystem = false
        })

        local tabStatus = Window:CreateTab("Trạng thái")
        local tabPlayer = Window:CreateTab("Người chơi")
        local tabCombat = Window:CreateTab("Chiến đấu")
        local tabFun = Window:CreateTab("Vui vẻ")

        local function addToggle(tab, label, key)
            tab:CreateToggle({
                Name = label,
                CurrentValue = state[key] or false,
                Flag = key,
                Callback = function(val)
                    state[key] = val
                    pcall(function() 
                        if hooks[key] then 
                            hooks[key](val) 
                        else 
                            warn("Hook missing:", key) 
                        end 
                    end)
                end
            })
        end

        -- Populate tabs
        addToggle(tabStatus, "Fly V3", "FlyV3")
        addToggle(tabStatus, "Infinite Jump", "InfJump")
        addToggle(tabStatus, "Speed", "Speed")
        addToggle(tabStatus, "Noclip", "Noclip")
        addToggle(tabStatus, "Wall Walk", "WallWalk")
        addToggle(tabStatus, "Bất tử (BatTu)", "BatTu")
        addToggle(tabStatus, "Tàng hình (TanHinh)", "TanHinh")
        addToggle(tabStatus, "ESP", "ESP")
        addToggle(tabStatus, "Low Lag", "LowLag")

        addToggle(tabPlayer, "Anti AFK", "AntiAFK")
        addToggle(tabPlayer, "Teleport GUI (load)", "TeleportGUI")
        addToggle(tabPlayer, "Shader (load)", "Shader")

        addToggle(tabCombat, "KillAura", "KillAura")
        addToggle(tabCombat, "Sword (local)", "Sword")
        addToggle(tabCombat, "Gun (load)", "Gun")
        addToggle(tabCombat, "Fighting (load)", "Fighting")
        addToggle(tabCombat, "FeFlip (load)", "FeFlip")

        addToggle(tabFun, "Be A Car (load)", "BeACar")
        addToggle(tabFun, "Bang (load)", "Bang")
        addToggle(tabFun, "JerkOff (load)", "JerkOff")
        
        -- Teleport one-shot implemented as button
        tabFun:CreateButton({
            Name = "Teleport To Mouse (one-shot)",
            Callback = function()
                pcall(function() 
                    if handles.__teleportToMouse then 
                        handles.__teleportToMouse() 
                    end 
                end)
            end
        })

        -- Toggle visibility via RightShift
        local menuOpen = true
        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == Enum.KeyCode.RightShift then
                menuOpen = not menuOpen
                pcall(function() 
                    if menuOpen then 
                        Window:Show()
                    else 
                        Window:Hide()
                    end 
                end)
            end
        end)

        -- Top-right small toggle (ScreenGui)
        local toggleGui = Instance.new("ScreenGui")
        toggleGui.Name = "RedHub_Toggle"
        toggleGui.ResetOnSpawn = false
        protectGui(toggleGui)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 110, 0, 32)
        btn.Position = UDim2.new(1, -130, 0, 18)
        btn.AnchorPoint = Vector2.new(0,0)
        btn.BackgroundColor3 = Color3.fromRGB(140,10,10)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Text = "🔴 Red Hub"
        btn.Parent = toggleGui

        btn.MouseButton1Click:Connect(function()
            menuOpen = not menuOpen
            pcall(function() 
                if menuOpen then 
                    Window:Show()
                else 
                    Window:Hide()
                end 
            end)
        end)

    else
        -- Fallback UI (Instance.new) - red/black, draggable
        local gui = Instance.new("ScreenGui")
        gui.Name = "RedHub_UI"
        gui.ResetOnSpawn = false
        protectGui(gui)

        local frameWidth, frameHeight = 360, 500
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
        frame.Position = UDim2.new(0.5, -frameWidth/2, 0.5, -frameHeight/2)
        frame.BackgroundColor3 = Color3.fromRGB(145,20,20)
        frame.Parent = gui

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1,0,0,40)
        title.Position = UDim2.new(0,0,0,0)
        title.BackgroundColor3 = Color3.fromRGB(190,30,30)
        title.TextColor3 = Color3.new(1,1,1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 18
        title.Text = "🔴 RED HUB"
        title.Parent = frame

        local menuGroups = {
            ["Nhân vật"] = {
                {key="FlyV3", label="Fly V3"},
                {key="InfJump", label="InfJump"},
                {key="Speed", label="Speed"},
                {key="Noclip", label="Noclip"},
                {key="WallWalk", label="Đi bộ trên tường"},
                {key="BatTu", label="Bất tử"},
                {key="TanHinh", label="Tàn hình"}
            },
            ["Chiến đấu"] = {
                {key="KillAura", label="KillAura"},
                {key="Sword", label="Sword"},
                {key="Gun", label="Gun"},
                {key="Fighting", label="Fighting"},
                {key="FeFlip", label="Lăn (FeFlip)"}
            },
            ["Hỗ trợ / Fun / Đồ họa"] = {
                {key="ESP", label="ESP"},
                {key="AntiAFK", label="Anti-AFK"},
                {key="BeACar", label="Be a Car"},
                {key="Bang", label="Bang"},
                {key="JerkOff", label="Jerk Off"},
                {key="Shader", label="Shader"},
                {key="TeleportGUI", label="Teleport GUI"},
                {key="LowLag", label="Giảm lag"}
            }
        }

        local startY = 44
        local btnPadding = 8
        local btnHeight = 36
        local btnWidth = math.floor((frameWidth - btnPadding*5)/4)

        for groupName, groupItems in pairs(menuGroups) do
            local groupLabel = Instance.new("TextLabel")
            groupLabel.Size = UDim2.new(1,0,0,24)
            groupLabel.Position = UDim2.new(0,0,0,startY)
            groupLabel.BackgroundColor3 = Color3.fromRGB(150,50,50)
            groupLabel.TextColor3 = Color3.new(1,1,1)
            groupLabel.Font = Enum.Font.GothamBold
            groupLabel.TextSize = 14
            groupLabel.Text = "► "..groupName
            groupLabel.Parent = frame
            startY = startY + 28

            for i, info in ipairs(groupItems) do
                local col = (i-1)%4
                local row = math.floor((i-1)/4)
                local btn = Instance.new("TextButton")
                btn.Size=UDim2.new(0,btnWidth,0,btnHeight)
                btn.Position=UDim2.new(0,btnPadding + col*(btnWidth+btnPadding),0,startY+row*(btnHeight+btnPadding))
                btn.BackgroundColor3=state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
                btn.TextColor3 = Color3.new(1,1,1)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize=14
                btn.Text = info.label..(state[info.key] and " [ON]" or " [OFF]")
                btn.Parent=frame

                btn.MouseButton1Click:Connect(function()
                    state[info.key] = not state[info.key]
                    btn.BackgroundColor3=state[info.key] and Color3.fromRGB(20,140,20) or Color3.fromRGB(140,10,10)
                    btn.Text=info.label..(state[info.key] and " [ON]" or " [OFF]")
                    pcall(function() 
                        if hooks[info.key] then 
                            hooks[info.key](state[info.key]) 
                        else 
                            warn("Hook missing:", info.key) 
                        end 
                    end)
                end)
            end
            startY = startY + math.ceil(#groupItems/4)*(btnHeight+btnPadding)+8
        end

        -- Drag logic for fallback
        local dragging=false
        local dragStart=Vector2.new()
        local startPos=UDim2.new()
        title.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true
                dragStart=input.Position
                startPos=frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState==Enum.UserInputState.End then dragging=false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
            end
        end)

        -- Top-right toggle for fallback
        local toggleGui = Instance.new("ScreenGui")
        toggleGui.Name = "RedHub_Toggle"
        toggleGui.ResetOnSpawn = false
        protectGui(toggleGui)
        local tbtn = Instance.new("TextButton")
        tbtn.Size = UDim2.new(0, 110, 0, 32)
        tbtn.Position = UDim2.new(1, -130, 0, 18)
        tbtn.BackgroundColor3 = Color3.fromRGB(140,10,10)
        tbtn.TextColor3 = Color3.new(1,1,1)
        tbtn.Font = Enum.Font.GothamBold
        tbtn.TextSize = 14
        tbtn.Text = "🔴 Red Hub"
        tbtn.Parent = toggleGui

        local visible = true
        tbtn.MouseButton1Click:Connect(function()
            visible = not visible
            frame.Visible = visible
        end)

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == Enum.KeyCode.RightShift then
                visible = not visible
                frame.Visible = visible
            end
        end)
    end

    print("✅ Red Hub loaded (hooks preserved, pcall-protected, executor-safe).")
end)
