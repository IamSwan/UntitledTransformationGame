local animModule = {}

local animations: { [string]: AnimationTrack } = {}

local player = game.Players.LocalPlayer

function animModule:addAnimation(name: string, id: string, looped: boolean)
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
		animations[name] = track
		animations[name].Looped = looped
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
	if speed then
		track:AdjustSpeed(speed)
	end
end

function animModule:refresh()
	for index, value in pairs(animations) do
		local anim = animations[index].Animation
		animations[index] = player.Character.Humanoid.Animator:LoadAnimation(anim)
	end
end

return animModule
