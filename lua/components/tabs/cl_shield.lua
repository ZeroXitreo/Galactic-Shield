local component = {}
component.dependencies = {"theme", "menu"}
component.title = "Shield"
component.description = "Enables you to edit your prop protection"
component.icon = "brick"
component.width = 280 * 2

function component:InitializeTab(parent)
end

galactic:Register(component)
