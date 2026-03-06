warn("Anti afk")
game:GetService("Players").LocalPlayer.Idled:connect(function()
warn("CẶC!")
game:GetService("VirtualUser"):CaptureController()
game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local allowedUsers = loadstring(game:HttpGet("https://raw.githubusercontent.com/minhphuong12748-afk/User/refs/heads/main/User%20script"))()
local currentUserName = game.Players.LocalPlayer.Name

if not allowedUsers[currentUserName] then
    -- Thông báo không được phép
    game.StarterGui:SetCore("SendNotification", {
        Title = "LỒN";
        Text = "CÓ CÁI LỒN MẸ M ĐÒI SÀI KÉ";
        Duration = 5;
    })
    
    -- Xóa GUI nếu đã tạo
    pcall(function()
        for _, v in pairs(game.CoreGui:GetChildren()) do
            if v.Name == "Fluent" or v:FindFirstChild("Fluent") then
                v:Destroy()
            end
        end
    end)
    
    -- Dừng script
    return
end
-- Ẩn tất cả output console (chặn log F12)
local oldprint = print
print = function() end
_G.print = function() end
warn = function() end
error = function() end

-- Chặn các phương thức log khác
if hookfunction then
    local oldprint = print
    print = function() end
    warn = function() end
    error = function() end
end

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
_G.AutoFarmGiangho = false
_G.DisableALLautogiangho = false

local function GetHealthPercent()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return 100 end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return 100 end
    return (humanoid.Health / humanoid.MaxHealth) * 100
end

function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip and ToolSe then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        if tool then
            wait(0.1)
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
        end
    end
end

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

function CheckItem(vukhi)
    local player = game:GetService("Players").LocalPlayer
    local inventory = player.PlayerGui.Inventory.MainFrame.List
    return inventory:FindFirstChild(vukhi) ~= nil
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

function GetList()
    local player = game:GetService("Players").LocalPlayer
    local inventory = player.PlayerGui.Inventory.MainFrame.List
    local tableweaponlist = {}
    for i,v in pairs(inventory:GetChildren()) do
        table.insert(tableweaponlist,v.Name)
        -- Đã xóa print
    end
    return tableweaponlist
end

-- Xóa nút chọn vũ khí

-- Xóa nút bật/tắt balo

local Toggle1 = Tabs.Main:AddToggle("AutoGiangHo", {Title = "Auto Buy bang gac", Default = _G.AutoBuyBangGac })
Toggle1:OnChanged(function(Value)
    _G.AutoBuyBangGac = Value
end)
local Toggle2 = Tabs.Main:AddToggle("AutoBangGac", {Title = "Auto Bang Gac", Default = _G.AutoBangGac })
Toggle2:OnChanged(function(Value)
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

spawn(function()
    while task.wait(0.75) do
        if not _G.AutoHeal then
            task.wait()
            continue
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then 
            task.wait()
            continue 
        end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then 
            task.wait()
            continue 
        end
        
        local healthPercent = (humanoid.Health / humanoid.MaxHealth) * 100
        
        if healthPercent < _G.LowHPThreshold then
            -- Đã xóa các dòng print
            
            local currentWeapon = character:FindFirstChildOfClass("Tool")
            local currentWeaponName = currentWeapon and currentWeapon.Name or _G.AttackWeapon
            
            local bandage = player.Backpack:FindFirstChild("băng gạc") or character:FindFirstChild("băng gạc")
            
            if bandage then
                if bandage.Parent == player.Backpack then
                    bandage.Parent = character
                    task.wait(0.2)
                end
                
                local success = pcall(function()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                end)
                
                if success then
                    -- Đã xóa print
                    task.wait(1)
                    
                    if _G.AttackWeapon then
                        local weapon = player.Backpack:FindFirstChild(_G.AttackWeapon)
                        if weapon then
                            weapon.Parent = character
                            -- Đã xóa print
                        else
                            weapon = character:FindFirstChild(_G.AttackWeapon)
                            if weapon and weapon ~= bandage then
                                -- Đã xóa print
                            else
                                -- Đã xóa print
                            end
                        end
                    elseif currentWeaponName and currentWeaponName ~= "băng gạc" then
                        local weapon = player.Backpack:FindFirstChild(currentWeaponName)
                        if weapon then
                            weapon.Parent = character
                            -- Đã xóa print
                        end
                    end
                end
            else
                -- Đã xóa print
            end
        end
    end
end)

local speed = Tabs.Main:AddButton({
    Title = "Speed",
    Description = "AD DANG CAP MA DUNG KHONG?",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BakerBo1/Tpwalk.V4/refs/heads/main/TpWalkV4"))()
    end
})

Tabs.Main:AddButton({
    Title = "Bật balo và ấn đây",
    Description = "nhớ bật r ẩn tui trước khi heal nha <3",
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
-- Xóa Toggle Auto Giang Hồ
-- Xóa các spawn function liên quan đến Auto Giang Hồ

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
