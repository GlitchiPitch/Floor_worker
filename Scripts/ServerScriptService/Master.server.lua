local RunService = game:GetService("RunService")
--[[

	налоги, выход наружу через взятку
	добавить дверь с надзирателем, которому нужно дать взятку чтобы выйти и голод
	голод утолять черным хлебом, который тоже надо покупать

	добавить способы уйти
		- игрок может положить в конвейер тул для пополнения цвета и сломать конвейер, дальше он остановиться и придет надзиратель,
		скажет жди здесь я позову техника, после этого он уходит и игрок может пойти к двери и выбраться

		также надо добавить баблы в голову игрока, которые будут говорить о состоянии и давать какой-то сюжет ( возможно использовать дневники какого-нибудь заключенного гулага, с цитатами)
			- "я голоден",
			- "я думаю мне надо пополнить цвет",
			- "надеюсь я накоплю достаточно денег чтобы выбраться отсюда",
			- "я должен выбраться отсюда чтобы увидеть свою семью",

		чтобы заплатить нужную взятку, надо будет наиграть много монет, но надзирателю всегда будет мало денег
			- "ты что, меня за бедняка держишь которму монету покажи он лоб разобьет?" (надзиратель)
			- "иди гуляй дядя, будем считать что мы ничего не видели"
			( надо унижать игрока за его работу )
		
			можно будет также убить его. для этого с вероятностью вместо кубиков будут выпадать странные вещи, это будут полезные элементы,
			из которых можно будет собрать оружие или выпадет прям оружие, которым можно будет убить надзирателя,

			если надзиратель увидит у игрока что-то в руке, он подойдет и заберет
				- игрок может напасть на надзирателя, но если он попробует это сделать напрямую то его надзиратель застрелит,
				- надо напасть со спины
			
			надзиратель будет через определенное количество времени приходить проверять игрока, если он будет видеть что-то не по регламенту, то будет действовать.

			значит игроку надо дать возможность прятать вещи где-то, например за конвейером, сделать тогда сундук с ограниченым количеством ячеек
			игроку по дефолту дают шмотки в сундуке, которые он должен надеть чтобы работать, если надзиратель увидит тебя без формы то ударит
]]

--[[
	-- переделать работу конвеера на то чтобы он делал из вещей зомби, зомби сделать в виде, мдоельки или меша без хуманоида

]]

-- modules
local modules = game.ServerScriptService.Modules

local colorLevels = require(modules.ColorLevels)
local conveyor = require(modules.Conveyor)
local foodSpawner = require(modules.FoodSpawner)
local moneySpawner = require(modules.MoneySpawner)
local inventory = require(modules.Inventory)
local warden = require(modules.Warden)

-- workspace
local conveyorFolder: {IsWorking: BoolValue} = workspace.Conveyor
local colorLevelModels = workspace.ColorLevels
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
local spawnedItems = game.ServerStorage.Eggs:GetChildren()
--npc
local wardenModel: Model = workspace.Warden
local player

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
local events = game.ReplicatedStorage.Events
local soundEvent = events.SoundEvent
local bindEvent = game.ServerStorage.Event

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
	dailyNorm.Value = 10
end

function finishDay()
	-- add new day line on the wall
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

foodSpawner.init({
	changePlayerPoints 	= changePlayerPoints,
	playerMoney 		= points,
	foodSpawnerModel 	= foodSpawnerModel,
	soundEvent 			= soundEvent,
	foodModel 			= bread,
})

moneySpawner.init({
	playerMoney 		= points,
    moneySpawnerModel 	= moneySpawnerModel,
	soundEvent 			= soundEvent,
    moneyModel 			= coin,
})

colorLevels.init({
	colorLevelValue 	= colorLevelValue,
	colorLevelModels 	= colorLevelModels,
	colorList 			= colorList,
	colorLevelTileSize 	= colorLevelTileSize,
	soundEvent 			= soundEvent,
	bindEvent 			= bindEvent,
})

conveyor.init(conveyorFolder, {
	changePlayerPoints 	= changePlayerPoints,
	currentColor 		= currentColor,
	colorList 			= colorList, 
	soundEvent 			= soundEvent,
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

inventory.init()

startDay()


