ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_adventure_addition_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 562.5, h = 87},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activityadventure/adventure_reward_bg3.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(75, 75)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "hero_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(53, 7)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "hero_name",
      z = 0,
      parent = "image_bg",
      text = T("\232\139\177\233\155\132\229\144\141\231\167\176\228\184\131\228\184\170\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(138.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 24.6},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/activityadventure/acttoken/adventure_token_icon_1.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(423.5, 42.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(112, 255, 84),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "addition",
      z = 0,
      parent = "image_bg",
      text = "+40%",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(468.5, 42)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 13.5, h = 17},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/battleresult/arrow_up.png",
      name = "image_arrow_up",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(504, 42.5)
    }
  }
}
