local utils = require(game.ReplicatedStorage.Utils)
local sounds = require(game.ReplicatedStorage.Modules.Sounds)

local player = game.Players.LocalPlayer
local playerGui = player.PlayerGui
local mainGui = playerGui:WaitForChild('Main') :: ScreenGui & {
    BlackScreen: Frame,
    Bribe: Frame & {
        TextBox: TextBox,
        Give: TextButton,
        Cancel: TextButton,
    }
}

local events = game.ReplicatedStorage.Events

function onBlackScreen()
    local blackScreen = mainGui.BlackScreen
    utils.tween(blackScreen.Frame, {Transparency = blackScreen.Enabled and 1 or 0}, TweenInfo.new(3))
    blackScreen.Enabled = not blackScreen.Enabled
end

function onBribe()
    local bribe = mainGui.Bribe
    bribe.Visible = true
    local giveConn, cancelConn
    giveConn = bribe.Give.Activated:Once(function()
        if cancelConn.Connected then cancelConn:Disconnect() end
        events.Bribe:FireServer(bribe.TextBox.Text)
        bribe.Visible = false
    end)
    cancelConn = bribe.Cancel.Activated:Once(function()
        if giveConn.Connected then giveConn:Disconnect() end
        bribe.Visible = false
    end)
end

events.Bribe.OnClientEvent:Connect(onBribe)
events.BlackScreen.OnClientEvent:Connect(onBlackScreen)
events.Sound.OnClientEvent:Connect(sounds.playSound)