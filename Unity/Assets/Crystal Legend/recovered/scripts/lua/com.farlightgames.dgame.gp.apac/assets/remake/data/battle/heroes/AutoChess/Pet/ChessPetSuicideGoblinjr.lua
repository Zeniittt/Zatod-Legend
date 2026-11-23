module("ed.battlehero", package.seeall)
local ed = ed
ChessPetSuicideGoblinjr = {}
ChessPetSuicideGoblinjr.PetSuicideGoblinjr_startBuffID = 1349

function ChessPetSuicideGoblinjr.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petsuicidegoblinjr_buffadded then
    local bid = ChessPetSuicideGoblinjr.PetSuicideGoblinjr_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petsuicidegoblinjr_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.3 and not pet.petsuicidegoblinjr_skillpasv_casted then
    local skillpasv = pet.skills.PetSuicideGoblinjr_pasv
    if skillpasv then
      skillpasv:takeEffectAt(master.position, master)
      if ed.run_with_scene then
        local effect_name = "eff_point_EM_ult.cha"
        if effect_name then
          ed.scene:playEffectOnScene(effect_name, master.position, {
            master.direction * 0.75,
            0.75
          }, nil, 1)
        end
      end
      pet.petsuicidegoblinjr_skillpasv_casted = true
    end
  end
end

function ChessPetSuicideGoblinjr.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petsuicidegoblinjr_buffadded = nil
  pet.petsuicidegoblinjr_skillpasv_casted = nil
end

function ChessPetSuicideGoblinjr.init_hero(hero)
  hero.update = override(hero.update, ChessPetSuicideGoblinjr.hero_update)
  hero.reset = override(hero.reset, ChessPetSuicideGoblinjr.hero_reset)
  return hero
end

return ChessPetSuicideGoblinjr.init_hero
