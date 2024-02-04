local component = {}
component.dependency = {"theme"}
component.namespace = "shieldEngine"
component.title = "Shield engine"
component.chipMovement = 0
component.owner = NULL
component.entity = NULL

if CLIENT then
    function component:HUDPaint()
        local ent = LocalPlayer():GetEyeTrace().Entity
        local looksAtEntity = false
        if self:CoveredUnderPP(ent) then
            self.owner = ent:GetNWEntity("shield_owner")
            self.entity = ent
            looksAtEntity = true
        end

        self.chipMovement = galactic.theme:PredictNextMove(self.chipMovement, looksAtEntity and 1 or 0, 20)
        local font = "GalacticDefault"
        local paddingW = galactic.theme.rem / 2
        local paddingH = galactic.theme.rem / 4
        local ownerName = self.owner:Nick()
        surface.SetFont(font)
        local fontW, fontH = surface.GetTextSize(ownerName)
        local sizeX = fontW + paddingW * 2
        local sizeY = paddingH * 2 + fontH
        draw.RoundedBox(
            galactic.theme.round,
            (ScrW() - sizeX) / 2,
            ScrH() - sizeY - paddingH + (sizeY + paddingH) * (1 - component.chipMovement),
            sizeX,
            sizeY,
            component:AllowedToPickup(LocalPlayer(), self.entity) != false and galactic.theme.colors.green or galactic.theme.colors.red)
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

    local PLAYER = FindMetaTable("Player")
    if PLAYER.AddCount then
        galactic.PLAYERAddCount = galactic.PLAYERAddCount or PLAYER.AddCount
        function PLAYER:AddCount(Type, ent) -- self: Player
            if IsValid(self) and IsValid(ent) then
                component:OnEntitySpawn(self, ent)
            end
            return galactic.PLAYERAddCount(self, Type, ent)
        end
    end

    function component:PlayerSpawnedEffect(ply, _, ent)
        component:OnEntitySpawn(ply, ent)
    end
    
    function component:PlayerSpawnedNPC(ply, ent)
        component:OnEntitySpawn(ply, ent)
    end
    
    function component:PlayerSpawnedProp(ply, _, ent)
        component:OnEntitySpawn(ply, ent)
    end
    
    function component:PlayerSpawnedRagdoll(ply, _, ent)
        component:OnEntitySpawn(ply, ent)
    end
    
    function component:PlayerSpawnedSENT(ply, ent)
        print(ent)
        component:OnEntitySpawn(ply, ent)
    end
    
    function component:PlayerSpawnedSWEP(ply, ent)
        component:OnEntitySpawn(ply, ent)
    end
    
    function component:PlayerSpawnedVehicle(ply, ent)
        component:OnEntitySpawn(ply, ent)
    end
    
    function component:PlayerSpawnedVehicle(ply, ent)
        component:OnEntitySpawn(ply, ent)
    end

    function component:OnEntitySpawn(ply, ent)
        ent:SetNWEntity("shield_owner", ply)
    end
end

function component:PhysgunPickup(ply, ent)
    if self:CoveredUnderPP(ent) then
        return self:AllowedToPickup(ply, ent)
    end
end

function component:CanTool(ply, tbl)
    local ent = tbl.Entity
    if not IsValid(ent) then return end
    if self:CoveredUnderPP(ent) then
        return self:AllowedToTool(ply, ent)
    end
end

function component:CoveredUnderPP(ent)
    return not ent:IsWorld() and not ent:IsPlayer() and ent:GetNWEntity("shield_owner")
end

function component:AllowedToPickup(ply, ent)
    if not ent:GetNWEntity("shield_owner"):IsPlayer() then return end
    -- if ply:IsSuperAdmin() then return end
    if ply:SteamID64() != ent:GetNWEntity("shield_owner"):SteamID64() then return false end
end

function component:AllowedToTool(ply, ent)
    if not ent:GetNWEntity("shield_owner"):IsPlayer() then return end
    -- if ply:IsSuperAdmin() then return end
    if ply:SteamID64() != ent:GetNWEntity("shield_owner"):SteamID64() then return false end
end

galactic:Register(component)
