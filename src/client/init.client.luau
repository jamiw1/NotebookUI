local Notebook = require(game.ReplicatedStorage.Notebook)
local Image = Notebook.Image
local Corner = Notebook.Corner

local myCorner = function() return Corner(20) {} end
local myPadding = Notebook.UIPadding({
    PaddingTop = UDim.new(0,40),
    PaddingLeft = UDim.new(0,40),
    PaddingRight = UDim.new(0,40),
    PaddingBottom = UDim.new(0,40),
}) {}

local FloatingFrame: Notebook.Page = Notebook.Page(function(none, native)
    return Notebook.Frame() {
        myCorner()
    } :: Frame
end)

local PaddedImageButton: Notebook.Page = Notebook.Page(function(data: {Image: string, Activated: () -> ()}, native)
    local paddedImageButton: ImageButton = Notebook.ImageButton() {
        Padding = myPadding,
        Label = Image(data.Image, {Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1}) {}
    } :: ImageButton
    paddedImageButton.Activated:Connect(data.Activated)
    return paddedImageButton
end)

local myImage = PaddedImageButton({
    Image = "rbxassetid://13492316854",
    Activated = function()
        print("hello, world!")
    end
}, {
    Size = UDim2.new(0,200,0,200), 
    Position = UDim2.new(0.5,0,0.5,0),
    BackgroundColor3 = Color3.fromRGB(25,25,25)
}) {
    Corner = myCorner()
}

local screengui = Notebook.ScreenGui() {
    FloatingFrame(nil,{Size = UDim2.new(0,100,0,100), Position = UDim2.new(0.1,0,0.5,0)}) {},
    DisplayImage = myImage
}
screengui.Parent = game.Players.LocalPlayer.PlayerGui