local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.mailoverfull = class
local icon_res = {
  Energy = "UI/alpha/HVGA/GuildHero/guildhero_energy.png",
  Diamond = "UI/alpha/1080P/common/shop_token_icon.png",
  Gold = "UI/alpha/1080P/common/goldicon_small.png",
  Exp = "UI/alpha/HVGA/task_exp_icon_2.png",
  CrusadeMoney = "UI/alpha/HVGA/money_dragonscale_big.png",
  PvpMoney = "UI/alpha/HVGA/money_arenatoken_big.png",
  TopPvpMoney = "UI/alpha/HVGA/money_top_pvp_big.png",
  GuildMoney = "UI/alpha/HVGA/money_guildtoken_big.png",
  GvgMoney = "UI/alpha/HVGA/money_gvg_big.png",
  SkillPoint = "UI/alpha/HVGA/herodetail_skill_upgrade_button_1.png",
  VipExp = "UI/alpha/HVGA/task_vip_exp_icon.png",
  DreamlandMoney = "UI/alpha/HVGA/money_dreampoint_big.png",
  GCWMoney = "UI/alpha/HVGA/money_gcw_big.png",
  Wood = "UI/alpha/HVGA/warschool/resource_wood.png",
  Iron = "UI/alpha/HVGA/warschool/resource_iron.png",
  Crystal = "UI/alpha/HVGA/warschool/resource_crystal.png",
  Medal = "UI/alpha/1080P/common/handbook_icon_lock.png",
  GuildEnergy = "UI/alpha/HVGA/guild/guild_loot_coin.png",
  starPoint = "UI/alpha/HVGA/stargate/money_stargate.png"
}

local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.left_button,
    press = ui.left_button_press,
    key = "left_button",
    clickHandler = function()
      if self.param.leftCallback then
        self.param.leftCallback()
      end
      self:destroy({skipAnim = true})
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.right_button,
    press = ui.right_button_press,
    key = "right_button",
    clickHandler = function()
      self:destroy({skipAnim = true})
    end
  })
end

class.registerTouchHandler = registerTouchHandler

local function createContent(self)
  local info = {
    cliprect = ed.DGRectMake(65, 130, 455, 230),
    noshade = true,
    container = self.ui.frame,
    priority = self.mainTouchPriority - 5,
    zorder = 10
  }
  self.draglist = ed.draglist.create(info)
  local ui = {
    {
      {
        t = "Label",
        base = {
          name = "r_1_1",
          text = T("\233\131\168\229\136\134\233\129\147\229\133\183\229\176\134\232\182\133\229\135\186\229\143\175\230\144\186\229\184\166\228\184\138\233\153\144\227\128\130\229\166\130\230\158\156\229\188\186\232\161\140\233\162\134\229\143\150\239\188\140\229\176\134\230\141\159\229\164\177\232\182\133\229\135\186\231\154\132\233\129\147\229\133\183\227\128\130"),
          size = 18
        },
        config = {
          color = ccc3(243, 194, 113),
          dimension = ed.DGSizeMake(400, 0),
          horizontalAlignment = kCCTextAlignmentLeft
        }
      }
    },
    {
      {
        t = "Label",
        base = {
          name = "r_2_1",
          text = T("\232\182\133\229\135\186\239\188\154"),
          size = 18
        },
        config = {
          color = ccc3(243, 194, 113)
        }
      }
    }
  }
  local items = self.param.items or {}
  for i = 1, #items / 4 + 1 do
    local ui_info = {}
    for j = 1, 4 do
      local item = items[4 * (i - 1) + j]
      if item then
        local id = item.id
        local amount = item.amount
        table.insert(ui_info, {
          t = "CCNode",
          base = {
            name = T("item_%d_%d", i, j),
            node = ed.readequip.createIconWithAmount(id, 60, amount, 1, {
              fres = icon_res[item.type]
            })
          }
        })
      end
    end
    table.insert(ui, ui_info)
  end
  table.insert(ui, {
    {
      t = "Label",
      base = {
        name = "r_3_1",
        text = T("\230\152\175\229\144\166\231\187\167\231\187\173\233\162\134\229\143\150\239\188\159"),
        size = 18
      },
      config = {
        color = ccc3(243, 194, 113)
      }
    }
  })
  local param = {
    t = "ChaosNode",
    base = {name = "node", offset = 3},
    config = {},
    ui = ui
  }
  local node = ed.readnode.getFeralNode(param)
  node:setAnchorPoint(ccp(0.5, 1))
  node:setPosition(ed.DGccp(296, 355))
  self.draglist:addItem(node)
  self.draglist:initListHeight(node:getContentSize().height)
end

class.createContent = createContent

local function create(param)
  local self = base.create("mailoverfull")
  setmetatable(self, class.mt)
  self.param = param or {}
  local mainLayer = self.mainLayer
  local container = self.container
  local container
  container, self.ui = ed.editorui(ed.uieditor.mailoverfull)
  self:setContainer(container)
  self:createContent()
  self:registerTouchHandler()
  return self
end

class.create = create

local function pop(param)
  local window = create(param)
  window:popWindow(99999)
end

class.pop = pop
