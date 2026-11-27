module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff22 = {}

function FancyAbyssbuff22.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.onDamaged = override(buff.onDamaged, FancyAbyssbuff22.Buff_onDamaged)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff22.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local owner = buff.owner
  if source then
    local skillHuskar = source.skills.Huskar_atk2
    local skillMed = source.skills.Med_atk2
    local skillTroll = source.skills.Troll_atk3
    local skillLYC = source.skills.LYC_atk2b
    local skillPA = source.skills.PA_atk
    local skillViper = source.skills.Viper_atk2
    local skillNS = source.skills.NS_atkb
    local skillDK = source.skills.DK_atkb
    local shard = source.proto._shard
    if shard and shard._id == 1000371 and source.shardSkillRank and source.shardSkillRank >= 3 then
      source.vipershard3 = true
    end
    if skill and (skill.info.Slot == 5 or skill == skillHuskar or skill == skillMed or skill == skillTroll or skill == skillLYC or skill == skillPA or skill == skillViper and source.vipershard3 or skill == skillDK or skill == skillNS) then
      dmg = dmg * 1.3
      if source.fancy22ratio and source.fancy22time then
        dmg = dmg * source.fancy22ratio
        if source.name == "BH" then
          dmg = dmg * 1.5
        end
        source.fancy22time = 0
        source.fancy22ratio = 1
        for i, tbuff in ipairs(source.buff_list) do
          if tbuff.info.ID == 6224 then
            tbuff.timer = -1
            source.fancy22effect = false
          end
        end
      end
    end
  end
  return dmg
end

function FancyAbyssbuff22.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff22.createBuff)
  return skill
end

return FancyAbyssbuff22.init_fieldSkill
