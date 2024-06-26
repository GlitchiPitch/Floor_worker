local tweenService = game:GetService('TweenService')

function tween(instance, finishGoal)
	local tween = tweenService:Create(instance, TweenInfo.new(1), finishGoal)
	tween:Play()
	tween.Completed:Wait()
end

function spawnItem(item: BasePart, parent: Folder, spawnPoint: Attachment)
	local item_ = item:Clone()
	item_.Parent = parent
	item_.Position = spawnPoint.WorldCFrame.Position
end

return {	
	spawnItem 			= spawnItem,
	tween 				= tween,
}