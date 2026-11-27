local ed = ed
local class = ed.Unit

function class.preloadCha(name)
  if not name then
    return
  end
  if string.match(name, "%.cha$") or string.match(name, "%.sp$") then
    name = string.gsub(name, "%.cha$", "")
    if ed.isOpenAsyncLoad() and EDEngineVersion() >= 4 then
      ed.asyncload.preloadFcaByName(name)
    end
  end
end

local function preloadEffect(self, name)
  if not ed.run_with_scene then
    return
  end
  class.preloadCha(name)
end

class.preloadEffect = preloadEffect

local function preloadAction(self, action_name)
end

class.preloadAction = preloadAction

local function preloadSkill(skill)
  local info = skill.info
  class.preloadCha(info["Launch Effect"])
  class.preloadCha(info["Point Effect"])
  class.preloadCha(info["Impact Effect"])
  class.preloadCha(info["Chain Effect"])
  local art = info["Tile Art"]
  if art and string.match(art, "%.png$") then
    if ed.isOpenAsyncLoad() and EDEngineVersion() >= 4 then
      ed.asyncload.preloadImageByName(art)
    else
      ed.getSpriteFrame(art)
    end
  elseif art then
    class.preloadCha(art)
  end
end

local function preload(self)
  if not ed.run_with_scene then
    return
  end
  local puppetRcsName = self.info.Puppet
  if puppetRcsName then
    puppetRcsName = ed.lookupDataTable("Puppet", "Resource", puppetRcsName)
    if ed.isOpenAsyncLoad() and puppetRcsName then
      class.preloadCha(puppetRcsName)
    end
  end
  for _, skill in ipairs(self.skill_list) do
    preloadSkill(skill)
  end
end

class.preload = preload

local function PreloadPuppetRcs(puppetRcsName)
  if ed.run_with_scene then
    local puppet = ed.createFcaActor(puppetRcsName, 1)
    if puppet then
      puppet:removeFromParentAndCleanup(true)
    end
  end
end

ed.PreloadPuppetRcs = PreloadPuppetRcs

local function PreloadPuppetRcsByUnitId(id)
  if ed.run_with_scene then
    local puppetRcsName = ed.lookupDataTable("Unit", "Puppet", id)
    if puppetRcsName then
      puppetRcsName = ed.lookupDataTable("Puppet", "Resource", puppetRcsName)
      local puppet = ed.createFcaActor(puppetRcsName, 1)
      if puppet then
        puppet:removeFromParentAndCleanup(true)
      end
    end
  end
end

ed.PreloadPuppetRcsByUnitId = PreloadPuppetRcsByUnitId

local function PreloadChessPuppetRcsByUnitId(id)
  if ed.run_with_scene then
  end
end

ed.PreloadChessPuppetRcsByUnitId = PreloadChessPuppetRcsByUnitId
