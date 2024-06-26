
local reModules = game.ReplicatedStorage.Modules
local modules = game.ServerScriptService.Modules
local utils = require(modules.Utils)
local sounds = require(reModules.Sounds)

local data: {
    playerMoney: IntValue,
    foodSpawnerModel: Model | Folder,
    soundEvent: RemoteEvent,
    foodModel: BasePart,
    changePlayerPoints: (value: number) -> (),
}

local foodSpawner: {
    spawnPoint: Attachment,
    spawnButton: BasePart,
    foodModel: BasePart,
    foodFolder: Folder,
}

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