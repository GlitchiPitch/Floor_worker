local soundService = game.SoundService
local runService = game:GetService("RunService")

local sounds: {
	backingTrack: Sound | string,
	conveyor: Sound | string,
	brokenConveyor: Sound | string,
	accept: Sound | string,
	error: Sound | string,
	getCoin: Sound | string,
	getFood: Sound | string,
	getColorTool: Sound | string,
	liquidLevel: Sound | string,
	pushButton: Sound | string,
}

if runService:IsClient() then
	sounds = {
		backingTrack = soundService.BackingTrack,
		conveyor = soundService.Conveyor,
		brokenConveyor = soundService.BrokenConveyor,
		accept = soundService.Accept,
		error = soundService.Error,
		getCoin = soundService.GetCoin,
		getFood = soundService.GetFood,
		getColorTool = soundService.GetColorTool,
		liquidLevel = soundService.LiquidLevel,
		pushButton = soundService.PushButton,
	}

	function playSound(soundName: string)
		if not sounds[soundName].Playing then
			sounds[soundName]:Play()
		elseif sounds[soundName].Playing then
			sounds[soundName]:Stop()
		end
	end

	return {
		playSound = playSound,
	}
elseif runService:IsServer() then
	sounds = {
		backingTrack = "backingTrack",
		conveyor = "conveyor",
		brokenConveyor = "brokenConveyor",
		accept = "accept",
		error = "error",
		getCoin = "getCoin",
		getFood = "getFood",
		getColorTool = "getColorTool",
		liquidLevel = "liquidLevel",
		pushButton = "pushButton",
	}

	return sounds
end
