local modules = game.ServerScriptService.Modules
local reModules = game.ReplicatedStorage.Modules
local utils = require(modules.Utils)
local sounds = require(reModules.Sounds)

local data: {
	colorLevelModels: Folder,
	colorList: {BrickColor},
	colorLevelValue: number,
	colorLevelTileSize: number,
	soundEvent: RemoteEvent,
	bindEvent: BindableEvent,
}

local colorLevels: {
	[Model]: {
		bar: BasePart,
		gate: BasePart,
		spawner: BasePart,
		button: BasePart,
		colorLevel: IntValue,
	}
} = {}

function changeColorLevel(bar, index)
	data.soundEvent:FireAllClients(sounds.pushButton)
	utils.tween(bar, {
		Size = bar.Size + Vector3.new(0, data.colorLevelTileSize * index, 0),
		Position = bar.Position + Vector3.new(0, data.colorLevelTileSize / 2 * index, 0)
	})
end

function colorGateTouched(hit: BasePart, gateColor: BrickColor, model: Model)
	local bar = colorLevels[model]
	local colorLevel: IntValue = bar.colorLevel
	if hit.BrickColor == gateColor then
		data.soundEvent:FireAllClients(sounds.liquidLevel)
		if colorLevel.Value < 10 then
			hit:Destroy()
			changeColorLevel(bar.bar, 1)
			colorLevel.Value += 1
		end
	end
end

function createColorTool(button)
	data.soundEvent:FireAllClients(sounds.getColorTool)
	local tool = game.ServerStorage.Tool:Clone()
	tool.Parent = workspace
	tool.Handle.BrickColor = button.BrickColor
	tool.Handle.Position = button.Position
end

function takeColorForConveyor(button, model: Model)
	data.soundEvent:FireAllClients(sounds.pushButton)
	local bar = colorLevels[model]
	if bar.colorLevel.Value > 0 then
		data.bindEvent:Fire('changeLiquidColor', button.BrickColor)
		changeColorLevel(bar.bar, -1)
		bar.colorLevel.Value -= 1
	end
end

function setupColorLevels()
	for model, items in colorLevels do
		items.gate.Touched:Connect(function(hit)
			colorGateTouched(hit, items.gate.BrickColor, model)
		end)
		
		items.spawner.ClickDetector.MouseClick:Connect(function()
			createColorTool(items.spawner)
		end)
		
		items.button.ClickDetector.MouseClick:Connect(function()
			takeColorForConveyor(items.button, model)
		end)
	end
end

function init(data_)
	data = data_
	for i, colorLevelModel in data.colorLevelModels:GetChildren() do
		colorLevels[colorLevelModel] = {
			bar 		= colorLevelModel.Bar,
			gate 		= colorLevelModel.Gate,
			spawner 	= colorLevelModel.Spawner,
			button 		= colorLevelModel.Button,
			colorLevel 	= colorLevelModel.ColorLevel,
		}
		
		colorLevels[colorLevelModel].bar.BrickColor = data.colorList[i]
		colorLevels[colorLevelModel].button.BrickColor = data.colorList[i]
		colorLevels[colorLevelModel].gate.BrickColor = data.colorList[i]
		colorLevels[colorLevelModel].spawner.BrickColor = data.colorList[i]
	end

	setupColorLevels()
	
end

return {
	init = init,
}