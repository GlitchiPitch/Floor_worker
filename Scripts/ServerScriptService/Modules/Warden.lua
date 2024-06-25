
local textChatService = game:GetService("TextChatService")

local warden: Model
local wardenHumanoid: Humanoid
local wardenHead: BasePart

local data: {
    playerCoins: IntValue,
    conveyorIsWorking: BoolValue,
}

local bubbles = {
    brokenConveyor = 'What, wait here i will call helper',
}

local movePoints: {
    conveyor: CFrame,
    exitDoor: CFrame,
    seat: CFrame,
}

function getBribe()
    
end

function exit()
    warden.Parent = game.ServerStorage
end

function moveTo(point: Vector3)
    wardenHumanoid:MoveTo(point)
    wardenHumanoid.MoveToFinished:Wait()
end

function says(message: string)
    textChatService:DisplayBubble(wardenHead, message)
    task.wait(3)
end

function conveyorIsWorkingChanged(value: boolean)
    if not value then
        moveTo(movePoints.conveyor)
        says(bubbles.brokenConveyor)
        moveTo(movePoints.exitDoor)
        exit()
    end
end

function init(data_)
    data = data_

    data.conveyorIsWorking.Changed:Connect(conveyorIsWorkingChanged)

end