
local event = game.ReplicatedStorage.SoundEvent

local sounds = require(game.ReplicatedStorage.Modules.Sounds)
event.OnClientEvent:Connect(sounds.playSound)