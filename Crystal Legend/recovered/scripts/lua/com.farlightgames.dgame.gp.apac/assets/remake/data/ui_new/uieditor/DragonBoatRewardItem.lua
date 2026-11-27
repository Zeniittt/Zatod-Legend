ed.uieditor = ed.uieditor or {}
ed.uieditor.DragonBoatRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 22, h = 21},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/dragonboat/stage_reward/zongzi_dark.png",
      name = "img_zongzi",
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
      fix_wh = {w = 75.5, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "img_zongzi",
      res = "UI/alpha/1080P/dragonboat/stage_reward/bg_digital_progress.png",
      name = "bg_progress",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(11, 35.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(80, 80)
    },
    t = "Layer",
    base = {
      parent = "img_zongzi",
      name = "img_icon",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(11, 92)
    }
  }
}
