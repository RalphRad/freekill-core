-- SPDX-License-Identifier: GPL-3.0-or-later

local extension = Package:new("maneuvering", Package.CardPack)

local slash = Fk:cloneCard("slash")

Fk:addDamageNature(fk.FireDamage, "fire_damage")
Fk:addDamageNature(fk.ThunderDamage, "thunder_damage")

local thunderSlashSkill = fk.CreateActiveSkill{
  name = "thunder__slash_skill",
  prompt = function(self, selected_cards)
    local card = Fk:cloneCard("thunder__slash")
    card:addSubcards(selected_cards)
    local max_num = self:getMaxTargetNum(Self, card)
    if max_num > 1 then
      local num = #table.filter(Fk:currentRoom().alive_players, function (p)
        return p ~= Self and not Self:isProhibited(p, card)
      end)
      max_num = math.min(num, max_num)
    end
    return max_num > 1 and "#thunder__slash_skill_multi:::" .. max_num or "#thunder__slash_skill"
  end,
  max_phase_use_time = 1,
  target_num = 1,
  on_effect = function(self, room, effect)
    local to = effect.to
    local from = effect.from

    room:damage({
      from = room:getPlayerById(from),
      to = room:getPlayerById(to),
      card = effect.card,
      damage = 1,
      damageType = fk.ThunderDamage,
      skillName = self.name
    })
  end
}
thunderSlashSkill.canUse = slash.skill.canUse
thunderSlashSkill.modTargetFilter = slash.skill.modTargetFilter
thunderSlashSkill.targetFilter = slash.skill.targetFilter
local thunderSlash = fk.CreateBasicCard{
  name = "thunder__slash",
  skill = thunderSlashSkill,
  is_damage_card = true,
}

extension:addCards{
  thunderSlash:clone(Card.Club, 5),
  thunderSlash:clone(Card.Club, 6),
  thunderSlash:clone(Card.Club, 7),
  thunderSlash:clone(Card.Club, 8),
  thunderSlash:clone(Card.Spade, 4),
  thunderSlash:clone(Card.Spade, 5),
  thunderSlash:clone(Card.Spade, 6),
  thunderSlash:clone(Card.Spade, 7),
  thunderSlash:clone(Card.Spade, 8),
}

local fireSlashSkill = fk.CreateActiveSkill{
  name = "fire__slash_skill",
  prompt = function(self, selected_cards)
    local card = Fk:cloneCard("fire__slash")
    card:addSubcards(selected_cards)
    local max_num = self:getMaxTargetNum(Self, card)
    if max_num > 1 then
      local num = #table.filter(Fk:currentRoom().alive_players, function (p)
        return p ~= Self and not Self:isProhibited(p, card)
      end)
      max_num = math.min(num, max_num)
    end
    return max_num > 1 and "#fire__slash_skill_multi:::" .. max_num or "#fire__slash_skill"
  end,
  max_phase_use_time = 1,
  target_num = 1,
  on_effect = function(self, room, effect)
    local to = effect.to
    local from = effect.from

    room:damage({
      from = room:getPlayerById(from),
      to = room:getPlayerById(to),
      card = effect.card,
      damage = 1,
      damageType = fk.FireDamage,
      skillName = self.name
    })
  end
}
fireSlashSkill.canUse = slash.skill.canUse
fireSlashSkill.modTargetFilter = slash.skill.modTargetFilter
fireSlashSkill.targetFilter = slash.skill.targetFilter
local fireSlash = fk.CreateBasicCard{
  name = "fire__slash",
  skill = fireSlashSkill,
  is_damage_card = true,
}

extension:addCards{
  fireSlash:clone(Card.Heart, 4),
  fireSlash:clone(Card.Heart, 7),
  fireSlash:clone(Card.Heart, 10),
  fireSlash:clone(Card.Diamond, 4),
  fireSlash:clone(Card.Diamond, 5),
}

local analepticSkill = fk.CreateActiveSkill{
  name = "analeptic_skill",
  prompt = "#analeptic_skill",
  max_turn_use_time = 1,
  mod_target_filter = function (self, to_select, selected, player, card, distance_limited)
    return true
  end,
  can_use = function(self, player, card, extra_data)
    return not player:isProhibited(player, card) and ((extra_data and (extra_data.bypass_times or extra_data.analepticRecover)) or
      self:withinTimesLimit(player, Player.HistoryTurn, card, "analeptic", player))
  end,
  on_use = function(_, _, use)
    if not use.tos or #TargetGroup:getRealTargets(use.tos) == 0 then
      use.tos = { { use.from } }
    end

    if use.extra_data and use.extra_data.analepticRecover then
      use.extraUse = true
    end
  end,
  on_effect = function(_, room, effect)
    local to = room:getPlayerById(effect.to)
    if effect.extra_data and effect.extra_data.analepticRecover then
      room:recover({
        who = to,
        num = 1,
        recoverBy = room:getPlayerById(effect.from),
        card = effect.card,
      })
    else
      to.drank = to.drank + 1 + ((effect.extra_data or {}).additionalDrank or 0)
      room:broadcastProperty(to, "drank")
    end
  end
}

local analepticEffect = fk.CreateTriggerSkill{
  name = "analeptic_effect",
  global = true,
  priority = 0, -- game rule
  events = { fk.PreCardUse, fk.AfterTurnEnd },
  can_trigger = function(_, event, target, player, data)
    if target ~= player then
      return false
    end

    if event == fk.PreCardUse then
      return data.card.trueName == "slash" and player.drank > 0
    else
      return true
    end
  end,
  on_trigger = function(_, event, _, player, data)
    local room = player.room
    if event == fk.PreCardUse then
      data.additionalDamage = (data.additionalDamage or 0) + player.drank
      data.extra_data = data.extra_data or {}
      data.extra_data.drankBuff = player.drank
      player.drank = 0
      room:broadcastProperty(player, "drank")
    else
      for _, p in ipairs(room:getAlivePlayers(true)) do
        if p.drank > 0 then
          p.drank = 0
          room:broadcastProperty(p, "drank")
        end
      end
    end
  end,
}
Fk:addSkill(analepticEffect)

local analeptic = fk.CreateBasicCard{
  name = "analeptic",
  suit = Card.Spade,
  number = 3,
  skill = analepticSkill,
}

extension:addCards({
  analeptic,
  analeptic:clone(Card.Spade, 9),
  analeptic:clone(Card.Club, 3),
  analeptic:clone(Card.Club, 9),
  analeptic:clone(Card.Diamond, 9),
})

local recast = fk.CreateActiveSkill{
  name = "recast",
  prompt = "#recast",
  target_num = 0,
  on_use = function(_, room, effect)
    room:recastCard(effect.cards, room:getPlayerById(effect.from))
  end
}
recast.cardSkill = true
Fk:addSkill(recast)

local ironChainCardSkill = fk.CreateActiveSkill{
  name = "iron_chain_skill",
  prompt = "#iron_chain_skill",
  can_use = Util.CanUse,
  min_target_num = 1,
  max_target_num = 2,
  mod_target_filter = Util.TrueFunc,
  target_filter = Util.TargetFilter,
  on_effect = function(_, room, cardEffectEvent)
    local to = room:getPlayerById(cardEffectEvent.to)
    to:setChainState(not to.chained)
  end,
}

local ironChain = fk.CreateTrickCard{
  name = "iron_chain",
  skill = ironChainCardSkill,
  special_skills = { "recast" },
  multiple_targets = true,
}
extension:addCards{
  ironChain:clone(Card.Spade, 11),
  ironChain:clone(Card.Spade, 12),
  ironChain:clone(Card.Club, 10),
  ironChain:clone(Card.Club, 11),
  ironChain:clone(Card.Club, 12),
  ironChain:clone(Card.Club, 13),
}

local fireAttackSkill = fk.CreateActiveSkill{
  name = "fire_attack_skill",
  prompt = "#fire_attack_skill",
  can_use = Util.CanUse,
  target_num = 1,
  mod_target_filter = function(_, to_select, _, _, _, _)
    local to = Fk:currentRoom():getPlayerById(to_select)
    return not to:isKongcheng()
  end,
  target_filter = Util.TargetFilter,
  on_effect = function(self, room, cardEffectEvent)
    local from = room:getPlayerById(cardEffectEvent.from)
    local to = room:getPlayerById(cardEffectEvent.to)
    if to:isKongcheng() then return end

    local showCard = room:askForCard(to, 1, 1, false, self.name, false, ".|.|.|hand", "#fire_attack-show:" .. from.id)[1]
    to:showCards(showCard)

    showCard = Fk:getCardById(showCard)
    local cards = room:askForDiscard(from, 1, 1, false, self.name, true,
      ".|.|" .. showCard:getSuitString(), "#fire_attack-discard:" .. to.id .. "::" .. showCard:getSuitString())
    if #cards > 0 then
      room:damage({
        from = from,
        to = to,
        card = cardEffectEvent.card,
        damage = 1,
        damageType = fk.FireDamage,
        skillName = self.name
      })
    end
  end,
}
local fireAttack = fk.CreateTrickCard{
  name = "fire_attack",
  skill = fireAttackSkill,
  is_damage_card = true,
}
extension:addCards{
  fireAttack:clone(Card.Heart, 2),
  fireAttack:clone(Card.Heart, 3),
  fireAttack:clone(Card.Diamond, 12),
}

local supplyShortageSkill = fk.CreateActiveSkill{
  name = "supply_shortage_skill",
  prompt = "#supply_shortage_skill",
  can_use = Util.CanUse,
  distance_limit = 1,
  mod_target_filter = function(self, to_select, _, player, card, distance_limited)
    local target = Fk:currentRoom():getPlayerById(to_select)
    return target ~= player and not (distance_limited and not self:withinDistanceLimit(player, false, card, target))
  end,
  target_filter = Util.TargetFilter,
  target_num = 1,
  on_effect = function(self, room, effect)
    local to = room:getPlayerById(effect.to)
    local judge = {
      who = to,
      reason = "supply_shortage",
      pattern = ".|.|spade,heart,diamond",
    }
    room:judge(judge)
    local result = judge.card
    if result.suit ~= Card.Club then
      to:skip(Player.Draw)
    end
    self:onNullified(room, effect)
  end,
  on_nullified = function(self, room, effect)
    room:moveCards{
      ids = room:getSubcardsByRule(effect.card, { Card.Processing }),
      toArea = Card.DiscardPile,
      moveReason = fk.ReasonUse
    }
  end,
}
local supplyShortage = fk.CreateDelayedTrickCard{
  name = "supply_shortage",
  skill = supplyShortageSkill,
}
extension:addCards{
  supplyShortage:clone(Card.Spade, 10),
  supplyShortage:clone(Card.Club, 4),
}

local gudingSkill = fk.CreateTriggerSkill{
  name = "#guding_blade_skill",
  attached_equip = "guding_blade",
  frequency = Skill.Compulsory,
  events = {fk.DamageCaused},
  can_trigger = function(self, _, target, player, data)
    local logic = player.room.logic
    if target == player and player:hasSkill(self) and
    data.to:isKongcheng() and data.card and data.card.trueName == "slash" then
      return data.by_user
    end
  end,
  on_use = function(_, _, _, _, data)
    data.damage = data.damage + 1
  end,
}
Fk:addSkill(gudingSkill)
local gudingBlade = fk.CreateWeapon{
  name = "guding_blade",
  suit = Card.Spade,
  number = 1,
  attack_range = 2,
  equip_skill = gudingSkill,
}

extension:addCard(gudingBlade)

local fanSkill = fk.CreateTriggerSkill{
  name = "#fan_skill",
  attached_equip = "fan",
  events = { fk.AfterCardUseDeclared },
  can_trigger = function(self, _, target, player, data)
    return target == player and player:hasSkill(self) and data.card.name == "slash"
  end,
  on_use = function(_, _, _, _, data)
    local card = Fk:cloneCard("fire__slash", data.card.suit, data.card.number)
    for k, v in pairs(data.card) do
      if card[k] == nil then
        card[k] = v
      end
    end
    if data.card:isVirtual() then
      card.subcards = data.card.subcards
    else
      card.id = data.card.id
    end
    card.skillNames = data.card.skillNames
    card.skillName = "fan"
    data.card = card
  end,
}
Fk:addSkill(fanSkill)
local fan = fk.CreateWeapon{
  name = "fan",
  suit = Card.Diamond,
  number = 1,
  attack_range = 4,
  equip_skill = fanSkill,
}

extension:addCard(fan)

local vineSkill = fk.CreateTriggerSkill{
  name = "#vine_skill",
  attached_equip = "vine",
  mute = true,
  frequency = Skill.Compulsory,

  events = {fk.PreCardEffect, fk.DamageInflicted},
  can_trigger = function(self, event, target, player, data)
    if event == fk.DamageInflicted then
      return target == player and player:hasSkill(self) and
        data.damageType == fk.FireDamage
    end
    local effect = data ---@type CardEffectEvent
    return player.id == effect.to and player:hasSkill(self) and
      (effect.card.name == "slash" or effect.card.name == "savage_assault" or
      effect.card.name == "archery_attack")
  end,
  on_use = function(self, event, _, player, data)
    local room = player.room
    room:sendLog{
      type = "#InvokeSkill",
      from = player.id,
      arg = self.name,
    }
    if event == fk.DamageInflicted then
      room:broadcastPlaySound("./packages/maneuvering/audio/card/vineburn")
      room:setEmotion(player, "./packages/maneuvering/image/anim/vineburn")
      data.damage = data.damage + 1
    else
      room:broadcastPlaySound("./packages/maneuvering/audio/card/vine")
      room:setEmotion(player, "./packages/maneuvering/image/anim/vine")
      return true
    end
  end,
}
Fk:addSkill(vineSkill)
local vine = fk.CreateArmor{
  name = "vine",
  equip_skill = vineSkill,
}
extension:addCards{
  vine:clone(Card.Spade, 2),
  vine:clone(Card.Club, 2),
}

local silverLionSkill = fk.CreateTriggerSkill{
  name = "#silver_lion_skill",
  attached_equip = "silver_lion",
  frequency = Skill.Compulsory,
  events = {fk.DamageInflicted, fk.AfterCardsMove},
  can_trigger = function(self, event, target, player, data)
    if event == fk.DamageInflicted then
      return target == player and player:hasSkill(self) and data.damage > 1
    else
      if player.dead or not player:isWounded() then return false end
      for _, move in ipairs(data) do
        if move.from == player.id then
          for _, info in ipairs(move.moveInfo) do
            if info.fromArea == Card.PlayerEquip and Fk:getCardById(info.cardId).name == self.attached_equip then
              return self:isEffectable(player)
            end
          end
        end
      end
    end
  end,
  on_use = function(self, event, _, player, data)
    if event == fk.DamageInflicted then
      data.damage = 1
    else
      local room = player.room
      room:recover({
        who = player,
        num = 1,
        recoverBy = player,
        skillName = self.name
      })
    end
  end,
}
Fk:addSkill(silverLionSkill)
local silverLion = fk.CreateArmor{
  name = "silver_lion",
  suit = Card.Club,
  number = 1,
  equip_skill = silverLionSkill,
}
extension:addCard(silverLion)

local hualiuSkill = fk.CreateDistanceSkill{
  name = "#hualiu_skill",
  attached_equip = "hualiu",
  correct_func = function(self, from, to)
    if to:hasSkill(self) then
      return 1
    end
  end,
}
Fk:addSkill(hualiuSkill)
local huaLiu = fk.CreateDefensiveRide{
  name = "hualiu",
  suit = Card.Diamond,
  number = 13,
  equip_skill = hualiuSkill,
}

extension:addCards({
  huaLiu,
})

extension:addCards{
  Fk:cloneCard("jink", Card.Heart, 8),
  Fk:cloneCard("jink", Card.Heart, 9),
  Fk:cloneCard("jink", Card.Heart, 11),
  Fk:cloneCard("jink", Card.Heart, 12),
  Fk:cloneCard("jink", Card.Diamond, 6),
  Fk:cloneCard("jink", Card.Diamond, 7),
  Fk:cloneCard("jink", Card.Diamond, 8),
  Fk:cloneCard("jink", Card.Diamond, 10),
  Fk:cloneCard("jink", Card.Diamond, 11),

  Fk:cloneCard("peach", Card.Heart, 5),
  Fk:cloneCard("peach", Card.Heart, 6),
  Fk:cloneCard("peach", Card.Diamond, 2),
  Fk:cloneCard("peach", Card.Diamond, 3),

  Fk:cloneCard("nullification", Card.Heart, 1),
  Fk:cloneCard("nullification", Card.Heart, 13),
  Fk:cloneCard("nullification", Card.Spade, 13),
}

Fk:loadTranslationTable{
  ["maneuvering"] = "军争",

  ["thunder__slash"] = "雷杀",
  [":thunder__slash"] = "基本牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：攻击范围内的一名角色<br /><b>效果</b>：对目标角色造成1点雷电伤害。",
  ["#thunder__slash_skill"] = "选择攻击范围内的一名角色，对其造成1点雷电伤害",
  ["#thunder__slash_skill_multi"] = "选择攻击范围内的至多%arg名角色，对这些角色各造成1点雷电伤害",

  ["fire__slash"] = "火杀",
  [":fire__slash"] = "基本牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：攻击范围内的一名角色<br /><b>效果</b>：对目标角色造成1点火焰伤害。",
  ["#fire__slash_skill"] = "选择攻击范围内的一名角色，对其造成1点火焰伤害",
  ["#fire__slash_skill_multi"] = "选择攻击范围内的至多%arg名角色，对这些角色各造成1点火焰伤害",

  ["analeptic"] = "酒",
  [":analeptic"] = "基本牌<br /><b>时机</b>：出牌阶段/你处于濒死状态时<br /><b>目标</b>：你<br /><b>效果</b>：目标角色本回合使用的下一张【杀】将要造成的伤害+1/目标角色回复1点体力。",
  ["#analeptic_skill"] = "你于此回合内使用的下一张【杀】的伤害值基数+1",

  ["iron_chain"] = "铁锁连环",
  [":iron_chain"] = "锦囊牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：一至两名角色<br /><b>效果</b>：横置或重置目标角色的武将牌。",
  ["#iron_chain_skill"] = "选择一至两名角色，这些角色横置或重置",
  ["_normal_use"] = "正常使用",
  ["recast"] = "重铸",
  [":recast"] = "你可以将此牌置入弃牌堆，然后摸一张牌。",
  ["#recast"] = "将此牌置入弃牌堆，然后摸一张牌",

  ["fire_attack"] = "火攻",
  ["fire_attack_skill"] = "火攻",
  [":fire_attack"] = "锦囊牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：一名有手牌的角色<br /><b>效果</b>：目标角色展示一张手牌，然后你可以弃置一张与此牌花色相同的手牌对其造成1点火焰伤害。",
  ["#fire_attack-show"] = "%src 对你使用了火攻，请展示一张手牌",
  ["#fire_attack-discard"] = "你可弃置一张 %arg 手牌，对 %src 造成1点火属性伤害",
  ["#fire_attack_skill"] = "选择一名有手牌的角色，令其展示一张手牌，<br />然后你可以弃置一张与此牌花色相同的手牌对其造成1点火焰伤害",

  ["supply_shortage"] = "兵粮寸断",
  [":supply_shortage"] = "延时锦囊牌<br /><b>时机</b>：出牌阶段<br /><b>目标</b>：距离1的一名其他角色<br /><b>效果</b>：将此牌置于目标角色判定区内。其判定阶段进行判定：若结果不为♣，其跳过摸牌阶段。然后将【兵粮寸断】置入弃牌堆。",
  ["#supply_shortage_skill"] = "选择距离1的一名角色，将此牌置于其判定区内。其判定阶段判定：<br />若结果不为♣，其跳过摸牌阶段",

  ["guding_blade"] = "古锭刀",
  [":guding_blade"] = "装备牌·武器<br /><b>攻击范围</b>：２<br /><b>武器技能</b>：锁定技。每当你使用【杀】对目标角色造成伤害时，若该角色没有手牌，此伤害+1。",
  ["#guding_blade_skill"] = "古锭刀",

  ["fan"] = "朱雀羽扇",
  [":fan"] = "装备牌·武器<br /><b>攻击范围</b>：４<br /><b>武器技能</b>：当你声明使用普【杀】后，你可以将此【杀】改为火【杀】。",
  ["#fan_skill"] = "朱雀羽扇",

  ["vine"] = "藤甲",
  [":vine"] = "装备牌·防具<br /><b>防具技能</b>：锁定技。【南蛮入侵】、【万箭齐发】和普通【杀】对你无效。每当你受到火焰伤害时，此伤害+1。",
  ["#vine_skill"] = "藤甲",

  ["silver_lion"] = "白银狮子",
  [":silver_lion"] = "装备牌·防具<br /><b>防具技能</b>：锁定技。每当你受到伤害时，若此伤害大于1点，防止多余的伤害。每当你失去装备区里的【白银狮子】后，你回复1点体力。",
  ["#silver_lion_skill"] = "白银狮子",

  ["hualiu"] = "骅骝",
  [":hualiu"] = "装备牌·坐骑<br /><b>坐骑技能</b>：其他角色与你的距离+1。",
}

local pkgprefix = "packages/"
if UsingNewCore then pkgprefix = "packages/freekill-core/" end
Fk:loadTranslationTable(require(pkgprefix .. 'maneuvering/i18n/en_US'), 'en_US')
Fk:loadTranslationTable(require(pkgprefix .. 'maneuvering/i18n/vi_VN'), 'vi_VN')

return extension
