-- Plugin: Version Tracker
-- Location: Plugins > Studio

-- Services
local ServerScriptService = game:GetService("ServerScriptService")

-- Settings
local scriptName = "VersionTrackerScript"
local versionValueName = "GameVersion"

-- Toolbar and Button
local toolbar = plugin:CreateToolbar("Version Tools")
local button = toolbar:CreateButton("Update Version", "Increments and updates game version", "")

-- Utility: Get or create version NumberValue
local function getVersionValue()
	local version = ServerScriptService:FindFirstChild(versionValueName)
	if not version then
		version = Instance.new("NumberValue")
		version.Name = versionValueName
		version.Value = 1
		version.Parent = ServerScriptService
	else
		version.Value += 1
	end
	return version.Value
end

-- Utility: Get or create the target Script
local function getOrCreateScript()
	local existing = ServerScriptService:FindFirstChild(scriptName)
	if existing and existing:IsA("Script") then
		return existing
	end
	local script = Instance.new("Script")
	script.Name = scriptName
	script.Parent = ServerScriptService
	return script
end

-- Button logic
button.Click:Connect(function()
	local version = getVersionValue()
	local targetScript = getOrCreateScript()
	targetScript.Source = `print('Game version updated to: {version}')`
end)
