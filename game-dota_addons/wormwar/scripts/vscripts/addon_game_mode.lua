-- Generated from template
require('playerinit')

flag_init_player_stats=0


if CWormWar == nil then
	CWormWar = class({})
end

function PrecacheEveryThingFromKV( context )
    local kv_files = {"scripts/npc/npc_units_custom.txt","scripts/npc/npc_abilities_custom.txt","scripts/npc/npc_heroes_custom.txt","scripts/npc/npc_abilities_override.txt","npc_items_custom.txt"}
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
            PrecacheEverythingFromTable( context, kvs)
        end
    end
end

function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            PrecacheEverythingFromTable( context, value )
        else
            if string.find(value, "vpcf") then
                PrecacheResource( "particle",  value, context)
                print("PRECACHE PARTICLE RESOURCE", value)
            end
            if string.find(value, "vmdl") then  
                PrecacheResource( "model",  value, context)
                print("PRECACHE MODEL RESOURCE", value)
            end
            if string.find(value, "vsndevts") then
                PrecacheResource( "soundfile",  value, context)
                print("PRECACHE SOUND RESOURCE", value)
            end
        end
    end    
end

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
	print("BEGIN TO PRECACHE RESOURCE")
	local time = GameRules:GetGameTime()
	PrecacheEveryThingFromKV(context)
	PrecacheResource( "particle_folder", "particles/folder", context )
	time = time - GameRules:GetGameTime()
	print("DONE PRECACHEING IN:"..tostring(time).."Seconds")
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CWormWar()
	GameRules.AddonTemplate:InitGameMode()
end

function CWormWar:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	ListenToGameEvent("entity_killed", Dynamic_Wrap(CWormWar, "OnEntityKilled"), self)
end

-- Evaluate the state of the game
function CWormWar:OnThink()
	if flag_init_player_stats==0 then
		init_player_stats()
		flag_init_player_stats=1
	end



	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CWormWar:OnEntityKilled(keys)--单位死亡响应
	--获得击杀信息
	local attacker = EntIndexToHScript(keys.entindex_attacker)
	local killed = EntIndexToHScript(keys.entindex_killed)
	local label = killed:GetContext("name")
	if label then
		if label == "sheep" then
			createunit("sheep")
		end
		if label == "cow" then
			createunit("cow")
		end
		if label == "fireman" then
			createunit("fireman")
		end
	end

end

