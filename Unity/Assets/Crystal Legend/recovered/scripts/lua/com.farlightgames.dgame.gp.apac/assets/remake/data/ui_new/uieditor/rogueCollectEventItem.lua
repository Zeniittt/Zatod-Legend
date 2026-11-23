ed.uieditor = ed.uieditor or {}
ed.uieditor.rogueCollectEventItem = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 286, h = 92},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/rogue/collect/collect_event_frame.png",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 255, 251),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_event_name",
      z = 0,
      parent = "image_bg",
      text = T("\228\186\139\228\187\182\229\144\141\231\167\176"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(143, 46)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 46.5, h = 46.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/collect/collect_reward_icon_2.png",
      name = "btn_reward",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(272, 83)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50.5, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/rogue/collect/collect_event_done.png",
      name = "image_done",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(251, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.65, x = 0.65},
      flip = "",
      opacity = 255,
      fix_wh = {w = 76.05, h = 76.05},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_reward",
      res = "UI/alpha/1080P/taskModel/player_award_list_item_eff.png",
      name = "image_reward_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.25, 23.25)
    }
  }
}
