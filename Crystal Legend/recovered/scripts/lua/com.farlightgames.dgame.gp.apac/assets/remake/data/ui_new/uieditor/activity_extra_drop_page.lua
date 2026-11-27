ed.uieditor = ed.uieditor or {}
ed.uieditor.activity_extra_drop_page = {
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 1170, h = 720},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/stage_extra_drop/qixi_festival.jpg",
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
      fix_scale = {y = 0.85, x = 0.85},
      flip = "",
      opacity = 255,
      fix_wh = {w = 203.575, h = 61.2},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_go",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(754.5, 79.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.7, x = 0.7},
      flip = "",
      opacity = 255,
      fix_wh = {w = 167.65, h = 50.4},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/activity/activity_gift_btn_img.png",
      name = "btn_go_common",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(561, 132)
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
      name = "label_go",
      z = 0,
      parent = "btn_go",
      text = T("\229\137\141\229\190\128\230\136\152\229\189\185"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.25, 39.5)
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
      name = "panel_drop_item_common",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(522, 249)
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
      size = 18,
      text = T("\229\137\169\228\189\15314\229\164\1694\230\151\182"),
      name = "label_left_time_common",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(524.5, 411)
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
      name = "label_go_common",
      z = 0,
      parent = "btn_go_common",
      text = T("\229\137\141\229\190\128\230\136\152\229\189\185"),
      size = 30
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.25, 39.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 169, h = 170},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "panel_drop_item_common",
      res = "UI/alpha/1080P/activity/stage_extra_drop/common_highlight.png",
      name = "image_mask",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41, 32.5)
    }
  }
}
