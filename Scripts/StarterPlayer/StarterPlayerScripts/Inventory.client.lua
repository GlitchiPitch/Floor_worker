local player = game.Players.LocalPlayer

local events = game.ReplicatedStorage.Events
local playerGui = player.PlayerGui

local inventoryScreen: BillboardGui = playerGui:WaitForChild('InventoryScreen')
local inventoryBox: {
    ClickDetector: ClickDetector,
    ClickBillboard: BillboardGui,
} = workspace:WaitForChild('Inventory')

local inventoryInvoke: RemoteFunction = events.InventoryInvoke

local inventoryButtons: {ImageButton} = {}

function clickToInventoryButton(clickedButton: ImageButton)
    local result = inventoryInvoke:InvokeServer(clickedButton.LayoutOrder)
    clickedButton.Image = result
end

function openInventory()
    inventoryBox.ClickBillboard.Enabled = not inventoryBox.ClickBillboard.Enabled
    inventoryScreen.Enabled = not inventoryScreen.Enabled
end

function init()
    inventoryScreen.Enabled = false
    inventoryScreen.Adornee = inventoryBox

    inventoryBox.ClickDetector.MouseClick:Connect(openInventory)
    inventoryBox.ClickBillboard.Enabled = true

    for i, v in inventoryScreen:GetDescendants() do
        if v:IsA('ImageButton') then
            inventoryButtons[v.LayoutOrder] = v
            v.Activated:Connect(function() clickToInventoryButton(v) end)
        end
    end
end

init()