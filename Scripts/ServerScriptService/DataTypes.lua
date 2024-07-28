export type Conveyor = {
	currentColor: BrickColorValue,
	colorList: {BrickColor},
	soundEvent: RemoteEvent,
	bindEvent: BindableEvent,
	changePlayerPoints: (value: number) -> (),
	spawnedItems: {BasePart},
}

export type FoodSpawner = {
    playerMoney: IntValue,
    foodSpawnerModel: Model | Folder,
    soundEvent: RemoteEvent,
    foodModel: BasePart,
    changePlayerPoints: (value: number) -> (),
}

export type MoneySpawner = {
    playerMoney: IntValue,
    moneySpawnerModel: Model | Folder,
    soundEvent: RemoteEvent,
    moneyModel: BasePart,
}

export type Warden = {
	wardenPath: Folder,
	wardenModel: Model,
	player: Player,
	playerCoins: IntValue,
	conveyorIsWorking: BoolValue,
}

export type ColorLevels = {
	colorLevelModels: Folder,
	colorList: {BrickColor},
	colorLevelAmount: number,
	colorLevelTileSize: number,
	soundEvent: RemoteEvent,
	bindEvent: BindableEvent,
}

return true