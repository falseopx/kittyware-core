local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint
local mouse = game.Players.LocalPlayer:GetMouse()
local UserInput = game:GetService("UserInputService")

getgenv().esp_settings = {
    boxes = false,
    names = false,
    tracers = false,
    chams = false,
    font = 3,
    teammates = false,
    visibleonly = false,
    unlocktracers = false,
    textsize = 16,
    bottomtext = "catgirls > all",
    boxoutline = false,
    colors = {
        boxes = Color3.fromRGB(255, 255, 255),
        tracers = Color3.fromRGB(255, 255, 255),
        names = Color3.fromRGB(255, 255, 255),
        chams = Color3.fromRGB(255, 255, 255),
        bottomtext = Color3.fromRGB(255, 255, 255)
    }
}

assert(getgenv().esp_settings, "settings not found")

function AttachChams(parent, face)
	local SurfaceGui = Instance.new("SurfaceGui",parent) 
	SurfaceGui.Parent = parent
	SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SurfaceGui.Face = Enum.NormalId[face]
	SurfaceGui.LightInfluence = 0
	SurfaceGui.ResetOnSpawn = false
	SurfaceGui.Name = "Body"
	SurfaceGui.AlwaysOnTop = true
	local Frame = Instance.new("Frame",SurfaceGui)
	Frame.BackgroundColor3 = esp_settings.colors.chams
	Frame.Size = UDim2.new(1,0,1,0)
end

local function esp(v)
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0,0,0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1,1,1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    local HealthBarOutline = Drawing.new("Square")
    HealthBarOutline.Thickness = 3
    HealthBarOutline.Filled = false
    HealthBarOutline.Color = Color3.new(0,0,0)
    HealthBarOutline.Transparency = 1
    HealthBarOutline.Visible = false

    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = 1
    HealthBar.Filled = false
    HealthBar.Transparency = 1
    HealthBar.Visible = false
    
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.new(1,1,1)
    Tracer.Thickness = 1
    Tracer.Transparency = 1
    
    local Name = Drawing.new("Text")
    Name.Transparency = 1
    Name.Visible = false
    Name.Color = Color3.new(1,1,1)
    Name.Size = 12
    Name.Center = true
    Name.Outline = true
    

    local Gun = Drawing.new("Text")
    Gun.Transparency = 1
    Gun.Visible = false
    Gun.Color = Color3.new(1,1,1)
    Gun.Size = 12
    Gun.Center = true
    Gun.Outline = true

    game:GetService("RunService").RenderStepped:Connect(function()
        if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 then
            local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (CurrentCamera.CFrame.p - v.Character.HumanoidRootPart.Position).Magnitude
            local RootPart = v.Character.HumanoidRootPart
            local Head = v.Character.Head
            local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
            local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + Vector3.new(0,0.5,0))
            local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - Vector3.new(0,3,0))
                
            if esp_settings.chams and v.Character.Head:FindFirstChild("Body") == nil then
                for i,v in pairs(v.Character:GetChildren()) do
                    if v:IsA("MeshPart") or v.Name == "Head" then
                        AttachChams(v, "Back")
                        AttachChams(v, "Front")
                        AttachChams(v, "Top")
                        AttachChams(v, "Bottom")
                        AttachChams(v, "Right")
                        AttachChams(v, "Left")
                    end
                end
            end

            if onScreen then
                if esp_settings.boxes then
                    BoxOutline.Size = Vector2.new(2500 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)
                    BoxOutline.Visible = esp_settings.boxoutline
    
                    Box.Size = Vector2.new(2500 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)
                    Box.Visible = true
                    Box.Color = esp_settings.colors.boxes
                        
                    HealthBarOutline.Size = Vector2.new(2, HeadPosition.Y - LegPosition.Y)
                    HealthBarOutline.Position = BoxOutline.Position - Vector2.new(6,0)
                    HealthBarOutline.Visible = true
    
                    HealthBar.Size = Vector2.new(2, (HeadPosition.Y - LegPosition.Y) / (v.Character.Humanoid.MaxHealth / math.clamp(v.Character.Humanoid.Health, 0,v.Character.Humanoid.MaxHealth)))
                    HealthBar.Position = Vector2.new(Box.Position.X - 6, Box.Position.Y + (1 / HealthBar.Size.Y))
                    HealthBar.Color = Color3.fromRGB(255 - 255 / (v.Character.Humanoid.MaxHealth / v.Character.Humanoid.Health), 255 / (v.Character.Humanoid.MaxHealth / v.Character.Humanoid.Health), 0)
                    HealthBar.Visible = true
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                    HealthBarOutline.Visible = false
                    HealthBar.Visible = false
                end
                if esp_settings.tracers then
                    if esp_settings.unlocktracers then
                        Tracer.From = Vector2.new(mouse.X, mouse.Y + 36)
                    else
                        Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    end
                    Tracer.To = Vector2.new(Vector.X, Vector.Y)
                    Tracer.Color = esp_settings.colors.tracers
                    Tracer.Visible = true
                else
                    Tracer.Visible = false
                end
                if esp_settings.names then
                    Name.Text = tostring(v.Name)
                    Name.Position = Vector2.new(workspace.Camera:WorldToViewportPoint(v.Character.Head.Position).X, workspace.Camera:WorldToViewportPoint(v.Character.Head.Position).Y - 30)
                    Name.Visible = true
                    Name.Size = esp_settings.textsize
                    Name.Color = esp_settings.colors.names
                    if esp_settings.font == "UI" then
                        Name.Font = 0
                        Gun.Font = 0
                    elseif esp_settings.font == "System" then
                        Name.Font = 1
                        Gun.Font = 1
                    elseif esp_settings.font == "Plex" then
                        Name.Font = 2
                        Gun.Font = 2
                    elseif esp_settings.font == "Monospace" then
                        Name.Font = 3
                        Gun.Font = 3
                    end
                    Gun.Size = esp_settings.textsize
                    Gun.Text = tostring(esp_settings.bottomtext)
                    Gun.Color = esp_settings.colors.bottomtext
                    Gun.Position = Vector2.new(LegPosition.X, LegPosition.Y + 10)
                    Gun.Visible = true
                else
                    Name.Visible = false
                    Gun.Visible = false
                end
            else
                BoxOutline.Visible = false
                Box.Visible = false
                HealthBarOutline.Visible = false
                HealthBar.Visible = false
                Tracer.Visible = false
                Name.Visible = false
                Gun.Visible = false
            end
        else
            BoxOutline.Visible = false
            Box.Visible = false
            HealthBarOutline.Visible = false
            HealthBar.Visible = false
            Tracer.Visible = false
            Name.Visible = false
            Gun.Visible = false
        end
    end)
end

for i,v in pairs(game.Players:GetChildren()) do
    esp(v)
end

game.Players.PlayerAdded:Connect(function(v)
    esp(v)
end)
