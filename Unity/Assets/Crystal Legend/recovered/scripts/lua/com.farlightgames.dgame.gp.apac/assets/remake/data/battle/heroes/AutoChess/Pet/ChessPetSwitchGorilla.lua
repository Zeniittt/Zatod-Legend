module("ed.battlehero", package.seeall)
local ed = ed
ChessPetSwitchGorilla = {}
ChessPetSwitchGorilla.PetSwitchGorilla_startBuffID = 1349

function ChessPetSwitchGorilla.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petSwitchGorilla_buffadded then
    local bid = ChessPetSwitchGorilla.PetSwitchGorilla_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petPetSwitchGorilla_buffadded = true
  end
  local master = pet.owner
  if not pet.petSwitchGorilla_firsttick then
    pet.petSwitchGorilla_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petSwitchGorilla_firsttick > 8 and not pet.petSwitchGorilla_skillpasv_casted then
    local skillpasv = pet.skills.PetSwitchGorilla_pasv
    if skillpasv then
      skillpasv.target = pet.owner
      local region = skillpasv:createRegion()
      region.update = override(region.update, ChessPetSwitchGorilla.skillpasvRegion_update)
      region.master = pet.owner
      ed.engine:addRegion(region)
    end
    pet.petSwitchGorilla_skillpasv_casted = true
  end
end

function ChessPetSwitchGorilla.skillpasvRegion_update(basefunc, region, dt)
  basefunc(region, dt)
  if not region.terminated and region.timer >= 0 then
    region.position = {
      region.master.position[1],
      region.master.position[2]
    }
    if not region.master:isAlive() then
      region:terminate()
    end
  end
end

function ChessPetSwitchGorilla.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petSwitchGorilla_buffadded = nil
  pet.petSwitchGorilla_skillpasv_casted = nil
  pet.petSwitchGorilla_firsttick = nil
  pet.petSwitchGorilla_skillatk1_countdown = nil
  pet.petSwitchGorilla_skillatk1_started = nil
  pet.petSwitchGorilla_skillatk1_casted = nil
  pet.petSwitchGorilla_skillatk1_invisible = nil
end

function ChessPetSwitchGorilla.init_hero(hero)
  hero.update = override(hero.update, ChessPetSwitchGorilla.hero_update)
  hero.reset = override(hero.reset, ChessPetSwitchGorilla.hero_reset)
  return hero
end

return ChessPetSwitchGorilla.init_hero
