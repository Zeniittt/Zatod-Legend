ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsRankRewardWindow = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 689.5, h = 433.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/newkingspvp/battlerecord/battle_record_bg.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.2, h = 44},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(677.25, 424.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(679, 370)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(5.75, 5.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(140.5, 55)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_title_bg",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/common/title_light.png",
      capInsets = CCRectMake(15, 15, 15, 15)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(344.75, 402.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_902",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 28.5)
    }
  }
}
