ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueDestinyCard = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 237.5, h = 356},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/bless/destiny_card_front.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 200, h = 175},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/bless/bless_the_tower.png",
      name = "image_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(118.75, 228.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_name_pos",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(118.75, 96)
    }
  }
}
