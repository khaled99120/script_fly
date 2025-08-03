return function(Settings)
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local StarterGui = game:GetService("StarterGui")

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local flying = false

    -- Set WalkSpeed
    humanoid.WalkSpeed = Settings.WalkSpeed or 32

    -- Fly function
    local function startFlying()
        if flying then return end
        flying = true

        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
        bv.Velocity = Vector3.zero
        bv.Parent = character:WaitForChild("HumanoidRootPart")

        RunService:BindToRenderStep("Flying", Enum.RenderPriority.Character.Value + 1, function()
            if flying and character and character:FindFirstChild("HumanoidRootPart") then
                local moveDir = Vector3.zero
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    moveDir += workspace.CurrentCamera.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    moveDir -= workspace.CurrentCamera.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir += Vector3.new(0,1,0)
                end
                character.HumanoidRootPart.FlyVelocity.Velocity = moveDir.Unit * (Settings.FlySpeed or 50)
            end
        end)
    end

    local function stopFlying()
        flying = false
        RunService:UnbindFromRenderStep("Flying")
        local part = character:FindFirstChild("HumanoidRootPart")
        if part and part:FindFirstChild("FlyVelocity") then
            part.FlyVelocity:Destroy()
        end
    end

    local function toggleFly()
        if flying then
            stopFlying()
        else
            startFlying()
        end
    end

    -- Optional GUI Button
    if Settings.FlyToggleButton then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FlyControl"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = player:WaitForChild("PlayerGui")

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 100, 0, 40)
        button.Position = UDim2.new(0, 20, 0, 100)
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Text = "Toggle Fly"
        button.Parent = screenGui
        button.Active = true
        button.Draggable = true
        button.MouseButton1Click:Connect(toggleFly)
    end
end
