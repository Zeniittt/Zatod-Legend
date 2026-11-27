ed.uieditor = ed.uieditor or {}
ed.uieditor.herodetailSkill = {
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      name = "layer_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(478.5, 253.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "layer_skill",
      name = "layer_skill_small",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "skill1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-355, 111)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill1",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "icon1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill1",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank1",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 106)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "skill2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-94.5, 111)
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
      name = "skill_level1",
      z = 1,
      parent = "skill1",
      text = "lv.55",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_rank1",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill1",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "skill_mask1",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
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
      name = "skill_rank1",
      z = 0,
      parent = "frame_skill_rank1",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 460.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "bg_skill_info",
      z = 0,
      parent = "layer_skill",
      res = "UI/alpha/1080P/hero/hero_info_bg_0.png",
      capInsets = CCRectMake(18, 150, 18, 160)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(204, 4.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "skill3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-355, -141.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill1",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_2.png",
      name = "skill_selected1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill2",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank2",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 106)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 131, h = 60},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill1",
      res = "UI/alpha/1080P/skill/new/skill_nirvana.png",
      name = "unique_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 16.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill2",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "icon2",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "skill4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-94, -141)
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
      name = "skill_level2",
      z = 1,
      parent = "skill2",
      text = "lv.55",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_mask1",
      res = "UI/alpha/1080P/skill/skill_lock.png",
      name = "skill_lock1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 65.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_rank2",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 276, h = 116.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "skill_mask1",
      res = "UI/alpha/1080P/skill/skill_frame_choose.png",
      name = "selected1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill2",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "skill_mask2",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 33, h = 39.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill",
      res = "UI/alpha/1080P/hero/hero_bg_frame_1.png",
      name = "sep1",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-21.5, 215)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 175)
    },
    t = "Layer",
    base = {
      parent = "layer_skill_small",
      name = "hero_pos",
      z = 1
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(-266.5, -107)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 432, h = 43.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/skill/new/skill_name_bg.png",
      name = "bg_title_skill",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(223.5, 435.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill2",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_2.png",
      name = "skill_selected2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill3",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank3",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 106)
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
      name = "skill_rank2",
      z = 0,
      parent = "frame_skill_rank2",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill3",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "icon3",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 67.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 345, h = 228.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/hero/hero_bg_mid_2.png",
      name = "image_bg_name",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-219, 118)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(100, 100)
    },
    t = "Layer",
    base = {
      parent = "bg_skill_info",
      name = "layer_skill_bottom",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(225, 230.25)
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
      name = "skill_level3",
      z = 1,
      parent = "skill3",
      text = "lv.55",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(225, 209, 181),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_unique_skill",
      z = 0,
      parent = "unique_skill",
      text = T("\229\191\133\230\157\128\230\138\128"),
      size = 12
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(64.5, 12)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill3",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "skill_mask3",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 458.5, h = 40},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "layer_skill",
      res = "UI/alpha/1080P/hero/hero_gs_up_bg.png",
      name = "bg_gsadd",
      z = 10
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-225, -53.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 213, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/hero/rank/hero_rank_1.png",
      name = "frame_name_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-218.5, 205.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(450, 165)
    },
    t = "Layer",
    base = {
      parent = "bg_skill_info",
      name = "bg_skill_ranks",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0.5, 141.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill3",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_2.png",
      name = "skill_selected3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill4",
      res = "UI/alpha/1080P/skill/skill_rank_2.png",
      name = "bg_skill_rank4",
      z = 2
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 106)
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
      name = "skill_info_name",
      z = 0,
      parent = "bg_title_skill",
      text = T("\228\186\161\231\129\181\229\143\172\229\148\164"),
      size = 21
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(228.5, 22.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_mask2",
      res = "UI/alpha/1080P/skill/skill_lock.png",
      name = "skill_lock2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 65.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_rank3",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 276, h = 116.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "skill_mask2",
      res = "UI/alpha/1080P/skill/skill_frame_choose.png",
      name = "selected2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 90, h = 90},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill4",
      res = "UI/alpha/1080P/common/frame/equip_frame_white.png",
      name = "icon4",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 67.5)
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
      name = "skill_info_level",
      z = 0,
      parent = "bg_title_skill",
      text = "lv.55",
      size = 21
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(245, 22.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 398.5, h = 397.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/hero/hero_bg_tattoos_2.png",
      name = "image_skill_bg",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-219, -27)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(447.5, 97.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "skill_introduction",
      z = 1,
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/skill/skill_bg_bj9_1.png",
      capInsets = CCRectMake(10, 20, 489, 30)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(225, 399.75)
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
      name = "skill_level4",
      z = 1,
      parent = "skill4",
      text = "lv.55",
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.75, 21.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/skill/new/skill_passive.png",
      name = "is_passive_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(33.5, 409.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill4",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_1.png",
      name = "skill_mask4",
      z = 3
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 307.5, h = 98.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/skill/new/skill_tattoo_2.png",
      name = "ImageView_1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-219, 133.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(227.5, 32.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "skill_btn_bg",
      z = 1,
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/skill/new/skill_button_bg.png",
      capInsets = CCRectMake(105, 10, 105, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(228.5, 398.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 156.5, h = 128},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill4",
      res = "UI/alpha/1080P/skill/new/skill_icon_bg_2.png",
      name = "skill_selected4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      scaleSize = CCSizeMake(153, 43),
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
      normal = "UI/alpha/1080P/package/btn_package2.png",
      capInsets = CCRectMake(30.5, 13, 30.5, 13),
      name = "btn_skillup",
      z = 2,
      parent = "layer_skill_bottom",
      text = "",
      press = "UI/alpha/1080P/package/btn_package2.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0.5, -200)
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
      name = "skill_rank3",
      z = 0,
      parent = "frame_skill_rank3",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 74, h = 34.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/skill/new/skill_halo.png",
      name = "is_aura_skill",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(34, 410.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 226, 186),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_need",
      z = 2,
      parent = "layer_skill_bottom",
      text = T("\230\182\136\232\128\151\239\188\154"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-60, -138)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "y",
      opacity = 255,
      fix_wh = {w = 307.5, h = 98.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_small",
      res = "UI/alpha/1080P/skill/new/skill_tattoo_2.png",
      name = "ImageView_2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-219, -147.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 447.5, h = 56.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_info",
      res = "UI/alpha/1080P/skill/new/skill_name_light.png",
      name = "bg_title_light",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(225, 428.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 253.5, h = 31},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_bottom",
      res = "UI/alpha/1080P/skill/new/skill_max.png",
      name = "max_banner",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-2.5, -172.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_mask3",
      res = "UI/alpha/1080P/skill/skill_lock.png",
      name = "skill_lock3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 65.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 35.5, h = 21.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "bg_skill_rank4",
      res = "UI/alpha/1080P/skill/skill_rank_1.png",
      name = "frame_skill_rank4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 276, h = 116.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "skill_mask3",
      res = "UI/alpha/1080P/skill/skill_frame_choose.png",
      name = "selected3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 50, h = 12.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "layer_skill_bottom",
      res = "UI/alpha/1080P/skill/skill_line_center.png",
      name = "skill_line",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(0, -96.5)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = false,
      scaleSize = CCSizeMake(275, 32.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "skill_upgrade_tips",
      z = 0,
      parent = "layer_skill_bottom",
      res = "UI/alpha/1080P/skill/new/skill_lock_bg.png",
      capInsets = CCRectMake(100, 10, 100, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3, -169)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(186.5, 32.5)
    },
    t = "Scale9Sprite",
    base = {
      name = "skill_unlock_condition",
      z = 0,
      parent = "layer_skill_bottom",
      res = "UI/alpha/1080P/skill/new/skill_lock_bg.png",
      capInsets = CCRectMake(100, 10, 100, 10)
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(-3, -169)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      fix_wh = {w = 52, h = 53},
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
      normal = "UI/alpha/1080P/hero/bg_btn1.png",
      name = "btn_add_material",
      z = 0,
      parent = "layer_skill_bottom",
      text = "",
      press = "UI/alpha/1080P/hero/bg_btn1.png",
      size = 7
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(159, -138.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(254, 241, 169),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_skillup",
      z = 0,
      parent = "btn_skillup",
      text = T("\229\141\135\231\186\167"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(77.5, 23)
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
      name = "hero_name",
      z = 0,
      parent = "frame_name_bg",
      text = T("\232\136\185\233\149\191+2"),
      size = 24
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(106.5, 19)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(431.5, 74)
    },
    t = "Layer",
    base = {
      parent = "skill_introduction",
      name = "skill_simple_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.25, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.8, x = 0.8},
      flip = "",
      opacity = 255,
      fix_wh = {w = 58, h = 58},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_mask4",
      res = "UI/alpha/1080P/skill/skill_lock.png",
      name = "skill_lock4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 65.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_need",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "material1",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(110, 10.25)
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
      name = "skill_rank4",
      z = 0,
      parent = "frame_skill_rank4",
      text = "1",
      size = 18
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(17.75, 10.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 276, h = 116.5},
      visible = false
    },
    t = "Sprite",
    base = {
      parent = "skill_mask4",
      res = "UI/alpha/1080P/skill/skill_frame_choose.png",
      name = "selected4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(78.25, 64)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_need",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "material2",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(185.5, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_need",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "material3",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(261, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_need",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "material4",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(336.5, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      flip = "",
      opacity = 255,
      visible = true,
      scaleSize = CCSizeMake(431.5, 73)
    },
    t = "Layer",
    base = {
      parent = "skill_introduction",
      name = "skill_detail_desc",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0),
      position = ccp(7.25, 10.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(153, 135, 194),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_is_passive_skill",
      z = 0,
      parent = "is_passive_skill",
      text = T("\232\162\171\229\138\168"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(36.5, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_need",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "material5",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(412, 10.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(242, 221, 191),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_max_banner",
      z = 0,
      parent = "max_banner",
      text = T("\229\183\178\232\190\190\229\136\176\230\156\128\229\164\167\231\173\137\231\186\167"),
      size = 20
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(126.75, 18)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_need",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "material6",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(487.5, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 0.75, x = 0.75},
      flip = "",
      opacity = 255,
      fix_wh = {w = 67.5, h = 67.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "label_need",
      res = "UI/alpha/1080P/common/frame/equip_frame_orange.png",
      name = "material7",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(563, 20.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 1,
      fix_wh = {w = 83, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_btn_bg",
      res = "UI/alpha/1080P/skill/new/skill_detail_button_1.png",
      name = "btn_simple",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(70.25, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "x",
      opacity = 255,
      fix_wh = {w = 110, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_line",
      res = "UI/alpha/1080P/skill/skill_line_left.png",
      name = "skill_line_left",
      z = 0
    },
    layout = {
      anchor = ccp(1, 0.5),
      position = ccp(0, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 110, h = 2},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_line",
      res = "UI/alpha/1080P/skill/skill_line_left.png",
      name = "skill_line_right",
      z = 0
    },
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(50, 4.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 1,
      fix_wh = {w = 83, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_btn_bg",
      res = "UI/alpha/1080P/skill/new/skill_detail_button_1.png",
      name = "btn_detail",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(157.75, 17.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(239, 205, 122),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_is_aura_skill",
      z = 0,
      parent = "is_aura_skill",
      text = T("\229\133\137\231\142\175"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(37, 17.25)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(255, 226, 186),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc_unlock_condition_1",
      z = 0,
      parent = "skill_upgrade_tips",
      text = T("\230\136\152\233\152\159\231\173\137\231\186\167\232\190\190\229\136\1767\231\186\167\229\188\128\230\148\190\230\138\128\232\131\189\229\141\135\231\186\167"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(149.5, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(241, 48, 51),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "desc_unlock_condition",
      z = 0,
      parent = "skill_unlock_condition",
      text = T("\232\139\177\233\155\132\232\190\190\229\136\176\232\147\157\233\152\182\232\167\163\233\148\129"),
      size = 17
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(105.25, 16.75)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 34, h = 30.5},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "skill_introduction",
      res = "UI/alpha/1080P/skill/skill_expound_arrow.png",
      name = "skill_introduction_arrow",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(223.75, 9.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 40, h = 38},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_add_material",
      res = "UI/alpha/1080P/skill/skill_icon_fastsupply.png",
      name = "icon_add_material",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 29.5)
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
      name = "label_add_material",
      z = 0,
      parent = "btn_add_material",
      text = T("\232\161\165\229\133\133\230\157\144\230\150\153"),
      size = 15
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(26, 7)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_simple",
      res = "UI/alpha/1080P/skill/new/skill_detail_button_1.png",
      name = "btn_simple_select",
      z = 1
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_simple",
      res = "UI/alpha/1080P/skill/new/skill_detail_button_2.png",
      name = "btn_simple_normal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 78, h = 25},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail",
      res = "UI/alpha/1080P/skill/new/skill_detail_button_2.png",
      name = "btn_detail_normal",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      fix_scale = {y = 1, x = 1},
      flip = "",
      opacity = 255,
      fix_wh = {w = 83, h = 29},
      visible = true
    },
    t = "Sprite",
    base = {
      parent = "btn_detail",
      res = "UI/alpha/1080P/skill/new/skill_detail_button_1.png",
      name = "btn_detail_select",
      z = 0
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 14.5)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 233, 163),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_simple_select",
      z = 0,
      parent = "btn_simple_select",
      text = T("\230\138\128\232\131\189\231\174\128\228\187\139"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 15.5)
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
      name = "label_simple_normal",
      z = 0,
      parent = "btn_simple_normal",
      text = T("\230\138\128\232\131\189\231\174\128\228\187\139"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39, 14)
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
      name = "label_detail_normal",
      z = 0,
      parent = "btn_detail_normal",
      text = T("\230\138\128\232\131\189\232\175\166\230\131\133"),
      size = 14
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(39, 14)
    }
  },
  {
    config = {
      rotation = 0,
      scalexy = {y = 1, x = 1},
      horizontalAlignment = 0,
      flip = "",
      color = ccc3(250, 233, 163),
      opacity = 255,
      verticalAlignment = 0,
      visible = true
    },
    t = "Label",
    base = {
      name = "label_detail_select",
      z = 0,
      parent = "btn_detail_select",
      text = T("\230\138\128\232\131\189\232\175\166\230\131\133"),
      size = 16
    },
    layout = {
      anchor = ccp(0.5, 0.5),
      position = ccp(41.5, 15.5)
    }
  }
}
