-- hamzHub - Walk on Water (buat lu bro)
-- Copy paste FULL code ini ke executor lu

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ================== GUI hamzHub ==================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "hamzHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 320, 0, 180)
mainFrame.Position = UDim2.new(0.5, -160, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -90, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "hamzHub"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- Feature Walk on Water
local featureFrame = Instance.new("Frame")
featureFrame.Size = UDim2.new(1, -20, 0, 85)
featureFrame.Position = UDim2.new(0, 10, 0, 50)
featureFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
featureFrame.BorderSizePixel = 0
featureFrame.Parent = mainFrame

local fCorner = Instance.new("UICorner")
fCorner.CornerRadius = UDim.new(0, 10)
fCorner.Parent = featureFrame

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0.6, 0, 0, 40)
label.Position = UDim2.new(0, 15, 0, 10)
label.BackgroundTransparency = 1
label.Text = "Jalan di Air"
label.TextColor3 = Color3.new(1, 1, 1)
label.TextSize = 18
label.Font = Enum.Font.GothamSemibold
label.TextXAlignment = Enum.TextXAlignment.Left
label.Parent = featureFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 110, 0, 40)
toggleBtn.Position = UDim2.new(1, -125, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = featureFrame

local tCorner = Instance.new("UICorner")
tCorner.CornerRadius = UDim.new(0, 10)
tCorner.Parent = toggleBtn

-- Credit kecil
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -25)
credit.BackgroundTransparency = 1
credit.Text = "Made for you bro • Walk on Water"
credit.TextColor3 = Color3.fromRGB(120, 120, 120)
credit.TextSize = 12
credit.Font = Enum.Font.Gotham
credit.Parent = mainFrame

-- ================== DRAG GUI ==================
local function makeDraggable(frame)
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(mainFrame)

-- ================== LOGIC JALAN DI AIR ==================
local enabled = false
local connection = nil

local function toggleWaterWalk(state)
	enabled = state
	
	if enabled then
		if connection then connection:Disconnect() end
		
		connection = RunService.Heartbeat:Connect(function()
			local char = player.Character
			if not char then return end
			
			local root = char:FindFirstChild("HumanoidRootPart")
			if not root then return end
			
			local rayOrigin = root.Position
			local rayDir = Vector3.new(0, -30, 0)
			
			local params = RaycastParams.new()
			params.FilterDescendantsInstances = {char}
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.IgnoreWater = false
			
			local result = workspace:Raycast(rayOrigin, rayDir, params)
			
			if result and result.Material == Enum.Material.Water then
				local hitY = result.Position.Y
				local desiredY = hitY + 3.5   -- sesuaikan kalo terlalu tinggi/rendah
				local currentY = root.Position.Y
				local diff = desiredY - currentY
				
				local vel = root.Velocity
				
				if math.abs(diff) > 0.4 then
					-- dorong ke permukaan air
					root.Velocity = Vector3.new(vel.X, diff * 45, vel.Z)
				else
					-- tetep di permukaan (ga tenggelam)
					root.Velocity = Vector3.new(vel.X, 0, vel.Z)
				end
			end
		end)
	else
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end
end

-- Toggle button
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	
	if enabled then
		toggleBtn.Text = "ON"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
	else
		toggleBtn.Text = "OFF"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	end
	
	toggleWaterWalk(enabled)
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

print("✅ hamzHub loaded bro! GUI muncul, tinggal ON buat jalan di air 🔥")
