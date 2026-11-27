EDDefineTable("fontconfigs")

local function toccc3(hex)
  return ccc3(hex / 65536, hex / 256 % 256, hex % 256)
end

guild_clash_battle_name = {
  color = toccc3(16776423),
  size = 16
}
pressButton = {
  size = 17,
  color = ccc3(255, 234, 198)
}
normalButton = {
  size = 17,
  color = ccc3(239, 197, 121)
}
pressButtonLittle = {
  size = 15,
  color = ccc3(255, 234, 198)
}
normalButtonLittle = {
  size = 15,
  color = ccc3(239, 197, 121)
}
ruleLabelNormal = {
  size = 16,
  color = ccc3(241, 193, 113)
}
main_icon_name = {
  size = 16,
  color = ccc3(255, 252, 231),
  strokeColor = ccc3(75, 57, 46),
  strokeSize = 1
}
guild_clash_name_self = {
  size = 16,
  color = toccc3(16776423),
  strokeColor = toccc3(6496031),
  strokeSize = 1
}
guild_clash_name_oppo = {
  size = 16,
  color = toccc3(16751724),
  strokeColor = toccc3(5380371),
  strokeSize = 1
}
guild_clash_self = {
  size = 13,
  color = toccc3(16776423),
  strokeColor = toccc3(6496031),
  strokeSize = 1
}
guild_clash_oppo = {
  size = 13,
  color = toccc3(16751724),
  strokeColor = toccc3(5380371),
  strokeSize = 1
}
main_name = {
  size = 16,
  color = ccc3(255, 238, 204)
}
tutorial_bubble = {
  size = 20,
  color = ccc3(253, 246, 143),
  strokeColor = ccc3(103, 47, 0),
  strokeSize = 1
}
tutorial_bubble2 = {
  size = 20,
  color = ccc3(253, 253, 253),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
tutorial_bubble3 = {
  size = 17,
  color = ccc3(253, 246, 143),
  strokeColor = ccc3(103, 47, 0),
  strokeSize = 1
}
smallest_normal_button = {
  size = 14,
  color = ccc3(235, 223, 207)
}
small_normal_button = {
  size = 16,
  color = ccc3(235, 223, 207)
}
normal_button = {
  size = 18,
  color = ccc3(235, 223, 207)
}
middle_normal_button = {
  size = 20,
  color = ccc3(235, 223, 207)
}
normal_button_stroke = {
  size = 18,
  color = ccc3(235, 223, 207),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
golden_button = {
  size = 18,
  color = ccc3(255, 204, 17)
}
dark_yellow = {
  size = 17,
  color = ccc3(238, 204, 119)
}
dark_yellow2 = {
  size = 16,
  color = ccc3(228, 176, 73),
  shadowColor = ccc3(50, 50, 50),
  shadowOffset = ccp(0, 2)
}
dark_white = {
  size = 17,
  color = ccc3(255, 255, 221)
}
dark_white1 = {
  size = 22,
  color = ccc3(255, 255, 221)
}
dark_white3 = {
  size = 18,
  color = ccc3(255, 255, 221)
}
dark_white4 = {
  size = 16,
  color = ccc3(255, 255, 221)
}
dark_white5 = {
  size = 15,
  color = ccc3(255, 255, 221)
}
dark_white_stroke = {
  size = 18,
  color = ccc3(255, 255, 221),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 1
}
dark_red = {
  size = 17,
  color = ccc3(255, 68, 0)
}
dark_greed = {
  size = 17,
  color = ccc3(170, 238, 17)
}
dark_pruple = {
  size = 17,
  color = ccc3(234, 92, 255)
}
blink_green = {
  size = 17,
  color = ccc3(68, 170, 68)
}
skill_white = {
  size = 16,
  color = ccc3(255, 255, 255)
}
skill_yellow = {
  size = 16,
  color = ccc3(231, 206, 19)
}
skill_yellow2 = {
  size = 17,
  color = ccc3(234, 225, 205)
}
skill_fashion = {
  size = 20,
  color = ccc3(238, 204, 119)
}
normal_black = {
  size = 18,
  color = ccc3(0, 0, 0)
}
normal_black_little = {
  size = 15,
  color = ccc3(0, 0, 0)
}
normal_coffee = {
  size = 15,
  color = ccc3(47, 36, 30)
}
dark_black = {
  size = 18,
  color = ccc3(65, 57, 54)
}
normal_red = {
  size = 18,
  color = ccc3(146, 0, 4)
}
big_normal_red = {
  size = 20,
  color = ccc3(146, 0, 4)
}
normal_red_little = {
  size = 15,
  color = ccc3(146, 0, 4)
}
title_yellow = {
  size = 18,
  color = ccc3(254, 211, 109)
}
title_while = {
  size = 15,
  color = ccc3(255, 252, 231),
  strokeColor = ccc3(36, 30, 23),
  strokeSize = 1
}
chat_pvp_link = {
  size = 15,
  color = ccc3(255, 245, 92),
  strokeColor = ccc3(85, 64, 39),
  strokeSize = 2
}
big_pvp_link = {
  size = 22,
  color = ccc3(255, 245, 92)
}
chat_title = {
  size = 18,
  color = ccc3(247, 228, 153),
  strokeColor = ccc3(169, 104, 27),
  strokeSize = 2
}
chat_quality_white = {
  size = 18,
  color = ccc3(219, 219, 219)
}
chat_quality_green = {
  size = 18,
  color = ccc3(119, 255, 92)
}
chat_quality_blue = {
  size = 18,
  color = ccc3(92, 219, 255)
}
chat_quality_pruple = {
  size = 18,
  color = ccc3(234, 92, 255)
}
chat_quality_orange = {
  size = 18,
  color = ccc3(255, 134, 92)
}
chat_input = {
  size = 20,
  color = ccc3(0, 0, 0)
}
chat_content = {
  size = 15,
  color = ccc3(255, 252, 231),
  strokeColor = ccc3(85, 64, 39),
  strokeSize = 1
}
chat_spell_content = {
  size = 15,
  color = ccc3(255, 255, 255),
  strokeColor = ccc3(85, 64, 39),
  strokeSize = 1
}
chat_content_highline_yellow = {
  size = 15,
  color = ccc3(255, 189, 130),
  strokeColor = ccc3(85, 64, 39),
  strokeSize = 1
}
chat_channel_active = {
  size = 15,
  color = ccc3(255, 254, 217),
  strokeColor = ccc3(82, 42, 18),
  strokeSize = 1
}
chat_channel_inactive = {
  size = 15,
  color = ccc3(195, 167, 122)
}
chat_private_top_content = {
  size = 15,
  color = ccc3(255, 252, 231)
}
chat_private_top_name = {
  size = 15,
  color = ccc3(236, 188, 111)
}
chat_name = {
  size = 12,
  color = ccc3(255, 252, 231)
}
chat_time = {
  size = 14,
  color = ccc3(191, 190, 184)
}
chat_level = {
  size = 12,
  color = ccc3(247, 228, 153),
  strokeColor = ccc3(169, 104, 27),
  strokeSize = 2
}
chat_suspension_white = {
  size = 18,
  color = ccc3(255, 252, 231)
}
chat_suspension_yellow = {
  size = 18,
  color = ccc3(232, 177, 82)
}
chat_online_green = {
  size = 12,
  color = ccc3(143, 214, 60),
  strokeColor = ccc3(14, 81, 24),
  strokeSize = 2
}
chat_online_grey = {
  size = 12,
  color = ccc3(194, 175, 159)
}
bl_tip_white = {
  size = 14,
  color = ccc3(254, 251, 232)
}
bl_tip_yellow = {
  size = 14,
  color = ccc3(251, 224, 71)
}
damage_white = {
  size = 18,
  color = ccc3(255, 252, 231),
  strokeColor = ccc3(57, 36, 21),
  strokeSize = 2
}
damage_green = {
  size = 18,
  color = ccc3(112, 255, 54),
  strokeColor = ccc3(23, 49, 31),
  strokeSize = 2
}
guild_join_tab_yellow = {
  size = 18,
  color = ccc3(250, 205, 16),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
guild_join_tab_white = {
  size = 18,
  color = ccc3(231, 231, 231)
}
guild_join_list_button = {
  size = 18,
  color = ccc3(234, 225, 205)
}
guild_join_list_guildname = {
  size = 18,
  color = ccc3(255, 252, 231),
  shadowColor = ccc3(85, 64, 39),
  shadowOffset = ccp(0, 2)
}
guild_join_list_guildpupulation = {
  size = 18,
  color = ccc3(138, 56, 1)
}
guild_join_list_description = {
  size = 18,
  color = ccc3(66, 58, 47)
}
guild_join_list_levelrequirement = {
  size = 18,
  color = ccc3(110, 102, 94)
}
guild_join_list_livenessrequirement = {
  size = 18,
  color = ccc3(70, 114, 0)
}
guild_create_words_yellow = {
  size = 18,
  color = ccc3(241, 193, 113)
}
guild_worship_title = {
  size = 18,
  color = ccc3(251, 206, 16)
}
guild_worship_exp_amount = {
  size = 20,
  color = ccc3(255, 255, 255),
  strokeColor = ccc3(74, 23, 0),
  strokeSize = 1
}
guild_worship_price_free = {
  size = 18,
  color = ccc3(255, 234, 198)
}
guild_worship_price_not_free = {
  size = 18,
  color = ccc3(255, 165, 49)
}
guild_hire_sent_hero_amount_title = {
  size = 18,
  color = ccc3(67, 59, 56)
}
guild_hire_sent_hero_amount_number = {
  size = 18,
  color = ccc3(138, 56, 1)
}
guild_hire_my_hero_income_number = {
  size = 18,
  color = ccc3(138, 91, 1)
}
guild_hire_my_hero_time = {
  size = 18,
  color = ccc3(169, 56, 28)
}
guild_send_hero_green = {
  size = 16,
  color = ccc3(160, 226, 25)
}
guild_player_title = {
  size = 16,
  color = ccc3(148, 26, 111)
}
guild_player_title_dark = {
  size = 16,
  color = ccc3(245, 84, 198)
}
op_act_title = {
  size = 18,
  color = ccc3(250, 205, 16),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
op_act_title1 = {
  size = 20,
  color = ccc3(250, 205, 16),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
op_act_grey = {
  size = 18,
  color = ccc3(53, 46, 48)
}
op_act_dark_blue = {
  size = 18,
  color = ccc3(0, 71, 187)
}
op_act_item_name = {
  size = 18,
  color = ccc3(131, 45, 0)
}
op_act_item_name1 = {
  size = 22,
  color = ccc3(131, 45, 0)
}
op_act_white = {
  size = 18,
  color = ccc3(252, 252, 252),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
big_op_act_white = {
  size = 20,
  color = ccc3(252, 252, 252),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
op_act_light_blue = {
  size = 18,
  color = ccc3(62, 226, 255),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
op_act_red = {
  size = 18,
  color = ccc3(138, 56, 1)
}
op_act_calendar_grey = {
  size = 18,
  color = ccc3(67, 59, 56)
}
op_act_calendar_red = {
  size = 18,
  color = ccc3(138, 56, 1)
}
dark_yellow1 = {
  size = 18,
  color = ccc3(238, 204, 119)
}
dark_white1 = {
  size = 18,
  color = ccc3(255, 255, 221)
}
dark_white2 = {
  size = 22,
  color = ccc3(255, 255, 221)
}
small_internal = {size = 3}
cd_em = {
  size = 20,
  color = ccc3(67, 59, 56),
  strokeColor = ccc3(198, 183, 221),
  strokeSize = 3
}
cd_equip = {
  size = 20,
  color = ccc3(67, 59, 56),
  strokeColor = ccc3(206, 168, 150),
  strokeSize = 3
}
team_index_1 = {
  size = 18,
  color = ccc3(254, 255, 128),
  strokeColor = ccc3(100, 75, 0),
  strokeSize = 2
}
team_index_2 = {
  size = 18,
  color = ccc3(168, 255, 250),
  strokeColor = ccc3(0, 77, 99),
  strokeSize = 2
}
team_index_3 = {
  size = 18,
  color = ccc3(255, 193, 222),
  strokeColor = ccc3(110, 4, 64),
  strokeSize = 2
}
team_unselected = {
  size = 18,
  color = ccc3(196, 187, 170),
  strokeColor = ccc3(100, 75, 0),
  strokeSize = 2
}
battle_round = {
  size = 20,
  color = ccc3(255, 255, 255),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
buff_stack = {
  size = 22,
  color = ccc3(255, 255, 255),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 3
}
equip_white = {
  size = 18,
  color = ccc3(255, 255, 255)
}
equip_green = {
  size = 18,
  color = ccc3(119, 255, 92)
}
equip_blue = {
  size = 18,
  color = ccc3(81, 224, 251)
}
equip_purple = {
  size = 18,
  color = ccc3(234, 92, 255)
}
equip_orange = {
  size = 18,
  color = ccc3(255, 134, 92)
}
equip_red = {
  size = 18,
  color = ccc3(195, 72, 68)
}
item_count = {
  size = 16,
  color = ccc3(255, 252, 231),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 1.5
}
dreamland_info = {
  size = 14,
  color = ccc3(228, 255, 220),
  strokeColor = ccc3(15, 30, 17),
  strokeSize = 1
}
damage_up_hint = {
  size = 17,
  color = ccc3(166, 235, 31)
}
dreamland_ranklist_damage = {
  size = 15,
  color = ccc3(255, 255, 255),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
dreamland_white = {
  size = 16,
  color = ccc3(255, 255, 255),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 1.5
}
dreamland_red = {
  size = 15,
  color = ccc3(253, 81, 81)
}
dreamland_label = {
  size = 18,
  color = ccc3(255, 255, 255),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 1
}
red_bag_act_red = {
  size = 18,
  color = ccc3(255, 164, 77)
}
real_arena_level = {
  size = 30,
  color = ccc3(234, 225, 205),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 1
}
real_arena_name = {
  size = 28,
  color = ccc3(234, 225, 205),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
real_arena_hint = {
  size = 22,
  color = ccc3(234, 225, 205),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
real_arena_green = {
  size = 22,
  color = ccc3(160, 226, 25),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
real_arena_red = {
  size = 22,
  color = ccc3(138, 56, 1),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
challenge_head = {
  size = 20,
  color = ccc3(255, 217, 10),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
friends_money = {
  size = 18,
  color = ccc3(67, 59, 56)
}
gcw_red = {
  size = 18,
  color = ccc3(195, 72, 68)
}
gcw_green = {
  size = 18,
  color = ccc3(57, 165, 14)
}
gcw_blue = {
  size = 18,
  color = ccc3(92, 219, 255)
}
gcw_yellow = {
  size = 18,
  color = ccc3(225, 201, 100)
}
gcw_purple = {
  size = 18,
  color = ccc3(152, 87, 157)
}
gcw_hint_yellow = {
  size = 18,
  color = ccc3(239, 197, 121),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
gcw_hint_white = {
  size = 18,
  color = ccc3(255, 255, 255),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
gcw_team_count_red = {
  size = 18,
  color = ccc3(195, 72, 68),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
gcw_team_count_green = {
  size = 18,
  color = ccc3(57, 165, 14),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
gcw_team_count_blue = {
  size = 18,
  color = ccc3(92, 219, 255),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
gcw_team_count_yellow = {
  size = 18,
  color = ccc3(225, 201, 100),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
gcw_team_count_purple = {
  size = 18,
  color = ccc3(152, 87, 157),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
task_white = {
  size = 18,
  color = ccc3(255, 255, 255),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
task_black = {
  size = 16,
  color = ccc3(65, 57, 54)
}
task_green = {
  size = 16,
  color = ccc3(70, 114, 0),
  shadowColor = ccc3(255, 255, 255),
  shadowOffset = ccp(0, 2)
}
task_yellow = {
  size = 18,
  color = ccc3(225, 201, 100),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
task_title = {
  size = 16,
  color = ccc3(138, 56, 1),
  shadowColor = ccc3(255, 255, 255),
  shadowOffset = ccp(0, 2)
}
task_reward = {
  size = 18,
  color = ccc3(182, 65, 21)
}
task_money = {
  size = 24,
  color = ccc3(255, 255, 221),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 3
}
heroTask_white = {
  size = 20,
  color = ccc3(255, 255, 255),
  shadowColor = ccc3(145, 113, 54),
  shadowOffset = ccp(0, 2)
}
login_black = {
  size = 18,
  color = ccc3(51, 51, 51)
}
key_yellow = {
  size = 15,
  color = ccc3(255, 151, 70)
}
key_black = {
  size = 15,
  color = ccc3(67, 59, 56)
}
master_red = {
  size = 16,
  color = ccc3(143, 30, 0)
}
master_red2 = {
  size = 18,
  color = ccc3(143, 30, 0)
}
master_black = {
  size = 16,
  color = ccc3(67, 59, 56)
}
master_black2 = {
  size = 18,
  color = ccc3(67, 59, 56)
}
magic_white1 = {
  size = 18,
  color = ccc3(255, 255, 221)
}
multiplayer_playername = {
  size = 20,
  color = ccc3(255, 255, 255),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
multiplayer_playergst = {
  size = 18,
  color = ccc3(67, 59, 56)
}
multiplayer_playergs = {
  size = 18,
  color = ccc3(182, 65, 21)
}
multiplayer_white2 = {
  size = 20,
  color = ccc3(241, 193, 113)
}
multiplayer_blcak = {
  size = 20,
  color = ccc3(112, 103, 94)
}
multiplayer_red = {
  size = 20,
  color = ccc3(255, 34, 34)
}
offlinequest_red = {
  size = 18,
  color = ccc3(165, 68, 47)
}
offlinequest_red2 = {
  size = 18,
  color = ccc3(255, 34, 34)
}
offlinequest_green = {
  size = 18,
  color = ccc3(119, 255, 92)
}
offlinequest_orange = {
  size = 18,
  color = ccc3(255, 151, 71)
}
offlinequest_white1 = {
  size = 18,
  color = ccc3(255, 234, 198)
}
offlinequest_white2 = {
  size = 18,
  color = ccc3(241, 193, 113)
}
offlinequest_black = {
  size = 18,
  color = ccc3(67, 59, 56)
}
multi_arena_title = {
  size = 20,
  color = ccc3(250, 205, 16),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
multi_arena_name_blue = {
  size = 18,
  color = ccc3(22, 252, 254),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
multi_arena_name_red = {
  size = 18,
  color = ccc3(234, 92, 254),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
herorecommend_white = {
  size = 18,
  color = ccc3(255, 234, 198)
}
herorecommend_orange = {
  size = 18,
  color = ccc3(251, 206, 16),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
herorecommend_red = {
  size = 18,
  color = ccc3(182, 65, 21),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
multistage_white = {
  size = 18,
  color = ccc3(255, 234, 198),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
multistage_orange = {
  size = 18,
  color = ccc3(251, 206, 16),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 2)
}
battle_reply_white = {
  size = 20,
  color = ccc3(255, 252, 231),
  strokeColor = ccc3(25, 9, 1),
  strokeSize = 2
}
battle_reply_yellow = {
  size = 20,
  color = ccc3(255, 165, 49),
  strokeColor = ccc3(40, 28, 18),
  strokeSize = 2
}
videoplayer_white = {
  size = 20,
  color = ccc3(255, 255, 255)
}
videoplayer_yellow = {
  size = 20,
  color = ccc3(251, 206, 16)
}
pet_white = {
  size = 18,
  color = ccc3(255, 234, 198)
}
cuparena_coffee = {
  size = 18,
  color = ccc3(255, 199, 136)
}
cuparena_yellow = {
  size = 18,
  color = ccc3(242, 77, 41)
}
cuparena_white = {
  size = 16,
  color = ccc3(255, 255, 255)
}
cuparena_green = {
  size = 16,
  color = ccc3(119, 255, 92)
}
recharge_normal = {
  size = 14,
  color = ccc3(255, 255, 255)
}
recharge_green = {
  size = 14,
  color = ccc3(119, 255, 92)
}
recharge_yellow = {
  size = 14,
  color = ccc3(231, 206, 19)
}
recharge_brown = {
  size = 14,
  color = ccc3(133, 49, 2)
}
recharge_normal_small = {
  size = 11,
  color = ccc3(255, 255, 255)
}
recharge_green_small = {
  size = 11,
  color = ccc3(119, 255, 92)
}
camp_normal = {
  size = 14,
  color = ccc3(240, 226, 203)
}
camp_red = {
  size = 14,
  color = ccc3(255, 101, 103)
}
camp_white = {
  size = 14,
  color = ccc3(245, 245, 245)
}
camp_orange = {
  size = 14,
  color = ccc3(248, 197, 116)
}
camp_yellow = {
  size = 14,
  color = ccc3(255, 239, 23)
}
guildmount_normal = {
  size = 15,
  color = ccc3(240, 226, 203)
}
guildmount_red = {
  size = 15,
  color = ccc3(255, 101, 103)
}
guildmount_white = {
  size = 15,
  color = ccc3(245, 245, 245)
}
guildmount_orange = {
  size = 15,
  color = ccc3(248, 197, 116)
}
guildmount_yellow = {
  size = 15,
  color = ccc3(255, 239, 23)
}
battleprepare_title = {
  size = 16,
  color = ccc3(255, 254, 233),
  strokeColor = ccc3(0, 0, 0),
  strokeSize = 2
}
wishlist_font_style = {
  size = 15,
  color = ccc3(255, 230, 154),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 3)
}
wishlist_font_yellow_style = {
  size = 15,
  color = ccc3(255, 230, 154),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 3)
}
wishlist_font_green_style = {
  size = 15,
  color = ccc3(112, 255, 84),
  shadowColor = ccc3(0, 0, 0),
  shadowOffset = ccp(0, 3)
}
daily_time = {
  size = 14,
  color = ccc3(58, 35, 31)
}
daily_time_green = {
  size = 14,
  color = ccc3(9, 255, 1)
}
hint_text = {
  size = 15,
  color = ccc3(255, 252, 231),
  strokeColor = ccc3(85, 64, 39),
  strokeSize = 1
}
equipstrengthen = {
  size = 15,
  color = ccc3(254, 211, 109),
  strokeColor = ccc3(57, 36, 21),
  strokeSize = 1
}
arenags1 = {
  size = 14,
  color = ccc3(255, 253, 125),
  strokeColor = ccc3(85, 64, 39),
  strokeSize = 1
}
arenags2 = {
  size = 14,
  color = ccc3(255, 252, 231),
  strokeColor = ccc3(85, 64, 39),
  strokeSize = 1
}
skill_apup = {
  size = 16,
  color = ccc3(88, 140, 248),
  strokeSize = 1
}
skillstep_unlock = {
  size = 16,
  color = ccc3(143, 143, 143),
  strokeSize = 1
}
skill_unlocklevel = {
  size = 16,
  color = ccc3(255, 108, 108),
  strokeSize = 1
}
fun_open_green = {}
chat_entrance = {
  size = 14,
  color = ccc3(255, 252, 231)
}
chatEntranceMsgName = {
  size = 14,
  color = ccc3(245, 221, 183)
}
guildRankTxt = {
  size = 15,
  color = ccc3(255, 252, 231)
}
guildRankTxtYellow = {
  size = 15,
  color = ccc3(254, 211, 109)
}
guildRankTxtOrange = {
  size = 15,
  color = ccc3(255, 165, 49)
}
chat_tag_world = {
  size = 12,
  color = ccc3(189, 246, 255)
}
chat_tag_guild = {
  size = 12,
  color = ccc3(119, 255, 91)
}
