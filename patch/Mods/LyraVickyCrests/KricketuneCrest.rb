PBStuff::POKEMONTOCREST[:KRICKETUNE] = :LVCKRICKCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCKRICKCREST] = ItemData.new(:LVCKRICKCREST, {
    name: "Kricketune Crest",
    desc: "Kricketune always moves immediately after its partner and its moves gain a stronger Metronome effect.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}


class PokeBattle_Battler
  alias_method :krickcrest_applyPostMoveEffects, :applyPostMoveEffects if !method_defined?(:krickcrest_applyPostMoveEffects)
  
  def applyPostMoveEffects(basemove, user, targets, hitflag)
    ret = krickcrest_applyPostMoveEffects(basemove, user, targets, hitflag)
    self.effects[:lvc_krickcrest_prio] = false if self.crested == :KRICKETUNE && self.effects[:lvc_krickcrest_prio]
    if [:Success, :StatusSuccess].intersect?(hitflag) && !@applyingEntryEffects
      priority = @battle.setSpeedOrder
      for i in priority
          if i.crested == :KRICKETUNE && !self.pbIsOpposing?(i.index)
            if basemove.priority >= 4  then
              i.effects[:lvc_krickcrest_prio] = true
              @battle.setMovePrioData
            else
              @battle.pbMoveAfter(i)
            end
          end
      end
    end
    return ret
  end

end

class PokeBattle_Battle
  alias_method :krickcrest_pbEndOfRoundPhase, :pbEndOfRoundPhase if !method_defined?(:krickcrest_pbEndOfRoundPhase)
  def pbEndOfRoundPhase(skipcelebi = false)
      priority = setSpeedOrder
      for battler in priority
        battler.effects[:lvc_krickcrest_prio] = false if battler.effects[:lvc_krickcrest_prio]
      end
      krickcrest_pbEndOfRoundPhase(skipcelebi)
  end
end

class PokeBattle_Move
      alias_method :krickcrest_priorityCheck, :priorityCheck if !method_defined?(:krickcrest_priorityCheck)
      def priorityCheck(attacker)
          return krickcrest_priorityCheck(attacker) if !attacker.crested == :KRICKETUNE || !attacker.effects[:lvc_krickcrest_prio]
          return 3
      end
end

class PBMults
  Krickcrest      = [
    1.0,
    1.4,
    1.8,
    2.2,
    2.6,
    3,
  ]
end

#double metronome effect
CodeInjector.insert_in_method(:PokeBattle_Move,:pbCalcDamage, "finalmult.append(PBMults::Metronome[[attacker.effects[:Metronome], 5].min]) if attitemworks && attacker.item == :METRONOME && @move == attacker.lastMoveUsed",
 "finalmult.append(PBMults::Krickcrest[[attacker.effects[:Metronome], 5].min]) if attacker.crested == :KRICKETUNE && @move == attacker.lastMoveUsed"
)