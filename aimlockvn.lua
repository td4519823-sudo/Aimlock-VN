local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local WEAPON_NAME = "Laser Blue"
local REMOTE_NAME = "FireWeapon"
local _G = _G or {}
_G.AimbotEnabled = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LOCDEPZAI_Gui"
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
	syn.protect_gui(ScreenGui)
	ScreenGui.Parent = CoreGui
elseif getguiwrapper then
	ScreenGui.Parent = getguiwrapper()
else
	ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Position = UDim2.new(0.5, -110, 0.4, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "LOCDEPZAI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 35)
MinimizeButton.Position = UDim2.new(1, -35, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -35)
ContentFrame.Position = UDim2.new(0, 0, 0, 35)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 180, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -90, 0.5, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
ToggleButton.Text = "AIMBOT: ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ContentFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

local Footer = Instance.new("TextLabel")
Footer.Name = "Footer"
Footer.Size = UDim2.new(1, 0, 0, 25)
Footer.Position = UDim2.new(0, 0, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Text = "Press [Insert] to Hide"
Footer.TextColor3 = Color3.fromRGB(150, 150, 150)
Footer.TextSize = 10
Footer.Font = Enum.Font.Gotham
Footer.Parent = ContentFrame

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		ContentFrame.Visible = false
		TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 220, 0, 35)}):Play()
		MinimizeButton.Text = "+"
	else
		TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 220, 0, 150)}):Play()
		task.wait(0.15)
		ContentFrame.Visible = true
		MinimizeButton.Text = "-"
	end
end)

ToggleButton.MouseButton1Click:Connect(function()
	_G.AimbotEnabled = not _G.AimbotEnabled
	if _G.AimbotEnabled then
		TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 100)}):Play()
		ToggleButton.Text = "AIMBOT: ON"
	else
		TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 0, 0)}):Play()
		ToggleButton.Text = "AIMBOT: OFF"
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.Insert then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

local function getClosestPlayerToMouse()
	local closestPlayer = nil
	local shortestDistance = math.huge
	local mousePosition = UserInputService:GetMouseLocation()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			if player.Team == nil or player.Team ~= LocalPlayer.Team then
				local head = player.Character.Head
				local screenPosition, onScreen = Camera:WorldToViewportPoint(head.Position)
				
				if onScreen then
					local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude
					if distance < shortestDistance then
						shortestDistance = distance
						closestPlayer = player
					end
				end
			end
		end
	end
	return closestPlayer
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end
	if not _G.AimbotEnabled then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local character = LocalPlayer.Character
		if not character or not character.PrimaryPart then return end
		
		local weapon = character:FindFirstChild(WEAPON_NAME) or (LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild(WEAPON_NAME))
		if not weapon then return end
		
		local fireRemote = weapon:FindFirstChild(REMOTE_NAME)
		if not fireRemote then return end
		
		local targetPlayer = getClosestPlayerToMouse()
		
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
			local targetHead = targetPlayer.Character.Head
			local currentPos = character.PrimaryPart.Position
			local originPosition = vector.create(currentPos.X, currentPos.Y, currentPos.Z)
			local rawDirection = (targetHead.Position - currentPos).Unit
			local directionVector = vector.create(rawDirection.X, rawDirection.Y, rawDirection.Z)
			
			local args = {
				originPosition,
				directionVector
			}
			
			fireRemote:FireServer(unpack(args))
		end
	end
end)
