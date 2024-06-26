
local collectionService = game:GetService("CollectionService")

local events = game.ReplicatedStorage.Events
local bubbleEvent = events.BubbleEvent

local warden: {
    model: Model,
    humanoid: Humanoid,
    head: BasePart,
}

local data: {
    wardenModel: Model,
    player: Player,
    playerCoins: IntValue,
    conveyorIsWorking: BoolValue,
}

local bubbles = {
    brokenConveyor      = 'What, wait here i will call helper',
    findNotAcceptedTool = 'Wait, what is it? you could be better',
}

local movePoints: {
    conveyor: CFrame,
    exitDoor: CFrame,
    seat: CFrame,
}

function getBribe()
    
end



function exit()
    warden.model.Parent = game.ServerStorage
end

function moveTo(point: Vector3)
    warden.humanoid:MoveTo(point)
    warden.humanoid.MoveToFinished:Wait()
end

function says(message: string)
    bubbleEvent:FireAllClients(warden.head, message)
    task.wait(3)
end

function checkPlayerItems()
    local findNotAcceptedTool = false
    local notAcceptedTools: {Tool} = {}
    for i, v in data.player.Backpack:GetChildren() do
        if not collectionService:HasTag(v, 'ColorTool') then
            table.insert(notAcceptedTools, v)
            findNotAcceptedTool = true
        end
    end

    for i, v in data.player.Character:GetChildren() do
        if v:IsA('Tool') and not collectionService:HasTag(v, 'ColorTool') then
            table.insert(notAcceptedTools, v)
            findNotAcceptedTool = true
        end
    end

    if findNotAcceptedTool then
        moveTo(data.player.Character:GetPivot().Position)
        says(bubbles.findNotAcceptedTool)
        -- punch player
        for i, v in notAcceptedTools do
            v:Destroy()
        end
    end
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

    warden = {
        model       = data.wardenModel,
        humanoid    = data.wardenModel:FindFirstAncestorOfClass('Humanoid'),
        head        = data.wardenModel:FindFirstChild('Head'),
    }

    movePoints = {
        conveyor    = CFrame.new(0, 0, 0),
        exitDoor    = CFrame.new(0, 0, 0),
        seat        = CFrame.new(0, 0, 0),
    }

    data.conveyorIsWorking.Changed:Connect(conveyorIsWorkingChanged)
end

return {
    init = init,
}