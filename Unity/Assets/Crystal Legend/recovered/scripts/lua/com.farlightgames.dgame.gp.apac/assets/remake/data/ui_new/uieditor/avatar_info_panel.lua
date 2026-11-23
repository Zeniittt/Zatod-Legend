ed.uieditor = ed.uieditor or {}
ed.uieditor.avatar_info_panel = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(555.5, 170)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 200),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "image_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(533, 267)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 165, 49),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_title",
      z = 0,
      parent = "image_bg",
      text = T("\229\164\180\229\131\143+\230\161\134\232\175\166\230\131\133"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(22.25, 153.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 348.5, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "image_bg",
      res = "UI/alpha/1080P/honorwall/honorwall_detail_title_1.png",
      name = "image_bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(179.25, 153)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(25, 25)
    },
    t = "Layer",
    base = {
      parent = "image_bg",
      name = "node_avatar",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(54.75, 71.5)
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
      name = "label_avatar_name",
      z = 0,
      parent = "image_bg",
      text = T("\229\164\180\229\131\143"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(113.25, 115)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_avatar_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\191\128\230\180\187\230\157\161\228\187\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(114.25, 102)
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
      name = "label_frame_name",
      z = 0,
      parent = "image_bg",
      text = T("\229\164\180\229\131\143\230\161\134"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(113.25, 50)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 211, 109),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_frame_desc",
      z = 0,
      parent = "image_bg",
      text = T("\230\191\128\230\180\187\230\157\161\228\187\182"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 1),
      position = ccp(114.25, 38)
    }
  }
}
