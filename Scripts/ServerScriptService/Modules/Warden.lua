local collectionService = game:GetService("CollectionService")
local pathfindingService = game:GetService("PathfindingService")
local events = game.ReplicatedStorage.Events
local bubbleEvent = events.BubbleEvent

local warden: {
	model: Model,
	humanoid: Humanoid,
	head: BasePart,
}

local data: {
	wardenPath: Folder,
	wardenModel: Model,
	player: Player,
	playerCoins: IntValue,
    playerIsNear: boolean,
	conveyorIsWorking: BoolValue,
}

local bubbles = {
	brokenConveyor = "What, wait here i will call helper",
	findNotAcceptedTool = "Wait, what is it? you could be better",
    patrol = "How is it going?",
}

local movePoints: {
	conveyor: Vector3,
	exitDoor: Vector3,
	seat: Vector3,
    patrol: Vector3,
}

function getBribe() end

function exit()
	warden.model.Parent = game.ServerStorage
end

function lookAt() end

function moveTo(point: Vector3)
	local path = pathfindingService:CreatePath()
	path:ComputeAsync(warden.model:GetPivot().Position, point)
	local waypoints: {PathWaypoint} = path:GetWaypoints()
	for i, p in waypoints do
		warden.humanoid:MoveTo(p.Position)
		warden.humanoid.MoveToFinished:Wait()
	end
end

function says(message: string)
	bubbleEvent:FireAllClients(warden.head, message)
	task.wait(3)
end

function checkPlayerItems()
    data.playerIsNear = true
	local notAcceptedTools: {Tool} = {}
	for i, v in data.player.Backpack:GetChildren() do
		if not collectionService:HasTag(v, "ColorTool") then
			table.insert(notAcceptedTools, v)
		end
	end

	for i, v in data.player.Character:GetChildren() do
		if v:IsA("Tool") and not collectionService:HasTag(v, "ColorTool") then
			table.insert(notAcceptedTools, v)
		end
	end

	if #notAcceptedTools > 0 then
		moveTo(data.player.Character:GetPivot().Position)
		says(bubbles.findNotAcceptedTool)
		-- punch player
		for i, v in notAcceptedTools do
			v:Destroy()
		end
	end
    if data.conveyorIsWorking.Value then
        moveTo(movePoints.seat)
    end
    data.playerIsNear = false
end

function checkPlayerIsNear()
	while task.wait(3) do
        if data.playerIsNear then continue end
		local playerCharacter = data.player.Character
		if playerCharacter and warden.model then
			if (playerCharacter:GetPivot().Position - warden.model:GetPivot().Position).Magnitude < 20 then
				checkPlayerItems()
			end
		end
	end
end

function patrol()
    -- если не работает конвеер, например не загружен блок туда, то он скажет работать

    while task.wait(10) do
        if data.conveyorIsWorking.Value then
            moveTo(movePoints.patrol)
            says(bubbles.patrol)
            task.wait(3)
            moveTo(movePoints.seat)
        end
    end
end

function conveyorIsWorkingChanged(value: boolean)
	if not value then
		moveTo(movePoints.conveyor)
		lookAt() -- look at player
		says(bubbles.brokenConveyor)
		moveTo(movePoints.exitDoor)
		exit()
	end
end

function init(data_)
	data = data_

    data.playerIsNear = false

	warden = {
		model       = data.wardenModel,
		humanoid    = data.wardenModel:FindFirstChildOfClass("Humanoid"),
		head        = data.wardenModel:FindFirstChild("Head"),
	}
	movePoints = {
		conveyor    = data.wardenPath.Conveyor.Position,
		exitDoor    = data.wardenPath.Exit.Position,
		seat        = data.wardenPath.Seat.Position,
        patrol      = data.wardenPath.Patrol.Position,
	}

	data.conveyorIsWorking.Changed:Connect(conveyorIsWorkingChanged)

    -- coroutine.wrap(patrol)()
	coroutine.wrap(checkPlayerIsNear)()
end

return {
	init = init,
}
