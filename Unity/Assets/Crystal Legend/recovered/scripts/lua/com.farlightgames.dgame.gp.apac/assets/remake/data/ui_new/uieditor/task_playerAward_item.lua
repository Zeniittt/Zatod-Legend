ed.uieditor = ed.uieditor or {}
ed.uieditor.task_playerAward_item = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76, h = 362},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/task/player_award_list_old.png",
      name = "award_item_bj",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 181)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 77, h = 362},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/task/player_award_list_new.png",
      name = "award_item_press",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(38.5, 181)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 248, 201),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 16,
      text = T("1\231\186\167"),
      name = "txt_item_level",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39, 344)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(77, 362)
    },
    t = "Layer",
    base = {name = "panel_item", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  }
}
