local events = game.ReplicatedStorage.Events
local inventoryInvoke: RemoteFunction = events.InventoryInvoke

local inventory = {}

function server(player: Player, itemIndex: number)

    if inventory[itemIndex] == nil then 
        local currentTool: Tool = player.Character:FindFirstChildOfClass('Tool')
        if currentTool then 
            inventory[itemIndex] = currentTool:Clone()
            currentTool:Destroy()
            return currentTool.TextureId
        end
        return ''
    else
        local currentTool: Tool = inventory[itemIndex]
        inventory[itemIndex] = nil
        currentTool.Parent = player.Character
        return ''
    end
end

function init()
    inventoryInvoke.OnServerInvoke = server
end

return {
    init = init,
}
