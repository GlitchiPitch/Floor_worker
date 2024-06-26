local events = game.replicatedStorage.Events
local inventoryInvoke: RemoteFunction = events.InventoryInvoke

local inventory = {}

function server(player: Player, itemIndex: number)

    if inventory[itemIndex] == nil then 
        local currentTool: Tool = player.Character:FindFirstAncestorOfClass('Tool')
        inventory[itemIndex] = currentTool:Clone()
        currentTool:Destroy()
        return currentTool.TextureId
    else
        local currentTool: Tool = inventory[itemIndex]
        inventory[itemIndex] = nil
        currentTool.Parent = player.Character
        return ''
    end
end

inventoryInvoke.OnServerInvoke = server