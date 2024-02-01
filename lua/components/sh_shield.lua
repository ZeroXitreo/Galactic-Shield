local component = {}
component.dependency = {"theme"}
component.namespace = "shield"
component.title = "Shield"
component.chipMovement = 0
component.owner = NULL
component.entity = NULL

function component:Constructor()
    print("ahh")
end

if CLIENT then
    function component:HUDPaint()
        ent = LocalPlayer():GetEyeTrace().Entity
        looksAtEntity = false
        if ent and not ent:IsWorld() and ent:GetNWEntity("shield_owner") then
            self.owner = ent:GetNWEntity("shield_owner")
            self.entity = ent
            looksAtEntity = true
        end

        self.chipMovement = galactic.theme:PredictNextMove(self.chipMovement, looksAtEntity and 1 or 0, 20)
        font = "GalacticDefault"
        paddingW = galactic.theme.rem / 2
        paddingH = galactic.theme.rem / 4
        ownerName = self.owner:Nick()
        surface.SetFont(font)
        fontW, fontH = surface.GetTextSize(ownerName)
        sizeX = fontW + paddingW * 2
        sizeY = paddingH * 2 + fontH
        draw.RoundedBox(
            galactic.theme.round,
            (ScrW() - sizeX) / 2,
            ScrH() - sizeY - paddingH + (sizeY + paddingH) * (1 - component.chipMovement),
            sizeX,
            sizeY,
            component:AllowedToPickup(self.owner, self.entity) and galactic.theme.colors.green or galactic.theme.colors.red)
        draw.DrawText(
            ownerName,
            font,
            ScrW() / 2,
            ScrH() - sizeY + (sizeY + paddingH) * (1 - component.chipMovement),
            galactic.theme.colors.text,
            TEXT_ALIGN_CENTER)
    end
end

if SERVER then
    function component:PlayerSpawnedEffect(ply, model, ent)
        component:wap(ply, ent)
    end
    
    function component:PlayerSpawnedNPC(ply, ent)
        component:wap(ply, ent)
    end
    
    function component:PlayerSpawnedProp(ply, model, ent)
        component:wap(ply, ent)
    end
    
    function component:PlayerSpawnedRagdoll(ply, model, ent)
        component:wap(ply, ent)
    end
    
    function component:PlayerSpawnedSENT(ply, ent)
        component:wap(ply, ent)
    end
    
    function component:PlayerSpawnedSWEP(ply, ent)
        component:wap(ply, ent)
    end
    
    function component:PlayerSpawnedVehicle(ply, ent)
        component:wap(ply, ent)
    end

    function component:wap(ply, ent)
        ent.ahh = "yee"
        ent:SetNWEntity("shield_owner", ply)
    end
end

function component:PhysgunPickup(ply, ent)
    return self:AllowedToPickup(ply, ent)
end

function component:AllowedToPickup(ply, ent)
    -- if ply:IsSuperAdmin() then return end
    if ply != ent:GetNWEntity("shield_owner") then return false end
    return true
end

galactic:Register(component)
