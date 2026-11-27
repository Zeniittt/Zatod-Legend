ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildMemberInfoWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(430, 300)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 25, 10, 25),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
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
      fix_scale = {y = 0.799999952, x = 0.799999952},
      flip = "",
      opacity = 255,
      fix_wh = {w = 43.199997408, h = 43.99999736},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(413.5, 284.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29.5, h = 29.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/add_contact.png",
      name = "btn_add",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(349.5, 245.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 93.5, h = 94},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/main/main_head_playtop.png",
      name = "avatar",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(87.5, 232)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label1",
      z = 0,
      parent = "bg",
      text = T("\230\156\128\232\191\1457\230\151\165\232\180\161\231\140\174\239\188\15410"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40, 159.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(232, 177, 82),
      opacity = 255,
      verticalAlignment = 0,
      visible = false
    },
    t = "Label",
    base = {
      name = "label2",
      z = 0,
      parent = "bg",
      text = T("\230\156\128\232\191\1457\230\151\165\232\180\161\231\140\174\239\188\15410"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(40, 117)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(369, 5)
    },
    t = "Scale9Sprite",
    base = {
      name = "line",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/campaign/campaign_detail_line_1.png",
      capInsets = CCRectMake(20, 0, 200, 5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(215, 86)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 45)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_hof",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(115, 45)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 45)
    },
    t = "Scale9Sprite",
    base = {
      name = "btn_social",
      z = 0,
      parent = "bg",
      res = "UI/alpha/1080P/common/button_com_sys.png",
      capInsets = CCRectMake(25, 11.5, 25, 11.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(315, 45)
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
      parent = "btn_back",
      res = "UI/alpha/1080P/common/butt_off.png",
      name = "ImageView_2427",
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
      color = ccc3(255, 252, 231),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_hof",
      z = 0,
      parent = "btn_hof",
      text = T("\230\159\165\231\156\139\232\141\163\232\170\137"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 24)
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
      name = "label_social",
      z = 0,
      parent = "btn_social",
      text = T("\229\143\145\232\181\183\232\129\138\229\164\169"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(50, 24)
    }
  }
}
