local function ExitGame()
  EDFcaActor:releaseFcaInfo()
  
  if EDFcaSpActor then
    EDFcaSpActor:releaseFcaInfo()
  end
  LoadResources:releaseMemory()
end

ListenEvent("ExitGame", ExitGame)
