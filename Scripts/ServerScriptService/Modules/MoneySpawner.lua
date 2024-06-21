local modules = game.ServerScriptService.Modules
local utils = require(modules.Utils)

local data: {
    playerMoney: IntValue,
    moneySpawnerModel: Model | Folder,
    moneyModel: BasePart,
}

local moneySpawner: {
    spawnPoint: Attachment,
    spawnButton: BasePart,
    moneyModel: BasePart,
    moneyFolder: Folder,
}

function setupSpawner()
    data.playerMoney.Changed:Connect(function(value: number)
        local coins = moneySpawner.moneyFolder:GetChildren() :: {BasePart}
        if #coins < value then
            utils.spawnItem(moneySpawner.moneyModel, moneySpawner.moneyFolder, moneySpawner.spawnPoint)
        elseif #coins > value then
            coins[1]:Destroy()
        end
    end)
end

function init(data_)
    data = data_

    moneySpawner = {
        spawnPoint = data.moneySpawnerModel.Attachment,
        moneyFolder = data.moneySpawnerModel.Money,
        moneyModel = data.moneyModel,
    }

    setupSpawner()

end

return {
    init = init,
}