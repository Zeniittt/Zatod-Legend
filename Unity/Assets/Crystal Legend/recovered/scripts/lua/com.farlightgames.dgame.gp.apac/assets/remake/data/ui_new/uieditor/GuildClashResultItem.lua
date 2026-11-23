ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashResultItem = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 96)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(350, 32, 5, 32),
      res = "UI/alpha/1080P/guild/guild_clash_report2/win_floor.png",
      name = "image_bg_win",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 0)
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
      text = T("\231\172\172\228\186\140\232\189\174"),
      name = "label_turn",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(60.5, 1.5)
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
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_win2.png",
      name = "image_result_win",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(166.5, 0)
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
      res = "UI/alpha/1080P/toparena/battleshow/battleshow_result_lose1.png",
      name = "image_result_lose",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(166.5, 0)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(244, 221, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 16,
      text = T("\229\175\185\230\137\139:"),
      name = "label_tips",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(359.5, 0.5)
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
      text = T("\229\133\172\228\188\154\229\144\141\229\173\151"),
      name = "label_guild_name",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(486, 1)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(65, 65)
    },
    t = "Layer",
    base = {
      name = "panel_guild_icon",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(413, -31.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(650, 96)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(350, 32, 5, 32),
      res = "UI/alpha/1080P/guild/guild_clash_report2/lose_floor.png",
      name = "image_bg_lose",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 0)
    }
  }
}
