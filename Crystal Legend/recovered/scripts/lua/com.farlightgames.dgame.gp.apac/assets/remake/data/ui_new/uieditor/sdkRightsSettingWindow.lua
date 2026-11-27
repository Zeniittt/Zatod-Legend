ed.uieditor = ed.uieditor or {}
ed.uieditor.sdkRightsSettingWindow = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(606, 412.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5),
      res = "installer/login/serverlist_bg.png",
      name = "frame",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(480, 270)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 54, h = 55},
      flip = "",
      labelConfig = {
        color = ccc3(255, 255, 255)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "close",
      z = 1,
      parent = "frame",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(586, 398.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(565, 335.5)
    },
    t = "Layer",
    base = {
      parent = "frame",
      name = "content_rights",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(20, 15.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(618, 37.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "title_bg",
      z = 0,
      parent = "frame",
      res = "installer/service/title_bg.png",
      capInsets = CCRectMake(50, 12.5, 50, 12.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(303.5, 384.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 33},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "close",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_465",
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
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 210, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "title",
      z = 1,
      parent = "title_bg",
      text = T("\230\157\131\233\153\144\231\174\161\231\144\134"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(309, 18.75)
    }
  }
}
