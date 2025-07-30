local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local settingsUI = playerGui:WaitForChild("McKeybinds")
local userInputService = game:GetService("UserInputService")

local holderRight = settingsUI.Background.HolderRight
local holderLeft = settingsUI.Background.HolderLeft

local keys = {
    ["Mc1"] = Enum.KeyCode.Z,
    ["Mc2"] = Enum.KeyCode.X,
    ["Mc3"] = Enum.KeyCode.C,
    ["Mc4"] = Enum.KeyCode.B,
    ["Mc5"] = Enum.KeyCode.N,
}

for _, keybind in ipairs(holderRight:GetChildren()) do
    if not keybind:IsA("TextLabel") then continue end
    local keyName = keybind.Name
    if keys[keyName] then
        keybind.Text = userInputService:GetStringForKeyCode(keys[keyName])
    end
end

for _, child in ipairs(holderLeft:GetChildren()) do
    if not child:IsA("TextBox") then continue end
    child.FocusLost:Connect(function(enter: boolean)
        if enter then
            player:SetAttribute(child.Name, child.Text)
        end
    end)
end
