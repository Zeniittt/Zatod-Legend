ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashAwardWin = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 848.5, h = 486},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_award/background.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(441, 265)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 65)
    },
    t = "Scale9Sprite",
    base = {
      name = "image_title",
      z = 0,
      parent = "image_bg",
      res = "UI/alpha/1080P/lottery/title_light_tf.png",
      capInsets = CCRectMake(20, 25, 2.5, 2.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(422.75, 448)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(135, 400)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_tab_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(824.25, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(712.5, 28)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(68.75, 395.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(745, 367.5)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_reward_list",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(51.75, 23.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 39.5, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/btn_back.png",
      name = "btn_close",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(808.75, 454)
    }
  }
}
