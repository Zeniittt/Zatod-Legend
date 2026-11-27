ed.uieditor = ed.uieditor or {}
ed.uieditor.serverFrameHeadItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(190.5, 133)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(6.5, 6.5, 6.5, 6.5),
      res = "UI/alpha/1080P/honorwall/honorwall_vip.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 2.34983754, x = 2.334167},
      flip = "",
      opacity = 255,
      fix_wh = {w = 187.9004435, h = 31.72280679},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/crusade/tip_detail_bg.png",
      name = "serverNameBg",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(95.25, 116)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverID",
      z = 2,
      parent = "bg",
      text = T("2119\229\140\186"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(56.75, 117)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 206, 16),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "serverName",
      z = 2,
      parent = "bg",
      text = T("\230\179\162\229\138\168\232\131\189\233\135\143"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133.75, 116.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(40, 40)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "headFramePanel",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(36.75, 18.5)
    }
  }
}
