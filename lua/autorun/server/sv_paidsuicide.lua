CreateConVar( "suicide_min_value", 500, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "suicide_max_value", 1000, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "suicide_random", 1, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "suicide_sound", 1, FCVAR_SERVER_CAN_EXECUTE )
CreateConVar( "suicide_value", 500, FCVAR_SERVER_CAN_EXECUTE )

local suicidemin = GetConVar( "suicide_min_value" )
local suicidemax = GetConVar( "suicide_max_value" )
local suicidevalue = GetConVar( "suicide_value" )

hook.Add("PlayerDeath", "CatPaidSuicide", function(ply, inflictor, attacker )
    if ( ply == attacker ) then
        if gmod.GetGamemode().Name != "DarkRP" then return end
        for k, aply in pairs(player.GetAll()) do
            if aply == ply then continue end
            aply:ChatPrint(ply:Nick() .. " said farewell cruel world!")
        end
        local suicidecost = GetConVar( "suicide_random" ):GetBool() and math.Round(math.Rand(suicidemin:GetInt(), suicidemax:GetInt())) or math.Round(suicidevalue:GetInt())
        local soundFile = "vo/npc/male01/whoops01.wav"
        if GetConVar( "suicide_sound" ):GetBool() then
            ply:EmitSound(soundFile)
        end
        ply:addMoney(-suicidecost)
        ply:ChatPrint("You just lost "..DarkRP.formatMoney(suicidecost).."!")
    end
end)

hook.Add("CanPlayerSuicide", "CatStopSuicide", function(ply)
    if !ply:Alive() then return false end

    if ply:isArrested() then
        DarkRP.notify(ply, 1, 5, "You can't suicide while arrested!") 
        return false 
    end    
    
    local suicidecost = GetConVar( "suicide_random" ):GetBool() and math.Round(math.Rand(suicidemin:GetInt(), suicidemax:GetInt())) or math.Round(suicidevalue:GetInt())
    if ply:canAfford(suicidecost) == false then 
        DarkRP.notify(ply, 1, 5, "Can't afford to suicide!") 
        return false 
    end
end)