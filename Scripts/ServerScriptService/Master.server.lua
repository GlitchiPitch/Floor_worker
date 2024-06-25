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
	оформить баблы у игрока и надзирателя
	реализовать механику поломки конвеера

	возможно поменять айдл анимки,

]]

-- modules
local modules = game.ServerScriptService.Modules

local colorLevels = require(modules.ColorLevels)
local conveyor = require(modules.Conveyor)
local foodSpawner = require(modules.FoodSpawner)
local moneySpawner = require(modules.MoneySpawner)

-- workspace
local conveyorFolder = workspace.Conveyor
local colorLevelModels = workspace.ColorLevels

-- item spawners
local foodSpawnerModel = workspace.FoodSpawner
local moneySpawnerModel = workspace.MoneySpawner

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

local currentColor = Instance.new('BrickColorValue')
local leaderstats = Instance.new('Folder')
local points = Instance.new('IntValue')

function changePlayerPoints(value: number) points.Value += value end

function onPlayerAdded(player: Player) 
	points.Parent = leaderstats
	leaderstats.Parent = player 
end

leaderstats.Name = 'leaderstats'
points.Name = 'points'

game.Players.PlayerAdded:Connect(onPlayerAdded)

foodSpawner.init({
	changePlayerPoints = changePlayerPoints,
	playerMoney = points,
	foodSpawnerModel = foodSpawnerModel,
	soundEvent = soundEvent,
	foodModel = bread,
})

moneySpawner.init({
	playerMoney = points,
    moneySpawnerModel = moneySpawnerModel,
	soundEvent = soundEvent,
    moneyModel = coin,
})

colorLevels.init({
	colorLevelValue = colorLevelValue,
	colorLevelModels = colorLevelModels,
	colorList = colorList,
	colorLevelTileSize = colorLevelTileSize,
	soundEvent = soundEvent,
	bindEvent = bindEvent,
})

conveyor.init(conveyorFolder, {
	changePlayerPoints = changePlayerPoints,
	currentColor = currentColor,
	colorList = colorList, 
	soundEvent = soundEvent,
	bindEvent = bindEvent,
})



