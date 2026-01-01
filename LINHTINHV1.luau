loadstring(game:HttpGet("https://raw.githubusercontent.com/Seven7-lua/RedzLibs/refs/heads/main/src/RedzlibV2/source.lua"))()

MakeWindow({
  Hub = {
    Title = "Linh tinh hub : Universal",
    Animation = "Universal Only!"
  },
  Key = {
    KeySystem = true,
    Title = "Key System",
    Description = "Nhập Key Mau",
    KeyLink = "https://pastefy.app/EKyM1zzQ/raw",
    Keys = {"Memaybeo"},
    Notifi = {
      Notifications = true,
      CorrectKey = "Running the Script...",
      Incorrectkey = "The key is incorrect",
      CopyKeyLink = "Copied to Clipboard"
    }
  }
})

MinimizeButton({
  Image = "http://www.roblox.com/asset/?id=",
  Size = {60, 60},
  Color = Color3.fromRGB(10, 10, 10),
  Corner = true,
  Stroke = false,
  StrokeColor = Color3.fromRGB(255, 0, 0)
})

local Main = MakeTab({
   Name = "Chung"
});

local Charac = MakeTab({
   Name = "Nhân Vật"
});

local Server = MakeTab({
   Name = "Máy Chủ"
});

local Nolag = MakeTab({
   Name = "Fix Lag"
});

local Status = MakeTab({
   Name = "Trạng Thái"
});

local Item = MakeTab({
   Name = "Cài Đặt Vật Phẩm"
});

local Music = MakeTab({
   Name = "Nghe Nhạc"
});

local Misc = MakeTab({
   Name = "Script Khác"
});

local Infor = MakeTab({
   Name = "Thông Tin"
});

local Inf = MakeTab({
   Name = "Thông Tin Script"
});

MakeNotifi({
  Title = "Linh tinh Hub",
  Text = "Cảm ơn vì đã sài script=)",
  Time = 5
})

do
local TEXTURE = "rbxassetid://134973285396563"
local faces = {
	Enum.NormalId.Front,
	Enum.NormalId.Back,
	Enum.NormalId.Left,
	Enum.NormalId.Right,
	Enum.NormalId.Top,
	Enum.NormalId.Bottom
}
local function ApplyTextureToPart(part)
	if not part:IsA("BasePart") then return end
	for _, face in ipairs(faces) do
		local decal = Instance.new("Decal")
		decal.Texture = TEXTURE
		decal.Face = face
		decal.Parent = part
	end
end
function ApplyTextureToEverything()
	for _, obj in ipairs(workspace:GetDescendants()) do
		ApplyTextureToPart(obj)
	end
	workspace.DescendantAdded:Connect(function(obj)
		ApplyTextureToPart(obj)
	end)
end
local Lighting = game:GetService("Lighting")
local SKY_ID = "rbxassetid://134973285396563"
function SetSkybox()
	-- Xoá Sky cũ nếu có
	for _,v in ipairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		end
	end
	-- Tạo sky mới
	local sky = Instance.new("Sky")
	sky.SkyboxBk = SKY_ID
	sky.SkyboxDn = SKY_ID
	sky.SkyboxFt = SKY_ID
	sky.SkyboxLf = SKY_ID
	sky.SkyboxRt = SKY_ID
	sky.SkyboxUp = SKY_ID
	sky.Parent = Lighting
end
local SoundService = game:GetService("SoundService")
local SOUND_ID = "rbxassetid://138081566"
function SkeletonSound()
	-- Xoá sound cũ nếu có
	for _, s in ipairs(SoundService:GetChildren()) do
		if s:IsA("Sound") and s.SoundId == SOUND_ID then
			s:Destroy()
		end
	end
	-- Tạo sound mới
	local sound = Instance.new("Sound")
	sound.SoundId = SOUND_ID
	sound.Volume = 1
	sound.Looped = true  -- 🔥 loop mượt không bị ngắn
	sound.Parent = SoundService
	sound:Play()
end
local Players = game:GetService("Players")

local function ApplyFireToCharacter(char)
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	-- lấy torso / upperbody làm gốc
	local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
	if not root then return end

	-- xoá fire cũ nếu có
	for _,v in ipairs(root:GetChildren()) do
		if v:IsA("Fire") or v:IsA("Smoke") then
			v:Destroy()
		end
	end

	-- tạo lửa
	local fire = Instance.new("Fire")
	fire.Size = 20
	fire.Heat = 15
	fire.Parent = root

	-- hiệu ứng khói chảy
	local smoke = Instance.new("Smoke")
	smoke.Opacity = 0.5
	smoke.RiseVelocity = 2
	smoke.Parent = root
end
function Burn()
	-- áp dụng cho người đang có
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr.Character then
			ApplyFireToCharacter(plr.Character)
		end
		-- tự động áp dụng khi respawn
		plr.CharacterAdded:Connect(function(char)
			ApplyFireToCharacter(char)
		end)
	end
	-- nếu có người mới join
	Players.PlayerAdded:Connect(function(plr)
		plr.CharacterAdded:Connect(function(char)
			ApplyFireToCharacter(char)
		end)
	end)
end
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local plr = Players.LocalPlayer
function SpawnDummyInFront(plr)
	local character = plr.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local model = Instance.new("Model")
	model.Name = "Dummy"
	local function makePart(name, size)
		local p = Instance.new("Part")
		p.Name = name
		p.Size = size
		p.Color = Color3.fromRGB(255, 255, 255) -- Màu trắng
		p.Material = Enum.Material.SmoothPlastic
		p.Anchored = false
		p.CanCollide = true
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.Parent = model
		return p
	end
	-- Tạo các bộ phận với màu trắng
	local Torso = makePart("Torso", Vector3.new(2, 2, 1))
	local LeftArm = makePart("Left Arm", Vector3.new(1, 2, 1))
	local RightArm = makePart("Right Arm", Vector3.new(1, 2, 1))
	local LeftLeg = makePart("Left Leg", Vector3.new(1, 2, 1))
	local RightLeg = makePart("Right Leg", Vector3.new(1, 2, 1))
	local Root = makePart("HumanoidRootPart", Vector3.new(2, 2, 1))
	Root.Anchored = true
	-- Tạo đầu Roblox với màu trắng
	local Head = Instance.new("Part")
	Head.Name = "Head"
	Head.Size = Vector3.new(2, 1, 1)
	Head.Color = Color3.fromRGB(255, 255, 255) -- Màu trắng
	Head.Material = Enum.Material.SmoothPlastic
	Head.Anchored = false
	Head.CanCollide = true
	Head.TopSurface = Enum.SurfaceType.Smooth
	Head.BottomSurface = Enum.SurfaceType.Smooth
	Head.Parent = model
	-- Thêm mesh đầu Roblox
	local headMesh = Instance.new("SpecialMesh")
	headMesh.MeshType = Enum.MeshType.Head
	headMesh.Scale = Vector3.new(1.25, 1.25, 1.25)
	headMesh.Parent = Head
	-- Đặt vị trí ban đầu
	local forward = hrp.CFrame.LookVector
	local spawnPos = hrp.CFrame + forward * 5 + Vector3.new(0, 2, 0)
	Root.CFrame = spawnPos
	-- Đặt CFrame cho các bộ phận
	Torso.CFrame = Root.CFrame
	Head.CFrame = Root.CFrame * CFrame.new(0, 1.5, 0)
	LeftArm.CFrame = Torso.CFrame * CFrame.new(-1.5, 0, 0)
	RightArm.CFrame = Torso.CFrame * CFrame.new(1.5, 0, 0)
	LeftLeg.CFrame = Torso.CFrame * CFrame.new(-0.5, -2, 0)
	RightLeg.CFrame = Torso.CFrame * CFrame.new(0.5, -2, 0)
	-- Humanoid
	local hum = Instance.new("Humanoid")
	hum.Health = 100
	hum.MaxHealth = 100
	hum.Parent = model
	-- Mặt (vẫn giữ decal mặt bình thường)
	local face = Instance.new("Decal")
	face.Texture = "rbxasset://textures/face.png"
	face.Face = Enum.NormalId.Front
	face.Parent = Head
	-- Joints với offset chính xác
	local function joint(p0, p1, name, c0, c1)
		local m = Instance.new("Motor6D")
		m.Name = name
		m.Part0 = p0
		m.Part1 = p1
		if c0 then m.C0 = c0 end
		if c1 then m.C1 = c1 end
		m.Parent = p0
	end
	-- Tạo joints với C0 và C1 đúng
	joint(Root, Torso, "RootJoint", CFrame.new(), CFrame.new())
	joint(Torso, Head, "Neck", CFrame.new(0, 1, 0), CFrame.new(0, -0.5, 0))
	joint(Torso, LeftArm, "Left Shoulder", CFrame.new(-1, 0.5, 0), CFrame.new(0.5, 0.5, 0))
	joint(Torso, RightArm, "Right Shoulder", CFrame.new(1, 0.5, 0), CFrame.new(-0.5, 0.5, 0))
	joint(Torso, LeftLeg, "Left Hip", CFrame.new(-0.5, -1, 0), CFrame.new(0, 1, 0))
	joint(Torso, RightLeg, "Right Hip", CFrame.new(0.5, -1, 0), CFrame.new(0, 1, 0))
	model.PrimaryPart = Root
	model.Parent = Workspace
	-- Bỏ anchored sau một chút
	task.delay(0.1, function()
		if model.Parent then
			Root.Anchored = false
		end
	end)
	return model
end
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
function SpawnZombie(pos)
	local model = Instance.new("Model")
	model.Name = "Zombie"
	local BROWN = Color3.fromRGB(95, 71, 45)
	local GREEN = Color3.fromRGB(75, 151, 75)
	local function make(name, size, color)
		local p = Instance.new("Part")
		p.Name = name
		p.Size = size
		p.Color = color
		p.Anchored = false
		p.CanCollide = true
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.Parent = model
		return p
	end
	-- Root
	local HRP = make("HumanoidRootPart", Vector3.new(2, 2, 1), BROWN)
	HRP.CFrame = CFrame.new(pos or Vector3.new(0, 5, 0))
	-- Torso
	local Torso = make("Torso", Vector3.new(2, 2, 1), BROWN)
	-- Head
	local Head = Instance.new("Part")
	Head.Name = "Head"
	Head.Size = Vector3.new(2,1,1)
	Head.Color = GREEN
	Head.TopSurface = Enum.SurfaceType.Smooth
	Head.BottomSurface = Enum.SurfaceType.Smooth
	Head.Parent = model
	local mesh = Instance.new("SpecialMesh",Head)
	mesh.MeshType = Enum.MeshType.Head
	mesh.Scale = Vector3.new(1.25,1.25,1.25)
	local face = Instance.new("Decal",Head)
	face.Texture = "rbxasset://7074668"
	face.Face = Enum.NormalId.Front
	-- Arms & Legs
	local LA = make("Left Arm", Vector3.new(1, 2, 1), GREEN)
	local RA = make("Right Arm", Vector3.new(1, 2, 1), GREEN)
	local LL = make("Left Leg", Vector3.new(1, 2, 1), BROWN)
	local RL = make("Right Leg", Vector3.new(1, 2, 1), BROWN)
	-- Positioning
	Torso.CFrame = HRP.CFrame
	Head.CFrame = Torso.CFrame * CFrame.new(0,1.5,0)
	LA.CFrame = Torso.CFrame * CFrame.new(-1.5,0,0)
	RA.CFrame = Torso.CFrame * CFrame.new(1.5,0,0)
	LL.CFrame = Torso.CFrame * CFrame.new(-0.5,-2,0)
	RL.CFrame = Torso.CFrame * CFrame.new(0.5,-2,0)
	-- Humanoid
	local hum = Instance.new("Humanoid")
	hum.Health = 120
	hum.MaxHealth = 120
	hum.WalkSpeed = 12
	hum.Parent = model
	-- Motor6D helper
	local function joint(p0,p1,name,c0,c1)
		local m = Instance.new("Motor6D")
		m.Name = name
		m.Part0 = p0
		m.Part1 = p1
		m.C0 = c0 or CFrame.new()
		m.C1 = c1 or CFrame.new()
		m.Parent = p0
	end
	-- Root + Neck
	joint(HRP,Torso,"RootJoint")
	joint(Torso,Head,"Neck",CFrame.new(0,1,0),CFrame.new(0,-0.5,0))
	-- 🎯 GIƠ TAY RA TRƯỚC (XOAY +90 ĐỘ)
	local armTilt = CFrame.Angles(math.rad(90),0,0)
	joint(
		Torso,
		LA,
		"Left Shoulder",
		CFrame.new(-1,0.5,0) * armTilt,
		CFrame.new(0.5,0.5,0)
	)
	joint(
		Torso,
		RA,
		"Right Shoulder",
		CFrame.new(1,0.5,0) * armTilt,
		CFrame.new(-0.5,0.5,0)
	)
	-- Hips
	joint(Torso,LL,"Left Hip",CFrame.new(-0.5,-1,0),CFrame.new(0,1,0))
	joint(Torso,RL,"Right Hip",CFrame.new(0.5,-1,0),CFrame.new(0,1,0))
	model.PrimaryPart = HRP
	model.Parent = Workspace
	---------------- AI ----------------
	local DAMAGE = 15
	local RANGE = 4
	local CD = false
	local function attack(h)
		if CD then return end
		CD = true
		h:TakeDamage(DAMAGE)
		task.delay(1,function() CD=false end)
	end
	local function getNearest()
		local nearest=nil
		local dist=math.huge
		for _,plr in ipairs(Players:GetPlayers()) do
			local char = plr.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local h = char and char:FindFirstChildOfClass("Humanoid")
			if hrp and h and h.Health>0 then
				local d=(hrp.Position-HRP.Position).Magnitude
				if d<dist then
					dist=d
					nearest=char
				end
			end
		end
		return nearest
	end
	-- AI LOOP
	task.spawn(function()
		while hum.Health>0 and model.Parent do
			local target = getNearest()
			if target then
				local thrp = target:FindFirstChild("HumanoidRootPart")
				local thum = target:FindFirstChildOfClass("Humanoid")
				if thrp and thum and thum.Health>0 then
					hum:MoveTo(thrp.Position)
					if (thrp.Position-HRP.Position).Magnitude <= RANGE then
						attack(thum)
					end
				end
			end
			task.wait(0.1)
		end
	end)
end
function beZombie()
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local function ClearCharacter(char)
	for _,v in ipairs(char:GetChildren()) do
		if v:IsA("Accessory") then
			v:Destroy()
		end
		if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") then
			v:Destroy()
		end
		if v:IsA("BodyColors") then
			v:Destroy()
		end
		if v.Name == "Head" then
			for _,d in ipairs(v:GetChildren()) do
				if d:IsA("Decal") then
					d:Destroy()
				end
			end
		end
	end
end
function BecomeZombie(plr)
	local char = plr.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	-- ✔ ẨN NHÂN VẬT GỐC
	ClearCharacter(char)
	-- ❌ Tắt face + quần áo mặc định
	for _,p in ipairs(char:GetChildren()) do
		if p:IsA("BasePart") then
			p.Transparency = 1
		end
	end
	-- 🧟 SPAWN MODEL ZOMBIE
	local model = Instance.new("Model")
	model.Name = plr.Name.. "Zombie"
	local BROWN = Color3.fromRGB(95, 71, 45)
	local GREEN = Color3.fromRGB(75, 151, 75)
	local function make(name,size,color)
		local p = Instance.new("Part")
		p.Name = name
		p.Size = size
		p.Color = color
		p.Anchored = false
		p.CanCollide = false
		p.TopSurface = Enum.SurfaceType.Smooth
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.Parent = model
		return p
	end
	local HRP = make("HumanoidRootPart",Vector3.new(2,2,1),BROWN)
	HRP.CFrame = hrp.CFrame
	local Torso = make("Torso",Vector3.new(2,2,1),BROWN)
	local Head = Instance.new("Part")
	Head.Name = "Head"
	Head.Size = Vector3.new(2,1,1)
	Head.Color = GREEN
	Head.Parent = model
	local mesh = Instance.new("SpecialMesh",Head)
	mesh.MeshType = Enum.MeshType.Head
	mesh.Scale = Vector3.new(1.25,1.25,1.25)
	local face = Instance.new("Decal",Head)
	face.Texture = "rbxassetid://7074668"
	face.Face = Enum.NormalId.Front
	local LA = make("Left Arm",Vector3.new(1,2,1),GREEN)
	local RA = make("Right Arm",Vector3.new(1,2,1),GREEN)
	local LL = make("Left Leg",Vector3.new(1,2,1),BROWN)
	local RL = make("Right Leg",Vector3.new(1,2,1),BROWN)
	Torso.CFrame = HRP.CFrame
	Head.CFrame = Torso.CFrame * CFrame.new(0,1.5,0)
	LA.CFrame = Torso.CFrame * CFrame.new(-1.5,0,0)
	RA.CFrame = Torso.CFrame * CFrame.new(1.5,0,0)
	LL.CFrame = Torso.CFrame * CFrame.new(-0.5,-2,0)
	RL.CFrame = Torso.CFrame * CFrame.new(0.5,-2,0)
	-- Humanoid (để gắn vào player)
	local hum = Instance.new("Humanoid")
	hum.Health = 120
	hum.MaxHealth = 120
	hum.WalkSpeed = 12
	hum.Parent = model
	-- Motor6D
	local function joint(p0,p1,name,c0,c1)
		local m = Instance.new("Motor6D")
		m.Name = name
		m.Part0 = p0
		m.Part1 = p1
		m.C0 = c0 or CFrame.new()
		m.C1 = c1 or CFrame.new()
		m.Parent = p0
	end
	joint(HRP,Torso,"RootJoint")
	joint(Torso,Head,"Neck",CFrame.new(0,1,0),CFrame.new(0,-0.5,0))
	local armTilt = CFrame.Angles(math.rad(90),0,0)
	joint(Torso,LA,"Left Shoulder",
		CFrame.new(-1,0.5,0)*armTilt,
		CFrame.new(0.5,0.5,0))
	joint(Torso,RA,"Right Shoulder",
		CFrame.new(1,0.5,0)*armTilt,
		CFrame.new(-0.5,0.5,0))
	joint(Torso,LL,"Left Hip",CFrame.new(-0.5,-1,0),CFrame.new(0,1,0))
	joint(Torso,RL,"Right Hip",CFrame.new(0.5,-1,0),CFrame.new(0,1,0))
	model.PrimaryPart = HRP
	model.Parent = Workspace
	-- 🔗 GẮN HRP ZOMBIE THEO PLAYER
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = HRP
	weld.Part1 = hrp
	weld.Parent = HRP
end
local plr = Players.LocalPlayer
local function start(char)
	task.wait(0.5)
	BecomeZombie(plr)
end
if plr.Character then
	start(plr.Character)
end
plr.CharacterAdded:Connect(start)
end
function ghost()
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local killCount = 0

    local function SpawnGhost(position)
        local model = Instance.new("Model")
        model.Name = "Ma s.e.x"

        local BLACK = Color3.fromRGB(0,0,0)

        local function make(name,size)
            local p = Instance.new("Part")
            p.Name = name
            p.Size = size
            p.Color = BLACK
            p.Material = Enum.Material.SmoothPlastic
            p.Transparency = 0.3
            p.CanCollide = true
            p.Anchored = false
            p.Parent = model
            return p
        end

        local HRP = make("HumanoidRootPart",Vector3.new(2,2,1))
        HRP.CFrame = position

        local Torso = make("Torso",Vector3.new(2,2,1))
        local Head = make("Head",Vector3.new(2,1,1))
        local LA = make("Left Arm",Vector3.new(1,2,1))
        local RA = make("Right Arm",Vector3.new(1,2,1))
        local LL = make("Left Leg",Vector3.new(1,2,1))
        local RL = make("Right Leg",Vector3.new(1,2,1))

        local mesh = Instance.new("SpecialMesh",Head)
        mesh.MeshType = Enum.MeshType.Head
        mesh.Scale = Vector3.new(1.3,1.3,1.3)

        local aura = Instance.new("ParticleEmitter")
        aura.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
        aura.LightEmission = 1
        aura.Size = NumberSequence.new(6)
        aura.Texture = "rbxassetid://243660364"
        aura.Rate = 8
        aura.Speed = NumberRange.new(0.2,0.5)
        aura.Parent = HRP

        local hum = Instance.new("Humanoid",model)
        hum.MaxHealth = 200
        hum.Health = 200
        hum.WalkSpeed = 20

        Torso.CFrame = HRP.CFrame
        Head.CFrame = Torso.CFrame * CFrame.new(0,1.5,0)
        LA.CFrame = Torso.CFrame * CFrame.new(-1.5,0,0)
        RA.CFrame = Torso.CFrame * CFrame.new(1.5,0,0)
        LL.CFrame = Torso.CFrame * CFrame.new(-0.5,-2,0)
        RL.CFrame = Torso.CFrame * CFrame.new(0.5,-2,0)

        local function joint(p0,p1,c0,c1)
            local m = Instance.new("Motor6D")
            m.Part0 = p0
            m.Part1 = p1
            m.C0 = c0
            m.C1 = c1
            m.Parent = p0
            return m
        end

        joint(HRP,Torso,CFrame.new(),CFrame.new())
        joint(Torso,Head,CFrame.new(0,1,0),CFrame.new(0,-0.5,0))
        joint(Torso,LA,CFrame.new(-1,0.5,0),CFrame.new(0.5,0.5,0))
        joint(Torso,RA,CFrame.new(1,0.5,0),CFrame.new(-0.5,0.5,0))
        joint(Torso,LL,CFrame.new(-0.5,-1,0),CFrame.new(0,1,0))
        joint(Torso,RL,CFrame.new(0.5,-1,0),CFrame.new(0,1,0))

        model.PrimaryPart = HRP
        model.Parent = Workspace

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(4000,0,4000)
        bv.Parent = HRP

        task.spawn(function()
            while model.Parent do
                if not model:GetAttribute("Chasing") then
                    HRP.CFrame = HRP.CFrame * CFrame.new(0, math.sin(tick()*3)*0.035, 0)
                end
                task.wait(0.03)
            end
        end)

        local function getClosest()
            local closest,dist
            for _,plr in ipairs(Players:GetPlayers()) do
                local c = plr.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                local hum2 = c and c:FindFirstChild("Humanoid")
                if h and hum2 and hum2.Health > 0 then
                    local d = (h.Position - HRP.Position).Magnitude
                    if not closest or d < dist then
                        closest = h
                        dist = d
                    end
                end
            end
            return closest,dist
        end

        task.spawn(function()
            local lastDamaged = {}

            while model.Parent do
                local target,dist = getClosest()

                if target and dist < 50 then
                    model:SetAttribute("Chasing",true)

                    local dir = (target.Position - HRP.Position).Unit

                    -- ⭐ tốc độ mới = 15
                    bv.Velocity = dir * 40

                    -- xoay mặt
                    HRP.CFrame = CFrame.new(
                        HRP.Position,
                        Vector3.new(target.Position.X, HRP.Position.Y, target.Position.Z)
                    )

                    if dist < 5 then
                        local hum2 = target.Parent:FindFirstChild("Humanoid")
                        if hum2 and hum2.Health > 0 then
                            local key = target.Parent.Name
                            local last = lastDamaged[key] or 0

                            if tick() - last > 1.2 then
                                -- ⭐ tăng damage lên 12
                                hum2:TakeDamage(12)

                                lastDamaged[key] = tick()

                                if hum2.Health <= 0 then
                                    killCount += 1
                                end
                            end
                        end
                    end
                else
                    model:SetAttribute("Chasing",false)
                    bv.Velocity = Vector3.new()
                end

                task.wait(0.1)
            end
        end)

        return model
    end

    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    SpawnGhost(hrp.CFrame * CFrame.new(0,0,-10))
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game.Workspace

function BecomeGhost()
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")

    ------------------------------------------------
    -- ẨN TOÀN BỘ NHÂN VẬT
    ------------------------------------------------
    for _,v in ipairs(char:GetChildren()) do
        if v:IsA("BasePart") then
            v.Transparency = 1
            if v:FindFirstChild("face") then
                v.face.Transparency = 1
            end
        elseif v:IsA("Accessory") then
            v.Handle.Transparency = 1
        elseif v:IsA("Clothing") then
            v:Destroy()
        end
    end

    humanoid.NameDisplayDistance = 0


    ------------------------------------------------
    -- TẠO GHOST
    ------------------------------------------------
    local model = Instance.new("Model")
    model.Name = "Ma s.e.x"

    local BLACK = Color3.fromRGB(0,0,0)

    local function make(name,size)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Color = BLACK
        p.Material = Enum.Material.SmoothPlastic
        p.Transparency = 0.3
        p.Anchored = false
        p.CanCollide = false
        p.Parent = model
        return p
    end

    local HRP = make("HumanoidRootPart",Vector3.new(2,2,1))
    HRP.CFrame = hrp.CFrame

    local Torso = make("Torso",Vector3.new(2,2,1))
    local Head = make("Head",Vector3.new(2,1,1))
    local LA = make("Left Arm",Vector3.new(1,2,1))
    local RA = make("Right Arm",Vector3.new(1,2,1))
    local LL = make("Left Leg",Vector3.new(1,2,1))
    local RL = make("Right Leg",Vector3.new(1,2,1))

    local mesh = Instance.new("SpecialMesh",Head)
    mesh.MeshType = Enum.MeshType.Head
    mesh.Scale = Vector3.new(1.3,1.3,1.3)

    local aura = Instance.new("ParticleEmitter")
    aura.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
    aura.LightEmission = 1
    aura.Size = NumberSequence.new(6)
    aura.Texture = "rbxassetid://243660364"
    aura.Rate = 10
    aura.Speed = NumberRange.new(0.2,0.5)
    aura.Parent = HRP

    local hum = Instance.new("Humanoid")
    hum.MaxHealth = 250
    hum.Health = 250
    hum.WalkSpeed = 20
    hum.Parent = model


    Torso.CFrame = HRP.CFrame
    Head.CFrame = Torso.CFrame * CFrame.new(0,1.5,0)
    LA.CFrame = Torso.CFrame * CFrame.new(-1.5,0,0)
    RA.CFrame = Torso.CFrame * CFrame.new(1.5,0,0)
    LL.CFrame = Torso.CFrame * CFrame.new(-0.5,-2,0)
    RL.CFrame = Torso.CFrame * CFrame.new(0.5,-2,0)

    local function joint(p0,p1,c0,c1)
        local m = Instance.new("Motor6D")
        m.Part0 = p0
        m.Part1 = p1
        m.C0 = c0
        m.C1 = c1
        m.Parent = p0
        return m
    end

    joint(HRP,Torso,CFrame.new(),CFrame.new())
    joint(Torso,Head,CFrame.new(0,1,0),CFrame.new(0,-0.5,0))
    joint(Torso,LA,CFrame.new(-1,0.5,0),CFrame.new(0.5,0.5,0))
    joint(Torso,RA,CFrame.new(1,0.5,0),CFrame.new(-0.5,0.5,0))
    joint(Torso,LL,CFrame.new(-0.5,-1,0),CFrame.new(0,1,0))
    joint(Torso,RL,CFrame.new(0.5,-1,0),CFrame.new(0,1,0))

    model.PrimaryPart = HRP
    model.Parent = Workspace


    ------------------------------------------------
    -- GẮN NHÂN VẬT VÀ CAMERA VÀO GHOST
    ------------------------------------------------
    plr.Character = model
    Workspace.CurrentCamera.CameraSubject = hum


    ------------------------------------------------
    -- DI CHUYỂN = WALK NHƯ NGƯỜI
    ------------------------------------------------
    print("you gay")
end
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

function RemoveAllCharacterEffects()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")

    ------------------------------------------------
    -- 1️⃣ TẮT SCRIPT ANIMATE  (xoá toàn bộ animation)
    ------------------------------------------------
    local animate = char:FindFirstChild("Animate")
    if animate then
        animate.Disabled = true
    end

    ------------------------------------------------
    -- 2️⃣ DỪNG TẤT CẢ ANIMATION ĐANG CHẠY
    ------------------------------------------------
    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    ------------------------------------------------
    -- 3️⃣ XOÁ EMOTE NẾU CÓ
    ------------------------------------------------
    if hum:FindFirstChild("Animator") then
        for _, track in ipairs(hum.Animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end

    ------------------------------------------------
    -- 4️⃣ TẮT STATE ĐẶC BIỆT (không spam lỗi)
    ------------------------------------------------
    local ok, _ = pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    end)

    ------------------------------------------------
    -- 5️⃣ RESET LẠI MOVE CHO MƯỢT
    ------------------------------------------------
    hum.WalkSpeed = 16
    hum.JumpPower = 50
    hum.AutoRotate = true
    hum.PlatformStand = false
end
function esp()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local ESPTable = {}

-- Hàm tạo ESP cho một nhân vật
local function CreateESP(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = character:FindFirstChild("HumanoidRootPart")
    local Hum = character:FindFirstChildOfClass("Humanoid")
    if not Hum then return end

    -- Nếu đã có ESP, return
    if ESPTable[character] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = HRP
    billboard.Size = UDim2.new(0,150,0,60)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = HRP

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255,0,0)
    text.TextStrokeTransparency = 0
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.Text = character.Name
    text.Parent = billboard

    ESPTable[character] = {Billboard = billboard, TextLabel = text, Humanoid = Hum}
end

-- Hàm xoá ESP
local function RemoveESP(character)
    if ESPTable[character] then
        if ESPTable[character].Billboard then
            ESPTable[character].Billboard:Destroy()
        end
        ESPTable[character] = nil
    end
end

-- Cập nhật thông tin ESP liên tục
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") then
                CreateESP(char)
                local data = ESPTable[char]
                local hum = data.Humanoid
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                data.TextLabel.Text = string.format("%s\nHP: %d/%d\nDist: %.0f", player.Name, hum.Health, hum.MaxHealth, dist)
            elseif char then
                RemoveESP(char)
            end
        end
    end
end)

-- Xóa khi player thoát
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        RemoveESP(player.Character)
    end
end)
end
function hitboxesp()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local HitboxTable = {}

-- Tạo hitbox cho 1 player
local function CreateHitbox(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    if HitboxTable[character] then return end

    local box = Instance.new("SelectionBox")
    box.Adornee = character:FindFirstChild("HumanoidRootPart")
    box.Color3 = Color3.fromRGB(0, 255, 0) -- màu xanh lá
    box.LineThickness = 0.05
    box.SurfaceTransparency = 0.7 -- trong suốt
    box.Visible = true
    box.Parent = Workspace

    HitboxTable[character] = box
end

-- Xóa hitbox
local function RemoveHitbox(character)
    if HitboxTable[character] then
        HitboxTable[character]:Destroy()
        HitboxTable[character] = nil
    end
end

-- Loop update hitbox liên tục
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                CreateHitbox(char)
                -- update vị trí
                HitboxTable[char].Adornee = char:FindFirstChild("HumanoidRootPart")
            elseif char then
                RemoveHitbox(char)
            end
        end
    end
end)
-- Xóa hitbox khi player rời
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        RemoveHitbox(player.Character)
    end
end)
end
function laser()
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Tạo Tool
local tool = Instance.new("Tool")
tool.Name = "Kiếm laser lỏ"
tool.RequiresHandle = true
tool.Parent = plr.Backpack

-- Tạo Handle (cán trắng)
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.3, 4, 0.3)
handle.Color = Color3.fromRGB(255,255,255)
handle.Material = Enum.Material.SmoothPlastic
handle.Anchored = false
handle.CanCollide = false
handle.Parent = tool

-- Tạo Blade nhọn bằng SpecialMesh
local blade = Instance.new("Part")
blade.Name = "Blade"
blade.Size = Vector3.new(0.2, 6, 0.2) -- chiều dài
blade.Color = Color3.fromRGB(255,0,0)
blade.Material = Enum.Material.Neon
blade.Anchored = false
blade.CanCollide = false
blade.Parent = tool

-- Mesh để làm blade nhọn
local mesh = Instance.new("SpecialMesh")
mesh.MeshType = Enum.MeshType.Wedge -- mũi nhọn
mesh.Scale = Vector3.new(0.2, 6, 0.5) -- chiều ngang nhỏ, dài
mesh.Parent = blade

-- Đặt blade đúng vị trí
blade.CFrame = handle.CFrame * CFrame.new(0, 3.5, 0)

-- Gắn Blade vào Handle
local weld = Instance.new("WeldConstraint")
weld.Part0 = handle
weld.Part1 = blade
weld.Parent = handle

-- Hiệu ứng lửa
local fire = Instance.new("ParticleEmitter")
fire.Texture = "rbxassetid://243660364"
fire.Color = ColorSequence.new(Color3.fromRGB(255,50,0), Color3.fromRGB(255,0,0))
fire.LightEmission = 1
fire.Rate = 20
fire.Lifetime = NumberRange.new(0.5,1)
fire.Speed = NumberRange.new(1,2)
fire.Parent = blade
local Lighting = game:GetService("Lighting")
end
function Hoho()
    -- Màu ánh sáng chính
    Lighting.TimeOfDay = "18:30:00" -- chiều tối
    Lighting.ClockTime = 18.5
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 180, 120) -- ánh sáng phản xạ
    Lighting.Ambient = Color3.fromRGB(255, 160, 100) -- màu tổng thể
    Lighting.FogColor = Color3.fromRGB(255, 120, 50) -- sương mù màu hoàng hôn
    Lighting.FogEnd = 300
    Lighting.FogStart = 0
    Lighting.ExposureCompensation = 0.3

    -- Skybox hoàng hôn
    if not Lighting:FindFirstChild("SunsetSky") then
        local sky = Instance.new("Sky")
        sky.Name = "SunsetSky"
        sky.SkyboxBk = "rbxassetid://15889789" -- bạn có thể thay bằng sky riêng
        sky.SkyboxDn = "rbxassetid://15889789"
        sky.SkyboxFt = "rbxassetid://15889789"
        sky.SkyboxLf = "rbxassetid://15889789"
        sky.SkyboxRt = "rbxassetid://15889789"
        sky.SkyboxUp = "rbxassetid://15889789"
        sky.Parent = Lighting
    end

    print("gay")
end
local Lighting = game:GetService("Lighting")

function NightFE()
    -- Áp dụng trời tối (không thay skybox)
    Lighting.TimeOfDay = "00:00:00"
    Lighting.ClockTime = 0
    Lighting.Brightness = 1
    Lighting.OutdoorAmbient = Color3.fromRGB(50,50,80)
    Lighting.Ambient = Color3.fromRGB(40,40,70)
    Lighting.FogColor = Color3.fromRGB(30,30,50)
    Lighting.FogEnd = 500
    Lighting.FogStart = 0
    Lighting.ExposureCompensation = 0
end
local Lighting = game:GetService("Lighting")

function MorningFE()
    -- Áp dụng buổi sáng
    Lighting.TimeOfDay = "08:00:00"
    Lighting.ClockTime = 8
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 180) -- ánh sáng phản xạ
    Lighting.Ambient = Color3.fromRGB(220, 220, 200)        -- màu tổng thể
    Lighting.FogColor = Color3.fromRGB(200, 200, 180)      -- sương mù sáng
    Lighting.FogEnd = 1000
    Lighting.FogStart = 0
    Lighting.ExposureCompensation = 0.3
end
local Lighting = game:GetService("Lighting")

function ShaderFE()
    -- Thời gian và ánh sáng tổng thể
    Lighting.ClockTime = 15.5        -- chiều muộn
    Lighting.TimeOfDay = "15:30:00"
    Lighting.Brightness = 2.5        -- ánh sáng sáng và rực rỡ
    Lighting.ShadowSoftness = 0.4    -- bóng mềm mại

    -- Màu ánh sáng môi trường
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 220, 180)  -- ánh sáng mặt trời phản chiếu
    Lighting.Ambient = Color3.fromRGB(200, 180, 150)         -- màu tổng thể
    Lighting.ColorShift_Bottom = Color3.fromRGB(240, 200, 160)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)

    -- Sương mù tạo chiều sâu
    Lighting.FogColor = Color3.fromRGB(240, 200, 180)
    Lighting.FogStart = 30
    Lighting.FogEnd = 400

    -- Điều chỉnh Exposure cho màu nổi bật hơn
    Lighting.ExposureCompensation = 0.5

    -- Optional: tăng contrast nhẹ cho môi trường sáng
    Lighting.ColorShift_Bottom = Color3.fromRGB(250, 210, 170)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)

    print("Gay")
end
local Image = AddImageLabel(Infor, {
  Name = "Logo Sắp Đc Thêm",
  Image = "rbxassetid://86749587185394"
})
local Paragraph = AddParagraph(Main, {"🥳Chúc Mừng Năm Mới🥳", ""})
local Paragraph = AddParagraph(Main, {"🎉Chúc Mấy Bạn Thi Tốt Nha🎉", ""})
AddButton(Main, {
  Name = "❤️Nhớ Follow Kênh Tiktok❤️",
  Default = true,
  Callback = function()
    setclipboard("@phnglcth7")
  end
})
local section = AddSection(Main, {"W.I.P"})
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local Slider = AddSlider(Main, {
    Name = "Tốc Độ",
    MinValue = 16,
    MaxValue = 500,
    Default = 16,
    Increase = 1,
    Callback = function(Value)
        local char = plr.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end
})
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- Slider điều chỉnh JumpPower
local Slider = AddSlider(Main, {
    Name = "Nhảy Cao",
    MinValue = 50,    -- nhảy thấp nhất
    MaxValue = 500,   -- nhảy cao nhất
    Default = 50,
    Increase = 1,
    Callback = function(Value)
        local char = plr.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            hum.JumpPower = Value -- áp dụng cho R6 và R15
        end
    end
})
-- Toggle X-Ray (Nhìn xuyên tường)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local xrayEnabled = false
local xrayConnection
local originalTransparencies = {}
local scannedParts = {}

-- Hàm áp dụng X-Ray cho tất cả parts trong workspace
local function applyXRay()
    -- Quét toàn bộ workspace
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
            -- Lưu transparency gốc (chỉ lần đầu)
            if originalTransparencies[part] == nil then
                originalTransparencies[part] = part.Transparency
            end
            
            -- Chỉ áp dụng cho parts không trong suốt
            if part.Transparency < 0.8 then
                -- Làm trong suốt các parts để nhìn xuyên qua
                part.Transparency = 0.8
                
                -- Tô màu đặc biệt cho các vật thể quan trọng
                if part.Name:lower():find("chest") or part.Name:lower():find("loot") then
                    part.Color = Color3.fromRGB(255, 215, 0) -- Vàng
                    part.Material = Enum.Material.Neon
                elseif part.Name:lower():find("player") or part:FindFirstChild("Humanoid") then
                    part.Color = Color3.fromRGB(255, 0, 0) -- Đỏ
                    part.Material = Enum.Material.Neon
                elseif part.Name:lower():find("door") or part.Name:lower():find("gate") then
                    part.Color = Color3.fromRGB(0, 255, 0) -- Xanh lá
                end
            end
        end
    end
end

-- Hàm khôi phục transparency gốc
local function restoreXRay()
    for part, transparency in pairs(originalTransparencies) do
        if part and part.Parent then
            pcall(function()
                part.Transparency = transparency
                -- Khôi phục màu sắc gốc cho các parts đặc biệt
                if part.Name:lower():find("chest") or part.Name:lower():find("loot") or 
                   part.Name:lower():find("player") or part.Name:lower():find("door") then
                    part.Color = Color3.fromRGB(255, 255, 255)
                    part.Material = Enum.Material.Plastic
                end
            end)
        end
    end
    originalTransparencies = {}
    scannedParts = {}
end

-- Loop duy trì X-Ray
local function maintainXRay()
    if xrayConnection then
        xrayConnection:Disconnect()
    end
    
    xrayConnection = RunService.RenderStepped:Connect(function()
        if xrayEnabled then
            applyXRay()
        end
    end)
end

-- Phiên bản nâng cao với highlight vật thể quan trọng
local function applyAdvancedXRay()
    -- Làm trong suốt tường và vật cản
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
            -- Lưu transparency gốc
            if originalTransparencies[part] == nil then
                originalTransparencies[part] = {
                    Transparency = part.Transparency,
                    Color = part.Color,
                    Material = part.Material
                }
            end
            
            -- Phân loại vật thể
            local isWall = part.Name:lower():find("wall") or part.Name:lower():find("brick") 
            local isFloor = part.Name:lower():find("floor") or part.Name:lower():find("ground")
            local isObstacle = part.Name:lower():find("obstacle") or part.Name:lower():find("barrier")
            
            if isWall or isFloor or isObstacle then
                -- Làm trong suốt tường và vật cản
                part.Transparency = 0.7
                part.Color = Color3.fromRGB(100, 100, 100)
            else
                -- Giữ nguyên các vật thể khác nhưng highlight quan trọng
                local parentName = part.Parent and part.Parent.Name:lower() or ""
                
                -- Highlight players
                if part.Parent and part.Parent:FindFirstChild("Humanoid") then
                    part.Transparency = 0.3
                    part.Color = Color3.fromRGB(255, 50, 50)
                    part.Material = Enum.Material.Neon
                
                -- Highlight chests/loot
                elseif parentName:find("chest") or parentName:find("loot") or 
                       part.Name:lower():find("chest") or part.Name:lower():find("loot") then
                    part.Transparency = 0.2
                    part.Color = Color3.fromRGB(255, 215, 0) -- Vàng
                    part.Material = Enum.Material.Neon
                
                -- Highlight doors
                elseif parentName:find("door") or part.Name:lower():find("door") then
                    part.Transparency = 0.4
                    part.Color = Color3.fromRGB(50, 205, 50) -- Xanh lá sáng
                    part.Material = Enum.Material.Neon
                
                -- Highlight vehicles
                elseif parentName:find("vehicle") or parentName:find("car") then
                    part.Transparency = 0.5
                    part.Color = Color3.fromRGB(30, 144, 255) -- Xanh dương
                    part.Material = Enum.Material.Neon
                end
            end
        end
    end
end
-- Simple X-Ray Toggle
local xrayOn = false
local savedProps = {}
local conn

AddToggle(Tab0o, {
    Name = "X-Ray",
    Callback = function(state)
        xrayOn = state
        
        if state then
            -- Bật X-Ray
            conn = game:GetService("RunService").RenderStepped:Connect(function()
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.Transparency < 0.5 then
                        if not savedProps[part] then
                            savedProps[part] = part.Transparency
                        end
                        part.Transparency = 0.5
                    end
                end
            end)
            
        else
            -- Tắt X-Ray
            if conn then
                conn:Disconnect()
                conn = nil
            end
            
            -- Khôi phục
            for part, transparency in pairs(savedProps) do
                if part and part.Parent then
                    part.Transparency = transparency
                end
            end
            savedProps = {}
            
        end
    end
})
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

_G.Infjumo = false
local conn

local function Setup()
	if conn then conn:Disconnect() end

	conn = UserInputService.JumpRequest:Connect(function()
		if not _G.Infjumo then return end

		local char = player.Character
		if not char then return end

		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
end

-- khi nhân vật spawn lại thì vẫn hoạt động
player.CharacterAdded:Connect(Setup)
Setup()

local Toggle = AddToggle(Main, {
	Name = "Nhảy Vô Hạn",
	Default = false,
	Callback = function(Value)
		_G.Infjumo = Value
	end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local AirWalkEnabled = false
local Platform = nil

local Toggle = AddToggle(Main, {
    Name = "Đi bộ trên không",
    Default = false,
    Callback = function(Value)
        AirWalkEnabled = Value
        
        if AirWalkEnabled then
            -- tạo platform nếu chưa có
            if not Platform then
                Platform = Instance.new("Part")
                Platform.Name = "AirWalkPlatform"
                Platform.Size = Vector3.new(6,1,6)
                Platform.Anchored = true
                Platform.Transparency = 0.5
                Platform.CanCollide = true
                Platform.Color = Color3.fromRGB(255,0,0)
                Platform.Parent = workspace
            end
            
            -- cập nhật vị trí liên tục
            task.spawn(function()
                while AirWalkEnabled and Platform do
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        Platform.CFrame = hrp.CFrame * CFrame.new(0,-4,0)
                    end
                    task.wait(0.02)
                end
            end)

        else
            -- tắt thì xóa platform
            if Platform then
                Platform:Destroy()
                Platform = nil
            end
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

_G.Noclipping = false
local noclipConn

local function ApplyNoclip()
	-- đảm bảo chỉ có 1 connection
	if noclipConn then noclipConn:Disconnect() end

	noclipConn = RunService.Stepped:Connect(function()
		if not _G.Noclipping then return end

		local char = player.Character
		if not char then return end

		for _,v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end)
end

-- auto chạy lại khi respawn
player.CharacterAdded:Connect(function()
	if _G.Noclipping then
		ApplyNoclip()
	end
end)

-- hàm bạn yêu cầu
function noclip()
	ApplyNoclip()
end

-- TOGGLE
local Toggle = AddToggle(Main, {
	Name = "Noclip",
	Default = false,
	Callback = function(Value)
		_G.Noclipping = Value
		if Value then
			noclip()
		end
	end
})
local Players = game:GetService("Players")
local player = Players.LocalPlayer

_G.Invisible = false
local savedTransparency = {}

local function SetInvisible(char)
    -- lưu lại transparency gốc để khôi phục
    savedTransparency[char] = {}

    for _,v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            savedTransparency[char][v] = v.Transparency
            v.Transparency = 1
        end
    end
end

local function SetVisible(char)
    if not savedTransparency[char] then return end

    for obj,old in pairs(savedTransparency[char]) do
        if obj then
            obj.Transparency = old
        end
    end

    savedTransparency[char] = nil
end

local function UpdateState()
    local char = player.Character
    if not char then return end

    if _G.Invisible then
        SetInvisible(char)
    else
        SetVisible(char)
    end
end

-- tự bật lại khi respawn
player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    UpdateState()
end)

-- TOGGLE UI
local Toggle = AddToggle(Main, {
    Name = "Tàn Hình",
    Default = false,
    Callback = function(Value)
        _G.Invisible = Value
        UpdateState()
    end
})
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

_G.ClickTP = false
local mouse = player:GetMouse()
local conn

local function EnableClickTP()
	if conn then conn:Disconnect() end

	conn = mouse.Button1Down:Connect(function()
		if not _G.ClickTP then return end
		local char = player.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local pos = mouse.Hit + Vector3.new(0,3,0)
		root.CFrame = CFrame.new(pos.X,pos.Y,pos.Z)
	end)
end

-- hỗ trợ respawn
player.CharacterAdded:Connect(function()
	if _G.ClickTP then
		EnableClickTP()
	end
end)

-- TOGGLE
local Toggle = AddToggle(Main, {
	Name = "Click Teleport",
	Default = false,
	Callback = function(Value)
		_G.ClickTP = Value
		if Value then
			EnableClickTP()
		end
	end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Swimming = false
local swimConnection

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function enableSwim()
    local character = getCharacter()
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoid and rootPart then
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        -- Giữ nhân vật không rơi quá nhanh
        rootPart.Velocity = Vector3.new(rootPart.Velocity.X, math.clamp(rootPart.Velocity.Y, -5, 5), rootPart.Velocity.Z)
    end
end

local function disableSwim()
    local character = getCharacter()
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

local Toggle = AddToggle(Main, {
    Name = "Sức Mạnh Đao",
    Default = false,
    Callback = function(Value)
        Swimming = Value
        if swimConnection then
            swimConnection:Disconnect()
            swimConnection = nil
        end

        if Swimming then
            swimConnection = RunService.Heartbeat:Connect(function()
                enableSwim()
            end)
        else
            disableSwim()
        end
    end
})
AddButton(Main, {
  Name = "Gui Bay",
  Callback = function()
    local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "Bay"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Gui Bay"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
closebutton.Font = "SourceSans"
closebutton.Size = UDim2.new(0, 45, 0, 28)
closebutton.Text = "X"
closebutton.TextSize = 30
closebutton.Position =  UDim2.new(0, 0, -1, 27)

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini.Font = "SourceSans"
mini.Size = UDim2.new(0, 45, 0, 28)
mini.Text = "-"
mini.TextSize = 40
mini.Position = UDim2.new(0, 44, -1, 27)

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
mini2.Font = "SourceSans"
mini2.Size = UDim2.new(0, 45, 0, 28)
mini2.Text = "+"
mini2.TextSize = 40
mini2.Position = UDim2.new(0, 44, -1, 57)
mini2.Visible = false

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "By Xneo";
	Text = "Remix By Script:)";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;

Frame.Active = true -- main = gui
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true



		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end




	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then



		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			--	game.Players.LocalPlayer.Character.Animate.Disabled = true
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false




	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false



	end





end)

local tis

up.MouseButton1Down:connect(function()
	tis = up.MouseEnter:connect(function()
		while tis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
		end
	end)
end)

up.MouseLeave:connect(function()
	if tis then
		tis:Disconnect()
		tis = nil
	end
end)

local dis

down.MouseButton1Down:connect(function()
	dis = down.MouseEnter:connect(function()
		while dis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
		end
	end)
end)

down.MouseLeave:connect(function()
	if dis then
		dis:Disconnect()
		dis = nil
	end
end)


game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false

end)


plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then


		tpwalking = false
		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
	end
end)
mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		wait(1)
		speed.Text = speeds
	else
		speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()

					local hb = game:GetService("RunService").Heartbeat	


					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end

				end)
			end
		end
	end
end)

closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speed.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	closebutton.Position =  UDim2.new(0, 0, -1, 57)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0 
	closebutton.Position =  UDim2.new(0, 0, -1, 27)
end)
  end
})
AddButton(Main, {
  Name = "Quả Lọ Cho r15",
  Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
  end
})
AddButton(Main, {
  Name = "Lọ r6",
  Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
  end
})
AddButton(Main, {
  Name = "Emote r15",
  Callback = function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxten-Keyes/music/refs/heads/main/music%23%5Bscripts%5D/music%23%5Bmiscellaneous%5D/music%23%5Bfe%20r15%20animation%20player%5D.lua"))()
  end
})
AddButton(Main, {
  Name = "quay ngược thời gian",
  Callback = function()
	loadstring(game:HttpGet("https://mscripts.vercel.app/scfiles/reverse-script.lua"))()
  end
})
local Players = game:GetService("Players")
local player = Players.LocalPlayer

AddButton(Main, {
    Name = "Hiệu Ứng Sích Lô",
    Callback = function()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        -- Tạo ParticleEmitter mới
        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "RedFairyParticle_" .. tick()
        emitter.Parent = humanoidRootPart

        -- Thay hạt bằng hình ảnh
        emitter.Texture = "rbxassetid://134973285396563"

        -- Kích thước hạt lớn hơn
        emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(1,0.6)})

        -- Màu đỏ đậm hơn, ít trong suốt
        emitter.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
        emitter.Transparency = NumberSequence.new(0.1,0.3)  -- ít trong suốt hơn

        -- Thời gian sống hạt
        emitter.Lifetime = NumberRange.new(1,2)

        -- Tốc độ, tỏa xung quanh sát nhân vật
        emitter.Rate = 40
        emitter.Speed = NumberRange.new(1,2)
        emitter.VelocitySpread = 360
        emitter.EmissionDirection = Enum.NormalId.Top
        emitter.ZOffset = 0

        -- Xoay hạt nhẹ
        emitter.Rotation = NumberRange.new(0,360)
        emitter.RotSpeed = NumberRange.new(30,60)

        -- Ánh sáng neon
        emitter.LightEmission = 0.8
    end
})
local Main = MakeTab({Name = "Hào Quang"})
-- Button Hào quang Lgbt
AddButton(Main, {
    Name = "Hào quang Lgbt",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        -- Xóa aura cũ nếu có
        if hrp:FindFirstChild("LgbtAura") then
            hrp.LgbtAura:Destroy()
        end

        -- Tạo Part hào quang
        local aura = Instance.new("Part")
        aura.Name = "LgbtAura"
        aura.Shape = Enum.PartType.Ball
        aura.Size = Vector3.new(12,12,12)
        aura.Transparency = 0.6
        aura.Material = Enum.Material.Neon
        aura.Anchored = true
        aura.CanCollide = false
        aura.CastShadow = false
        aura.Parent = workspace

        -- Thêm PointLight
        local light = Instance.new("PointLight")
        light.Range = 25
        light.Brightness = 3
        light.Shadows = false
        light.Parent = aura

        local isActive = true
        local hue = 0
        local baseColor = Color3.fromRGB(255,0,0) -- Màu mặc định đỏ

        -- Cập nhật vị trí và đổi màu liên tục
        RunService.Heartbeat:Connect(function(dt)
            if not isActive or not aura or not hrp then return end
            aura.Position = hrp.Position

            -- Rainbow effect dựa trên baseColor
            local hsv = {baseColor:ToHSV()}
            hue = (hue + dt * 0.2) % 1
            local color = Color3.fromHSV(hue, hsv[2], hsv[3])
            aura.Color = color
            light.Color = color
        end)

        -- Hàm tăng/giảm kích thước
        local function changeSize(delta)
            local newSize = math.clamp(aura.Size.X + delta, 6, 20)
            aura.Size = Vector3.new(newSize,newSize,newSize)
        end

        -- Bật/tắt aura
        local function toggleAura()
            isActive = not isActive
            aura.Visible = isActive
            light.Enabled = isActive
        end

        -- Key bindings
        local UIS = game:GetService("UserInputService")
        UIS.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.H then toggleAura()
            elseif input.KeyCode == Enum.KeyCode.Up then changeSize(2)
            elseif input.KeyCode == Enum.KeyCode.Down then changeSize(-2) end
        end)

        -- Color Picker để đổi màu cơ bản
        AddColorPicker(Main, {
            Name = "Chọn màu hào quang",
            Default = baseColor,
            Callback = function(Value)
                baseColor = Value
                aura.Color = Value
                light.Color = Value
            end
        })

        print("Gay à")
    end
})

local section = AddSection(Main, {"Bay Theo Người Chơi"})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local targetPlayerName = ""
local followConnection = nil
local shouldTween = false

-- Hàm tween mượt đến target
local function _tp(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    local rootPart = character.HumanoidRootPart
    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()

    task.spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            if not shouldTween then
                tween:Cancel()
                break
            end
            task.wait(0.1)
        end
    end)
end

-- TextBox nhập tên người chơi
AddTextBox(Main, {
    Name = "Nhập tên người chơi",
    Default = "",
    PlaceholderText = "Nhập tên người chơi...",
    ClearText = false,
    Callback = function(Value)
        targetPlayerName = Value
    end
})

-- Toggle bay theo người chơi
AddToggle(Main, {
    Name = "Bay theo người chơi",
    Default = false,
    Callback = function(value)
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end

        if value then
            shouldTween = true
            -- Bắt đầu follow
            followConnection = RunService.Heartbeat:Connect(function()
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
                    local targetCFrame = CFrame.new(targetPos)
                    _tp(targetCFrame)
                end
            end)
        else
            -- Tắt follow
            shouldTween = false
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
        end
    end
})

local section = AddSection(Main, {"Bay Xung Quanh Người Chơi"})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local targetPlayerName = ""
local followConnection = nil
local shouldTween = false
local orbitSpeed = 25 -- mặc định tốc độ
local orbitRadius = 10 -- mặc định bán kính

-- Hàm tween mượt đến target
local function _tp(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    local rootPart = character.HumanoidRootPart
    local distance = (targetCFrame.Position - rootPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()

    task.spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            if not shouldTween then
                tween:Cancel()
                break
            end
            task.wait(0.05)
        end
    end)
end

-- TextBox nhập tên người chơi
AddTextBox(Main, {
    Name = "Nhập tên người chơi",
    Default = "",
    PlaceholderText = "Nhập tên người chơi...",
    ClearText = false,
    Callback = function(Value)
        targetPlayerName = Value
    end
})

-- Slider tốc độ bay quanh
AddSlider(Main, {
    Name = "Tốc độ bay",
    MinValue = 10,
    MaxValue = 200,
    Default = orbitSpeed,
    Increase = 1,
    Callback = function(Value)
        orbitSpeed = Value
    end
})

-- Slider bán kính xoay
AddSlider(Main, {
    Name = "Bán kính xoay",
    MinValue = 5,
    MaxValue = 50,
    Default = orbitRadius,
    Increase = 1,
    Callback = function(Value)
        orbitRadius = Value
    end
})

-- Toggle bay xung quanh người chơi
AddToggle(Main, {
    Name = "Bay quanh người chơi",
    Default = false,
    Callback = function(value)
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end

        if value then
            shouldTween = true
            local angle = 0
            followConnection = RunService.Heartbeat:Connect(function(dt)
                if not shouldTween then return end
                local targetPlayer = Players:FindFirstChild(targetPlayerName)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    angle = angle + dt * orbitSpeed / 50 -- điều chỉnh tốc độ
                    local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                    local x = targetPos.X + math.cos(angle) * orbitRadius
                    local z = targetPos.Z + math.sin(angle) * orbitRadius
                    local y = targetPos.Y + 5 -- offset trên đầu
                    _tp(CFrame.new(Vector3.new(x, y, z)))
                end
            end)
        else
            shouldTween = false
            if followConnection then
                followConnection:Disconnect()
                followConnection = nil
            end
        end
    end
})
local section = AddSection(Main, {"Đóng băng người Chơi"})

local Players = game:GetService("Players")

local FrozenPlayerName = nil
local FrozenChar = nil
local FrozenState = false

-- TEXTBOX: nhập tên player
AddTextBox(Main, {
    Name = "Tên người chơi",
    Default = "",
    PlaceholderText = "Nhập tên...",
    ClearText = false,
    Callback = function(Value)
        FrozenPlayerName = Value
    end
})

-- TOGGLE: đóng băng
local Toggle = AddToggle(Main, {
    Name = "Đóng băng",
    Default = false,
    Callback = function(Value)
        FrozenState = Value
        
        if not FrozenPlayerName or FrozenPlayerName == "" then
            return
        end
        
        local plr = Players:FindFirstChild(FrozenPlayerName)
        if not plr then
            return
        end
        
        FrozenChar = plr.Character or plr.CharacterAdded:Wait()
        local hrp = FrozenChar:FindFirstChild("HumanoidRootPart")
        
        if not hrp then return end
        
        if FrozenState == true then
            hrp.Anchored = true
        else
            hrp.Anchored = false
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Frozen = false
local conns = {}

-- HÀM DỪNG ANIMATION (nếu bạn đã có sẵn thì bỏ đoạn này)
local function StopAnimations(hum)
    for _,track in ipairs(hum:GetPlayingAnimationTracks()) do
        track:Stop()
    end
end

-- ĐÓNG BĂNG 1 CHAR
local function FreezeCharacter(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    local animate = char:FindFirstChild("Animate")

    if not hrp or not hum then return end
    
    if animate then
        animate.Disabled = true
    end

    StopAnimations(hum)

    hum.WalkSpeed = 0
    hum.JumpPower = 0
    hrp.Anchored = true
end

-- BỎ ĐÓNG BĂNG 1 CHAR
local function UnfreezeCharacter(char)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    local animate = char:FindFirstChild("Animate")

    if not hrp or not hum then return end

    hrp.Anchored = false
    hum.WalkSpeed = 16
    hum.JumpPower = 50

    if animate then
        animate.Disabled = false
    end
end

-- ÁP DỤNG CHO TẤT CẢ
local function ApplyAll()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                if Frozen then
                    FreezeCharacter(char)
                else
                    UnfreezeCharacter(char)
                end
            end

            -- đảm bảo respawn vẫn bị áp dụng
            if not conns[plr] then
                conns[plr] = plr.CharacterAdded:Connect(function(char)
                    task.wait(0.2)
                    if Frozen then
                        FreezeCharacter(char)
                    else
                        UnfreezeCharacter(char)
                    end
                end)
            end
        end
    end
end

----------------------------------------------------
-- TOGGLE
----------------------------------------------------
local Toggle = AddToggle(Main, {
    Name = "Đóng băng tất cả người chơi(có thể bị lỗi animation)",
    Default = false,
    Callback = function(Value)
        Frozen = Value
        ApplyAll()
    end
})

local section = AddSection(Main, {"Hitbox (Thử Nghiệm)"})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local HitboxEnabled = false
local HitboxSize = 25
local Connections = {}
local RemoveConnections = {} -- bảng riêng

-- Hàm áp hitbox
local function ApplyHitbox(char)
    pcall(function()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end
        
        if not char:GetAttribute("OriginalHRPSize") then
            char:SetAttribute("OriginalHRPSize", hrp.Size)
            char:SetAttribute("OriginalHRPTransparency", hrp.Transparency)
            char:SetAttribute("OriginalHRPCanCollide", hrp.CanCollide)
        end
        
        hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
        hrp.Massless = true
        hrp.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
        hrp.Transparency = 0.7
        hrp.CanCollide = false
        
        local highlight = char:FindFirstChild("HitboxHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "HitboxHighlight"
            highlight.FillColor = Color3.fromRGB(255,0,0)
            highlight.FillTransparency = 0.7
            highlight.OutlineColor = Color3.fromRGB(255,50,50)
            highlight.OutlineTransparency = 0
            highlight.Adornee = hrp
            highlight.Parent = char
        else
            highlight.Enabled = true
            highlight.Adornee = hrp
        end
    end)
end

-- Gỡ hitbox
local function ResetHitbox(char)
    pcall(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if char:GetAttribute("OriginalHRPSize") then
            hrp.Size = char:GetAttribute("OriginalHRPSize")
            hrp.Transparency = char:GetAttribute("OriginalHRPTransparency") or 1
            hrp.CanCollide = char:GetAttribute("OriginalHRPCanCollide") or false
            hrp.Massless = false
            hrp.CustomPhysicalProperties = nil
            char:SetAttribute("OriginalHRPSize", nil)
        else
            hrp.Size = Vector3.new(2,2,1)
            hrp.Transparency = 1
            hrp.Massless = false
        end
        
        local highlight = char:FindFirstChild("HitboxHighlight")
        if highlight then highlight:Destroy() end
    end)
end

-- Áp hitbox cho tất cả
local function UpdateAll()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if HitboxEnabled then
                ApplyHitbox(plr.Character)
            else
                ResetHitbox(plr.Character)
            end
        end
    end
end

-- Hook player
local function HookPlayer(plr)
    if plr == LocalPlayer then return end
    
    if Connections[plr] then
        Connections[plr]:Disconnect()
        Connections[plr] = nil
    end
    
    if RemoveConnections[plr] then
        RemoveConnections[plr]:Disconnect()
        RemoveConnections[plr] = nil
    end

    if HitboxEnabled and plr.Character then
        task.wait(0.5)
        ApplyHitbox(plr.Character)
    end
    
    Connections[plr] = plr.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if HitboxEnabled then
            ApplyHitbox(char)
        end
    end)
    
    RemoveConnections[plr] = plr.AncestryChanged:Connect(function(_, parent)
        if not parent then
            if Connections[plr] then Connections[plr]:Disconnect() end
            if RemoveConnections[plr] then RemoveConnections[plr]:Disconnect() end
            Connections[plr] = nil
            RemoveConnections[plr] = nil
        end
    end)
end

-- Hook hiện tại
for _,plr in pairs(Players:GetPlayers()) do
    HookPlayer(plr)
end

Players.PlayerAdded:Connect(HookPlayer)

-- Cleanup khi local rời
LocalPlayer.AncestryChanged:Connect(function(_,parent)
    if not parent then
        for _,c in pairs(Connections) do pcall(function() c:Disconnect() end) end
        for _,c in pairs(RemoveConnections) do pcall(function() c:Disconnect() end) end
    end
end)

-- UI SLIDER
AddSlider(Main,{
    Name = "Hitbox Size",
    MinValue = 5,
    MaxValue = 100,
    Default = 25,
    Increase = 1,
    Callback = function(v)
        HitboxSize = v
        if HitboxEnabled then UpdateAll() end
    end
})

-- UI TOGGLE
AddToggle(Main,{
    Name = "Hitbox",
    Default = false,
    Callback = function(v)
        HitboxEnabled = v
        UpdateAll()
    end
})
local section = AddSection(Main, {"Bầu Trời"})

local Lighting = game:GetService("Lighting")

local SkyID = ""

AddTextBox(Main, {
  Name = "Thay đổi bầu trời",
  Default = "rbxassetid://",
  PlaceholderText = "rbxassetid://",
  ClearText = false,
  Callback = function(Value)
      SkyID = tostring(Value)
  end
})

AddButton(Main, {
  Name = "Áp dụng",
  Callback = function()
      if SkyID == "" then return end
      
      -- tìm sky cũ
      local old = Lighting:FindFirstChildOfClass("Sky")
      if old then
          old:Destroy()
      end

      -- tạo sky mới
      local sky = Instance.new("Sky")
      sky.Name = "CustomSky"
      sky.SkyboxBk = SkyID
      sky.SkyboxDn = SkyID
      sky.SkyboxFt = SkyID
      sky.SkyboxLf = SkyID
      sky.SkyboxRt = SkyID
      sky.SkyboxUp = SkyID
      sky.Parent = Lighting
  end
})
local Lighting = game:GetService("Lighting")

-- Tạo/tìm Atmosphere
local Atmos = Lighting:FindFirstChildOfClass("Atmosphere")
if not Atmos then
    Atmos = Instance.new("Atmosphere", Lighting)
    Atmos.Parent = Lighting
end

-- Tạo/tìm Sky
local Sky = Lighting:FindFirstChildOfClass("Sky")
if not Sky then
    Sky = Instance.new("Sky")
    Sky.Parent = Lighting
end

-- LƯU GIÁ TRỊ GỐC
local Default = {
    AtmosphereColor = Atmos.Color,
    AtmosphereDecay = Atmos.Decay,
    AtmosphereDensity = Atmos.Density,
    AtmosphereHaze = Atmos.Haze,
    AtmosphereGlare = Atmos.Glare,

    SkyBoxBk = Sky.SkyboxBk,
    SkyBoxDn = Sky.SkyboxDn,
    SkyBoxFt = Sky.SkyboxFt,
    SkyBoxLf = Sky.SkyboxLf,
    SkyBoxRt = Sky.SkyboxRt,
    SkyBoxUp = Sky.SkyboxUp
}

local ColorMap = {
    ["màu đỏ"] = Color3.fromRGB(255, 70, 70),
    ["màu xanh biển"] = Color3.fromRGB(70, 130, 255),
    ["xanh lá"] = Color3.fromRGB(70, 255, 140),
    ["màu hồng"] = Color3.fromRGB(255, 120, 210),
    ["màu đen"] = Color3.fromRGB(20, 20, 20),
    ["màu tím"] = Color3.fromRGB(180, 120, 255),
}

--------------------------------
-- DROPDOWN = ÁP DỤNG NGAY
--------------------------------
AddDropdown(Main, {
    Name = "Chọn màu bầu trời",
    Options = {"màu đỏ","màu xanh biển","xanh lá","màu hồng","màu đen","màu tím","mặc định"},
    Default = "mặc định",

    Callback = function(v)

        -----------------
        -- TRẢ VỀ MẶC ĐỊNH
        -----------------
        if v == "mặc định" then
            
            Atmos.Color = Default.AtmosphereColor
            Atmos.Decay = Default.AtmosphereDecay
            Atmos.Density = Default.AtmosphereDensity
            Atmos.Haze = Default.AtmosphereHaze
            Atmos.Glare = Default.AtmosphereGlare

            Sky.SkyboxBk = Default.SkyBoxBk
            Sky.SkyboxDn = Default.SkyBoxDn
            Sky.SkyboxFt = Default.SkyBoxFt
            Sky.SkyboxLf = Default.SkyBoxLf
            Sky.SkyboxRt = Default.SkyBoxRt
            Sky.SkyboxUp = Default.SkyBoxUp

            return
        end

        -----------------
        -- ĐỔI MÀU
        -----------------
        local col = ColorMap[v]
        if not col then return end
        
        Atmos.Color = col
        Atmos.Decay = Color3.new(1,1,1)
        Atmos.Density = 0.35
        Atmos.Haze = 0.8
        Atmos.Glare = 0.5

        -- Sky đổi về nền trơn
        local id = "rbxassetid://7018684000"
        Sky.SkyboxBk = id
        Sky.SkyboxDn = id
        Sky.SkyboxFt = id
        Sky.SkyboxLf = id
        Sky.SkyboxRt = id
        Sky.SkyboxUp = id

        -- ColorCorrection nhẹ
        local CC = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if not CC then
            CC = Instance.new("ColorCorrectionEffect")
            CC.Parent = Lighting
        end
        CC.TintColor = col
    end
})
AddButton(Main, {
  Name = "Bầu Trời 666",
  Callback = function()
    SetSkybox();
  end
})
AddButton(Main, {
  Name = "Bầu Trời Linh tinh;)",
  Callback = function()
    Hoho();
  end
})
AddButton(Main, {
  Name = "Trời Tối",
  Callback = function()
    NightFE();
  end
})
AddButton(Main, {
  Name = "Trời Sáng",
  Callback = function()
    MorningFE();
  end
})
local section = AddSection(Main, {"Vật Thể"})

AddButton(Main, {
  Name = "666",
  Callback = function()
    ApplyTextureToEverything();
  end
})
AddButton(Main, {
  Name = "Btools nhà làm:)",
  Callback = function()
    -- FE Building Tools (Client-Side)
-- Works only for LocalPlayer objects

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Backpack = LP:WaitForChild("Backpack")

-- ===== TOOL: CLONE =================================================

local Clone = Instance.new("Tool")
Clone.Name = "Nhân Bản"
Clone.RequiresHandle = false
Clone.Parent = Backpack

Clone.Activated:Connect(function()
	local target = Mouse.Target
	if target and target:IsDescendantOf(workspace) then
		local copy = target:Clone()
		copy.Parent = workspace
		copy.CFrame = target.CFrame * CFrame.new(0,3,0)
	end
end)

-- ===== TOOL: GRAB / MOVE ===========================================

local Grab = Instance.new("Tool")
Grab.Name = "Kéo"
Grab.RequiresHandle = false
Grab.Parent = Backpack

local grabbed = nil
Grab.Activated:Connect(function()
	if not grabbed then
		grabbed = Mouse.Target
	else
		grabbed = nil
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if grabbed then
		grabbed.CFrame = CFrame.new(Mouse.Hit.Position)
	end
end)

-- ===== TOOL: HAMMER (DELETE) =======================================

local Hammer = Instance.new("Tool")
Hammer.Name = "Xóa"
Hammer.RequiresHandle = false
Hammer.Parent = Backpack

Hammer.Activated:Connect(function()
	local target = Mouse.Target
	if target and target:IsDescendantOf(workspace) then
		target:Destroy()
	end
end)

print("BTools Loaded")
  end
})
local section = AddSection(Main, {"Kick Người Chơi(Thử Nghiệm)"})
local Players = game:GetService("Players")

local TargetName = ""

AddTextBox(Main, {
    Name = "Player cần kick",
    Default = "",
    PlaceholderText = "Nhập tên player...",
    ClearText = false,
    Callback = function(Value)
        TargetName = Value
    end
})

AddButton(Main, {
    Name = "Kick Player",
    Callback = function()
        if TargetName == "" then
            warn("Chưa nhập tên")
            return
        end
        
        for _,plr in ipairs(Players:GetPlayers()) do
            if string.lower(plr.Name):find(string.lower(TargetName)) then
                plr:Kick("Bạn đã bị kick")
                break
            end
        end
    end
})

local section = AddSection(Main, {"Chức năng khác"})

AddButton(Main, {
  Name = "Triệu Hồi Zombie",
  Callback = function()
    local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- Spawn zombie trước mặt 10 studs
SpawnZombie(hrp.Position + hrp.CFrame.LookVector * 10)
  end
})
AddButton(Main, {
  Name = "Biến Thành Zombie",
  Callback = function()
    beZombie();
  end
})
AddButton(Main, {
  Name = "Triệu Hồi Ma",
  Callback = function()
    ghost();
  end
})
AddButton(Main, {
  Name = "Biến Thành Ma",
  Callback = function()
    BecomeGhost();
  end
})
AddButton(Main, {
  Name = "Spawn Dummy",
  Callback = function()
    SpawnDummyInFront(plr);
  end
})
AddButton(Main, {
  Name = "Đốt Cháy Người Chơi",
  Callback = function()
    Burn();
  end
})
AddButton(Main, {
  Name = "Spawn Kiếm Laser",
  Callback = function()
    laser();
  end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GodModeEnabled = false
local OldDiedConn

local Toggle = AddToggle(Main, {
    Name = "Toggle Bất Tử",
    Default = false,
    Callback = function(Value)
        GodModeEnabled = Value
        
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:FindFirstChild("Humanoid")

        if not hum then return end

        if GodModeEnabled then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            
            -- Ngăn chết
            OldDiedConn = hum.Died:Connect(function()
                task.wait(0.1)
                LocalPlayer:LoadCharacter()
            end)

        else
            -- Tắt bất tử → trả lại bình thường
            hum.MaxHealth = 100
            hum.Health = 100
            
            if OldDiedConn then
                OldDiedConn:Disconnect()
                OldDiedConn = nil
            end
        end
    end
})
AddButton(Main, {
  Name = "Spawn Ak-47",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/sinret/rbxscript.com-scripts-reuploads-/main/ak47", true))()
  end
})
AddButton(Main, {
  Name = "Shader Đơn",
  Callback = function()
    --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet("https://raw.githubusercontent.com/p0e1/1/refs/heads/main/SimpleShader.lua"))()
  end
})
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local chatEnabled = true

local Toggle = AddToggle(Main, {
    Name = "Bật / Tắt Chat",
    Default = true,
    Callback = function(Value)
        chatEnabled = Value
        
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, chatEnabled)
    end
})
local StarterGui = game:GetService("StarterGui")

AddButton(Main, {
    Name = "Mở bảng Emote",
    Callback = function()
        pcall(function()
            StarterGui:SetCore("ShowEmotesMenu")
        end)
    end
})
AddButton(Charac, {
  Name = "Esp người Chơi",
  Callback = function()
    esp();
  end
})
