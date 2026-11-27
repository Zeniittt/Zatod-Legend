ed.uieditor = ed.uieditor or {}
ed.uieditor.kingsBattleResultItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(888, 60.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5),
      res = "UI/alpha/1080P/newkingspvp/battleprepare/battleprepare_join_room_num_bg.png",
      name = "image_bg",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(255, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_hero_blue",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(135.5, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(255, 50)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "panel_hero_red",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(494, 6.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 70, h = 63},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_win2.png",
      name = "image_result_win",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 84.5, h = 83},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1.png",
      name = "image_result_fail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(444, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(797.5, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 38.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_record",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(853, 28.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 234, 198),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_round",
      z = 0,
      parent = "image_bg",
      text = "Round 1",
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(63, 30.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.8, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail",
      res = "UI/alpha/1080P/crusade/btn_statics.png",
      name = "ImageView_2195",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.19999993},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.799997795, h = 36},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_record",
      res = "UI/alpha/1080P/crusade/btn_replay.png",
      name = "ImageView_2194",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}
