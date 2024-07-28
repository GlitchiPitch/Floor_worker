-- modules
local modules = game.ServerScriptService.Modules

local config 	= require(game.ServerScriptService.Config)
local types 	= require(game.ServerScriptService.Types)

local moneySpawner 	= require(modules.MoneySpawner)
local foodSpawner 	= require(modules.FoodSpawner)
local colorLevels 	= require(modules.ColorLevels)
local conveyor 		= require(modules.Conveyor)
local warden 		= require(modules.Warden)

-- workspace
local conveyorFolder: Folder & {IsWorking: BoolValue} = workspace.Conveyor
local colorLevelModels: Folder = workspace.ColorLevels
local wardenPath: {
	Patrol: Part,
	Conveyor: Part,
	Exit: Part,
	Seat: Part,
} = workspace.WardenPath

-- item spawners
local foodSpawnerModel = workspace.FoodSpawner
local moneySpawnerModel = workspace.MoneySpawner

-- items
local bread = game.ServerStorage.Food
local coin = game.ServerStorage.Money
local spawnedItems = game.ServerStorage.Template
local exitDoor = workspace.ExitDoor :: Part & types.InteractObject
local matress = workspace.Matress:: MeshPart & types.InteractObject
--npc
local wardenModel: Model = workspace.Warden
local player

-- vars
local colorLevelAmount = 10
local colorLevelTileSize = 29 / 10


-- events
local events = game.ReplicatedStorage.Events
local bindEvent = game.ServerStorage.Event

-- varObjects
local currentColor = Instance.new('BrickColorValue')
local leaderstats = Instance.new('Folder')
local points = Instance.new('IntValue')
local dailyNorm = Instance.new('IntValue')

leaderstats.Name = 'leaderstats'
points.Name = 'Coins'

function changePlayerPoints(value: number) points.Value += value end

function onPlayerAdded(player_: Player) 
	player = player_
	points.Parent = leaderstats
	leaderstats.Parent = player 

end

function startDay()
	matress.Attachment.ProximityPrompt.Enabled = false
	dailyNorm.Value = 10
end

function finishDay()
	matress.Attachment.ProximityPrompt.Enabled = true
	matress.Attachment.ProximityPrompt.Triggered:Once(function(player: Player)
		local humanoid = player.Character.Humanoid
		humanoid.WalkSpeed = 0
		events.BlackScreen:FireClient(player)
		task.wait(5)
		events.BlackScreen:FireClient(player)
		humanoid.WalkSpeed = 16
		startDay()
	end)

end

function exitDoorTriggered(player: Player)
	if wardenModel.Parent ~= workspace then
		player:Kick("Great job you escaped")
	end
end

function dailyNormChanged(value: number)
	if value == 0 then
		finishDay()
	end
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

foodSpawner.init({
	changePlayerPoints 	= changePlayerPoints,
	playerMoney 		= points,
	foodSpawnerModel 	= foodSpawnerModel,
	soundEvent 			= events.Sound,
	foodModel 			= bread,
})

moneySpawner.init({
	playerMoney 		= points,
    moneySpawnerModel 	= moneySpawnerModel,
	soundEvent 			= events.Sound,
    moneyModel 			= coin,
})

colorLevels.init({
	colorLevelAmount 	= colorLevelAmount,
	colorLevelModels 	= colorLevelModels,
	colorList 			= config.colorList,
	colorLevelTileSize 	= colorLevelTileSize,
	soundEvent 			= events.Sound,
	bindEvent 			= bindEvent,
})

conveyor.init(conveyorFolder, {
	changePlayerPoints 	= changePlayerPoints,
	currentColor 		= currentColor,
	colorList 			= config.colorList, 
	soundEvent 			= events.Sound,
	bindEvent 			= bindEvent,
	dailyNorm 			= dailyNorm,
	spawnedItems 		= spawnedItems,
})

warden.init({
	wardenPath 			= wardenPath,
	wardenModel 		= wardenModel,
    player 				= player,
    playerCoins 		= points,
    conveyorIsWorking 	= conveyorFolder.IsWorking,
})

exitDoor.Attachment.ProximityPrompt.Triggered:Connect(exitDoorTriggered)
dailyNorm.Changed:Connect(dailyNormChanged)

startDay()


