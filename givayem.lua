local local_player = game:GetService("Players").LocalPlayer
local workspace = game:GetService("Workspace")

local holes = workspace:FindFirstChild("World"):FindFirstChild("Zones"):FindFirstChild("_NoDig")

getgenv().enabled = true

function get_tool()
return local_player.Character:FindFirstChildOfClass("Tool")
end

local_player.Character.ChildAdded:Connect(function(v)
if enabled and v:IsA("Tool") and v.Name:find("Shovel") then
task.wait(1)
if holes:FindFirstChild(local_player.Name.."_Crater_Hitbox") then
holes[local_player.Name.."_Crater_Hitbox"]:Destroy()
end
v:Activate()
end
end)

local_player.PlayerGui.ChildAdded:Connect(function(v)
if enabled and v.Name == "Dig" then
local strong_bar = v:FindFirstChild("Safezone"):FindFirstChild("Holder"):FindFirstChild("Area_Strong")
local player_bar = v:FindFirstChild("Safezone"):FindFirstChild("Holder"):FindFirstChild("PlayerBar")
player_bar:GetPropertyChangedSignal("Position"):Connect(function()
if not enabled then return end
if math.abs(player_bar.Position.X.Scale - strong_bar.Position.X.Scale) <= 0.04 then
local tool = get_tool()
if tool then
tool:Activate()
task.wait()
end
end
end)
end
end)

local_player:GetAttributeChangedSignal("IsDigging"):Connect(function()
if not enabled then return end
if not local_player:GetAttribute("IsDigging") then
if holes:FindFirstChild(local_player.Name.."_Crater_Hitbox") then
holes[local_player.Name.."_Crater_Hitbox"]:Destroy()
end
local tool = get_tool()
if tool then
tool:Activate()
end
end
end)
