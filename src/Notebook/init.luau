local lib = {}

local function getProperty(instance: Instance, propertyName: string): any?
	local success, result = pcall(function()
		local instance: any = instance
		return instance[propertyName]
	end)
	return (success and result) or nil
end

local function applyNative(instance: any, native: {[string]: any}?)
	if native then
		for key, value in pairs(native) do
			if getProperty(instance, key) then
				instance[key] = value
			end
		end
	end
end

local initializedChildren: {Instance} = {}
local function initializeChild(child,parent,name)
	table.insert(initializedChildren, child)
	child.Name = typeof(name) == "string" and name or child.Name
	child.Parent = parent
	child.Destroying:Connect(function()
		initializedChildren[table.find(initializedChildren, child) :: number] = nil
	end)
end
local function setChildren(parent: Instance)
	return function(children: { [any]: Instance | () -> (...any) })
		for name, child in pairs(children) do
			if child then
				if typeof(child) == "Instance" and not table.find(initializedChildren, child) then
					initializeChild(child, parent, name)
				end
				if typeof(child) == "function" then
					local result = child()
					if typeof(result) == "Instance" and not table.find(initializedChildren, result) then
						initializeChild(result,parent,name)
					end
				end
			end
		end
		return parent
	end
end

-- Roblox GUI Instance Types
local guiTypes: {string} = {
    "ScreenGui",
    "BillboardGui",
    "SurfaceGui",
    "Frame",
    "TextLabel",
    "TextButton",
    "TextBox",
    "ImageLabel",
    "ImageButton",
    "ScrollingFrame",
    "ViewportFrame",
    "CanvasGroup",
    "UIListLayout",
    "UIGridLayout",
    "UIPageLayout",
    "UITableLayout",
    "UIScale",
    "UIAspectRatioConstraint",
    "UICorner",
    "UIPadding",
    "UISizeConstraint",
    "UIStroke",
	"UIGradient"
}
type Native = { [string]: any }

type obj = (({[string]: Instance }) -> Instance)
export type Page = (data: any, native: Native?) -> (obj)
function lib.Page(callback: (any, Native?) -> Instance): Page
	return function(data: any, native: Native?)
		local inst: Instance = callback(data, native)
		applyNative(inst, native)
		return setChildren(inst)
	end
end


lib.Image = function(Image: string, native: Native?)
	local image: ImageLabel = Instance.new("ImageLabel")
	image.Image = Image

	applyNative(image, native)
	return setChildren(image)
end

lib.Corner = function(radius: number, native: Native?)
	local corner: UICorner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)

	applyNative(corner, native)
	return setChildren(corner)
end

for _, name in ipairs(guiTypes) do
	lib[name] = function(native: Native?)
		local instance = Instance.new(name) or Instance.new("Frame")
		
		applyNative(instance, native)
		return setChildren(instance)
	end
end


return lib