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
    Title = "Equip Best Pet",
    Callback = function()
        pcall(petAction.FireServer, petAction, "Equip Best")
    end
})



local RebirthTab = Window:Tab({
    Title = "Rebirth",
    Icon = "solar:refresh-bold",
})

local rebirthEvent = game:GetService("ReplicatedStorage").Game.Events.Rebirth
local rebirthCount = 1
local rebirthThread = nil
local rebirthRunning = false

RebirthTab:Input({
    Title = "Amount",
    Value = "1",
    Placeholder = "Times to rebirth...",
    Callback = function(value)
        rebirthCount = tonumber(value) or 1
    end
})

RebirthTab:Button({
    Title = "Rebirth 1x",
    Callback = function()
        pcall(rebirthEvent.FireServer, rebirthEvent, 1)
    end
})

RebirthTab:Button({
    Title = "Rebirth Amount",
    Callback = function()
        if rebirthRunning then return end
        rebirthRunning = true
        rebirthThread = task.spawn(function()
            for i = 1, rebirthCount do
                if not rebirthRunning then break end
                local ok = pcall(rebirthEvent.FireServer, rebirthEvent, 1)
                if not ok then break end
                task.wait()
            end
            rebirthRunning = false
            rebirthThread = nil
            WindUI:Notify({
                Title = "Done",
                Content = "Tried " .. rebirthCount .. " rebirths",
                Duration = 2,
            })
        end)
    end
})

RebirthTab:Button({
    Title = "Rebirth Until Fail",
    Callback = function()
        if rebirthRunning then return end
        rebirthRunning = true
        rebirthThread = task.spawn(function()
            local n = 0
            while rebirthRunning and task.wait() do
                local ok = pcall(rebirthEvent.FireServer, rebirthEvent, 1)
                if not ok then break end
                n = n + 1
            end
            rebirthRunning = false
            rebirthThread = nil
            WindUI:Notify({
                Title = "Done",
                Content = tostring(n) .. " rebirths done",
                Duration = 3,
            })
        end)
    end
})

RebirthTab:Button({
    Title = "Stop Rebirths",
    Callback = function()
        rebirthRunning = false
        if rebirthThread then
            task.cancel(rebirthThread)
            rebirthThread = nil
        end
        WindUI:Notify({
            Title = "Stopped",
            Content = "Rebirth loop cancelled",
            Duration = 2,
        })
    end
})
