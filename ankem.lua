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

-- Khởi tạo biến global
_G.AttackWeapon = nil
_G.AutoBuyBangGac = false
_G.AutoBangGac = false
_G.AutoHeal = false
_G.LowHPThreshold = 90
_G.AutoFarmGiangho = false
_G.DisableALLautogiangho = false

-- Function lấy % máu
local function GetHealthPercent()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return 100 end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return 100 end
    return (humanoid.Health / humanoid.MaxHealth) * 100
end

-- Function sử dụng băng gạc
local function UseBandage()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    local bandage = player.Backpack:FindFirstChild("băng gạc")
    if bandage then
        bandage.Parent = character
        wait(0.2)
        
        -- Kích hoạt sử dụng item
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        wait(0.5)
        
        -- Trang bị lại vũ khí cũ
        if _G.AttackWeapon then
            local weapon = player.Backpack:FindFirstChild(_G.AttackWeapon)
            if weapon then
                weapon.Parent = character
            end
        end
        
        return true
    end
    return false
end

-- Function EquipWeapon (gộp các function trùng)
function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip and ToolSe then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        if tool then
            wait(0.1)
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end

-- Function Prompt
function Prompt(proximityPrompt)
    wait(0.1)
    if proximityPrompt then
        pcall(function()
            proximityPrompt.Enabled = true
            proximityPrompt.HoldDuration = 0
            fireproximityprompt(proximityPrompt, 1, true)
        end)
    end
end

-- Function CheckItem
function CheckItem(vukhi)
    local player = game:GetService("Players").LocalPlayer
    local inventory = player.PlayerGui.Inventory.MainFrame.List
    return inventory:FindFirstChild(vukhi) ~= nil
end

-- Function UnInventoryWeapon
function UnInventoryWeapon(WE)
    if CheckItem(WE) then
        local args = {
            [1] = "eue",
            [2] = WE
        }
        game:GetService("ReplicatedStorage"):WaitForChild("KnitPackages"):WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0"):WaitForChild("knit"):WaitForChild("Services"):WaitForChild("InventoryService"):WaitForChild("RE"):WaitForChild("updateInventory"):FireServer(unpack(args))
    end
end

-- Function GetList (giữ nguyên)
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

-- Nút chọn vũ khí
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

-- Cập nhật hiển thị vũ khí
spawn(function()
    while wait(1.5) do
        if _G.AttackWeapon then
            selectedWeaponButton:SetDesc("Weapon Hiện Tại : " .. _G.AttackWeapon)
        end
    end
end)

-- Nút bật/tắt balo
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

-- Toggle Auto Buy bang gac
local Toggle1 = Tabs.Main:AddToggle("AutoGiangHo", {Title = "Auto Buy bang gac", Default = _G.AutoBuyBangGac })
Toggle1:OnChanged(function(Value)
    _G.AutoBuyBangGac = Value
end)

-- Toggle Auto Bang Gac
local Toggle2 = Tabs.Main:AddToggle("AutoBangGac", {Title = "Auto Bang Gac", Default = _G.AutoBangGac })
Toggle2:OnChanged(function(Value)
    _G.AutoBangGac = Value
end)

-- Auto Bang Gac logic
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

-- Auto Buy bang gac logic
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

-- Toggle Auto Heal (ĐÃ SỬA)
local ToggleAutoHeal = Tabs.Main:AddToggle("AutoHealToggle", {
    Title = "Auto Heal HP < 90%",
    Default = false
})

ToggleAutoHeal:OnChanged(function(Value)
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
end)

-- AUTO HEAL LOGIC (ĐÃ SỬA - ĐÂY LÀ PHẦN QUAN TRỌNG NHẤT)
spawn(function()
    while task.wait(0.75) do  -- Kiểm tra mỗi 0.5 giây
        -- Kiểm tra nếu auto heal được bật
        if not _G.AutoHeal then
            task.wait()
            continue
        end
        
        -- Lấy player và character
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then 
            task.wait()
            continue 
        end
        
        -- Lấy humanoid
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then 
            task.wait()
            continue 
        end
        
        -- Tính % máu
        local healthPercent = (humanoid.Health / humanoid.MaxHealth) * 100
        
        -- Debug: In ra % máu (có thể bỏ comment để kiểm tra)
        -- print("HP: " .. healthPercent .. "%")
        
        -- Kiểm tra nếu máu dưới ngưỡng
        if healthPercent < _G.LowHPThreshold then
            print("Máu thấp: " .. healthPercent .. "%, đang dùng băng gạc...")
            
            -- Tìm băng gạc trong backpack hoặc character
            local bandage = player.Backpack:FindFirstChild("băng gạc") or character:FindFirstChild("băng gạc")
            
            if bandage then
                -- Đưa băng gạc lên tay
                if bandage.Parent == player.Backpack then
                    bandage.Parent = character
                    task.wait(0.2)
                end
                
                -- Sử dụng băng gạc
                local success = pcall(function()
                    -- Kích hoạt sử dụng item
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                end)
                
                if success then
                    print("Đã sử dụng băng gạc")
                    task.wait(1)  -- Chờ hồi máu
                    
                    -- Trang bị lại vũ khí cũ nếu có
                    if _G.AttackWeapon then
                        local weapon = player.Backpack:FindFirstChild(_G.AttackWeapon)
                        if weapon then
                            weapon.Parent = character
                        end
                    end
                end
            else
                print("Không có băng gạc để heal!")
            end
        end
    end
end)

-- Toggle Auto Giang Hồ
local ToggleGiangHo = Tabs.Main:AddToggle("AutoGiangHo", {
    Title = "Auto Giang Hồ",
    Default = false
})
ToggleGiangHo:OnChanged(function(Value)
    _G.AutoFarmGiangho = Value
end)

-- Auto Giang Hồ logic
spawn(function()
    while wait() do
        if _G.DisableALLautogiangho then
            break
        end
        if _G.AutoFarmGiangho and not _G.DisableALLautogiangho and (Vector3.new(871, 29, -1423) - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5000 then
            for i,v in pairs(workspace.CityNPCs.NPCs:GetChildren()) do
                if v:FindFirstChild('HumanoidRootPart') and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then
                    repeat 
                        task.wait() 
                        pcall(function()
                            -- Nhặt đồ
                            for i,v in pairs(workspace.CityNPCs.Drop:GetChildren()) do
                                if v:FindFirstChild("ProximityPrompt") or v:FindFirstChildOfClass('ProximityPrompt') then
                                    local itemdrop = v:FindFirstChild("ProximityPrompt") or v:FindFirstChildOfClass('ProximityPrompt')
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                                    Prompt(itemdrop)
                                end
                            end
                            
                            -- Đánh quái
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0,0,11) * CFrame.Angles(math.rad(0), 0, 0)
                            EquipWeapon(_G.AttackWeapon)
                            game:GetService('VirtualUser'):CaptureController()
                            game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
                        end)
                    until not v:FindFirstChild('HumanoidRootPart') or not v:FindFirstChild('Humanoid') or v.Humanoid.Health <= 0 or _G.DisableALLautogiangho
                end
            end
        end
    end
end)

-- Auto click khi auto giang hồ
spawn(function()
    while wait() do
        if _G.AutoFarmGiangho and not _G.DisableALLautogiangho then
            game:GetService('VirtualUser'):CaptureController()
            game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672))
        end
    end
end)

-- Save/Load manager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Chọn tab đầu tiên
Window:SelectTab(1)

-- Thông báo khởi động
Fluent:Notify({
    Title = "Angels of Death",
    Content = "AD - Đã fix auto heal",
    Duration = 8
})
