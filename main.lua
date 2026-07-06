local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Auto Farm",
    Folder = "AutoFarm",
    Icon = "solar:folder-2-bold-duotone",
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "solar:home-2-bold",
})

local click = game:GetService("ReplicatedStorage").Game.Events.Click

local clickThread

MainTab:Toggle({
    Title = "Auto Clicker",
    Flag = "Clicker",
    Callback = function(value)
        if clickThread then task.cancel(clickThread) end
        if value and click then
            clickThread = task.spawn(function()
                while task.wait(0.05) do
                    pcall(click.FireServer, click)
                end
            end)
        end
    end
})

local petAction = game:GetService("ReplicatedStorage").Game.Events.PetAction

MainTab:Button({
    Title = "Equip Best Pets",
    Callback = function()
        pcall(petAction.FireServer, petAction, "Equip Best")
    end
})
