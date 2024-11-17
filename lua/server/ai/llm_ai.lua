-- 基于大语言模型的AI策略
-- 真的能行吗？不过这不是挺有意思么，试试看吧
-- 在我的设想中这个需要多进程才可实现，freekill这边只负责产出prompt
-- 中间的进程负责将prompt交给LLM，然后将回答返回freekill
-- 至于使用何种LLM、制定何种system prompt就全看他自己了
-- 我也会在同一个文件夹内用python写一个访问ollama的中间程序以便实验

-- 如果能行的话，这个AI也没法推广，毕竟目标写着“所有设备可用”，所以还是得整手搓策略的SmartAI
-- 但是LLMAI也很酷就是了

---@class LLMAI: SmartAI
local LLMAI = AI:subclass("LLMAI")

-- system prompt中应该说明基本游戏规则
-- prompt中应该要说明房间内的情况、玩家此时要完成的事情
-- 此外还要说明场内所有玩家可见的卡牌/技能的描述信息
-- 最后，还要说明答复的格式
--
-- 下面是试着设计的prompt 估计也不好用

local system_prompt = [[
  You are a San Guo Sha (card game) player. Your mission is to get prompt
  of operation request (such as ask you to use a card) and make reply.
  Don't show steps of your thinking, just tell me the answer.

  In the game situation JSON, the key "circle" indicates the seat order of all
  players; and player["player_cards"] consists of 3 arrays, they are hand cards,
  equipment cards and delayed trick cards, respectively.

  You will receive prompt that contains information of the whole game (in JSON),
  data of current request, and required reply format.

]]

-- 分别对应json, json, json, int, 描述
local prompt_body = [[
  Current situation of the game:
  %s

  Data of this request:
  %s

  Description of card and skills:
  %s

  You are player #%d

  Your reply format is:
  %s

  Extra data:
  %s

  Please make your decision.
]]

-- 按理说可以直接用这个重连信息喂给LLM，但是完全可以精简
function LLMAI:getSituationOfGame()
  local obj = self.room:toJsonObject(self.player)
  obj.settings = nil
  local desc_obj = {}
  for _, p in pairs(obj.players) do
    p.setup_data = nil
    for _, skill in ipairs(p.skills) do
      if not desc_obj[skill] then
        desc_obj[skill] = Fk:translate(":" .. skill)
      end
    end
    for _, cards in ipairs(p.player_cards) do
      for _, cid in ipairs(cards) do
        local c = Fk:getCardById(cid)
        desc_obj[tostring(cid)] = Fk:translate(c.name) .. "\n" .. Fk:translate(":" .. c.name)
      end
    end
  end
  return obj, desc_obj
end

function LLMAI:buildPrompt(replyFormat, extra)
  local obj, desc_obj = self:getSituationOfGame()
  return system_prompt .. prompt_body:format(
    json.encode(obj),
    json.encode(self.data),
    json.encode(desc_obj),
    self.player.id,
    replyFormat,
    extra
  )
end

-- 发出信息并等待LLM答复。
-- 因为不知道哪里规定了只有delay和玩家的思考才可使用异步等待，所以这里只能阻塞
---@param prompt string
function LLMAI:request(prompt)
  return ""
end

-- 以下是和AI对接的各种Request包装
----------------------------------------------

local reqactive_handler_format = [[
  cards you can use: %s
  skills you can use: %s
]]

local reqactive_reply_format = [[
  JSON format, if you choose you hand cards, format is:
    {"card": <id of the card you want to use>, "targets": [ <id of choosed targets> ]}
  and if you want to use skill, the format is:
    {"card": { "skill": <name of the skill", "subcards": [ <id of choosed cards>]}, "targets": [ <id of choosed targets> ]}
]]

function LLMAI:handlePlayCard()
  local cards = self:getEnabledCards()
  local skills = self:getEnabledSkills()
  print(self:buildPrompt(reqactive_reply_format, reqactive_handler_format:format(json.encode(cards), json.encode(skills))))
  dbg()
end

return LLMAI
