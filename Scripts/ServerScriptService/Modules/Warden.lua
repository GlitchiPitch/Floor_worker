local pathfindingService = game:GetService("PathfindingService")
local events = game.ReplicatedStorage.Events
local bubbleEvent = events.Bubble

local dataTypes = require(game.ReplicatedStorage.DataTypes)
local types = require(game.ReplicatedStorage.Types)

local warden: types.Warden
local data: dataTypes.Warden

local bubbles 	= require(game.ServerScriptService.Bubbles).wardenBubbles

local movePoints: {
	conveyor: Vector3,
	exitDoor: Vector3,
	seat: Vector3,
}

function exit()
	warden.model.Parent = game.ServerStorage
end

function comeBack()
	warden.model.Parent = workspace
	moveTo(movePoints.seat)
	data.conveyorIsWorking.Value = true
end

function moveTo(targetPoint: Vector3)
	local path = pathfindingService:CreatePath()
	path:ComputeAsync(warden.model:GetPivot().Position, targetPoint)
	local waypoints: { PathWaypoint } = path:GetWaypoints()
	for i, p in waypoints do
		warden.humanoid:MoveTo(p.Position)
		warden.humanoid.MoveToFinished:Wait()
	end
end

function says(message: string)
	bubbleEvent:FireAllClients(warden.head, message)
	task.wait(3)
end

function conveyorIsWorkingChanged(value: boolean)
	if not value then
		moveTo(movePoints.conveyor)
		says(bubbles.brokenConveyor)
		moveTo(movePoints.exitDoor)
		exit()
		task.wait(15)
		comeBack()
	end
end

function init(data_: dataTypes.Warden)
	data = data_

	warden = {
		model = data.wardenModel,
		humanoid = data.wardenModel:FindFirstChildOfClass("Humanoid"),
		head = data.wardenModel:FindFirstChild("Head"),
	}
	movePoints = {
		conveyor = data.wardenPath.Conveyor.Position,
		exitDoor = data.wardenPath.Exit.Position,
		seat = data.wardenPath.Seat.Position,
	}

	data.conveyorIsWorking.Changed:Connect(conveyorIsWorkingChanged)
end

return {
	init = init,
}
