ed.uieditor = ed.uieditor or {}
ed.uieditor.packageExpire = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(938, 191.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(468, 95, 1, 25),
      res = "UI/alpha/1080P/package/new/equip_timeout_frame.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 284)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(209, 200, 168),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 0,
      parent = "bg",
      text = T("\228\187\165\228\184\139\231\137\169\229\147\129\229\183\178\232\191\135\230\156\159\239\188\154"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(469, 170.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(600, 128)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "itemTableView",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(171.5, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(183, 9.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-48, 8.75)
    }
  }
}
