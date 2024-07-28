
local reModules = game.ReplicatedStorage.Modules
local modules = game.ServerScriptService.Modules
local utils = require(game.ReplicatedStorage.Utils)
local sounds = require(reModules.Sounds)

local dataTypes = require(game.ServerScriptService.DataTypes)
local types = require(game.ServerScriptService.Types)

local data: dataTypes.FoodSpawner
local foodSpawner: types.FoodSpawner

function activateButton()
    if data.playerMoney.Value > 0 then
        data.soundEvent:FireAllClients(sounds.getFood)
        utils.spawnItem(foodSpawner.foodModel, foodSpawner.foodFolder, foodSpawner.spawnPoint)
        data.changePlayerPoints(-1)
    else
        data.soundEvent:FireAllClients(sounds.error)
    end
end

function setupSpawner()
    local clickDetector: ClickDetector = foodSpawner.spawnButton.ClickDetector
    clickDetector.MouseClick:Connect(activateButton)
end

function init(data_)
    data = data_

    foodSpawner = {
        spawnButton     = data.foodSpawnerModel.Button,
        spawnPoint      = data.foodSpawnerModel.Attachment,
        foodFolder      = data.foodSpawnerModel.Food,
        foodModel       = data.foodModel,
        soundEvent      = data.soundEvent,
    }

    setupSpawner()

end

return {
    init = init,
}