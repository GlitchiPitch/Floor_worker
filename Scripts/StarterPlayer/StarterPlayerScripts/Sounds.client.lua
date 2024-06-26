
local event = game.ReplicatedStorage.Events.SoundEvent

local sounds = require(game.ReplicatedStorage.Modules.Sounds)
event.OnClientEvent:Connect(sounds.playSound)