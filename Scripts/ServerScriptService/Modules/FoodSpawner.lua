
local modules = game.ServerScriptService.Modules
local utils = require(modules.Utils)

local data: {
    playerMoney: IntValue,
    foodSpawnerModel: Model | Folder,
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
        utils.spawnItem(foodSpawner.foodModel, foodSpawner.foodFolder, foodSpawner.spawnPoint)
        data.changePlayerPoints(-1)
    end
end

function setupSpawner()
    local clickDetector: ClickDetector = foodSpawner.spawnButton.ClickDetector
    clickDetector.MouseClick:Connect(activateButton)
end

function init(data_)
    data = data_

    foodSpawner = {
        spawnButton = data.foodSpawnerModel.Button,
        spawnPoint = data.foodSpawnerModel.Attachment,
        foodFolder = data.foodSpawnerModel.Food,
        foodModel = data.foodModel,
    }

    setupSpawner()

end

return {
    init = init,
}