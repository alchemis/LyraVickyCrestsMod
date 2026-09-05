PBStuff::POKEMONTOCREST[:TENTACRUEL] = :LVCTENTACREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCTENTACREST] = ItemData.new(:LVCTENTACREST, {
    name: "Tentacruel Crest",
    desc: "Tentacruel's binding moves steal one stage of the respective defense.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Move_0D0 < PokeBattle_Move
    alias_method :tentacrest_pbEffectTarget, :pbEffectTarget if !method_defined?(:tentacrest_pbEffectTarget)
    def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
      tentacrest_pbEffectTarget(attacker, opponent, hitnum, alltargets)
      return if opponent.isFainted? || opponent.damagestate.substitute
      stat = pbIsPhysical?(attacker) ? PBStats::DEFENSE : PBStats::SPDEF
      if attacker.crested == :TENTACRUEL && (attacker.pbCanIncreaseStatStage?(stat, attacker, self, showMessage: false) || opponent.pbCanReduceStatStage?(stat, attacker, self, showMessage: false))
          @battle.pbShowAbilityBox(attacker, item: true)
          opponent.pbChangeStats(stat, -1, attacker, self, abilitycheck: :skip)
          attacker.pbChangeStats(stat, 1, attacker, self, abilitycheck: :skip)
          @battle.pbHideAbilityBox(attacker)
      end
    end
end

class PokeBattle_Move_0CF < PokeBattle_Move
    alias_method :tentacrest_pbEffectTarget, :pbEffectTarget if !method_defined?(:tentacrest_pbEffectTarget)
    def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
      tentacrest_pbEffectTarget(attacker, opponent, hitnum, alltargets)
      return if opponent.isFainted? || opponent.damagestate.substitute
      stat = pbIsPhysical?(attacker) ? PBStats::DEFENSE : PBStats::SPDEF
      if attacker.crested == :TENTACRUEL && (attacker.pbCanIncreaseStatStage?(stat, attacker, self, showMessage: false) || opponent.pbCanReduceStatStage?(stat, attacker, self, showMessage: false))
          @battle.pbShowAbilityBox(attacker, item: true)
          opponent.pbChangeStats(stat, -1, attacker, self, abilitycheck: :skip)
          attacker.pbChangeStats(stat, 1, attacker, self, abilitycheck: :skip)
          @battle.pbHideAbilityBox(attacker)
      end
    end
end