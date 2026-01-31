local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local CoreGui=game:GetService("CoreGui")

local Player=Players.LocalPlayer
local Mouse=Player:GetMouse()

local Library={}
Library.Flags={}
Library.Theme={
    Background=Color3.fromRGB(18,18,18),
    Dark=Color3.fromRGB(28,28,28),
    Light=Color3.fromRGB(35,35,35),
    Accent=Color3.fromRGB(90,140,255),
    Text=Color3.fromRGB(235,235,235),
    SubText=Color3.fromRGB(180,180,180),
    Positive=Color3.fromRGB(70,110,70),
    Negative=Color3.fromRGB(110,70,70)
}

local function Tween(o,t,p)
    TweenService:Create(o,TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p):Play()
end

local function Create(c,p)
    local i=Instance.new(c)
    for k,v in pairs(p) do
        i[k]=v
    end
    return i
end

function Library:Notify(text,duration)
    duration=duration or 3
    if not self.NotificationGui then
        local gui=Create("ScreenGui",{Parent=CoreGui,ResetOnSpawn=false})
        local holder=Create("Frame",{Parent=gui,AnchorPoint=Vector2.new(1,1),Position=UDim2.fromScale(1,1),Size=UDim2.fromOffset(320,500),BackgroundTransparency=1})
        Create("UIListLayout",{Parent=holder,Padding=UDim.new(0,8),VerticalAlignment=Enum.VerticalAlignment.Bottom})
        self.NotificationGui=holder
    end
    local n=Create("Frame",{Parent=self.NotificationGui,Size=UDim2.fromOffset(320,56),BackgroundColor3=self.Theme.Dark,BorderSizePixel=0})
    local t=Create("TextLabel",{Parent=n,Size=UDim2.new(1,-20,1,0),Position=UDim2.fromOffset(10,0),BackgroundTransparency=1,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,Font=Enum.Font.Gotham,TextSize=14,TextColor3=self.Theme.Text,Text=text})
    n.BackgroundTransparency=1
    n.Position=UDim2.fromOffset(40,0)
    Tween(n,0.25,{BackgroundTransparency=0,Position=UDim2.new(0,0,0,0)})
    task.delay(duration,function()
        Tween(n,0.25,{BackgroundTransparency=1,Position=UDim2.fromOffset(40,0)})
        task.wait(0.25)
        n:Destroy()
    end)
end

function Library:CreateWindow(title,fade)
    fade=fade or 0.25
    local Gui=Create("ScreenGui",{Parent=CoreGui,ResetOnSpawn=false})
    local Main=Create("Frame",{Parent=Gui,Size=UDim2.fromOffset(700,520),AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),BackgroundColor3=self.Theme.Background,BorderSizePixel=0})
    Main.Size=UDim2.fromScale(0,0)
    Tween(Main,fade,{Size=UDim2.fromOffset(700,520)})

    local Top=Create("Frame",{Parent=Main,Size=UDim2.new(1,0,0,40),BackgroundColor3=self.Theme.Dark,BorderSizePixel=0})
    Create("TextLabel",{Parent=Top,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=title,Font=Enum.Font.GothamBold,TextSize=18,TextColor3=self.Theme.Text})

    local dragging=false
    local dragStart, startPos

    Top.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            dragStart=i.Position
            startPos=Main.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            local delta=UserInputService:GetMouseLocation()-dragStart
            Main.Position=startPos+UDim2.fromOffset(delta.X,delta.Y)
        end
    end)

    local TabsBar=Create("Frame",{Parent=Main,Position=UDim2.fromOffset(0,40),Size=UDim2.new(1,0,0,34),BackgroundColor3=self.Theme.Light,BorderSizePixel=0})
    Create("UIListLayout",{Parent=TabsBar,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4)})

    local Pages=Create("Frame",{Parent=Main,Position=UDim2.fromOffset(10,84),Size=UDim2.new(1,-20,1,-94),BackgroundTransparency=1})

    local Window={}
    local CurrentTab=nil

    function Window:AddTab(name)
        local Tab={}
        local Btn=Create("TextButton",{Parent=TabsBar,Size=UDim2.fromOffset(120,28),Text=name,Font=Enum.Font.Gotham,TextSize=13,TextColor3=Library.Theme.SubText,BackgroundColor3=Library.Theme.Dark,BorderSizePixel=0})
        local Page=Create("Frame",{Parent=Pages,Size=UDim2.fromScale(1,1),Visible=false,BackgroundTransparency=1})

        local Left=Create("Frame",{Parent=Page,Size=UDim2.fromScale(0.48,1),BackgroundTransparency=1})
        local Right=Create("Frame",{Parent=Page,Position=UDim2.fromScale(0.52,0),Size=UDim2.fromScale(0.48,1),BackgroundTransparency=1})
        Create("UIListLayout",{Parent=Left,Padding=UDim.new(0,8)})
        Create("UIListLayout",{Parent=Right,Padding=UDim.new(0,8)})

        local function Activate()
            if CurrentTab then
                CurrentTab.Page.Visible=false
                Tween(CurrentTab.Button,0.15,{BackgroundColor3=Library.Theme.Dark,TextColor3=Library.Theme.SubText})
            end
            CurrentTab={Button=Btn,Page=Page}
            Page.Visible=true
            Tween(Btn,0.15,{BackgroundColor3=Library.Theme.Accent,TextColor3=Color3.new(1,1,1)})
        end

        Btn.MouseButton1Click:Connect(Activate)
        if not CurrentTab then Activate() end

        local function AddGroup(parent,name)
            local Group={}
            local Frame=Create("Frame",{Parent=parent,Size=UDim2.new(1,0,0,32),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=Library.Theme.Light,BorderSizePixel=0})
            Create("TextLabel",{Parent=Frame,Size=UDim2.new(1,0,0,26),BackgroundTransparency=1,Text=name,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=Library.Theme.Text})
            local Holder=Create("Frame",{Parent=Frame,Position=UDim2.fromOffset(6,28),Size=UDim2.new(1,-12,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
            Create("UIListLayout",{Parent=Holder,Padding=UDim.new(0,6)})

            function Group:AddTextbox(flag,default,callback)
                Library.Flags[flag]=default or ""
                local B=Create("TextBox",{Parent=Holder,Size=UDim2.new(1,0,0,26),Text=Library.Flags[flag],Font=Enum.Font.Gotham,TextSize=13,TextColor3=Library.Theme.Text,BackgroundColor3=Library.Theme.Dark,ClearTextOnFocus=false,BorderSizePixel=0})
                B.FocusLost:Connect(function()
                    Library.Flags[flag]=B.Text
                    callback(B.Text)
                end)
            end

            return Group
        end

        function Tab:AddLeftGroup(n)return AddGroup(Left,n)end
        function Tab:AddRightGroup(n)return AddGroup(Right,n)end
        return Tab
    end

    return Window
end

return Library
