local base = ed.ui.baseres
local class = newclass(base.mt)
ed.heroDetailManager.resConfig = class
setfenv(1, class)
equip_tag_icon = {
  wear = "UI/alpha/1080P/hero/equip/equip_add_2.png",
  upgrade = "UI/alpha/HVGA/Resource_for_titan/titandetail-equip-enhancedtag.png",
  cannotwear = "UI/alpha/1080P/hero/equip/equip_add_1.png"
}
equip_tag_text = {
  notHave = {
    text = T("\230\151\160\232\163\133\229\164\135"),
    labelColor = ed.toccc3(14735037),
    strokeColor = ed.toccc3(1972758),
    strokeSize = 1.5
  },
  canWear = {
    text = T("\229\143\175\232\163\133\229\164\135"),
    labelColor = ed.toccc3(11665187),
    strokeColor = ed.toccc3(400676),
    strokeSize = 1.5
  },
  cannotwear = {
    text = T("\230\156\170\232\163\133\229\164\135"),
    labelColor = ed.toccc3(16770422),
    strokeColor = ed.toccc3(2035467),
    strokeSize = 1.5
  },
  canCraft = {
    text = T("\229\143\175\229\144\136\230\136\144"),
    labelColor = ed.toccc3(11665187),
    strokeColor = ed.toccc3(400676),
    strokeSize = 1.5
  },
  canUse = {
    text = T("\229\143\175\228\189\191\231\148\168"),
    labelColor = ed.toccc3(11665187),
    strokeColor = ed.toccc3(400676),
    strokeSize = 1.5
  },
  lock = {
    text = T("\230\156\170\232\167\163\233\148\129"),
    labelColor = ed.toccc3(13287589),
    strokeColor = ed.toccc3(2366491),
    strokeSize = 1.5
  }
}
type_icon = {
  STR = "UI/alpha/HVGA/icon_str.png",
  AGI = "UI/alpha/HVGA/icon_agi.png",
  INT = "UI/alpha/HVGA/icon_int.png"
}
card_type_icon = {
  STR = "UI/alpha/1080P/card/card_att_str.png",
  AGI = "UI/alpha/1080P/card/card_att_agi.png",
  INT = "UI/alpha/1080P/card/card_att_int.png"
}
card_frame = {
  "UI/alpha/1080P/card/card_bg_white.png",
  "UI/alpha/1080P/card/card_bg_green.png",
  "UI/alpha/1080P/card/card_bg_green.png",
  "UI/alpha/1080P/card/card_bg_blue.png",
  "UI/alpha/1080P/card/card_bg_blue.png",
  "UI/alpha/1080P/card/card_bg_blue.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_purple.png",
  "UI/alpha/1080P/card/card_bg_orange.png",
  "UI/alpha/1080P/card/card_bg_orange.png",
  "UI/alpha/1080P/card/card_bg_orange.png",
  "UI/alpha/1080P/card/card_bg_red.png",
  "UI/alpha/1080P/card/card_bg_red.png"
}
card_rotate_amount = 0
card_rotate_direction = "left"
skill_unlock_color_text = {
  T("\231\153\189\233\152\182"),
  T("\231\187\191\233\152\182"),
  T("\231\187\191\233\152\182"),
  T("\232\147\157\233\152\182"),
  T("\232\147\157\233\152\182"),
  T("\232\147\157\233\152\182"),
  T("\231\180\171\233\152\182"),
  T("\231\180\171\233\152\182"),
  T("\231\180\171\233\152\182"),
  T("\231\180\171\233\152\182"),
  T("\231\180\171\233\152\182"),
  T("\230\169\153\233\152\182"),
  T("\230\169\153\233\152\182"),
  T("\230\169\153\233\152\182"),
  T("\231\186\162\233\152\182"),
  T("\231\186\162\233\152\182")
}
skill_unlock_key_rank = {
  [2] = 2,
  [4] = 3,
  [7] = 4
}
equip_rank_info = {
  {
    name = T("\231\153\189\232\137\178"),
    font = "equip_white"
  },
  {
    name = T("\231\187\191\232\137\178"),
    font = "equip_green"
  },
  {
    name = T("\231\187\191\232\137\178+1"),
    font = "equip_green"
  },
  {
    name = T("\232\147\157\232\137\178"),
    font = "equip_blue"
  },
  {
    name = T("\232\147\157\232\137\178+1"),
    font = "equip_blue"
  },
  {
    name = T("\232\147\157\232\137\178+2"),
    font = "equip_blue"
  },
  {
    name = T("\231\180\171\232\137\178"),
    font = "equip_purple"
  },
  {
    name = T("\231\180\171\232\137\178+1"),
    font = "equip_purple"
  },
  {
    name = T("\231\180\171\232\137\178+2"),
    font = "equip_purple"
  },
  {
    name = T("\231\180\171\232\137\178+3"),
    font = "equip_purple"
  },
  {
    name = T("\231\180\171\232\137\178+4"),
    font = "equip_purple"
  },
  {
    name = T("\230\169\153\232\137\178"),
    font = "equip_orange"
  },
  {
    name = T("\230\169\153\232\137\178+1"),
    font = "equip_orange"
  },
  {
    name = T("\230\169\153\232\137\178+2"),
    font = "equip_orange"
  },
  {
    name = T("\231\186\162\232\137\178"),
    font = "equip_red"
  },
  {
    name = T("\231\186\162\232\137\178+1"),
    font = "equip_red"
  }
}
