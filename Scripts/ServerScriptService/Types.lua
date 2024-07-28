export type Conveyor = {
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
	counter: Part,
}

export type FoodSpawner = {
    spawnPoint: Attachment,
    spawnButton: BasePart,
    foodModel: BasePart,
    foodFolder: Folder,
}

export type MoneySpawner = {
    spawnPoint: Attachment,
    spawnButton: BasePart,
    moneyModel: BasePart,
    moneyFolder: Folder,
}

export type Warden = {
	model: Model,
	humanoid: Humanoid,
	head: BasePart,
}

export type ColorLevels = {
	[Model]: {
		bar: BasePart,
		gate: BasePart,
		spawner: BasePart,
		button: BasePart,
		colorLevel: IntValue,
	}
}

export type InteractObject = {
	Attachment: Attachment & {
		ProximityPrompt: ProximityPrompt
	}
}

return true