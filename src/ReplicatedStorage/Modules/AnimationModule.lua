local ReplicatedStorage = game:GetService("ReplicatedStorage")
local animModule = {}

local animations: { [string]: AnimationTrack } = {}
local priorities: { [string]: Enum.AnimationPriority } = {}

local player = game.Players.LocalPlayer

function animModule:addAnimation(name: string, id: string, looped: boolean, priority: Enum.AnimationPriority?)
	if animations[name] then
		return
	end
	local animation = Instance.new("Animation")
	local animator = player.Character.Humanoid.Animator
	local track: AnimationTrack = nil

	if looped == nil then
		looped = true
	end
	animation.AnimationId = id
	track = animator:LoadAnimation(animation)
	if track then
		track.Looped = looped
		priorities[name] = priority or Enum.AnimationPriority.Action
		animations[name] = track
	end
end

function animModule:getTrack(name: string): AnimationTrack
	return animations[name]
end

function animModule:Stop(name: string, delay: number?)
	local track: AnimationTrack = animations[name]
	if not track then
		return
	end
	track:AdjustWeight(0, delay)
	task.delay(delay, function()
		track:Stop()
	end)
end

function animModule:Play(name: string, delay: number?, speed: number?)
	local track: AnimationTrack = animations[name]
	if not track then
		return
	end
	track:Play(delay)
	track.Priority = priorities[name]
	if speed then
		track:AdjustSpeed(speed)
	end
end

function animModule:setNewId(name: string, id: string, player: Player?)
	if game:GetService("RunService"):IsServer() then
		game.ReplicatedStorage.Remotes.AnimationRemote:FireClient(player, name, id)
		return
	end
	if #id == 0 then
		if animations[name] then
			animations[name]:Stop()
			animations[name]:Destroy()
		end
		animations[name] = nil
		return
	end
	local track: AnimationTrack = animations[name]
	local animation = Instance.new("Animation")
	animation.AnimationId = id
	if track then
		track:Stop()
	end
	animations[name] = nil
	if track then
		self:addAnimation(name, id, track.Looped, priorities[name])
		track:Destroy()
	else
		self:addAnimation(name, id, true, priorities[name])
	end
end

function animModule:StopAll(delay: number?)
	for index, value in pairs(animations) do
		local track: AnimationTrack = animations[index]
		if not track then
			return
		end
		track:AdjustWeight(0, delay)
		task.delay(delay, function()
			track:Stop()
		end)
	end
end

function animModule:getAllTracks()
	return animations
end

function animModule:refresh()
	for index, value in pairs(animations) do
		local anim = animations[index].Animation
		animations[index] = player.Character.Humanoid.Animator:LoadAnimation(anim)
	end
end

if game:GetService("RunService"):IsClient() then
	game.ReplicatedStorage.Remotes.AnimationRemote.OnClientEvent:Connect(function(name: string, id: string)
		animModule:setNewId(name, id)
	end)
end

return animModule
