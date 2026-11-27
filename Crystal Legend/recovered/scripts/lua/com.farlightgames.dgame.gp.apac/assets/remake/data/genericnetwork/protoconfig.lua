module("genericNetwork", package.seeall)
NetMode = {
  sdklogin = 1,
  systemdev = 2,
  accsystem = 3
}
csprotoConfig = {
  [NetMode.sdklogin] = {
    pbUp = "account_up",
    pbDown = "account_down",
    encryption = false,
    packHeadByteNum = 2,
    serverIp = "mlogin.dota.lilith.sh",
    serverPort = "10018",
    upMsgName = "account_up_msg",
    downMsgName = "account_down_msg"
  },
  [NetMode.systemdev] = {
    pbUp = "up",
    pbDown = "down",
    encryption = true,
    packHeadByteNum = 4,
    upMsgName = "up_msg",
    downMsgName = "down_msg"
  },
  [NetMode.accsystem] = {
    pbUp = "acc_up",
    pbDown = "acc_down",
    encryption = false,
    packHeadByteNum = 2,
    upMsgName = "acc_up_msg",
    downMsgName = "acc_down_msg"
  }
}
