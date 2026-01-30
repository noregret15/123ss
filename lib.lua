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
        local gui=Create("ScreenGui",{Parent=CoreGui,ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
        local holder=Create("Frame",{Parent=gui,AnchorPoint=Vector2.new(1,1),Position=UDim2.fromScale(1,1),Size=UDim2.fromOffset(320,500),BackgroundTransparency=1})
        Create("UIListLayout",{Parent=holder,Padding=UDim.new(0,8),VerticalAlignment=Enum.VerticalAlignment.Bottom,HorizontalAlignment=Enum.HorizontalAlignment.Right})
        self.NotificationGui=holder
    end
    local note=Create("Frame",{Parent=self.NotificationGui,Size=UDim2.fromOffset(320,56),BackgroundColor3=self.Theme.Dark,BorderSizePixel=0})
    local textLabel=Create("TextLabel",{Parent=note,Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-20,1,0),BackgroundTransparency=1,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,Font=Enum.Font.Gotham,TextSize=14,TextColor3=self.Theme.Text,Text=text})
    note.BackgroundTransparency=1
    note.Position=UDim2.fromOffset(40,0)
    Tween(note,0.25,{BackgroundTransparency=0,Position=UDim2.fromOffset(0,0)})
    task.delay(duration,function()
        Tween(note,0.25,{BackgroundTransparency=1,Position=UDim2.fromOffset(40,0)})
        task.wait(0.25)
        note:Destroy()
    end)
end

function Library:CreateWindow(title,fade)
    fade=fade or 0.25
    local Gui=Create("ScreenGui",{Parent=CoreGui,ResetOnSpawn=false})
    local Main=Create("Frame",{Parent=Gui,AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromScale(0,0),BackgroundColor3=self.Theme.Background,BorderSizePixel=0})
    Tween(Main,fade,{Size=UDim2.fromOffset(700,520)})

    Create("TextLabel",{Parent=Main,Size=UDim2.new(1,0,0,40),BackgroundTransparency=1,Text=title,Font=Enum.Font.GothamBold,TextSize=20,TextColor3=self.Theme.Text})

    local TabsBar=Create("Frame",{Parent=Main,Position=UDim2.fromOffset(0,40),Size=UDim2.new(1,0,0,36),BackgroundColor3=self.Theme.Light,BorderSizePixel=0})
    Create("UIListLayout",{Parent=TabsBar,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4)})

    local Pages=Create("Frame",{Parent=Main,Position=UDim2.fromOffset(10,86),Size=UDim2.new(1,-20,1,-96),BackgroundTransparency=1})

    local Hidden=false
    UserInputService.InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode==Enum.KeyCode.LeftAlt then
            Hidden=not Hidden
            Tween(Main,0.25,{Size=Hidden and UDim2.fromScale(0,0) or UDim2.fromOffset(700,520)})
        end
    end)

    local Window={}
    local CurrentTab=nil

    function Window:AddTab(name)
        local Tab={}
        local Btn=Create("TextButton",{Parent=TabsBar,Size=UDim2.fromOffset(130,30),Text=name,Font=Enum.Font.Gotham,TextSize=14,TextColor3=Library.Theme.SubText,BackgroundColor3=Library.Theme.Dark,BorderSizePixel=0})
        local Page=Create("Frame",{Parent=Pages,Size=UDim2.fromScale(1,1),Visible=false,BackgroundTransparency=1})

        local Left=Create("Frame",{Parent=Page,Size=UDim2.fromScale(0.48,1),BackgroundTransparency=1})
        local Right=Create("Frame",{Parent=Page,Position=UDim2.fromScale(0.52,0),Size=UDim2.fromScale(0.48,1),BackgroundTransparency=1})
        Create("UIListLayout",{Parent=Left,Padding=UDim.new(0,8),VerticalAlignment=Enum.VerticalAlignment.Top})
        Create("UIListLayout",{Parent=Right,Padding=UDim.new(0,8),VerticalAlignment=Enum.VerticalAlignment.Top})

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

        local function AddGroup(parent,gname)
            local Group={}
            local Frame=Create("Frame",{Parent=parent,Size=UDim2.new(1,0,0,36),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=Library.Theme.Light,BorderSizePixel=0})
            local Header=Create("TextButton",{Parent=Frame,Size=UDim2.new(1,0,0,30),BackgroundTransparency=1,Text=gname,Font=Enum.Font.GothamBold,TextSize=13,TextColor3=Library.Theme.Text})
            local Holder=Create("Frame",{Parent=Frame,Position=UDim2.fromOffset(6,32),Size=UDim2.new(1,-12,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1})
            Create("UIListLayout",{Parent=Holder,Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Top})

            function Group:AddButton(text,callback)
                local B=Create("TextButton",{Parent=Holder,Size=UDim2.new(1,0,0,26),Text=text,Font=Enum.Font.Gotham,TextSize=13,TextColor3=Library.Theme.Text,BackgroundColor3=Library.Theme.Dark,BorderSizePixel=0})
                B.MouseButton1Click:Connect(function()
                    Tween(B,0.1,{BackgroundColor3=Library.Theme.Accent})
                    task.delay(0.1,function()
                        Tween(B,0.1,{BackgroundColor3=Library.Theme.Dark})
                    end)
                    callback()
                end)
            end

            function Group:AddToggle(flag,default,callback)
                Library.Flags[flag]=default
                local T=Create("TextButton",{Parent=Holder,Size=UDim2.new(1,0,0,26),Font=Enum.Font.Gotham,TextSize=13,BorderSizePixel=0})
                local function Refresh()
                    T.Text=flag.." ["..(Library.Flags[flag] and "ON" or "OFF").."]"
                    T.TextColor3=Library.Theme.Text
                    T.BackgroundColor3=Library.Flags[flag] and Library.Theme.Positive or Library.Theme.Dark
                end
                Refresh()
                T.MouseButton1Click:Connect(function()
                    Library.Flags[flag]=not Library.Flags[flag]
                    Refresh()
                    callback(Library.Flags[flag])
                end)
                return {SetValue=function(_,v)Library.Flags[flag]=v Refresh()end}
            end

            function Group:AddSlider(flag,min,max,default,step,callback)
                step=step or 1
                Library.Flags[flag]=default
                local F=Create("Frame",{Parent=Holder,Size=UDim2.new(1,0,0,36),BackgroundColor3=Library.Theme.Dark,BorderSizePixel=0})
                local L=Create("TextLabel",{Parent=F,Size=UDim2.new(1,-10,0,16),Position=UDim2.fromOffset(5,2),BackgroundTransparency=1,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,Font=Enum.Font.Gotham,TextSize=13,TextColor3=Library.Theme.Text})
                local B=Create("Frame",{Parent=F,Position=UDim2.fromOffset(5,22),Size=UDim2.new(1,-10,0,8),BackgroundColor3=Library.Theme.Light,BorderSizePixel=0})
                local Fill=Create("Frame",{Parent=B,Size=UDim2.fromScale(0,1),BackgroundColor3=Library.Theme.Accent,BorderSizePixel=0})
                local Drag=false
                local function Set(v)
                    v=math.clamp(math.floor(v/step+0.5)*step,min,max)
                    Library.Flags[flag]=v
                    L.Text=flag..": "..v
                    Tween(Fill,0.08,{Size=UDim2.fromScale((v-min)/(max-min),1)})
                    callback(v)
                end
                Set(default)
                B.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then Drag=true end end)
                UserInputService.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then Drag=false end end)
                RunService.RenderStepped:Connect(function()
                    if Drag then
                        local pos=(Mouse.X-B.AbsolutePosition.X)/B.AbsoluteSize.X
                        Set(min+(max-min)*pos)
                    end
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
