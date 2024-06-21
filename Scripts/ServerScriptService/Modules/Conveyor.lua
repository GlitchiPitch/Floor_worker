--!strict

local modules = game.ServerScriptService.Modules
local utils = require(modules.Utils)

local data: {
	currentColor: BrickColorValue,
	colorList: {BrickColor},
	soundEvent: RemoteEvent,
	bindEvent: BindableEvent,
	changePlayerPoints: () -> (),
}

local conveyor: {
	getButton: BasePart,
	levelButton: BasePart,
	pushButton: BasePart,
	spawner: BasePart,
	door: BasePart,
	road: BasePart,
	checingkGate: BasePart,
	base: BasePart,
	screen: Model,
	liquid: BasePart,
}

local stateValues: {
	liquidLevelIsFull: BoolValue,
	conveyourIsOn: BoolValue,
}

function spawnItem()
	local item = Instance.new('Part')
	item.Parent = workspace
	item.CollisionGroup = 'Item'
	item.Position = conveyor.spawner.Position
end

function activateConveyor(isOn: boolean)
	local goal = {Position = conveyor.door.Position + Vector3.new(0, conveyor.door.Size.Y * (isOn and 1 or -1), 0)}
	utils.tween(conveyor.door, goal)
	conveyor.base.CanCollide = isOn
	conveyor.road.AssemblyLinearVelocity = not isOn and -Vector3.zAxis * 10 or Vector3.zero 
	conveyor.pushButton.BrickColor = isOn and BrickColor.Green() or BrickColor.Red()
end

function changeLiquidColor(liquidColor: BrickColor)
	conveyor.liquid.BrickColor = liquidColor
end

function changeLevel(isFull: boolean)
	conveyor.levelButton.BrickColor = isFull and BrickColor.Green() or BrickColor.Red()
	local full = Vector3.new(31, 15, 31)
	local empty = Vector3.new(31, 1, 31)
	utils.tween(conveyor.liquid, 
		{
			Position = conveyor.liquid.Position + (((Vector3.yAxis * full) / 2) * (isFull and -1 or 1)),
			Size = isFull and empty or full,
		}
	)

	for i, v in workspace:GetPartsInPart(conveyor.liquid) do v.BrickColor = conveyor.liquid.BrickColor end
end

function changeCurrentColor()
	data.currentColor.Value = data.colorList[math.random(#data.colorList)]
	
	local frame: BasePart = conveyor.screen.Frame
	local screen: BasePart = conveyor.screen.Screen

	frame.BrickColor = BrickColor.new('Bright green')
	task.wait(2)
	frame.BrickColor = BrickColor.new('Medium stone grey')
	screen.BrickColor = data.currentColor.Value
	
end

function setupGetButton()
	if stateValues.liquidLevelIsFull.Value or stateValues.conveyourIsOn.Value then return end
	conveyor.getButton:FindFirstChildOfClass('ClickDetector').MouseClick:Connect(spawnItem)
end

function setupClicker(clickedObject: Instance, checkedValue: BoolValue, changedValue: BoolValue, callback: (boolean) -> ())
	local detector: ClickDetector = clickedObject:FindFirstChildOfClass('ClickDetector')
	detector.MouseClick:Connect(function()
		if checkedValue.Value == true then return end
		detector.MaxActivationDistance = 0
		callback(changedValue.Value)
		changedValue.Value = not changedValue.Value
		detector.MaxActivationDistance = 32
	end)
end

function setupChecingGate(hit: BasePart)
	if hit.CollisionGroup == 'Item' then
		if hit.BrickColor == data.currentColor.Value then
			data.soundEvent:FireAllClients('yes')
			hit:Destroy()
			changeCurrentColor()
			data.changePlayerPoints()
		else
			data.soundEvent:FireAllClients('no')
		end
	end
end

function conveyorEvents(method: string, ...)
	local methods = {
		changeLiquidColor = changeLiquidColor,
	}

	if methods[method] then
		methods[method](...)
	end

end

function init(conveyor_: Folder, data_)

	data = data_

	conveyor = {
		getButton = conveyor_.Get,
		levelButton = conveyor_.Level,
		pushButton = conveyor_.Push,
		spawner = conveyor_.Spawner,
		door = conveyor_.Door,
		road = conveyor_.Road,
		checingkGate = conveyor_.CheckingGate,
		base = conveyor_.Base,
		screen = conveyor_.Screen,
		liquid = conveyor_.Liquid,
	}

	stateValues = {
		conveyourIsOn = conveyor.pushButton:FindFirstChildOfClass('BoolValue'),
		liquidLevelIsFull = conveyor.levelButton:FindFirstChildOfClass('BoolValue'),
	}
	
	setupGetButton()
	changeCurrentColor()
	
	setupClicker(conveyor.pushButton, stateValues.liquidLevelIsFull, stateValues.conveyourIsOn, activateConveyor)
	setupClicker(conveyor.levelButton, stateValues.conveyourIsOn, stateValues.liquidLevelIsFull, changeLevel)

	data.bindEvent.Event:Connect(conveyorEvents)
	conveyor.checingkGate.Touched:Connect(setupChecingGate)
end

return {
	init = init,
}