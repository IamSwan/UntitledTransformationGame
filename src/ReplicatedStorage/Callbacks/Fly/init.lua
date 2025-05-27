-- Client

local cooldownModule = require(game.ReplicatedStorage.Modules.Cooldown)

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)
local alienStats = require(game.ReplicatedStorage.Configs.AliensStats)

local GRAVITY = Vector3.new(0, workspace.Gravity, 0)

local function onFlyUpdate()
    local character = player.Character
    if not character then
        return
    end

    local vectorForce = character.PrimaryPart:FindFirstChild("FlyVector")
    if not vectorForce then
        warn("FlyVector not found in character's PrimaryPart.")
        return
    end
    local alignOrientation = character.PrimaryPart:FindFirstChild("AlignOrientation")
    if not alignOrientation then
        warn("AlignOrientation not found in character's PrimaryPart.")
        return
    end

    local camera = workspace.CurrentCamera
    if not camera then
        warn("CurrentCamera not found in workspace.")
        return
    end

    local cameraDirection = camera.CFrame.LookVector
    local moveDirection = character.Humanoid.MoveDirection

    local moveVector = Vector3.new(moveDirection.X, 0, moveDirection.Z)

    -- Apply gravity
    vectorForce.Force = GRAVITY * character.PrimaryPart.AssemblyMass

    local flySpeed = 50
    local aStats = alienStats[player.Character:GetAttribute("Alien")]

    if aStats then
        flySpeed = aStats.FlySpeed or 50
    end

    if moveDirection.Magnitude > 0 then
        -- Calculate the desired movement direction based on camera orientation
        local desiredDirection = moveVector
        -- Apply the force in the desired direction

        vectorForce.Force += desiredDirection * flySpeed * character.PrimaryPart.AssemblyMass
    end

    if player.Character:GetAttribute("FlyUp") then
        vectorForce.Force += Vector3.new(0, flySpeed, 0) * character.PrimaryPart.AssemblyMass
    end
    if player.Character:GetAttribute("FlyDown") then
        vectorForce.Force += Vector3.new(0, -flySpeed, 0) * character.PrimaryPart.AssemblyMass
    end

    -- Rotate the character properly
    alignOrientation.CFrame = CFrame.new(Vector3.new(0, 0, 0), cameraDirection)

    -- apply drag
    if character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 0 then
        local dragCoefficient = 1.2
        local dragVector = -character.HumanoidRootPart.AssemblyLinearVelocity.Unit
        local dragCurve = character.HumanoidRootPart.AssemblyLinearVelocity.Magnitude ^ 1.2
        vectorForce.Force += dragVector * dragCoefficient * character.PrimaryPart.AssemblyMass * dragCurve
    end
end

local function startFly()
    local character = player.Character
    if not character then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    local vectorForce = script:FindFirstChild("VectorForce"):Clone()
    vectorForce.Name = "FlyVector"
    vectorForce.Enabled = true
    vectorForce.Parent = character.PrimaryPart
    vectorForce.Attachment0 = character.PrimaryPart:FindFirstChild("RootAttachment") or Instance.new("Attachment", character.PrimaryPart)
    local alignOrientation = script:FindFirstChild("AlignOrientation"):Clone()
    alignOrientation.Parent = character.PrimaryPart
    alignOrientation.Attachment0 = character.PrimaryPart:FindFirstChild("RootAttachment") or Instance.new("Attachment", character.PrimaryPart)
    alignOrientation.Enabled = true
    inputBinder:BindAction("FlyUp", { Enum.KeyCode.Space })
    inputBinder:BindAction("FlyDown", { Enum.KeyCode.LeftAlt })
    local connection = nil
    connection = runService.Heartbeat:Connect(function()
        if not character:GetAttribute("Flying_local") then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            return
        end
        onFlyUpdate()
    end)
end

local function stopFly()
    local character = player.Character
    local vectorForce = character.HumanoidRootPart:FindFirstChild("FlyVector")
    if vectorForce then
        vectorForce:Destroy()
    end
    local alignOrientation = character.HumanoidRootPart:FindFirstChild("AlignOrientation")
    if alignOrientation then
        alignOrientation:Destroy()
    end
    character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
    character:SetAttribute("FlyUp", nil)
    character:SetAttribute("FlyDown", nil)
    inputBinder:UnbindAction("FlyUp")
    inputBinder:UnbindAction("FlyDown")
end

return function(action: string, state: Enum.UserInputState, inputObject: InputObject)
	if state ~= Enum.UserInputState.Begin then
		return
	end

    if player.Character:GetAttribute("Flying_local") then
        player.Character:SetAttribute("Flying_local", nil)
        stopFly()
        game.ReplicatedStorage.Remotes.ActionRemote:FireServer("Fly", state)
        return Enum.ContextActionResult.Sink
    end

	if not cooldownModule:IsFinished(game.Players.LocalPlayer, "Busy") then
		print("busy.")
		return
	end

    player.Character:SetAttribute("Flying_local", true)
    startFly()

    game.ReplicatedStorage.Remotes.ActionRemote:FireServer("Fly", state)

	return Enum.ContextActionResult.Sink
end
