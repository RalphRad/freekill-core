local skill = fk.CreateSkill {
  name = "qingguo",
}

skill:addEffect("viewas", nil, {
  anim_type = "defensive",
  pattern = "jink",
  prompt = "#qingguo",
  handly_pile = true,
  card_filter = function(self, player, to_select, selected)
    return #selected == 0 and Fk:getCardById(to_select).color == Card.Black and
      table.contains(player:getHandlyIds(), to_select)
  end,
  view_as = function(self, cards)
    if #cards ~= 1 then return end
    local c = Fk:cloneCard("jink")
    c.skillName = skill.name
    c:addSubcard(cards[1])
    return c
  end,
})

return skill
