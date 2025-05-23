--|| Services ||--
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

--|| Modules ||--
local modules = replicatedStorage.Modules
local animationsModule = require(modules.AnimationModule)

--|| Variables ||--
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid: Humanoid = character:WaitForChild("Humanoid")

local state = ""

--|| Functions ||--

local function onHeartbeat()
	local moveMag = humanoid.MoveDirection.Magnitude
	local isJumping = humanoid:GetState() == Enum.HumanoidStateType.Jumping

	if math.round(moveMag) == 0 and not isJumping then
		if not animationsModule:getTrack("Idle").IsPlaying then
			animationsModule:Stop("Walk", .1)
			animationsModule:Stop("Run", .1)
			animationsModule:Play("Idle")
			state = "Idle"
		end
    elseif moveMag > 0 and not isJumping then
        if player.Character:GetAttribute("Sprinting") then
            if not animationsModule:getTrack("Run").IsPlaying then
                animationsModule:Stop("Idle", .1)
                animationsModule:Stop("Walk", .1)
                animationsModule:Play("Run")
                state = "Run"
            end
        else
            if not animationsModule:getTrack("Walk").IsPlaying then
                animationsModule:Stop("Idle", .1)
                animationsModule:Stop("Run", .1)
                animationsModule:Play("Walk")
                state = "Walk"
            end
        end
	end
end

runService.Heartbeat:Connect(onHeartbeat)
