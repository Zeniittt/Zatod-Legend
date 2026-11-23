module("ed.battleprepare", package.seeall)
EnemyHeros = {}
EnemyHeros.__index = EnemyHeros

function EnemyHeros:create(uiview)
  local self = {}
  setmetatable(self, EnemyHeros)
  self:initData(uiview)
  self:initAppearence()
  return self
end

function EnemyHeros:initData(uiview)
  local controll = uiview:getController()
  local modle = controll:getModel()
  local enemyHeros = modle:getEnemyHeroList()
  self.enemyHeroSummarys = enemyHeros
end

function EnemyHeros:initAppearence()
  self.container = CCLayer:create()
  self.container:setVisible(false)
  self.ui = {}
  local uiInfo = self:getUiInfo()
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(uiInfo)
  local dx, dy = 4.3, 3.8
  local length = 52
  for j, hero in ipairs(self.enemyHeroSummarys) do
    local hero_icon = ed.readhero.createIcon({
      id = hero._tid,
      rank = hero._rank,
      level = hero._level,
      stars = hero._stars,
      length = length
    })
    if not hero_icon then
      break
    end
    local icon_node = hero_icon.icon
    icon_node:setAnchorPoint(ccp(0, 0))
    local x, y = icon_node:getPosition()
    icon_node:setPosition(ccp(x + dx, y + dy))
    self.ui["enemybg" .. j]:addChild(icon_node)
  end
end

function EnemyHeros:getView()
  return self.container
end

function EnemyHeros:setVisible(param)
  self.container:setVisible(param)
end

function EnemyHeros:getUiInfo()
  local uiInfo = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/realtime_pvp/pvp_manual_heroselect_head.png",
        z = 5
      },
      layout = {
        position = ccp(365, 412)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemybg1",
        res = "UI/alpha/HVGA/realtime_pvp/pvp_manual_heroselect_head_bg.png",
        z = 6
      },
      layout = {
        position = ccp(262, 420)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemybg2",
        res = "UI/alpha/HVGA/realtime_pvp/pvp_manual_heroselect_head_bg.png",
        z = 6
      },
      layout = {
        position = ccp(324, 420)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemybg3",
        res = "UI/alpha/HVGA/realtime_pvp/pvp_manual_heroselect_head_bg.png",
        z = 6
      },
      layout = {
        position = ccp(386, 420)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemybg4",
        res = "UI/alpha/HVGA/realtime_pvp/pvp_manual_heroselect_head_bg.png",
        z = 6
      },
      layout = {
        position = ccp(448, 420)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "enemybg5",
        res = "UI/alpha/HVGA/realtime_pvp/pvp_manual_heroselect_head_bg.png",
        z = 6
      },
      layout = {
        position = ccp(510, 420)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemyLabel1",
        text = T("\229\175\185\230\150\185"),
        size = 18,
        z = 10
      },
      layout = {
        position = ccp(165, 431)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "enemyLabel2",
        text = T("\233\152\181\229\174\185"),
        size = 18,
        z = 10
      },
      layout = {
        position = ccp(165, 411)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    }
  }
  return uiInfo
end
