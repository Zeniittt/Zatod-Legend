local BuffIDIndex = {}
BuffIDIndex[316] = 1
BuffIDIndex[317] = 2
BuffIDIndex[318] = 3
BuffIDIndex[319] = 4
BuffIDIndex[320] = 5
local RefAttribNames = {
  "AP",
  "AD",
  "ARM",
  "MR",
  "HP"
}
local AttribMultipliers = {
  0.08,
  0.09,
  0.14,
  0.14,
  0.1
}
local TargetAttribNames = {
  "AP",
  "AD",
  "ARM",
  "MR",
  "Shield Value"
}

local function setPercentAttribs(buff)
  local index = BuffIDIndex[buff.info.ID]
  local ownerAttribs = buff.owner.attribs
  local info = ed.wraptable(buff.info, {})
  buff.info = info
  local attribName = RefAttribNames[index]
  local refAttrib = ownerAttribs[attribName]
  local addAttrib = refAttrib * AttribMultipliers[index]
  local targetAttribName = TargetAttribNames[index]
  info[targetAttribName] = info[targetAttribName] + addAttrib
  if targetAttribName == "Shield Value" then
    buff.shield = addAttrib
  end
end

local function initBuff(buff)
  buff.setPercentAttribs = setPercentAttribs
  return buff
end

return initBuff
