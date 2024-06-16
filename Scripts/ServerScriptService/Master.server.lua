--[[

	налоги, выход наружу через взятку
	добавить дверь с надзирателем, которому нужно дать взятку чтобы выйти и голод
	голод утолять черным хлебом, который тоже надо покупать
]]

local tweenService = game:GetService('TweenService')

local modules = game.ServerScriptService.Modules
local colorLevels = require(modules.ColorLevels)
local conveyor = require(modules.Conveyor)

local conveyorFolder = workspace.Conveyor
local colorLevelsFolder = workspace.ColorLevels

local foodSpawner = workspace.FoodSpawner.Attachment
local bread = game.ServerStorage.Food

local moneySpawner = workspace.MoneySpawner.Attachment
local moneyFolder = workspace.Money_
local coin = game.ServerStorage.Money

local colorLevelValue = 10
local colorLevelTileSize = 29 / 10

local soundEvent = game.ReplicatedStorage.SoundEvent
local bindEvent = game.ServerStorage.Event

local currentColor = script.CurrentColor

local player
local leaderstats = script.leaderstats

function onPlayerAdded(player_: Player)
	player = player_ 
	leaderstats.Parent = player
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

colorLevels.init(colorLevelsFolder, {
	colorLevelValue = colorLevelValue,
	colorLevelTileSize = colorLevelTileSize,
	soundEvent = soundEvent,
	bindEvent = bindEvent,
})

conveyor.init(conveyorFolder, {
	currentColor = currentColor,
	soundEvent = soundEvent,
	bindEvent = bindEvent,
})




