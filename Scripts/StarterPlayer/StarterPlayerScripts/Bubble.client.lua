local textChatService = game:GetService("TextChatService")

local player = game.Players.LocalPlayer
local bubbles 	= require(game.ReplicatedStorage.Bubbles).playerBubbles
local events = game.ReplicatedStorage.Events
local bubbleEvent = events.Bubble

function showBubble(head: BasePart, message: string)
    if head then
        textChatService:DisplayBubble(head, message)
    else
        local character = player.Character
        if not character then return end
        head = character:FindFirstChild('Head')
        textChatService:DisplayBubble(head, bubbles[message])
    end
end

bubbleEvent.OnClientEvent:Connect(showBubble)