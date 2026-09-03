PBStuff::POKEMONTOCREST[:NOIVERN] = :LVCNOIVCREST


ModCacheInjection.hook(:items) {
  $cache.items[:LVCNOIVCREST] = ItemData.new(:LVCNOIVCREST, {
    name: "Noivern Crest",
    desc: "Noivern's Sp. Atk and Accuracy are raised when Sound moves are used. Powers up its own Sound moves and takes less damage from them.",
    price: 0,
    crest: true,
    noUseInBattle: true,
    noUse: true,
  })
}

class PokeBattle_Move
    alias_method :noivcrest_pbCalcDamage, :pbCalcDamage if !method_defined?(:noivcrest_pbCalcDamage)
    def pbCalcDamage(attacker, opponent, hitnum = 0, feedbackMessages = { opponent.index => [] }, movetype: nil)
          if movetype then
            damage = noivcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages, movetype: movetype) #attacker, opponent, hitnum, feedbackMessages, movetype
          else damage = noivcrest_pbCalcDamage(attacker, opponent, hitnum, feedbackMessages)
          end
          if attacker.crested == :NOIVERN && $cache.moves[@move]&.checkFlag?(:soundmove)
            damage *= 1.3
          end

          if opponent.crested == :NOIVERN && $cache.moves[@move]&.checkFlag?(:soundmove)
            damage *= 0.5
          end

          return damage.floor
    end

end

#ECHO
class PokeBattle_Battler
  alias_method :noivcrest_applyPostMoveEffects, :applyPostMoveEffects if !method_defined?(:noivcrest_applyPostMoveEffects)
  
  def applyPostMoveEffects(basemove, user, targets, hitflag)
    ret = noivcrest_applyPostMoveEffects(basemove, user, targets, hitflag)
    if [:Success, :StatusSuccess].intersect?(hitflag)
      id = basemove.move
      priority = @battle.setSpeedOrder
      for i in priority
        if i.crested == :NOIVERN && $cache.moves[id]&.checkFlag?(:soundmove)
          if i.pbCanIncreaseAnyStat?([PBStats::ATTACK, PBStats::ACCURACY], i, nil, showMessage: false)
            @battle.pbShowAbilityBox(i, item: true)
            @battle.pbDisplay(_INTL("{1} is getting amped!", i.pbThis))
            i.pbChangeStats([PBStats::SPATK, PBStats::ACCURACY], 1, i, nil, abilitycheck: :skip)
            @battle.pbHideAbilityBox(i)
          end
        end
      end
    end
    return ret
  end

end

