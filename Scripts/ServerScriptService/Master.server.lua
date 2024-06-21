--[[

	налоги, выход наружу через взятку
	добавить дверь с надзирателем, которому нужно дать взятку чтобы выйти и голод
	голод утолять черным хлебом, который тоже надо покупать
]]

-- services
local tweenService = game:GetService('TweenService')

-- modules
local modules = game.ServerScriptService.Modules
local colorLevels = require(modules.ColorLevels)
local conveyor = require(modules.Conveyor)
local utils = require(modules.Utils)

-- workspace
local conveyorFolder = workspace.Conveyor
local colorLevelModels = workspace.ColorLevels
local moneyFolder = workspace.Money
local foodFolder = workspace.Food

-- item spawners
local foodSpawner = workspace.FoodSpawner.Attachment
local moneySpawner = workspace.MoneySpawner.Attachment

-- items
local bread = game.ServerStorage.Food
local coin = game.ServerStorage.Money

-- vars
local colorLevelValue = 10
local colorLevelTileSize = 29 / 10
local colorList = {
	BrickColor.new('Persimmon'),
	BrickColor.new('Gold'),
	BrickColor.new('Cyan'),
	BrickColor.new('Magenta'),
}

-- events
local soundEvent = game.ReplicatedStorage.SoundEvent
local bindEvent = game.ServerStorage.Event

local currentColor = script.CurrentColor
local leaderstats = script.leaderstats

function changePlayerPoints() 
	leaderstats.points.Value += 1
	utils.spawnItem(coin, moneyFolder, moneySpawner)
end

function spawnFood()
	utils.spawnItem(bread, foodFolder, foodSpawner)
end

function onPlayerAdded(player: Player) leaderstats.Parent = player end

game.Players.PlayerAdded:Connect(onPlayerAdded)

colorLevels.init({
	colorLevelValue = colorLevelValue,
	colorLevelModels = colorLevelModels,
	colorList = colorList,
	colorLevelTileSize = colorLevelTileSize,
	soundEvent = soundEvent,
	bindEvent = bindEvent,
})

conveyor.init(conveyorFolder, {
	currentColor = currentColor,
	colorList = colorList, 
	soundEvent = soundEvent,
	bindEvent = bindEvent,
	changePlayerPoints = changePlayerPoints,
})




