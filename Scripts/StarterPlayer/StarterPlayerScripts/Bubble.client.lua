local textChatService = game:GetService("TextChatService")
local events = game.ReplicatedStorage.Events
local bubbleEvent = events.BubbleEvent

function showBubble(head: BasePart, message: string)
    textChatService:DisplayBubble(head, message)
end

bubbleEvent.OnClientEvent:Connect(showBubble)