local component = {}
component.dependencies = {"theme", "menu"}
component.title = "Shield"
component.description = "Enables you to edit your prop protection"
component.icon = "brick"

function component:InitializeTab(parent)
	self.width = 500

    local header = parent:Add("DPanel")
    header:Dock(TOP)
    header:SetHeight(100)

    local description = header:Add("DLabel")
    description:SetFont("GalacticDefault")
    description:SetColor(galactic.theme.colors.red)
    description:SetText("ahh")
    description:Dock(LEFT)
    description:SetHeight(100)
    function description:Paint(w, h)
        draw.RoundedBox(galactic.theme.round, 0, 0, w, h, galactic.theme.colors.blue)
        local w, h = 0, 0
        local t = RealTime()*500
        
        local mat = Matrix()
     
        local toLocalX, toLocalY = description:LocalToScreen(0, 0)
        mat:Translate(Vector(toLocalX, toLocalY))
        mat:Rotate(Angle(0,60,0))
        mat:Translate(-Vector(toLocalX, toLocalY))
     
        cam.PushModelMatrix(mat)
            draw.SimpleTextOutlined("Physgun", "GalacticDefault", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 255))
        cam.PopModelMatrix()
    end

    local description = header:Add("DLabel")
    description:SetFont("GalacticDefault")
    description:SetColor(galactic.theme.colors.red)
    description:SetText("ahh")
    description:Dock(LEFT)
    description:SetHeight(100)
    function description:Paint(w, h)
        draw.RoundedBox(galactic.theme.round, 0, 0, w, h, galactic.theme.colors.blue)
        local w, h = 0, 0
        local t = RealTime()*500
        
        local mat = Matrix()
     
        local toLocalX, toLocalY = description:LocalToScreen(0, 0)
        mat:Translate(Vector(toLocalX, toLocalY))
        mat:Rotate(Angle(0,60,0))
        mat:Translate(-Vector(toLocalX, toLocalY))
     
        cam.PushModelMatrix(mat)
            draw.SimpleTextOutlined("Tool", "GalacticDefault", w/2, h/2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, Color(0, 0, 0, 255))
        cam.PopModelMatrix()
    end

    local players = parent:Add("DScrollPanel")
    players:Dock(FILL)

    self:PopulatePlayers(players)
end

function component:PopulatePlayers(parent)
	for _, ply in ipairs(player.GetAll()) do
    -- for _, ply in ipairs(player.GetHumans()) do
    --     if ply == LocalPlayer() then continue end
		self:AddPlayer(parent, ply)
		self:AddPlayer(parent, ply)
		self:AddPlayer(parent, ply)
	end
end

function component:AddPlayer(parent, ply)
    local itemHeight = 20
    local item = parent:Add("Panel")
    item:Dock(TOP)
    item:DockMargin(0, 0, 0, galactic.theme.rem / 4)
    item:DockPadding(galactic.theme.rem / 2, galactic.theme.rem / 2, galactic.theme.rem / 2, galactic.theme.rem / 2)
    function item:Paint(w, h)
        draw.RoundedBox(galactic.theme.round, 0, 0, w, h, galactic.theme.colors.block)
    end
    item:SetHeight(itemHeight + galactic.theme.rem)

    local label = item:Add("DLabel")
    label:SetFont("GalacticDefault")
    label:SetText(ply:Nick())
    label:SetColor(galactic.theme.colors.text)
    label:Dock(FILL)
    
    local checks = item:Add("Panel")
    checks:SetHeight(itemHeight)
    checks:SetWidth(0)
    checks:Dock(RIGHT)

    self:AddCheckbox(checks, "Physgun")
    self:AddCheckbox(checks, "Toolgun")

    checks:InvalidateLayout(true)
    checks:SizeToChildren(false, true)
end

function component:AddCheckbox(parent, tooltip)
    local gap = galactic.theme.rem / 4
    local checkbox = parent:Add("DCheckBox")
    checkbox:SetTooltip(tooltip)

    local parentWidth, parentHeight = parent:GetSize()
    local width, height = checkbox:GetSize()
    checkbox:SetY((parentHeight - height) / 2)

    if parentWidth > 0 then
        parent:SetWidth(parentWidth + width + gap)
        checkbox:SetX(parentWidth + gap)
    else
        parent:SetWidth(parentWidth + width)
        checkbox:SetX(parentWidth)
    end

    checkbox:SetValue(false)
end

galactic:Register(component)
