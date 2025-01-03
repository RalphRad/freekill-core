-- 全是答辩的世界
-- sumneko佬，球球快支持泛型类罢，我什么都愿意做

---@alias RoundTrigFunc fun(self: TriggerSkill, event: RoundEvent,
---  target: ServerPlayer, player: ServerPlayer, data: RoundStruct): any
---@class RoundSkelSpec: TrigSkelSpec
---@field public on_trigger? RoundTrigFunc
---@field public can_trigger? RoundTrigFunc
---@field public on_cost? RoundTrigFunc
---@field public on_use? RoundTrigFunc
---@field public on_refresh? RoundTrigFunc
---@field public can_refresh? RoundTrigFunc
---@field public can_wake? RoundTrigFunc

---@alias TurnTrigFunc fun(self: TriggerSkill, event: TurnEvent,
---  target: ServerPlayer, player: ServerPlayer, data: TurnStruct): any
---@class TurnSkelSpec: TrigSkelSpec
---@field public on_trigger? TurnTrigFunc
---@field public can_trigger? TurnTrigFunc
---@field public on_cost? TurnTrigFunc
---@field public on_use? TurnTrigFunc
---@field public on_refresh? TurnTrigFunc
---@field public can_refresh? TurnTrigFunc
---@field public can_wake? TurnTrigFunc

---@alias PhaseTrigFunc fun(self: TriggerSkill, event: PhaseEvent,
---  target: ServerPlayer, player: ServerPlayer, data: PhaseStruct): any
---@class PhaseSkelSpec: TrigSkelSpec
---@field public on_trigger? PhaseTrigFunc
---@field public can_trigger? PhaseTrigFunc
---@field public on_cost? PhaseTrigFunc
---@field public on_use? PhaseTrigFunc
---@field public on_refresh? PhaseTrigFunc
---@field public can_refresh? PhaseTrigFunc
---@field public can_wake? PhaseTrigFunc

---@alias MoveCardsTrigFunc fun(self: TriggerSkill, event: MoveCardsEvent,
---  target: ServerPlayer, player: ServerPlayer, data: MoveCardsStruct): any
---@class MoveCardsSkelSpec: TrigSkelSpec
---@field public on_trigger? MoveCardsTrigFunc
---@field public can_trigger? MoveCardsTrigFunc
---@field public on_cost? MoveCardsTrigFunc
---@field public on_use? MoveCardsTrigFunc
---@field public on_refresh? MoveCardsTrigFunc
---@field public can_refresh? MoveCardsTrigFunc
---@field public can_wake? MoveCardsTrigFunc

---@alias UseCardTrigFunc fun(self: TriggerSkill, event: UseCardEvent,
---  target: ServerPlayer, player: ServerPlayer, data: UseCardStruct): any
---@class UseCardSkelSpec: TrigSkelSpec
---@field public on_trigger? UseCardTrigFunc
---@field public can_trigger? UseCardTrigFunc
---@field public on_cost? UseCardTrigFunc
---@field public on_use? UseCardTrigFunc
---@field public on_refresh? UseCardTrigFunc
---@field public can_refresh? UseCardTrigFunc
---@field public can_wake? UseCardTrigFunc

---@alias RespondCardTrigFunc fun(self: TriggerSkill, event: RespondCardEvent,
---  target: ServerPlayer, player: ServerPlayer, data: RespondCardStruct): any
---@class RespondCardSkelSpec: TrigSkelSpec
---@field public on_trigger? RespondCardTrigFunc
---@field public can_trigger? RespondCardTrigFunc
---@field public on_cost? RespondCardTrigFunc
---@field public on_use? RespondCardTrigFunc
---@field public on_refresh? RespondCardTrigFunc
---@field public can_refresh? RespondCardTrigFunc
---@field public can_wake? RespondCardTrigFunc

---@alias CardEffectTrigFunc fun(self: TriggerSkill, event: CardEffectEvent,
---  target: ServerPlayer, player: ServerPlayer, data: CardEffectStruct): any
---@class CardEffectSkelSpec: TrigSkelSpec
---@field public on_trigger? CardEffectTrigFunc
---@field public can_trigger? CardEffectTrigFunc
---@field public on_cost? CardEffectTrigFunc
---@field public on_use? CardEffectTrigFunc
---@field public on_refresh? CardEffectTrigFunc
---@field public can_refresh? CardEffectTrigFunc
---@field public can_wake? CardEffectTrigFunc

---@alias DamageTrigFunc fun(self: TriggerSkill, event: DamageEvent,
---  target: ServerPlayer, player: ServerPlayer, data: DamageStruct): any
---@class DamageSkelSpec: TrigSkelSpec
---@field public on_trigger? DamageTrigFunc
---@field public can_trigger? DamageTrigFunc
---@field public on_cost? DamageTrigFunc
---@field public on_use? DamageTrigFunc
---@field public on_refresh? DamageTrigFunc
---@field public can_refresh? DamageTrigFunc
---@field public can_wake? DamageTrigFunc

---@alias HpChangedTrigFunc fun(self: TriggerSkill, event: HpChangedEvent,
---  target: ServerPlayer, player: ServerPlayer, data: HpChangedData): any
---@class HpChangedSkelSpec: TrigSkelSpec
---@field public on_trigger? HpChangedTrigFunc
---@field public can_trigger? HpChangedTrigFunc
---@field public on_cost? HpChangedTrigFunc
---@field public on_use? HpChangedTrigFunc
---@field public on_refresh? HpChangedTrigFunc
---@field public can_refresh? HpChangedTrigFunc
---@field public can_wake? HpChangedTrigFunc

---@alias DyingTrigFunc fun(self: TriggerSkill, event: DyingEvent,
---  target: ServerPlayer, player: ServerPlayer, data: DyingData): any
---@class DyingSkelSpec: TrigSkelSpec
---@field public on_trigger? DyingTrigFunc
---@field public can_trigger? DyingTrigFunc
---@field public on_cost? DyingTrigFunc
---@field public on_use? DyingTrigFunc
---@field public on_refresh? DyingTrigFunc
---@field public can_refresh? DyingTrigFunc
---@field public can_wake? DyingTrigFunc

---@alias DeathTrigFunc fun(self: TriggerSkill, event: DeathEvent,
---  target: ServerPlayer, player: ServerPlayer, data: DeathData): any
---@class DeathSkelSpec: TrigSkelSpec
---@field public on_trigger? DeathTrigFunc
---@field public can_trigger? DeathTrigFunc
---@field public on_cost? DeathTrigFunc
---@field public on_use? DeathTrigFunc
---@field public on_refresh? DeathTrigFunc
---@field public can_refresh? DeathTrigFunc
---@field public can_wake? DeathTrigFunc

---@alias JudgeTrigFunc fun(self: TriggerSkill, event: JudgeEvent,
---  target: ServerPlayer, player: ServerPlayer, data: JudgeData): any
---@class JudgeSkelSpec: TrigSkelSpec
---@field public on_trigger? JudgeTrigFunc
---@field public can_trigger? JudgeTrigFunc
---@field public on_cost? JudgeTrigFunc
---@field public on_use? JudgeTrigFunc
---@field public on_refresh? JudgeTrigFunc
---@field public can_refresh? JudgeTrigFunc
---@field public can_wake? JudgeTrigFunc

---@alias PindianTrigFunc fun(self: TriggerSkill, event: PindianEvent,
---  target: ServerPlayer, player: ServerPlayer, data: PindianData): any
---@class PindianSkelSpec: TrigSkelSpec
---@field public on_trigger? PindianTrigFunc
---@field public can_trigger? PindianTrigFunc
---@field public on_cost? PindianTrigFunc
---@field public on_use? PindianTrigFunc
---@field public on_refresh? PindianTrigFunc
---@field public can_refresh? PindianTrigFunc
---@field public can_wake? PindianTrigFunc

---@alias SkillEffectTrigFunc fun(self: TriggerSkill, event: SkillEffectEvent,
---  target: ServerPlayer, player: ServerPlayer, data: SkillEffectData): any
---@class SkillEffectSkelSpec: TrigSkelSpec
---@field public on_trigger? SkillEffectTrigFunc
---@field public can_trigger? SkillEffectTrigFunc
---@field public on_cost? SkillEffectTrigFunc
---@field public on_use? SkillEffectTrigFunc
---@field public on_refresh? SkillEffectTrigFunc
---@field public can_refresh? SkillEffectTrigFunc
---@field public can_wake? SkillEffectTrigFunc

---@alias PropertyChangeTrigFunc fun(self: TriggerSkill, event: PropertyChangeEvent,
---  target: ServerPlayer, player: ServerPlayer, data: PropertyChangeData): any
---@class PropertyChangeSkelSpec: TrigSkelSpec
---@field public on_trigger? PropertyChangeTrigFunc
---@field public can_trigger? PropertyChangeTrigFunc
---@field public on_cost? PropertyChangeTrigFunc
---@field public on_use? PropertyChangeTrigFunc
---@field public on_refresh? PropertyChangeTrigFunc
---@field public can_refresh? PropertyChangeTrigFunc
---@field public can_wake? PropertyChangeTrigFunc
