-- modules
local modules = game.ServerScriptService.Modules

local config 	= require(game.ServerScriptService.Config)
local dataTypes = require(game.ReplicatedStorage.DataTypes)
local types 	= require(game.ReplicatedStorage.Types)
local bubbles 	= require(game.ReplicatedStorage.Bubbles)

local moneySpawner 	= require(modules.MoneySpawner)
local foodSpawner 	= require(modules.FoodSpawner)
local colorLevels 	= require(modules.ColorLevels)
local conveyor 		= require(modules.Conveyor)
local warden 		= require(modules.Warden)

-- workspace
local conveyorFolder: Folder & {IsWorking: BoolValue} = workspace.Conveyor
local colorLevelModels: Folder = workspace.ColorLevels
local wardenPath: types.WardenPath = workspace.WardenPath
local calendar: Part & {SurfaceGui: SurfaceGui} = workspace.Calendar
local bribePlate: MeshPart & {Attachment: Attachment & {ProximityPrompt: ProximityPrompt}} = workspace.BribePlate

-- item spawners
local foodSpawnerObject = workspace.FoodSpawner
local moneySpawnerObject = workspace.MoneySpawner

-- items
local dayStar = game.ServerStorage.Star :: ImageLabel
local bread = game.ServerStorage.Food :: MeshPart
local coin = game.ServerStorage.Money :: MeshPart
local spawnedItems = game.ServerStorage.Template :: Model
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
local bribeEvent = events.Bribe
local bubbleEvent = events.Bubble

-- varObjects
local currentColor = Instance.new('BrickColorValue')
local leaderstats = Instance.new('Folder')
local points = Instance.new('IntValue')
local dailyNorm = Instance.new('IntValue')

leaderstats.Name = 'leaderstats'
points.Name = 'Coins'

function changePlayerPoints(value: number) 
	points.Value += value

end

function onPlayerAdded(player_: Player) 
	player = player_
	points.Parent = leaderstats
	leaderstats.Parent = player 

end

function startDay()
	dayStar:Clone().Parent = calendar.SurfaceGui
	matress.Attachment.ProximityPrompt.Enabled = false
	dailyNorm.Value = 5
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

function bribePlateTriggered(player: Player)
	bribeEvent:FireClient(player)
end

function getBribe(player: Player, bribeAmount: number)
	bribeAmount = tonumber(bribeAmount)
	if not bribeAmount then return end
	if points.Value >= bribeAmount then
		for i = 1, bribeAmount do
			changePlayerPoints(-1)
		end
		bubbleEvent:FireClient(player, wardenModel.Head, bubbles.wardenBubbles.getBribe[math.random(#bubbles.wardenBubbles.getBribe)])
	else
		bubbleEvent:FireClient(player, wardenModel.Head, bubbles.wardenBubbles.notEnoughMoney)
	end
end

function dailyNormChanged(value: number)
	if value == 0 then
		finishDay()
	end
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

local foodSpawnerData: dataTypes.FoodSpawner = {
	changePlayerPoints = changePlayerPoints,
	spawnerObject = foodSpawnerObject,
	playerMoney = points,
	itemObject = bread,
}

local moneySpawnerData: dataTypes.MoneySpawner = {
	spawnerObject = moneySpawnerObject,
	playerMoney = points,
	itemObject = coin,
}

foodSpawner.init(foodSpawnerData)
moneySpawner.init(moneySpawnerData)

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
bribePlate.Attachment.ProximityPrompt.Triggered:Connect(bribePlateTriggered)
dailyNorm.Changed:Connect(dailyNormChanged)
bribeEvent.OnServerEvent:Connect(getBribe)

startDay()


