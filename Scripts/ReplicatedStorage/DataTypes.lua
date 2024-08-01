export type Conveyor = {
	currentColor: BrickColorValue,
	colorList: {BrickColor},
	soundEvent: RemoteEvent,
	bindEvent: BindableEvent,
	changePlayerPoints: (value: number) -> (),
	spawnedItems: {BasePart},
}

export type ItemSpawner = {
	changePlayerPoints: (value: number) -> ()?, 
	playerMoney: IntValue,
	spawnerObject: BasePart | Model,
	itemObject: BasePart | Model,
}

export type FoodSpawner = ItemSpawner & {
}

export type MoneySpawner = ItemSpawner & {
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