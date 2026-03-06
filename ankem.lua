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
    game.StarterGui:SetCore("SendNotification", {
        Title = "LỒN";
        Text = "CÓ CÁI LỒN MẸ M ĐÒI SÀI KÉ";
        Duration = 5;
    })
    
    pcall(function()
        for _, v in pairs(game.CoreGui:GetChildren()) do
            if v.Name == "Fluent" or v:FindFirstChild("Fluent") then
                v:Destroy()
            end
        end
    end)
    return
end

-- Ẩn output
print = function() end
_G.print = function() end
warn = function() end
error = function() end

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

-- BIẾN LƯU VŨ KHÍ
local lastWeapon = nil

-- HÀM LẤY VŨ KHÍ ĐANG CẦM
function GetCurrentWeapon()
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name ~= "băng gạc" then
                return tool.Name
            end
        end
    end
    return nil
end

-- HÀM CẦM VŨ KHÍ (ĐƠN GIẢN NHẤT)
function EquipWeapon(weaponName)
    if not weaponName then return false end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return false end
    
    -- Tìm trong Backpack
    local weapon = player.Backpack:FindFirstChild(weaponName)
    if weapon then
        -- Cầm vũ khí
        weapon.Parent = character
        return true
    end
    return false
end

-- CẬP NHẬT VŨ KHÍ LIÊN TỤC (mỗi 1 giây)
spawn(function()
    while true do
        task.wait(1)
        local currentWeapon = GetCurrentWeapon()
        if currentWeapon then
            lastWeapon = currentWeapon
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
    Title = "Auto Heal HP < 90% (tự động cầm lại vũ khí)",
    Default = false
})

ToggleAutoHeal:OnChanged(function(Value)
    _G.AutoHeal = Value
    if Value then
        Fluent:Notify({
            Title = "Auto Heal",
            Content = "Đã bật: Tự động dùng băng gạc khi HP dưới 90% và cầm lại vũ khí",
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

-- AUTO HEAL CHÍNH
spawn(function()
    while task.wait(0.3) do
        if not _G.AutoHeal then
            task.wait()
            continue
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then continue end
        
        local healthPercent = (humanoid.Health / humanoid.MaxHealth) * 100
        
        if healthPercent < _G.LowHPThreshold then
            -- LƯU VŨ KHÍ HIỆN TẠI
            local weaponBefore = GetCurrentWeapon()
            if weaponBefore then
                lastWeapon = weaponBefore
            end
            
            -- TÌM BĂNG GẠC
            local bandage = player.Backpack:FindFirstChild("băng gạc") or character:FindFirstChild("băng gạc")
            
            if bandage then
                -- CẦM BĂNG GẠC
                if bandage.Parent == player.Backpack then
                    bandage.Parent = character
                    task.wait(0.2)
                end
                
                -- DÙNG BĂNG GẠC
                pcall(function()
                    game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                end)
                
                task.wait(1.5) -- CHỜ HEAL XONG
                
                -- CẦM LẠI VŨ KHÍ (PHẦN QUAN TRỌNG)
                if lastWeapon then
                    -- Tìm trong Backpack
                    local weaponToEquip = player.Backpack:FindFirstChild(lastWeapon)
                    if weaponToEquip then
                        weaponToEquip.Parent = character
                    else
                        -- Nếu không có, tìm vũ khí bất kỳ
                        for _, tool in pairs(player.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool.Name ~= "băng gạc" then
                                tool.Parent = character
                                lastWeapon = tool.Name
                                break
                            end
                        end
                    end
                else
                    -- Nếu không có lastWeapon, tìm vũ khí bất kỳ
                    for _, tool in pairs(player.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name ~= "băng gạc" then
                            tool.Parent = character
                            lastWeapon = tool.Name
                            break
                        end
                    end
                end
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
