local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Cộng Đồng Việt Rack- V1.2.0",
    SubTitle = "By Angels of Death - AD", 
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightAlt
})
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
_G.AttackWeapon = nil
_G.AutoBuyBangGac = false
_G.AutoBangGac = false
_G.AutoHeal = false
_G.LowHPThreshold = 90
function GetList()
    local player = game:GetService("Players").LocalPlayer
    local inventory = player.PlayerGui.Inventory.MainFrame.List
    local tableweaponlist = {}
    for i,v in pairs(inventory:GetChildren()) do
        table.insert(tableweaponlist,v.Name)
        print('Added '..v.Name)
    end
    return tableweaponlist
end
local selectedWeaponButton = Tabs.Main:AddButton({
    Title = "Chon Vu Khi",
    Description = "VuKhi Hiện Tại : None",
    Callback = function()
        local weaponButtons = {}
        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(weaponButtons, {
                    Title = tool.Name,
                    Callback = function()
                        _G.AttackWeapon = tool.Name
                        print("Vũ khí đã chọn: " .. tool.Name)
                        EquipWeapon(_G.AttackWeapon)
                        selectedWeaponButton:SetDesc("VuKhi Hiện Tại : " .. _G.AttackWeapon)
                    end
                })
            end
        end
        if #weaponButtons == 0 then
            Fluent:Notify({
                Title = "Cảnh báo",
                Content = "Không tìm thấy vũ khí nào trong Backpack!",
                Duration = 5
            })
            return
        end
        Window:Dialog({
            Title = "Chọn Vũ Khí",
            Content = "Chọn một vũ khí để sử dụng:",
            Buttons = weaponButtons
        })
    end
})
spawn(function()
    while wait(1.5) do
        if _G.AttackWeapon then
            selectedWeaponButton:SetDesc("Weapon Hiện Tại : " .. _G.AttackWeapon)
        end
    end
end)
Tabs.Main:AddButton({
    Title = "Bật balo và ấn đây",
    Description = "bấm đi",
    Callback = function()
        Window:Dialog({
            Title = "Title",
            Content = "This is a dialog",
            Buttons = {
                {
                    Title = "Bật balo",
                    Callback = function()
                    game:GetService("Players").LocalPlayer.PlayerGui.Inventory.MainFrame.Visible = true
                    end
                },
                {
                    Title = "Tắt balo",
                    Callback = function()
                    game:GetService("Players").LocalPlayer.PlayerGui.Inventory.MainFrame.Visible = false
                    end
                }
            }
        })
    end
})
local Toggle = Tabs.Main:AddToggle("AutoGiangHo", {Title = "Auto Buy bang gac", Default = _G.AutoBuyBangGac })
Toggle:OnChanged(function(Value)
    _G.AutoBuyBangGac = Value
end)
local Toggle = Tabs.Main:AddToggle("AutoBangGac", {Title = "Auto Bang Gac", Default = _G.AutoBangGac })
Toggle:OnChanged(function(Value)
    _G.AutoBangGac = Value
end)
spawn(function()
    while wait() do
        if _G.AutoBangGac then
            if not game.Players.LocalPlayer.Backpack:FindFirstChild("băng gạc") and not game.Players.LocalPlayer.Character:FindFirstChild("băng gạc") then
                local args = {
                    [1] = "eue",
                    [2] = "băng gạc"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("updateInventory"):FireServer(unpack(args))
                wait()
            end
        end
    end
end)
function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip then
        if ToolSe then
            if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
                local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
                wait(.1)
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
            end
        end
    end
end
function Prompt(proximityPrompt)
    wait(.1)
    if proximityPrompt then
        pcall(function()
            proximityPrompt.Enabled = true
            proximityPrompt.HoldDuration = 0
            fireproximityprompt(proximityPrompt, 1, true)
        end)
    else
        warn("ProximityPrompt is nil")
    end
end
function CheckItem(vukhi)
    local player = game:GetService("Players").LocalPlayer
    local inventory = player.PlayerGui.Inventory.MainFrame.List
    if inventory:FindFirstChild(vukhi) then
        return true
    end
end
function UnInventoryWeapon(WE)
    if CheckItem(WE) then
        local args = {
            [1] = "eue",
            [2] = WE
        }
        game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("updateInventory"):FireServer(unpack(args))
    end
end
spawn(function()
    while wait(1) do
        if _G.AutoBuyBangGac then
            local player = game.Players.LocalPlayer
            local playerGui = player.PlayerGui:WaitForChild("Inventory"):WaitForChild("MainFrame"):WaitForChild("Container"):WaitForChild("Main"):WaitForChild("ToolList"):WaitForChild("ScrollingFrame")
            local hasBandage = false
            for _, item in pairs(playerGui:GetChildren()) do
                if item.Name == "băng gạc" then
                    hasBandage = true
                    break
                end
            end
            if not hasBandage then
                local buyArgs = { "băng gạc", 10 } 
                for i = 1, 10 do
                    game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ShopService"):WaitForChild("RE"):WaitForChild("buyItem"):FireServer(unpack(buyArgs))
                end
            end
        end
    end
end)
local ToggleAutoHeal = Tabs.Main:AddToggle("AutoHealToggle", {
    Title = "Auto Heal HP < 90%",
    Default = false,
    Callback = function(Value)
        _G.AutoHeal = Value
        if Value then
            Fluent:Notify({
                Title = "Auto Heal",
                Content = "Đã bật: Tự động dùng băng gạc khi HP dưới 90%",
                Duration = 5
            })
        else
            Fluent:Notify({
                Title = "Auto Heal",
                Content = "Đã tắt Auto Heal",
                Duration = 4
            })
        end
    end
})

local Toggle = Tabs.Main:AddToggle("AutoGiangHo", {
    Title = "Auto Giang Hồ",
    Default = false
})
Toggle:OnChanged(function(Value)
    AutoFarmGiangho = Value
end)
function EquipWeapon(ToolSe)
	if not _G.NotAutoEquip then
		if ToolSe then
			if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
				Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
				wait(.1)
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
			end
		end
	end
end

function Prompt(proximityPrompt)
	wait(.1)
	if proximityPrompt then
		pcall(function()
			proximityPrompt.Enabled = true
			proximityPrompt.HoldDuration = 0
			fireproximityprompt(proximityPrompt, 1, true)
		end)
	else
		warn("ProximityPrompt is nil")
	end
end
function CheckItem(vukhi)
	local player = game:GetService("Players").LocalPlayer
	local inventory = player.PlayerGui.Inventory.MainFrame.List

	if inventory:FindFirstChild(vukhi) then
		return true
	end
end
function UnInventoryWeapon(WE)
	if CheckItem(WE) then
		local args = {
			[1] = "eue",
			[2] = WE
		}

		game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("updateInventory"):FireServer(unpack(args))
	end
end
function EquipWeapon(ToolSe)
	if not _G.NotAutoEquip then
		if ToolSe then
			if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
				Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
				wait(.1)
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
			end
		end
	end
end

function Prompt(proximityPrompt)
	wait(.1)
	if proximityPrompt then
		pcall(function()
			proximityPrompt.Enabled = true
			proximityPrompt.HoldDuration = 0
			fireproximityprompt(proximityPrompt, 1, true)
		end)
	else
		warn("ProximityPrompt is nil")
	end
end
function CheckItem(vukhi)
	local player = game:GetService("Players").LocalPlayer
	local inventory = player.PlayerGui.Inventory.MainFrame.List

	if inventory:FindFirstChild(vukhi) then
		return true
	end
end
function UnInventoryWeapon(WE)
	if CheckItem(WE) then
		local args = {
			[1] = "eue",
			[2] = WE
		}

		game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("updateInventory"):FireServer(unpack(args))
	end
end
function EquipWeapon(ToolSe)
	if not _G.NotAutoEquip then
		if ToolSe then
			if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
				Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
				wait(.1)
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
			end
		end
	end
end

function Prompt(proximityPrompt)
	wait(.1)
	if proximityPrompt then
		pcall(function()
			proximityPrompt.Enabled = true
			proximityPrompt.HoldDuration = 0
			fireproximityprompt(proximityPrompt, 1, true)
		end)
	else
		warn("ProximityPrompt is nil")
	end
end
function CheckItem(vukhi)
	local player = game:GetService("Players").LocalPlayer
	local inventory = player.PlayerGui.Inventory.MainFrame.List

	if inventory:FindFirstChild(vukhi) then
		return true
	end
end
function UnInventoryWeapon(WE)
	if CheckItem(WE) then
		local args = {
			[1] = "eue",
			[2] = WE
		}

		game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("updateInventory"):FireServer(unpack(args))
	end
end
spawn(function()
	while wait() do
		if DisableALLautogiangho then
			break
		end
		if AutoFarmGiangho and not DisableALLautogiangho and (Vector3.new(871, 29, -1423) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5000 then
			for i,v in pairs(workspace.CityNPCs.NPCs:GetChildren()) do
				if v:FindFirstChild('HumanoidRootPart') and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then
					repeat task.wait() 
						pcall(function()
							for i,v in pairs(workspace.CityNPCs.Drop:GetChildren()) do
								if v:FindFirstChild("ProximityPrompt") or v:FindFirstChildOfClass('ProximityPrompt') then
									local itemdrop = v:FindFirstChild("ProximityPrompt") or v:FindFirstChildOfClass('ProximityPrompt')
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
									Prompt(itemdrop)
								end
							end
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,11)* CFrame.Angles(math.rad(0), 0, 0)
								EquipWeapon(AttackWeapon)
								game:GetService'VirtualUser':CaptureController()
								game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
						end)
					until not v:FindFirstChild('HumanoidRootPart') or not v:FindFirstChild('Humanoid') or v.Humanoid.Health <= 0 or DisableALLautogiangho
				end
			end
		end
end
end)
spawn(function()
	while wait() do
		if AutoFarmGiangho and not DisableALLautogiangho then
			game:GetService'VirtualUser':CaptureController()
			game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
		end
	end
end)
local function GetHealthPercent()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return 100 end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return 100 end
    return (humanoid.Health / humanoid.MaxHealth) * 100
end
local function UseBandage()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    local bandage = player.Backpack:FindFirstChild("băng gạc")
    if bandage then
        character.Humanoid:EquipTool(bandage)
        wait(0.2)
    end
    local equippedBandage = character:FindFirstChild("băng gạc")
    if equippedBandage then
        local prompt = equippedBandage:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            Prompt(prompt)
        end
    end
end
spawn(function()
    while task.wait(0.4) do
        if not _G.AutoHeal then continue end
        if GetHealthPercent() >= _G.LowHPThreshold then continue end

        local player = game.Players.LocalPlayer
        local bp = player.Backpack
        local char = player.Character
        if not char then continue end

        local bandage = bp:FindFirstChild("băng gạc") or char:FindFirstChild("băng gạc")
        if bandage then
            bandage.Parent = char
            task.wait(0.2)
            
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
            task.wait(1)
            
            if _G.AttackWeapon then
                local weapon = bp:FindFirstChild(_G.AttackWeapon)
                if weapon then
                    weapon.Parent = char
                end
            end
        end
    end
end)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
Fluent:Notify({
    Title = "Angels of Death",
    Content = "AD",
    Duration = 8
})
