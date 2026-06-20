-- made by bobo135, OP
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local TargetGui = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
local CollectRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/Collect")
local BallDropRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RE/BallDrop")
local RebirthRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/Rebirth")
local BrainrotRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/EquipBestBrainrots")
local QuickStackRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net"):WaitForChild("RF/QuickStack")
local autoCollect = false
local autoDrop = false
local autoRebirth = false
local autoBrainrot = false
local autoQuickStack = false
local MaxSlots = 12 
local DetectedPlotName = "Plot4"
local OFF_COLOR = Color3.fromRGB(150, 40, 40)

local function FindPlayerPlot()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local owner = obj:FindFirstChild("Owner") or obj:FindFirstChild("OwnerName") or obj:FindFirstChild("Player")
        if owner and (owner.Value == LocalPlayer or owner.Value == LocalPlayer.Name) then
            local current = obj
            while current and current.Parent ~= Workspace and current.Parent ~= nil do
                if string.find(string.lower(current.Name), "plot") or string.find(string.lower(current.Name), "tycoon") then
                    return current.Name, current
                end
                current = current.Parent
            end
            return obj.Name, obj
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("Folder") then
            if string.find(string.lower(obj.Name), string.lower(LocalPlayer.Name)) then
                return obj.Name, obj
            end
        end
    end
    local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Tycoons")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerName")
            if owner and (owner.Value == LocalPlayer or owner.Value == LocalPlayer.Name) then
                return plot.Name, plot
            end
        end
        if plotsFolder:FindFirstChild(DetectedPlotName) then
            return DetectedPlotName, plotsFolder[DetectedPlotName]
        end
    end
    return DetectedPlotName, nil
end

if TargetGui:FindFirstChild("TycoonMegaMenuFixed") then
    TargetGui.TycoonMegaMenuFixed:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TycoonMegaMenuFixed"
ScreenGui.Parent = TargetGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 280, 0, 375)
Frame.Position = UDim2.new(0.5, -140, 0.3, -187)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "Drop Balls For Brainrots Menu"
Title.TextSize = 22
Title.Font = Enum.Font.SourceSansBold 
Title.Parent = Frame

local function CreateButton(text, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 240, 0, 45)
    Btn.Position = UDim2.new(0, 20, 0, yPos)
    Btn.BackgroundColor3 = OFF_COLOR
    Btn.Text = text .. ": OFF"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 16 
    Btn.Font = Enum.Font.SourceSansBold 
    Btn.Parent = Frame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    return Btn
end

local CollectBtn  = CreateButton("Auto Collect", 50)
local DropBtn     = CreateButton("Auto Drop Balls", 105)
local RebirthBtn  = CreateButton("Auto Rebirth", 160)
local QuickStackBtn = CreateButton("Auto Quick Stack", 215)
local BrainrotBtn = CreateButton("Auto Equip Best Brainrot", 270)

local ActiveButtons = {}
local CurrentRainbowColor = Color3.fromRGB(255, 255, 255)

local function SetButtonState(btn, state, text)
    if state then
        btn.Text = text .. ": ON"
        ActiveButtons[btn] = true
    else
        ActiveButtons[btn] = nil
        btn.Text = text .. ": OFF"
        TweenService:Create(btn, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = OFF_COLOR}):Play()
    end
end

CollectBtn.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    SetButtonState(CollectBtn, autoCollect, "Auto Collect")
end)

DropBtn.MouseButton1Click:Connect(function()
    autoDrop = not autoDrop
    SetButtonState(DropBtn, autoDrop, "Auto Drop Balls")
end)

RebirthBtn.MouseButton1Click:Connect(function()
    autoRebirth = not autoRebirth
    SetButtonState(RebirthBtn, autoRebirth, "Auto Rebirth")
end)

QuickStackBtn.MouseButton1Click:Connect(function()
    autoQuickStack = not autoQuickStack
    SetButtonState(QuickStackBtn, autoQuickStack, "Auto Quick Stack")
end)

BrainrotBtn.MouseButton1Click:Connect(function()
    autoBrainrot = not autoBrainrot
    SetButtonState(BrainrotBtn, autoBrainrot, "Auto Equip Best Brainrot")
end)

task.spawn(function()
    while true do
        for i = 0, 1, 0.005 do
            CurrentRainbowColor = Color3.fromHSV(i, 0.8, 1)
            UIStroke.Color = CurrentRainbowColor
            Title.TextColor3 = CurrentRainbowColor
            
            for button, _ in pairs(ActiveButtons) do
                pcall(function()
                    TweenService:Create(button, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {BackgroundColor3 = CurrentRainbowColor}):Play()
                end)
            end
            task.wait(0.02)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        if autoCollect and CollectRemote:IsA("RemoteFunction") then
            local currentPlotName, _ = FindPlayerPlot()
            for slotIndex = 1, MaxSlots do
                if not autoCollect then break end
                pcall(function()
                    CollectRemote:InvokeServer(currentPlotName, tostring(slotIndex))
                end)
                task.wait(0.01)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if autoDrop and BallDropRemote:IsA("RemoteEvent") then
            pcall(function()
                BallDropRemote:FireServer(3)
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(1.5)
        if autoRebirth and RebirthRemote:IsA("RemoteFunction") then
            pcall(function()
                RebirthRemote:InvokeServer()
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if autoQuickStack and QuickStackRemote:IsA("RemoteFunction") then
            pcall(function()
                QuickStackRemote:InvokeServer()
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(5.0)
        if autoBrainrot and BrainrotRemote:IsA("RemoteFunction") then
            pcall(function()
                BrainrotRemote:InvokeServer()
            end)
        end
    end
end)
