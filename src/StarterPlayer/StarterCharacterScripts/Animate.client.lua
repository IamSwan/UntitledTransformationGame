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
    local isFlying = player.Character:GetAttribute("Flying_local")

    if isFlying then
        animationsModule:Stop("Idle", .1)
        animationsModule:Stop("Walk", .1)
        animationsModule:Stop("Run", .1)
        if math.round(moveMag) == 0 then
            if animationsModule:getTrack("FlyIdle") and not animationsModule:getTrack("FlyIdle").IsPlaying then
                animationsModule:Stop("FlyForward", .1)
                animationsModule:Play("FlyIdle")
            end
        else
            if animationsModule:getTrack("FlyForward") and not animationsModule:getTrack("FlyForward").IsPlaying then
                animationsModule:Stop("FlyIdle", .1)
                animationsModule:Play("FlyForward")
            end
        end
        return
    else
        if animationsModule:getTrack("FlyIdle") and animationsModule:getTrack("FlyIdle").IsPlaying then
            animationsModule:Stop("FlyIdle", .1)
        end
        if animationsModule:getTrack("FlyForward") and animationsModule:getTrack("FlyForward").IsPlaying then
            animationsModule:Stop("FlyForward", .1)
        end
    end

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
