ed.uieditor = ed.uieditor or {}
ed.uieditor.GuildClashSetTeamWin = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(470, 495)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(16.5, 19.5, 16.5, 16.5),
      res = "UI/alpha/1080P/common/com_new_3.png",
      name = "bg",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(244.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1.01},
      flip = "",
      opacity = 255,
      fix_wh = {w = 475.71, h = 171},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/guildteam_floor.png",
      name = "ImageView_68",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(235, 417.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20, h = 23},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/myteam_icon.png",
      name = "icon",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(180.5, 480)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162.5, h = 116},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_unselected.png",
      name = "btn_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174, 443)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(470, 458)
    },
    t = "Layer",
    base = {
      parent = "bg",
      name = "layer_self",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 2)
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
      name = "label_title",
      z = 0,
      parent = "icon",
      text = T("\230\136\145\231\154\132\233\152\159\228\188\141"),
      size = 17
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(30, 11.5)
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
      name = "label_team_num",
      z = 0,
      parent = "icon",
      text = T("6\233\152\159"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(119.5, 11.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.6999999, x = 0.6999999},
      flip = "",
      opacity = 255,
      fix_wh = {w = 37.7999946, h = 38.4999945},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg",
      res = "UI/alpha/1080P/common/break_butt_bj.png",
      name = "btn_back",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(467, 488.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162.5, h = 116},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_unselected.png",
      name = "btn_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174, 348)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162.5, h = 116},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_top",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_selected.png",
      name = "btn_top_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.25, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42, h = 42},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_top",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_toproad_unselected.png",
      name = "icon_top",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162.5, h = 116},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_unselected.png",
      name = "btn_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(174, 247.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(132.5, 77)
    },
    t = "Layer",
    base = {
      parent = "btn_top",
      name = "btn_top_touchArea",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26.75, 18.5)
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
      name = "ImageView_102",
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
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_top_selected",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_toproad_selected.png",
      name = "icon_top_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 252, 210),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_top_selected",
      z = 0,
      parent = "btn_top_selected",
      text = T("\228\184\138\232\183\175"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 133.5, h = 189},
      visible = false
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/guild/guild_clash_deploy/operate_floor.png",
      name = "bg_oppoBtn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(650, 382.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.5, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_mid",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_midroad_unselected.png",
      name = "icon_mid",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 191, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_top",
      z = 0,
      parent = "icon_top",
      text = T("\228\184\138\232\183\175"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.5, 20.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162.5, h = 116},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_mid",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_selected.png",
      name = "btn_mid_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.25, 58)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(132.5, 77)
    },
    t = "Layer",
    base = {
      parent = "btn_mid",
      name = "btn_mid_touchArea",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26.75, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_bottom",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_botroad_unselected.png",
      name = "icon_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 191, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_mid",
      z = 0,
      parent = "icon_mid",
      text = T("\228\184\173\232\183\175"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67.75, 19.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 162.5, h = 116},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "btn_bottom",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_selected.png",
      name = "btn_bottom_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(81.25, 58)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(132.5, 77)
    },
    t = "Layer",
    base = {
      parent = "btn_bottom",
      name = "btn_bottom_touchArea",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(26.75, 18.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 42.5, h = 40},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_mid_selected",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_midroad_selected.png",
      name = "icon_mid_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 252, 210),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_mid_selected",
      z = 0,
      parent = "btn_mid_selected",
      text = T("\228\184\173\232\183\175"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppoBtn",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      name = "btn_set1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.75, 156.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppoBtn",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      name = "btn_set2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.75, 114.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppoBtn",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      name = "btn_edit",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.75, 72.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(154, 191, 179),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bottom",
      z = 0,
      parent = "icon_bottom",
      text = T("\228\184\139\232\183\175"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(67, 19)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 101.5, h = 42},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_oppoBtn",
      res = "UI/alpha/1080P/common/button_mini_sys.png",
      name = "btn_delete",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(66.75, 30.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 41, h = 39},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_bottom_selected",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/tab_botroad_selected.png",
      name = "icon_bottom_selected",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(58.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 252, 210),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_bottom_selected",
      z = 0,
      parent = "btn_bottom_selected",
      text = T("\228\184\139\232\183\175"),
      size = 21
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(104.75, 58)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_set1",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/operate_botroad.png",
      name = "icon_set1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 22)
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
      name = "label_set1",
      z = 0,
      parent = "btn_set1",
      text = T("\230\180\190\229\190\128\228\184\139\232\183\175"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34.5, h = 32},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_set2",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/operate_midroad.png",
      name = "icon_set2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 22)
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
      name = "label_set2",
      z = 0,
      parent = "btn_set2",
      text = T("\230\180\190\229\190\128\228\184\139\232\183\175"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 32, h = 31.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_edit",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/operate_edit.png",
      name = "icon_edit",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 22)
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
      name = "label_edit",
      z = 0,
      parent = "btn_edit",
      text = T("\232\176\131\230\149\180\233\152\181\229\174\185"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 22)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 30, h = 32.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_delete",
      res = "UI/alpha/1080P/guild/guild_clash_deploy/operate_delete.png",
      name = "icon_delete",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(19.75, 22)
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
      name = "label_delete",
      z = 0,
      parent = "btn_delete",
      text = T("\229\136\160\233\153\164\233\152\159\228\188\141"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(61.75, 22)
    }
  }
}
