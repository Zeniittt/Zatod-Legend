module("eddebug", package.seeall)
local firstSnapshot, secondSnapshot

function StartMemorySnapshot()
  firstSnapshot = EDMemorySnapShot()
end

function EndMemorySnapshot()
  secondSnapshot = EDMemorySnapShot()
  for k, v in pairs(secondSnapshot) do
    if firstSnapshot[k] == nil and k ~= "firstSnapshot" and k ~= "secondSnapshot" then
      print(tostring(v))
    end
  end
  firstSnapshot = nil
  secondSnapshot = nil
end
