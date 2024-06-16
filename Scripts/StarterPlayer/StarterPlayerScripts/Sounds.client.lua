local soundService = game.SoundService
local event = game.ReplicatedStorage.SoundEvent
local sounds = {
	no = soundService.no,
	click = soundService.click,
	yes = soundService.yes,
}

function onEvent(key) sounds[key]:Play() end

event.OnClientEvent:Connect(onEvent)