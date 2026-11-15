lua
local Mod = {}

-- Configuração dos encontros clássicos do Mareep (Gold/Silver)
local MAREEP_SLOT_MORNING = { species = "MAREEP", level = 6 }
local MAREEP_SLOT_DAY     = { species = "MAREEP", level = 6 }

local function patchRoute32Encounters(data)
    if not data then return false end

    -- Localiza a tabela de encontros de grama de Johto
    local grassTable = data.johto_grass or data.wild_grass or (data.encounters and data.encounters.johto_grass)
    if not grassTable then return false end

    local route32 = grassTable["ROUTE_32"] or grassTable["Route32"]
    if not route32 then return false end

    -- Substitui o 4º slot (índice 4 em Lua) da manhã e do dia pelo Mareep,
    -- preservando as taxas de encontro (10% de chance, igual ao Gold/Silver original)
    if route32.morning and route32.morning[4] then
        route32.morning[4] = { species = MAREEP_SLOT_MORNING.species, level = MAREEP_SLOT_MORNING.level }
    end

    if route32.day and route32.day[4] then
        route32.day[4] = { species = MAREEP_SLOT_DAY.species, level = MAREEP_SLOT_DAY.level }
    end

    return true
end

function Mod.onLoad(ctx)
    -- Aplica apenas se a ROM carregada for Pokémon Crystal
    local gameId = (ctx and ctx.game and ctx.game.id) or ""
    if gameId ~= "" and not tostring(gameId):lower():find("crystal") then
        return
    end

    -- Gancho de registro de dados da API de Mods do Gen2Recomped
    if ctx and ctx.events and ctx.events.on then
        ctx.events.on("gamedata:loaded", function(gamedata)
            local ok = patchRoute32Encounters(gamedata)
            if ok and ctx.log then
                ctx.log.info("[crystal_route32_mareep] Mareep adicionado com sucesso à Rota 32!")
            end
        end)
    end
end

return Mod
