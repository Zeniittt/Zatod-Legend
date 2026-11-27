ed.uieditor = ed.uieditor or {}
ed.uieditor.SkillTowerRewardItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 553, h = 87},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skilltower/bg_can_get.png",
      name = "bg",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 255),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_star_num",
      z = 0,
      parent = "bg",
      text = T("\230\148\182\233\155\13412\233\162\151\230\152\159"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(53, 44.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(118, 43.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_get",
      z = 1,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_big.png",
      capInsets = CCRectMake(10, 10, 10, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(478.5, 43.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(277, 80.5)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(112.5, 5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_get",
      z = 0,
      parent = "btn_get",
      text = T("\233\162\134 \229\143\150"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(59, 23.25)
    }
  }
}
