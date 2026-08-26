PBStuff::POKEMONTOCREST[:TREVENANT] = :LVCTREVCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCTREVCREST] = ItemData.new(:LVCTREVCREST, {
    name: "Trevenant Crest",
    desc: "Trevenant ingrains and boosts its defenses on entry. Forest's Curse additionally curses the enemy.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Battle
    alias_method :trevcrest_pbCrestEntry, :pbCrestEntry if !defined?(trevcrest_pbCrestEntry)
    def pbCrestEntry(index, pokemon)
      trevcrest_pbCrestEntry(index, pokemon)
      battler = @battlers[index]
      case battler.crested
        when :TREVENANT
          pbShowAbilityBox(battler, item: true)
          battler.pbUseMoveSimple(:INGRAIN, -1, -1)
          if battler.pbCanIncreaseAnyStat?([PBStats::SPDEF, PBStats::DEFENSE], battler, nil, showMessage: false)
            pbDisplay(_INTL("{1} hardens its bark!", battler.pbThis))
            battler.pbChangeStats([PBStats::SPDEF, PBStats::DEFENSE], 1, battler, nil, abilitycheck: :skip)
          end
          pbHideAbilityBox(battler)
      end
    end
end

class PokeBattle_Move_143 < PokeBattle_Move
  alias_method :trevcrest_pbEffectValid, :pbEffectValid if !defined?(trevcrest_pbEffectValid)
  def pbEffectValid(attacker, opponent, showMessage = false)
    if attacker.crested == :TREVENANT
      if (!opponent.canChangeType? || opponent.hasType?(:GRASS)) && opponent.effects[:Curse]
        @battle.pbDisplay(_INTL("But it failed!")) if showMessage
        return false
      end
      return true
    else return trevcrest_pbEffectValid(attacker, opponent, showMessage)
    end
  end

  alias_method :trevcrest_pbEffectTarget, :pbEffectTarget if !defined?(trevcrest_pbEffectTarget)
  def pbEffectTarget(attacker, opponent, hitnum = 0, alltargets = nil)
    if attacker.crested == :TREVENANT
      trevcrest_pbEffectTarget(attacker,opponent,hitnum,alltargets) unless !opponent.canChangeType? || opponent.hasType?(:GRASS)
      if !opponent.effects[:Curse]
        opponent.effects[:Curse] = true
        @battle.pbDisplay(_INTL("{1} put a curse on {2}!", attacker.pbThis, opponent.pbThis(true)))
      end
    else return trevcrest_pbEffectTarget(attacker,opponent,hitnum,alltargets)
    end
  end
end