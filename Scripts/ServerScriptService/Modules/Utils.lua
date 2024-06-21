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

--function spawnMoney()
--	local coin_ = coin:Clone()
--	coin_.Parent = moneyFolder
--	coin_.Position = money.WorldCFrame.Position
--end

--function spawnFood()
--	local bread_ = bread:Clone()
--	bread_.Parent = workspace
--	bread_.Position = food.WorldCFrame.Position
--end


return {
	tween = tween,
	spawnItem = spawnItem,
}