local reModules = game.ReplicatedStorage.Modules
local modules = game.ServerScriptService.Modules
local events = game.ReplicatedStorage.Events

local dataTypes = require(game.ReplicatedStorage.DataTypes)
local utils = require(game.ReplicatedStorage.Utils)
local types = require(game.ReplicatedStorage.Types)
local sounds = require(reModules.Sounds)

local data: dataTypes.MoneySpawner
local moneySpawner: types.MoneySpawner

function setupSpawner()
    data.playerMoney.Changed:Connect(function(value: number)
        events.Sound:FireAllClients(sounds.getCoin)
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
        spawnPoint      = data.spawnerObject.Attachment,
        moneyFolder     = data.spawnerObject.Money,
        moneyModel      = data.itemObject,
    }

    setupSpawner()

end

return {
    init = init,
}