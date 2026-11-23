ed.uieditor = ed.uieditor or {}
ed.uieditor.moonFestivalRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 135, h = 117.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_copper.png",
      name = "plate",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 40)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "plate",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(67.5, 116.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 102, h = 28.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "plate",
      res = "UI/alpha/1080P/bunnyrace/br_reward/br_reward_copper_bg.png",
      name = "feet_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 43.25)
    }
  }
}
