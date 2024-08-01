
local reModules = game.ReplicatedStorage.Modules
local modules = game.ServerScriptService.Modules
local utils = require(game.ReplicatedStorage.Utils)
local sounds = require(reModules.Sounds)
local events = game.ReplicatedStorage.Events

local dataTypes = require(game.ReplicatedStorage.DataTypes)
local types = require(game.ReplicatedStorage.Types)

local data: dataTypes.FoodSpawner
local foodSpawner: types.FoodSpawner

function activateButton()
    if data.playerMoney.Value > 0 then
        events.Sound:FireAllClients(sounds.getFood)    
        data.changePlayerPoints(-1)
        utils.spawnItem(foodSpawner.foodModel, foodSpawner.foodFolder, foodSpawner.spawnPoint)
    else
        events.Sound:FireAllClients(sounds.error)
    end
end

function setupSpawner()
    local clickDetector: ClickDetector = foodSpawner.spawnButton.ClickDetector
    clickDetector.MouseClick:Connect(activateButton)
end

function init(data_)
    data = data_

    foodSpawner = {
        spawnButton     = data.spawnerObject.Button,
        spawnPoint      = data.spawnerObject.Attachment,
        foodFolder      = data.spawnerObject.Food,
        foodModel       = data.itemObject,
    }

    setupSpawner()

end

return {
    init = init,
}