ed.uieditor = ed.uieditor or {}
ed.uieditor.ageTips = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(635, 412.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(7.5, 7.5, 7.5, 7.5),
      res = "installer/login/serverlist_bg.png",
      name = "frame",
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
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(626, 42)
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
      position = ccp(316.5, 382.75)
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
      text = T("\233\128\130\233\190\132\230\143\144\231\164\186"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(313, 21)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(570.5, 322)
    },
    t = "Layer",
    base = {
      parent = "frame",
      name = "content_rights",
      z = 2
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(32, 21.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 193, 113),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "rithts_tips",
      z = 0,
      parent = "frame",
      text = T("\228\184\186\231\161\174\228\191\157\230\130\168\231\154\132\230\184\184\230\136\143\228\189\147\233\170\140\239\188\140\230\136\145\228\187\172\229\176\134\229\156\168\230\130\168\228\189\191\231\148\168\230\136\145\228\187\172\231\154\132\230\156\141\229\138\161\232\191\135\231\168\139\228\184\173\231\148\179\232\175\183\228\187\165\228\184\138\230\157\131\233\153\144\239\188\140\229\177\138\230\151\182\230\130\168\229\143\175\228\187\165\233\128\137\230\139\169\229\144\140\230\132\143\230\136\150\230\139\146\231\187\157\229\188\128\229\144\175\231\155\184\229\133\179\230\157\131\233\153\144\239\188\140\229\144\140\230\132\143\229\144\142\229\143\175\228\186\142\231\179\187\231\187\159\232\174\190\231\189\174\228\184\173\232\191\155\232\161\140\229\133\179\233\151\173\230\142\136\230\157\131\227\128\130"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(317.5, 106.75)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(54, 55),
      flip = "",
      labelConfig = {
        color = ccc3(253, 240, 158)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/break_butt_bj.png",
      capInsets = CCRectMake(15, 15, 15, 10),
      name = "closeBtn",
      z = 0,
      parent = "frame",
      text = "",
      press = "UI/alpha/1080P/common/break_butt_bj.png",
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(610, 397.25)
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
      parent = "closeBtn",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_464",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(27, 27.5)
    }
  }
}
