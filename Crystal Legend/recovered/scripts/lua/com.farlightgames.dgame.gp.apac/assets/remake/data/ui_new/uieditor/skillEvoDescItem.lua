ed.uieditor = ed.uieditor or {}
ed.uieditor.skillEvoDescItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(448, 45.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 5, 1, 35),
      res = "UI/alpha/1080P/skill/new/skill_info_bg1.png",
      name = "bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "desc_skill",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-171, 0)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(448, 45.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(30, 5, 1, 35),
      res = "UI/alpha/1080P/skill/new/skill_info_bg2.png",
      name = "bg2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0.5)
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
      name = "desc_skill_rank",
      z = 0,
      parent = "desc_skill",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  }
}
