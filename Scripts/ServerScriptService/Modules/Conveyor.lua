--!strict
local reModules = game.ReplicatedStorage.Modules
local modules = game.ServerScriptService.Modules
local utils = require(game.ReplicatedStorage.Utils)
local sounds = require(reModules.Sounds)
local events = game.ReplicatedStorage.Events
local bubbleEvent = events.Bubble
local dataTypes = require(game.ReplicatedStorage.DataTypes)
local types = require(game.ReplicatedStorage.Types)

local data: dataTypes.Conveyor
local conveyor: types.Conveyor

local stateValues: {
	liquidLevelIsFull: BoolValue,
	conveyourIsOn: BoolValue,
	isWorking: BoolValue,
	dailyNorm: IntValue,
}

function checkStates(checkedStates: {[string]: boolean | number})
	print(checkedStates)
	for stateName, value in checkedStates do
		if stateValues[stateName].Value == value then 
			bubbleEvent:FireAllClients(nil, stateName)
			return false
		end
	end

	if not stateValues.isWorking.Value or stateValues.dailyNorm.Value == 0 then
		return false
	end

	return true
end

function spawnItem()
	local item = data.spawnedItems:Clone() :: Model
	item.Parent = workspace
	for i, v in item:GetChildren() do
		if v:IsA('BasePart') then
			v.CollisionGroup = 'Item'
		end
	end
	item:PivotTo(conveyor.spawner.CFrame)
end

function activateConveyor(isOn: boolean)

	if not checkStates({
		liquidLevelIsFull = true,
	}) then
		return
	end

	data.soundEvent:FireAllClients(sounds.conveyor)
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

	if not checkStates({
		conveyourIsOn = true,
	}) then
		return
	end

	data.soundEvent:FireAllClients(sounds.liquidLevel)
	conveyor.levelButton.BrickColor = isFull and BrickColor.Green() or BrickColor.Red()
	local full = Vector3.new(31, 15, 31)
	local empty = Vector3.new(31, 1, 31)
	utils.tween(conveyor.liquid, 
		{
			Position 	= conveyor.liquid.Position + (((Vector3.yAxis * full) / 2) * (isFull and -1 or 1)),
			Size 		= isFull and empty or full,
		}
	)
	for i, v in workspace:GetPartsInPart(conveyor.liquid) do 
		if v:IsA('Part') then
			v.BrickColor = conveyor.liquid.BrickColor
		end
	end
	-- add some equipment like a gun
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
	local detector: ClickDetector = conveyor.getButton.ClickDetector
	detector.MouseClick:Connect(function()

		if not checkStates({
			liquidLevelIsFull = true,
			conveyourIsOn = true,
		}) then
			return
		end

		data.soundEvent:FireAllClients(sounds.getFood)
		spawnItem()
	end)
end

function setupClicker(clickedObject: Instance, checkedValue: string, changedValue: BoolValue, callback: (boolean) -> ())
	local detector: ClickDetector = clickedObject.ClickDetector
	detector.MouseClick:Connect(function()
		if not checkStates({[checkedValue] = true}) then 
			return 
		end
		
		data.soundEvent:FireAllClients(sounds.pushButton)
		detector.MaxActivationDistance = 0
		callback(changedValue.Value)
		changedValue.Value = not changedValue.Value
		detector.MaxActivationDistance = 32
	end)
end

function setupCheckingGate(hit: BasePart)
	if hit.CollisionGroup == 'Item' then
		if hit.BrickColor == data.currentColor.Value then
			data.soundEvent:FireAllClients(sounds.accept)
			stateValues.dailyNorm.Value -= 1
			hit.Parent:Destroy()
			changeCurrentColor()
			data.changePlayerPoints(1)
		else
			data.soundEvent:FireAllClients(sounds.error)
		end
	end

	if hit and hit.Parent and hit.Parent:IsA('Tool') then
		hit.Parent:Destroy()
		stateValues.isWorking.Value = false
	end
end

function setupCounter(value: number)
	local label = conveyor.counter:FindFirstChildOfClass('SurfaceGui'):FindFirstChildOfClass('TextLabel')
	label.Text = value
end

function repairConveyor()
	stateValues.isWorking.Value = true
end

function conveyorEvents(method: string, ...)
	local methods = {
		changeLiquidColor 	= changeLiquidColor,
		repairConveyor 		= repairConveyor,
	}

	if methods[method] then
		methods[method](...)
	end
end

function init(conveyor_: Folder, data_)

	data = data_

	conveyor = {
		getButton 		= conveyor_.Get,
		levelButton 	= conveyor_.Level,
		pushButton 		= conveyor_.Push,
		spawner 		= conveyor_.Spawner,
		door 			= conveyor_.Door,
		road 			= conveyor_.Road,
		checingkGate 	= conveyor_.CheckingGate,
		base 			= conveyor_.Base,
		screen 			= conveyor_.Screen,
		liquid 			= conveyor_.Liquid,
		counter 		= conveyor_.Counter,
	}

	stateValues = {
		conveyourIsOn 		= conveyor.pushButton:FindFirstChildOfClass('BoolValue'),
		liquidLevelIsFull 	= conveyor.levelButton:FindFirstChildOfClass('BoolValue'),
		isWorking 			= conveyor_:FindFirstChildOfClass('BoolValue'),
		dailyNorm			= data.dailyNorm,
	}
	
	setupGetButton()
	changeCurrentColor()
	
	setupClicker(conveyor.pushButton, 'liquidLevelIsFull', stateValues.conveyourIsOn, activateConveyor)
	setupClicker(conveyor.levelButton, 'conveyourIsOn', stateValues.liquidLevelIsFull, changeLevel)

	data.bindEvent.Event:Connect(conveyorEvents)
	conveyor.checingkGate.Touched:Connect(setupCheckingGate)
	stateValues.dailyNorm.Changed:Connect(setupCounter)
end

return {
	init = init,
}