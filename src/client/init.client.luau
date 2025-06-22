--Topbar icons example

local TweenService = game:GetService("TweenService")
local Notebook = require(game.ReplicatedStorage.Notebook)
local Image = Notebook.Image
local Corner = Notebook.Corner

local fullCorner = function() return Corner(0, {CornerRadius = UDim.new(1,0)}) {} end
local myPadding = function() return Notebook.UIPadding({
    PaddingTop = UDim.new(0,4),
    PaddingLeft = UDim.new(0,4),
    PaddingRight = UDim.new(0,4),
    PaddingBottom = UDim.new(0,4),
}) {} end

local Frame: Notebook.Page = Notebook.Page(function(none, native)
    return Notebook.Frame({BackgroundColor3 = Color3.fromRGB(18,18,21), BackgroundTransparency = 0.08}) {} :: Frame
end)

local Button: Notebook.Page = Notebook.Page(function(data: {Image: string, Activated: () -> ()}, native)
    local paddedImageButton: ImageButton = Notebook.ImageButton({AutoButtonColor = false, BackgroundTransparency = 1, BackgroundColor3 = Color3.fromRGB(208, 217, 251)}) {
        Corner = fullCorner,
        Padding = myPadding,
        Label = Image(data.Image, {
            Size = UDim2.new(1,0,1,0), 
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0),
            AnchorPoint = Vector2.new(0.5,0.5)
        }) {Corner = fullCorner}
    } :: ImageButton
    paddedImageButton.Activated:Connect(data.Activated)

    local downTween = TweenService:Create(
        paddedImageButton:FindFirstChild("Label"), 
        TweenInfo.new(0.08, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {Size = UDim2.new(0.85,0, 0.85,0)}
    )
    paddedImageButton.MouseButton1Down:Connect(function()
        downTween:Play()
    end)

	local upTween = TweenService:Create(
		paddedImageButton:FindFirstChild("Label"),
		TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ Size = UDim2.new(1, 0, 1, 0) }
	)
	paddedImageButton.MouseButton1Up:Connect(function()
		upTween:Play()
	end)

	local enterTween = TweenService:Create(
		paddedImageButton,
		TweenInfo.new(0.08, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 0.92 }
	)
	paddedImageButton.MouseEnter:Connect(function()
		enterTween:Play()
	end)

	local exitTween = TweenService:Create(
		paddedImageButton,
		TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 1 }
	)
	paddedImageButton.MouseLeave:Connect(function()
		exitTween:Play()
	end)

    return paddedImageButton
end)

local Button1 = Button({
    Image = "rbxassetid://85847002099254",
    Activated = function()
        print("hello, world!")
    end
}, {
    Size = UDim2.new(0,36,0,36),
    Position = UDim2.new(0,8,0.5,0),
    AnchorPoint = Vector2.new(0,0.5)
}) {}

local Button2 = Button({
	Image = "rbxassetid://109389688135170",
	Activated = function()
		print("hello, world 2!: Electric Boogaloo")
	end,
}, {
	Size = UDim2.new(0, 36, 0, 36),
    Position = UDim2.new(0,52,0.5,0),
    AnchorPoint = Vector2.new(0,0.5)
})({})

local screengui = Notebook.ScreenGui({ScreenInsets = Enum.ScreenInsets.None}) {
    Frame = Frame(nil, {Size = UDim2.new(0,96,0,44), Position = UDim2.new(0, 172, 0, 12)}) {
        Button1 = Button1,
        Button2 = Button2,
        Corner = fullCorner()
    },
    
}
screengui.Parent = game.Players.LocalPlayer.PlayerGui