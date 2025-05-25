local bindRemote = game.ReplicatedStorage.Remotes.BindRemote
local unbindRemote = game.ReplicatedStorage.Remotes.UnbindRemote
local inputBinder = require(game.ReplicatedStorage.Modules.InputBinder)

bindRemote.OnClientEvent:Connect(function(action, keys)
    if not action or not keys then
        warn("Received invalid action or keys from server.")
        return
    end

    -- Bind the action with the provided keys
    inputBinder:BindAction(action, keys)
end)


unbindRemote.OnClientEvent:Connect(function(action)
    if not action then
        warn("Received invalid action from server.")
        return
    end

    -- Unbind the action
    inputBinder:UnbindAction(action)
end)
