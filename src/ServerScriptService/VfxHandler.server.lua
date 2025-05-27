--|| Services ||--
local replicatedStorage = game:GetService("ReplicatedStorage")

--|| Remotes ||--
local remotes = replicatedStorage:FindFirstChild("Remotes")
local vfxRemote = remotes:FindFirstChild("VFXRemote")

--|| Config ||--
local allowedRequests = {
    "PrototypeOmnitrixLightCore",
    "PrototypeOmnitrixDisableCore",
    "PrototypeOmnitrixPrimeSound"
}

--|| Functions ||--
local function onVfxRequested(player: Player, vfxName: string, origin: CFrame | Part)
    if not table.find(allowedRequests, vfxName) then
        warn("Player " .. player.Name .. " attempted to request an invalid VFX: " .. vfxName)
        return
    end

    if not origin or not origin:IsA("CFrame") and not origin:IsA("Part") then
        warn("Invalid origin provided for VFX: " .. vfxName)
        return
    end

    vfxRemote:FireClient(player, vfxName, origin)
end

--|| Hooks ||--
vfxRemote.OnServerEvent:Connect(onVfxRequested)
