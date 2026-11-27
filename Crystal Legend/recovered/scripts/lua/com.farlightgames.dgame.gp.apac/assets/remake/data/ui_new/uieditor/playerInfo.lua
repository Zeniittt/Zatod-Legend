ed.uieditor = ed.uieditor or {}
ed.uieditor.playerInfo = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(605, 391.5)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/common/mail_bj9_1.png",
      name = "bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 466)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(245, 221, 183),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 18,
      text = T("\228\191\161\230\129\175\228\184\142\232\174\190\231\189\174"),
      name = "lb_title",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(479, 441.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(50, 50)
    },
    t = "Layer",
    base = {name = "head_panel", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(265, 364)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "lb_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_100",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(133, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 67, h = 12},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "lb_title",
      res = "UI/alpha/1080P/common/battle_prepare_lins_1.png",
      name = "ImageView_100_Copy0",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-48.5, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      fix_wh = {w = 93, h = 42.6},
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      name = "btn_personal_setting",
      z = 0,
      text = T("\228\184\170\230\128\167\232\174\190\231\189\174"),
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.5, 283)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.2, x = 1.2},
      fix_wh = {w = 93, h = 42.6},
      flip = "",
      labelConfig = {
        color = ccc3(255, 252, 231)
      },
      opacity = 255,
      visible = true,
      pressConfig = {flip = ""}
    },
    t = "DGButton",
    base = {
      normal = "UI/alpha/1080P/common/button_com_sys.png",
      name = "btn_team_honor",
      z = 0,
      text = T("\230\136\152\233\152\159\232\141\163\232\170\137"),
      press = "UI/alpha/1080P/common/button_com_sys.png",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(263.5, 236.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(1, 262)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(0, 0.5, 0.5, 162.5),
      res = "UI/alpha/1080P/setting/setting_line.png",
      name = "ImageView_106",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(354, 287.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 252, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      res = "UI/alpha/1080P/playerinfo/team_name_bg.png",
      name = "rename_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(511, 389.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(397, 208.5)
    },
    t = "Layer",
    base = {name = "info_panel", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(372, 159.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(536, 41.5)
    },
    t = "Layer",
    base = {name = "btns_panel", z = 0},
    layout = {
      anchor = ccp(0, 0),
      position = ccp(209.5, 97.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(129, 125, 120),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      size = 14,
      text = T("IP\229\177\158\229\156\176\239\188\154\228\184\138\230\181\183"),
      name = "ip_location",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(696, 381.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(584, 265)
    },
    t = "Scale9Sprite",
    base = {
      capInsets = CCRectMake(10, 10, 10, 10),
      res = "UI/alpha/1080P/setting/setting_info_bg.png",
      name = "bg1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(480, 419.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 29, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "rename_bg",
      res = "UI/alpha/1080P/playerinfo/icon_setting.png",
      name = "ImageView_108",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(220, 19.5)
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
      name = "team_name",
      z = 0,
      parent = "rename_bg",
      text = T("\230\136\145\231\154\132\229\144\141\229\173\151"),
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126, 19)
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
      name = "Label_111",
      z = 0,
      parent = "info_panel",
      text = T("\230\136\152\233\152\159:"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 224, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "team_level",
      z = 0,
      parent = "info_panel",
      text = T("123\231\186\167"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74.5, 192.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 224, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "guild_name",
      z = 0,
      parent = "info_panel",
      text = T("\233\155\183\228\186\154\229\141\162\229\141\161\232\174\190\233\173\148\230\179\149\229\173\166\233\153\162"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74.5, 163.5)
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
      name = "Label_111_Copy0",
      z = 0,
      parent = "info_panel",
      text = T("\229\133\172\228\188\154:"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 163.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 224, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "server_name",
      z = 0,
      parent = "info_panel",
      text = T("\233\173\148\230\179\149\229\173\166\233\153\162"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(74.5, 137)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 26, h = 26},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "info_panel",
      res = "UI/alpha/1080P/mixserver/icon.png",
      name = "merge_svr_btn",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(74.5, 137)
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
      name = "Label_111_Copy1",
      z = 0,
      parent = "info_panel",
      text = T("\229\140\186\230\156\141:"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 137)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 224, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "uid",
      z = 0,
      parent = "info_panel",
      text = "21312312312",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(110, 110.5)
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
      name = "Label_111_Copy2",
      z = 0,
      parent = "info_panel",
      text = T("\230\156\172\230\156\141\231\188\150\229\143\183:"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 111)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 100,
      visible = true,
      scaleSize = CCSizeMake(235, 15)
    },
    t = "Scale9Sprite",
    base = {
      name = "ImageView_131",
      z = 0,
      parent = "info_panel",
      res = "UI/alpha/1080P/setting/setting_exp_bg.png",
      capInsets = CCRectMake(75, 5, 1.5, 2.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(243.5, 192.5)
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
      name = "Label_111_Copy3",
      z = 0,
      parent = "info_panel",
      text = T("\232\167\146\232\137\178\231\160\129:"),
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(17.5, 86)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(251, 224, 116),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "role_id",
      z = 0,
      parent = "info_panel",
      text = "21312312312",
      size = 18
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(94, 86)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(167.5, 33.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "music_bg",
      z = 0,
      parent = "info_panel",
      res = "UI/alpha/1080P/setting/setting_music_bg.png",
      capInsets = CCRectMake(15, 12.5, 15, 12.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(9, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(167.5, 33.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "effect_bg",
      z = 0,
      parent = "info_panel",
      res = "UI/alpha/1080P/setting/setting_music_bg.png",
      capInsets = CCRectMake(15, 12.5, 15, 12.5)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(204, 41.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 20.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "info_panel",
      res = "UI/alpha/1080P/setting/setting_code_copy.png",
      name = "btn_copy",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(277, 85.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(233, 15)
    },
    t = "Scale9Sprite",
    base = {
      name = "progress_disabled",
      z = 0,
      parent = "ImageView_131",
      res = "UI/alpha/1080P/playerinfo/progress_bg3.png",
      capInsets = CCRectMake(75, 5, 1.5, 2.5)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 8)
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
      name = "progress_text",
      z = 0,
      parent = "ImageView_131",
      text = T("\229\183\178\229\136\176\232\190\190\231\173\137\231\186\167\228\184\138\233\153\144"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(117.5, 8)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(233, 15)
    },
    t = "Layer",
    base = {
      parent = "ImageView_131",
      name = "progress_clip",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(1.5, 1)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.7, h = 24.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "music_bg",
      res = "UI/alpha/1080P/setting/setting_button_on.png",
      name = "switch_music_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 17.25)
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
      name = "Label_123",
      z = 0,
      parent = "music_bg",
      text = T("\233\159\179\228\185\144"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 14, h = 16},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "music_bg",
      res = "UI/alpha/1080P/setting/setting_music_icon.png",
      name = "ImageView_11271",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1.1, x = 1.1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 51.7, h = 24.75},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "effect_bg",
      res = "UI/alpha/1080P/setting/setting_button_on.png",
      name = "switch_effect_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(132.5, 17.25)
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
      name = "Label_123",
      z = 0,
      parent = "effect_bg",
      text = T("\233\159\179\230\149\136"),
      size = 16
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(29, 18.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 16, h = 16.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "effect_bg",
      res = "UI/alpha/1080P/setting/setting_sound_icon.png",
      name = "ImageView_11272",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(16, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(233, 15)
    },
    t = "Scale9Sprite",
    base = {
      name = "progress",
      z = 0,
      parent = "progress_clip",
      res = "UI/alpha/1080P/playerinfo/progress_bg2.png",
      capInsets = CCRectMake(0.5, 3, 162.5, 3)
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(0, 7.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_music_bg",
      res = "UI/alpha/1080P/setting/setting_button_off.png",
      name = "close_music_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_music_bg",
      res = "UI/alpha/1080P/setting/setting_button.png",
      name = "btn_music",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 47, h = 22.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_effect_bg",
      res = "UI/alpha/1080P/setting/setting_button_off.png",
      name = "close_effect_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(23.5, 11.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 21.5, h = 19.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "switch_effect_bg",
      res = "UI/alpha/1080P/setting/setting_button.png",
      name = "btn_effect",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34.5, 11.25)
    }
  }
}
