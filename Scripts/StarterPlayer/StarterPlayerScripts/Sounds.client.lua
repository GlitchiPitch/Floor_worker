
local event = game.ReplicatedStorage.Events.SoundEvent

local sounds = require(game.ReplicatedStorage.Modules.Sounds)

-- playe ambient

event.OnClientEvent:Connect(sounds.playSound)