local modules = game.ServerScriptService.Modules
local utils = require(modules.Utils)

local data: {
	currentColor: BrickColorValue,
	soundEvent: RemoteEvent,
	bindEvent: BindableEvent,
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

function spawnItem()
	local item = Instance.new('Part')
	item.Parent = workspace
	item.CollisionGroup = 'Item'
	item.Position = conveyor.spawner.Position
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

function activateConveyor(isOn: boolean)
	local goal = {Position = conveyor.door.Position + Vector3.new(0, conveyor.door.Size.Y * (isOn and 1 or -1), 0)}
	utils.tween(conveyor.door, goal)
	conveyor.base.CanCollide = isOn
	conveyor.road.AssemblyLinearVelocity = not isOn and -Vector3.zAxis * 10 or Vector3.zero 
	conveyor.pushButton.BrickColor = isOn and BrickColor.Red() or BrickColor.Green()
end

function setupGetButton()
	conveyor.getButton:FindFirstChildOfClass('ClickDetector').MouseClick:Connect(spawnItem)
end

function setupLevelButton()
	local liquidLevelIsFull: BoolValue = conveyor.levelButton:FindFirstChildOfClass('BoolValue')
	local detector: ClickDetector = conveyor.levelButton:FindFirstChildOfClass('ClickDetector')
	detector.MouseClick:Connect(function()
		detector.MaxActivationDistance = 0
		changeLevel(liquidLevelIsFull.Value)
		liquidLevelIsFull.Value = not liquidLevelIsFull.Value
		detector.MaxActivationDistance = 32
	end)
	
end

function setupPushButton()
	local conveyourIsOn: BoolValue = conveyor.pushButton:FindFirstChildOfClass('BoolValue')
	local detector: ClickDetector = conveyor.pushButton:FindFirstChildOfClass('ClickDetector')
	detector.MouseClick:Connect(function()
		detector.MaxActivationDistance = 0
		activateConveyor(conveyourIsOn.Value)
		conveyourIsOn.Value = not conveyourIsOn.Value
		detector.MaxActivationDistance = 32
	end)
end

function setupChecingGate()
	conveyor.checingkGate.Touched:Connect(function(hit: BasePart)
		if hit.CollisionGroup == 'Item' then
			if hit.BrickColor == data.currentColor.Value  then
				data.soundEvent:FireAllClients('yes')
				--data.bindEvent:Fire('yes')
			else
				print('else')
			end
			
		end
	end)
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
	
	setupGetButton()
	setupPushButton()
	setupLevelButton()
	setupChecingGate()
	
	data.bindEvent.Event:Connect(conveyorEvents)
end

return {
	init = init,
}