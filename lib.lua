local CoreGui = game:GetService("CoreGui")

local Functions = {}
local Objects = {}

local Library__ = {
    Background = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(0, 200, 200),
    Text = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Roboto
}

local SCREEN = Instance.new("ScreenGui")
SCREEN.Parent = CoreGui
SCREEN.IgnoreGuiInset = true
SCREEN.ResetOnSpawn = false

Functions["Create"] = function(Class, Properties)
    if not Class or not Properties then return end
    local Object = Instance.new(Class)

    for p, v in pairs(Properties) do
        Object[p] = v
    end

    table.insert(Objects, Object)
    return Object
end

Functions["AddWindow"] = function(Name)
    local Frame = Functions.Create("Frame", {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library__.Background,
        Size = UDim2.new(0, 700, 0, 900),
        BackgroundTransparency = 0,
        Parent = SCREEN,
        Name = "FR1"
    })

    local FrameLabel = Functions.Create("Frame", {
        Parent = Frame,
        Name = "FR2",
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Library__.Background,
        BackgroundTransparency = 0.2
    })

    local Label = Functions.Create("TextLabel", {
        Name = "TEXT",
        Text = Name,
        TextSize = 16,
        Font = Library__.Font,
        Parent = FrameLabel,
        TextColor3 = Library__.Text,
        BackgroundTransparency = 1,
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
end
