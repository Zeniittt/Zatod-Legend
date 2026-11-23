local chatAddFriend = {}
chatAddFriend.__index = chatAddFriend
ed.chatAddFriend = chatAddFriend
ed.chatAddFriend.addFriendList = {}
local itemData, height, accData, extraData

function chatAddFriend:initData(itemdata, height1)
  itemData = itemdata
  height = height1
  extraData = itemData.extraData
  return self:creatUiToView()
end

function chatAddFriend:creatUiToView()
  local ui = {}
  local sp = CCSprite:create()
  ed.editorui(ed.uieditor.FriendApplyMessage, {container = sp, ui = ui})
  local info = {
    node = ui.btn_yes,
    pressNode = ui.btn_yes_press,
    data = {
      roleId = extraData.roleId
    }
  }
  table.insert(ed.chatAddFriend.addFriendList, info)
  return sp, ui
end

function chatAddFriend:isHide(pnode)
  local node = pnode
  if not node or tolua.isnull(pnode) then
    return false
  end
  if node:isVisible() == false then
    return true
  end
  while node:getParent() do
    if node:getParent():isVisible() == false then
      return true
    end
    node = node:getParent()
  end
  return false
end

local isPress, index, pressNode

function chatAddFriend:touch(event, x, y)
  if event == "began" then
    for i = 1, #ed.chatAddFriend.addFriendList do
      local ic = ed.chatAddFriend.addFriendList[i]
      if ed.containsPoint(ic.node, x, y) and not self:isHide(ic.node) then
        isPress = true
        pressNode = ic.pressNode
        pressNode:setVisible(true)
        index = i
        break
      end
    end
    px = x
    py = y
  elseif event == "moved" then
    local dis = ccpDistanceSQ(ccp(x, y), ccp(px or 0, py or 0))
    if 10 < dis then
      isPress = false
      if pressNode then
        pressNode:setVisible(false)
        pressNode = nil
      end
      index = nil
    end
  elseif event == "ended" then
    if not index then
      return
    end
    local ic = ed.chatAddFriend.addFriendList[index]
    if isPress and ed.containsPoint(ic.node, x, y) and not self:isHide(ic.node) and y < 350 then
      self:addFriendHandler(ic.data)
    end
    if pressNode then
      pressNode:setVisible(false)
      pressNode = nil
    end
    isPress = false
    index = nil
    px = nil
    py = nil
  end
end

function chatAddFriend:addFriendHandler(info)
  if ed.friendlist.isInFriendlist(info.uid, info.sid) then
    ed.showToast(T("\229\175\185\230\150\185\229\183\178\230\136\144\228\184\186\228\189\160\231\154\132\229\165\189\229\143\139"))
    return
  end
  if ed.blacklist.isInBlacklist(info.uid, info.sid) then
    ed.showToast(T("\230\173\164\231\142\169\229\174\182\229\156\168\228\189\160\231\154\132\233\187\145\229\144\141\229\141\149\228\184\173,\230\151\160\230\179\149\230\136\144\228\184\186\229\165\189\229\143\139"))
    return
  end
  ed.chatNetDataMrg:sendAddFriend(info.uid, info.sid)
end
